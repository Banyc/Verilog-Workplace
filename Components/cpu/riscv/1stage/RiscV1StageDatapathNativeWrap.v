`ifndef __RiscV1StageDatapathNativeWrap__
`define __RiscV1StageDatapathNativeWrap__

`include "Components/cpu/riscv/1stage/RiscV1StageDatapath.v"
`include "Components/memory/Ram32b.v"
`include "Components/memory/Rom32b.v"

module RiscV1StageDatapathNativeWrap (
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
    Ram32b ram32b_inst(
        .clk(clk),
        .rst(rst),
        .address(aluOut),
        .readEnable(memoryReadEnable),
        .writeEnable(memoryWriteEnable),
        .writeData(rs2),
        .readData(memoryOut)
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
