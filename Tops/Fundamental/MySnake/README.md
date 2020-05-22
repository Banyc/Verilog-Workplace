# Snake game in Verilog

以 verilog 语言编写的 贪吃蛇游戏

## Introduction

本游戏是基于 基础的 贪吃蛇游戏。里面将会涉及到如下几个游戏元素

- snake
- apple
- border

所有元素都由单节或多节以10个像素为边长的正方形组成。以下提到的单位皆以这些正方形为单位，而非像素。

显示屏 为 640x480 @ 60 Hz 的 VGA 显示屏

游戏区域为 540x380，居中于屏幕，相当于 setoff of x, y 分别为 50 和 50

在一次游戏内，snake 为 白色，将从1节起始，在屏幕的左上角出现，默认往右爬；Apple 为绿色，最多只会存在一个； border 为红色，围绕在屏幕四周。

4 位 16 进制 显示器 显示当前蛇的长度，也就是当前分数，以 BCD 编码，也就是显示的是十进制数

8 位 16 进制 显示器 显示随机数内容，左 4 位 和 右 4 位 分别为 不同的随机数

屏幕与游戏机制 极度耦合。

### 游戏流程

<!-- 游戏开始前，屏幕为全蓝 -->

游戏开始后，屏幕为全黑，边界出现，snake 将从 1 节长度起始，在屏幕的左上角出现，默认往右爬。

在snake接触到自己或 border 的时候，将会变成游戏结束

在snake接触到apple，snake的长度增加 1

### 游戏操作

- SW[15] 上拨并保持一个游戏时钟时间，会重置游戏
- SW[14:11] 是种子，用于初始化随机数发生器
- SW[3:0] 为备用方向键盘，从高位到低位 分别为 上下左右；上升沿触发
- 外接键盘在中间的 USB 接口，方向键为工作区域
- SW[5:4] 调节游戏速度，时间单位 从低位到高位 分别为
    - 1000ms
    - 500ms
    - 250ms
    - 100ms

## Development

这个项目需要用到多个 modules

### Keyboard_driver

将上下左右四个键的按下事件输出。

```Verilog
Keyboard_driver(clk, kb_serial_input, direction);
```

- `input clk` - 频率为 100mhz
- `input kb_serial_input` - 键盘向板子输入的信号
- `output [3:0] direction` - 输出键盘的结果，从 0-3 分别为 up, down, left, right；如果没有任何输出，输出 4'b0

如果没有新的输入，direction 必须保持上一次输出结果

### Random_generator

输出随机数。随机数可以使用一个公式持续产生。

```Verilog
Random_generator(clk, seed, x, y);
```

- `input clk` - 频率为 100mhz
- `input [3:0] seed` - 随机数的种子
- `output [9:0] x` - 输出范围为 [0, 540 - 10], 且个位一定为0
- `output [8:0] y` - 输出范围为 [0, 380 - 10], 且个位一定为0

clk每上升沿一次，给出一个新的随机数，并且保持结果不变 直到下一次clk上升。

## Contribution

请除组长的所有组员认领 Keyboard_driver 和 Random_generator 中随意一个。

如果无法在 deadline 前完成相应任务，或泄漏本项目信息，将会被组长根据离谱程度抽取贡献度。

代码不允许向小组以外的任何人或机构提供任何本项目代码。

### Deadline

暂定计划

- 认领自己的部分，从 Keyboard_driver 和 Random_generator 选一个 - Due to 2019.12.14
- 写出结果，并由组长审阅通过 - Due to 2019.12.21

如果不满意，请及时在群内讨论，否则默认满意。
