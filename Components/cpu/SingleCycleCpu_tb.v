`include "./Components/cpu/SingleCycleCpu.v"

module SingleCycleCpu_tb(
    
);
    reg clk;
    reg rst;
    wire [31:0] instruction;
    wire [31:0] pcOut;

    SingleCycleCpu uut(
        clk,
        rst,
        instruction,
        pcOut
    );

    initial begin
        $dumpfile("SingleCycleCpu_tb.vcd"); $dumpvars(0, SingleCycleCpu_tb);
        // $monitor("instruction: %b, clock:%b\n", instruction, clk);
        rst = 0;
        # 12;
        rst = 1;
        # 10;
        rst = 0;
        
        // $display("instruction: %b, PC: %d, clock:%b", instruction, pcOut/4 + 1, clk);

        
        # 10;

        #2000; $finish;
    end

    always begin
        $display("instruction: %b, PC: %d, clock:%b", instruction, pcOut/4 + 1, clk);
        clk = 0;
        #10;
        clk = 1;
        #10;
    end

endmodule // SingleCycleCpu_tb
