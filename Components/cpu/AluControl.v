`ifndef __AluControl__
`define __AluControl__

`include "./Components/cpu/OpcodeEnum.v"

module AluControl(
    opcode,
    funct,
    aluOp,
    aluOpOut
);
    input wire [5:0] opcode;
    input wire [5:0] funct;
    input wire [1:0] aluOp;
    output reg [3:0] aluOpOut;

    always @(*) begin
        case (aluOp)
            // `AluOpType_Add: aluOpOut <= `ALU_add;
            2'b00: aluOpOut <= `ALU_add;
            // `AluOpType_Sub: aluOpOut <= `ALU_sub;
            2'b01: aluOpOut <= `ALU_sub;
            // `AluOpType_Funct: begin
            2'b10: begin
                case (funct)
                    `SLL: aluOpOut <= `ALU_sll;
                    `SRL: aluOpOut <= `ALU_srl;
                    `ADD: aluOpOut <= `ALU_add;
                    `SUB: aluOpOut <= `ALU_sub;
                    `AND: aluOpOut <= `ALU_and;
                    `OR: aluOpOut <= `ALU_or;
                    `XOR: aluOpOut <= `ALU_xor;
                    `SLT: aluOpOut <= `ALU_slt;
                    // default: 
                endcase
            end
            2'b11: begin
                case (opcode)
                    `ANDI: aluOpOut <= `ALU_and;
                    `ORI: aluOpOut <= `ALU_or;
                    `XORI: aluOpOut <= `ALU_xor;
                endcase
            end
            // default: 
        endcase
    end
endmodule // AluControl

`endif
