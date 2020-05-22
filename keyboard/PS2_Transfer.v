`include "./keyboard/PS2.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:49:13 12/25/2019 
// Design Name: 
// Module Name:    PS2_Transfer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PS2_Transfer(
    input clk, //100mhz
    input PS2_clk, PS2_data,
    output reg [3:0] PS2_ret  
);

wire [9:0] ps2_out;
reg [9:0] data;

PS2 ps2part(.clk(clk), .rst(), .ps2_clk(PS2_clk), .ps2_data(PS2_data), .ps2_out(ps2_out), .ready());

always @(posedge clk) begin
    data <= ps2_out;
	case (data)
        10'h275:PS2_ret <= 4'b0001; //up
        10'h375:PS2_ret <= 4'b0000; 
        10'h272:PS2_ret <= 4'b0010; //down
        10'h372:PS2_ret <= 4'b0000;
		10'h26B:PS2_ret <= 4'b0100; //left
        10'h36B:PS2_ret <= 4'b0000;
        10'h274:PS2_ret <= 4'b1000; //right
        10'h374:PS2_ret <= 4'b0000;
    endcase
end

endmodule 
