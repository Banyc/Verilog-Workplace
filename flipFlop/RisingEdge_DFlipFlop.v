`ifndef RisingEdge_DFlipFlop
`define RisingEdge_DFlipFlop

// FPGA projects using Verilog/ VHDL 
// fpga4student.com
// Verilog code for D Flip FLop
// Verilog code for rising edge D flip flop 
module RisingEdge_DFlipFlop(
    D, clk, Q
);
    input wire D; // Data input 
    input wire clk; // clock input 
    output reg Q; // output Q 

    initial begin
        Q <= 0;
    end

    always @(posedge clk) begin
        Q <= D; 
    end 
endmodule 

`endif
