`ifndef __Multiplier32bu
`define __Multiplier32bu

// unsign
// malfunctioned

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/register/ShiftReg32b.v"

module Multiplier32bu(
    clk,
    a,
    b,
    p,
    start,
    finish
);
    input wire clk;
    input wire [31:0] a;
    input wire [31:0] b;
    input wire start;
    output reg finish;
    output wire [63:0] p;

    wire [31:0] multiplicand;
    wire carry;
    wire [31:0] sum;
    reg [31:0] paraInProd1;
    reg prod0sl;  // 0: shift
    reg prod1sl;  // 0: shift
    reg prod0load;  // 1: load
    reg prod1load;  // 1: load
    // reg subSignal;  // 1: subtract
    reg isAdd;  // 1: add; 0: don't add
    reg stage;  // 0: add; 1: shift
    reg [5:0] count;

    ShiftReg32b aS(.clk(clk), .load(start), .S_L(1'b1), .s_in(1'b0), .p_in(a), .Q(multiplicand));

    ShiftReg32b product1(.clk(clk), .load(prod1load), .S_L(prod1sl), .s_in(carry), .p_in(paraInProd1), .Q(p[63:32]));
    ShiftReg32b product0(.clk(clk), .load(prod0load), .S_L(prod0sl), .s_in(p[32]), .p_in(b),           .Q(p[31:0]));

    AddSub32bFlag alu32b(
        .A(multiplicand),
        .B(p[63:32]),
        .Ci(1'b0),
        .Ctrl(1'b0),
        .S(sum),
        .CF(carry), .OF(), .ZF(), .SF(), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );

    // control unit for unsigned integer is below

    // init
    initial begin
        finish = 1;
        prod0load = 0;
        prod1load = 0;
        count = 0;
        paraInProd1 = 0;
        stage = 0;
    end

    // parallel input of prod1
    always @(isAdd, sum, count) begin
        if (count == 1) begin
            paraInProd1 <= 0;
        end else if (isAdd) begin
            paraInProd1 <= sum;
        end else begin
            paraInProd1 <= paraInProd1;
        end
    end
    // load signal for product 0
    always @(stage) begin
        if (~finish & stage == 1) begin  // delete finish?
            prod0load <= 1;
        end else begin
            prod0load <= 0;
        end
    end
    // load signal for product 1
    always @(isAdd, stage, finish) begin
        if (~finish & ((isAdd & stage == 0) | stage == 1)) begin  // delete finish?
            prod1load <= 1;
        end else begin
            prod1load <= 0;
        end
    end
    // shift or parallel?
    always @(stage) begin
        if (count == 1) begin
            prod0sl <= 1;
        end else begin
            prod0sl <= 0;  // shift
        end
    end
    always @(count, stage) begin
        if (count == 1) begin
            prod1sl <= 1;
        end else if (stage == 0) begin
            prod1sl <= 1;
        end else begin
            prod1sl <= 0;  // shift
        end
    end
    // is add?
    always @(p[0]) begin
        if (p[0]) begin
            isAdd <= 1;
        end else begin
            isAdd <= 0;
        end
    end
    // stage
    always @(negedge clk) begin
        if (~finish) begin
            stage <= ~stage;
        end else begin
            stage <= 0;
        end
    end
    // finish?
    // always @(start, count) begin  // TODO: make start a posedge
    //     if (~start & (count == 32 + 1 + 1 | finish)) begin
    always @(posedge start, count) begin  // TODO: make start a posedge
        if (count == 32 + 1 + 1) begin
            finish <= 1;
        end else if (start) begin
            finish <= 0;
        end else begin
            finish <= finish;
        end
    end
    // count
    always @(stage, finish) begin
        if (finish) begin
            count <= 0;
        end else if (stage == 0) begin
            count <= count + 1;
        end else begin
            count <= count;
        end
    end

endmodule // Multiplier32bu

`endif
