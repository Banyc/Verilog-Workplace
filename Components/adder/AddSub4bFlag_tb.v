`include "./Components/adder/AddSub4bFlag.v"

module AddSub4bFlag_tb(
    
);
    reg [3:0] A;
    reg [3:0] B;
    reg  Ci;
    reg  Ctrl;
    wire [3:0] S;
    wire  CF,OF,ZF,SF,PF;  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF

    AddSub4bFlag uut(
        A,
        B,
        Ci,
        Ctrl,
        S,
        CF,OF,ZF,SF,PF
    );

    initial begin
        $dumpfile("AddSub4bFlag_tb.vcd"); $dumpvars(0, AddSub4bFlag_tb);
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

    end

endmodule // AddSub4bFlag_tb