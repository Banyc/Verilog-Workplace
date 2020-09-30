`ifndef __ShamtSignExtend32b__
`define __ShamtSignExtend32b__

module ShamtSignExtend32b (
    instruction,
    signExtended
);
    input wire [31:0] instruction;
    output wire [31:0] signExtended;

    assign signExtended = {
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24],
        instruction[24:20]
    };

endmodule

`endif
