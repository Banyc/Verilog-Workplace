// MyCounter

`include "./Components/clock/clk_1s.v"
`include "./Components/hexDisplay/DispNum.v"
`include "./Components/counter/Counter4b.v"

module top(
	input wire clk,
	output wire LED,
	output wire [3:0]AN,
	output wire [7:0]SEGMENT
	); 

	wire [15:0] nums;
	wire clk_1s;

	// clock
	clk_1s m0(clk, clk_1s);

	Counter4b m1(
		.clk(clk_1s), 
		.Qa(nums[0]), 
		.Qb(nums[1]), 
		.Qc(nums[2]), 
		.Qd(nums[3]), 
		.Rc(LED));
	DispNum m6(
		.clk(clk), 
		.hexs({12'b0, nums[3:0]}), 
		.les(4'b1110), 
		.points(4'b0), 
		.rst(1'b0), 
		.an(AN), 
		.segment(SEGMENT));
endmodule
