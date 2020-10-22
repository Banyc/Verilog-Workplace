`include "./Components/io/button/pbdebounceWrapper.v"
`include "./Components/io/LED/LedWrapper.v"
`include "./Components/io/hexDisplay/DispNum.v"
`include "./Components/io/hexDisplay/SegWrapper.v"
`include "./Components/cpu/singleCycleCpu/SingleCycleCpu.v"
// `include "./ipcore_dir/Ram32bIp.v"

module Top(
    clk,
    BTN,
    BTNX4,
    SEGMENT,
    AN,
    SW,
    LED,
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
    output wire [7:0] LED;
    output wire LED_CLK;
    output reg LED_CLR = 1;
    output wire LED_DO;
    output reg LED_EN = 1;

    output wire SEG_CLK;
    output reg SEG_CLR = 1;
    output wire SEG_DT;
    output reg SEG_EN = 1;

    wire cpuClk;
    wire rst;
    wire [31:0] instruction;
    wire [31:0] pcOut;
    wire [4:0] readRegisterDebug;
    wire [31:0] readDataDebug;

    wire manualClk;
    wire clkMode;  // 0: manual; 1: auto

    assign cpuClk = (clkMode) ? clk :
                                manualClk;

    // __subject__
    // CPU
    SingleCycleCpu cpu(
        .clk(cpuClk),
        .rst(rst),
        // custom outputs
        .instruction(instruction),
        .pcOut(pcOut),

        .readRegisterDebug(readRegisterDebug),
        .readDataDebug(readDataDebug)
    );

    // __inner states__
    // cpuClk counter
    reg [3:0] cpuClkCounter = 0;
    always @(posedge cpuClk or posedge rst) begin
        if (rst)
            cpuClkCounter = 0;
        else
            cpuClkCounter = cpuClkCounter + 1;
    end

    // debug
    reg [15:0] rstCount = 0;
    always @(posedge rst) begin
        rstCount = rstCount + 1;
    end

    // __input__
    // btn 
    wire [3:0] goodBtn;
    pbdebounceWrapper easePress0(clk, !BTN[0], goodBtn[0]);
    pbdebounceWrapper easePress1(clk, !BTN[1], goodBtn[1]);
    pbdebounceWrapper easePress2(clk, !BTN[2], goodBtn[2]);
    pbdebounceWrapper easePress3(clk, !BTN[3], goodBtn[3]);

    // __control by input__
    assign manualClk = goodBtn[3];
    assign rst = goodBtn[2];
    assign clkMode = SW[7];

    // 4 digits display content 
    reg [15:0] displayContent;
    assign readRegisterDebug = SW[4:0];

    always @(*) begin
        case (SW[6:5])
            0: begin
                displayContent = readDataDebug[15:0];
            end
            1: begin
                displayContent = readDataDebug[31:16];
            end
            2: begin
                displayContent = {cpuClkCounter[3:0], 4'b0000, 4'b0000, pcOut[3:0]};
            end
            3: begin
                // debug
                // displayContent = {cpuClkCounter, state[3:0], 3'b0, BTN[2], 3'b0, rst};
                displayContent = {pcOut[15:0]};
            end
        endcase
    end

    // __output__
    // 8 bit LED
    assign LED[7] = manualClk;
    assign LED[6] = clk;
    assign LED[5] = rst;
    assign LED[4] = 0;
    assign LED[3] = 0;
    assign LED[2] = 0;
    assign LED[1] = 0;
    assign LED[0] = 0;

    // hex display
    DispNum m6(clk, 1'b0, displayContent, 4'b0, ~{4'b1111}, AN, SEGMENT);

    // LED
    LedWrapper led(
        .clk(clk),
        .rst(1'b0),
        .bitmap({16'b0}),
        .LED_CLK(LED_CLK),
        .LED_DO(LED_DO)
    );

    // SEG_DRV
    SegWrapper seg(
        .clk(clk),
        .rst(1'b0),
        .ens(8'b0),
        .nums(instruction),  // show PC
        .points(8'b0),
        .SEG_CLK(SEG_CLK),
        .SEG_DT(SEG_DT)
    );

endmodule // Top
