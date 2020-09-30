`ifndef __Alu32b_simple__
`define __Alu32b_simple__

module Alu32b_simple(
    aluOp,
    leftOperand,
    rightOperand,
    aluResult
);
    input wire [3:0] aluOp;
    input wire [31:0] leftOperand;
    input wire [31:0] rightOperand;
    output reg [31:0] aluResult;

    wire [31:0] sourceA;
    wire [31:0] sourceB;
    assign sourceA = aluOp[3] ? ~leftOperand : leftOperand;
    assign sourceB = aluOp[2] ? ~rightOperand : rightOperand;

    wire [31:0] sum;
    assign sum = sourceA + sourceB;

    always @(*) begin
        case (aluOp[1:0])
            0: begin
                aluResult <= sourceA & sourceB;
            end
            1: begin
                aluResult <= sourceA | sourceB;
            end
            2: begin
                aluResult <= sum;
            end
            3: begin
                aluResult <= {
                    31'b0,
                    sum[31]
                };
            end
        endcase
    end
    
endmodule // Alu32b_simple

`endif
