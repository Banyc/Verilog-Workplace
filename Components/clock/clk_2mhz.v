
`ifndef _clk_2mhz
`define _clk_2mhz

module clk_2mhz(
    clk_100mhz,
    clk_2mhz
);
    input wire clk_100mhz;
    output reg clk_2mhz;

    reg [1:0]counter;

    initial begin
        counter = 0;
        clk_2mhz = 0;
    end

    always @(posedge clk_100mhz) begin
        counter = counter + 1;
        if (counter >= 25) begin
            clk_2mhz = ~clk_2mhz;
            counter = 0;
        end
    end

endmodule // clk_2mhz

`endif
