`include "./random/Random_generator.v"

module Random_generator_tb(
    
);

    reg clk;
	reg init;  // positive edge
	reg [3:0] seed;
    wire [9:0] x;
    wire [8:0] y;

    Random_generator UUT(clk, init, seed, x, y);

    initial begin
        init = 0;
        seed = 0;

        # 17;
        seed = 13;
        
        # 17;
        init = 1;

    end

    always begin
        clk <= 0;
        # 10;
        clk <= 1;
        # 10;
    end

endmodule // Random_generator_tb