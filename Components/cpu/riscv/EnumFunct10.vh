`ifndef __EnumFunct10_vh__
`define __EnumFunct10_vh__

// Funct10 = funct7 + funct3

// riscv-spec.pdf #130

`define riscv32_funct10_SLLI  10'b0000000001
`define riscv32_funct10_SRLI  10'b0000000101
`define riscv32_funct10_SRAI  10'b0100000101
`define riscv32_funct10_ADD   10'b0000000000
`define riscv32_funct10_SUB   10'b0100000000
`define riscv32_funct10_SLL   10'b0000000001
`define riscv32_funct10_SLT   10'b0000000010
`define riscv32_funct10_SLTU  10'b0000000011
`define riscv32_funct10_XOR   10'b0000000100
`define riscv32_funct10_SRL   10'b0000000101
`define riscv32_funct10_SRA   10'b0100000101
`define riscv32_funct10_OR    10'b0000000110
`define riscv32_funct10_AND   10'b0000000111

`endif
