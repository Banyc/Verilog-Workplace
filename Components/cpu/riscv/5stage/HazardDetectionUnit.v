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
    dec_regFileWriteAddress,
    dec_regFileWriteEnable,
    exe_regFileWriteAddress,
    exe_regFileWriteEnable,
    mem_regFileWriteAddress,
    mem_regFileWriteEnable,
    wb_regFileWriteAddress,
    wb_regFileWriteEnable,
    exe_isBranchOrJumpTaken
);
    output reg pcWriteEnable;
    output reg if_kill;
    output reg dec_kill;

    output reg [1:0] dec_forwardingOp1Sel = `riscv32_5stage_dec_forwarding_none;  // WORKAROUND
    output reg [1:0] dec_forwardingOp2Sel = `riscv32_5stage_dec_forwarding_none;  // WORKAROUND
    output reg [1:0] dec_forwardingRs2Sel = `riscv32_5stage_dec_forwarding_none;  // WORKAROUND
    
    input wire [4:0] if_rs1Address;
    input wire [4:0] if_rs2Address;
    input wire [4:0] dec_regFileWriteAddress;
    input wire       dec_regFileWriteEnable;
    input wire [4:0] exe_regFileWriteAddress;
    input wire       exe_regFileWriteEnable;
    input wire [4:0] mem_regFileWriteAddress;
    input wire       mem_regFileWriteEnable;
    input wire [4:0] wb_regFileWriteAddress;
    input wire       wb_regFileWriteEnable;
    input wire       exe_isBranchOrJumpTaken;

    // stalling
    always @(*) begin
        if (exe_isBranchOrJumpTaken == 1) begin
            pcWriteEnable <= 1;
            if_kill <= 1;
            dec_kill <= 1;
        end else if (
            (
                dec_regFileWriteEnable == 1
                &&
                dec_regFileWriteAddress != 0
                &&
                (
                    dec_regFileWriteAddress == if_rs1Address
                    ||
                    dec_regFileWriteAddress == if_rs2Address
                )
            )
            ||
            (
                exe_regFileWriteEnable == 1
                &&
                exe_regFileWriteAddress != 0
                &&
                (
                    exe_regFileWriteAddress == if_rs1Address
                    ||
                    exe_regFileWriteAddress == if_rs2Address
                )
            )
            ||
            (
                mem_regFileWriteEnable == 1
                &&
                mem_regFileWriteAddress != 0
                &&
                (
                    (
                        // exe_regFileWriteAddress != if_rs1Address
                        // &&
                        mem_regFileWriteAddress == if_rs1Address
                    )
                    ||
                    (
                        // exe_regFileWriteAddress != if_rs2Address
                        // &&
                        mem_regFileWriteAddress == if_rs2Address
                    )
                )
            )
            ||
            (
                wb_regFileWriteEnable == 1
                &&
                wb_regFileWriteAddress != 0
                &&
                (
                    (
                        // exe_regFileWriteAddress != if_rs1Address
                        // &&
                        // mem_regFileWriteAddress != if_rs1Address
                        // &&
                        wb_regFileWriteAddress == if_rs1Address
                    )
                    ||
                    (
                        // exe_regFileWriteAddress != if_rs2Address
                        // &&
                        // mem_regFileWriteAddress != if_rs2Address
                        // &&
                        wb_regFileWriteAddress == if_rs2Address
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

endmodule


`endif
