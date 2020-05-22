`include "./Components/adder/Adder1b.v"

module Adder4b(
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Ci,
    output wire [3:0] S, 
    output wire Co
);
    wire c1, c2, c3;

    Adder1b a1(.A(A[0]), .B(B[0]), .Ci(Ci), .S(S[0]), .Co(c1));
    Adder1b a2(.A(A[1]), .B(B[1]), .Ci(c1), .S(S[1]), .Co(c2));
    Adder1b a3(.A(A[2]), .B(B[2]), .Ci(c2), .S(S[2]), .Co(c3));
    Adder1b a4(.A(A[3]), .B(B[3]), .Ci(c3), .S(S[3]), .Co(Co));

endmodule
