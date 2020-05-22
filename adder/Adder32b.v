`ifndef __Adder32b
`define __Adder32b

`include "./adder/AddSub32bFlag.v"
`include "./Comparator/Comparator32b.v"

module Adder32b(
    input[31:0] A,
    input[31:0] B,
    input Ci,
    input Ctrl,
    output[31:0] S,
    output CF,OF,ZF,SF,PF,  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    output SLTu, SLT
);
    AddSub32bFlag addsub(A, B, Ci, Ctrl, S, CF,OF,ZF,SF,PF);
    Comparator32b cmp(.A(A), .B(B), .ZF(), .SLTu(SLTu), .SLT(SLT));

endmodule
`endif
