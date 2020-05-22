`include "./register/ShiftReg8b.v"

// WARNING
// clk should be initial to 0

// for LED on motherboard
module LED_DRV(
    clk,
    start,
    led_to_show,
    finish,
    serial_clk,
    serial_led
);
    input wire clk;
    input wire start;  // start to load full LED to serial form;  positive edge
    input wire [15:0] led_to_show;
    output wire finish;
    output wire serial_clk;
    output wire serial_led;

    wire [15:0] shiftReg;
    reg old_start;
    reg [4:0] ttl;  // time to live
    reg should_shift;

    initial begin
        old_start = 1'b0;
        ttl = 0;
        should_shift = 1'b0;
    end

    assign finish = ~should_shift;
    assign serial_clk = ~clk & should_shift;  // NOTICE: to update the latest state boosted by clk, there must be an inversion on top of clk

    // shift data to serial output
    ShiftReg8b s1(clk, ~should_shift, shiftReg[0], 
        {
            led_to_show[0],
            led_to_show[1],
            led_to_show[2],
            led_to_show[3],
            led_to_show[4],
            led_to_show[5],
            led_to_show[6],
            led_to_show[7]
        }, shiftReg[15:8]);  // high part
    ShiftReg8b s2(clk, ~should_shift, shiftReg[8], 
        {
            led_to_show[8],
            led_to_show[9],
            led_to_show[10],
            led_to_show[11],
            led_to_show[12],
            led_to_show[13],
            led_to_show[14],
            led_to_show[15]
        }, shiftReg[7:0]);  // low part

    assign serial_led = ~shiftReg[0];  // 0: activated

    // second round
    always @(posedge clk) begin
        old_start <= start;  // record positive edge of start
    end

    always @(posedge clk) begin
        // first round
        // IF positive edge of start AND no shifting is running (i.e. finished)
        if ((old_start == 1'b0) && (start == 1'b1) && (ttl == 0)) begin
            ttl <= 16;
        end
        // second round
        if (ttl > 0) begin
            should_shift <= 1'b1;
            ttl <= ttl - 1;
        end else begin
            should_shift <= 1'b0;
        end
    end
endmodule // LED_DRV
