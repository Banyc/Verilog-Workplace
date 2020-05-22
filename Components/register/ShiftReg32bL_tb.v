// test branch
`include "./Components/register/ShiftReg32bL.v"

module ShiftReg32bL_tb(
    
);

    reg clk;
    reg S_L;  // 并行输入命令 ~S / L
    reg s_in;  // shift_in, 串行输入
    reg [31:0] p_in;  // par_in, 并行输入数据
    wire [31:0] Q;  // output

    ShiftReg32bL UUT(clk, 1'b1, S_L, s_in, p_in, Q);

    initial begin
        $dumpfile("ShiftReg32bL_tb.vcd");
        $dumpvars(0, ShiftReg32bL_tb);

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
		p_in = 32'h12345678;
		#500;

    end

    always begin
		clk = 0; #20;
		clk = 1; #20;
	end

endmodule // ShiftReg32bL_tb
