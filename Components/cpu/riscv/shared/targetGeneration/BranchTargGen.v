`ifndef __BranchTargGen__
`define __BranchTargGen__

`include "Components/cpu/riscv/shared/immediateExtend/32bits/BTypeSignExtend32b.v"

module BranchTargGen (
    pc,
    instruction,
    target
);
    input wire [31:0] pc;
    input wire [31:0] instruction;
    output wire [31:0] target;

    wire [31:0] immediate;
    BTypeSignExtend32b bTypeSignExtend32b_inst(
        .instruction(instruction),
        .signExtended(immediate)
    );

    assign target = pc + immediate;

endmodule

`endif
