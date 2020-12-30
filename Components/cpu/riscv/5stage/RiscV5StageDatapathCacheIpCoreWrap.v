`ifndef __RiscV5StageDatapathCacheIpCoreWrap__
`define __RiscV5StageDatapathCacheIpCoreWrap__

`include "Components/cpu/riscv/5stage/RiscV5StageDatapath.v"
`include "Components/memory/LatencyMemory.v"
`include "Components/memory/cache/directMapping/writeBack/Cache_512bytes_4bytes.v"

module RiscV5StageDatapathCacheIpCoreWrap (
    clk,
    rst,
    instruction,
    pc,
    regFileReadRegisterDebug,
    regFileReadDataDebug,
    romCacheIndexDebug,
    romCacheRowOutputDebug,
    ramCacheIndexDebug,
    ramCacheRowOutputDebug
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
    input wire [6:0] romCacheIndexDebug;
    output wire [56:0] romCacheRowOutputDebug;
    input wire [6:0] ramCacheIndexDebug;
    output wire [56:0] ramCacheRowOutputDebug;

    wire ram_isStallAll;
    wire rom_isStallAll;

    // CPU
    RiscV5StageDatapath cpu(
        .clk(clk),
        .rst(rst),
        // external control
        .isStallAll(ram_isStallAll || rom_isStallAll),
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
    wire [31:0] ram_mem_req_addr; 
    wire [31:0] ram_mem_req_data; 
    wire        ram_mem_req_wen;  
    wire        ram_mem_req_valid;
    wire [31:0] ram_mem_res_data; 
    wire        ram_mem_res_valid;
    Cache_512bytes_4bytes ram_cache_inst(
        .clk(!clk),
        .rst(rst),
        .cache_req_addr(memoryAddress),  // write/read address from pipeline
        .cache_req_data(memoryWriteData),  // data to write to cache, which is required from pipeline
        .cache_req_wen(memoryWriteEnable),  // if cache write enable
        .cache_req_valid(memoryReadEnable || memoryWriteEnable),  // is write/read request to cache valid
        .cache_res_data(memoryReadData),  // read data from cache to pipeline
        .cache_res_stall(ram_isStallAll),  // should pipeline stall
        .mem_req_addr(ram_mem_req_addr),  // write/read address to memory
        .mem_req_data(ram_mem_req_data),  // data to write to memory
        .mem_req_wen(ram_mem_req_wen),  // if memory write enable
        .mem_req_valid(ram_mem_req_valid),  // is write/read request to memory valid
        .mem_res_data(ram_mem_res_data),  // read data from memory to cache
        .mem_res_valid(ram_mem_res_valid),  // is task that write/read data from memory done
        .debugCacheIndex(ramCacheIndexDebug),
        .debugCacheRowOutput(ramCacheRowOutputDebug)
    );
    wire ram_latency_clk;
    LatencyMemory ram_control_inst(
        .clk(!clk),
        .clk_latency(ram_latency_clk),
        .rst(rst),
        .en(ram_mem_req_valid),
        .we(ram_mem_req_wen),
        // .addr(ram_mem_req_addr),
        // .data_in(ram_mem_req_data),
        // .data_out(ram_mem_res_data),
        .hasFinished(ram_mem_res_valid)
    );
    Ram32bIp ram32b_inst(
        .clka(!ram_latency_clk),
        .wea({4 {ram_mem_req_valid & ram_mem_req_wen}}),
        .addra(ram_mem_req_addr),
        .dina(ram_mem_req_data),
        .douta(ram_mem_res_data)
    );
    // end: RAM datapath

    // begin: ROM datapath
    wire [31:0] rom_mem_req_addr; 
    wire        rom_mem_req_valid;
    wire [31:0] rom_mem_res_data; 
    wire        rom_mem_res_valid;
    Cache_512bytes_4bytes rom_cache_inst(
        .clk(!clk),
        .rst(rst),
        .cache_req_addr(pc),  // write/read address from pipeline
        .cache_req_data(32'b0),  // data to write to cache, which is required from pipeline
        .cache_req_wen(1'b0),  // if cache write enable
        .cache_req_valid(1'b1),  // is write/read request to cache valid
        .cache_res_data(instruction),  // read data from cache to pipeline
        .cache_res_stall(rom_isStallAll),  // should pipeline stall
        .mem_req_addr(rom_mem_req_addr),  // write/read address to memory
        .mem_req_data(),  // data to write to memory
        .mem_req_wen(),  // if memory write enable
        .mem_req_valid(rom_mem_req_valid),  // is write/read request to memory valid
        .mem_res_data(rom_mem_res_data),  // read data from memory to cache
        .mem_res_valid(rom_mem_res_valid),  // is task that write/read data from memory done
        .debugCacheIndex(romCacheIndexDebug),
        .debugCacheRowOutput(romCacheRowOutputDebug)
    );
    wire rom_latency_clk;
    LatencyMemory rom_control_inst(
        .clk(!clk),
        .clk_latency(rom_latency_clk),
        .rst(rst),
        .en(rom_mem_req_valid),
        .we(1'b0),
        // .addr(rom_mem_req_addr),
        // .data_out(rom_mem_res_data),
        .hasFinished(rom_mem_res_valid)
    );
    Rom32bIp rom32b_inst(
        .a(rom_mem_req_addr[11 : 2]),
        .spo(rom_mem_res_data)
    );
    // end: ROM datapath
    
endmodule

`endif
