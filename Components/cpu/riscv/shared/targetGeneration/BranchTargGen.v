`ifndef __BranchTargGen__
`define __BranchTargGen__

module BranchTargGen (
    pc,
    instruction,
    target
);
    input wire [31:0] pc;
    input wire [31:0] instruction;
    output wire [31:0] target;

    // TODO: review
    wire [31:0] immediate;
    assign immediate = {
        // 19'b0,
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12] (the extended sign)
        instruction[31],  // imm[12]
        instruction[7],  // imm[11]
        instruction[30:25],  // imm[10:5]
        instruction[11:8],  // imm[4:1]
        1'b0
    };

    assign target = pc + immediate;

endmodule

`endif
