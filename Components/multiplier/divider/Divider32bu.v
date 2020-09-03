`ifndef __Divider32bu
`define __Divider32bu

// unsigned
// restoring algorithm

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/register/ShiftReg65b.v"
`include "./Components/register/Register32b.v"
`include "./Components/mux/Mux4to1_65b.v"
`include "./Components/multiplier/divider/Divider32bControl.v"

module Divider32bu (
    clk,
    a,  // dividend
    b,  // divisor
    quo,  // quotient
    rem,  // remainder
    rst,  // positive to start
    finish
);
    input wire clk;
    input wire [31:0] a;
    input wire [31:0] b;
    input wire rst;
    output wire finish;
    output wire [32:0] quo;
    output wire [31:0] rem;

    // control wires
    wire aluIsSubtract;
    wire remainderShiftLeft;
    wire remainderWrite;
    wire quotientRightmostBit;
    wire [1:0] muxRemainderSourceSelector;
    wire divisorIsInitWrite;

    wire [31:0] divisor;
    wire [31:0] aluResult;
    wire carry;
    wire [64:0] remainderSource;
    reg [2:0] remainderOperation;
    wire carryBitOfProduction;

    Register32b divisorRegister (
        .clk(clk),
        .enableWrite(divisorIsInitWrite),
        .d(b),
        .q(divisor)
    );

    AddSub32bFlag alu32b(
        .A({rem[30:0], quo[32]}),
        .B(divisor),
        .Ci(1'b0),
        .Ctrl(aluIsSubtract),
        .S(aluResult),
        .CF(carry), .OF(), .ZF(), .SF(), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );

    Mux4to1_65b remainderSourceMux (
        muxRemainderSourceSelector,
        {33'b0, a},
        {!carry, aluResult, quo[31:0]},
        {rem, quo[32:1], quotientRightmostBit},
        65'b0,
        remainderSource
    );

    always @(*) begin
        if (remainderWrite) begin
            remainderOperation = `ShiftReg65b_Operation_WriteD;
        end else if (remainderShiftLeft) begin
            remainderOperation = `ShiftReg65b_Operation_ShiftLeftLogical;
        end else begin
            remainderOperation = `ShiftReg65b_Operation_DoNothing;
        end
    end

    ShiftReg65b remainderRegister (
        .clk(clk),
        .operation(remainderOperation),
        .shiftIn(1'b0),
        .d(remainderSource),
        .q({rem, quo})
    );

    Divider32bControl control (
        .clk(clk),
        .rst(rst),
        .remainderLeftmostBit(rem[31]),
        .aluIsSubtract(aluIsSubtract),
        .remainderShiftLeft(remainderShiftLeft),
        .remainderWrite(remainderWrite),
        .quotientRightmostBit(quotientRightmostBit),
        .muxRemainderSourceSelector(muxRemainderSourceSelector),
        .divisorIsInitWrite(divisorIsInitWrite),
        .isHalt(finish)
    );

endmodule
`endif
