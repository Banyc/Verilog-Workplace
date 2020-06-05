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

    initial begin
        $dumpfile("MultiCycleCpu_tb.vcd"); $dumpvars(0, MultiCycleCpu_tb);
        // $monitor("instruction: %b, clock:%b\n", instruction, clk);
        rst = 0;
        # 12;
        rst = 1;
        # 10;
        rst = 0;
        
        // $display("instruction: %b, PC: %d, clock:%b", instruction, pcOut/4 + 1, clk);

        
        # 10;

        #3000; $finish;
    end

    always begin
        $display("instruction: %b, PC: %d, clock:%b", instruction, pcOut/4 + 1, clk);
        clk = 0;
        #10;
        clk = 1;
        #10;
    end

endmodule // MultiCycleCpu_tb
