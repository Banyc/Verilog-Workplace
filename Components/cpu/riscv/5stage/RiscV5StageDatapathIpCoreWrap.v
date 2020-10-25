`ifndef __RiscV5StageDatapathIpCoreWrap__
`define __RiscV5StageDatapathIpCoreWrap__

`include "Components/cpu/riscv/5stage/RiscV5StageDatapath.v"

// Ip Core:
// RAM
// - Component Name: Ram32bIp
// - Memory Type: Single Port RAM
// - Memory Size
//   - Write Width: 32
//   - Write Depth: 1024
//   - Read Width: 32
// - Memory Initialization
//   - Load Init File: true
//   - Coe File: !!!

// ROM
// - Component Name: Rom32bIp
// - Memory Type: Single Port ROM
// - Memory Size
//   - Read Width: 32
//   - Read Depth: 1024
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

    // begin: RAM datapath
    Ram32bIp ram32b_inst(
        .clka(!clk),
        .wea(memoryWriteEnable),
        .addra(memoryAddress[11 : 2]),
        .dina(memoryWriteData),
        .douta(memoryReadData)
    );
    // end: RAM datapath

    // begin: ROM datapath
    Rom32bIp rom32b_inst(
        .clka(clk),
        .addra(pc[11 : 2]),
        .douta(instruction)
    );
    // end: ROM datapath
    
endmodule

`endif
