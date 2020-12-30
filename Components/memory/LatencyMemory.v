`ifndef __LatencyMemory_v__
`define __LatencyMemory_v__


// both write and read finish at `posedge clk`
module LatencyMemory(
    clk,
    clk_latency,  // it is the clock of the external memory
    rst,
    en,
    we,
    hasFinished  // only persists for one `clk` circle.
);
    input wire  clk;
    input wire  rst;
    input wire  en;
    input wire  we;
    output reg  hasFinished;  // only persists for one `clk` circle.

    reg [3:0] clkdiv = 0; 

    always @ (posedge clk)begin
        if (rst) clkdiv <= 0;
        else clkdiv <= clkdiv + 1;
    end

    output wire clk_latency;
    assign clk_latency = clkdiv[3];

    wire hasTaskTriggered =  we && clk_latency || !we && !clk_latency;

`include "Components/memory/LatencyMainLogic.vh"

endmodule

`endif
