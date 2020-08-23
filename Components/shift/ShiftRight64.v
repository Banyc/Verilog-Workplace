`ifndef __ShiftRight64
`define __ShiftRight64

module ShiftRight64 (
    clk,
    isShiftRight,
    isWrite,
    d,
    q
);
    input wire clk;
    input wire isShiftRight;
    input wire isWrite;
    input wire [63:0] d;
    output reg [63:0] q;

    always @(posedge clk) begin
        case ({isShiftRight, isWrite})
            2'b00: begin
                q <= q;
            end
            2'b01: begin
                q <= d;
            end
            2'b10: begin
                q <= {q[63], q[63:1]};
            end
            2'b11: begin
                q <= {d[63], d[63:1]};
            end
        endcase
    end
endmodule
`endif
