`include "./Components/cpu/riscv/1stage/RiscV1StageDatapathNativeWrap.v"

module RiscV1StageDatapathNativeWrap_tb(

);

    reg clk;

    wire cpuClk;
    assign cpuClk = clk;
    reg rst;
    wire [31:0] instruction;
    wire [31:0] pc;
    reg [4:0] readRegisterDebug;
    wire [31:0] readDataDebug;

    wire manualClk;
    wire clkMode;  // 0: manual; 1: auto

    // __subject__
    // CPU
    RiscV1StageDatapathNativeWrap cpuWrap(
        .clk(cpuClk),
        .rst(rst),
        // debug
        .instruction(instruction),
        .pc(pc),
        // Registers
        .readRegisterDebug(readRegisterDebug),
        .readDataDebug(readDataDebug)
    );

    // __inner states__

    wire integer pcHuman;
    assign pcHuman = pc/4 + 1;
    // assign pcHuman = pcOut/4;

    // integer idx;
    initial begin
        $dumpfile("RiscV1StageDatapathNativeWrap_tb.vcd"); $dumpvars(0, RiscV1StageDatapathNativeWrap_tb);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[1]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[2]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[3]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[4]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[5]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[6]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[7]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[8]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[9]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[10]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[11]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[12]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[13]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[14]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[15]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[16]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[17]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[18]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[19]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[20]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[21]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[22]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[23]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[24]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[25]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[26]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[27]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[28]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[29]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[30]);
        $dumpvars(0, cpuWrap.cpu.regFile_inst.memory[31]);

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
