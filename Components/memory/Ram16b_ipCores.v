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

// NOTICE: this line should only used for development. In ISE, this line won't be in effect.
`include "./Components/memory/ipcore_dir/Ram32b.v"

module Ram16b_ipCores(
    clk,
    // rst,
    addr,
    // write
    write_en,
    write_data,
    // read
    read_data_1,
    // endian
    is_little_endian
);

    input clk;
    input [3:0] addr;  // the last bit is to distinguish the upper half or the later half of the read word
    // write
    input write_en;
    input [15:0] write_data;
    // read
    output reg [15:0] read_data_1;
    // endian
    input is_little_endian;

    wire [31:0] m_read_data;
    reg [31:0] m_write_data;

    // NOTICE: include the IP cores called Ram16b in ISE
    // 32-bit memory
    // data size := 32 bits width; 8 addresses; address size := 3
    Ram32b myram(.clka(clk), .wea(write_en), .dina(m_write_data), .addra(addr[3:1]), .douta(m_read_data));

    always @(*) begin
        if (is_little_endian) begin
            if (addr[0] == 0) begin
                read_data_1 = m_read_data[15:0];
            end else begin
                read_data_1 = m_read_data[31:16];
            end
        end else begin
            if (addr[0] == 0) begin
                read_data_1 = {m_read_data[7:0], m_read_data[15:8]};
            end else begin
                read_data_1 = {m_read_data[23:16], m_read_data[31:24]};
            end
        end
        if (addr[0] == 0) begin
            m_write_data = {m_read_data[31:16], write_data};
        end else begin
            m_write_data = {write_data, m_read_data[15:0]};
        end
    end

endmodule // Ram16b_ipCores
