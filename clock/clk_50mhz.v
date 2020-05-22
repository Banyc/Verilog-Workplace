
`ifndef _clk_50mhz
`define _clk_50mhz

module clk_50mhz(
    clk_100mhz,
    clk_50mhz
);
    input wire clk_100mhz;
    output reg clk_50mhz;

    reg [1:0]counter;

    initial begin
        counter = 0;
        clk_50mhz = 0;
    end

    always @(posedge clk_100mhz) begin
        counter = counter + 1;
        if (counter >= 1) begin
            clk_50mhz = ~clk_50mhz;
            counter = 0;
        end
    end

endmodule // clk_50mhz

`endif
