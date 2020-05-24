`ifndef __OpcodeEnum__
`define __OpcodeEnum__

// enum opcode

`define RType    6'b000000

`define SPECIAL  6'b000000
`define REGIMM   6'b000001
`define J        6'b000010
`define JAL      6'b000011
`define BEQ      6'b000100
`define BNE      6'b000101
`define BLEZ     6'b000110
`define BGTZ     6'b000111

`define ADDI     6'b001000
`define ADDIU    6'b001001
`define SLTI     6'b001010
`define SLTIU    6'b001011
`define ANDI     6'b001100
`define ORI      6'b001101
`define XORI     6'b001110
`define LUI      6'b001111

`define COP0     6'b010000
`define COP1     6'b010001
`define COP2     6'b010010
`define COP3     6'b010011
`define BEQL     6'b010100
`define BNEL     6'b010101
`define BLEZL    6'b010110
`define BGTZL    6'b010111

`define LB       6'b100000
`define LH       6'b100001
`define LWL      6'b100010
`define LW       6'b100011
`define LBU      6'b100100
`define LHU      6'b100101
`define LWR      6'b100110

`define SB       6'b101000
`define SH       6'b101001
`define SWL      6'b101010
`define SW       6'b101011

`define SWR      6'b101110
`define CACHE    6'b101111

`define LL       6'b110000
`define LWC1     6'b110001
`define LWC2     6'b110010
`define LWC3     6'b110011

`define LDC1     6'b110101
`define LDC2     6'b110110
`define LDC3     6'b110111

`define SC       6'b111000
`define SWC1     6'b111001
`define SWC2     6'b111010
`define SWC3     6'b111011

`define SDC1     6'b111101
`define SDC2     6'b111110
`define SDC3     6'b111111

/*-----------------------------------------------------------------------------*
 * Enum Funct                                                                  *
 *-----------------------------------------------------------------------------*/

`define SLL      6'b000000
`define SRL      6'b000010
`define SRA      6'b000011
`define SLLV     6'b000100
`define SRLV     6'b000110
`define SRAV     6'b000111

`define JR       6'b001000
`define JALR     6'b001001

`define SYSCALL  6'b001100
`define BREAK    6'b001101

`define MFHI     6'b010000
`define MTHI     6'b010001
`define MFLO     6'b010010
`define MTLO     6'b010011

`define MULT     6'b011000
`define MULTU    6'b011001
`define DIV      6'b011010
`define DIVU     6'b011011

`define ADD      6'b100000
`define ADDU     6'b100001
`define SUB      6'b100010
`define SUBU     6'b100011
`define AND      6'b100100
`define OR       6'b100101
`define XOR      6'b100110
`define NOR      6'b100111

`define SLT      6'b101010
`define SLTU     6'b101011

`define TGE      6'b110000
`define TGEU     6'b110001
`define TLT      6'b110010
`define TLTU     6'b110011
`define TEQ      6'b110100

`define TNE      6'b110110

// enum AluOpType

`define AluOpType_Add       2'b00
`define AluOpType_Sub       2'b01
`define AluOpType_Funct     2'b10
`define AluOpType_Immediate 2'b11

// enum AluControl

`define ALU_and      4'b0000
`define ALU_or       4'b0001
`define ALU_add      4'b0010
`define ALU_sub      4'b0110
// set on less than
`define ALU_slt      4'b0111
`define ALU_nor      4'b1100
// customized
`define ALU_sll      4'b1001

// enum Funct



`endif
