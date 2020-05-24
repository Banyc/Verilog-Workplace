`ifndef __Nor32b__
`define __Nor32b__

module Nor32b(
    leftOperand,
    rightOperand,
    result
);
    input wire [31:0] leftOperand;
    input wire [31:0] rightOperand;
    output wire [31:0] result;

    assign result[0]  = ~(leftOperand[0]  | rightOperand[0]);
    assign result[1]  = ~(leftOperand[1]  | rightOperand[1]);
    assign result[2]  = ~(leftOperand[2]  | rightOperand[2]);
    assign result[3]  = ~(leftOperand[3]  | rightOperand[3]);
    assign result[4]  = ~(leftOperand[4]  | rightOperand[4]);
    assign result[5]  = ~(leftOperand[5]  | rightOperand[5]);
    assign result[6]  = ~(leftOperand[6]  | rightOperand[6]);
    assign result[7]  = ~(leftOperand[7]  | rightOperand[7]);
    assign result[8]  = ~(leftOperand[8]  | rightOperand[8]);
    assign result[9]  = ~(leftOperand[9]  | rightOperand[9]);
    assign result[10] = ~(leftOperand[10] | rightOperand[10]);
    assign result[11] = ~(leftOperand[11] | rightOperand[11]);
    assign result[12] = ~(leftOperand[12] | rightOperand[12]);
    assign result[13] = ~(leftOperand[13] | rightOperand[13]);
    assign result[14] = ~(leftOperand[14] | rightOperand[14]);
    assign result[15] = ~(leftOperand[15] | rightOperand[15]);
    assign result[16] = ~(leftOperand[16] | rightOperand[16]);
    assign result[17] = ~(leftOperand[17] | rightOperand[17]);
    assign result[18] = ~(leftOperand[18] | rightOperand[18]);
    assign result[19] = ~(leftOperand[19] | rightOperand[19]);
    assign result[20] = ~(leftOperand[20] | rightOperand[20]);
    assign result[21] = ~(leftOperand[21] | rightOperand[21]);
    assign result[22] = ~(leftOperand[22] | rightOperand[22]);
    assign result[23] = ~(leftOperand[23] | rightOperand[23]);
    assign result[24] = ~(leftOperand[24] | rightOperand[24]);
    assign result[25] = ~(leftOperand[25] | rightOperand[25]);
    assign result[26] = ~(leftOperand[26] | rightOperand[26]);
    assign result[27] = ~(leftOperand[27] | rightOperand[27]);
    assign result[28] = ~(leftOperand[28] | rightOperand[28]);
    assign result[29] = ~(leftOperand[29] | rightOperand[29]);
    assign result[30] = ~(leftOperand[30] | rightOperand[30]);
    assign result[31] = ~(leftOperand[31] | rightOperand[31]);

endmodule // Nor32b

`endif
