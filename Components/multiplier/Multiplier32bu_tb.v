`include "./Components/multiplier/Multiplier32bu.v"

module Multiplier32bu_tb(
    
);
    reg clk;
    reg [31:0] a;
    reg [31:0] b;
    reg start;
    wire finish;
    wire [63:0] p;


    Multiplier32bu uut(
        clk,
        a,
        b,
        p,
        start,
        finish
    );

    initial begin
        $dumpfile("Multiplier32bu_tb.vcd"); $dumpvars(0, Multiplier32bu_tb);
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
        
        a = 10;
        b = 32;
        // 140
        
        # 1000;

        start = 1;

        # 20;

        start = 0;

    end

    always begin
        #5;
        clk <= ~clk;
    end

endmodule // Multiplier4b2u_tb
