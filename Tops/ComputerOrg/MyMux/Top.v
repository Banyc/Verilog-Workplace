`include "./Components/io/hexDisplay/DispNum.v"
`include "./Components/mux/Mux4to1b4.v"
`include "./Components/mux/Mux4to1b16.v"
`include "./Components/register/Register4b.v"
`include "./Components/io/LED/LED_DRV.v"
`include "./Components/clock/clkdiv.v"


module Top(
    clk,
    BTN,
    BTNX4,
    SEGMENT,
    AN,
    SW,
    LED_CLK,
    LED_CLR,
    LED_DO,
    LED_EN
);

    input wire clk;
    input wire [3:0] BTN;
    input wire [15:0] SW;
    output reg BTNX4 = 0;
    output wire [7:0] SEGMENT;
    output wire [3:0] AN;
    output wire LED_CLK;
    output reg LED_CLR = 1;
    output wire LED_DO;
    output reg LED_EN = 1;

    // mux output
    wire [15:0] num;
    wire [3:0] en;

    // hex display
    DispNum m6(clk, 1'b0, num, 4'b0, ~en, AN, SEGMENT);

    // LED
    wire [31:0] clk_counter;
    wire finish;
    clkdiv slowed_clock(.clk(clk), .rst(1'b0), .clkdiv(clk_counter));
    LED_DRV m5(clk, clk_counter[17], SW, finish, LED_CLK, LED_DO);

    // cases for being selected by MUX
    wire [15:0] num1 = {SW[7:0], 8'b0};
    wire [15:0] num2 = {4'b0, SW[7:0], 4'b0};
    wire [15:0] num3 = {8'b0, SW[7:0]};
    wire [15:0] num4 = {SW[3:0], 8'b0, SW[7:4]};
    wire [3:0] en1 = {1'b1, 1'b1, 1'b0, 1'b0};
    wire [3:0] en2 = {1'b0, 1'b1, 1'b1, 1'b0};
    wire [3:0] en3 = {1'b0, 1'b0, 1'b1, 1'b1};
    wire [3:0] en4 = {1'b1, 1'b0, 1'b0, 1'b1};

    // BTN recording
    wire load = |BTN;
    wire [3:0] sel_decoded;
    Register4b reg4(clk, load, BTN, sel_decoded);

    // encode selective option from BTN
    wire [1:0] sel;
    assign sel[0] = sel_decoded[3] | sel_decoded[1];
    assign sel[1] = sel_decoded[3] | sel_decoded[2];

    // mux 16bit 4to1
    Mux4to1b16 mux16(sel, num1, num2, num3, num4, num);

    // mux 4bit 4to1
    Mux4to1b4 mux4(sel, en1, en2, en3, en4, en);

endmodule // Top
