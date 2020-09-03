`include "./Components/multiplier/Multiplier4bu.v"

module Multiplier4bu_tb(
    
);
    reg [3:0] a;
    reg [3:0] b;
    wire [7:0] p;

    Multiplier4bu uut(
        a,
        b,
        p
    );

    initial begin
        $dumpfile("Multiplier4bu_tb.vcd"); $dumpvars(0, Multiplier4bu_tb);
        a = 4'h0;        
        b = 4'h7;

        # 10;

        a = 4'h1;        
        b = 4'h7;
        
        # 10;

        a = 4'h2;        
        b = 4'h7;

        # 10;

        a = 4'h3;        
        b = 4'h7;

        # 10;
    end

endmodule // Multiplier4bu_tb
