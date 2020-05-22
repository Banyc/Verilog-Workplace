
module Random_generator(
	input wire clk,
	input wire init,  // positive edge
	input wire [3:0] seed,
	output reg [9:0] x,
	output reg [8:0] y
    );

	reg [9:0] x_gen = 446;
	reg [8:0] y_gen = 324;
	
	reg old_init;

	initial begin
		x = 90;
		y = 80;
	end

	always @(posedge clk) begin
		old_init <= init;
	end

	always @(posedge clk) begin
		if (init == 1 && old_init == 1) begin
			x_gen[0] <= seed[0] ^ seed[1];
			x_gen[1] <= seed[2] ^ x_gen[0];
			x_gen[2] <= x_gen[0] ^ x_gen[1];
			x_gen[3] <= x_gen[1] ^ x_gen[2];
			x_gen[4] <= x_gen[2] ^ x_gen[3];
			x_gen[5] <= x_gen[3] ^ x_gen[4];
			x_gen[6] <= x_gen[4] ^ x_gen[5];
			x_gen[7] <= x_gen[5] ^ x_gen[6];
			x_gen[8] <= x_gen[6] ^ x_gen[7];
			x_gen[9] <= x_gen[7] ^ x_gen[8];
		end 
		x_gen[0] <= x_gen[1] ^ x_gen[2];
		x_gen[1] <= x_gen[2] ^ x_gen[3];
		x_gen[2] <= x_gen[3] ^ x_gen[4];
		x_gen[3] <= x_gen[4] ^ x_gen[5];
		x_gen[4] <= x_gen[5] ^ x_gen[6];
		x_gen[5] <= x_gen[6] ^ x_gen[7];
		x_gen[6] <= x_gen[7] ^ x_gen[8];
		x_gen[7] <= x_gen[8] ^ x_gen[9];
		x_gen[8] <= x_gen[9] ^ x_gen[0];
		x_gen[9] <= x_gen[0] ^ x_gen[1];
	end

	always @(posedge clk) begin
		if (init == 1 && old_init == 1) begin
			y_gen[0] <= seed[1] ^ seed[2];
			y_gen[1] <= seed[3] ^ y_gen[0];
			y_gen[2] <= y_gen[0] ^ y_gen[1];
			y_gen[3] <= y_gen[1] ^ y_gen[2];
			y_gen[4] <= y_gen[2] ^ y_gen[3];
			y_gen[5] <= y_gen[3] ^ y_gen[4];
			y_gen[6] <= y_gen[4] ^ y_gen[5];
			y_gen[7] <= y_gen[5] ^ y_gen[6];
			y_gen[8] <= y_gen[6] ^ y_gen[7];
		end
		y_gen[0] <= y_gen[1] ^ y_gen[2];
		y_gen[1] <= y_gen[2] ^ y_gen[3];
		y_gen[2] <= y_gen[3] ^ y_gen[4];
		y_gen[3] <= y_gen[4] ^ y_gen[5];
		y_gen[4] <= y_gen[5] ^ y_gen[6];
		y_gen[5] <= y_gen[6] ^ y_gen[7];
		y_gen[6] <= y_gen[7] ^ y_gen[8];
		y_gen[7] <= y_gen[8] ^ y_gen[0];
		y_gen[8] <= y_gen[0] ^ y_gen[1];
	end

	always @(posedge clk)
	begin
        x <= 10 * (x_gen % 54);
	end

	always @(posedge clk)
	begin
        y <= 10 * (y_gen % 38);
	end

endmodule // Random_generator
