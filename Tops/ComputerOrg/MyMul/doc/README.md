# 第04周实验：4位乘法器

## 实验目的

目标：按理论课所讲的乘法器原理，设计4位整数乘法器。

输入：

　开　关：左右4位分别代表4位二进制被乘数与乘数。

　按　钮：最左：正常/按下分别对应：无符号乘法/补码乘法。

输出：

　发光管：如果用到加法器，发光管自左至右显示：SF、CF、OF、ZF、PF。否则自定

　数码管：数码管自左至右分别以十六进制显示：被乘数、乘数、积高4位、积低4位。

考虑1：可考虑阵列乘法器。

## 实验原理

本次实验使用阵列乘法器，也就是非时序电路。电路结构如下图所示

![Multiplier4b 电路图](img/2020-03-23-01-02-58.png)

由于需要同时对补码进行乘法算法的支持，因此修改电路如下

![Multiplier4b2u 电路图](img/2020-03-23-11-19-49.png)

代码如下

```verilog
module Multiplier4b2u(
    input wire c,  // 1: 2'compliment; 0: magnitude
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] p
);
    wire [3:0] adder0_a;
    wire [3:0] adder1_a;
    wire [3:0] adder2_a;

    wire [3:0] adder0_b;
    wire [3:0] adder1_b;
    wire [3:0] adder2_b;

    wire [3:0] adder0_s;
    wire [3:0] adder1_s;
    wire [3:0] adder2_s;
    wire ha_s;

    wire adder0_co;
    wire adder1_co;
    wire adder2_co;
    wire ha_co;

    assign adder0_a[0] = a[0] & b[1];
    assign adder0_a[1] = a[1] & b[1];
    assign adder0_a[2] = a[2] & b[1];
    assign adder0_a[3] = c ^ (a[3] & b[1]);

    assign adder1_a[0] = a[0] & b[2];
    assign adder1_a[1] = a[1] & b[2];
    assign adder1_a[2] = a[2] & b[2];
    assign adder1_a[3] = c ^ (a[3] & b[2]);

    assign adder2_a[0] = c ^ (a[0] & b[3]);
    assign adder2_a[1] = c ^ (a[1] & b[3]);
    assign adder2_a[2] = c ^ (a[2] & b[3]);
    assign adder2_a[3] = a[3] & b[3];

    assign adder0_b[0] = a[1] & b[0];
    assign adder0_b[1] = a[2] & b[0];
    assign adder0_b[2] = c ^ (a[3] & b[0]);
    assign adder0_b[3] = c;

    assign adder1_b[0] = adder0_s[1];
    assign adder1_b[1] = adder0_s[2];
    assign adder1_b[2] = adder0_s[3];
    assign adder1_b[3] = adder0_co;

    assign adder2_b[0] = adder1_s[1];
    assign adder2_b[1] = adder1_s[2];
    assign adder2_b[2] = adder1_s[3];
    assign adder2_b[3] = adder1_co;

    Adder4b adder0(
        .A(adder0_a),
        .B(adder0_b),
        .Ci(1'b0),
        .S(adder0_s), 
        .Co(adder0_co));
    Adder4b adder1(
        .A(adder1_a),
        .B(adder1_b),
        .Ci(1'b0),
        .S(adder1_s), 
        .Co(adder1_co));
    Adder4b adder2(
        .A(adder2_a),
        .B(adder2_b),
        .Ci(1'b0),
        .S(adder2_s), 
        .Co(adder2_co));

    Adder1b ha(
        .A(adder2_co), .B(c), .Ci(1'b0),
        .S(ha_s), .Co()
    );

    assign p[0] = a[0] & b[0];
    assign p[1] = adder0_s[0];
    assign p[2] = adder1_s[0];
    assign p[3] = adder2_s[0];
    assign p[4] = adder2_s[1];
    assign p[5] = adder2_s[2];
    assign p[6] = adder2_s[3];
    assign p[7] = ha_s;
endmodule
```

在这个实验中并没有使用带有减法功能的加法器，当然也就没有使用到具有 flags 输出的 4位加法器。相反，此处使用的是下图所示的加法器

![Adder4b 电路图](img/2020-03-23-01-08-17.png)

每个加法器的作用都不一样，因此无法统一出一个份具体的 flags。如果为每个加法器配一份 flags 也没有太大的意义，因为某个一加法器的 ZF 不能够代表乘法的积，并且因为输出积的位数有8位，明显不会出现溢出或者是进位的情况，因此没有必要在该乘法器内部去做 flags 的输出实现。

## 实验截图

![项目编译结果](img/2020-03-23-11-34-21.png)

![Multiplier4b 波形图](img/2020-03-23-01-00-17.png)

![Multiplier4b2u 波形图](img/2020-03-23-11-17-47.png)
