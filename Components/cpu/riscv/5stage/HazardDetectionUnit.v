// HazardDetectionUnit
`ifndef __HazardDetectionUnit_v__
`define __HazardDetectionUnit_v__


module HazardDetectionUnit (
    pcWriteEnable,
    if_kill,
    dec_kill,
    dec_rs1Address,
    dec_rs2Address,
    exe_regFileWriteAddress,
    exe_regFileWriteEnable,
    mem_regFileWriteAddress,
    mem_regFileWriteEnable,
    wb_regFileWriteAddress,
    wb_regFileWriteEnable,
    exe_isBranch
);
    output reg pcWriteEnable;
    output reg if_kill;
    output reg dec_kill;
    
    input wire [4:0] dec_rs1Address;
    input wire [4:0] dec_rs2Address;
    input wire [4:0] exe_regFileWriteAddress;
    input wire       exe_regFileWriteEnable;
    input wire [4:0] mem_regFileWriteAddress;
    input wire       mem_regFileWriteEnable;
    input wire [4:0] wb_regFileWriteAddress;
    input wire       wb_regFileWriteEnable;
    input wire       exe_isBranch;

    
    always @(*) begin
        if (
            (
                exe_regFileWriteEnable == 1
                &&
                exe_regFileWriteAddress != 0
                &&
                (
                    exe_regFileWriteAddress == dec_rs1Address
                    ||
                    exe_regFileWriteAddress == dec_rs2Address
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
                        // exe_regFileWriteAddress != dec_rs1Address
                        // &&
                        mem_regFileWriteAddress == dec_rs1Address
                    )
                    ||
                    (
                        // exe_regFileWriteAddress != dec_rs2Address
                        // &&
                        mem_regFileWriteAddress == dec_rs2Address
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
                        // exe_regFileWriteAddress != dec_rs1Address
                        // &&
                        // mem_regFileWriteAddress != dec_rs1Address
                        // &&
                        wb_regFileWriteAddress == dec_rs1Address
                    )
                    ||
                    (
                        // exe_regFileWriteAddress != dec_rs2Address
                        // &&
                        // mem_regFileWriteAddress != dec_rs2Address
                        // &&
                        wb_regFileWriteAddress == dec_rs2Address
                    )
                )
            )
            ||
            exe_isBranch == 1
        ) begin
            pcWriteEnable <= 0;
            if_kill <= 1;
            dec_kill <= 1;
        end else begin
            pcWriteEnable <= 1;
            if_kill <= 0;
            dec_kill <= 0;
        end
    end


endmodule


`endif
