`include "./Components/LED/LED_DRV.v"
`include "./Components/clock/clkdiv.v"

module LedWrapper(
    clk,
    rst,
    bitmap,
    LED_CLK,
    LED_DO
);
    input wire clk;
    input wire rst;
    input wire [15:0] bitmap;
    output wire LED_CLK;
    output wire LED_DO;

    wire [31:0] clk_counter;

    clkdiv slowed_clock(.clk(clk), .rst(rst), .clkdiv(clk_counter));

    LED_DRV drv(
        .clk(clk),
        .start(clk_counter[18]),
        .led_to_show(bitmap),
        .finish(),
        .serial_clk(LED_CLK),
        .serial_led(LED_DO)
    );
endmodule // LedWrapper
