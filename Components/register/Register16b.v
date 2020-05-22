// 目标：存储器读。自选合适位数的存储器，按每zjie地址为内容初始化该存储器，选择地址读出显示。系统按16位zjie字节编址。

// 输入：

// 　开　关：八个开关表示8位按16位zjie编址的存储器地址。

// 　按　钮：[可选]当按字读出时，最右按/不按选择显示大头/小头不同设计。

// 输出：

// 　发光管：自定。

// 　四数码：显示存储器读写地址(按zjie寻址)。

// 　八数码：显示32位存储器读写数据。

// COE：

// 　memory_initialization_radix=16;

// 　memory_initialization_vector=

// 　　00010203, 04050607, 08090A0B, 0C0D0E0F, ... 12345678;

// 考虑1：考虑对齐/不对齐读。

// 考虑2：以显存文本方式显示。

module Register16b(
    clk,
    rst,
    // write
    write_en,
    write_addr,
    write_data,
    // read
    read_addr_1,
    read_data_1,
    read_addr_2,
    read_data_2,
    // endian
    is_little_endian
);

    input clk;
    input rst;
    // write
    input write_en;
    input [2:0] write_addr;
    input [15:0] write_data;
    // read
    input [2:0] read_addr_1;
    output reg [15:0] read_data_1;
    input [2:0] read_addr_2;
    output reg [15:0] read_data_2;
    // endian
    input is_little_endian;

    // memory
    reg [15:0] memory [7:0];

    // Rem myram(.CLKA(clk), .WEA(1'b0), .DINA(1'b0), .ADDRA(), .DOUTA());

    always @(*) begin
        if (is_little_endian) begin
            assign read_data_1 = memory[read_addr_1];
            assign read_data_2 = memory[read_addr_2];
        end else begin
            // assign read_data_1 = {memory[read_addr_1][7:0], memory[read_addr_1][15:8], memory[read_addr_1][23:16], memory[read_addr_1][31:24]};
            // assign read_data_2 = {memory[read_addr_2][7:0], memory[read_addr_2][15:8], memory[read_addr_2][23:16], memory[read_addr_2][31:24]};
            assign read_data_1 = {memory[read_addr_1][7:0], memory[read_addr_1][15:8]};
            assign read_data_2 = {memory[read_addr_2][7:0], memory[read_addr_2][15:8]};
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            // memory[0] = 32'h00010203;
            // memory[1] = 32'h04050607;
            // memory[2] = 32'h08090A0B;
            // memory[3] = 32'h0C0D0E0F;
            // memory[4] = 32'h0C0D0E0F;
            // memory[5] = 32'h0C0D0E0F;
            // memory[6] = 32'h0C0D0E0F;
            // memory[7] = 32'h0C0D0E0F;
            // memory[8] = 32'h0C0D0E0F;
            // memory[9] = 32'h0C0D0E0F;
            // memory[10] = 32'h0C0D0E0F;
            // memory[11] = 32'h0C0D0E0F;
            // memory[12] = 32'h0C0D0E0F;
            // memory[13] = 32'h0C0D0E0F;
            // memory[14] = 32'h0C0D0E0F;
            // memory[15] = 32'h12345678;

            memory[0] = 16'h0001;
            memory[1] = 16'h0203;
            memory[2] = 16'h0405;
            memory[3] = 16'h0607;
            memory[4] = 16'h0809;
            memory[5] = 16'h0A0B;
            memory[6] = 16'h0C0D;
            memory[7] = 16'h0E0F;
        end
        if (write_en)
            memory[write_addr] <= write_data;
    end

endmodule // Register16b
