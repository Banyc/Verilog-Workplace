

`include "Components/memory/cache/directMapping/writeBack/Cache_512bytes_4bytes.v"
`include "Components/memory/ram32b.v"
`include "Components/memory/LatencyRam.v"

module Cache_512bytes_4bytes_tb (
    
);

    reg        clk;
    reg        rst;
    reg [31:0] cache_req_addr;
    reg [31:0] cache_req_data;
    reg        cache_req_wen;
    reg        cache_req_valid;
    wire [31:0] cache_res_data;
    wire        cache_res_stall;
    wire [31:0] mem_req_addr;
    wire [31:0] mem_req_data;
    wire        mem_req_wen;
    wire        mem_req_valid;
    wire [31:0] mem_res_data;
    wire        mem_res_valid;


    Cache_512bytes_4bytes cache(
        !clk,
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

    LatencyRam ram(
        .clk(!clk),
        .rst(rst),
        .en(mem_req_valid),
        .we(mem_req_wen),
        .addr(mem_req_addr),
        .data_in(mem_req_data),
        .data_out(mem_res_data),
        .isFinish(mem_res_valid)
    );

    // Ram32b ram(
    //     .clk(clk),
    //     .rst(rst),
    //     .address(mem_req_addr),
    //     .readEnable(mem_req_valid & !mem_req_wen),
    //     .writeEnable(mem_req_valid & mem_req_wen),
    //     .writeData(mem_req_data),
    //     .readData(mem_res_data)
    // );

    reg [31:0] readData;

    integer state = 0;
    always @(posedge clk) begin
        if (cache_res_stall) begin
            state <= state;
        end else begin
            readData = cache_res_data;
            case (state)
                0: begin
                    cache_req_valid = 0;
                    state <= 1;
                end
                1: begin
                    cache_req_valid = 0;
                    state <= 2;
                end
                2: begin
                    cache_req_valid = 0;
                    state <= 3;
                end
                3: begin
                    // write 0xbeef to 0x4
                    cache_req_addr = 32'h4;
                    cache_req_data = 32'hbeef;
                    cache_req_wen = 1;
                    cache_req_valid = 1;
                    
                    state <= 4;
                end
                4: begin
                    // read 0x4
                    cache_req_addr = 32'h4;
                    cache_req_data = 32'haaaa;
                    cache_req_wen = 0;
                    cache_req_valid = 1;
                    
                    state <= 5;
                end
                5: begin
                    // read 0x8
                    cache_req_addr = 32'h8;
                    cache_req_data = 32'haaaa;
                    cache_req_wen = 0;
                    cache_req_valid = 1;
                    
                    state <= 6;
                end
                6: begin
                    // write 0xdead to 0x4 + (128 << 2)
                    cache_req_addr = (32'd128 << 2) + 32'h4;
                    cache_req_data = 32'hdead;
                    cache_req_wen = 1;
                    cache_req_valid = 1;
                    
                    state <= 7;
                end
                7: begin
                    // write 0xf00d to 0x8 + (128 << 2)
                    cache_req_addr = (32'd128 << 2) + 32'h8;
                    cache_req_data = 32'hf00d;
                    cache_req_wen = 1;
                    cache_req_valid = 1;
                    
                    state <= 8;
                end
                8: begin
                    // read 0x4
                    cache_req_addr = 32'h4;
                    cache_req_data = 32'haaaa;
                    cache_req_wen = 0;
                    cache_req_valid = 1;
                    
                    state <= 9;
                end
                9: begin
                    // dummy state to update state
                    cache_req_valid = 0;
                    state <= 10;
                end

                default: begin
                    cache_req_valid = 0;
                    state <= state;
                end
            endcase
        end
    end

    initial begin
        $dumpfile("Cache_512bytes_4bytes_tb.vcd"); $dumpvars(0, Cache_512bytes_4bytes_tb);
        clk = 1;
        rst = 1;
        # 10;
        rst = 0;
        
        #2900; $finish;
    end

    always begin
        # 5;
        clk = !clk;
    end

endmodule
