`ifndef __Divider32bControl
`define __Divider32bControl

`include "./Components/register/Register32b.v"

`define Divider32bControl_RemainderSourceMux_InitialDividend 2'h0
`define Divider32bControl_RemainderSourceMux_Alu 2'h1

module Divider32bControl (
    clk,
    rst,
    remainderLeftmostBit,
    aluIsSubtract,
    remainderShiftLeft,
    remainderAppendBit,
    remainderWrite,
    quotientRightmostBit,
    muxRemainderSourceSelector,
    divisorIsInitWrite,
    isHalt
);
    input wire clk;
    input wire rst;
    input wire remainderLeftmostBit;
    output reg aluIsSubtract;
    output reg remainderShiftLeft;
    output reg remainderAppendBit;
    output reg remainderWrite;
    output reg quotientRightmostBit;
    output reg [1:0] muxRemainderSourceSelector;
    output reg divisorIsInitWrite;
    output reg isHalt;

    // states
    reg [3:0] realState;
    reg [3:0] state;
    reg [3:0] nextState;

    // integer countDown;
    wire [31:0] countDown;
    reg [31:0] nextCountDown;

    Register32b counter(
        .clk(clk),
        .enableWrite(1'b1),
        .d(nextCountDown),
        .q(countDown)
    );

    parameter RESET = 4'h0;
    parameter SUBTRACT = 4'h1;
    parameter AFTER_SUBTRACT = 4'h2;
    // parameter SHIFT_LEFT_1 = 4'h3;
    parameter APPEND_ONE = 4'h4;
    // parameter ADD = 4'h5;
    parameter SHIFT_LEFT_APPEND_ZERO = 4'h6;
    // parameter APPEND_ZERO = 4'h7;
    parameter HALT = 4'hF;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= RESET;
        end else begin
            state <= nextState;
        end
    end

    always @(*) begin
        aluIsSubtract = 0;
        remainderShiftLeft = 0;
        remainderAppendBit = 0;
        remainderWrite = 0;
        quotientRightmostBit = 0;
        muxRemainderSourceSelector = 0;
        divisorIsInitWrite = 0;
        isHalt = 0;
        nextCountDown = countDown;

        case (state)
            default: begin
                realState = state;
            end
        endcase

        case (realState)
            RESET: begin
                remainderWrite = 1;
                muxRemainderSourceSelector = `Divider32bControl_RemainderSourceMux_InitialDividend;
                divisorIsInitWrite = 1;
                nextCountDown = 33;
                
                nextState = SUBTRACT;
            end

            SUBTRACT: begin
                nextCountDown = countDown - 1;
                if (countDown <= 0) begin
                    nextState = HALT;
                end else begin
                    // subtract dividend
                    aluIsSubtract = 1;
                    remainderWrite = 1;
                    muxRemainderSourceSelector = `Divider32bControl_RemainderSourceMux_Alu;

                    nextState = AFTER_SUBTRACT;
                end
            end
            AFTER_SUBTRACT: begin
                if (remainderLeftmostBit == 1) begin
                    // succeeded
                    // shift left + append 1
                    remainderShiftLeft = 1;
                    remainderAppendBit = 1;

                    nextState = SUBTRACT;
                end else begin
                    // failed
                    // add
                    aluIsSubtract = 0;
                    remainderWrite = 1;
                    muxRemainderSourceSelector = `Divider32bControl_RemainderSourceMux_Alu;

                    nextState = SHIFT_LEFT_APPEND_ZERO;
                end
            end
            SHIFT_LEFT_APPEND_ZERO: begin
                remainderShiftLeft = 1;
                remainderAppendBit = 0;
                
                nextState = SUBTRACT;
            end

            HALT: begin
                isHalt = 1;
                nextState = HALT;
            end

            default: begin
                nextState = RESET;
            end 
        endcase
    end
    
endmodule

`endif
