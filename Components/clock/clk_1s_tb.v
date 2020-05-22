`timescale 10ns / 10ns

`include "./Components/clock/clk_1s.v"

module clk_1s_tb(
    
);
    reg clk_100mhz;
    wire clk_1s_out;

    clk_1s UUT(clk_100mhz, clk_1s_out);

    initial begin
        $dumpfile("clk_1s_tb.vcd");
        $dumpvars(0, clk_1s_tb);
    end

    always begin
        clk_100mhz = 0; #1;
        clk_100mhz = 1; #1;
    end

endmodule // clk_1s_tb
