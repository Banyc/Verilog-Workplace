`ifndef __LatencyRom_v__
`define __LatencyRom_v__

`include "Components/memory/rom32b.v"

// read finishes at `posedge clk`
module LatencyRom(
    clk,
    rst,
    en,
    addr,
    data_out,
    hasFinished  // only persists for one `clk` circle.
);
    input wire  clk;
    input wire  rst;
    input wire  en;
    input wire  [31:0] addr;
    output wire [31:0] data_out;
    output reg  hasFinished;  // only persists for one `clk` circle.

    reg [3:0] clkdiv = 0; 

    always @ (posedge clk)begin
        if (rst) clkdiv <= 0;
        else clkdiv <= clkdiv + 1;
    end

    wire clk_latency;
    assign clk_latency = clkdiv[3];

    wire hasTaskTriggered = !clk_latency;

`include "Components/memory/LatencyMainLogic.vh"

    Rom32b memory(
        .rst(rst),
        .readAddress(addr[31:0]),
        .data(data_out[31:0])
    );
endmodule

`endif
