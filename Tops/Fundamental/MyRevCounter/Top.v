// MyRevCounter

`include "./Components/clock/clk_100ms.v"
`include "./Components/io/hexDisplay/DispNum.v"
`include "./Components/counter/Counter16bRev.v"

module Top(
	input wire clk,
    input wire SW,
	output wire LED,
	output wire [3:0]AN,
	output wire [7:0]SEGMENT
	); 

	wire [15:0] nums;
	wire clk_100ms;

	// clock
	clk_100ms m0(clk, clk_100ms);

	Counter16bRev m1(
		.clk(clk_100ms), 
		.s(SW), 
		.cnt(nums), 
		.Rc(LED));
	DispNum m6(
		.clk(clk), 
		.hexs(nums), 
		.les(4'b0), 
		.points(4'b0), 
		.rst(1'b0), 
		.an(AN), 
		.segment(SEGMENT));
endmodule
