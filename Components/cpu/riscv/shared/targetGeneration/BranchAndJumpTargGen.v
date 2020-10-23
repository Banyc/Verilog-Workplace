`ifndef __BranchAndJumpTargGen__
`define __BranchAndJumpTargGen__

module BranchAndJumpTargGen (
    pc,
    immediate,
    target
);
    input wire [31:0] pc;
    input wire [31:0] immediate;
    output wire [31:0] target;

    assign target = pc + immediate;

endmodule

`endif
