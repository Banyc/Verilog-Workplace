`ifndef __ITypeSignExtend32b__
`define __ITypeSignExtend32b__

`include "./Components/shift/SignExtend12To32.v"

module ITypeSignExtend32b (
    instruction,
    signExtended
);
    input wire [31:0] instruction;
    output wire [31:0] signExtended;

    SignExtend12To32 signExtend12To32_instance(
        .from(instruction[31:20]),
        .to(signExtended)
    );

endmodule

`endif
