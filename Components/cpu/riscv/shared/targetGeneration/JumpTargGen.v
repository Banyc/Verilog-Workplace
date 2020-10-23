`ifndef __JumpTargGen__
`define __JumpTargGen__

`include "Components/cpu/riscv/shared/immediateExtend/32bits/JTypeSignExtend32b.v"

// unconditional jump to (PC + immediate)
module JumpTargGen (
    pc,
    instruction,
    target
);
    input wire [31:0] pc;
    input wire [31:0] instruction;
    output wire [31:0] target;

    wire [31:0] immediate;
    JTypeSignExtend32b jTypeSignExtend32b_inst(
        .instruction(instruction),
        .signExtended(immediate)
    );

    assign target = pc + immediate;

endmodule

`endif
