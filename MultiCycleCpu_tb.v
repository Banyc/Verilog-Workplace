`include "./Components/cpu/MultiCycleCpu.v"

module MultiCycleCpu_tb(
    
);
    reg clk;
    reg rst;
    wire [31:0] instruction;
    wire [31:0] pcOut;

    MultiCycleCpu uut(
        clk,
        rst,
        instruction,
        pcOut
    );

    wire integer pcHuman;
    assign pcHuman = pcOut/4 + 1;

    // integer idx;
    initial begin
        $dumpfile("MultiCycleCpu_tb.vcd"); $dumpvars(0, MultiCycleCpu_tb);
        // for (idx = 1; idx < 32; idx = idx + 1)
        //     $dumpvars(0, uut.registers.memory[idx]);
        $dumpvars(0, uut.registers.memory[1]);
        $dumpvars(0, uut.registers.memory[2]);
        $dumpvars(0, uut.registers.memory[3]);
        $dumpvars(0, uut.registers.memory[4]);
        $dumpvars(0, uut.registers.memory[5]);
        $dumpvars(0, uut.registers.memory[6]);
        $dumpvars(0, uut.registers.memory[7]);
        $dumpvars(0, uut.registers.memory[8]);
        $dumpvars(0, uut.registers.memory[9]);
        $dumpvars(0, uut.registers.memory[10]);
        $dumpvars(0, uut.registers.memory[11]);
        $dumpvars(0, uut.registers.memory[12]);
        $dumpvars(0, uut.registers.memory[13]);
        $dumpvars(0, uut.registers.memory[14]);
        $dumpvars(0, uut.registers.memory[15]);
        $dumpvars(0, uut.registers.memory[16]);
        $dumpvars(0, uut.registers.memory[17]);
        $dumpvars(0, uut.registers.memory[18]);
        $dumpvars(0, uut.registers.memory[19]);
        $dumpvars(0, uut.registers.memory[20]);
        $dumpvars(0, uut.registers.memory[21]);
        $dumpvars(0, uut.registers.memory[22]);
        $dumpvars(0, uut.registers.memory[23]);
        $dumpvars(0, uut.registers.memory[24]);
        $dumpvars(0, uut.registers.memory[25]);
        $dumpvars(0, uut.registers.memory[26]);
        $dumpvars(0, uut.registers.memory[27]);
        $dumpvars(0, uut.registers.memory[28]);
        $dumpvars(0, uut.registers.memory[29]);
        $dumpvars(0, uut.registers.memory[30]);
        $dumpvars(0, uut.registers.memory[31]);

        // $monitor("instruction: %b, clock:%b\n", instruction, clk);
        $monitor("instruction: %b, PC: %d", instruction, pcHuman);
        rst = 0;
        # 12;
        rst = 1;
        # 10;
        rst = 0;
        
        // $display("instruction: %b, PC: %d, clock:%b", instruction, pcOut/4 + 1, clk);

        
        # 10;

        #10000; $finish;
    end

    always begin
        // $display("instruction: %b, PC: %d, clock:%b", instruction, pcOut/4 + 1, clk);
        clk = 0;
        #10;
        clk = 1;
        #10;
    end

endmodule // MultiCycleCpu_tb
