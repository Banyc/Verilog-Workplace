`ifndef __EnumFunct3_vh__
`define __EnumFunct3_vh__

// riscv-spec.pdf #130

`define riscv32_funct3_JALR  3'b000
`define riscv32_funct3_BEQ   3'b000
`define riscv32_funct3_BNE   3'b001
`define riscv32_funct3_LB    3'b000
`define riscv32_funct3_LH    3'b001
`define riscv32_funct3_LW    3'b010
`define riscv32_funct3_LBU   3'b100
`define riscv32_funct3_LHU   3'b101
`define riscv32_funct3_SB    3'b000
`define riscv32_funct3_SH    3'b001
`define riscv32_funct3_SW    3'b010
`define riscv32_funct3_ADDI  3'b000
`define riscv32_funct3_SLTI  3'b010
`define riscv32_funct3_SLTIU 3'b011
`define riscv32_funct3_XORI  3'b100
`define riscv32_funct3_ORI   3'b110
`define riscv32_funct3_ANDI  3'b111
`define riscv32_funct3_SLLI  3'b001
`define riscv32_funct3_SRLI  3'b101
`define riscv32_funct3_SRAI  3'b101
// `define riscv32_funct3_ADD   3'b000
// `define riscv32_funct3_SUB   3'b000
`define riscv32_funct3_ADD_SUB   3'b000
`define riscv32_funct3_SLL   3'b001
`define riscv32_funct3_SLT   3'b010
`define riscv32_funct3_SLTU  3'b011
`define riscv32_funct3_XOR   3'b100
// `define riscv32_funct3_SRL   3'b101
// `define riscv32_funct3_SRA   3'b101
`define riscv32_funct3_SRL_SRA   3'b101
`define riscv32_funct3_OR    3'b110
`define riscv32_funct3_AND   3'b111

`endif
