
`ifndef _clk_100ms
`define _clk_100ms

module clk_100ms(
    clk_100mhz,
    clk_100ms
);
    input wire clk_100mhz;
    output reg clk_100ms;

    reg [27:0]counter;

    initial begin
        counter = 0;
        clk_100ms = 0;
    end

    always @(posedge clk_100mhz) begin
        counter = counter + 1;
        if (counter >= 5000000) begin
            clk_100ms = ~clk_100ms;
            counter = 0;
        end
    end

endmodule // clk_100ms

`endif
