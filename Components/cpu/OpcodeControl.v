`ifndef __OpcodeControl__
`define __OpcodeControl__

`include "./Components/cpu/OpcodeEnum.v"

// ALU control + main controls
module OpcodeControl(
    opcode,
    regDst,
    jump,
    branch,
    branch_ne,
    memRead,
    memtoReg,
    aluOp,
    memWrite,
    aluSrc,
    regWrite
);
    input wire [5:0] opcode;
    output wire regDst;
    output wire jump;
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

    reg isR;
    reg isJ;
    // reg isJal;
    reg isBeq;
    reg isBne;
    reg isLw;
    reg isSw;

    always @(*) begin
        case (opcode)
            `RType: isR <= 1;
            `J: isJ <= 1;
            // `JAL: isJal <= 1;
            `BEQ: isBeq <= 1;
            `BNE: isBne <= 1;

            `LW: isLw <= 1;
            `SW: isSw <= 1;
        endcase
    end


    assign regDst = isR;
    // assign jump = isJ || isJal;
    assign jump = isJ;
    assign branch = isBeq;
    assign branch_ne = isBne;
    assign memRead = isLw;
    // load memory to register
    assign memtoReg = isLw;

    // aluOp
    always @(*) begin
        case (opcode)
            // from funct field
            `RType: aluOp <= `AluOpType_Funct;
            // sub
            `BEQ: aluOp <= `AluOpType_Sub;
            // add
            `LW: aluOp <= `AluOpType_Add;
            `SW: aluOp <= `AluOpType_Add;
            // default: 
        endcase
    end

    assign memWrite = isSw;
    assign aluSrc = isLw || isSw;
    // assign regWrite = ~(isSw || isBeq || isBne || isJ || isJr);
    assign regWrite = isLw || isR;

endmodule // OpcodeControl

`endif
