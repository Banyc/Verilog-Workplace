`ifndef __RiscV5StageDatapathNativeWrap__
`define __RiscV5StageDatapathNativeWrap__

`include "Components/cpu/riscv/5stage/RiscV5StageDatapath.v"
`include "Components/memory/Ram32b.v"
`include "Components/memory/Rom32b.v"

module RiscV5StageDatapathNativeWrap (
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
    Ram32b ram32b_inst(
        .clk(clk),
        .rst(rst),
        .address(memoryAddress),
        .readEnable(memoryReadEnable),
        .writeEnable(memoryWriteEnable),
        .writeData(memoryWriteData),
        .readData(memoryReadData)
    );
    // end: RAM datapath

    // begin: ROM datapath
    Rom32b rom32b_inst(
        .rst(rst),
        .readAddress(pc),
        .data(instruction)
    );
    // end: ROM datapath
    
endmodule

`endif
