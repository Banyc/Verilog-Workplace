`ifndef __Multiplier32bu
`define __Multiplier32bu

// unsigned

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/shift/Shift65b.v"
`include "./Components/register/Register32b.v"
`include "./Components/mux/Mux2to1_65b.v"
`include "./Components/multiplier/multiplier/Multiplier32bControl.v"

module Multiplier32bu (
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
    wire muxIsInitProduction;
    wire multiplicandIsInitWrite;

    wire [31:0] multiplicand;
    wire [31:0] sum;
    wire carry;
    wire [64:0] productionSource;
    reg [2:0] productionOperation;
    wire carryBitOfProduction;

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
        .CF(carry), .OF(), .ZF(), .SF(), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );

    Mux2to1_65b productionSourceMux (
        muxIsInitProduction,
        {carry, sum, p[31:0]},
        {33'b0, b},
        productionSource
    );

    always @(*) begin
        if (productionWrite) begin
            productionOperation = `Shift65b_Operation_WriteD;
        end else if (productionShiftRight) begin
            productionOperation = `Shift65b_Operation_ShiftRightLogical;
        end else begin
            productionOperation = `Shift65b_Operation_DoNothing;
        end
    end

    Shift65b production (
        .clk(clk),
        .operation(productionOperation),
        .d(productionSource),
        .q({carryBitOfProduction, p})
    );

    Multiplier32bControl control (
        .clk(clk),
        .rst(rst),
        .productionRightmostBit(p[0]),
        .productionShiftRight(productionShiftRight),
        .productionWrite(productionWrite),
        .muxIsInitProduction(muxIsInitProduction),
        .multiplicandIsInitWrite(multiplicandIsInitWrite),
        .isHalt(finish)
    );

endmodule
`endif
