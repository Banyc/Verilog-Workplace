`ifndef _Mux2to1_32b
`define _Mux2to1_32b

module Mux2to1_32b(
    input wire S,
    input wire [31:0] I0,
    input wire [31:0] I1,
    output reg [31:0] O
);

    always @ * begin
        case (S)
            1'b0:
                O <= I0;
            1'b1:
                O <= I1;
            default: begin
                // exception
            end
        endcase
    end

endmodule

`endif
