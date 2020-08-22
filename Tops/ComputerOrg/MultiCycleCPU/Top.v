`include "./Components/button/pbdebounceWrapper.v"
`include "./Components/LED/LedWrapper.v"
`include "./Components/hexDisplay/DispNum.v"
`include "./Components/hexDisplay/SegWrapper.v"
`include "./Components/cpu/MultiCycleCpu.v"
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
    wire memRead;
    wire memWrite;
    wire regWrite;
    wire [31:0] memoryReadDataAddress;
    wire [31:0] registerReadData2;
    wire [4:0] writeRegister;
    wire [31:0] freshMemoryReadData;
    wire [31:0] registerWriteData;
    wire [4:0] readRegister1;
    wire [4:0] readRegister2;
    wire [31:0] freshRegisterReadData1;
    wire [31:0] freshRegisterReadData2;
    wire [31:0] instruction;
    wire [31:0] pcOut;
    wire [3:0] state;
    wire [4:0] readRegisterDebug;
    wire [31:0] readDataDebug;

    wire manualClk;
    wire clkMode;  // 0: manual; 1: auto

    assign cpuClk = (clkMode) ? clk :
                                manualClk;

    // __subject__
    // CPU
    MultiCycleCpu cpu(
        .clk(cpuClk),
        .rst(rst),
        // ports for Ram32b
        .memoryReadDataAddress(memoryReadDataAddress),
        .memRead(memRead),
        .memWrite(memWrite),
        .registerReadData2(registerReadData2),
        .freshMemoryReadData(freshMemoryReadData),
        // ports for RegFile
        .readRegister1(readRegister1),
        .readRegister2(readRegister2),
        .writeRegister(writeRegister),
        .registerWriteData(registerWriteData),
        .regWrite(regWrite),
        .freshRegisterReadData1(freshRegisterReadData1),
        .freshRegisterReadData2(freshRegisterReadData2),
        // custom outputs
        .instruction(instruction),
        .pcOut(pcOut),

        .state(state)
    );

    // Memory
    Ram32b dataMemory(
        .clk(cpuClk),
        .rst(rst),
        .address(memoryReadDataAddress),
        .readEnable(memRead),
        .writeEnable(memWrite),
        .writeData(registerReadData2),
        .readData(freshMemoryReadData)
    );
    // Ram32bIp dataMemoryIp(
    //     .clka(!cpuClk),
    //     .wea(memWrite),
    //     .addra(memoryReadDataAddress[11 : 2]),
    //     .dina(registerReadData2),
    //     .douta(freshMemoryReadData)
    // );

    // Register
    RegFile registers(
        .clk(cpuClk),
        .rst(rst),
        .readRegister1(readRegister1),
        .readRegister2(readRegister2),
        .writeRegister(writeRegister),
        .writeData(registerWriteData),
        .writeEnable(regWrite),
        .readData1(freshRegisterReadData1),
        .readData2(freshRegisterReadData2),
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
                displayContent = {cpuClkCounter[3:0], 4'b0000, state[3:0], pcOut[3:0]};
            end
            3: begin
                // debug
                // displayContent = {cpuClkCounter, state[3:0], 3'b0, BTN[2], 3'b0, rst};
                displayContent = {instruction[15:0]};
            end
        endcase
    end

    // __output__
    // 8 bit LED
    assign LED[7] = manualClk;
    assign LED[6] = clk;
    assign LED[5] = rst;
    assign LED[4] = 0;
    assign LED[3:0] = state;

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
        .nums(pcOut),  // show PC
        .points(8'b0),
        .SEG_CLK(SEG_CLK),
        .SEG_DT(SEG_DT)
    );

endmodule // Top
