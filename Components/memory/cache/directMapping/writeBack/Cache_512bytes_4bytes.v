`ifndef _Cache_512bytes_4bytes_v_
`define _Cache_512bytes_4bytes_v_

`include "Components/memory/cache/directMapping/writeBack/CacheControl.v"

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
    mem_res_valid  // is task that write/read data from memory done
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

    assign mem_req_data = dataField;

    wire isWriteDataStorage =
        cache_req_wen & 
        cache_req_valid &
        isHit;

    wire isAllocateFinish;

    // read
    assign cache_res_data = dataStorage[addressIndexField][56:25];

    // write
    integer i;
    always @(posedge isAllocateFinish or posedge clk or rst) begin
        if (isAllocateFinish) begin
            // data field
            dataStorage[addressIndexField][56:25] = mem_res_data;

            // dirty bit
            if (cache_req_wen) begin
                dataStorage[addressIndexField][0] = 1;
                dataStorage[addressIndexField][56:25] = cache_req_data;
            end else begin
                if (isHit) begin
                    dataStorage[addressIndexField][0] = dataStorage[addressIndexField][0];
                end else begin
                    dataStorage[addressIndexField][0] = 0;
                end
            end

            // valid bit
            // this change must be after that to dirty bit
            dataStorage[addressIndexField][1] = 1;
        
        end else begin
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
                        dataStorage[addressIndexField][56:25];
                end
            end
        end
    end

    CacheControl cacheControl_inst(
        .clk(clk),
        .rst(rst),
        .isDirty(dirtyBit),
        .isHit(isHit),
        .cache_req_valid(cache_req_valid),  // is write/read request to cache valid
        .mem_res_valid(mem_res_valid),  // read data from memory to cache
        .mem_req_valid(mem_req_valid),  // is write/read request to memory valid
        .mem_req_wen(mem_req_wen),  // if memory write enable
        .cache_res_stall(cache_res_stall),  // should pipeline stall
        .isFinish(isAllocateFinish)
    );



endmodule

`endif
