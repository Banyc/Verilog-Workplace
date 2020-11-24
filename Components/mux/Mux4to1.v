`ifndef _Mux4to1
`define _Mux4to1

// Mux4to1 mux4to1_1(.S(Scan), .I0(Point[0]), .I1(Point[1]), .I2(Point[2]), .I3(Point[3]), .O(P));

module Mux4to1(
    input wire [1:0] S,
    input wire I0,
    input wire I1,
    input wire I2,
    input wire I3,
    output wire O
);
    reg o;
    always @* begin
        case (S)
            2'b00:
                o = I0; 
            2'b01:
                o = I1; 
            2'b10:
                o = I2; 
            2'b11:
                o = I3; 
            default: begin
                // exception
            end
        endcase
    end

    assign O = o;

endmodule

`endif
