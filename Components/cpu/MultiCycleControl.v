`ifndef __MultiCycleControl__
`define __MultiCycleControl__

`include "./Components/cpu/OpcodeEnum.v"

`define RESET 4'b1111
// instruction fetch
`define IR 4'h0
// instruction decode + register fetch
`define ID_RF 4'h1
// memory address computation
`define MemoryAccessComputation 4'h2
// memory access (read)
`define MemoryAccessRead 4'h3
// write-back step
`define WriteBackStep 4'h4
// memory access (write)
`define MemoryAccessWrite 4'h5
`define Execution 4'h6
`define RTypeCompletion 4'h7
`define BranchCompletion 4'h8
`define JumpCompletion 4'h9

// bne
`define BneCompletion 4'hA
// I-type execute
// `define AddiExecute 4'hB
`define ITypeExecute 4'hB
// I-type writeback
`define ITypeWriteBack 4'hC


module MultiCycleControl(
    clk,
    rst,
    opcode,
    funct,

    pcWriteCond,
    pcWrite,
    iorD,
    memRead,
    memWrite,
    memToReg,
    irWrite,
    pcSource,
    aluOp,
    aluSrcB,
    aluSrcA,
    regWrite,
    regDst
);
    input wire clk;
    input wire rst;
    input wire [5:0] opcode;
    input wire [5:0] funct;

    // 00: disable
    // 01: beq
    // 10: bne
    output reg [1:0] pcWriteCond;
    output reg pcWrite;
    output reg iorD;
    output reg memRead;
    output reg memWrite;
    output reg memToReg;
    output reg irWrite;
    output reg [1:0] pcSource;
    output reg [1:0] aluOp;
    output reg [1:0] aluSrcB;
    output reg aluSrcA;
    output reg regWrite;
    output reg regDst;

    reg [3:0] state;
    reg [3:0] nextState;

    reg isR;
    reg isJ;
    reg isJal;
    reg isJr;
    reg isJalr;
    reg isBeq;
    reg isBne;
    reg isAddi;
    reg isAndi;
    reg isOri;
    reg isXori;
    reg isSlti;
    reg isLw;
    reg isSw;
    reg isSll;
    reg isSrl;
    reg isLui;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state = `RESET;
        else
            state = nextState;
    end

    always @(state or opcode or funct) begin
        isR = 0;
        isJ = 0;
        isJal = 0;
        isJr = 0;
        isJalr = 0;
        isBeq = 0;
        isBne = 0;
        isAddi = 0;
        isAndi = 0;
        isOri = 0;
        isXori = 0;
        isSlti = 0;
        isLw = 0;
        isSw = 0;
        isSll = 0;
        isSrl = 0;
        isLui = 0;
        case (opcode)
            `RType: isR = 1;
            `J: isJ = 1;
            `JAL: isJal = 1;
            `BEQ: isBeq = 1;
            `BNE: isBne = 1;
            `ADDI: isAddi = 1;
            `ANDI: isAndi = 1;
            `ORI: isOri = 1;
            `XORI: isXori = 1;
            `SLTI: isSlti = 1;

            `LW: isLw = 1;
            `SW: isSw = 1;
            `LUI: isLui = 1;
        endcase
        case (funct)
            `JR: isJr = isR & 1;
            `JALR: isJalr = isR & 1;
            `SLL: isSll = 1;
            `SRL: isSrl = 1;
        endcase
        // init
        pcWriteCond = 0;
        pcWrite = 0;
        iorD = 0;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        irWrite = 0;
        pcSource = 0;
        aluOp = 0;
        aluSrcB = 0;
        aluSrcA = 0;
        regWrite = 0;
        regDst = 0;

        case (state)
            `RESET: begin
                pcWriteCond = 0;
                pcWrite = 0;
                iorD = 0;
                memRead = 0;
                memWrite = 0;
                memToReg = 0;
                irWrite = 0;
                pcSource = 0;
                aluOp = 0;
                aluSrcB = 0;
                aluSrcA = 0;
                regWrite = 0;
                regDst = 0;

                nextState = `IR;
            end
            `IR: begin
                // instructionReg = mem[PC]
                // PC += 4
                memRead = 1;
                aluSrcA = 0;
                iorD = 0;
                irWrite = 1;
                aluSrcB = 2'b01;
                aluOp = 2'b00;
                pcWrite = 1;
                pcSource = 2'b00;
                
                nextState = `ID_RF;
            end
            `ID_RF: begin
                // A = $source
                // B = $target
                // ALUOut = PC + immediate << 2
                aluSrcA = 0;
                aluSrcB = 2'b11;
                aluOp = 2'b00;
                
                // next state
                if (isLw || isSw)
                    nextState = `MemoryAccessComputation;
                else if (isR)
                    nextState = `Execution;
                else if (isBeq)
                    nextState = `BranchCompletion;
                else if (isBne)
                    nextState = `BneCompletion;
                else if (isJ)
                    nextState = `JumpCompletion;
                else if (isAddi || isAndi || isOri || isSlti)
                    nextState = `ITypeExecute;
                else
                    // throw interrupt
                    nextState = `RESET;
            end
            `MemoryAccessComputation: begin
                // ALUOut = A + immediate
                aluSrcA = 1;
                aluSrcB = 2'b10;
                aluOp = 2'b00;

                // next state
                if (isLw)
                    nextState = `MemoryAccessRead;
                else if (isSw)
                    nextState = `MemoryAccessWrite;
                else
                    // throw interrupt
                    nextState = `RESET;
            end
            `MemoryAccessRead: begin
                // memDataReg = mem[ALUOut]
                memRead = 1;
                iorD = 1;
                
                nextState = `WriteBackStep;
            end
            `WriteBackStep: begin
                // regs[%target] = memDataReg
                regWrite = 1;
                memToReg = 1;
                regDst = 0;
                
                nextState = `IR;
            end
            `MemoryAccessWrite: begin
                // mem[ALUOut] = B
                memWrite = 1;
                iorD = 1;
                
                nextState = `IR;
            end
            `Execution: begin
                // ALUOut = A <operator> B
                aluSrcA = 1;
                aluSrcB = 2'b00;
                aluOp = 2'b10;
                
                nextState = `RTypeCompletion;
            end
            `RTypeCompletion: begin
                // regs[$destination] = ALUOut
                regDst = 1;
                regWrite = 1;
                memToReg = 0;
                
                nextState = `IR;
            end
            `BranchCompletion: begin
                // ALUOut = A - B
                // PC = ALUOut if isZero
                aluSrcA = 1;
                aluSrcB = 2'b00;
                aluOp = 2'b01;
                pcWriteCond = 1;
                pcSource = 2'b01;
                
                nextState = `IR;
            end
            `BneCompletion: begin
                // ALUOut = A - B
                // PC = ALUOut if not isZero
                aluSrcA = 1;
                aluSrcB = 2'b00;
                aluOp = 2'b01;
                pcWriteCond = 2;
                pcSource = 2'b01;
                
                nextState = `IR;
            end
            `JumpCompletion: begin
                // PC = PC <concat> target << 2
                pcWrite = 1;
                pcSource = 2'b10;
                
                nextState = `IR;
            end
            `ITypeExecute: begin
                // ALUOut = A <operator> immediate
                aluOp = `AluOpType_Immediate;
                aluSrcA = 1;
                aluSrcB = 2;
                
                nextState = `ITypeWriteBack;
            end
            `ITypeWriteBack: begin
                // regs[$target] = ALUOut
                regDst = 0;
                memToReg = 0;
                regWrite = 1;
                
                nextState = `IR;
            end

            // throw interrupt
            default: nextState = `RESET;
        endcase
    end

endmodule // MultiCycleControl

`endif
