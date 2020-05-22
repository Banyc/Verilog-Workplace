`include "./hexDisplay/SEG_DRV.v"

module SEG_DRV_tb(
    
);

    reg clk;
    reg start;
    reg [7:0] en;
    reg [31:0] num;
    reg [7:0] point;
    wire finish;
    wire serial_clk;
    wire serial_seg;

    SEG_DRV UUT(
        clk,
        start,
        en,
        num,
        point,
        finish,
        serial_clk,
        serial_seg
    );

    initial begin
        $dumpfile("SEG_DRV_tb.vcd");
        $dumpvars(0, SEG_DRV_tb);

        start = 0;
        num = 32'h70106317;
        point = 8'b0;
        en = 8'b0;

        #10;
        start = 1;
        // #10;
        // start = 0;
    end

    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

endmodule // SEG_DRV_tb
