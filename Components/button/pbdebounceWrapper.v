// reduce the bouncing electric signals when pressing a button

`include "./Components/clock/clkdiv.v"
`include "./Components/button/pbdebounce.v"

module pbdebounceWrapper(
    input wire clk,
	input wire button, 
	output wire pbreg
);
	wire [31:0] clk_div;

	clkdiv m2(.clk(clk), .rst(1'b0), .clkdiv(clk_div));
	pbdebounce m0(.clk_1ms(clk_div[17]), .button(button), .pbreg(pbreg));

endmodule
