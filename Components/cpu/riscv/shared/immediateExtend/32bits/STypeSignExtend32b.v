`ifndef __STypeSignExtend32b__
`define __STypeSignExtend32b__

`include "./Components/shift/SignExtend12To32.v"

module STypeSignExtend32b (
    instruction,
    signExtended
);
    input wire [31:0] instruction;
    output wire [31:0] signExtended;

    SignExtend12To32 signExtend12To32_instance(
        .from({instruction[31:25], instruction[11:7]}),
        .to(signExtended)
    );

endmodule

`endif
