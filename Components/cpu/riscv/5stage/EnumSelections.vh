`ifndef __EnumSelections_vh__
`define __EnumSelections_vh__

`define riscv32_5stage_pc_sel_pc_4 0
`define riscv32_5stage_pc_sel_jumpOrBranch 1
`define riscv32_5stage_pc_sel_jalr 2

`define riscv32_5stage_op2Sel_rs2 0
`define riscv32_5stage_op2Sel_bTypeSignExtend 1
`define riscv32_5stage_op2Sel_iTypeSignExtend 2
`define riscv32_5stage_op2Sel_uTypeImmediate 3
`define riscv32_5stage_op2Sel_jTypeSignExtend 4
`define riscv32_5stage_op2Sel_sTypeSignExtend 5
`define riscv32_5stage_op2Sel_shamtSignExtend 6
`define riscv32_5stage_op2Sel_zero 7

`define riscv32_5stage_op1Sel_if_pc 0
`define riscv32_5stage_op1Sel_rs1 1
`define riscv32_5stage_op1Sel_zero 2

`define riscv32_5stage_exe_wb_sel_pc_4 0
`define riscv32_5stage_exe_wb_sel_aluOut 1

`define riscv32_5stage_mem_wb_sel_aluOut 1
`define riscv32_5stage_mem_wb_sel_memoryReadData 2

`endif
