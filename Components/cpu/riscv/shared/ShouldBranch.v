`ifndef __ShouldBranch__
`define __ShouldBranch__

module ShouldBranch (
    isBne,
    isBeq,
    isBranchEqual,
    shouldBranch
);
    input wire isBne;
    input wire isBeq;
    input wire isBranchEqual;
    output reg shouldBranch;
    
    always @(*) begin
        if (isBeq && isBranchEqual
        || isBne && !isBranchEqual) begin
            shouldBranch = 1;
        end else begin
            shouldBranch = 0;
        end
    end

endmodule

`endif
