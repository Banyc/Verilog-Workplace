`ifndef __ShiftReg32bL
`define __ShiftReg32bL

`include "./Components/register/ShiftReg8b.v"

// left shift

module ShiftReg32bL(
    clk, load, S_L, s_in, p_in, Q
);
    input wire clk;
    input wire S_L;  // 并行输入命令 ~S/L; 0: Serial mode; 1: parallel mode
    input wire s_in;  // shift_in, 串行输入
    input wire [31:0] p_in;  // par_in, 并行输入数据
    input wire load;  // 1: write
    output reg [31:0] Q;  // value of all regs

    wire [31:0] right_shift_reg;
    reg [31:0] reversed_p_in;
    integer i;

    always @(*) begin
        for (i = 0; i < 32; i = i + 1) begin
            Q[i] = right_shift_reg[31 - i];
            reversed_p_in[i] = p_in[31 - i];
        end
    end

    ShiftReg8b s0(.clk(clk & load), .S_L(S_L), .s_in(right_shift_reg[8]),  .p_in(reversed_p_in[7:0]),   .Q(right_shift_reg[7:0]));
    ShiftReg8b s1(.clk(clk & load), .S_L(S_L), .s_in(right_shift_reg[16]), .p_in(reversed_p_in[15:8]),  .Q(right_shift_reg[15:8]));
    ShiftReg8b s2(.clk(clk & load), .S_L(S_L), .s_in(right_shift_reg[24]), .p_in(reversed_p_in[23:16]), .Q(right_shift_reg[23:16]));
    ShiftReg8b s3(.clk(clk & load), .S_L(S_L), .s_in(s_in),  .p_in(reversed_p_in[31:24]), .Q(right_shift_reg[31:24]));

endmodule // ShiftReg32b

`endif
