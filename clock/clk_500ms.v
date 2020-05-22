
`ifndef _clk_500ms
`define _clk_500ms

module clk_500ms(
    clk_100mhz,
    clk_500ms
);
    input wire clk_100mhz;
    output reg clk_500ms;

    reg [27:0]counter;

    initial begin
        counter = 0;
        clk_500ms = 0;
    end

    always @(posedge clk_100mhz) begin
        counter = counter + 1;
        if (counter >= 25000000) begin
            clk_500ms = ~clk_500ms;
            counter = 0;
        end
    end

endmodule // clk_500ms

`endif
