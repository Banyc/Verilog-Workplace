`include "./Components/cpu/mips/multiCycleCpu/MultiCycleCpu.v"

module MultiCycleCpu_tb(

);

    reg clk;

    wire cpuClk;
    assign cpuClk = clk;
    reg rst;
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
    reg [4:0] readRegisterDebug;
    wire [31:0] readDataDebug;

    wire manualClk;
    wire clkMode;  // 0: manual; 1: auto

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
        .pcOut(pcOut)
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
    //     .addra(memoryReadDataAddress[10 : 2]),
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

    wire integer pcHuman;
    // assign pcHuman = pcOut/4 + 1;
    assign pcHuman = pcOut/4;

    // integer idx;
    initial begin
        $dumpfile("MultiCycleCpu_tb.vcd"); $dumpvars(0, MultiCycleCpu_tb);
        // for (idx = 1; idx < 32; idx = idx + 1)
        //     $dumpvars(0, uut.registers.memory[idx]);
        $dumpvars(0, registers.memory[1]);
        $dumpvars(0, registers.memory[2]);
        $dumpvars(0, registers.memory[3]);
        $dumpvars(0, registers.memory[4]);
        $dumpvars(0, registers.memory[5]);
        $dumpvars(0, registers.memory[6]);
        $dumpvars(0, registers.memory[7]);
        $dumpvars(0, registers.memory[8]);
        $dumpvars(0, registers.memory[9]);
        $dumpvars(0, registers.memory[10]);
        $dumpvars(0, registers.memory[11]);
        $dumpvars(0, registers.memory[12]);
        $dumpvars(0, registers.memory[13]);
        $dumpvars(0, registers.memory[14]);
        $dumpvars(0, registers.memory[15]);
        $dumpvars(0, registers.memory[16]);
        $dumpvars(0, registers.memory[17]);
        $dumpvars(0, registers.memory[18]);
        $dumpvars(0, registers.memory[19]);
        $dumpvars(0, registers.memory[20]);
        $dumpvars(0, registers.memory[21]);
        $dumpvars(0, registers.memory[22]);
        $dumpvars(0, registers.memory[23]);
        $dumpvars(0, registers.memory[24]);
        $dumpvars(0, registers.memory[25]);
        $dumpvars(0, registers.memory[26]);
        $dumpvars(0, registers.memory[27]);
        $dumpvars(0, registers.memory[28]);
        $dumpvars(0, registers.memory[29]);
        $dumpvars(0, registers.memory[30]);
        $dumpvars(0, registers.memory[31]);

        // $monitor("instruction: %b, clock:%b\n", instruction, clk);
        $monitor("instruction: %b, PC: %d", instruction, pcHuman);
        readRegisterDebug = 1;
        rst = 0;
        # 12;
        rst = 1;
        # 10;
        rst = 0;
        
        // $display("instruction: %b, PC: %d, clock:%b", instruction, pcOut/4 + 1, clk);

        
        # 10;

        // #10000; $finish;
        #90000; $finish;
    end

    always begin
        // $display("instruction: %b, PC: %d, clock:%b", instruction, pcOut/4 + 1, clk);
        clk = 0;
        #10;
        clk = 1;
        #10;
    end

endmodule // Top
