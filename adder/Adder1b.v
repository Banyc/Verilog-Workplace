// Adder 1bit
`ifndef _Adder1b
`define _Adder1b

// {Co, S} = A + B + Ci

module Adder1b(
    input wire A, B, Ci,
    output wire S, Co
);
    wire gen, p_and_ci, prop;

    assign prop = A ^ B;
    assign S = prop ^ Ci;
    assign gen = A & B;
    assign p_and_ci = prop & Ci;
    assign Co = gen | p_and_ci;

endmodule

`endif
