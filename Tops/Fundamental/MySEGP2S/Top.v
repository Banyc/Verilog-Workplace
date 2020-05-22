`include "./Components/register/ShiftReg8b.v"
`include "./Components/hexDisplay/SEG_DRV.v"

module Top(
    clk,
    SW,
    SEG_CLK,
    SEG_CLR,
    SEG_DT,
    SEG_EN
);

    input wire clk;
    input wire [15:0] SW;
    output wire SEG_CLK;
    output reg SEG_CLR;
    output wire SEG_DT;
    output reg SEG_EN;

    reg [31:0] num;
    wire finish;
    wire serial_SEG;

    initial begin
        SEG_CLR = 1'b1;
        SEG_EN = 1'b1;
        num = 32'h70106317;
    end

    // 
    SEG_DRV drv(clk, SW[15], 8'b0, num, 8'b0, finish, SEG_CLK, SEG_DT);

endmodule // Top
