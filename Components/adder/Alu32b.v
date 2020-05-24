`ifndef __Alu32b__
`define __Alu32b__

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/adder/Or32b.v"
`include "./Components/adder/Xor32b.v"
`include "./Components/adder/Nor32b.v"
`include "./Components/adder/And32b.v"
`include "./Components/shift/ShiftLeftN.v"
`include "./Components/cpu/OpcodeEnum.v"

module Alu32b(
    aluOp,
    leftOperand,
    rightOperand,
    aluResult,
    zero
);
    input wire [3:0] aluOp;
    input wire [31:0] leftOperand;
    input wire [31:0] rightOperand;
    output reg [31:0] aluResult;
    output wire zero;

    // add / sub
    wire [31:0] addSubResult;
    wire addSubZero;
    wire addSubSign;

    AddSub32bFlag addSub(
        .A(leftOperand),
        .B(rightOperand),
        .Ci(1'b0),
        .Ctrl(aluOp[2]),
        .S(addSubResult),
        .CF(), .OF(), .ZF(addSubZero), .SF(addSubSign), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );

    // and / or
    wire [31:0] andResult;
    wire [31:0] orResult;
    wire [31:0] xorResult;
    wire [31:0] norResult;
    wire [31:0] shiftLeftResult;

    And32b ander(leftOperand, rightOperand, andResult);
    Or32b orer(leftOperand, rightOperand, orResult);

    ShiftLeftN shiftLeft(
        .from(rightOperand),
        .shamt(leftOperand[4:0]),
        .to(shiftLeftResult)
    );

    Xor32b xorer(leftOperand, rightOperand, xorResult);
    Nor32b norer(leftOperand, rightOperand, norResult);

    // output
    always @(*) begin
        case (aluOp)
            `ALU_add: aluResult <= addSubResult;
            `ALU_sub: aluResult <= addSubResult;
            `ALU_and: aluResult <= andResult;
            `ALU_or: aluResult <= orResult;
            `ALU_nor: aluResult <= norResult;
            `ALU_slt: begin
                if (addSubSign) begin
                    aluResult <= 1;
                end else begin
                    aluResult <= 0;
                end
            end
            `ALU_sll: aluResult <= shiftLeftResult;
            `ALU_xor: aluResult <= xorResult;
            // default: 
        endcase
    end
    assign zero = &(~aluResult);

endmodule // Alu32b

`endif
