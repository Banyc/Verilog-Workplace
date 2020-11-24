`ifndef _Mux2to1_5b
`define _Mux2to1_5b

module Mux2to1_5b(
    input wire S,
    input wire [4:0] I0,
    input wire [4:0] I1,
    output reg [4:0] O
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
