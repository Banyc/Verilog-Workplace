// Snake game
`include "./Components/clock/clk_1s.v"
`include "./Components/clock/clk_500ms.v"
`include "./Components/clock/clk_250ms.v"
`include "./Components/clock/clk_100ms.v"
// `include "./Components/clock/clk_50mhz.v"
`include "./Components/VGA/VGA_640x480_60hz_DRV.v"
`include "./Components/hexDisplay/DispNum.v"
`include "./Components/hexDisplay/SEG_DRV.v"
`include "./Components/random/Random_generator.v"
`include "./Components/keyboard/PS2_Transfer.v"
`include "./Components/BCD/Hex2BCD16b.v"
`include "./Components/LED/LED_DRV.v"

`define OFFSET 50

module Top(
    clk, SW, BTN, BTNX4, VGA_r, VGA_g, VGA_b, VGA_hs, VGA_vs, SEGMENT, AN, SEG_CLK, SEG_CLR, SEG_DT, SEG_EN, PS2_CLK, PS2_DATA, PS2_RST, LED_CLK, LED_CLR, LED_DO, LED_EN
);
    input wire clk;
    input wire [15:0] SW;
    input wire [3:0] BTN;
    output reg BTNX4 = 1'b0;
    // VGA
    output wire [3:0] VGA_r;
    output wire [3:0] VGA_g;
    output wire [3:0] VGA_b;
    output wire VGA_hs;
    output wire VGA_vs;
    // 4x4-bit hex
    output wire [7:0] SEGMENT;
    output wire [3:0] AN;
    // 4x8-bit hex
    output wire SEG_CLK;
    output reg SEG_CLR = 1'b1;
    output wire SEG_DT;
    output reg SEG_EN = 1'b1;
    // PS2 keyboard
    input wire PS2_CLK;
    input wire PS2_DATA;
    input wire PS2_RST;
    // LED
    output wire LED_CLK;
    output reg LED_CLR = 1;
    output wire LED_DO;
    output reg LED_EN = 1;

    // VGA
    wire [9:0] x_pos_original;
    wire [8:0] y_pos_original;
    wire is_active_video;
    reg [11:0] color;
    // in x, y pos, whether elements below exist
    reg is_snake_body;
    reg is_snake_head;
    reg is_apple;
    reg is_border;
    // snake
    integer max_snake_size = 127;
    reg [6:0] snake_size;
    reg [9:0] snake_x[0:126];  // pos of snake in x coordinate  // snake_x[0] is the head
    reg [8:0] snake_y[0:126];  // pos of snake in y coordinate  // snake_y[0] is the head
    wire clk_1s;  // moving speed of snake
    wire clk_500ms;  // moving speed of snake
    wire clk_250ms;  // moving speed of snake
    wire clk_100ms;  // moving speed of snake
    reg snake_clk;  // moving speed of snake
    integer i_is_snake_body;  // iterative for is_snake_body
    integer i_snake_update;  // iterative for update snake
    reg is_snake_GG;  // full signal
    // apple
    reg [9:0] apple_x;
    reg [8:0] apple_y;
    reg apple_invalid;
    // btn
    reg [3:0] last_direction;
    // keyboard
    wire [3:0] kb_direction;
    // bcd
    wire [25:0] snake_size_bcd;
    // LED
    wire dummy_finish;
    // signals
    wire [9:0] rand_x;
    wire [8:0] rand_y;
    reg reset_game;  // for 1 clk
    reg old_switch;
    wire seg_finish;
    wire [9:0] x_pos;
    wire [8:0] y_pos;
    reg is_game_zone;

    // VGA
    assign {VGA_b, VGA_g, VGA_r} = color;
    // WORKAROUND
    // assign x_pos = x_pos_original - `OFFSET;
    assign x_pos = (x_pos_original >= 50) ? x_pos_original - 50 : 540;
    // assign y_pos = y_pos_original - `OFFSET;
    assign y_pos = (y_pos_original >= 50) ? y_pos_original - 50 : 380;
    // assign rand_x = `OFFSET + 80;
    // assign rand_y = `OFFSET + 50;
    
    // 16-bit hexDisplay
    DispNum h0(clk, 1'b0, snake_size_bcd[15:0], 4'b0, 4'b0, AN, SEGMENT);
    // 4x8-bit hex  // record the pos of the snake's head
    // SEG_DRV h1(clk, snake_clk, 8'b0, {6'b0, snake_x[0], 7'b0, snake_y[0]}, 8'b00010000, seg_finish, SEG_CLK, SEG_DT);
    SEG_DRV h1(clk, snake_clk, 8'b0, {6'b0, rand_x, 7'b0, rand_y}, 8'b00010000, seg_finish, SEG_CLK, SEG_DT);
    // VGA
    VGA_640x480_60hz_DRV v0(clk, 1'b0, VGA_hs, VGA_vs, x_pos_original, y_pos_original, is_active_video);
    // clk
    clk_1s c0(clk, clk_1s);
    clk_500ms c1(clk, clk_500ms);
    clk_250ms c2(clk, clk_250ms);
    clk_100ms c3(clk, clk_100ms);
    // clk_50mhz ckb0(clk, clk_50mhz);
    // ramdon_generator
    Random_generator r0(clk, SW[15], SW[14:11], rand_x, rand_y);
    // keyboard_driver
    PS2_Transfer kb0(clk, PS2_CLK, PS2_DATA, kb_direction);
    // hex to dec
    Hex2BCD16b bcd0({9'b0, snake_size}, snake_size_bcd);
    // LED
    LED_DRV led0(clk, snake_clk, SW, dummy_finish, LED_CLK, LED_DO);

    // init
    integer i;
    initial begin
        old_switch = SW[15];
        snake_size = 1;
        for (i = 0; i < 127; i = i + 1) begin
            snake_x[i] = 10;
            snake_y[i] = 10;
        end
        snake_x[0] = 0;
        snake_y[0] = 0;
        apple_x = rand_x;
        apple_y = rand_y;
        last_direction = 4'b0001;
    end

    // snake_clk
    always @(posedge clk) begin
        case (SW[5:4])
            0: snake_clk <= clk_1s;
            1: snake_clk <= clk_500ms;
            2: snake_clk <= clk_250ms;
            3: snake_clk <= clk_100ms;
            default: snake_clk <= clk_500ms;
        endcase
    end

    // is_game_zone
    always @(x_pos or y_pos) begin
        if (x_pos >= 0 && x_pos < 540 && y_pos >= 0 && y_pos < 380 && is_active_video) begin
            is_game_zone <= 1;
        end
        else begin
            is_game_zone <= 0;
        end
    end

    // last_direction
    always @(posedge clk) begin
        case (kb_direction)
            4'b1000: begin
                if (last_direction != 4'b0100)
                    last_direction <= 4'b1000;
            end
            4'b0100: begin
                if (last_direction != 4'b1000)
                    last_direction <= 4'b0100;
            end
            4'b0010: begin
                if (last_direction != 4'b0001)
                    last_direction <= 4'b0010;
            end
            4'b0001: begin
                if (last_direction != 4'b0010)
                    last_direction <= 4'b0001;
            end
            // 4'b0000: begin
            //     last_direction <= last_direction;
            // end
            default: begin
                case (SW[3:0])
                    4'b1000: begin
                        if (last_direction != 4'b0100)
                            last_direction <= 4'b1000;
                    end
                    4'b0100: begin
                        if (last_direction != 4'b1000)
                            last_direction <= 4'b0100;
                    end
                    4'b0010: begin
                        if (last_direction != 4'b0001)
                            last_direction <= 4'b0010;
                    end
                    4'b0001: begin
                        if (last_direction != 4'b0010)
                            last_direction <= 4'b0001;
                    end
                    4'b0000: begin
                        last_direction <= last_direction;
                    end
                    default: begin
                        last_direction <= last_direction;
                    end
                endcase
            end
        endcase
        if (reset_game) begin
            last_direction <= 4'b0001;
        end
    end

    // old_switch
    always @(posedge snake_clk) begin
        old_switch <= SW[15];
    end

    // reset_game
    always @(posedge clk) begin
        if (SW[15] == 1 && old_switch == 0) begin
            reset_game <= 1;
        end else begin
            reset_game <= 0;
        end
    end

    // is_snake_GG
    always @(posedge clk) begin
        if (is_snake_head && is_border || is_snake_head && is_snake_body) begin
            is_snake_GG <= 1;
        end
        else if (reset_game) begin
            is_snake_GG <= 0;
        end
    end

    // update snake body
    always @(posedge snake_clk) begin
        if (!is_snake_GG) begin
            // body
            for (i_snake_update = 126; i_snake_update > 0; i_snake_update = i_snake_update - 1) begin
                snake_x[i_snake_update] <= snake_x[i_snake_update - 1];
                snake_y[i_snake_update] <= snake_y[i_snake_update - 1];
            end
            // head
            case (last_direction)
                4'b1000: begin
                    snake_y[0] <= snake_y[0] - 10;
                end
                4'b0100: begin
                    snake_y[0] <= snake_y[0] + 10;
                end
                4'b0010: begin
                    snake_x[0] <= snake_x[0] - 10;
                end
                4'b0001: begin
                    snake_x[0] <= snake_x[0] + 10;
                end
                4'b0000: begin
                    ;
                end
                default: begin
                    ;
                end
            endcase
        end
        // init
        if (reset_game) begin
            for (i = 0; i < 127; i = i + 1) begin
                snake_x[i] <= 10;
                snake_y[i] <= 10;
            end
            snake_x[0] <= 10;
            snake_y[0] <= 10;
        end
    end

    // update snake_size (length)
    always @(posedge clk) begin
        if (is_snake_head && is_apple && !apple_invalid && snake_size < max_snake_size) begin
            snake_size <= snake_size + 1;
        end
        if (reset_game) begin
            snake_size <= 1;
        end
    end

    // is_snake_body
    always @(posedge clk) begin
        // is_snake_body <= 0;
        // for (i_is_snake_body = 1; i_is_snake_body < 127; i_is_snake_body = i_is_snake_body + 1) begin
        //     if (i_is_snake_body < snake_size) begin
        //         if (x_pos >= snake_x[i_is_snake_body] && x_pos < snake_x[i_is_snake_body] + 10 && y_pos >= snake_y[i_is_snake_body] && y_pos < snake_y[i_is_snake_body] + 10) begin
        //             is_snake_body <= 1;
        //         end
        //     end
        // end

        // TODO: test this
        is_snake_body = 0;
        for (i_is_snake_body = 1; i_is_snake_body < 127; i_is_snake_body = i_is_snake_body + 1) begin: snake_body_loop
            if (i_is_snake_body < snake_size) begin
                if (x_pos >= snake_x[i_is_snake_body] && x_pos < snake_x[i_is_snake_body] + 10 && y_pos >= snake_y[i_is_snake_body] && y_pos < snake_y[i_is_snake_body] + 10) begin
                    is_snake_body = 1;
                    disable snake_body_loop;
                end
            end
        end
    end

    // is_snake_head
    always @(posedge clk) begin
        if (x_pos >= snake_x[0] && x_pos < snake_x[0] + 10 && y_pos >= snake_y[0] && y_pos < snake_y[0] + 10) begin
            is_snake_head <= 1;
        end else begin
            is_snake_head <= 0;
        end
    end

    // is_border
    always @(posedge clk) begin
        if (x_pos < 10 || x_pos >= 540 - 10 || y_pos < 10 || y_pos >= 380 - 10) begin
            is_border <= 1;
        end else begin
            is_border <= 0;
        end
    end

    // apple position
    always @(posedge clk) begin
        if (is_snake_head && is_apple || reset_game || apple_invalid) begin
            apple_x <= rand_x;
            apple_y <= rand_y;
        end
    end

    // is_apple
    always @(posedge clk) begin
        if (x_pos >= apple_x && x_pos < apple_x + 10 && y_pos >= apple_y && y_pos < apple_y + 10 && !is_snake_GG) begin
            is_apple <= 1;
        end else begin
            is_apple <= 0;
        end
    end

    // apple_invalid
    always @(posedge clk) begin
        if (is_apple && is_border || is_apple && is_snake_body  // the apple goes on the top of elements
            || apple_invalid == 1 && snake_x[0] == rand_x && snake_y[0] == rand_y  // pending position is the head of the snake
            || is_snake_head && is_apple && !apple_invalid)  // the snake ate an apple
            apple_invalid <= 1;
        else
            apple_invalid <= 0;
    end

    // display
    always @(posedge clk) begin
        if (is_game_zone) begin
            if (is_apple)
                color <= 12'h0FF;
            else if (is_snake_head || is_snake_body)
                color <= 12'hFFF;
            else if (is_border)
                color <= 12'h00F;
            else
                color <= 12'h000;
        end
        else begin
            color <= 12'h000;
        end
    end

endmodule // Top
