`ifndef __OpcodeControl__
`define __OpcodeControl__

`include "./Components/cpu/OpcodeEnum.v"

// ALU control + main controls
module OpcodeControl(
    opcode,
    regDst,
    jump,
    branch,
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

    // 6'b000000
    wire isR = &(~opcode);
    // 6'b100011
    wire isLw =  opcode[5]&~opcode[4]&~opcode[3]&~opcode[2]& opcode[1]& opcode[0];
    // 6'b101011
    wire isSw =  opcode[5]&~opcode[4]& opcode[3]&~opcode[2]& opcode[1]& opcode[0];
    // 6'b000100
    wire isBeq = ~opcode[5]&~opcode[4]&~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];
    // 6'b000010
    wire isJ = ~opcode[5]&~opcode[4]&~opcode[3]&~opcode[2]& opcode[1]&~opcode[0];


    assign regDst = isR;
    assign jump = isJ;
    assign branch = isBeq;
    assign memRead = isLw;
    // load memory to register
    assign memtoReg = isLw;

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
    assign regWrite = isLw || isR;

endmodule // OpcodeControl

`endif
