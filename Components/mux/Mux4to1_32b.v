`ifndef _Mux4to1_32b
`define _Mux4to1_32b

module Mux4to1_32b(
    input wire [1:0] S,
    input wire [31:0] I0,
    input wire [31:0] I1,
    input wire [31:0] I2,
    input wire [31:0] I3,
    output reg [31:0] O
);

    always @ * begin
        case (S)
            2'b00:
                O <= I0;
            2'b01:
                O <= I1;
            2'b10:
                O <= I2;
            2'b11:
                O <= I3;
            default: begin
                // exception
                O <= 0;
            end
        endcase
    end

endmodule

`endif
