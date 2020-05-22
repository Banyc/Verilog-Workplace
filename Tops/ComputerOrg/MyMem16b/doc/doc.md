# 存储器实现 & 存储器读写

## 实验目的

目标：存储器读写。自选合适的方式选择地址写入32位数据，并能按任意地址读出存储器数据。系统按16位zjie编址。

输入：

　开　关：八个开关表示8位按16位zjie编址的存储器地址。

　按　钮：[可选]当按字读出时，最右按/不按选择显示大头/小头不同设计。

输出：

　发光管：自定。

　四数码：显示存储器读写地址(按zjie寻址)。

　八数码：显示32位存储器读写数据。

<!-- 注意：当地址不对齐时，

　读：需要读出几个相邻单元拚接。

　写：需要读出几个相邻单元拚接后写入。 -->

<!-- 检查：32位存储器的初始化coe文件为：

memory_initialization_radix = 16;

memory_initialization_vector = 00112233, 44556677, 8899AABB, CCDDEEFF;

选择在地址0~7写入字数据0x12345678，检查地址0~8的读出显示。 -->

## 实验过程

首先编写 COE 文件如下：

```
memory_initialization_radix = 16;
memory_initialization_vector =
    00010203,
    04050607,
    08090A0B,
    0C0D0E0F,
    00102030,
    40506070,
    8090A0B0,
    C0D0E0F0
    ;
```

接着利用 IP cores 生成一个 word size 为 32 bits，并且 words 的数量为 8 的 Block Memory

![Memory Settings](img/2020-04-21-14-18-42.png)

然后导入 COE

![COE Config](img/2020-04-21-14-19-40.png)

确认无误以后，编写控制代码如下：

```verilog
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
```

测试代码，波形图呈现在实例分析小节。

编写 Top 模块，实现相应功能：

输入：

　开　关：八个开关表示8位按16位zjie编址的存储器地址。

　按　钮：[可选]当按字读出时，最右按/不按选择显示大头/小头不同设计。

输出：

　发光管：自定。

　四数码：显示存储器读写地址(按zjie寻址)。

　八数码：显示32位存储器读写数据。

形成最终项目：

![Project](img/2020-04-21-14-31-27.png)

## 实例分析

波形图如下：

![波形图](img/2020-04-21-14-04-23.png)

可以看出，在 big-endian 的模式下，原本的储存的数值 0x0203 输出方式成功改变成了 0x0302。接着可以观察到，当我改变 0x1 地址下的值为 0x4141 以后，当前地址的值的确被改变了。将读取地址变为 0x0 之后，可以看到储存在 0x0 的值并没有随之发生变化，因此可以证明对 half-word 的操作不会影响到储存器的其他值。
