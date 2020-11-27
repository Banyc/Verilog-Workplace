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
    wire       exe_dummyOutput1b_controlSignals;
    wire [6:0] exe_dummyOutput7b_controlSignals;
    wire [6:0] mem_dummyOutput7b_controlSignals;
    wire [6:0] wb_dummyOutput7b_controlSignals;

    // 32 bits outputs
    wire [31:0] if_pc;
    output wire [31:0] pc;
    assign pc = if_pc;
    input wire [31:0] instruction;
    wire [31:0] if_instruction = instruction;
    input wire [31:0] memoryReadData;
    wire [31:0] mem_memoryReadData = memoryReadData;

    // control signals
    output wire memoryWriteEnable;
    output wire memoryReadEnable;

    // begin: control signals
    // naming convention: inWhere_detail
    wire       dec_signal_isBne;
    wire       dec_signal_isBeq;
    wire [3:0] dec_signal_aluFunction;
    wire [1:0] dec_signal_op1Sel;
    wire [2:0] dec_signal_op2Sel;
    wire [1:0] dec_signal_pc_sel;
    wire [1:0] dec_signal_mem_wb_sel;
    wire       dec_signal_exe_wb_sel;
    wire       dec_signal_regFileWriteEnable;
    wire       dec_signal_memoryWriteEnable;
    wire       dec_signal_memoryReadEnable;
    wire [4:0] dec_signal_rd;
    // forwarding
    wire [1:0] dec_signal_forwardingOp1Sel;  // WORDAROUND
    wire [1:0] dec_signal_forwardingOp2Sel;  // WORDAROUND
    wire [1:0] dec_signal_forwardingRs2Sel;  // WORDAROUND
    // from HazardDetectionUnit
    wire       if_signal_if_kill;
    wire       dec_signal_dec_kill;
    wire       global_signal_pcWriteEnable;

    wire       exe_signal_isBne;
    wire       exe_signal_isBeq;
    wire       exe_signal_is_br_eq;
    wire [3:0] exe_signal_aluFunction;
    wire [1:0] exe_signal_op1Sel;
    wire [2:0] exe_signal_op2Sel;
    wire [1:0] exe_signal_pc_sel;
    wire [1:0] exe_signal_mem_wb_sel;
    wire       exe_signal_exe_wb_sel;
    wire       exe_signal_regFileWriteEnable;
    wire       exe_signal_memoryWriteEnable;
    wire       exe_signal_memoryReadEnable;
    wire [4:0] exe_signal_rd;

    wire       mem_signal_isBne;
    wire       mem_signal_isBeq;
    wire       mem_signal_is_br_eq;
    wire [3:0] mem_signal_aluFunction;
    wire [1:0] mem_signal_op1Sel;
    wire [2:0] mem_signal_op2Sel;
    wire [1:0] mem_signal_pc_sel;
    wire [1:0] mem_signal_mem_wb_sel;
    wire       mem_signal_exe_wb_sel;
    wire       mem_signal_regFileWriteEnable;
    wire       mem_signal_memoryWriteEnable;
    wire       mem_signal_memoryReadEnable;
    wire [4:0] mem_signal_rd;

    wire       wb_signal_isBne;
    wire       wb_signal_isBeq;
    wire       wb_signal_is_br_eq;
    wire [3:0] wb_signal_aluFunction;
    wire [1:0] wb_signal_op1Sel;
    wire [2:0] wb_signal_op2Sel;
    wire [1:0] wb_signal_pc_sel;
    wire [1:0] wb_signal_mem_wb_sel;
    wire       wb_signal_exe_wb_sel;
    wire       wb_signal_regFileWriteEnable;
    wire       wb_signal_memoryWriteEnable;
    wire       wb_signal_memoryReadEnable;
    wire [4:0] wb_signal_rd;
    // end: control signals

    // reg file
    wire [31:0] regFileWriteData;
    input wire [4:0] regFileReadRegisterDebug;
    output wire [31:0] regFileReadDataDebug;

    // memory
    output wire [31:0] memoryAddress;
    output wire [31:0] memoryWriteData;

    // ::::: Global ::::: //
    HazardDetectionUnit global_hazardDetectionUnit_inst(
        // stalling
        .pcWriteEnable(global_signal_pcWriteEnable),
        .if_kill(if_signal_if_kill),
        .dec_kill(dec_signal_dec_kill),
        // forwarding
        .dec_forwardingOp1Sel(dec_signal_forwardingOp1Sel),
        .dec_forwardingOp2Sel(dec_signal_forwardingOp2Sel),
        .dec_forwardingRs2Sel(dec_signal_forwardingRs2Sel),
        // inputs
        .if_rs1Address(if_instruction[19:15]),
        .if_rs2Address(if_instruction[24:20]),
        .dec_rs1Address(dec_instruction[19:15]),
        .dec_rs2Address(dec_instruction[24:20]),
        .dec_regFileWriteAddress(dec_signal_rd),
        .dec_regFileWriteEnable(dec_signal_regFileWriteEnable),
        .dec_signal_mem_wb_sel(dec_signal_mem_wb_sel),
        .dec_signal_op2Sel(dec_signal_op2Sel),
        .exe_regFileWriteAddress(exe_signal_rd),
        .exe_regFileWriteEnable(exe_signal_regFileWriteEnable),
        .exe_signal_mem_wb_sel(exe_signal_mem_wb_sel),
        .mem_regFileWriteAddress(mem_signal_rd),
        .mem_regFileWriteEnable(mem_signal_regFileWriteEnable),
        .mem_signal_mem_wb_sel(mem_signal_mem_wb_sel),
        .wb_regFileWriteAddress(wb_signal_rd),
        .wb_regFileWriteEnable(wb_signal_regFileWriteEnable),
        .wb_signal_mem_wb_sel(wb_signal_mem_wb_sel),
        .exe_isBranchOrJumpTaken(exe_pc_sel_withBranchConsidered == `riscv32_5stage_pc_sel_jumpOrBranch)
    );
    
    // begin: RegFile datapath
    RegFile global_regFile_inst(
        .clk(clk),
        .rst(rst),
        .readRegister1(dec_instruction[19:15]),
        .readRegister2(dec_instruction[24:20]),
        .writeRegister(wb_signal_rd),
        .writeData(regFileWriteData),
        .writeEnable(wb_signal_regFileWriteEnable),

        .readData1(dec_rs1),
        .readData2(dec_rs2),

        // debug only
        .readRegisterDebug(regFileReadRegisterDebug),
        .readDataDebug(regFileReadDataDebug)
    );
    // end: RegFile datapath

    // ::::: PC Modification Stage ::::: //
    wire [31:0] if_pc_4;
    wire [31:0] exe_branchOrJump;
    wire [31:0] exe_jalr;

    // begin: update pc_sel
    wire [1:0] exe_pc_sel_withBranchConsidered;
    PcSelUpdater exe_pcSelUpdater_inst(
        .isBne(exe_signal_isBne),
        .isBeq(exe_signal_isBeq),
        .isBranchEqual(exe_signal_is_br_eq),
        .oldPcSel(exe_signal_pc_sel),
        .newPcSel(exe_pc_sel_withBranchConsidered)
    );
    // end: update pc_sel
    
    // begin: MUX for PC input datapath
    wire [31:0] pc_sel_out;
    Mux4to1_32b pc_sel_mux_inst(
        .S(exe_pc_sel_withBranchConsidered),
        .I0(if_pc_4),
        .I1(exe_branchOrJump),
        .I2(exe_jalr),
        .I3(32'b0),
        .O(pc_sel_out)
    );
    // end: MUX for PC input datapath

    // begin: PC datapath
    RegisterResettable32b pc_inst(
        .clk(clk),
        .rst(rst),
        .enableWrite(global_signal_pcWriteEnable),
        .d(pc_sel_out),
        .q(if_pc)
    );
    // end: PC datapath

    // ::::: Fetch Stage ::::: //
    assign if_pc_4 = if_pc + 4;

    // begin: instruction memory datapath
    // the only input is `pc`
    // end: instruction memory datapath

    // begin: if_kill_mux
    wire [31:0] if_kill_out;
    Mux2to1_32b if_kill_mux_inst(
        .S(if_signal_if_kill),
        .I0(if_instruction),
        .I1(32'h13),  // nop
        .O(if_kill_out)
    );
    // end: if_kill_mux

    // begin: Stage registers
    wire [31:0] dec_pc;
    wire [31:0] dec_instruction;
    Register32b if_dec_pc_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(if_pc),
        .q(dec_pc)
    );
    Register32b if_dec_instruction_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(if_kill_out),
        .q(dec_instruction)
    );
    // end: Stage registers

    // ::::: Decode Stage ::::: //
    wire [31:0] dec_rs1;
    wire [31:0] dec_rs2;
    wire [31:0] dec_bTypeSignExtend;
    wire [31:0] dec_iTypeSignExtend;
    wire [31:0] dec_shamtSignExtend;
    wire [31:0] dec_sTypeSignExtend;
    wire [31:0] dec_jTypeSignExtend;
    wire [31:0] dec_uTypeImmediate;

    assign dec_signal_rd = dec_instruction[11:7];

    // begin: immediate extend datapath
    BTypeSignExtend32b dec_bTypeSignExtend32b_inst(
        .instruction(dec_instruction),
        .signExtended(dec_bTypeSignExtend)
    );
    ITypeSignExtend32b dec_iTypeSignExtend32b_inst(
        .instruction(dec_instruction),
        .signExtended(dec_iTypeSignExtend)
    );
    UType32b dec_uType32b_inst(
        .instruction(dec_instruction),
        .extended(dec_uTypeImmediate)
    );
    JTypeSignExtend32b dec_jTypeSignExtend32b_inst(
        .instruction(dec_instruction),
        .signExtended(dec_jTypeSignExtend)
    );
    STypeSignExtend32b dec_sTypeSignExtend32b_inst(
        .instruction(dec_instruction),
        .signExtended(dec_sTypeSignExtend)
    );
    ShamtSignExtend32b dec_shamtSignExtend32b_inst(
        .instruction(dec_instruction),
        .signExtended(dec_shamtSignExtend)
    );
    // end: immediate extend datapath 

    // begin: MUX for ALU input datapath
    wire [31:0] dec_op2Sel_out;
    Mux8to1_32b dec_op2Sel_mux_inst(
        .S(dec_signal_op2Sel),
        .I0(dec_rs2),
        .I1(dec_bTypeSignExtend),
        .I2(dec_iTypeSignExtend),
        .I3(dec_uTypeImmediate),
        .I4(dec_jTypeSignExtend),
        .I5(dec_sTypeSignExtend),
        .I6(dec_shamtSignExtend),
        .I7(32'b0),
        .O(dec_op2Sel_out)
    );
    wire [31:0] dec_op1Sel_out;
    Mux4to1_32b dec_op1Sel_mux_inst(
        .S(dec_signal_op1Sel),
        .I0(dec_pc),
        .I1(dec_rs1),
        .I2(32'b0),
        .I3(32'b0),
        .O(dec_op1Sel_out)
    );
    // end: MUX for ALU input datapath

    // begin: Control datapath
    RiscV5StageControl dec_decoder_inst(
        .instruction(dec_instruction),

        .pcSelect(dec_signal_pc_sel),
        .op2Select(dec_signal_op2Sel),
        .op1Select(dec_signal_op1Sel),
        .aluFunction(dec_signal_aluFunction),
        .mem_writebackSelect(dec_signal_mem_wb_sel),
        .exe_writebackSelect(dec_signal_exe_wb_sel),
        .regFileWriteEnable(dec_signal_regFileWriteEnable),
        .memoryReadEnable(dec_signal_memoryReadEnable),
        .memoryWriteEnable(dec_signal_memoryWriteEnable),
        .isBne(dec_signal_isBne),
        .isBeq(dec_signal_isBeq)
    );
    // end: Control datapath

    // begin: dec_kill_mux
    wire [31:0] dec_kill_out;
    Mux2to1_32b dec_kill_mux_inst(
        .S(dec_signal_dec_kill),
        .I0({
            7'b0,
            dec_signal_isBne,
            dec_signal_isBeq,
            1'b0,
            dec_signal_aluFunction,
            dec_signal_op1Sel,
            dec_signal_op2Sel,
            dec_signal_pc_sel,
            dec_signal_mem_wb_sel,
            dec_signal_exe_wb_sel,
            dec_signal_regFileWriteEnable,
            dec_signal_memoryWriteEnable,
            dec_signal_memoryReadEnable,
            dec_signal_rd
        }),
        .I1(32'h0),
        .O(dec_kill_out)
    );
    // end: dec_kill_mux

    // begin: MUX for forwarding
    wire [31:0] dec_forwardingOp1Sel_mux_out;
    Mux4to1_32b dec_forwardingOp1Sel_mux_inst(
        .S(dec_signal_forwardingOp1Sel),
        .I0(exe_aluOut),
        .I1(mem_wb_sel_out),
        .I2(wb_wbData),
        .I3(dec_op1Sel_out),
        .O(dec_forwardingOp1Sel_mux_out)
    );
    wire [31:0] dec_forwardingOp2Sel_mux_out;
    Mux4to1_32b dec_forwardingOp2Sel_mux_inst(
        .S(dec_signal_forwardingOp2Sel),
        .I0(exe_aluOut),
        .I1(mem_wb_sel_out),
        .I2(wb_wbData),
        .I3(dec_op2Sel_out),
        .O(dec_forwardingOp2Sel_mux_out)
    );
    wire [31:0] dec_forwardingRs2Sel_mux_out;
    Mux4to1_32b dec_forwardingRs2Sel_mux_inst(
        .S(dec_signal_forwardingRs2Sel),
        .I0(exe_aluOut),
        .I1(mem_wb_sel_out),
        .I2(wb_wbData),
        .I3(dec_rs2),
        .O(dec_forwardingRs2Sel_mux_out)
    );
    // end: MUX for forwarding

    // begin: Stage registers
    wire [31:0] exe_pc;
    wire [31:0] exe_op1;
    wire [31:0] exe_op2;
    wire [31:0] exe_rs2;
    Register32b dec_exe_pc_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(dec_pc),
        .q(exe_pc)
    );
    Register32b dec_exe_op1_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(dec_forwardingOp1Sel_mux_out),
        .q(exe_op1)
    );
    Register32b dec_exe_op2_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(dec_forwardingOp2Sel_mux_out),
        .q(exe_op2)
    );
    Register32b dec_exe_rs2_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(dec_forwardingRs2Sel_mux_out),
        .q(exe_rs2)
    );
    // control signals
    RegisterResettable32b dec_exe_controlSignals_inst(
        .clk(clk),
        .rst(rst),
        .enableWrite(1'b1),
        .d(dec_kill_out),
        .q({
            exe_dummyOutput7b_controlSignals,
            exe_signal_isBne,
            exe_signal_isBeq,
            exe_dummyOutput1b_controlSignals,
            exe_signal_aluFunction,
            exe_signal_op1Sel,
            exe_signal_op2Sel,
            exe_signal_pc_sel,
            exe_signal_mem_wb_sel,
            exe_signal_exe_wb_sel,
            exe_signal_regFileWriteEnable,
            exe_signal_memoryWriteEnable,
            exe_signal_memoryReadEnable,
            exe_signal_rd
        })
    );
    // end: Stage registers

    // ::::: Execute Stage ::::: //
    wire [31:0] exe_aluOut;

    // begin: condition generation
    BranchCondGen exe_branchCondGen_inst(
        .rs1(exe_op1),
        .rs2(exe_rs2),
        .is_br_eq(exe_signal_is_br_eq),
        .is_br_lt(),
        .is_br_ltu()
    );
    // end: condition generation

    // begin: target generation datapath
    BranchAndJumpTargGen exe_branchAndJumpTargGen_inst(
        .pc(exe_pc),
        .immediate(exe_op2),
        .target(exe_branchOrJump)
    );
    JumpRegTargGen exe_jumpRegTargGen_inst(
        .iTypeSignExtend(exe_op2),
        .rs1(exe_op1),
        .target(exe_jalr)
    );
    // end: target generation datapath

    // begin: ALU datapath
    Alu32b_extended exe_alu32b_inst(
        .aluOp(exe_signal_aluFunction),
        .leftOperand(exe_op1),
        .rightOperand(exe_op2),
        .aluResult(exe_aluOut)
    );
    // end: ALU datapath

    // begin: MUX for writeback address to RAM or data to regFile
    wire [31:0] exe_wb_sel_out;
    Mux2to1_32b exe_wb_sel_mux_inst(
        .S(exe_signal_exe_wb_sel),
        .I0(exe_pc + 4),
        .I1(exe_aluOut),
        .O(exe_wb_sel_out)
    );
    // end: MUX for writeback address to RAM or data to regFile

    // begin: Stage registers
    wire [31:0] mem_aluOut;
    wire [31:0] mem_rs2;
    wire [31:0] mem_rs1;
    Register32b exe_mem_aluOut_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(exe_wb_sel_out),
        .q(mem_aluOut)
    );
    Register32b exe_mem_rs2_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(exe_rs2),
        .q(mem_rs2)
    );
    Register32b exe_mem_rs1_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(exe_op1),
        .q(mem_rs1)
    );
    // control signals
    RegisterResettable32b exe_mem_controlSignals_inst(
        .clk(clk),
        .rst(rst),
        .enableWrite(1'b1),
        .d({
            7'b0,
            exe_signal_isBne,
            exe_signal_isBeq,
            exe_signal_is_br_eq,
            exe_signal_aluFunction,
            exe_signal_op1Sel,
            exe_signal_op2Sel,
            exe_signal_pc_sel,
            exe_signal_mem_wb_sel,
            exe_signal_exe_wb_sel,
            exe_signal_regFileWriteEnable,
            exe_signal_memoryWriteEnable,
            exe_signal_memoryReadEnable,
            exe_signal_rd
        }),
        .q({
            mem_dummyOutput7b_controlSignals,
            mem_signal_isBne,
            mem_signal_isBeq,
            mem_signal_is_br_eq,
            mem_signal_aluFunction,
            mem_signal_op1Sel,
            mem_signal_op2Sel,
            mem_signal_pc_sel,
            mem_signal_mem_wb_sel,
            mem_signal_exe_wb_sel,
            mem_signal_regFileWriteEnable,
            mem_signal_memoryWriteEnable,
            mem_signal_memoryReadEnable,
            mem_signal_rd
        })
    );
    // end: Stage registers

    // ::::: Memory Stage ::::: //

    // begin: input ports of RAM
    assign memoryAddress = mem_aluOut;
    assign memoryWriteData = mem_rs2;
    assign memoryReadEnable = mem_signal_memoryReadEnable;
    assign memoryWriteEnable = mem_signal_memoryWriteEnable;
    // end: input ports of RAM

    // begin: MUX for data to regFile
    wire [31:0] mem_wb_sel_out;
    Mux4to1_32b mem_wb_sel_mux_inst(
        .S(mem_signal_mem_wb_sel),
        .I0(32'b0),
        .I1(mem_aluOut),
        .I2(mem_memoryReadData),
        .I3(32'b0),
        .O(mem_wb_sel_out)
    );
    // end: MUX for data to regFile

    // begin: Stage registers
    wire [31:0] wb_wbData;
    Register32b mem_wb_wbData_inst(
        .clk(clk),
        .enableWrite(1'b1),
        .d(mem_wb_sel_out),
        .q(wb_wbData)
    );
    // WORKAROUND: ignore "to host" register
    // control signals
    RegisterResettable32b mem_wb_controlSignals_inst(
        .clk(clk),
        .rst(rst),
        .enableWrite(1'b1),
        .d({
            7'b0,
            mem_signal_isBne,
            mem_signal_isBeq,
            mem_signal_is_br_eq,
            mem_signal_aluFunction,
            mem_signal_op1Sel,
            mem_signal_op2Sel,
            mem_signal_pc_sel,
            mem_signal_mem_wb_sel,
            mem_signal_exe_wb_sel,
            mem_signal_regFileWriteEnable,
            mem_signal_memoryWriteEnable,
            mem_signal_memoryReadEnable,
            mem_signal_rd
        }),
        .q({
            wb_dummyOutput7b_controlSignals,
            wb_signal_isBne,
            wb_signal_isBeq,
            wb_signal_is_br_eq,
            wb_signal_aluFunction,
            wb_signal_op1Sel,
            wb_signal_op2Sel,
            wb_signal_pc_sel,
            wb_signal_mem_wb_sel,
            wb_signal_exe_wb_sel,
            wb_signal_regFileWriteEnable,
            wb_signal_memoryWriteEnable,
            wb_signal_memoryReadEnable,
            wb_signal_rd
        })
    );
    // end: Stage registers

    // ::::: Writeback Stage ::::: //
    // begin: input ports of RegFile
    assign regFileWriteData = wb_wbData;
    // end: input ports of RegFile
    
endmodule

`endif
