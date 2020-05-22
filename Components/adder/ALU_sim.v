`include "./Components/adder/ALU.v"
// Verilog test fixture created from schematic D:\MEGAsync\circuits\ISE\MyALU\MyALU.sch - Thu Oct 31 22:07:07 2019

`timescale 1ns / 1ps

module ALU_ALU_sch_tb();

// Inputs
   reg [1:0] S;
   reg [3:0] A;
   reg [3:0] B;

// Output
   wire [3:0] C;
   wire Co;

// Bidirs

// Instantiate the UUT
   ALU UUT (
		.S(S), 
		.A(A), 
		.B(B), 
		.C(C), 
		.Co(Co)
   );

   initial begin
$dumpfile("ALU_sim.vcd"); $dumpvars(0, ALU_ALU_sch_tb);   
   end

// Initialize Inputs
   integer i;
   initial begin
		S = 0;
		A = 0;
		B = 0;

      for (i = 0; i < 1024; i = i + 1) begin
         #10;
         {S, A, B} = i;
      end
   end
endmodule
