`include "./Components/comparator/Comparator4b.v"

module Comparator4b_tb(
    
);
    reg [3:0] A;
    reg [3:0] B;
    wire ZF, SLTu, SLT;

    Comparator4b uut(
        A,
        B,
        ZF, SLTu, SLT
    );

    initial begin
        $dumpfile("Comparator4b_tb.vcd"); $dumpvars(0, Comparator4b_tb);
        A = 4'h7;
        B = 4'he;
        
        # 10;

        A = 4'he;
        B = 4'h7;
        
        # 10;

        A = 4'h3;
        B = 4'h6;

        # 10;

        A = 4'h6;
        B = 4'h3;

        # 10;

        A = 4'h6;
        B = 4'h6;

        # 10;
    end

endmodule // Comparator4b_tb
