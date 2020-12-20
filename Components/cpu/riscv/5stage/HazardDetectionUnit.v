// HazardDetectionUnit
`ifndef __HazardDetectionUnit_v__
`define __HazardDetectionUnit_v__

`include "Components/cpu/riscv/5stage/EnumSelections.vh"

module HazardDetectionUnit (
    // stalling
    pcWriteEnable,
    if_kill,
    dec_kill,
    // forwarding
    dec_forwardingOp1Sel,
    dec_forwardingOp2Sel,
    dec_forwardingRs2Sel,
    // inputs
    if_rs1Address,
    if_rs2Address,
    dec_rs1Address,
    dec_rs2Address,
    dec_regFileWriteAddress,
    dec_regFileWriteEnable,
    dec_signal_mem_wb_sel,
    dec_signal_op2Sel,
    exe_regFileWriteAddress,
    exe_regFileWriteEnable,
    exe_signal_mem_wb_sel,
    mem_regFileWriteAddress,
    mem_regFileWriteEnable,
    mem_signal_mem_wb_sel,
    wb_regFileWriteAddress,
    wb_regFileWriteEnable,
    wb_signal_mem_wb_sel,
    exe_isBranchOrJumpTaken
);
    output reg pcWriteEnable;
    output reg if_kill;
    output reg dec_kill;

    output reg [1:0] dec_forwardingOp1Sel;
    output reg [1:0] dec_forwardingOp2Sel;
    output reg [1:0] dec_forwardingRs2Sel;
    
    input wire [4:0] if_rs1Address;
    input wire [4:0] if_rs2Address;
    input wire [4:0] dec_rs1Address;
    input wire [4:0] dec_rs2Address;
    input wire [4:0] dec_regFileWriteAddress;
    input wire       dec_regFileWriteEnable;
    input wire [1:0] dec_signal_mem_wb_sel;
    input wire [2:0] dec_signal_op2Sel;
    input wire [4:0] exe_regFileWriteAddress;
    input wire       exe_regFileWriteEnable;
    input wire [1:0] exe_signal_mem_wb_sel;
    input wire [4:0] mem_regFileWriteAddress;
    input wire       mem_regFileWriteEnable;
    input wire [1:0] mem_signal_mem_wb_sel;
    input wire [4:0] wb_regFileWriteAddress;
    input wire       wb_regFileWriteEnable;
    input wire [1:0] wb_signal_mem_wb_sel;
    input wire       exe_isBranchOrJumpTaken;

    wire dec_isLoad = dec_signal_mem_wb_sel ==
        `riscv32_5stage_mem_wb_sel_memoryReadData &&
        dec_regFileWriteEnable == 1;
    wire exe_isLoad = exe_signal_mem_wb_sel ==
        `riscv32_5stage_mem_wb_sel_memoryReadData &&
        exe_regFileWriteEnable == 1;
    wire mem_isLoad = mem_signal_mem_wb_sel ==
        `riscv32_5stage_mem_wb_sel_memoryReadData &&
        mem_regFileWriteEnable == 1;
    wire wb_isLoad = wb_signal_mem_wb_sel ==
        `riscv32_5stage_mem_wb_sel_memoryReadData &&
        wb_regFileWriteEnable == 1;

    wire exe_isArithmetic = exe_signal_mem_wb_sel ==
        `riscv32_5stage_mem_wb_sel_aluOut &&
        exe_regFileWriteEnable == 1;
    wire mem_isArithmetic = mem_signal_mem_wb_sel ==
        `riscv32_5stage_mem_wb_sel_aluOut &&
        mem_regFileWriteEnable == 1;
    wire wb_isArithmetic = wb_signal_mem_wb_sel ==
        `riscv32_5stage_mem_wb_sel_aluOut &&
        wb_regFileWriteEnable == 1;

    // not include store/branch instruction
    wire dec_hasRs2AsOp2 = dec_signal_op2Sel == `riscv32_5stage_op2Sel_rs2;

    wire dec_isStore = dec_signal_op2Sel == `riscv32_5stage_op2Sel_sTypeSignExtend;

    wire dec_isBranch = dec_signal_op2Sel == `riscv32_5stage_op2Sel_bTypeSignExtend;

    wire dec_hasRs2 = dec_hasRs2AsOp2 || dec_isStore || dec_isBranch;

    // stalling
    always @(*) begin
        if (exe_isBranchOrJumpTaken == 1) begin
            pcWriteEnable <= 1;
            if_kill <= 1;
            dec_kill <= 1;
        end else if (
            (
                dec_isLoad
                &&
                dec_regFileWriteAddress != 0
                &&
                (
                    dec_regFileWriteAddress == if_rs1Address
                    ||
                    (
                        // ISSUE: Every time `if_instruction[24:20]` looks like `dec_signal_rd`,
                        // ISSUE:  it will stall even if the instruction is of I/U/UJ-type.
                        // ISSUE: The issue is neglectable though.
                        // if_hasRs2
                        // &&
                        dec_regFileWriteAddress == if_rs2Address
                    )
                )
            )
        ) begin
            pcWriteEnable <= 0;
            if_kill <= 1;
            dec_kill <= 0;
        end else begin
            pcWriteEnable <= 1;
            if_kill <= 0;
            dec_kill <= 0;
        end
    end

    // ::::: forwarding ::::: //
    // dec_forwardingOp1Sel
    always @(*) begin
        // exe.arithmatic
        if (
            exe_isArithmetic
            &&
            exe_regFileWriteAddress != 0
            &&
            exe_regFileWriteAddress == dec_rs1Address
        ) begin
            dec_forwardingOp1Sel <= `riscv32_5stage_dec_forwarding_exe_aluOut;
        end
        // mem.load || mem.arithmatic
        else if (
            (mem_isLoad || mem_isArithmetic)
            &&
            mem_regFileWriteAddress != 0
            &&
            mem_regFileWriteAddress == dec_rs1Address
        ) begin
            dec_forwardingOp1Sel <= `riscv32_5stage_dec_forwarding_mem_wb_sel_out;
        end
        // wb.load || wb.arithmetic
        else if (
            (wb_isLoad || wb_isArithmetic)
            &&
            wb_regFileWriteAddress != 0
            &&
            wb_regFileWriteAddress == dec_rs1Address
        ) begin
            dec_forwardingOp1Sel <= `riscv32_5stage_dec_forwarding_wb_wbData;
        end
        // default
        else begin
            dec_forwardingOp1Sel <= `riscv32_5stage_dec_forwarding_none;
        end
    end

    // dec_forwardingOp2Sel
    // dec_forwardingRs2Sel
    always @(*) begin
        // exe.arithmatic
        if (
            dec_hasRs2
            &&
            exe_isArithmetic
            &&
            exe_regFileWriteAddress != 0
            &&
            exe_regFileWriteAddress == dec_rs2Address
        ) begin
            if (dec_isStore || dec_isBranch) begin
                // dec_forwardingOp2Sel = dec_sTypeSignExtend
                //   or dec_forwardingOp2Sel = dec_bTypeSignExtend
                dec_forwardingOp2Sel <= `riscv32_5stage_dec_forwarding_none;
                dec_forwardingRs2Sel <= `riscv32_5stage_dec_forwarding_exe_aluOut;
            end
            else begin
                dec_forwardingOp2Sel <= `riscv32_5stage_dec_forwarding_exe_aluOut;
                // dec_forwardingRs2Sel don't care
                dec_forwardingRs2Sel <= `riscv32_5stage_dec_forwarding_none;
            end
        end
        // mem.load || mem.arithmatic
        else if (
            dec_hasRs2
            &&
            (mem_isLoad || mem_isArithmetic)
            &&
            mem_regFileWriteAddress != 0
            &&
            mem_regFileWriteAddress == dec_rs2Address
        ) begin
            if (dec_isStore || dec_isBranch) begin
                // dec_forwardingOp2Sel = dec_sTypeSignExtend
                //   or dec_forwardingOp2Sel = dec_bTypeSignExtend
                dec_forwardingOp2Sel <= `riscv32_5stage_dec_forwarding_none;
                dec_forwardingRs2Sel <= `riscv32_5stage_dec_forwarding_mem_wb_sel_out;
            end
            else begin
                dec_forwardingOp2Sel <= `riscv32_5stage_dec_forwarding_mem_wb_sel_out;
                // dec_forwardingRs2Sel don't care
                dec_forwardingRs2Sel <= `riscv32_5stage_dec_forwarding_none;
            end
        end
        // wb.load || wb.arithmetic
        else if (
            dec_hasRs2
            &&
            (wb_isLoad || wb_isArithmetic)
            &&
            wb_regFileWriteAddress != 0
            &&
            wb_regFileWriteAddress == dec_rs2Address
        ) begin
            if (dec_isStore || dec_isBranch) begin
                // dec_forwardingOp2Sel = dec_sTypeSignExtend
                //   or dec_forwardingOp2Sel = dec_bTypeSignExtend
                dec_forwardingOp2Sel <= `riscv32_5stage_dec_forwarding_none;
                dec_forwardingRs2Sel <= `riscv32_5stage_dec_forwarding_wb_wbData;
            end
            else begin
                dec_forwardingOp2Sel <= `riscv32_5stage_dec_forwarding_wb_wbData;
                // dec_forwardingRs2Sel don't care
                dec_forwardingRs2Sel <= `riscv32_5stage_dec_forwarding_none;
            end
        end
        // default
        else begin
            dec_forwardingOp2Sel <= `riscv32_5stage_dec_forwarding_none;
            // dec_forwardingRs2Sel don't care
            dec_forwardingRs2Sel <= `riscv32_5stage_dec_forwarding_none;
        end
    end

endmodule


`endif
