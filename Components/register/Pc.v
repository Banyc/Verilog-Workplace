`ifndef __Pc__
`define __Pc__

module Pc(
    clk,
    rst,
    d,
    q
);
    input wire clk;
    input wire rst;
    input wire [31:0] d;
    output reg [31:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // q <= 32'h00400020;
            q <= 32'h00000000;
        end else begin
            q <= d;
        end
    end

endmodule // Pc

`endif
