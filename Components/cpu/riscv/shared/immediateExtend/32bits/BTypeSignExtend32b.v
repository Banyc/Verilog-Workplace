`ifndef __BTypeSignExtend32b__
`define __BTypeSignExtend32b__

module BTypeSignExtend32b (
    instruction,
    signExtended
);
    input wire [31:0] instruction;
    output wire [31:0] signExtended;

    assign signExtended = 
    {
        {20 {instruction[31]}},  // imm[12]
        instruction[7],  // imm[11]
        instruction[30:25],  // imm[10:5]
        instruction[11:8],  // imm[4:1]
        1'b0
    };
    
endmodule

`endif
