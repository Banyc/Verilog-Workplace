`ifndef __Divider32bu
`define __Divider32bu

// unsigned
// Non-Restoring Division For Unsigned Integer
// algorithm - <https://www.geeksforgeeks.org/non-restoring-division-unsigned-integer/?ref=rp>

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/register/ShiftReg32b.v"
`include "./Components/register/ShiftReg32bL.v"


module Divider32bu(
    clk,
    a,
    b,
    q,
    r,
    rst,  // set positive to start
    finish
);
    input wire clk;
    input wire [31:0] a;  // Divisor; 被除数
    input wire [31:0] b;  // Dividend
    input wire rst;
    output reg finish;
    output wire [31:0] q;
    output wire [31:0] r;

    wire [31:0] d;  // Divisor
    wire carry;
    wire [31:0] sum;

    reg divisor_load;
    reg remainder_load;  // 1: load
    reg remainder_sl;  // 0: shift
    reg [31:0] paraIn_remainder;
    reg quotient_load;  // 1: load
    reg quotient_sl;  // 0: shift
    reg [31:0] paraIn_quotient;
    reg sub_signal;  // 1: subtract
    reg [5:0] repeat_count;
    reg [2:0] state;
    reg [2:0] next_state;

    localparam RESET = 0;  // init divisor, remainder, quotient
    localparam SHIFT = 1;
    localparam SET_REM_QUO = 2;
    localparam DONE = 3;

    ShiftReg32b divisor(.clk(clk), .load(divisor_load), .S_L(1'b1), .s_in(1'b0), .p_in(b), .Q(d));

    ShiftReg32bL remainder(.clk(clk), .load(remainder_load), .S_L(remainder_sl), .s_in(q[31]), .p_in(paraIn_remainder), .Q(r[31:0]));
    ShiftReg32bL  quotient(.clk(clk), .load(quotient_load),  .S_L(quotient_sl),  .s_in(1'b0),  .p_in(paraIn_quotient),  .Q(q[31:0]));

    AddSub32bFlag alu32b(
        .A(r),
        .B(d),
        .Ci(1'b0),
        .Ctrl(sub_signal),
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
                divisor_load = 1;
                remainder_load = 1;  // 1: load
                remainder_sl = 1;  // 0: shift
                paraIn_remainder = 0;
                quotient_load = 1;  // 1: load
                quotient_sl = 1;  // 0: shift
                paraIn_quotient = a;  // load devident into quotient register
                sub_signal = 0;  // 1: subtract
                repeat_count = 32 - 1;
                next_state = SHIFT;
                finish = 0;
            end
            SHIFT: begin
                divisor_load = 0;
                remainder_load = 1;  // 1: load
                remainder_sl = 0;  // 0: shift
                // paraIn_remainder = 0;
                quotient_load = 1;  // 1: load
                quotient_sl = 0;  // 0: shift
                // paraIn_quotient = b;
                sub_signal = 1;  // 1: subtract  // the next state can then get the difference
                // repeat_count = 32;
                next_state = SET_REM_QUO;
                // finish = 0;
            end
            SET_REM_QUO: begin
                divisor_load = 0;
                if (sum[31] == 0) begin
                    remainder_load = 1;  // 1: load
                    remainder_sl = 1;  // 0: shift
                    paraIn_remainder = sum;
                end else begin
                    remainder_load = 0;  // 1: load
                    // remainder_sl = 1;  // 0: shift
                    // paraIn_remainder = sum;
                end
                quotient_load = 1;  // 1: load
                quotient_sl = 1;  // 0: shift
                if (sum[31] == 0) begin
                    paraIn_quotient = {q[31:1], 1'b1};
                end else begin
                    paraIn_quotient = {q[31:1], 1'b0};
                end
                // sub_signal = 1;  // 1: subtract
                if (repeat_count == 0)
                    // repeat_count = repeat_count - 1;
                    next_state = DONE;
                else begin
                    repeat_count = repeat_count - 1;
                    next_state = SHIFT;
                end
                // finish = 0;
            end
            DONE: begin
                divisor_load = 0;
                remainder_load = 0;  // 1: load
                // remainder_sl = 1;  // 0: shift
                // paraIn_remainder = 0;
                quotient_load = 0;  // 1: load
                // quotient_sl = 1;  // 0: shift
                // paraIn_quotient = b;
                // sub_signal = 0;  // 1: subtract
                // repeat_count = 32;
                next_state = DONE;
                if (~finish)
                    finish = 1;
            end
        endcase
    end

endmodule // Divider32bu

`endif
