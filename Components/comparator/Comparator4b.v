`ifndef _Comparator4b
`define _Comparator4b
`include "./Components/mux/Mux2to1.v"

// 　if(A==B)ZF=1; else ZF=0;

// 　if(A<B)SLTu=1; else SLTu=0; //无符号数

// 　if(A<B)SLT =1; else SLT =0; //补码符号数

module Comparator4b(
    input wire [3:0] A,
    input wire [3:0] B,
    output wire ZF, SLTu, SLT
);
    wire a_xor_b_bar0;
    wire a_xor_b_bar1;
    wire a_xor_b_bar2;
    wire a_xor_b_bar3;

    wire a_bar_and_b0;
    wire a_bar_and_b1;
    wire a_bar_and_b2;
    wire a_bar_and_b3;

    assign a_xor_b_bar0 = ~(A[0] ^ B[0]);
    assign a_xor_b_bar1 = ~(A[1] ^ B[1]);
    assign a_xor_b_bar2 = ~(A[2] ^ B[2]);
    assign a_xor_b_bar3 = ~(A[3] ^ B[3]);

    assign a_bar_and_b0 = ~A[0] & B[0]
        & a_xor_b_bar1 & a_xor_b_bar2 & a_xor_b_bar3;
    assign a_bar_and_b1 = ~A[1] & B[1]
        & a_xor_b_bar2 & a_xor_b_bar3;
    assign a_bar_and_b2 = ~A[2] & B[2]
        & a_xor_b_bar3;
    assign a_bar_and_b3 = ~A[3] & B[3];

    assign SLTu = a_bar_and_b0 | a_bar_and_b1 | a_bar_and_b2 | a_bar_and_b3;

    Mux2to1 mux(.a(SLTu), .b(A[3]), .ctrl(A[3] ^ B[3]), .s(SLT));

    assign ZF = a_xor_b_bar0 & a_xor_b_bar1 & a_xor_b_bar2 & a_xor_b_bar3;

endmodule

`endif
