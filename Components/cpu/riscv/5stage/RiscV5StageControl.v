`ifndef __RiscV5StageControl__
`define __RiscV5StageControl__

`include "Components/cpu/riscv/EnumOpcode.vh"
`include "Components/cpu/riscv/EnumFunct3.vh"
`include "Components/cpu/riscv/EnumFunct7.vh"
`include "Components/cpu/riscv/EnumFunct10.vh"
`include "Components/cpu/riscv/EnumInstructionTypes.vh"
`include "Components/adder/Alu32b_extended_enumAluOp.vh"
`include "Components/cpu/riscv/5stage/EnumSelections.vh"

module RiscV5StageControl (
    instruction,

    pcSelect,
    op2Select,
    op1Select,
    aluFunction,
    mem_writebackSelect,
    exe_writebackSelect,
    regFileWriteEnable,
    memoryReadEnable,
    memoryWriteEnable,
    isBne,
    isBeq
);

    input wire [31:0] instruction;

    output reg [1:0] pcSelect;
    output reg [2:0] op2Select;
    output reg [1:0] op1Select;
    output reg [3:0] aluFunction;
    output reg [1:0] mem_writebackSelect;
    output reg exe_writebackSelect;
    output reg regFileWriteEnable;
    output reg memoryReadEnable;
    output reg memoryWriteEnable;
    output reg isBne;
    output reg isBeq;

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

    // is branch?
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_SB: begin
                case (funct3)
                    `riscv32_funct3_BEQ: begin
                        isBne = 0;
                        isBeq = 1;
                    end
                    `riscv32_funct3_BNE: begin
                        isBne = 1;
                        isBeq = 0;
                    end
                    default: begin
                        isBne = 0;
                        isBeq = 0;
                    end
                endcase
            end
            default: begin 
                isBne = 0;
                isBeq = 0;
            end
        endcase
    end

    // pcSelect,
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_R: begin
                pcSelect = `riscv32_5stage_pc_sel_pc_4;
            end
            `riscv_instructionType_I: begin
                case (opcode)
                    `riscv32_opcode_JALR: begin
                        pcSelect = `riscv32_5stage_pc_sel_jalr;
                    end
                    default: begin
                        pcSelect = `riscv32_5stage_pc_sel_pc_4;
                    end
                endcase
            end
            `riscv_instructionType_S: begin
                pcSelect = `riscv32_5stage_pc_sel_pc_4;
            end
            `riscv_instructionType_SB: begin
                // if (funct3 == `riscv32_funct3_BEQ && isBranchEqual
                // || funct3 == `riscv32_funct3_BNE && !isBranchEqual) begin
                //     pcSelect = `riscv32_5stage_pc_sel_jumpOrBranch;
                // end else begin
                //     pcSelect = `riscv32_5stage_pc_sel_pc_4;
                // end
                // do nothing
            end
            `riscv_instructionType_U: begin
                pcSelect = `riscv32_5stage_pc_sel_pc_4;
            end
            `riscv_instructionType_UJ: begin
                pcSelect = `riscv32_5stage_pc_sel_jumpOrBranch;
            end
            default: begin
                // exception
            end
        endcase
    end

    // op2Select,
    // op1Select,
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_R: begin
                op1Select = `riscv32_5stage_op1Sel_rs1;
                op2Select = `riscv32_5stage_op2Sel_rs2;
            end
            `riscv_instructionType_I: begin
                case (funct3)
                    `riscv32_funct3_SLL,
                    `riscv32_funct3_SRL_SRA: begin
                        op2Select = `riscv32_5stage_op2Sel_shamtSignExtend;
                    end
                    default: begin
                        op2Select = `riscv32_5stage_op2Sel_iTypeSignExtend;
                    end
                endcase
                op1Select = `riscv32_5stage_op1Sel_rs1;
            end
            `riscv_instructionType_S: begin
                op1Select = `riscv32_5stage_op1Sel_rs1;
                op2Select = `riscv32_5stage_op2Sel_sTypeSignExtend;
            end
            `riscv_instructionType_SB: begin
                op1Select = `riscv32_5stage_op1Sel_rs1;
                op2Select = `riscv32_5stage_op2Sel_bTypeSignExtend;
                // ALU result not used
            end
            `riscv_instructionType_U: begin
                op1Select = `riscv32_5stage_op1Sel_zero;
                op2Select = `riscv32_5stage_op2Sel_uTypeImmediate;
            end
            `riscv_instructionType_UJ: begin
                // op1Select don't care
                op2Select = `riscv32_5stage_op2Sel_jTypeSignExtend;
                // ALU result not used
            end
            default: begin
                // exception
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

    // exe_writebackSelect
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_R: begin
                exe_writebackSelect = `riscv32_5stage_exe_wb_sel_aluOut;
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_I: begin
                case (opcode)
                    `riscv32_opcode_LW: begin
                        // memory address <- aluOut
                        exe_writebackSelect = `riscv32_5stage_exe_wb_sel_aluOut;
                    end
                    `riscv32_opcode_JALR: begin
                        exe_writebackSelect = `riscv32_5stage_exe_wb_sel_pc_4;
                    end
                    `riscv32_opcode_ADDI: begin
                        exe_writebackSelect = `riscv32_5stage_exe_wb_sel_aluOut;
                    end
                    default: begin
                        // exception
                    end
                endcase
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_U: begin
                exe_writebackSelect = `riscv32_5stage_exe_wb_sel_aluOut;
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_UJ: begin
                exe_writebackSelect = `riscv32_5stage_exe_wb_sel_pc_4;
                regFileWriteEnable = 1;
            end
            default: begin
                regFileWriteEnable = 0;
            end
        endcase
    end

    // mem_writebackSelect,
    // regFileWriteEnable
    always @(*) begin
        case (instructionType)
            `riscv_instructionType_R: begin
                mem_writebackSelect = `riscv32_5stage_mem_wb_sel_aluOut;
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_I: begin
                case (opcode)
                    `riscv32_opcode_LW: begin
                        mem_writebackSelect = `riscv32_5stage_mem_wb_sel_memoryReadData;
                    end
                    `riscv32_opcode_JALR: begin
                        // regFile <- pc + 4
                        mem_writebackSelect = `riscv32_5stage_mem_wb_sel_aluOut;
                    end
                    `riscv32_opcode_ADDI: begin
                        mem_writebackSelect = `riscv32_5stage_mem_wb_sel_aluOut;
                    end
                    default: begin
                        // exception
                    end
                endcase
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_U: begin
                mem_writebackSelect = `riscv32_5stage_mem_wb_sel_aluOut;
                regFileWriteEnable = 1;
            end
            `riscv_instructionType_UJ: begin
                // regFile <- pc + 4
                mem_writebackSelect = `riscv32_5stage_mem_wb_sel_aluOut;
                regFileWriteEnable = 1;
            end
            default: begin
                regFileWriteEnable = 0;
            end
        endcase
    end

endmodule

`endif
