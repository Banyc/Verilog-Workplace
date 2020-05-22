Top里需要的增加的是：
reg [3:0] PS2_ret;

PS2_Transfer ps2transfer (.clk(clk), .rst(), .PS2_clk(PS2_clk), .PS2_data(PS2_data), .PS2_ret(PS2_ret)); //这里面的clk是100mhz