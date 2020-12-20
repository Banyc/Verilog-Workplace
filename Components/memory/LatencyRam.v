`ifndef __LatencyRam_v__
`define __LatencyRam_v__

`include "Components/memory/ram32b.v"

// both write and read finish at `posedge clk`
module LatencyRam(
    clk,
    rst,
    en,
    we,
    addr,
    data_in,
    data_out,
    hasFinished  // only persists for one `clk` circle.
);
    input wire  clk;
    input wire  rst;
    input wire  en;
    input wire  we;
    input wire  [31:0] addr;
    input wire  [31:0] data_in;
    output wire [31:0] data_out;
    output reg  hasFinished;  // only persists for one `clk` circle.

    reg [3:0] clkdiv = 0; 

    always @ (posedge clk)begin
        if (rst) clkdiv <= 0;
        else clkdiv <= clkdiv + 1;
    end

    wire clk_latency;
    assign clk_latency = clkdiv[3];

    wire hasTaskTriggered =  we && clk_latency || !we && !clk_latency;

`include "Components/memory/LatencyMainLogic.vh"

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
