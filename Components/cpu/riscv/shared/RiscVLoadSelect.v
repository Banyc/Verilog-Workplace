`ifndef __RiscVLoadSelect_v__
`define __RiscVLoadSelect_v__

`include "Components/cpu/riscv/EnumFunct3.vh"

module RiscVLoadSelect (
    funct3,
    memoryReadData,
    selectMemoryReadData
);
    input wire [2:0] funct3;
    input wire [31:0] memoryReadData;
    output reg [31:0] selectMemoryReadData;

    always @(*) begin
        case (funct3)
            `riscv32_funct3_LB: begin
                selectMemoryReadData <= {{24{memoryReadData[7]}}, memoryReadData[7:0]};
            end
            `riscv32_funct3_LH: begin
                selectMemoryReadData <= {{16{memoryReadData[15]}}, memoryReadData[15:0]};
            end
            `riscv32_funct3_LW: begin
                selectMemoryReadData <= memoryReadData;
            end
            `riscv32_funct3_LBU: begin
                selectMemoryReadData <= {24'b0, memoryReadData[7:0]};
            end
            `riscv32_funct3_LHU: begin
                selectMemoryReadData <= {16'b0, memoryReadData[15:0]};
            end
            default: begin
                selectMemoryReadData <= 0;
            end
        endcase
    end

endmodule

`endif
