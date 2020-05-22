`ifndef _AddSub1b
`define _AddSub1b

`include "./adder/Adder1b.v"

module AddSub1b(
    input wire A, B, Ctrl, Ci,
    output wire S, Co
);
    wire tmp;

    assign tmp = B ^ Ctrl;
    Adder1b add(.A(A), .B(tmp), .Ci(Ci), .S(S), .Co(Co));

endmodule

`endif
