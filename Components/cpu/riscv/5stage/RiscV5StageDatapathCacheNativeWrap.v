`ifndef __RiscV5StageDatapathCacheNativeWrap__
`define __RiscV5StageDatapathCacheNativeWrap__

`include "Components/cpu/riscv/5stage/RiscV5StageDatapath.v"
`include "Components/memory/LatencyRam.v"
`include "Components/memory/cache/directMapping/writeBack/Cache_512bytes_4bytes.v"
`include "Components/memory/Rom32b.v"

module RiscV5StageDatapathCacheNativeWrap (
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

    wire isStallAll;

    // CPU
    RiscV5StageDatapath cpu(
        .clk(clk),
        .rst(rst),
        // external control
        .isStallAll(isStallAll),
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
        .cache_res_stall(isStallAll),  // should pipeline stall
        .mem_req_addr(ram_mem_req_addr),  // write/read address to memory
        .mem_req_data(ram_mem_req_data),  // data to write to memory
        .mem_req_wen(ram_mem_req_wen),  // if memory write enable
        .mem_req_valid(ram_mem_req_valid),  // is write/read request to memory valid
        .mem_res_data(ram_mem_res_data),  // read data from memory to cache
        .mem_res_valid(ram_mem_res_valid)  // is task that write/read data from memory done
    );
    LatencyRam ram_inst(
        .clk(!clk),
        .rst(rst),
        .en(ram_mem_req_valid),
        .we(ram_mem_req_wen),
        .addr(ram_mem_req_addr),
        .data_in(ram_mem_req_data),
        .data_out(ram_mem_res_data),
        .isFinish(ram_mem_res_valid)
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
