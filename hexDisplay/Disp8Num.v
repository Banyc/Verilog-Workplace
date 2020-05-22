`include "./clock/clkdiv.v"
`include "./hexDisplay/SEG_DRV.v"

// Disp8Num d1(clk, 1'b0, num, 8'b0, 8'b0, SEG_CLK, SEG_DT);

module Disp8Num(
    input wire clk, rst,
    input wire [31:0] num,  // all 8 numbers to display  //
    input wire [7:0] point,  // point to display  // 1: activated
    input wire [7:0] en,  // "enable" for all 8 displays  // 0: enable
    // the output wires should be directly connected to the display hardware
    output wire seg_clk,
    output wire seg_data
);
    wire [31:0] clk_counter;
    wire [3:0] num_to_display;
    wire point_to_display;
    wire is_disabled;
    wire [3:0] turn_index;
    wire seg_finish;

    clkdiv slowed_clock(.clk(clk), .rst(rst), .clkdiv(clk_counter));

    SEG_DRV d0(clk, clk_counter[18], en, num, point, seg_finish, seg_clk, seg_data);

endmodule // Disp8Num
