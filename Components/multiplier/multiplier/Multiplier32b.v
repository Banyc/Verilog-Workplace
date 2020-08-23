`ifndef __Multiplier32b
`define __Multiplier32b

// signed 2's complement

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/shift/ShiftRight64.v"
`include "./Components/register/Register32b.v"
`include "./Components/mux/Mux2to1_64b.v"
`include "./Components/multiplier/multiplier/Multiplier32bControl.v"

module Multiplier32b (
    clk,
    a,
    b,
    p,
    rst,  // positive to start
    finish
);
    input wire clk;
    input wire [31:0] a;
    input wire [31:0] b;
    input wire rst;
    output wire finish;
    output wire [63:0] p;

    // control wires
    wire productionShiftRight;
    wire productionWrite;
    wire productionIsInitMux;
    wire multiplicandIsInitWrite;

    wire [31:0] multiplicand;
    wire [31:0] sum;
    wire [63:0] productionSource;

    Register32b multiplicandRegister (
        .clk(clk),
        .enableWrite(multiplicandIsInitWrite),
        .d(a),
        .q(multiplicand)
    );

    AddSub32bFlag alu32b(
        .A(p[63:32]),
        .B(multiplicand),
        .Ci(1'b0),
        .Ctrl(1'b0),
        .S(sum),
        .CF(), .OF(), .ZF(), .SF(), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );

    Mux2to1_64b productionSourceMux (
        productionIsInitMux,
        {sum, p[31:0]},
        {32'b0, b},
        productionSource
    );

    ShiftRight64 production (
        .clk(clk),
        .isShiftRight(productionShiftRight),
        .isWrite(productionWrite),
        .d(productionSource),
        .q(p)
    );

    Multiplier32bControl control (
        .clk(clk),
        .rst(rst),
        .productionRightmostBit(p[0]),
        .productionShiftRight(productionShiftRight),
        .productionWrite(productionWrite),
        .productionIsInitMux(productionIsInitMux),
        .multiplicandIsInitWrite(multiplicandIsInitWrite),
        .isHalt(finish)
    );

endmodule
`endif
