`ifndef __RiscV5StageDatapathIpCoreWrap__
`define __RiscV5StageDatapathIpCoreWrap__

`include "Components/cpu/riscv/5stage/RiscV5StageDatapath.v"

// Ip Core:
// RAM
// - Block Memory
// - Component Name: Ram32bIp
// - Memory Type: Single Port RAM
// - Addressing Options
//   - Enable 32-bit Address: true
// - Memory Size
//   - Write Width: 32
//   - Write Depth: 1024
//   - Read Width: 32
// - Memory Initialization
//   - Load Init File: true
//   - Coe File: !!!

// ROM
// - Distributed Memory
// - Component Name: Rom32bIp
// - Options
//   - Depth: 1024
//   - Data Width: 32
// - Memory Type: ROM
// - Memory Initialization
//   - Load Init File: true
//   - Coe File: !!!

module RiscV5StageDatapathIpCoreWrap (
    clk,
    rst,
    instruction,
    pc,
    regFileReadRegisterDebug,
    regFileReadDataDebug
);
    input wire clk;
    input wire rst;
    output wire [31:0] instruction;
    output wire [31:0] pc;
    wire [31:0] memoryAddress;
    wire memoryWriteEnable;
    wire memoryReadEnable;
    wire [31:0] memoryWriteData;
    wire [31:0] memoryReadData;
    input wire [4:0] regFileReadRegisterDebug;
    output wire [31:0] regFileReadDataDebug;

    // CPU
    RiscV5StageDatapath cpu(
        .clk(clk),
        .rst(rst),
        // external control
        .isStallAll(1'b0),
        // ROM
        .instruction(instruction),
        .pc(pc),
        // RAM
        .memoryAddress(memoryAddress),
        .memoryReadEnable(memoryReadEnable),
        .memoryWriteEnable(memoryWriteEnable),
        .memoryWriteData(memoryWriteData),
        .memoryReadData(memoryReadData),
        // Registers
        .regFileReadRegisterDebug(regFileReadRegisterDebug),
        .regFileReadDataDebug(regFileReadDataDebug)
    );

    // // begin: RAM datapath
    // Ram32bIp ram32b_inst(
    //     .clka(!clk),
    //     .wea(memoryWriteEnable),
    //     .addra(memoryAddress[11 : 2]),
    //     .dina(memoryWriteData),
    //     .douta(memoryReadData)
    // );
    // // end: RAM datapath
    // begin: RAM datapath
    Ram32bIp ram32b_inst(
        .clka(!clk),
        .wea({
            memoryWriteEnable,
            memoryWriteEnable,
            memoryWriteEnable,
            memoryWriteEnable
        }),
        .addra(memoryAddress),
        .dina(memoryWriteData),
        .douta(memoryReadData)
    );
    // end: RAM datapath

    // begin: ROM datapath
    Rom32bIp rom32b_inst(
        .a(pc[11 : 2]),
        .spo(instruction)
    );
    // end: ROM datapath
    
endmodule

`endif
