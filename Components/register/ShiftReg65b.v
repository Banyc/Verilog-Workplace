`ifndef __ShiftReg65b
`define __ShiftReg65b

`define ShiftReg65b_Operation_DoNothing 3'b000
`define ShiftReg65b_Operation_ShiftLeftArithmetic 3'b001
`define ShiftReg65b_Operation_ShiftRightArithmetic 3'b010
`define ShiftReg65b_Operation_ShiftLeftLogical 3'b011
`define ShiftReg65b_Operation_ShiftRightLogical 3'b100
`define ShiftReg65b_Operation_ShiftLeftCustom 3'b101
`define ShiftReg65b_Operation_ShiftRightCustom 3'b110
`define ShiftReg65b_Operation_WriteD 3'b111

module ShiftReg65b (
    clk,
    operation,
    shiftIn,  // serial input
    d,
    q
);
    input wire clk;
    input wire [2:0] operation;
    input wire shiftIn;
    input wire [64:0] d;
    output reg [64:0] q;

    always @(posedge clk) begin
        case (operation)
            `ShiftReg65b_Operation_DoNothing: begin
                q <= q;
            end
            `ShiftReg65b_Operation_WriteD: begin
                q <= d;
            end
            `ShiftReg65b_Operation_ShiftRightArithmetic: begin
                q <= {q[64], q[64:1]};
            end
            `ShiftReg65b_Operation_ShiftLeftArithmetic: begin
                q <= {q[63:0], q[0]};
            end
            `ShiftReg65b_Operation_ShiftRightLogical: begin
                q <= {1'b0, q[64:1]};
            end
            `ShiftReg65b_Operation_ShiftLeftLogical: begin
                q <= {q[63:0], 1'b0};
            end
            `ShiftReg65b_Operation_ShiftRightCustom: begin
                q <= {shiftIn, q[64:1]};
            end
            `ShiftReg65b_Operation_ShiftLeftCustom: begin
                q <= {q[63:0], shiftIn};
            end
        endcase
    end
endmodule
`endif
