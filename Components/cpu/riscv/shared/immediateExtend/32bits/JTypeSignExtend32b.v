`ifndef __JTypeSignExtend32b__
`define __JTypeSignExtend32b__

module JTypeSignExtend32b (
    instruction,
    signExtended
);
    input wire [31:0] instruction;
    output wire [31:0] signExtended;

    assign signExtended = 
    {
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
    
endmodule

`endif
