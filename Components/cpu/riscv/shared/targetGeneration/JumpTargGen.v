`ifndef __JumpTargGen__
`define __JumpTargGen__

// unconditional jump to immediate
module JumpTargGen (
    pc,
    instruction,
    target
);
    input wire [31:0] pc;
    input wire [31:0] instruction;
    output wire [31:0] target;

    wire [31:0] immediate;
    assign immediate = {
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[31],
        instruction[19:12],
        instruction[20],
        instruction[30:25],
        instruction[24:21],
        1'b0
    };

    // TODO: review
    assign target = {
        pc[31:21],
        immediate[20:0]
    };

endmodule

`endif
