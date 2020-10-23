`ifndef __Alu32b_extended__
`define __Alu32b_extended__

`include "Components/adder/Alu32b_simple.v"
`include "Components/adder/Alu32b_extended_enumAluOp.vh"

module Alu32b_extended (
    aluOp,
    leftOperand,
    rightOperand,  // or shamt
    aluResult
);

    input wire [3:0] aluOp;
    input wire [31:0] leftOperand;
    input wire [31:0] rightOperand;
    output reg [31:0] aluResult;

    wire [31:0] aluSimpleResult;
    wire [31:0] shiftRightLogically;

    assign shiftRightLogically = leftOperand >> rightOperand;

    Alu32b_simple alu32b_simple_inst(
        .aluOp(aluOp),
        .leftOperand(leftOperand),
        .rightOperand(rightOperand),
        .aluResult(aluSimpleResult)
    );

    always @(*) begin
        case (aluOp)
            `Alu32b_extended_aluOp_sll: begin
                aluResult = leftOperand << rightOperand;
            end
            `Alu32b_extended_aluOp_srl: begin
                aluResult = shiftRightLogically;
            end
            `Alu32b_extended_aluOp_sra: begin
                aluResult = {shiftRightLogically[30], shiftRightLogically[30:0]};
            end
            `Alu32b_extended_aluOp_xor: begin
                aluResult = leftOperand ^ rightOperand;
            end
            default: begin
                aluResult = aluSimpleResult;
            end
        endcase
    end

endmodule

`endif
