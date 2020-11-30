`ifndef __BranchCondGen__
`define __BranchCondGen__

module BranchCondGen (
    rs1,
    rs2,
    is_br_eq,
    is_br_lt,
    is_br_ltu
);
    input wire [31:0] rs1;
    input wire [31:0] rs2;
    output wire is_br_eq;
    output wire is_br_lt;
    output wire is_br_ltu;

    wire [31:0] difference;
    assign difference = rs1 - rs2;
    assign is_br_eq = difference == 0 ? 1'b1 : 1'b0;
    // TODO
    // assign is_br_lt
    // assign is_br_ltu

endmodule

`endif
