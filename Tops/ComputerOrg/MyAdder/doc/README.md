# 第02周课堂实验

## 设计目的

```
目标：按理论课所讲的加法器原理图，设计4位加法器。

module Adder4(input[3:0] A, input[3:0] B, input Ctrl, input Co, output[3:0] out, ouput CF,OF,ZF,SF,PF);

输入：
  开　关：左右4位各代表十六进制被加(减)数、加(减)数。
  按　钮：最左：正常/按下分别对应：加法/减法。
输出：
  发光管：发光管自左至右显示：加法(符号SF、进位CF、溢出OF、零标志ZF、奇偶PF)，减法(符号SF、借位CF、溢出OF、零标志ZF、奇偶PF)。
  数码管：数码管自左至右分别显示：被加数(被减数)、加数(减数)、和。
说明：
  ＊：数码管最右位自定。
参考图：见：http://10.214.200.99:8080/masm/odshow.jsp?crs=jz&chpt=7n2
```

About Flags - <https://baike.baidu.com/item/FLAG/6050220>

## 设计思路

### 一位全加法器

![pic.Adder1b](./img/2020-03-06-15-08-35.png)

```verilog
module Adder1b(
    input wire A, B, Ci,
    output wire S, Co
);
    wire gen, p_and_ci, prop;

    assign prop = A ^ B;
    assign S = prop ^ Ci;
    assign gen = A & B;
    assign p_and_ci = prop & Ci;
    assign Co = gen | p_and_ci;

endmodule
```

### 具有减法功能的一位全加器

![pic.AddSub1b](./img/2020-03-09-19-13-47.png)

```verilog
module AddSub1b(
    input wire A, B, Ctrl, Ci,
    output wire S, Co
);
    wire tmp;

    assign tmp = B ^ Ctrl;
    Adder1b add(.A(A), .B(tmp), .Ci(Ci), .S(S), .Co(Co));

endmodule
```

### 具有减法功能的四位全加器

![pic.AddSub4b](./img/2020-03-09-19-15-21.png)

```verilog
module AddSub4b(
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Ci,  // if subtraction, it is borrow
    input wire Ctrl,  // [mode] 0: addup; 1: subtraction
    output wire [3:0] S, 
    output wire Co
);
    wire c1, c2, c3;

    AddSub1b aS1(.A(A[0]), .B(B[0]), .Ci(Ctrl ^ Ci), .S(S[0]), .Co(c1), .Ctrl(Ctrl));
    AddSub1b aS2(.A(A[1]), .B(B[1]), .Ci(c1), .S(S[1]), .Co(c2), .Ctrl(Ctrl));
    AddSub1b aS3(.A(A[2]), .B(B[2]), .Ci(c2), .S(S[2]), .Co(c3), .Ctrl(Ctrl));
    AddSub1b aS4(.A(A[3]), .B(B[3]), .Ci(c3), .S(S[3]), .Co(Co), .Ctrl(Ctrl));

endmodule
```

### 具有 flags 状态输出的且具有减法功能的四位全加器

![pic.Adder4](./img/2020-03-09-19-31-53.png)

```verilog
module Adder4(
    input[3:0] A,
    input[3:0] B,
    input Ci,
    input Ctrl,
    output[3:0] out,
    output CF,OF,ZF,SF,PF  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
);

    wire add_cf, sub_cf, sub_sf, co;

    AddSub4b m1(.Ctrl(Ctrl), .Ci(Ci), .A(A), .B(B), .S(out), .Co(co));

    assign add_cf = ~Ctrl & co;
    assign sub_cf = Ctrl & ~co;
    assign sub_sf = Ctrl & sub_cf;

    assign CF = add_cf | sub_cf;
    assign SF = sub_sf;

    assign OF = add_cf;
    assign PF = ~out[0];
    assign ZF = ~|out;

endmodule
```

## 实验过程

1. 设计一位全加法器
1. 设计具有减法功能的一位全加器
1. 设计具有减法功能的四位全加器
1. 查阅各个 flag 所对应的意义
1. 设计具有 flags 状态输出的且具有减法功能的四位全加器
1. 增加用来验证 `Adder4` 的 Top 模块

## 运行截图

### 测试 Adder4

![pic.add_ZF_PF](./img/2020-03-09-19-31-53.png)

![pic.add_PF](./img/2020-03-09-19-33-42.png)

![pic.add_OF_CF](./img/2020-03-09-19-34-38.png)

![pic.sub](./img/2020-03-09-19-36-41.png)

![pic.sub_CF_SF](./img/2020-03-09-19-37-44.png)
