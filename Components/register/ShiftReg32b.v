`ifndef __ShiftReg32b
`define __ShiftReg32b

`include "./Components/register/ShiftReg8b.v"

// shift right
module ShiftReg32b(
    clk, load, S_L, s_in, p_in, Q
);
    input wire clk;
    input wire S_L;  // 并行输入命令 ~S/L; 0: Serial mode; 1: parallel mode
    input wire s_in;  // shift_in, 串行输入
    input wire [31:0] p_in;  // par_in, 并行输入数据
    input wire load;  // 1: write
    output wire [31:0] Q;  // value of all regs

    ShiftReg8b s0(.clk(clk & load), .S_L(S_L), .s_in(Q[8]),  .p_in(p_in[7:0]),   .Q(Q[7:0]));
    ShiftReg8b s1(.clk(clk & load), .S_L(S_L), .s_in(Q[16]), .p_in(p_in[15:8]),  .Q(Q[15:8]));
    ShiftReg8b s2(.clk(clk & load), .S_L(S_L), .s_in(Q[24]), .p_in(p_in[23:16]), .Q(Q[23:16]));
    ShiftReg8b s3(.clk(clk & load), .S_L(S_L), .s_in(s_in),  .p_in(p_in[31:24]), .Q(Q[31:24]));

endmodule // ShiftReg32b

`endif
