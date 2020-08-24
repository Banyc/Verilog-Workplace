`include "./Components/multiplier/multiplier/Multiplier32b.v"

module Multiplier32b_tb(
    
);
    reg clk;
    reg [31:0] a;
    reg [31:0] b;
    reg start;
    wire finish;
    wire [63:0] p;

    Multiplier32b uut(
        clk,
        a,
        b,
        p,
        start,
        finish
    );

    initial begin
        $dumpfile("Multiplier32b_tb.vcd"); $dumpvars(0, Multiplier32b_tb);
        clk = 0;
        a = 351;  //  15F
        b = 23;  // 17
        // 1F89
        start = 0;

        # 5;

        start = 1;
        # 10;
        start = 0;

        # 10;
        
        a = 3;
        b = 3;
        // 9
        
        # 3000;

        start = 1;
        # 20;
        start = 0;

        # 3000;

        a = 32'h7fffffff;
        // a = 2147483647;
        b = 32'h7fffffff;
        // b = 2147483647;
        // 4611686014132420609
        // 0x3FFFFFFF00000001

        start = 1;
        # 20;
        start = 0;
        
        # 3000;

        start = 1;
        # 20;
        start = 0;

        a = 32'hffffffff;
        b = 32'hffffffff;
        // 0xFFFF FFFE 0000 0001

        # 10000; $finish;
    end

    always begin
        #5;
        clk <= ~clk;
    end

endmodule
