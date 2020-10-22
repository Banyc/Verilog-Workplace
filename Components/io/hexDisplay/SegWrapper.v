`include "./Components/io/hexDisplay/SEG_DRV.v"
`include "./Components/clock/clkdiv.v"

module SegWrapper(
    clk,
    rst,
    ens,
    nums,
    points,
    SEG_CLK,
    SEG_DT
);
    input wire clk;
    input wire rst;
    // enable; 0: enabled
    input wire [7:0] ens;
    input wire [31:0] nums;
    // 1: activated
    input wire [7:0] points;
    output wire SEG_CLK;
    output wire SEG_DT;

    wire [31:0] clk_counter;

    clkdiv slowed_clock(.clk(clk), .rst(rst), .clkdiv(clk_counter));

    SEG_DRV drv(
        .clk(clk),
        .start(clk_counter[18]),
        .en(ens),
        .num(nums),
        .point(points),
        .finish(),
        .serial_clk(SEG_CLK),
        .serial_seg(SEG_DT)
    );
endmodule // SegWrapper
