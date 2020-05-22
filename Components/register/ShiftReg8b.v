`ifndef __ShiftReg8b
`define __ShiftReg8b

module ShiftReg8b(
    clk, S_L, s_in, p_in, Q
);
    input wire clk;
    input wire S_L;  // 并行输入命令 ~S/L; 0: Serial mode; 1: parallel mode
    input wire s_in;  // shift_in, 串行输入
    input wire [7:0] p_in;  // par_in, 并行输入数据
    output reg [7:0] Q;  // value of all regs

    initial begin
        Q = 0;
    end

    wire [7:0] d;  // D port of D flip-flop

    assign d[7] = (s_in & ~S_L) | (p_in[7] & S_L);
    assign d[6] = (Q[7] & ~S_L) | (p_in[6] & S_L);
    assign d[5] = (Q[6] & ~S_L) | (p_in[5] & S_L);
    assign d[4] = (Q[5] & ~S_L) | (p_in[4] & S_L);
    assign d[3] = (Q[4] & ~S_L) | (p_in[3] & S_L);
    assign d[2] = (Q[3] & ~S_L) | (p_in[2] & S_L);
    assign d[1] = (Q[2] & ~S_L) | (p_in[1] & S_L);
    assign d[0] = (Q[1] & ~S_L) | (p_in[0] & S_L);

    always @(posedge clk) begin
        Q <= d;
    end

endmodule // ShiftReg8b

`endif
