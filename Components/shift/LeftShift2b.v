`ifndef __LeftShift2b__
`define __LeftShift2b__

// left shift 2 bits padded with 0's
module LeftShift2b(
    from,
    to
);
    input wire [31:0] from;
    output wire [31:0] to;

    assign to = {from[29:0], 2'b00};
endmodule // LeftShift2b

`endif
