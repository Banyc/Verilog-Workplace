`ifndef __Shift65b
`define __Shift65b

`define Shift65b_Operation_DoNothing 3'b000
`define Shift65b_Operation_ShiftLeftArithmetic 3'b001
`define Shift65b_Operation_ShiftRightArithmetic 3'b010
`define Shift65b_Operation_ShiftLeftLogical 3'b011
`define Shift65b_Operation_ShiftRightLogical 3'b100
`define Shift65b_Operation_WriteD 3'b111

module Shift65b (
    clk,
    operation,
    d,
    q
);
    input wire clk;
    input wire [2:0] operation;
    input wire [64:0] d;
    output reg [64:0] q;

    always @(posedge clk) begin
        case (operation)
            `Shift65b_Operation_DoNothing: begin
                q <= q;
            end
            `Shift65b_Operation_WriteD: begin
                q <= d;
            end
            `Shift65b_Operation_ShiftRightArithmetic: begin
                q <= {q[64], q[64:1]};
            end
            `Shift65b_Operation_ShiftLeftArithmetic: begin
                q <= {q[63:0], q[0]};
            end
            `Shift65b_Operation_ShiftRightLogical: begin
                q <= {1'b0, q[64:1]};
            end
            `Shift65b_Operation_ShiftLeftLogical: begin
                q <= {q[63:0], 1'b0};
            end
        endcase
    end
endmodule
`endif
