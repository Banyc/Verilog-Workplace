`include "./Components/multiplier/Divider32bu.v"

module Divider32bu_tb(
    
);
    reg clk;
    reg [31:0] a;
    reg [31:0] b;
    reg rst;
    wire finish;
    wire [31:0] q;
    wire [31:0] r;

    Divider32bu uut(
        clk,
        a,
        b,
        q,
        r,
        rst,
        finish
    );

    initial begin
        $dumpfile("Divider32bu_tb.vcd"); $dumpvars(0, Divider32bu_tb);
        clk = 0;
        a = 10;  //  0xA
        b = 3;  // 3
        // 3 ... 1
        rst = 0;

        # 5;

        rst = 1;

        # 10;

        rst = 0;

        # 10;
        
        a = 7;  // 0x7
        b = 32;  // 0x20
        // 0 ... 0x7
        
        # 1000;

        rst = 1;

        # 20;

        rst = 0;

    end

    always begin
        #5;
        clk <= ~clk;
    end

endmodule // Multiplier4b2u_tb
