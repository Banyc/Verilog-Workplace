`ifndef __EnumSelections_vh__
`define __EnumSelections_vh__

`define riscv32_1stage_pc_sel_pc_4 0
`define riscv32_1stage_pc_sel_jalr 1
`define riscv32_1stage_pc_sel_branch 2
`define riscv32_1stage_pc_sel_jump 3
`define riscv32_1stage_pc_sel_exception 4

`define riscv32_1stage_op2Sel_pc 0
`define riscv32_1stage_op2Sel_iTypeSignExtend 1
`define riscv32_1stage_op2Sel_sTypeSignExtend 2
`define riscv32_1stage_op2Sel_rs2 3
`define riscv32_1stage_op2Sel_zero 4
`define riscv32_1stage_op2Sel_shamtSignExtend 5

`define riscv32_1stage_op1Sel_rs1 0
`define riscv32_1stage_op1Sel_uTypeImmediate 1
`define riscv32_1stage_op1Sel_four 2

`define riscv32_1stage_wb_sel_oo_processor 0
`define riscv32_1stage_wb_sel_pc_4 1
`define riscv32_1stage_wb_sel_aluOut 2
`define riscv32_1stage_wb_sel_memoryOut 3

`endif
