`ifndef __EnumOpcode__
`define __EnumOpcode__

// riscv-spec.pdf #130

`define riscv32_opcode_LUI   7'b0110111
`define riscv32_opcode_JAL   7'b1101111
`define riscv32_opcode_JALR  7'b1100111
// branch
`define riscv32_opcode_BEQ   7'b1100011
`define riscv32_opcode_BNE   7'b1100011
// load/store
`define riscv32_opcode_LW    7'b0000011
`define riscv32_opcode_SW    7'b0100011
// arithmatics
`define riscv32_opcode_ADDI  7'b0010011
`define riscv32_opcode_SLTI  7'b0010011
`define riscv32_opcode_SLTIU 7'b0010011
`define riscv32_opcode_XORI  7'b0010011
`define riscv32_opcode_ORI   7'b0010011
`define riscv32_opcode_ANDI  7'b0010011
`define riscv32_opcode_SLLI  7'b0010011
`define riscv32_opcode_SRLI  7'b0010011
`define riscv32_opcode_SRAI  7'b0010011
`define riscv32_opcode_ADD   7'b0110011
`define riscv32_opcode_SUB   7'b0110011
`define riscv32_opcode_SLL   7'b0110011
`define riscv32_opcode_SLT   7'b0110011
`define riscv32_opcode_SLTU  7'b0110011
`define riscv32_opcode_XOR   7'b0110011
`define riscv32_opcode_SRL   7'b0110011
`define riscv32_opcode_SRA   7'b0110011
`define riscv32_opcode_OR    7'b0110011
`define riscv32_opcode_AND   7'b0110011

`endif
