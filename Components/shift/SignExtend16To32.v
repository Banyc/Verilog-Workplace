`ifndef __SignExtend16To32__
`define __SignExtend16To32__

// extend 2's compliement with 16 bits to 32 bits 
module SignExtend16To32(
    from,
    to,
);
    input wire [15:0] from;
    output wire [31:0] to;

    assign to = {
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from[15],
        from
    };
endmodule // SignExtend16To32

`endif
