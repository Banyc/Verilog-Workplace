// AddSub4b with flags
// support both signed 2's compliment and unsighed number

`ifndef __AddSub4bFlag
`define __AddSub4bFlag

`include "./Components/adder/AddSub1b.v"

module AddSub4bFlag(
    input[3:0] A,
    input[3:0] B,
    input Ci,
    input Ctrl,
    output[3:0] S,
    output CF,OF,ZF,SF,PF  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
);

    wire add_cf, sub_cf, sub_sf, co;

    wire c0, c1, c2, c3;

    AddSub1b aS0(.A(A[0]), .B(B[0]), .Ci(Ctrl ^ Ci), .S(S[0]), .Co(c0), .Ctrl(Ctrl));
    AddSub1b aS1(.A(A[1]), .B(B[1]), .Ci(c0), .S(S[1]), .Co(c1), .Ctrl(Ctrl));
    AddSub1b aS2(.A(A[2]), .B(B[2]), .Ci(c1), .S(S[2]), .Co(c2), .Ctrl(Ctrl));
    AddSub1b aS3(.A(A[3]), .B(B[3]), .Ci(c2), .S(S[3]), .Co(c3), .Ctrl(Ctrl));

    assign CF = Ctrl ^ c3;
    assign SF = S[3];

    assign OF = c2 ^ c3;
    assign PF = ^S;
    assign ZF = ~|S;

endmodule

`endif
