`include "./counter/Counter4b.v"

// Verilog test fixture created from schematic D:\MEGAsync\circuits\ISE\MyCounter\Counter4b.sch - Wed Nov 20 10:51:21 2019

`timescale 1ns / 1ps

module Counter4b_tb();

// Inputs
    reg clk;

// Output
    wire Qb;
    wire Qc;
    wire Qd;
    wire Qa;
    wire Rc;

// Bidirs
    // reg integer i;

// Instantiate the UUT
    Counter4b UUT (
		.clk(clk), 
		.Qb(Qb), 
		.Qc(Qc), 
		.Qd(Qd), 
		.Qa(Qa), 
		.Rc(Rc)
    );
// Initialize Inputs
    initial begin
        $dumpfile("Counter4b_tb.vcd");
        $dumpvars(0, Counter4b_tb);
	    clk = 0;
    end

    always begin
        clk = 0; #10;
        clk = 1; #10;
    end
endmodule
