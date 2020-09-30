`ifndef __JumpRegTargGen__
`define __JumpRegTargGen__

// jalr
// JUMP TO REGISTER
module JumpRegTargGen (
    iTypeSignExtend,
    rs1,
    target
);

    input wire [31:0] iTypeSignExtend;
    input wire [31:0] rs1;
    output wire [31:0] target;
    
    assign target = rs1 + iTypeSignExtend;

endmodule

`endif
