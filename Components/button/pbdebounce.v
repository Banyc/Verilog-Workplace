// reduce the bouncing electric signals when pressing a button

module pbdebounce(
    input wire clk_1ms,
	input wire button, 
	output reg pbreg
);

    reg [7:0] pbshift;

	always @(posedge clk_1ms) begin
		pbshift = pbshift << 1;  // purge the leftest bit and make room for the new incoming bit to the rightest bit position
		pbshift[0] = button;  // record button state at the newly available space
		if (pbshift == 8'b0)
			pbreg = 0;
		if (pbshift == 8'hFF)  // contigeous pressing signal of button is made
			pbreg = 1;	
	end

endmodule
