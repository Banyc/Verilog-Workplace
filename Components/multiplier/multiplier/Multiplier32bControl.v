`ifndef __Multiplier32bControl
`define __Multiplier32bControl

module Multiplier32bControl (
    clk,
    rst,
    productionRightmostBit,
    productionShiftRight,
    productionWrite,
    productionIsInitMux,
    multiplicandIsInitWrite,
    isHalt
);
    input wire clk;
    input wire rst;
    input wire productionRightmostBit;
    output reg productionShiftRight;
    output reg productionWrite;
    output reg productionIsInitMux;
    output reg multiplicandIsInitWrite;
    output reg isHalt;

    // states
    reg [3:0] state;
    reg [3:0] nextState;

    integer countDown;

    parameter RESET = 4'h0;
    parameter SAVE_SUM = 4'h1;
    parameter SHIFT_RIGHT = 4'h2;
    parameter HALT = 4'hF;
    // `define  0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= RESET;
        end else begin
            state <= nextState;
        end
    end

    always @(state) begin
        productionShiftRight = 0;
        productionWrite = 0;
        productionIsInitMux = 0;
        multiplicandIsInitWrite = 0;
        isHalt = 0;

        case (state)
            RESET: begin
                productionWrite = 1;
                productionIsInitMux = 1;
                multiplicandIsInitWrite = 1;
                countDown = 31;
                nextState = SAVE_SUM;
            end
            SAVE_SUM: begin
                if (productionRightmostBit == 1) begin
                    productionWrite = 1;
                end else begin
                    
                end
                nextState = SHIFT_RIGHT;
            end
            SHIFT_RIGHT: begin
                productionShiftRight = 1;

                countDown = countDown - 1;

                if (countDown >= 0) begin
                    nextState = SAVE_SUM;
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
