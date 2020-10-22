# RISC V

## Sodor

- <https://docs.google.com/document/d/1WPQblOoKIODLrIacFSumXR6_uC9zquyixNFN8ABVQxY/edit>

## Instructions

- <https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf>
    - instruction types
- ![](img/instructionTypes.png)
    - R-type
        - Arithmetics
            - add rd, rs1, rs2
                - rd <- rs1 <?> rs2
    - I-type
        - Arithmetics
            - addi rd, rs1, imm
                - rd <- rs1 <?> imm
        - load
            - lw rd, imm(rs1)
                - rd <- mem[rs1 + imm]
        - jalr
            - jalr rd, imm(rs1)
                - rd <- pc + 4
                - pc <- rs1 + imm
            - pseudo
                - jr rs | jalr x0, 0(rs) | Jump register
                - jalr rs | jalr x1, 0(rs) | Jump and link register
                - ret | jalr x0, 0(x1) | Return from subroutine
    - S-type
        - store
            - sw rs2, imm(rs1)
                - mem[rs1 + imm] <- rs2
    - SB-type
        - conditional branch
            - beq rs1, rs2, label/offset
    - U-type
        - Dealing With Large Immediates
        - LUI (load upper immediate)
            - lui rd, imm
                - rd <- imm
    - UJ-type
        - jal rd, label/direct_imm
            - rd <- pc + 4
            - pc <- immediate
- ![](img/immediate.png)
- ![](img/2020-09-29-20-12-04.png)