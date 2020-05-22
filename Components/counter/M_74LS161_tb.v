`include "./Components/counter/M_74LS161.v"

module M_74LS161_tb(
    
);
    reg CR;
    reg LD;
    reg CT_P;
    reg CT_T;
    reg CP;
    reg [3:0] D;
    wire [3:0] Q;
    wire CO;

    M_74LS161 UUT(CR, LD, CT_P, CT_T, CP, D, Q, CO);

    initial begin
        CR = 0;
        LD = 0;
        CT_P = 0;
        CT_T = 0;
        D = 0;

        # 100;
        CR = 1;
        LD = 1;
        CT_P = 0;
        CT_T = 0;
        D = 4'b1100;

        #30 CR = 0;
		#20 CR = 1;
		#10 LD = 0;
		#30 CT_T = 1;
		CT_P = 1;
		#10 LD = 1;

		#510;
		CR = 0;
		#20 CR = 1;

		#500;
        $finish;
    end

    always begin
        CP <= 0;
        # 17;
        CP <= 1;
        # 17;
    end


endmodule // M_74LS161_tb
