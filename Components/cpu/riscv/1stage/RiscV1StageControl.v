`ifndef __RiscV1StageControl__
`define __RiscV1StageControl__

`include "Components/cpu/riscv/EnumOpcode.vh"
`include "Components/cpu/riscv/EnumFunct3.vh"
`include "Components/cpu/riscv/EnumFunct7.vh"
`include "Components/cpu/riscv/EnumFunct10.vh"
`include "Components/cpu/riscv/EnumInstructionTypes.vh"
`include "Components/adder/Alu32b_extended_enumAluOp.vh"
`include "Components/cpu/riscv/1stage/EnumSelections.vh"

module RiscV1StageControl (
    instruction,
    isBranchEqual,

    pcSelect,
    op2Select,
    op1Select,
    aluFunction,
    writebackSelect,
    regFileWriteEnable,
    memoryReadEnable,
    memoryWriteEnable
);

    input wire [31:0] instruction;
    input wire isBranchEqual;

    output reg [2:0] pcSelect;
    output reg [2:0] op2Select;
    output reg [1:0] op1Select;
    output reg [3:0] aluFunction;
    output reg [1:0] writebackSelect;
    output reg regFileWriteEnable;
    output reg memoryReadEnable;
    output reg memoryWriteEnable;

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [9:0] funct10;
    reg [2:0] instructionType;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign funct10 = {funct7, funct3};

    // instruction type
    always @(*) begin
        case (opcode)
            `riscv32_opcode_LUI: begin
                instructionType = `riscv_instructionType_U;
            end
            `riscv32_opcode_JAL: begin
                instructionType = `riscv_instructionType_UJ;
            end
            `riscv32_opcode_ADDI,
            `riscv32_opcode_LW,
            `riscv32_opcode_JALR: begin
                instructionType = `riscv_instructionType_I;
            end
            `riscv32_opcode_BEQ: begin
                instructionType = `riscv_instructionType_SB;
            end
            `riscv32_opcode_SW: begin
                instructionType = `riscv_instructionType_S;
            end
            `riscv32_opcode_ADD: begin
                instructionType = `riscv_instructionType_R;
            end
            default: begin
                instructionType = `riscv_instructionType_undefined;
            end
        endcase
    end
    
    // ALU function/ALU op
    // support both R-type and I-type arithmatics
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_R,
            `riscv_instructionType_I: begin
                case (opcode)
                    // "load" and `jalr` are also I-type
                    `riscv32_opcode_JALR,
                    `riscv32_opcode_LW: begin
                        aluFunction = `Alu32b_extended_aluOp_add;
                    end
                    default: begin
                        // start arithmatics
                        case (funct3)
                            `riscv32_funct3_ADD_SUB: begin
                                case (funct7)
                                    `riscv32_funct7_ADD: begin
                                        aluFunction = `Alu32b_extended_aluOp_add;
                                    end
                                    `riscv32_funct7_SUB: begin
                                        aluFunction = `Alu32b_extended_aluOp_sub;
                                    end
                                    default: begin
                                        // exception
                                        aluFunction = 0;
                                    end
                                endcase
                            end  
                            `riscv32_funct3_SLL: begin
                                aluFunction = `Alu32b_extended_aluOp_sll;
                            end  
                            `riscv32_funct3_SLT: begin
                                aluFunction = `Alu32b_extended_aluOp_slt;
                            end  
                            `riscv32_funct3_SLTU: begin
                                aluFunction = `Alu32b_extended_aluOp_sltu;
                            end 
                            `riscv32_funct3_XOR: begin
                                aluFunction = `Alu32b_extended_aluOp_xor;
                            end  
                            `riscv32_funct3_SRL_SRA: begin
                                case (funct7)
                                    `riscv32_funct7_SRL: begin
                                        aluFunction = `Alu32b_extended_aluOp_srl;
                                    end
                                    `riscv32_funct7_SRA: begin
                                        aluFunction = `Alu32b_extended_aluOp_sra;
                                    end
                                    default: begin
                                        // exception
                                        aluFunction = 0;
                                    end
                                endcase
                            end  
                            `riscv32_funct3_OR: begin
                                aluFunction = `Alu32b_extended_aluOp_or;
                            end   
                            `riscv32_funct3_AND: begin
                                aluFunction = `Alu32b_extended_aluOp_and;
                            end  
                            default: begin
                                // exception
                                aluFunction = 0;
                            end
                        endcase
                        // end arithmatics     
                    end
                endcase
            end
            default: begin
                aluFunction = `Alu32b_extended_aluOp_add;
            end
        endcase
    end

    // pcSelect,
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_R: begin
                pcSelect = `riscv32_1stage_pc_sel_pc_4;
            end
            `riscv_instructionType_I: begin
                case (opcode)
                    `riscv32_opcode_JALR: begin
                        pcSelect = `riscv32_1stage_pc_sel_jalr;
                    end
                    default: begin
                        pcSelect = `riscv32_1stage_pc_sel_pc_4;
                    end
                endcase
            end
            `riscv_instructionType_S: begin
                pcSelect = `riscv32_1stage_pc_sel_pc_4;
            end
            `riscv_instructionType_SB: begin
                if (funct3 == `riscv32_funct3_BEQ && isBranchEqual
                || funct3 == `riscv32_funct3_BNE && !isBranchEqual) begin
                    pcSelect = `riscv32_1stage_pc_sel_branch;
                end else begin
                    pcSelect = `riscv32_1stage_pc_sel_pc_4;
                end
            end
            `riscv_instructionType_U: begin
                pcSelect = `riscv32_1stage_pc_sel_pc_4;
            end
            `riscv_instructionType_UJ: begin
                pcSelect = `riscv32_1stage_pc_sel_jump;
            end
            default: begin
                // exception
                pcSelect = `riscv32_1stage_pc_sel_exception;
            end
        endcase
    end

    // op2Select,
    // op1Select,
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_R: begin
                op1Select = `riscv32_1stage_op1Sel_rs1;
                op2Select = `riscv32_1stage_op2Sel_rs2;
            end
            `riscv_instructionType_I: begin
                case (funct3)
                    `riscv32_funct3_SLL,
                    `riscv32_funct3_SRL_SRA: begin
                        op2Select = `riscv32_1stage_op2Sel_shamtSignExtend;
                    end
                    default: begin
                        op2Select = `riscv32_1stage_op2Sel_iTypeSignExtend;
                    end
                endcase
                op1Select = `riscv32_1stage_op1Sel_rs1;
            end
            `riscv_instructionType_S: begin
                op1Select = `riscv32_1stage_op1Sel_rs1;
                op2Select = `riscv32_1stage_op2Sel_sTypeSignExtend;
            end
            `riscv_instructionType_SB: begin
                // ALU result not used
                op1Select = 0;
                op2Select = 0;
            end
            `riscv_instructionType_U: begin
                op1Select = `riscv32_1stage_op1Sel_uTypeImmediate;
                op2Select = `riscv32_1stage_op2Sel_zero;
            end
            `riscv_instructionType_UJ: begin
                // ALU result not used
                op1Select = 0;
                op2Select = 0;
            end
            default: begin
                // exception
                op1Select = 0;
                op2Select = 0;
            end
        endcase
    end

    // memoryReadEnable
    // memoryWriteEnable
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_I: begin
                case (opcode)
                    `riscv32_opcode_LW: begin
                        memoryReadEnable = 1;
                    end
                    default: begin
                        memoryReadEnable = 0;
                    end 
                endcase
                memoryWriteEnable = 0;
            end
            `riscv_instructionType_S: begin
                memoryReadEnable = 0;
                memoryWriteEnable = 1;
            end
            default: begin
                memoryReadEnable = 0;
                memoryWriteEnable = 0;
            end
        endcase
    end

    // writebackSelect,
    // regFileWriteEnable
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_R: begin
                writebackSelect = `riscv32_1stage_wb_sel_aluOut;
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_I: begin
                case (opcode)
                    `riscv32_opcode_LW: begin
                        writebackSelect = `riscv32_1stage_wb_sel_memoryOut;
                    end
                    `riscv32_opcode_JALR: begin
                        writebackSelect = `riscv32_1stage_wb_sel_pc_4;
                    end
                    `riscv32_opcode_ADDI: begin
                        writebackSelect = `riscv32_1stage_wb_sel_aluOut;
                    end
                    default: begin
                        // exception
                        writebackSelect = 0;
                    end
                endcase
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_U: begin
                writebackSelect = `riscv32_1stage_wb_sel_aluOut;
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_UJ: begin
                writebackSelect = `riscv32_1stage_wb_sel_pc_4;
                regFileWriteEnable = 1;
            end
            default: begin
                regFileWriteEnable = 0;
            end
        endcase
    end

endmodule

`endif
