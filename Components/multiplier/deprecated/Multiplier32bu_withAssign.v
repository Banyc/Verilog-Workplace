`ifndef __Multiplier32bu
`define __Multiplier32bu

// unsigned

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/register/ShiftReg32b.v"

module Multiplier32bu(
    clk,
    a,
    b,
    p,
    rst,  // positive to start
    finish
);
    input wire clk;
    input wire [31:0] a;
    input wire [31:0] b;
    input wire rst;
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
    reg [5:0] repeat_count;
    reg [2:0] state;
    reg [2:0] next_state;
    reg aSLoad;

    localparam RESET = 0;  // init aS
    localparam ADD = 1;
    localparam SHIFT = 2;
    localparam DONE = 3;

    ShiftReg32b aS(.clk(clk), .load(aSLoad), .S_L(1'b1), .s_in(1'b0), .p_in(a), .Q(multiplicand));

    ShiftReg32b product1(.clk(clk), .load(prod1load), .S_L(prod1sl), .s_in(carry), .p_in(paraInProd1), .Q(p[63:32]));
    ShiftReg32b product0(.clk(clk), .load(prod0load), .S_L(prod0sl), .s_in(p[32]), .p_in(b),           .Q(p[31:0]));

    AddSub32bFlag alu32b(
        .A(p[63:32]),
        .B(multiplicand),
        .Ci(1'b0),
        .Ctrl(1'b0),
        .S(sum),
        .CF(carry), .OF(), .ZF(), .SF(), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );

    // control unit for unsigned integer is below

    // main state controller
    always @(negedge clk)
    begin
        if (rst)
            state <= RESET;
        else
            state <= next_state;
    end

    always @(state)
    begin
        case (state)
            RESET: begin
                assign aSLoad = 1;
                assign prod1sl = 1;
                assign prod0sl = 1;
                assign repeat_count = 32;
                assign prod0load = 1;
                assign prod1load = 1;
                assign paraInProd1 = 0;
                assign finish = 0;
                assign next_state = ADD;
            end
            ADD: begin
                assign aSLoad = 0;
                assign prod0sl = 0;
                assign prod1sl = 1;

                assign prod0load = 0;
                if (p[0])
                begin
                    assign prod1load = 1;
                end else begin
                    assign prod1load = 0;
                end
                assign paraInProd1 = sum;

                assign next_state = SHIFT;
            end
            SHIFT: begin

                assign prod0sl = 0;
                assign prod1sl = 0;
                assign repeat_count = repeat_count - 1;
                assign prod0load = 1;
                assign prod1load = 1;


                if (repeat_count == 0) begin
                    assign next_state = DONE;
                end else begin
                    assign next_state = ADD;
                end
            end
            DONE: begin
                assign prod0load = 0;
                assign prod1load = 0;
                assign finish = 1;
                assign next_state = DONE;
            end
        endcase
    end

endmodule // Multiplier32bu

`endif
