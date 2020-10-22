`include "./Components/io/LED/LED_DRV.v"

module LED_DRV_tb(
    
);

    reg clk;
    reg load;
    reg [15:0] led_to_show;
    wire finish;
    wire serial_clk;
    wire serial_led;

    LED_DRV UUT(
        clk,
        load,
        led_to_show,
        finish,
        serial_clk,
        serial_led
    );

    initial begin
        $dumpfile("LED_DRV_tb.vcd");
        $dumpvars(0, LED_DRV_tb);

        load = 0;
        led_to_show = 16'b1011_0111_0111_1011;

        #10;
        load = 1;
        // #10;
        // load = 0;
    end

    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

endmodule // LED_DRV_tb
