`ifndef __LatencyRam_v__
`define __LatencyRam_v__

`include "Components/memory/ram32b.v"


module LatencyRam(
    input clk,
    input rst,
    input en,
    input we,
    input [31:0] addr,
    input [31:0] data_in,
    output [31:0] data_out,
    output reg isFinish
);

reg [31:0] clkdiv = 0; 

always @ (posedge clk)begin
    if (rst) clkdiv <= 0;
    else clkdiv <= clkdiv + 1;
end

wire clk_latency;
assign clk_latency = clkdiv[3];

// limits the positive time of `isFinish` to only one `clk` circle.
reg shouldDeactivateFinish;

wire hasTaskTriggered =  we && clk_latency || !we && !clk_latency;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        isFinish = 0;
        shouldDeactivateFinish = 1;
    end else begin
        if (en & hasTaskTriggered && !shouldDeactivateFinish) begin
            isFinish = 1;
            shouldDeactivateFinish = 0;
        end else begin
            isFinish = 0;
            if (hasTaskTriggered) begin
                shouldDeactivateFinish = 1;
            end else begin
                // prepare for the next `posedge hasTaskTriggered`
                shouldDeactivateFinish = 0;
            end
        end
    end
end

Ram32b ram(
    .clk(clk_latency),
    .rst(rst),
    .address(addr[31:0]),
    .readEnable(en && !we),
    .writeEnable(en && we),
    .writeData(data_in[31:0]),
    .readData(data_out[31:0])
);
endmodule

`endif
