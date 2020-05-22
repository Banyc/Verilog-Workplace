`include "./Components/clock/clk_1ms.v"
`include "./Components/hexDisplay/NumberGenerator.v"
`include "./Components/hexDisplay/DispNum.v"
`include "./Components/register/ShiftReg8b.v"
`include "./Components/button/pbdebounce.v"
`include "./Components/LED/LED_DRV.v"

module Top(
    clk,
    SW,
    BTNX4,
    BTN,
    LED_CLK,
    LED_CLR,
    LED_DO,
    LED_EN,
    AN,
    SEGMENT
);

    input wire clk;
    input wire [15:0] SW;
    output reg BTNX4;
    input wire [3:0] BTN;
    output wire LED_CLK;
    output reg LED_CLR;
    output wire LED_DO;
    output reg LED_EN;
    output wire [3:0] AN;
    output wire [7:0] SEGMENT;

    wire clk_1s;
    wire clk_1ms;
    wire [3:0] btn;
    wire [15:0] num;
    wire finish;

    initial begin
        LED_CLR = 1'b1;
        LED_EN = 1'b1;
        BTNX4 = 1'b0;
    end

    clk_1ms c0(clk, clk_1ms);

    pbdebounce btn1(clk_1ms, BTN[0], btn[0]);
    pbdebounce btn2(clk_1ms, BTN[1], btn[1]);
    pbdebounce btn3(clk_1ms, BTN[2], btn[2]);
    pbdebounce btn4(clk_1ms, BTN[3], btn[3]);
    
    NumberGenerator m5(.num_event(btn), .sw(4'b0), .num(num));
    DispNum m6(clk, 1'b0, num, 4'b0, 4'b0, AN, SEGMENT);

    // LED_DRV; LED driver
    LED_DRV drv(clk, SW[15], num, finish, LED_CLK, LED_DO);

endmodule // Top
