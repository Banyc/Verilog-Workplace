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
    
    // data storage
    // fields:
    //   - data
    //     - size: 32 bits
    //   - tag
    //     - size: 32 - log2(4 Bytes) - log2(512 Bytes / 4 Bytes) = 23 bits
    //   - valid bit
    //     - size: 1 bit
    //   - dirty bit
    //     - size: 1 bit
    //   - row size: 57 bits
    //   - column length: 128
    reg [56:0] dataStorage [127:0];

    wire addressTagField = cache_req_addr[31:9];
    wire addressIndexField = cache_req_addr[8:2];

    wire [56:0] dataStorageRowSelected = dataStorage[addressIndexField];
    wire        validBit = dataStorageRowSelected[1];
    wire        dirtyBit = dataStorageRowSelected[0];
    wire [22:0] tagField = dataStorageRowSelected[25:2];
    wire [31:0] dataField = dataStorageRowSelected[57:26];

    wire isWriteDataStorage = cache_req_wen & 
                   cache_req_valid &
                   addressTagField == tagField &
                   validBit;

    always @(posedge clk or rst) begin
        if (rst) begin
            
        end else begin
            if (isWriteDataStorage) begin
                dataStorage[addressIndexField][57:26] = cache_req_data;
            end else begin
                dataStorage[addressIndexField][57:26] = dataStorage[addressIndexField][57:26];
            end
        end
    end

endmodule

`endif
