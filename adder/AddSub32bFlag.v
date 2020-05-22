// AddSub4b with flags
// support both signed 2's compliment and unsighed number

`ifndef __AddSub32bFlag
`define __AddSub32bFlag

`include "./adder/AddSub1b.v"

module AddSub32bFlag(
    input[31:0] A,
    input[31:0] B,
    input Ci,
    input Ctrl,
    output[31:0] S,
    output CF,OF,ZF,SF,PF  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
);

    wire add_cf, sub_cf, sub_sf, co;

    wire [31:0] c;

    AddSub1b  aS0(.A(A[0]),  .B(B[0]),  .Ci(Ctrl ^ Ci), .S(S[0]),  .Co(c[0]),  .Ctrl(Ctrl));
    AddSub1b  aS1(.A(A[1]),  .B(B[1]),  .Ci(c[0]),      .S(S[1]),  .Co(c[1]),  .Ctrl(Ctrl));
    AddSub1b  aS2(.A(A[2]),  .B(B[2]),  .Ci(c[1]),      .S(S[2]),  .Co(c[2]),  .Ctrl(Ctrl));
    AddSub1b  aS3(.A(A[3]),  .B(B[3]),  .Ci(c[2]),      .S(S[3]),  .Co(c[3]),  .Ctrl(Ctrl));
    AddSub1b  aS4(.A(A[4]),  .B(B[4]),  .Ci(c[3]),      .S(S[4]),  .Co(c[4]),  .Ctrl(Ctrl));
    AddSub1b  aS5(.A(A[5]),  .B(B[5]),  .Ci(c[4]),      .S(S[5]),  .Co(c[5]),  .Ctrl(Ctrl));
    AddSub1b  aS6(.A(A[6]),  .B(B[6]),  .Ci(c[5]),      .S(S[6]),  .Co(c[6]),  .Ctrl(Ctrl));
    AddSub1b  aS7(.A(A[7]),  .B(B[7]),  .Ci(c[6]),      .S(S[7]),  .Co(c[7]),  .Ctrl(Ctrl));
    AddSub1b  aS8(.A(A[8]),  .B(B[8]),  .Ci(c[7]),      .S(S[8]),  .Co(c[8]),  .Ctrl(Ctrl));
    AddSub1b  aS9(.A(A[9]),  .B(B[9]),  .Ci(c[8]),      .S(S[9]),  .Co(c[9]),  .Ctrl(Ctrl));
    AddSub1b aS10(.A(A[10]), .B(B[10]), .Ci(c[9]),      .S(S[10]), .Co(c[10]), .Ctrl(Ctrl));
    AddSub1b aS11(.A(A[11]), .B(B[11]), .Ci(c[10]),     .S(S[11]), .Co(c[11]), .Ctrl(Ctrl));
    AddSub1b aS12(.A(A[12]), .B(B[12]), .Ci(c[11]),     .S(S[12]), .Co(c[12]), .Ctrl(Ctrl));
    AddSub1b aS13(.A(A[13]), .B(B[13]), .Ci(c[12]),     .S(S[13]), .Co(c[13]), .Ctrl(Ctrl));
    AddSub1b aS14(.A(A[14]), .B(B[14]), .Ci(c[13]),     .S(S[14]), .Co(c[14]), .Ctrl(Ctrl));
    AddSub1b aS15(.A(A[15]), .B(B[15]), .Ci(c[14]),     .S(S[15]), .Co(c[15]), .Ctrl(Ctrl));
    AddSub1b aS16(.A(A[16]), .B(B[16]), .Ci(c[15]),     .S(S[16]), .Co(c[16]), .Ctrl(Ctrl));
    AddSub1b aS17(.A(A[17]), .B(B[17]), .Ci(c[16]),     .S(S[17]), .Co(c[17]), .Ctrl(Ctrl));
    AddSub1b aS18(.A(A[18]), .B(B[18]), .Ci(c[17]),     .S(S[18]), .Co(c[18]), .Ctrl(Ctrl));
    AddSub1b aS19(.A(A[19]), .B(B[19]), .Ci(c[18]),     .S(S[19]), .Co(c[19]), .Ctrl(Ctrl));
    AddSub1b aS20(.A(A[20]), .B(B[20]), .Ci(c[19]),     .S(S[20]), .Co(c[20]), .Ctrl(Ctrl));
    AddSub1b aS21(.A(A[21]), .B(B[21]), .Ci(c[20]),     .S(S[21]), .Co(c[21]), .Ctrl(Ctrl));
    AddSub1b aS22(.A(A[22]), .B(B[22]), .Ci(c[21]),     .S(S[22]), .Co(c[22]), .Ctrl(Ctrl));
    AddSub1b aS23(.A(A[23]), .B(B[23]), .Ci(c[22]),     .S(S[23]), .Co(c[23]), .Ctrl(Ctrl));
    AddSub1b aS24(.A(A[24]), .B(B[24]), .Ci(c[23]),     .S(S[24]), .Co(c[24]), .Ctrl(Ctrl));
    AddSub1b aS25(.A(A[25]), .B(B[25]), .Ci(c[24]),     .S(S[25]), .Co(c[25]), .Ctrl(Ctrl));
    AddSub1b aS26(.A(A[26]), .B(B[26]), .Ci(c[25]),     .S(S[26]), .Co(c[26]), .Ctrl(Ctrl));
    AddSub1b aS27(.A(A[27]), .B(B[27]), .Ci(c[26]),     .S(S[27]), .Co(c[27]), .Ctrl(Ctrl));
    AddSub1b aS28(.A(A[28]), .B(B[28]), .Ci(c[27]),     .S(S[28]), .Co(c[28]), .Ctrl(Ctrl));
    AddSub1b aS29(.A(A[29]), .B(B[29]), .Ci(c[28]),     .S(S[29]), .Co(c[29]), .Ctrl(Ctrl));
    AddSub1b aS30(.A(A[30]), .B(B[30]), .Ci(c[29]),     .S(S[30]), .Co(c[30]), .Ctrl(Ctrl));
    AddSub1b aS31(.A(A[31]), .B(B[31]), .Ci(c[30]),     .S(S[31]), .Co(c[31]), .Ctrl(Ctrl));

    assign CF = Ctrl ^ c[31];
    assign SF = S[31];

    assign OF = c[30] ^ c[31];
    assign PF = ^S;
    assign ZF = ~|S;

endmodule

`endif
