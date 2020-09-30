`ifndef __UType32b__
`define __UType32b__

module UType32b (
    instruction,
    extended
);
    input wire [31:0] instruction;
    output wire [31:0] extended;

    assign extended = {
        instruction[31:12],
        12'b0
    };

endmodule

`endif
