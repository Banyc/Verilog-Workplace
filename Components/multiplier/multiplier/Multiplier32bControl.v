`ifndef __Multiplier32bControl
`define __Multiplier32bControl

`include "./Components/register/Register32b.v"

module Multiplier32bControl (
    clk,
    rst,
    productionRightmostBit,
    productionShiftRight,
    productionWrite,
    muxIsInitProduction,
    multiplicandIsInitWrite,
    isHalt
);
    input wire clk;
    input wire rst;
    input wire productionRightmostBit;
    output reg productionShiftRight;
    output reg productionWrite;
    output reg muxIsInitProduction;
    output reg multiplicandIsInitWrite;
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
    parameter TO_SAVE_SUM_OR_SHIFT_RIGHT = 4'h1;
    parameter TO_SAVE_SUM_OR_SHIFT_RIGHT_2 = 4'h2;
    parameter TO_SHIFT_RIGHT = 4'h3;
    parameter TO_SHIFT_RIGHT_2 = 4'h4;
    parameter HALT = 4'hF;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= RESET;
        end else begin
            state <= nextState;
        end
    end

    always @(*) begin
        productionShiftRight = 0;
        productionWrite = 0;
        muxIsInitProduction = 0;
        multiplicandIsInitWrite = 0;
        isHalt = 0;
        nextCountDown = countDown;

        case (state)
            TO_SHIFT_RIGHT_2: begin
                realState = TO_SHIFT_RIGHT;
            end
            TO_SAVE_SUM_OR_SHIFT_RIGHT_2: begin
                realState = TO_SAVE_SUM_OR_SHIFT_RIGHT;
            end
            default: begin
                realState = state;
            end
        endcase

        case (realState)
            RESET: begin
                productionWrite = 1;
                muxIsInitProduction = 1;
                multiplicandIsInitWrite = 1;
                nextCountDown = 31;
                // countDown = 32;
                
                nextState = TO_SAVE_SUM_OR_SHIFT_RIGHT_2;
            end

            TO_SAVE_SUM_OR_SHIFT_RIGHT: begin
                if (productionRightmostBit == 1) begin
                    // save sum
                    productionWrite = 1;

                    nextState = TO_SHIFT_RIGHT_2;
                end else begin
                    // shift right
                    productionShiftRight = 1;

                    nextCountDown = countDown - 1;
                    // this won't act!
                    // countDown = countDown - 1;

                    if (countDown >= 1) begin
                        nextState = TO_SAVE_SUM_OR_SHIFT_RIGHT_2;
                    end else begin
                        nextState = HALT;
                    end
                end
            end
            
            TO_SHIFT_RIGHT: begin
                // the production has NOT shifted YET
                // the next state could only read the not-yet-changed production
                productionShiftRight = 1;

                nextCountDown = countDown - 1;
                // countDown = countDown - 1;

                if (countDown >= 1) begin
                    // the production has NOT shifted YET
                    if (productionRightmostBit == 1) begin
                        nextState = TO_SAVE_SUM_OR_SHIFT_RIGHT_2;
                    end else begin
                        nextState = TO_SHIFT_RIGHT_2;
                    end
                end else begin
                    nextState = HALT;
                end
            end

            HALT: begin
                isHalt = 1;
                nextState = HALT;
            end

            // default: begin
            //     nextState = `RESET;
            // end 
        endcase
    end
    
endmodule

`endif
