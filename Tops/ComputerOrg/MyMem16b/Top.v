// 目标：存储器读。自选合适位数的存储器，按每zjie地址为内容初始化该存储器，选择地址读出显示。系统按16位zjie字节编址。

// 输入：

// 　开　关：八个开关表示8位按16位zjie编址的存储器地址。

// 　按　钮：[可选]当按字读出时，最右按/不按选择显示大头/小头不同设计。

// 输出：

// 　发光管：自定。

// 　四数码：显示存储器读写地址(按zjie寻址)。

// 　八数码：显示32位存储器读写数据。

// COE：

// 　memory_initialization_radix=16;

// 　memory_initialization_vector=

// 　　00010203, 04050607, 08090A0B, 0C0D0E0F, ... 12345678;

// 考虑1：考虑对齐/不对齐读。

// 考虑2：以显存文本方式显示。

`include "./Components/io/LED/LED_DRV.v"
`include "./Components/clock/clkdiv.v"
`include "./Components/io/hexDisplay/DispNum.v"
`include "./Components/io/hexDisplay/SEG_DRV.v"
`include "./Components/memory/Ram16b_ipCores.v"

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
    LED_EN,
    SEG_CLK,
    SEG_CLR,
    SEG_DT,
    SEG_EN
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

    output wire SEG_CLK;
    output reg SEG_CLR = 1;
    output wire SEG_DT;
    output reg SEG_EN = 1;

    wire [15:0] read_data_1;

    Ram16b_ipCores m0(
        clk,
        // rst,
        SW[3:0],  // address
        // write
        SW[7],  // write enable
        {SW[15:0]},  // write data
        // read
        read_data_1,
        // endian
        BTN[0]
    );

    // hex display
    DispNum m6(clk, 1'b0, {8'b0, SW[7:0]}, 4'b0, ~{4'b1111}, AN, SEGMENT);

    // slow clk
    wire [31:0] clk_counter;

    // LED
    wire finish_led;
    clkdiv slowed_clock(.clk(clk), .rst(1'b0), .clkdiv(clk_counter));
    LED_DRV m5(clk, clk_counter[17], {16'b0}, finish_led, LED_CLK, LED_DO);

    // SEG_DRV
    wire finish_seg;
    SEG_DRV m7(
        clk,
        clk_counter[17],
        8'b0,
        {16'b0, read_data_1},
        8'b0,
        finish_seg,
        SEG_CLK,
        SEG_DT
    );

endmodule // Top
