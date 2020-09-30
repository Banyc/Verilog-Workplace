`include "./Components/cpu/riscv/1stage/RiscV1StageDatapath.v"

module RiscV1StageDatapath_tb(

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
    RiscV1StageDatapath cpu(
        .clk(cpuClk),
        .rst(rst),
        // custom outputs
        .instruction(instruction),
        .pc(pcOut)
    );

    // __inner states__

    wire integer pcHuman;
    assign pcHuman = pcOut/4 + 1;
    // assign pcHuman = pcOut/4;

    // integer idx;
    initial begin
        $dumpfile("RiscV1StageDatapath_tb.vcd"); $dumpvars(0, RiscV1StageDatapath_tb);
        $dumpvars(0, cpu.regFile_instr.memory[1]);
        $dumpvars(0, cpu.regFile_instr.memory[2]);
        $dumpvars(0, cpu.regFile_instr.memory[3]);
        $dumpvars(0, cpu.regFile_instr.memory[4]);
        $dumpvars(0, cpu.regFile_instr.memory[5]);
        $dumpvars(0, cpu.regFile_instr.memory[6]);
        $dumpvars(0, cpu.regFile_instr.memory[7]);
        $dumpvars(0, cpu.regFile_instr.memory[8]);
        $dumpvars(0, cpu.regFile_instr.memory[9]);
        $dumpvars(0, cpu.regFile_instr.memory[10]);
        $dumpvars(0, cpu.regFile_instr.memory[11]);
        $dumpvars(0, cpu.regFile_instr.memory[12]);
        $dumpvars(0, cpu.regFile_instr.memory[13]);
        $dumpvars(0, cpu.regFile_instr.memory[14]);
        $dumpvars(0, cpu.regFile_instr.memory[15]);
        $dumpvars(0, cpu.regFile_instr.memory[16]);
        $dumpvars(0, cpu.regFile_instr.memory[17]);
        $dumpvars(0, cpu.regFile_instr.memory[18]);
        $dumpvars(0, cpu.regFile_instr.memory[19]);
        $dumpvars(0, cpu.regFile_instr.memory[20]);
        $dumpvars(0, cpu.regFile_instr.memory[21]);
        $dumpvars(0, cpu.regFile_instr.memory[22]);
        $dumpvars(0, cpu.regFile_instr.memory[23]);
        $dumpvars(0, cpu.regFile_instr.memory[24]);
        $dumpvars(0, cpu.regFile_instr.memory[25]);
        $dumpvars(0, cpu.regFile_instr.memory[26]);
        $dumpvars(0, cpu.regFile_instr.memory[27]);
        $dumpvars(0, cpu.regFile_instr.memory[28]);
        $dumpvars(0, cpu.regFile_instr.memory[29]);
        $dumpvars(0, cpu.regFile_instr.memory[30]);
        $dumpvars(0, cpu.regFile_instr.memory[31]);

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
