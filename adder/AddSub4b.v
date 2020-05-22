`ifndef _AddSub4b
`define _AddSub4b

`include "./adder/AddSub1b.v"

module AddSub4b(
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Ci,  // if subtraction, it is borrow
    input wire Ctrl,  // [mode] 0: addup; 1: subtraction
    output wire [3:0] S, 
    output wire Co
);
    wire c1, c2, c3;

    AddSub1b aS1(.A(A[0]), .B(B[0]), .Ci(Ctrl ^ Ci), .S(S[0]), .Co(c1), .Ctrl(Ctrl));
    AddSub1b aS2(.A(A[1]), .B(B[1]), .Ci(c1), .S(S[1]), .Co(c2), .Ctrl(Ctrl));
    AddSub1b aS3(.A(A[2]), .B(B[2]), .Ci(c2), .S(S[2]), .Co(c3), .Ctrl(Ctrl));
    AddSub1b aS4(.A(A[3]), .B(B[3]), .Ci(c3), .S(S[3]), .Co(Co), .Ctrl(Ctrl));

endmodule

// subtraction:
//   A - B
// = A + ~B + 1

`endif
