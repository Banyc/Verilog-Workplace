
`ifndef __Register4b 
`define __Register4b
// `include "./Components/flipFlop/RisingEdge_DFlipFlop.v"

module Register4b(
    clk, Load, In,
    Out
);
    input wire clk;
    input wire Load;
    input wire [3:0] In;
    output reg [3:0] Out;

    initial begin
        Out <= 0;
    end

    always @(posedge clk) begin
        if (Load) begin
            Out <= In;
        end
    end
endmodule // Register4b
`endif
