
`ifndef _clk_1s
`define _clk_1s

module clk_1s(
    clk_100mhz,
    clk_1s
);
    input wire clk_100mhz;
    output reg clk_1s;

    reg [27:0]counter;

    initial begin
        counter = 0;
        clk_1s = 0;
    end

    always @(posedge clk_100mhz) begin
        counter = counter + 1;
        if (counter >= 50000000) begin
            clk_1s = ~clk_1s;
            counter = 0;
        end
    end

endmodule // clk_1s

`endif
