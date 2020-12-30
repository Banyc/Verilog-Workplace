`ifndef __Cache_512bytes_4bytes_v__
`define __Cache_512bytes_4bytes_v__

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
    mem_res_valid,  // is task that write/read data from memory done
    debugCacheIndex,
    debugCacheRowOutput
);
    input  wire        clk;
    input  wire        rst;
    input  wire [31:0] cache_req_addr;
    input  wire [31:0] cache_req_data;
    input  wire        cache_req_wen;
    input  wire        cache_req_valid;
    output wire [31:0] cache_res_data;
    output reg         cache_res_stall;
    output reg  [31:0] mem_req_addr;
    output wire [31:0] mem_req_data;
    output reg         mem_req_wen;
    output reg         mem_req_valid;
    input  wire [31:0] mem_res_data;
    input  wire        mem_res_valid;

    input wire [6:0] debugCacheIndex;
    output wire [56:0] debugCacheRowOutput;
    assign debugCacheRowOutput = dataStorage[debugCacheIndex];

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

    wire [22:0] addressTagField = cache_req_addr[31:9];
    wire [6:0] addressIndexField = cache_req_addr[8:2];

    wire [56:0] dataStorageRowSelected = dataStorage[addressIndexField];
    wire        validBit = dataStorageRowSelected[1];
    wire        isDirty = dataStorageRowSelected[0];
    wire [22:0] tagField = dataStorageRowSelected[24:2];
    wire [31:0] dataField = dataStorageRowSelected[56:25];
    wire        isHit = 
                    addressTagField == tagField &&
                    validBit;

    assign mem_req_data = dataField;

    wire [31:0] writeBackAddress = {tagField, addressIndexField, cache_req_addr[1:0]};

    // read
    assign cache_res_data = dataStorage[addressIndexField][56:25];

    // debug counters
    integer updateCount_write = 0;
    integer updateCount_simpleWrite = 0;
    integer updateCount_allocate = 0;
    integer updateCount_allocate_then_write = 0;
    
    // @follow-up control

    reg [2:0] state;

    // Cache 正常读写,即 Load/Store 命中或者未使用 Cache。
    parameter S_IDLE = 3'h0;
    // 发生 Cache Miss,且被替换块中存在脏数,此时需要对脏数据先进行写回
    // write back dirty page to memory
    parameter S_BACK = 3'h1;
    // 写回等待阶段,完成后自动跳转至 S_FILL 状态。
    parameter S_BACK_WAIT = 3'h2;
    // 发生 Cache Miss 或者写回已经完成,目标位置上不存在脏数据,可以直接从 Memory 中取回数据进行替换。
    parameter S_FILL = 3'h3;
    // 填充等待阶段,完成后表示目标数据已经加载到 Cache 中,自动跳转至 S_IDLE 状态。
    parameter S_FILL_WAIT = 3'h4;
    // write new data into cache block
    parameter S_FILL_WRITE = 3'h5;

    task writeBackToBlock(input [31:0] newData);
        begin
            // data field
            dataStorage[addressIndexField][56:25] = 
                newData;
            // tag field
            dataStorage[addressIndexField][24:2] =
                addressTagField;
            // dirty bit
            dataStorage[addressIndexField][0] = 1;
            // count up
            updateCount_write = updateCount_write + 1;
        end
    endtask

    // reg [31:0] addressCache = 0;
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // clean dataStorage valid bits
            for (i = 0; i < 128; i = i + 1) begin
                dataStorage[i] = 57'b0;
            end
            state <= S_IDLE;
        end else begin
            // addressCache = addressCache;
            mem_req_valid = 0;
            mem_req_wen = 0;
            cache_res_stall = 0;
            case (state)
                S_IDLE: begin
                    if (cache_req_valid) begin
                        if (isHit) begin
                            // done
                            cache_res_stall = 0;
                            // valid bit
                            dataStorage[addressIndexField][1] = 1;
                            if (cache_req_wen) begin
                                writeBackToBlock(cache_req_data);
                                updateCount_simpleWrite = updateCount_simpleWrite + 1;
                            end else begin
                                // do nothing
                            end
                            state <= S_IDLE;
                        end else begin
                            cache_res_stall = 1;
                            // addressCache = cache_req_addr;
                            if (isDirty) begin
                                state <= S_BACK;
                            end else begin
                                state <= S_FILL;
                            end
                        end
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_BACK: begin
                    mem_req_addr = writeBackAddress;
                    mem_req_valid = 1;
                    mem_req_wen = 1;
                    cache_res_stall = 1;
                    state <= S_BACK_WAIT;
                end
                S_BACK_WAIT: begin
                    if (mem_res_valid) begin
                        cache_res_stall = 1;
                        state <= S_FILL;
                    end else begin
                        mem_req_addr = writeBackAddress;
                        mem_req_valid = 1;
                        mem_req_wen = 1;
                        cache_res_stall = 1;
                        state <= S_BACK_WAIT;
                    end
                end
                S_FILL: begin
                    mem_req_addr = cache_req_addr;
                    mem_req_valid = 1;
                    mem_req_wen = 0;
                    cache_res_stall = 1;
                    state <= S_FILL_WAIT;
                end
                S_FILL_WAIT: begin
                    if (mem_res_valid) begin
                        // valid bit
                        dataStorage[addressIndexField][1] = 1;
                        // read data from memory to block
                        writeBackToBlock(mem_res_data);
                        updateCount_allocate = updateCount_allocate + 1;

                        if (cache_req_wen) begin
                            // not done yet
                            cache_res_stall = 1;
                            // write new data into cache block
                            state <= S_FILL_WRITE;
                        end else begin
                            // done
                            cache_res_stall = 0;
                            // mark the block as not dirty
                            dataStorage[addressIndexField][0] = 0;
                            state <= S_IDLE;
                        end
                    end else begin
                        mem_req_addr = cache_req_addr;
                        mem_req_valid = 1;
                        mem_req_wen = 0;
                        cache_res_stall = 1;
                        state <= S_FILL_WAIT;
                    end
                end
                S_FILL_WRITE: begin
                    // done
                    cache_res_stall = 0;
                    // write new data into cache block
                    writeBackToBlock(cache_req_data);
                    updateCount_allocate_then_write = updateCount_allocate_then_write + 1;
                    // mark the block as dirty
                    dataStorage[addressIndexField][0] = 1;
                    state <= S_IDLE;
                end
                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule

`endif
