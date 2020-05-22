`include "./Components/comparator/Comparator4b.v"
`include "./Components/LED/LED_DRV.v"
`include "./Components/clock/clkdiv.v"
`include "./Components/hexDisplay/DispNum.v"

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

    wire zf, sltu, slt;

    Comparator4b m0(.A(SW[3:0]), .B(SW[7:4]), .ZF(zf), .SLTu(sltu), .SLT(slt));

    // hex display
    DispNum m6(clk, 1'b0, {SW[7:0], 3'b0, sltu, 3'b0, slt}, 4'b0, ~{4'b1111}, AN, SEGMENT);

    // LED
    wire [31:0] clk_counter;
    wire finish;
    clkdiv slowed_clock(.clk(clk), .rst(1'b0), .clkdiv(clk_counter));
    LED_DRV m5(clk, clk_counter[17], {15'b0, zf}, finish, LED_CLK, LED_DO);

endmodule // Top
