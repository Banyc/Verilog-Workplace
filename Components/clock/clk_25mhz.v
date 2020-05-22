
`ifndef _clk_25mhz
`define _clk_25mhz

module clk_25mhz(
    clk_100mhz,
    clk_25mhz
);
    input wire clk_100mhz;
    output reg clk_25mhz;

    reg [1:0]counter;

    initial begin
        counter = 0;
        clk_25mhz = 0;
    end

    always @(posedge clk_100mhz) begin
        counter = counter + 1;
        if (counter >= 2) begin
            clk_25mhz = ~clk_25mhz;
            counter = 0;
        end
    end

endmodule // clk_25mhz

`endif
