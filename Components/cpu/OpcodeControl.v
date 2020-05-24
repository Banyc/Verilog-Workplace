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
    reg isBeq;
    reg isBne;
    reg isAddi;
    reg isLw;
    reg isSw;
    reg isSll;
    reg isLui;

    always @(*) begin
        isR = 0;
        isJ = 0;
        isJal = 0;
        isJr = 0;
        isBeq = 0;
        isBne = 0;
        isAddi = 0;
        isLw = 0;
        isSw = 0;
        isSll = 0;
        isLui = 0;
        case (opcode)
            `RType: isR = 1;
            `J: isJ = 1;
            `JAL: isJal = 1;
            `BEQ: isBeq = 1;
            `BNE: isBne = 1;
            `ADDI: isAddi = 1;

            `LW: isLw = 1;
            `SW: isSw = 1;
            `LUI: isLui = 1;
        endcase
        case (funct)
            `JR: isJr = isR & 1;
            `SLL: isSll = 1;
        endcase
    end

    assign regDst = isR;
    assign jump = isJ || isJal;
    assign jumpAndLink = isJal;
    assign jumpRegister = isJr;
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
            // add
            `LW: aluOp = `AluOpType_Add;
            `SW: aluOp = `AluOpType_Add;
            `ADDI: aluOp = `AluOpType_Add;
            // default: 
        endcase
    end

    assign memWrite = isSw;
    assign aluSrc = isLw || isSw || isAddi;
    assign regWrite = ~(isSw || isBeq || isBne || isJ || isJr);
    assign shiftLeftLogical = isSll;
    assign loadUpperImmediate = isLui;

endmodule // OpcodeControl

`endif
