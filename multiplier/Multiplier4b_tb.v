`include "./multiplier/Multiplier4b.v"

module Multiplier4b_tb(
    
);
    reg c;
    reg [3:0] a;
    reg [3:0] b;
    wire [7:0] p;

    Multiplier4b uut(
        c,
        a,
        b,
        p
    );

    initial begin
        $dumpfile("Multiplier4b_tb.vcd"); $dumpvars(0, Multiplier4b_tb);
        c = 0;
        a = 4'h0;        
        b = 4'h7;

        # 10;

        c = 0;
        a = 4'h1;        
        b = 4'h7;
        
        # 10;

        c = 0;
        a = 4'h2;        
        b = 4'h7;

        # 10;

        c = 0;
        a = 4'h3;        
        b = 4'h7;

        # 10;

        c = 0;
        a = 4'h3;        
        b = 4'hf;

        # 10;

        c = 1;
        a = 4'h0;        
        b = 4'h7;

        # 10;

        c = 1;
        a = 4'h1;        
        b = 4'h7;
        
        # 10;

        c = 1;
        a = 4'h2;        
        b = 4'h7;

        # 10;

        c = 1;
        a = 4'h3;        
        b = 4'h7;
        
        # 10;
        
        c = 1;
        a = 4'h3;        
        b = 4'hf;

        # 10;
    end

endmodule // Multiplier4b_tb
