`ifndef __Divider32b
`define __Divider32b

// signed

`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/multiplier/deprecated/Divider32bu.v"

module Divider32b(
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
    output reg [31:0] q;
    output reg [31:0] r;

    wire finish_unsigned;
    wire [31:0] q_unsigned;
    wire [31:0] r_unsigned;
    wire carry;
    wire [31:0] sum;

    reg rst_unsigned;
    reg q_sign;
    reg r_sign;
    reg [31:0] a_unsigned;
    reg [31:0] b_unsigned;
    reg [31:0] negative;

    reg [3:0] state;
    reg [3:0] next_state;

    // test
    reg goto_test;

    localparam RESET = 0;  // init extract sign, send a to alu
    localparam INIT_A = 1;  // signed a -> unsigned a, send b to alu
    localparam INIT_B = 2;  // signed b -> unsigned b, start divider
    localparam WAIT_UNFINISH = 3;  // wait the unsigned divider to be set unfinished
    localparam WAIT = 4;
    localparam WAIT_2 = 5;  // same as WAIT to keep `always @(state)` active
    localparam SIGN_Q = 6;
    localparam SIGN_R = 7;
    localparam DONE = 8;

    AddSub32bFlag alu32b(
        .A(32'b0),
        .B(negative),
        .Ci(1'b0),
        .Ctrl(1'b1),
        .S(sum),
        .CF(carry), .OF(), .ZF(), .SF(), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );

    Divider32bu divider(
        .clk(clk),
        .a(a_unsigned),
        .b(b_unsigned),
        .q(q_unsigned),
        .r(r_unsigned),
        .rst(rst_unsigned),  // set positive to start
        .finish(finish_unsigned)
    );

    // control unit for unsigned integer is below

    // main state controller
    reg trigger;
    always @(negedge clk)
    begin
        if (rst)
            state = RESET;
        else
            state = next_state;
    end

    always @(state)
    begin
        case (state)
            RESET: begin
                rst_unsigned = 0;
                if (a[31] != b[31])
                    q_sign = 1;
                else
                    q_sign = 0;
                if (a[31])
                    r_sign = 1;
                else
                    r_sign = 0;
                negative = a;
                // a_unsigned = sum;
                // b_unsigned;
                next_state = INIT_A;
                finish = 0;
            end
            INIT_A: begin
                rst_unsigned = 0;
                // q_sign = 1;
                // r_sign = 1;
                if (a[31]) begin
                    a_unsigned = sum;
                end else begin
                    a_unsigned = a;
                end
                negative = b;
                // b_unsigned;
                next_state = INIT_B;
                // finish = 0;
            end
            INIT_B: begin
                rst_unsigned = 1;
                // q_sign = 0;
                // r_sign = 0;
                // a_unsigned = sum;
                if (b[31]) begin
                    b_unsigned = sum;
                end else begin
                    b_unsigned = b;
                end
                next_state = WAIT_UNFINISH;
                // finish = 0;
            end
            WAIT_UNFINISH: begin
                rst_unsigned = 0;
                next_state = WAIT;
            end
            WAIT: begin
                // rst_unsigned = 0;
                // q_sign = 0;
                // r_sign = 0;
                negative = q_unsigned;  // prepare for state SIGN_Q in advance
                // a_unsigned = sum;
                // b_unsigned;
                if (finish_unsigned) begin
                    next_state = SIGN_Q;
                end else begin
                    next_state = WAIT_2;
                end
                // finish = 0;
            end
            WAIT_2: begin
                // negative = q_unsigned;  // prepare for state SIGN_Q in advance
                if (finish_unsigned) begin
                    next_state = SIGN_Q;
                end else begin
                    next_state = WAIT;
                end
            end
            SIGN_Q: begin
                // rst_unsigned = 0;
                if (q_sign) begin
                    q = sum;
                end else begin
                    q = q_unsigned;
                end
                negative = r_unsigned;  // prepare for state SIGN_R in advance
                // r_sign = 0;
                // a_unsigned = sum;
                // b_unsigned;
                next_state = SIGN_R;
                // finish = 0;
            end
            SIGN_R: begin
                // rst_unsigned = 0;
                // q_sign = 0;
                if (r_sign)
                    r = sum;
                else
                    r = r_unsigned;
                // a_unsigned = sum;
                // b_unsigned;
                next_state = DONE;
                // finish = 0;
            end
            DONE: begin
                // rst_unsigned = 0;
                // q_sign = 1;
                // r_sign = 0;
                // negative = a;
                // a_unsigned = sum;
                // b_unsigned;
                next_state = DONE;
                finish = 1;
            end
        endcase
    end

endmodule // Divider32b

`endif
