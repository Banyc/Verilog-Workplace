`include "./clock/clk_25mhz.v"

// `define porch_front_h 640
// `define sync_h_start (640 + 16)


// 640 * 480 @ 60 HZ
module VGA_640x480_60hz_DRV(
    clk_100mhz, rst, sync_h, sync_v, x_pos, y_pos, is_active_video
);
    input wire clk_100mhz;  // 100
    input wire rst;  // reset pointer to (0, 0)
    output reg sync_h;
    output reg sync_v;
    output reg [9:0] x_pos;
    output reg [8:0] y_pos;
    output reg is_active_video;

    // VGA timing for 640 * 480 @ 60 HZ
    // <http://martin.hinner.info/vga/timing.html>
    wire clk_25mhz;
    // integer porch_front_h = 640;  // start of horizntal front porch
	// integer sync_h_start = 640 + 16;  // start of horizontal sync  // + 16
	// integer porch_back_h = 640 + 16 + 96;  // start of horizontal back porch  // + 96
	// integer max_h = 640 + 16 + 96 + 48;  // total length of line.  // + 48
    integer porch_front_h = 640;  // start of horizntal front porch
	integer sync_h_start = 640 + 5;  // start of horizontal sync  // + 0
	integer porch_back_h = 640 + 0 + 96;  // start of horizontal back porch  // + 112
	integer max_h = 640 + 0 + 96 + 48 + 11;  // total length of line.  // + 48 + 16

	// integer porch_front_v = 480;  // start of vertical front porch 
	// integer sync_v_start = 480 + 11;  // start of vertical sync  // + 11
	// integer porch_back_v = 480 + 11 + 2;  // start of vertical back porch  // + 2
	// integer max_v = 480 + 11 + 2 + 31;  // total rows.  // + 31
	integer porch_front_v = 480;  // start of vertical front porch 
	integer sync_v_start = 480 + 11;  // start of vertical sync  // + 11
	integer porch_back_v = 480 + 11 + 2;  // start of vertical back porch  // + 2
	integer max_v = 480 + 11 + 2 + 31;  // total rows.  // + 31

    clk_25mhz c0 (clk_100mhz, clk_25mhz);

    initial begin
        x_pos = 0;
        y_pos = 0;
    end

    // x_pos
    always @(posedge clk_25mhz) begin
        if (x_pos == max_h - 1) begin
            x_pos <= 0;
        end else begin
            x_pos <= x_pos + 1;
        end
        if (rst == 1) begin
            x_pos <= 0;
        end
    end

    // y_pos
    always @(posedge clk_25mhz) begin
        if (x_pos == max_h - 1) begin
            if (y_pos == max_v - 1) begin
                y_pos <= 0;
            end else begin
                y_pos <= y_pos + 1;
            end
        end
        if (rst == 1) begin
            y_pos <= 0;
        end
    end

    // sync_h
    always @(posedge clk_25mhz) begin
        if (x_pos >= sync_h_start && x_pos < porch_back_h) begin
            sync_h <= 0;
        end else begin
            sync_h <= 1;
        end
    end

    // sync_h
    always @(posedge clk_25mhz) begin
        if (y_pos >= sync_v_start && y_pos < porch_back_v) begin
            sync_v <= 0;
        end else begin
            sync_v <= 1;
        end
    end

    // is_active_video
    always @(posedge clk_25mhz) begin
        if (x_pos < porch_front_h && y_pos < porch_front_v) begin
            is_active_video <= 1;
        end else begin
            is_active_video <= 0;
        end
    end

endmodule // VGA_640x480_Gen
