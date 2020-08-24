`ifndef __Multiplier32b
`define __Multiplier32b

// signed 2's complement

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/shift/Shift65b.v"
`include "./Components/register/Register32b.v"
`include "./Components/mux/Mux2to1_65b.v"
`include "./Components/multiplier/multiplier/Multiplier32bu.v"

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
    wire [63:0] pFromMultiplier;

    wire [31:0] aUnsigned;
    wire [31:0] bUnsigned;

    assign aUnsigned = a[31] == 0 ? a : ~a + 1;
    assign bUnsigned = b[31] == 0 ? b : ~b + 1;

    assign p = !(a[31] ^ b[31]) ? pFromMultiplier : ~pFromMultiplier + 1;

    Multiplier32bu multiplier32bu (
        clk,
        aUnsigned,
        bUnsigned,
        pFromMultiplier,
        rst,
        finish
    );

endmodule
`endif
