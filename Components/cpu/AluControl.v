`ifndef __AluControl__
`define __AluControl__

`include "./Components/cpu/OpcodeEnum.v"

module AluControl(
    funct,
    aluOp,
    aluOpOut
);
    input wire [5:0] funct;
    input wire [1:0] aluOp;
    output reg [2:0] aluOpOut;

    always @(*) begin
        casez (aluOp)
            // `AluOpType_Add: aluOpOut <= `ALU_add;
            2'b00: aluOpOut <= `ALU_add;
            // `AluOpType_Sub: aluOpOut <= `ALU_sub;
            2'b?1: aluOpOut <= `ALU_sub;
            // `AluOpType_Funct: begin
            2'b1?: begin
                casez (funct)
                    6'b??0000: aluOpOut <= `ALU_add;
                    6'b??0010: aluOpOut <= `ALU_sub;
                    6'b??0100: aluOpOut <= `ALU_and;
                    6'b??0101: aluOpOut <= `ALU_or;
                    6'b??1010: aluOpOut <= `ALU_slt;
                    // default: 
                endcase
            end
            // default: 
        endcase
    end
endmodule // AluControl

`endif
