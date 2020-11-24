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
            `AluOpType_Add: aluOpOut <= `ALU_add;
            `AluOpType_Sub: aluOpOut <= `ALU_sub;
            `AluOpType_Funct: begin
                case (funct)
                    `SLL: aluOpOut <= `ALU_sll;
                    `SRL: aluOpOut <= `ALU_srl;
                    `ADD: aluOpOut <= `ALU_add;
                    `SUB: aluOpOut <= `ALU_sub;
                    `AND: aluOpOut <= `ALU_and;
                    `OR: aluOpOut <= `ALU_or;
                    `NOR: aluOpOut <= `ALU_nor;
                    `XOR: aluOpOut <= `ALU_xor;
                    `SLT: aluOpOut <= `ALU_slt;
                    default: begin
                        // exception
                    end
                endcase
            end
            `AluOpType_Immediate: begin
                case (opcode)
                    `ANDI: aluOpOut <= `ALU_and;
                    `ORI: aluOpOut <= `ALU_or;
                    `XORI: aluOpOut <= `ALU_xor;
                    `SLTI: aluOpOut <= `ALU_slt;
                    `LUI: aluOpOut <= `ALU_sll16;
                    default: begin
                        // exception
                    end
                endcase
            end
            default: begin
                // exception
            end
        endcase
    end
endmodule // AluControl

`endif
