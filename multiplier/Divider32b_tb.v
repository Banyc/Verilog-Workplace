`include "./multiplier/Divider32b.v"

module Divider32b_tb(
    
);
    reg clk;
    reg [31:0] a;
    reg [31:0] b;
    reg rst;
    wire finish;
    wire [31:0] q;
    wire [31:0] r;

    Divider32b uut(
        clk,
        a,
        b,
        q,
        r,
        rst,
        finish
    );

    initial begin
        $dumpfile("Divider32b_tb.vcd"); $dumpvars(0, Divider32b_tb);
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
        
        a = 32'hfffffff9;  // -7
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
