`ifndef _Comparator32b
`define _Comparator32b

`include "./Components/comparator/Comparator4b.v"

module Comparator32b(
    input wire [31:0] A,
    input wire [31:0] B,
    output wire ZF,
    output reg SLTu, SLT
);

    wire [7:0] zf;
    wire [7:0] sltu;
    wire [7:0] slt;

    Comparator4b c0(.A(A[3:0]),   .B(B[3:0]),   .ZF(zf[0]), .SLTu(sltu[0]), .SLT(slt[0]));
    Comparator4b c1(.A(A[7:4]),   .B(B[7:4]),   .ZF(zf[1]), .SLTu(sltu[1]), .SLT(slt[1]));
    Comparator4b c2(.A(A[11:8]),  .B(B[11:8]),  .ZF(zf[2]), .SLTu(sltu[2]), .SLT(slt[2]));
    Comparator4b c3(.A(A[15:12]), .B(B[15:12]), .ZF(zf[3]), .SLTu(sltu[3]), .SLT(slt[3]));
    Comparator4b c4(.A(A[19:16]), .B(B[19:16]), .ZF(zf[4]), .SLTu(sltu[4]), .SLT(slt[4]));
    Comparator4b c5(.A(A[23:20]), .B(B[23:20]), .ZF(zf[5]), .SLTu(sltu[5]), .SLT(slt[5]));
    Comparator4b c6(.A(A[27:24]), .B(B[27:24]), .ZF(zf[6]), .SLTu(sltu[6]), .SLT(slt[6]));
    Comparator4b c7(.A(A[31:28]), .B(B[31:28]), .ZF(zf[7]), .SLTu(sltu[7]), .SLT(slt[7]));

    assign ZF = &zf;

    always @* begin
        // first four
        if (~zf[7]) begin
            SLTu = sltu[7];
            SLT = slt[7];
        end else if (~zf[6]) begin
            SLTu = sltu[6];
            SLT = sltu[6];
        end else if (~zf[5]) begin
            SLTu = sltu[5];
            SLT = sltu[5];
        end else if (~zf[4]) begin
            SLTu = sltu[4];
            SLT = sltu[4];
        end else if (~zf[3]) begin
            SLTu = sltu[3];
            SLT = sltu[3];
        end else if (~zf[2]) begin
            SLTu = sltu[2];
            SLT = sltu[2];
        end else if (~zf[1]) begin
            SLTu = sltu[1];
            SLT = sltu[1];
        end else if (~zf[0]) begin
            SLTu = sltu[0];
            SLT = sltu[0];
        end else begin
            SLTu = 0;
            SLT = 0;
        end
    end
    

endmodule // Comparator32b

`endif
