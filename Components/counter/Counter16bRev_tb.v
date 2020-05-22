`include "./Components/counter/Counter16bRev.v"

module Counter16bRev_tb(
    
);
    reg clk;
    reg s;
    wire [15:0] cnt;
    wire Rc;

    Counter16bRev UUT(.clk(clk), .s(s), .cnt(cnt), .Rc(Rc));

    initial begin
        $dumpfile("Counter16bRev_tb.vcd");
        $dumpvars(0, Counter16bRev_tb);
        clk = 0;
        s = 1;
        #320;
        #10;
        s = 0;
    end

    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

endmodule // Counter16bRev_tb
