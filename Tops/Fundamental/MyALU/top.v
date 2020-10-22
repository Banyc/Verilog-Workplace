// MyALU

`include "./Components/clock/clkdiv.v"
`include "./Components/io/button/pbdebounce.v"
`include "./Components/io/hexDisplay/NumberGenerator.v"
`include "./Components/adder/ALU.v"
`include "./Components/io/hexDisplay/DispNum.v"

module top(
	input wire clk,
	input wire [1:0]BTN,
	input wire [1:0]SW1,  // decide whether addup or subtract A and B at the display
	input wire [1:0]SW2,  // mode index for ALU
	output wire [3:0]AN,
	output wire [7:0]SEGMENT,
	output wire BTNX4  // 0: enable btn
	); 

	wire [15:0] num;
	wire [1:0] btn_out;
	wire [3:0] C;
	wire Co;
	wire [31:0] clk_div;
	wire [15:0] disp_hexs;
	assign disp_hexs[15:12] = num[3:0];	//A
	assign disp_hexs[11:8] = num[7:4];	//B
	assign disp_hexs[7:4] = {3'b000, Co};
	assign disp_hexs[3:0] = C[3:0];

	pbdebounce m0(.clk_1ms(clk_div[17]), .button(BTN[0]), .pbreg(btn_out[0]));
 	pbdebounce m1(.clk_1ms(clk_div[17]), .button(BTN[1]), .pbreg(btn_out[1]));
	clkdiv m2(.clk(clk), .rst(1'b0),.clkdiv(clk_div));
	NumberGenerator m3(.num_event({2'b00, btn_out}), .sw({2'b00, SW1}), .num(num));	// initiate number A and B
	ALU m5(.S(SW2), .A(num[3:0]), .B(num[7:4]), .C(C), .Co(Co)); // 
	DispNum m6(.clk(clk), .hexs(disp_hexs), .les(4'b0), .points(4'b0), .rst(1'b0), .an(AN), .segment(SEGMENT));
	assign BTNX4 = 1'b0;	//Enable button inputs
endmodule
