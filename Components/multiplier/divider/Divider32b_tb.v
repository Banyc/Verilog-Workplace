`include "./Components/multiplier/divider/Divider32b.v"

module Divider32b_tb(
    
);
    reg clk;
    reg [31:0] a;
    reg [31:0] b;
    reg start;
    wire finish;
    wire [32:0] quo;
    wire [31:0] rem;

    Divider32b uut(
        clk,
        a,
        b,
        quo,
        rem,
        start,  // positive to start
        finish
    );

    initial begin
        $dumpfile("Divider32b_tb.vcd"); $dumpvars(0, Divider32b_tb);
        clk = 0;
        a = 351;  //  15F
        b = 23;  // 17
        // 15...6
        // 0xF...6
        start = 0;

        # 5;

        start = 1;
        # 10;
        start = 0;

        # 10;
        
        # 3000;
        
        a = 3;
        b = 3;

        start = 1;
        # 20;
        start = 0;

        # 3000;

        a = 32'h7;
        b = 32'h2;

        start = 1;
        # 20;
        start = 0;
        
        # 3000;

        a = 32'h7;
        b = 32'hfffffffe;

        start = 1;
        # 20;
        start = 0;
        
        # 3000;

        a = 32'hfffffff9;
        b = 32'hfffffffe;

        start = 1;
        # 20;
        start = 0;
        
        # 3000;

        a = 32'hfffffff9;
        b = 32'h2;

        start = 1;
        # 20;
        start = 0;

        # 10000; $finish;
    end

    always begin
        #5;
        clk <= ~clk;
    end

endmodule
