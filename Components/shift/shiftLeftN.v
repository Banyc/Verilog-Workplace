`ifndef __ShiftLeftN__
`define __ShiftLeftN__

// left shift 2 bits padded with 0's
module ShiftLeftN(
    from,
    shamt,
    to
);
    input wire [31:0] from;
    input wire [4:0] shamt;
    output wire [31:0] to;

    assign to = from << shamt;
endmodule // ShiftLeftN

`endif
