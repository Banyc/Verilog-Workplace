`ifndef __PcSelUpdater__
`define __PcSelUpdater__

`include "Components/cpu/riscv/shared/ShouldBranch.v"
`include "Components/cpu/riscv/5stage/EnumSelections.vh"

module PcSelUpdater (
    isBne,
    isBeq,
    isBranchEqual,
    oldPcSel,
    newPcSel
);
    input wire isBne;
    input wire isBeq;
    input wire isBranchEqual;
    input wire [1:0] oldPcSel;
    output wire [1:0] newPcSel;

    wire shouldBranch;
    ShouldBranch shouldBranch_inst(
        .isBne(),
        .isBeq(),
        .isBranchEqual(),
        .shouldBranch(shouldBranch)
    );

    assign newPcSel
        = shouldBranch ? `riscv32_5stage_pc_sel_jumpOrBranch
                       : oldPcSel
                       ;
    
endmodule

`endif
