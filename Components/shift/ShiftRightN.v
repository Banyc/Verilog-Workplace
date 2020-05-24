`ifndef __ShiftRightN__
`define __ShiftRightN__

// left shift 2 bits padded with 0's
module ShiftRightN(
    from,
    shamt,
    to
);
    input wire [31:0] from;
    input wire [4:0] shamt;
    output wire [31:0] to;

    assign to = from >> shamt;
endmodule // ShiftRightN

`endif
