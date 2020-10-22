
`include "./Components/clock/clk_100ms.v"
`include "./Components/counter/M_74LS161.v"
`include "./Components/io/hexDisplay/Disp8Num.v"

module Top(
    clk, SW, SEG_CLK, SEG_CLR, SEG_DT, SEG_EN
);
    input clk;
    input [15:0] SW;

    output wire SEG_CLK;
    output reg SEG_CLR = 1'b1;
    output wire SEG_DT;
    output reg SEG_EN = 1'b1;

    wire clk_100ms;
    reg [31:0] num;

    wire [7:0] hour;
    wire [7:0] minute;
    wire [7:0] second;

    wire [5:0] dummy;

    reg [5:0] reset = 0;

    reg [7:0] hour_init = 8'h00;
    reg [7:0] minute_init = 8'h00;
    reg [7:0] second_init = 8'h00;

    clk_100ms c0(clk, clk_100ms);
    Disp8Num d1(clk, 1'b0, {8'b0, hour, minute, second}, 8'b00010101, 8'b0, SEG_CLK, SEG_DT);

    M_74LS161   hour_1(SW[0], ~reset[5], 1'b1, 1'b1, ~reset[4], hour_init[7:4], hour[7:4], dummy[5]);
    M_74LS161   hour_0(SW[0], ~reset[4], 1'b1, 1'b1, ~reset[3], hour_init[3:0], hour[3:0], dummy[4]);

    M_74LS161 minute_1(SW[0], ~reset[3], 1'b1, 1'b1, ~reset[2], minute_init[7:4], minute[7:4], dummy[3]);
    M_74LS161 minute_0(SW[0], ~reset[2], 1'b1, 1'b1, ~reset[1], minute_init[3:0], minute[3:0], dummy[2]);

    M_74LS161 second_1(SW[0], ~reset[1], 1'b1, 1'b1, ~reset[0], second_init[7:4], second[7:4], dummy[1]);
    M_74LS161 second_0(SW[0], ~reset[0], 1'b1, 1'b1, clk_100ms, second_init[3:0], second[3:0], dummy[0]);

    // always @(posedge clk) begin
    //     if (SW[15] == 0) begin
    //         hour_init <= 8'h00;
    //         minute_init <= 8'h00;
    //         second_init <= 8'h00;
    //     end
    //     else begin
    //         hour_init <= 8'h23;
    //         minute_init <= 8'h58;
    //         second_init <= 8'h00;
    //     end
    // end

    always @(posedge clk) begin
        // low
        if (second[3:0] == 9) begin
            reset[0] <= 1;
        end
        else begin
            reset[0] <= 0;
        end
        if (second[7:0] == 8'h59) begin
            reset[1] <= 1;
        end
        else begin
            reset[1] <= 0;
        end

        if (minute[3:0] == 9) begin
            reset[2] <= 1;
        end
        else begin
            reset[2] <= 0;
        end
        if (minute[7:0] == 8'h59 && reset[1] == 1) begin
            reset[3] <= 1;
        end
        else begin
            reset[3] <= 0;
        end

        if (hour[3:0] == 9) begin
            reset[4] <= 1;
        end
        else begin
            reset[4] <= 0;
        end
        if (hour[7:0] == 8'h23 && reset[3] == 1) begin
            reset[5] <= 1;
        end
        else begin
            reset[5] <= 0;
        end
        // high
    end

endmodule // Top
