
`include "./Components/register/Register4b.v"
`include "./Components/button/Load_Gen.v"
`include "./Components/clock/clkdiv.v"
`include "./Components/adder/AddSub4b.v"
`include "./Components/hexDisplay/DispNum.v"

module Top(
    clk,
    SW,
    AN,
    SEGMENT,
    LED
);
    input wire clk;
    input wire [15:0] SW;
    output wire [3:0] AN;
    output wire [7:0] SEGMENT;
    output wire [7:0] LED;

    wire Load_A;
	wire [3:0] A,  A_IN, A1;
	wire [31:0] clk_div;

	Register4b RegA(.clk(clk), .In(A_IN), .Load(Load_A), .Out(A));

	Load_Gen m0(.clk(clk), .clk_1ms(clk_div[17]), .btn_in(SW[2]),
		 .Load_out(Load_A));  //寄存器A的Load信号

	clkdiv m3(clk, 1'b0, clk_div);

	AddSub4b m4(.A(A), .B(4'b0001), .Ctrl(SW[0]), .S(A1));  //自增/自减逻辑

    // select which as input to its register
	assign A_IN = (SW[15] == 1'b0) ? A1 : 4'b0000;  //2选1多路复用器，复位寄存器初值

	DispNum m8(.clk(clk), .hexs({A, A1, A_IN, 4'b0000}), .les(4'b0001), 
		.points(4'b0), .rst(1'b0), .an(AN), .segment(SEGMENT));

	// assign LED = 8'b11111111;
	assign LED = 8'b0;

endmodule // Top
