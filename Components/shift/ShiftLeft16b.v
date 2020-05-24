`ifndef __ShiftLeft16b__
`define __ShiftLeft16b__

// left shift 2 bits padded with 0's
module ShiftLeft16b(
    from,
    to
);
    input wire [31:0] from;
    output wire [31:0] to;

    assign to = {from[15:0], 16'b0};
endmodule // ShiftLeft16b

`endif
