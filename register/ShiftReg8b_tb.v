// test branch
`include "./register/ShiftReg8b.v"

module ShiftReg8b_tb(
    
);

    reg clk;
    reg S_L;  // 并行输入命令 ~S / L
    reg s_in;  // shift_in, 串行输入
    reg [7:0] p_in;  // par_in, 并行输入数据
    wire [7:0] Q;  // output

    ShiftReg8b UUT(clk, S_L, s_in, p_in, Q);

    initial begin
        $dumpfile("ShiftReg8b_tb.vcd");
        $dumpvars(0, ShiftReg8b_tb);

        // Initialize Inputs
		clk = 0;
		S_L = 0;
		s_in = 0;
		p_in = 0;

		#100;
        
		// Add stimulus here
		S_L = 0;
		s_in = 1;
		p_in =0;
        #200;
		S_L = 1;
		s_in = 0;
		p_in = 8'b0101_0101;
		#500;

    end

    always begin
		clk = 0; #20;
		clk = 1; #20;
	end

endmodule // ShiftReg8b_tb
