`ifndef __clk_2to1__
`define __clk_2to1__

module clk_2to1(input clk200P, clk200N, rst, output clk200MHz);
    IBUFDS sclk(
        .I(clk200P),
        .IB(clk200N),
        .O(clk200MHz)
    );
endmodule

`endif
