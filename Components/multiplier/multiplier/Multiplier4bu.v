// accept magnitude only

`ifndef _Multiplier4bu
`define _Multiplier4bu
`include "./Components/adder/Adder4b.v"

module Multiplier4bu(
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] p
);
    wire [3:0] adder0_a;
    wire [3:0] adder1_a;
    wire [3:0] adder2_a;

    wire [3:0] adder0_b;
    wire [3:0] adder1_b;
    wire [3:0] adder2_b;

    wire [3:0] adder0_s;
    wire [3:0] adder1_s;
    wire [3:0] adder2_s;

    wire adder0_co;
    wire adder1_co;
    wire adder2_co;

    assign adder0_a[0] = a[0] & b[1];
    assign adder0_a[1] = a[1] & b[1];
    assign adder0_a[2] = a[2] & b[1];
    assign adder0_a[3] = a[3] & b[1];

    assign adder1_a[0] = a[0] & b[2];
    assign adder1_a[1] = a[1] & b[2];
    assign adder1_a[2] = a[2] & b[2];
    assign adder1_a[3] = a[3] & b[2];

    assign adder2_a[0] = a[0] & b[3];
    assign adder2_a[1] = a[1] & b[3];
    assign adder2_a[2] = a[2] & b[3];
    assign adder2_a[3] = a[3] & b[3];

    assign adder0_b[0] = a[1] & b[0];
    assign adder0_b[1] = a[2] & b[0];
    assign adder0_b[2] = a[3] & b[0];
    assign adder0_b[3] = 0;

    assign adder1_b[0] = adder0_s[1];
    assign adder1_b[1] = adder0_s[2];
    assign adder1_b[2] = adder0_s[3];
    assign adder1_b[3] = adder0_co;

    assign adder2_b[0] = adder1_s[1];
    assign adder2_b[1] = adder1_s[2];
    assign adder2_b[2] = adder1_s[3];
    assign adder2_b[3] = adder1_co;

    Adder4b adder0(
        .A(adder0_a),
        .B(adder0_b),
        .Ci(1'b0),
        .S(adder0_s), 
        .Co(adder0_co));
    Adder4b adder1(
        .A(adder1_a),
        .B(adder1_b),
        .Ci(1'b0),
        .S(adder1_s), 
        .Co(adder1_co));
    Adder4b adder2(
        .A(adder2_a),
        .B(adder2_b),
        .Ci(1'b0),
        .S(adder2_s), 
        .Co(adder2_co));

    assign p[0] = a[0] & b[0];
    assign p[1] = adder0_s[0];
    assign p[2] = adder1_s[0];
    assign p[3] = adder2_s[0];
    assign p[4] = adder2_s[1];
    assign p[5] = adder2_s[2];
    assign p[6] = adder2_s[3];
    assign p[7] = adder2_co;
endmodule

`endif
