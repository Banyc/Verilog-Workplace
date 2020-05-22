`ifndef __Hex2BCD16b
`define __Hex2BCD16b

module Hex2BCD16b(
    hex_16bit, bcd
);

    input wire [15:0] hex_16bit;
    output reg [25:0] bcd;

    always @(hex_16bit) begin
        bcd[3:0]   <= hex_16bit % 10;
        bcd[7:4]   <= (hex_16bit / 10) % 10;
        bcd[11:8]  <= (hex_16bit / 100) % 10;
        bcd[15:12] <= (hex_16bit / 1000) % 10;
        bcd[19:16] <= (hex_16bit / 10000) % 10;
        bcd[23:20] <= (hex_16bit / 100000) % 10;
        bcd[25:24] <= (hex_16bit / 1000000) % 10;
    end

endmodule // Hex2BCD16b

`endif
