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
`include "./Components/register/Register16b_ipCores.v"

module Register16b_ipCores_tb(
);

    reg clk;
    reg [3:0] addr;  // the last bit is to distinguish the upper half or the later half of the read word
    // write
    reg write_en;
    reg [15:0] write_data;
    // read
    wire [15:0] read_data_1;
    // endian
    reg is_little_endian;

    Register16b_ipCores ram16b(
        clk,
        addr,  // the last bit is to distinguish the upper half or the later half of the read word
        // write
        write_en,
        write_data,
        // read
        read_data_1,
        // endian
        is_little_endian
    );

    initial begin
        clk = 0;

        write_en = 0;
        addr = 0;
        write_data = 0;
        is_little_endian = 0;

        # 30;

        addr = 1;
        write_data = 16'h4141;

        # 30;

        write_en = 1;

        # 30;

        write_en = 0;
        addr = 0;

        # 30;
        
        // test endian

        

    end

    always begin
        #10;
        clk = ~clk;
    end

endmodule // Register16b_ipCores_tb
