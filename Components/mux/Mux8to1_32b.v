`ifndef _Mux8to1_32b
`define _Mux8to1_32b

module Mux8to1_32b(
    input wire [2:0] S,
    input wire [31:0] I0,
    input wire [31:0] I1,
    input wire [31:0] I2,
    input wire [31:0] I3,
    input wire [31:0] I4,
    input wire [31:0] I5,
    input wire [31:0] I6,
    input wire [31:0] I7,
    output reg [31:0] O
);

    always @ * begin
        case (S)
            0:
                O <= I0;
            1:
                O <= I1;
            2:
                O <= I2;
            3:
                O <= I3;
            4:
                O <= I4;
            5:
                O <= I5;
            6:
                O <= I6;
            7:
                O <= I7;
        endcase
    end

endmodule

`endif
