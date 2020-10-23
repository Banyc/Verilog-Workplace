`ifndef __RiscV1StageDatapathIpCoreWrap__
`define __RiscV1StageDatapathIpCoreWrap__

`include "Components/cpu/riscv/1stage/RiscV1StageDatapath.v"

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

module RiscV1StageDatapathIpCoreWrap (
    clk,
    rst,
    instruction,
    pc,
    readRegisterDebug,
    readDataDebug
);
    input wire clk;
    input wire rst;
    output wire [31:0] instruction;
    output wire [31:0] pc;
    wire [31:0] aluOut;
    wire memoryWriteEnable;
    wire memoryReadEnable;
    wire [31:0] rs2;
    wire [31:0] memoryOut;
    input wire [4:0] readRegisterDebug;
    output wire [31:0] readDataDebug;

    // CPU
    RiscV1StageDatapath cpu(
        .clk(clk),
        .rst(rst),
        // ROM
        .instruction(instruction),
        .pc(pc),
        // RAM
        .aluOut(aluOut),
        .memoryReadEnable(memoryReadEnable),
        .memoryWriteEnable(memoryWriteEnable),
        .rs2(rs2),
        .memoryOut(memoryOut),
        // Registers
        .readRegisterDebug(readRegisterDebug),
        .readDataDebug(readDataDebug)
    );

    // begin: RAM datapath
    // Ram32b ram32b_inst(
    //     .clk(clk),
    //     .rst(rst),
    //     .address(aluOut),
    //     .readEnable(memoryReadEnable),
    //     .writeEnable(memoryWriteEnable),
    //     .writeData(rs2),
    //     .readData(memoryOut)
    // );
    Ram32bIp ram32b_inst(
        .clka(!clk),
        .wea(memoryWriteEnable),
        .addra(aluOut[11 : 2]),
        // .addra(aluOut[9 : 0]),
        .dina(rs2),
        .douta(memoryOut)
    );
    // end: RAM datapath

    // begin: ROM datapath
    // Rom32b rom32b_inst(
    //     .rst(rst),
    //     .readAddress(pc),
    //     .data(instruction)
    // );
    Rom32bIp rom32b_inst(
        .clka(clk),
        .addra(pc[11 : 2]),
        // .addra(aluOut[9 : 0]),
        .douta(instruction)
    );
    // end: ROM datapath
    
endmodule

`endif
