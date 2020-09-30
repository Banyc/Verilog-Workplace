`ifndef __SignExtend12To32__
`define __SignExtend12To32__

// extend 2's compliement with 12 bits to 32 bits 
module SignExtend12To32(
    from,
    to
);
    input wire [11:0] from;
    output wire [31:0] to;

    assign to = {
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from[11],
        from
    };
endmodule // SignExtend12To32

`endif
