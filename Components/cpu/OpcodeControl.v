`ifndef __OpcodeControl__
`define __OpcodeControl__

`include "./Components/cpu/OpcodeEnum.v"

// ALU control + main controls
module OpcodeControl(
    opcode,
    funct,
    regDst,
    jump,
    jumpAndLink,
    jumpRegister,
    branch,
    branch_ne,
    memRead,
    memtoReg,
    aluOp,
    memWrite,
    aluSrc,
    regWrite,
    shiftLeftLogical,
    loadUpperImmediate
);
    input wire [5:0] opcode;
    input wire [5:0] funct;
    output wire regDst;
    output wire jump;
    output wire jumpAndLink;
    output wire jumpRegister;
    output wire branch;
    output wire branch_ne;
    output wire memRead;
    output wire memtoReg;
    // alu operation type
    // ALU operation type | Input
    // -----
    // Add for L/S | 00
    // Sub for beq | 01
    // From funct field | 10
    output reg [1:0] aluOp;
    output wire memWrite;
    output wire aluSrc;
    output wire regWrite;
    output wire shiftLeftLogical;
    output wire loadUpperImmediate;

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

    always @(*) begin
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
    end

    assign regDst = isR;
    // jump to target, not to register
    assign jump = isJ || isJal;
    // save PC + 4 to register $ra
    assign jumpAndLink = isJal || isJalr;
    // jump to register
    assign jumpRegister = isJr || isJalr;
    assign branch = isBeq;
    assign branch_ne = isBne;
    assign memRead = isLw;
    // load memory to register
    assign memtoReg = isLw;

    // aluOp
    always @(*) begin
        case (opcode)
            // from funct field
            `RType: aluOp = `AluOpType_Funct;
            // sub
            `BEQ: aluOp = `AluOpType_Sub;
            `BNE: aluOp = `AluOpType_Sub;
            // add
            `LW: aluOp = `AluOpType_Add;
            `SW: aluOp = `AluOpType_Add;
            `ADDI: aluOp = `AluOpType_Add;
            `ANDI: aluOp = `AluOpType_Immediate;
            `ORI: aluOp = `AluOpType_Immediate;
            `XORI: aluOp = `AluOpType_Immediate;
            // default: 
        endcase
    end

    assign memWrite = isSw;
    // select immediate as source B of ALU
    assign aluSrc = isLw || isSw || isAddi || isAndi || isOri || isXori || isSlti;
    assign regWrite = ~(isSw || isBeq || isBne || isJ || isJr);
    assign shiftLeftLogical = isSll || isSrl;
    assign loadUpperImmediate = isLui;

endmodule // OpcodeControl

`endif
