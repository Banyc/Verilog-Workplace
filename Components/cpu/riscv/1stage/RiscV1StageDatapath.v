
`ifndef __RiscV1StageDatapath__
`define __RiscV1StageDatapath__

`include "Components/mux/Mux2to1_32b.v"
`include "Components/mux/Mux4to1_32b.v"
`include "Components/mux/Mux8to1_32b.v"
`include "Components/register/Pc.v"
`include "Components/register/RegFile.v"
// `include "Components/register/Register32b.v"
`include "Components/adder/Alu32b_extended.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/ITypeSignExtend32b.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/ShamtSignExtend32b.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/STypeSignExtend32b.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/UType32b.v"
`include "Components/cpu/riscv/shared/targetGeneration/BranchTargGen.v"
`include "Components/cpu/riscv/shared/targetGeneration/JumpRegTargGen.v"
`include "Components/cpu/riscv/shared/targetGeneration/JumpTargGen.v"
`include "Components/cpu/riscv/shared/BranchCondGen.v"
`include "Components/cpu/riscv/1stage/RiscV1StageControl.v"


module RiscV1StageDatapath (
    clk,
    rst,
    // ROM
    pc,
    instruction,
    // RAM
    aluOut,
    memoryReadEnable,
    memoryWriteEnable,
    rs2,
    memoryOut,
    // Registers
    readRegisterDebug,
    readDataDebug
);
    input wire clk;
    input wire rst;
    input wire [4:0] readRegisterDebug;
    output wire [31:0] readDataDebug;

    // MUXs
    wire [31:0] pc_sel_out;
    wire [31:0] op2Sel_out;
    wire [31:0] op1Sel_out;
    wire [31:0] wb_sel_out;

    // 32 bits outputs
    output wire [31:0] pc;
    wire [31:0] pc_4;
    input wire [31:0] instruction;
    wire [31:0] branch;
    wire [31:0] jump;
    wire [31:0] jalr;
    wire [31:0] rs1;
    output wire [31:0] rs2;
    wire [31:0] iTypeSignExtend;
    wire [31:0] shamtSignExtend;
    wire [31:0] sTypeSignExtend;
    wire [31:0] uTypeImmediate;
    output wire [31:0] aluOut;
    input wire [31:0] memoryOut;

    // control signals
    wire is_br_eq;
    wire [3:0] aluFunction;
    wire [1:0] op1Sel;
    wire [2:0] op2Sel;
    wire [2:0] pc_sel;
    wire [1:0] wb_sel;
    wire rf_wen;  // reg file write enable
    output wire memoryWriteEnable;
    output wire memoryReadEnable;

    // begin: MUX for PC input datapath
    Mux8to1_32b pc_selMux_instr(
        .S(pc_sel),
        .I0(pc_4),
        .I1(jalr),
        .I2(branch),
        .I3(jump),
        .I4(32'b0),
        .I5(32'b0),
        .I6(32'b0),
        .I7(32'b0),
        .O(pc_sel_out)
    );
    // end: MUX for PC input datapath

    // begin: PC datapath
    Pc pc_instr(
        .clk(clk),
        .rst(rst),
        .enableWrite(1'b1),
        .d(pc_sel_out),
        .q(pc)
    );
    assign pc_4 = pc + 4;
    // end: PC datapath

    // // begin: ROM datapath
    // Rom32b rom32b_instr(
    //     .rst(rst),
    //     .readAddress(pc),
    //     .data(instruction)
    // );
    // // end: ROM datapath

    // begin: target generation datapath
    BranchTargGen branchTargGen_instr(
        .pc(pc),
        .instruction(instruction),
        .target(branch)
    );
    JumpRegTargGen jumpRegTargGen_instr(
        .iTypeSignExtend(iTypeSignExtend),
        .rs1(rs1),
        .target(jalr)
    );
    JumpTargGen jumpTargGen_instr(
        .pc(pc),
        .instruction(instruction),
        .target(jump)
    );
    // end: target generation datapath

    // begin: immediate extend datapath
    ITypeSignExtend32b iTypeSignExtend32b_instr(
        .instruction(instruction),
        .signExtended(iTypeSignExtend)
    );
    ShamtSignExtend32b shamtSignExtend32b_instr(
        .instruction(instruction),
        .signExtended(shamtSignExtend)
    );
    STypeSignExtend32b sTypeSignExtend32b_instr(
        .instruction(instruction),
        .signExtended(sTypeSignExtend)
    );
    UType32b uType32b_instr(
        .instruction(instruction),
        .extended(uTypeImmediate)
    );
    // end: immediate extend datapath 

    // begin: condition generation
    BranchCondGen BranchCondGen_instr(
        .rs1(rs1),
        .rs2(rs2),
        .is_br_eq(is_br_eq),
        .is_br_lt(),
        .is_br_ltu()
    );
    // end: condition generation

    // begin: RegFile datapath
    RegFile regFile_instr(
        .clk(clk),
        .rst(rst),
        .readRegister1(instruction[19:15]),
        .readRegister2(instruction[24:20]),
        .writeRegister(instruction[11:7]),
        .writeData(wb_sel_out),
        .writeEnable(rf_wen),

        .readData1(rs1),
        .readData2(rs2),

        // debug only
        .readRegisterDebug(readRegisterDebug),
        .readDataDebug(readDataDebug)
    );
    // end: RegFile datapath

    // begin: Control datapath
    RiscV1StageControl decoder(
        .instruction(instruction),
        .isBranchEqual(is_br_eq),

        .pcSelect(pc_sel),
        .op2Select(op2Sel),
        .op1Select(op1Sel),
        .aluFunction(aluFunction),
        .writebackSelect(wb_sel),
        .regFileWriteEnable(rf_wen),
        .memoryReadEnable(memoryReadEnable),
        .memoryWriteEnable(memoryWriteEnable)
    );
    // end: Control datapath

    // begin: MUX for ALU input datapath
    Mux8to1_32b op2SelMux_instr(
        .S(op2Sel),
        .I0(pc),
        .I1(iTypeSignExtend),
        .I2(sTypeSignExtend),
        .I3(rs2),
        .I4(32'b0),
        .I5(shamtSignExtend),
        .I6(32'b0),
        .I7(32'b0),
        .O(op2Sel_out)
    );
    Mux4to1_32b op1SelMux_instr(
        .S(op1Sel),
        .I0(rs1),
        .I1(uTypeImmediate),
        .I2(32'h4),
        .I3(32'b0),
        .O(op1Sel_out)
    );
    // end: MUX for ALU input datapath
    
    // begin: ALU datapath
    Alu32b_extended alu32b_instr(
        .aluOp(aluFunction),
        .leftOperand(op1Sel_out),
        .rightOperand(op2Sel_out),
        .aluResult(aluOut)
    );
    // end: ALU datapath

    // begin: MUX for RegFile input datapath
    Mux4to1_32b wb_selMux_instr(
        .S(wb_sel),
        .I0(32'b0),
        .I1(pc_4),
        .I2(aluOut),
        .I3(memoryOut),
        .O(wb_sel_out)
    );
    // end: MUX for RegFile input datapath

    // // begin: RAM datapath
    // Ram32b ram32b_instr(
    //     .clk(clk),
    //     .rst(rst),
    //     .address(aluOut),
    //     .readEnable(memoryReadEnable),
    //     .writeEnable(memoryWriteEnable),
    //     .writeData(rs2),
    //     .readData(memoryOut)
    // );
    // // end: RAM datapath

endmodule

`endif
