
`include "./Components/register/Register4b.v"
`include "./Components/io/button/Load_Gen.v"
`include "./Components/clock/clkdiv.v"
`include "./Components/adder/AddSub4b.v"
`include "./Components/io/hexDisplay/DispNum.v"
`include "./Components/mux/Mux4to1b4.v"

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
    wire Load_B;
    wire Load_C;

	wire [3:0] A, A_IN, A1;
	wire [3:0] B, B_IN, B1;
	wire [3:0] C, C_IN;

	wire [31:0] clk_div;

    wire [3:0] bus;

	Register4b RegA(.clk(clk), .In(A_IN), .Load(Load_A), .Out(A));  // dynamic
	Register4b RegB(.clk(clk), .In(B_IN), .Load(Load_B), .Out(B));  // dynamic
	Register4b RegC(.clk(clk), .In(C_IN), .Load(Load_C), .Out(C));  // static

	Load_Gen m0(.clk(clk), .clk_1ms(clk_div[17]), .btn_in(SW[2]),
		 .Load_out(Load_A));  //寄存器A的Load信号
	Load_Gen m1(.clk(clk), .clk_1ms(clk_div[17]), .btn_in(SW[3]),
		 .Load_out(Load_B));  //寄存器B的Load信号
	Load_Gen m2(.clk(clk), .clk_1ms(clk_div[17]), .btn_in(SW[4]),
		 .Load_out(Load_C));  //寄存器C的Load信号

	clkdiv m3(clk, 1'b0, clk_div);

	AddSub4b m4(.A(A), .B(4'b0001), .Ctrl(SW[0]), .S(A1));  //自增/自减逻辑
	AddSub4b m5(.A(B), .B(4'b0001), .Ctrl(SW[1]), .S(B1));  //自增/自减逻辑

	// reg transition
    Mux4to1b4 m6(.S(SW[8:7]), .I0(A), .I1(B), .I2(C), .I3(4'b0), .O(bus));
	
	// select which as input to its register
	assign A_IN = (SW[15] == 1'b0) ? A1 : bus;  // mux2to1, 1 to value of either register
	assign B_IN = (SW[15] == 1'b0) ? B1 : bus;  // mux2to1, 1 to value of either register
	assign C_IN = (SW[15] == 1'b0) ? 4'b0 : bus;  // mux2to1, 0: 0; 1: value of either register

	DispNum m8(.clk(clk), .hexs({A, B, 4'b0000, C}), .les(4'b0010),
		.points(4'b0), .rst(1'b0), .an(AN), .segment(SEGMENT));

	// assign LED = 8'b11111111;
	assign LED = 8'b0;

endmodule // Top
