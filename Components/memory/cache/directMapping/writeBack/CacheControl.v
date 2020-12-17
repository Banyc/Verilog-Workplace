`ifndef __CacheControl_V__
`define __CacheControl_V__

module CacheControl (
    clk,
    rst,
    isDirty,
    isHit,
    cache_req_valid,  // is write/read request to cache valid
    mem_res_valid,  // read data from memory to cache
    mem_req_valid,  // is write/read request to memory valid
    mem_req_wen,  // if memory write enable
    cache_res_stall,  // should pipeline stall
    isFinish
);
    input wire  clk;
    input wire  rst;
    input wire  isDirty;
    input wire  isHit;
    input wire  cache_req_valid;
    input wire  mem_res_valid;
    output reg  mem_req_valid;
    output reg  mem_req_wen;
    output reg  cache_res_stall;
    output reg  isFinish;
    
    reg [2:0] state;
    reg [2:0] nextState;

    // Cache 正常读写,即 Load/Store 命中或者未使用 Cache。
    parameter S_IDLE = 0;
    // 发生 Cache Miss,且被替换块中存在脏数,此时需要对脏数据先进行写回
    // write back dirty page to memory
    parameter S_BACK = 1;
    // 写回等待阶段,完成后自动跳转至 S_FILL 状态。
    parameter S_BACK_WAIT = 2;
    // 发生 Cache Miss 或者写回已经完成,目标位置上不存在脏数据,可以直接从 Memory 中取回数据进行替换。
    parameter S_FILL = 3;
    // 填充等待阶段,完成后表示目标数据已经加载到 Cache 中,自动跳转至 S_IDLE 状态。
    parameter S_FILL_WAIT = 4;

    always @(posedge clk or rst) begin
        if (rst) begin
            state = S_IDLE;
        end else begin
            state = nextState;
        end
    end

    always @(*) begin
        mem_req_valid = 0;
        mem_req_wen = 0;
        cache_res_stall = 0;
        isFinish = 0;
        case (state)
            S_IDLE: begin
                if (cache_req_valid & !isHit) begin
                    if (isDirty) begin
                        nextState = S_BACK;
                    end else begin
                        nextState = S_FILL;
                    end
                end else begin
                    nextState = S_IDLE;
                end
            end
            S_BACK: begin
                mem_req_valid = 1;
                mem_req_wen = 1;
                cache_res_stall = 1;
                nextState = S_BACK_WAIT;
            end
            S_BACK_WAIT: begin
                if (mem_res_valid) begin
                    mem_req_valid = 1;
                    mem_req_wen = 1;
                    cache_res_stall = 1;
                    nextState = S_FILL;
                end else begin
                    cache_res_stall = 1;
                    nextState = S_BACK_WAIT;
                end
            end
            S_FILL: begin
                mem_req_valid = 1;
                mem_req_wen = 0;
                cache_res_stall = 1;
                nextState = S_FILL_WAIT;
            end
            S_FILL_WAIT: begin
                if (mem_res_valid) begin
                    mem_req_valid = 1;
                    mem_req_wen = 0;
                    cache_res_stall = 1;
                    nextState = S_IDLE;
                end else begin
                    cache_res_stall = 1;
                    isFinish = 1;
                    nextState = S_FILL_WAIT;
                end
            end
            default: begin
                nextState = S_IDLE;
            end
        endcase
    end

endmodule

`endif
