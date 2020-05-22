`include "./Components/adder/Adder32b.v"

module Adder32b_tb(
    
);
    reg [31:0] A;
    reg [31:0] B;
    reg  Ci;
    reg  Ctrl;
    wire [31:0] S;
    wire  CF,OF,ZF,SF,PF;  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    wire SLTu, SLT;

    Adder32b uut(
        A,
        B,
        Ci,
        Ctrl,
        S,
        CF,OF,ZF,SF,PF,
        SLTu, SLT
    );

    initial begin
        $dumpfile("Adder32b_tb.vcd"); $dumpvars(0, Adder32b_tb);
        A = 4'h1;        
        B = 4'h7;
        Ci = 0;
        Ctrl = 0;
        
        # 10;

        A = 4'h3;        
        B = 4'hf;
        Ci = 0;
        Ctrl = 1;

        # 10;

        A = 32'h80000003;        
        B = 4'hf;
        Ci = 0;
        Ctrl = 1;

        # 10;

    end

endmodule // Adder32b_tb