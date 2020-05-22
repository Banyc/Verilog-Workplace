
`ifndef _clk_250ms
`define _clk_250ms

module clk_250ms(
    clk_100mhz,
    clk_250ms
);
    input wire clk_100mhz;
    output reg clk_250ms;

    reg [27:0]counter;

    initial begin
        counter = 0;
        clk_250ms = 0;
    end

    always @(posedge clk_100mhz) begin
        counter = counter + 1;
        if (counter >= 12500000) begin
            clk_250ms = ~clk_250ms;
            counter = 0;
        end
    end

endmodule // clk_250ms

`endif
