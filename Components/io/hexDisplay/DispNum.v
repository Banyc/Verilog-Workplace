`include "./Components/clock/clkdiv.v"
`include "./Components/io/hexDisplay/DisplaySyn.v"
`include "./Components/io/hexDisplay/MC14495.v"

// DispNum m6(clk, 1'b0, num, 4'b0, 4'b0, AN, SEGMENT);

module DispNum(
    input wire clk, rst,
    input wire [15:0] hexs,  // all four number to display  // leftmost[15:12]; secondLeft[11:8]; secondRight[7:4]; rightmost[3:0]
    input wire [3:0] points,  // point to display  // 1: activated
    input wire [3:0] les,  // "enable" for all four display  // 0: enable
    // the output wires should be directly connected to the display hardware
    output wire [3:0] an,  // in turn of which display's  // 0: enabled
    output wire [7:0] segment  // Segement of a char display  // point is represented by segement[7]
);
    wire [31:0] clk_counter;
    wire [3:0] num_to_display;
    wire point_to_display;
    wire is_disabled;
    wire [3:0] turn_index;

    clkdiv slowed_clock(.clk(clk), .rst(rst), .clkdiv(clk_counter));

    DisplaySyn dynamic_allocated_display(
        .Scan(clk_counter[18:17]),
        .Hexs(hexs),
        .Point(points),
        .LES(les),
        .HEX(num_to_display),
        .P(point_to_display),
        .LE(is_disabled),
        .AN(turn_index)
        );

    assign an = turn_index;

    MC14495 base_display(
        .LE(is_disabled),
        .D0(num_to_display[0]),
        .D1(num_to_display[1]),
        .D2(num_to_display[2]),
        .D3(num_to_display[3]),
        .Point(point_to_display),
        .a(segment[0]),
        .b(segment[1]),
        .c(segment[2]),
        .d(segment[3]),
        .e(segment[4]),
        .f(segment[5]),
        .g(segment[6]),
        .p(segment[7])
        );

endmodule // DispNum
