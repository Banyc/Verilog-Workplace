`ifndef _Mux2to1
`define _Mux2to1

module Mux2to1(
    a,  // candidate
    b,  // candidate
    ctrl,  // control
    s  // final selection
);

    input wire a;
    input wire b;
    input wire ctrl;
    output wire s;

    wire sel1, sel2;

    and(sel1, a, ~ctrl);
    and(sel2, b, ctrl);
    or(s, sel1, sel2);

endmodule // Mux2to1

`endif
