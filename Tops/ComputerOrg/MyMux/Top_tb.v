`include "./Top.v"

module Top_tb(
    
);

    reg clk;
    reg [3:0] BTN;
    reg [15:0] SW;
    wire BTNX4;
    wire [7:0] SEGMENT;
    wire [3:0] AN;
    wire LED_CLK;
    wire LED_CLR;
    wire LED_DO;
    wire LED_EN;

    Top UUT(
        clk,
        BTN,
        BTNX4,
        SEGMENT,
        AN,
        SW,
        LED_CLK,
        LED_CLR,
        LED_DO,
        LED_EN
    );

    initial begin
        $dumpfile("Top_tb.vcd"); $dumpvars(0, Top_tb);
        BTN = 0;
        SW = 16'h12;
        // SW = 0;

        #20;
        BTN = 1;
        #20;
        BTN = 2;
        #20;
        BTN = 4;
        #20;
        BTN = 8;
        #20;
        BTN = 0;

    end

    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

endmodule // Top_tb
