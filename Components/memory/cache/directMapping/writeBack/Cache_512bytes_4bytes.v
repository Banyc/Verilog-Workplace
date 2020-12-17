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
    input  wire        clk;
    input  wire        rst;
    input  wire [31:0] cache_req_addr;
    input  wire [31:0] cache_req_data;
    input  wire        cache_req_wen;
    input  wire        cache_req_valid;
    output wire [31:0] cache_res_data;
    output wire        cache_res_stall;
    output wire [31:0] mem_req_addr;
    output wire [31:0] mem_req_data;
    output wire        mem_req_wen;
    output wire        mem_req_valid;
    input  wire [31:0] mem_res_data;
    input  wire        mem_res_valid;

    assign mem_req_addr = cache_req_addr;
    
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
    wire [22:0] tagField = dataStorageRowSelected[24:2];
    wire [31:0] dataField = dataStorageRowSelected[56:25];
    wire        isHit = 
                    addressTagField == tagField &
                    validBit;

    wire isWriteDataStorage =
        cache_req_wen & 
        cache_req_valid &
        isHit;

    integer i;
    always @(posedge clk or rst) begin
        if (rst) begin
            // clean dataStorage valid bits
            for (i = 0; i < 128; i = i + 1) begin
                dataStorage[i] = 57'b0;
            end
        end else begin
            if (isWriteDataStorage) begin
                dataStorage[addressIndexField][56:25] = 
                    cache_req_data;
            end else begin
                dataStorage[addressIndexField][56:25] = 
                    dataStorage[addressIndexField][57:26];
            end
        end
    end



endmodule

`endif
