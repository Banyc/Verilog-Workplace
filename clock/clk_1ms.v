
`ifndef _clk_1ms
`define _clk_1ms

module clk_1ms(
    clk_100mhz,
    clk_1ms
);
    input wire clk_100mhz;
    output reg clk_1ms;

    reg [27:0]counter;

    initial begin
        counter = 0;
        clk_1ms = 0;
    end

    always @(posedge clk_100mhz) begin
        counter = counter + 1;
        if (counter >= 50000) begin
            clk_1ms = ~clk_1ms;
            counter = 0;
        end
    end

endmodule // clk_1ms

`endif
