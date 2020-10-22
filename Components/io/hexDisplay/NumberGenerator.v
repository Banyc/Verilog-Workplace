// `timescale 1ns / 1ps
// initiate number
`include "./Components/adder/AddSub4b.v"

// NumberGenerator m3(.num_event({2'b00, btn_out}), .sw({2'b00, SW1}), .num(num));

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:34:53 10/28/2019 
// Design Name: 
// Module Name:    NumberGenerator 
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
module NumberGenerator(
    input wire [3:0] num_event,
    input wire [3:0] sw,  // decide if addup or subtract when a num_event is coming  // [mode] 0: addup; 1: subtract
    output reg [15:0] num
    );
    wire [3:0] A, B, C, D;

    initial num <= 16'b1010_1011_1100_1101; //display "AbCd"

    // assign A = num[ 3: 0] + 4'd1;
    // assign B = num[ 7: 4] + 4'd1;
    // assign C = num[11: 8] + 4'd1;
    // assign D = num[15:12] + 4'd1;
    AddSub4b a1(.A(num[ 3: 0]), .B(4'd1), .Ctrl(sw[0]), .S(A));
    AddSub4b a2(.A(num[ 7: 4]), .B(4'd1), .Ctrl(sw[1]), .S(B));
    AddSub4b a3(.A(num[11: 8]), .B(4'd1), .Ctrl(sw[2]), .S(C));
    AddSub4b a4(.A(num[15:12]), .B(4'd1), .Ctrl(sw[3]), .S(D));

    always @ (posedge num_event[0]) begin
        num[ 3: 0] <= A; 
    end
    always @ (posedge num_event[1]) num[ 7: 4] <= B;
    always @ (posedge num_event[2]) num[11: 8] <= C;
    always @ (posedge num_event[3]) num[15:12] <= D;
endmodule
