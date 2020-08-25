`ifndef __Divider32b
`define __Divider32b

// signed 2's complement

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/shift/Shift65b.v"
`include "./Components/register/Register32b.v"
`include "./Components/mux/Mux2to1_65b.v"
`include "./Components/multiplier/divider/Divider32bu.v"

module Divider32b (
    clk,
    a,
    b,
    quo,
    rem,
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
    wire [32:0] quoFromDivider;
    wire [31:0] remFromDivider;

    wire [31:0] aUnsigned;
    wire [31:0] bUnsigned;

    assign aUnsigned = a[31] == 0 ? a : ~a + 1;
    assign bUnsigned = b[31] == 0 ? b : ~b + 1;

    assign quo = !(a[31] ^ b[31]) ? quoFromDivider : ~quoFromDivider + 1;
    assign rem = !(a[31]) ? remFromDivider : ~remFromDivider + 1;

    Divider32bu divider32bu (
        clk,
        aUnsigned,
        bUnsigned,
        quoFromDivider,  // quotient
        remFromDivider,  // remainder
        rst,
        finish
    );

endmodule
`endif
