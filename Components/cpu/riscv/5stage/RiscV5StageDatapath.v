`ifndef __RiscV5StageDatapath__
`define __RiscV5StageDatapath__

`include "Components/mux/Mux2to1_32b.v"
`include "Components/mux/Mux4to1_32b.v"
`include "Components/mux/Mux8to1_32b.v"
`include "Components/register/RegisterResettable32b.v"
`include "Components/register/RegFile.v"
`include "Components/register/Register32b.v"
`include "Components/adder/Alu32b_extended.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/ShamtSignExtend32b.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/ITypeSignExtend32b.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/STypeSignExtend32b.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/BTypeSignExtend32b.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/UType32b.v"
`include "Components/cpu/riscv/shared/immediateExtend/32bits/JTypeSignExtend32b.v"
`include "Components/cpu/riscv/shared/targetGeneration/JumpRegTargGen.v"
`include "Components/cpu/riscv/shared/targetGeneration/BranchAndJumpTargGen.v"
`include "Components/cpu/riscv/shared/BranchCondGen.v"
`include "Components/cpu/riscv/5stage/PcSelUpdater.v"
`include "Components/cpu/riscv/5stage/HazardDetectionUnit.v"
`include "Components/cpu/riscv/5stage/RiscV5StageControl.v"


module RiscV5StageDatapath (
    clk,
    rst,
    // ROM
    pc,
    instruction,
    // RAM
    memoryAddress,
    memoryReadEnable,
    memoryWriteEnable,
    memoryWriteData,
    memoryReadData,
    // Registers
    regFileReadRegisterDebug,
    regFileReadDataDebug
);
    input wire clk;
    input wire rst;

    // dummy outputs
    wire        dummyOutput1b_dec_controlSignals;
    wire [6:0] dummyOutput7b_dec_controlSignals;
    wire [6:0] dummyOutput7b_exe_controlSignals;
    wire [6:0] dummyOutput7b_mem_controlSignals;

    // 32 bits outputs
    output wire [31:0] pc;
    wire [31:0] pc_4;
    input wire [31:0] instruction;
    input wire [31:0] memoryReadData;

    // control signals
    output wire memoryWriteEnable;
    output wire memoryReadEnable;

    // begin: control signals
    // naming convention: fromWhere_detail
    wire       newSignal_isBne;
    wire       newSignal_isBeq;
    wire       newSignal_is_br_eq;
    wire [3:0] newSignal_aluFunction;
    wire [1:0] newSignal_op1Sel;
    wire [2:0] newSignal_op2Sel;
    wire [1:0] newSignal_pc_sel;
    wire [1:0] newSignal_mem_wb_sel;
    wire       newSignal_exe_wb_sel;
    wire       newSignal_regFileWriteEnable;
    wire       newSignal_memoryWriteEnable;
    wire       newSignal_memoryReadEnable;
    wire [4:0] newSignal_rd;
    // from HazardDetectionUnit
    wire       newSignal_if_kill;
    wire       newSignal_dec_kill;
    wire       newSignal_pcWriteEnable;

    wire       decSignal_isBne;
    wire       decSignal_isBeq;
    // wire       decSignal_is_br_eq;
    wire [3:0] decSignal_aluFunction;
    wire [1:0] decSignal_op1Sel;
    wire [2:0] decSignal_op2Sel;
    wire [1:0] decSignal_pc_sel;
    wire [1:0] decSignal_mem_wb_sel;
    wire       decSignal_exe_wb_sel;
    wire       decSignal_regFileWriteEnable;
    wire       decSignal_memoryWriteEnable;
    wire       decSignal_memoryReadEnable;
    wire [4:0] decSignal_rd;

    wire       exeSignal_isBne;
    wire       exeSignal_isBeq;
    wire       exeSignal_is_br_eq;
    wire [3:0] exeSignal_aluFunction;
    wire [1:0] exeSignal_op1Sel;
    wire [2:0] exeSignal_op2Sel;
    wire [1:0] exeSignal_pc_sel;
    wire [1:0] exeSignal_mem_wb_sel;
    wire       exeSignal_exe_wb_sel;
    wire       exeSignal_regFileWriteEnable;
    wire       exeSignal_memoryWriteEnable;
    wire       exeSignal_memoryReadEnable;
    wire [4:0] exeSignal_rd;

    wire       memSignal_isBne;
    wire       memSignal_isBeq;
    wire       memSignal_is_br_eq;
    wire [3:0] memSignal_aluFunction;
    wire [1:0] memSignal_op1Sel;
    wire [2:0] memSignal_op2Sel;
    wire [1:0] memSignal_pc_sel;
    wire [1:0] memSignal_mem_wb_sel;
    wire       memSignal_exe_wb_sel;
    wire       memSignal_regFileWriteEnable;
    wire       memSignal_memoryWriteEnable;
    wire       memSignal_memoryReadEnable;
    wire [4:0] memSignal_rd;
    // end: control signals

    // reg file
    wire [31:0] regFileWriteData;
    input wire [4:0] regFileReadRegisterDebug;
    output wire [31:0] regFileReadDataDebug;

    // memory
    output wire [31:0] memoryAddress;
    output wire [31:0] memoryWriteData;

    // ::::: Global ::::: //
    HazardDetectionUnit hazardDetectionUnit_inst(
        .pcWriteEnable(newSignal_pcWriteEnable),
        .if_kill(newSignal_if_kill),
        .dec_kill(newSignal_dec_kill),
        .dec_rs1Address(instruction[19:15]),
        .dec_rs2Address(instruction[24:20]),
        .exe_regFileWriteAddress(decSignal_rd),
        .exe_regFileWriteEnable(decSignal_regFileWriteEnable),
        .mem_regFileWriteAddress(exeSignal_rd),
        .mem_regFileWriteEnable(exeSignal_regFileWriteEnable),
        .wb_regFileWriteAddress(memSignal_rd),
        .wb_regFileWriteEnable(memSignal_regFileWriteEnable),
        .exe_isBranch(pc_sel_withBranchConsidered == `riscv32_5stage_pc_sel_jumpOrBranch)
    );

    // ::::: PC Modification Stage (writeback stage?) ::::: //
    wire [31:0] branchOrJump;
    wire [31:0] jalr;

    // begin: update pc_sel
    wire [1:0] pc_sel_withBranchConsidered;
    PcSelUpdater pcSelUpdater_inst(
        .isBne(decSignal_isBne),
        .isBeq(decSignal_isBeq),
        .isBranchEqual(newSignal_is_br_eq),
        .oldPcSel(decSignal_pc_sel),
        .newPcSel(pc_sel_withBranchConsidered)
    );
    // end: update pc_sel
    
    // begin: MUX for PC input datapath
    wire [31:0] pc_sel_out;
    Mux4to1_32b pc_sel_mux_inst(
        .S(pc_sel_withBranchConsidered),
        .I0(pc_4),
        .I1(branchOrJump),
        .I2(jalr),
        .I3(32'b0),
        .O(pc_sel_out)
    );
    // end: MUX for PC input datapath

    // begin: PC datapath
    RegisterResettable32b pc_inst(
        .clk(clk),
        .rst(rst),
        .enableWrite(newSignal_pcWriteEnable),
        .d(pc_sel_out),
        .q(pc)
    );
    // end: PC datapath

    // ::::: Fetch Stage ::::: //
    assign pc_4 = pc + 4;

    // begin: instruction memory datapath
    // the only input is `pc`
    // end: instruction memory datapath

    // begin: if_kill_mux
    wire [31:0] if_kill_out;
    Mux2to1_32b if_kill_mux_inst(
        .S(newSignal_if_kill),
        .I0(instruction),
        .I1(32'h13),  // nop
        .O(if_kill_out)
    );
    // end: if_kill_mux

    // begin: Stage registers
    wire [31:0] if_pc;
    wire [31:0] if_instruction;
    Register32b if_pc_inst(
        .clk(clk),
        .enableWrite(1'b1),
        // .d(pc),
        .d(pc_4),
        .q(if_pc)
    );
    Register32b if_instruction_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(if_kill_out),
        .q(if_instruction)
    );
    // end: Stage registers

    // ::::: Decode Stage ::::: //
    wire [31:0] rs1;
    wire [31:0] rs2;
    wire [31:0] bTypeSignExtend;
    wire [31:0] iTypeSignExtend;
    wire [31:0] shamtSignExtend;
    wire [31:0] sTypeSignExtend;
    wire [31:0] jTypeSignExtend;
    wire [31:0] uTypeImmediate;

    // begin: RegFile datapath
    RegFile regFile_inst(
        .clk(clk),
        .rst(rst),
        .readRegister1(instruction[19:15]),
        .readRegister2(instruction[24:20]),
        .writeRegister(memSignal_rd),
        .writeData(regFileWriteData),
        .writeEnable(memSignal_regFileWriteEnable),

        .readData1(rs1),
        .readData2(rs2),

        // debug only
        .readRegisterDebug(regFileReadRegisterDebug),
        .readDataDebug(regFileReadDataDebug)
    );
    // end: RegFile datapath

    assign newSignal_rd = instruction[11:7];

    // begin: immediate extend datapath
    BTypeSignExtend32b bTypeSignExtend32b_inst(
        .instruction(instruction),
        .signExtended(bTypeSignExtend)
    );
    ITypeSignExtend32b iTypeSignExtend32b_inst(
        .instruction(instruction),
        .signExtended(iTypeSignExtend)
    );
    UType32b uType32b_inst(
        .instruction(instruction),
        .extended(uTypeImmediate)
    );
    JTypeSignExtend32b jTypeSignExtend32b_inst(
        .instruction(instruction),
        .signExtended(jTypeSignExtend)
    );
    STypeSignExtend32b sTypeSignExtend32b_inst(
        .instruction(instruction),
        .signExtended(sTypeSignExtend)
    );
    ShamtSignExtend32b shamtSignExtend32b_inst(
        .instruction(instruction),
        .signExtended(shamtSignExtend)
    );
    // end: immediate extend datapath 

    // begin: MUX for ALU input datapath
    wire [31:0] op2Sel_out;
    Mux8to1_32b op2Sel_mux_inst(
        .S(newSignal_op2Sel),
        .I0(rs2),
        .I1(bTypeSignExtend),
        .I2(iTypeSignExtend),
        .I3(uTypeImmediate),
        .I4(jTypeSignExtend),
        .I5(sTypeSignExtend),
        .I6(shamtSignExtend),
        .I7(32'b0),
        .O(op2Sel_out)
    );
    wire [31:0] op1Sel_out;
    Mux4to1_32b op1Sel_mux_inst(
        .S(newSignal_op1Sel),
        .I0(if_pc),
        .I1(rs1),
        .I2(32'b0),
        .I3(32'b0),
        .O(op1Sel_out)
    );
    // end: MUX for ALU input datapath

    // begin: Control datapath
    RiscV5StageControl decoder_inst(
        .instruction(instruction),

        .pcSelect(newSignal_pc_sel),
        .op2Select(newSignal_op2Sel),
        .op1Select(newSignal_op1Sel),
        .aluFunction(newSignal_aluFunction),
        .mem_writebackSelect(newSignal_mem_wb_sel),
        .exe_writebackSelect(newSignal_exe_wb_sel),
        .regFileWriteEnable(newSignal_regFileWriteEnable),
        .memoryReadEnable(newSignal_memoryReadEnable),
        .memoryWriteEnable(newSignal_memoryWriteEnable),
        .isBne(newSignal_isBne),
        .isBeq(newSignal_isBeq)
    );
    // end: Control datapath

    // begin: dec_kill_mux
    wire [31:0] dec_kill_out;
    Mux2to1_32b dec_kill_mux_inst(
        .S(newSignal_dec_kill),
        .I0({
            7'b0,
            newSignal_isBne,
            newSignal_isBeq,
            1'b0,
            newSignal_aluFunction,
            newSignal_op1Sel,
            newSignal_op2Sel,
            newSignal_pc_sel,
            newSignal_mem_wb_sel,
            newSignal_exe_wb_sel,
            newSignal_regFileWriteEnable,
            newSignal_memoryWriteEnable,
            newSignal_memoryReadEnable,
            newSignal_rd
        }),
        .I1(32'h0),
        .O(dec_kill_out)
    );
    // end: dec_kill_mux

    // begin: Stage registers
    wire [31:0] dec_pc;
    wire [31:0] dec_op1;
    wire [31:0] dec_op2;
    wire [31:0] dec_rs2;
    Register32b dec_pc_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(if_pc),
        .q(dec_pc)
    );
    Register32b dec_op1_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(op1Sel_out),
        .q(dec_op1)
    );
    Register32b dec_op2_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(op2Sel_out),
        .q(dec_op2)
    );
    Register32b dec_rs2_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(rs2),
        .q(dec_rs2)
    );
    // control signals
    RegisterResettable32b dec_controlSignals_inst(
        .clk(clk),
        .rst(rst),
        .enableWrite(1'b1),
        .d(dec_kill_out),
        .q({
            dummyOutput7b_dec_controlSignals,
            decSignal_isBne,
            decSignal_isBeq,
            dummyOutput1b_dec_controlSignals,
            decSignal_aluFunction,
            decSignal_op1Sel,
            decSignal_op2Sel,
            decSignal_pc_sel,
            decSignal_mem_wb_sel,
            decSignal_exe_wb_sel,
            decSignal_regFileWriteEnable,
            decSignal_memoryWriteEnable,
            decSignal_memoryReadEnable,
            decSignal_rd
        })
    );
    // end: Stage registers

    // ::::: Execute Stage ::::: //
    wire [31:0] aluOut;

    // begin: condition generation
    BranchCondGen BranchCondGen_inst(
        .rs1(dec_op1),
        .rs2(dec_rs2),
        .is_br_eq(newSignal_is_br_eq),
        .is_br_lt(),
        .is_br_ltu()
    );
    // end: condition generation

    // begin: target generation datapath
    BranchAndJumpTargGen branchAndJumpTargGen_inst(
        .pc(dec_pc),
        .immediate(dec_op2),
        .target(branchOrJump)
    );
    JumpRegTargGen jumpRegTargGen_inst(
        .iTypeSignExtend(dec_op2),
        .rs1(dec_op1),
        .target(jalr)
    );
    // end: target generation datapath

    // begin: ALU datapath
    Alu32b_extended alu32b_inst(
        .aluOp(decSignal_aluFunction),
        .leftOperand(dec_op1),
        .rightOperand(dec_op2),
        .aluResult(aluOut)
    );
    // end: ALU datapath

    // begin: MUX for writeback address to RAM or data to regFile
    wire [31:0] exe_wb_sel_out;
    Mux2to1_32b exe_wb_sel_mux_inst(
        .S(decSignal_exe_wb_sel),
        .I0(if_pc + 4),
        .I1(aluOut),
        .O(exe_wb_sel_out)
    );
    // end: MUX for writeback address to RAM or data to regFile

    // begin: Stage registers
    wire [31:0] exe_aluOut;
    wire [31:0] exe_rs2;
    wire [31:0] exe_rs1;
    Register32b exe_aluOut_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(exe_wb_sel_out),
        .q(exe_aluOut)
    );
    Register32b exe_rs2_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(dec_rs2),
        .q(exe_rs2)
    );
    Register32b exe_rs1_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(dec_op1),
        .q(exe_rs1)
    );
    // control signals
    RegisterResettable32b exe_controlSignals_inst(
        .clk(clk),
        .rst(rst),
        .enableWrite(1'b1),
        .d({
            7'b0,
            decSignal_isBne,
            decSignal_isBeq,
            newSignal_is_br_eq,
            decSignal_aluFunction,
            decSignal_op1Sel,
            decSignal_op2Sel,
            decSignal_pc_sel,
            decSignal_mem_wb_sel,
            decSignal_exe_wb_sel,
            decSignal_regFileWriteEnable,
            decSignal_memoryWriteEnable,
            decSignal_memoryReadEnable,
            decSignal_rd
        }),
        .q({
            dummyOutput7b_exe_controlSignals,
            exeSignal_isBne,
            exeSignal_isBeq,
            exeSignal_is_br_eq,
            exeSignal_aluFunction,
            exeSignal_op1Sel,
            exeSignal_op2Sel,
            exeSignal_pc_sel,
            exeSignal_mem_wb_sel,
            exeSignal_exe_wb_sel,
            exeSignal_regFileWriteEnable,
            exeSignal_memoryWriteEnable,
            exeSignal_memoryReadEnable,
            exeSignal_rd
        })
    );
    // end: Stage registers

    // ::::: Memory Stage ::::: //

    // begin: input ports of RAM
    assign memoryAddress = exe_aluOut;
    assign memoryWriteData = exe_rs2;
    assign memoryReadEnable = exeSignal_memoryReadEnable;
    assign memoryWriteEnable = exeSignal_memoryWriteEnable;
    // end: input ports of RAM

    // begin: MUX for data to regFile
    wire [31:0] mem_wb_sel_out;
    Mux4to1_32b mem_wb_sel_mux_inst(
        .S(exeSignal_mem_wb_sel),
        .I0(32'b0),
        .I1(exe_aluOut),
        .I2(memoryReadData),
        .I3(32'b0),
        .O(mem_wb_sel_out)
    );
    // end: MUX for data to regFile

    // begin: Stage registers
    wire [31:0] mem_wbData;
    Register32b mem_wbData_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(mem_wb_sel_out),
        .q(mem_wbData)
    );
    // WORKAROUND: ignore "to host" register
    // control signals
    RegisterResettable32b mem_controlSignals_inst(
        .clk(clk),
        .rst(rst),
        .enableWrite(1'b1),
        .d({
            7'b0,
            exeSignal_isBne,
            exeSignal_isBeq,
            exeSignal_is_br_eq,
            exeSignal_aluFunction,
            exeSignal_op1Sel,
            exeSignal_op2Sel,
            exeSignal_pc_sel,
            exeSignal_mem_wb_sel,
            exeSignal_exe_wb_sel,
            exeSignal_regFileWriteEnable,
            exeSignal_memoryWriteEnable,
            exeSignal_memoryReadEnable,
            exeSignal_rd
        }),
        .q({
            dummyOutput7b_mem_controlSignals,
            memSignal_isBne,
            memSignal_isBeq,
            memSignal_is_br_eq,
            memSignal_aluFunction,
            memSignal_op1Sel,
            memSignal_op2Sel,
            memSignal_pc_sel,
            memSignal_mem_wb_sel,
            memSignal_exe_wb_sel,
            memSignal_regFileWriteEnable,
            memSignal_memoryWriteEnable,
            memSignal_memoryReadEnable,
            memSignal_rd
        })
    );
    // end: Stage registers

    // ::::: Writeback Stage ::::: //
    // begin: input ports of RegFile
    assign regFileWriteData = mem_wbData;
    // end: input ports of RegFile
    
endmodule

`endif
