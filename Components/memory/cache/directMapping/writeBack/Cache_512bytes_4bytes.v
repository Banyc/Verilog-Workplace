`ifndef _Cache_512bytes_4bytes_v_
`define _Cache_512bytes_4bytes_v_

// write-back
// direct mapping
// capacity: 512 bytes
// block size: 4 bytes

module Cache_512bytes_4bytes (
    clk,
    rst,
    cache_req_addr,  // write/read address from pipeline
    cache_req_data,  // data to write to cache, which is required from pipeline
    cache_req_wen,  // if cache write enable
    cache_req_valid,  // is write/read request to cache valid
    cache_res_data,  // read data from cache to pipeline
    cache_res_stall,  // should pipeline stall
    mem_req_addr,  // write/read address to memory
    mem_req_data,  // data to write to memory
    mem_req_wen,  // if memory write enable
    mem_req_valid,  // is write/read request to memory valid
    mem_res_data,  // read data from memory to cache
    mem_res_valid  // is task that read data from memory done
);
    input         clk;
    input         rst;
    input  [31:0] cache_req_addr;
    input  [31:0] cache_req_data;
    input         cache_req_wen;
    input         cache_req_valid;
    output [31:0] cache_res_data;
    output        cache_res_stall;
    output [31:0] mem_req_addr;
    output [31:0] mem_req_data;
    output        mem_req_wen;
    output        mem_req_valid;
    input  [31:0] mem_res_data;
    input         mem_res_valid;
    
    

endmodule

`endif
