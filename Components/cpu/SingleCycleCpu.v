`ifndef __SingleCycleCpu__
`define __SingleCycleCpu__

`include "./Components/shift/LeftShift2b.v"
`include "./Components/shift/SignExtend16To32.v"
`include "./Components/register/RegFile.v"
`include "./Components/register/Pc.v"
`include "./Components/mux/Mux2to1_5b.v"
`include "./Components/mux/Mux2to1_32b.v"
`include "./Components/memory/Rom32b.v"
`include "./Components/memory/Ram32b.v"
`include "./Components/adder/Alu32b.v"
`include "./Components/adder/AddSub32bFlag.v"
`include "./Components/cpu/OpcodeControl.v"
`include "./Components/cpu/AluControl.v"

module SingleCycleCpu(
    clk,
    rst,
    instruction,
    pcOut
);
    input wire clk;
    input wire rst;
    output wire [31:0] instruction;
    output wire [31:0] pcOut;

    // instruction fetching
    // wire [31:0] instruction;
    // wire [31:0] pcOut;
    wire [31:0] pcPlusFour;
    // instruction decoding
    wire regDst;
    wire jump;
    wire branch;
    wire branch_ne;
    wire memRead;
    wire memtoReg;
    wire [1:0] aluOp;
    wire memWrite;
    wire aluSrc;
    wire regWrite;
    wire [4:0] writeRegister;
    wire [31:0] registerReadData1;
    wire [31:0] registerReadData2;
    wire [31:0] leftShiftedTargetAddress;
    wire [31:0] jumpAddress;
    wire [31:0] extendedImmediate;
    // executing
    wire [31:0] leftShiftedImmediate;
    wire [31:0] offsetedPc;
    wire [31:0] aluSourceB;
    wire [2:0] aluOpOut;
    wire [31:0] aluResult;
    wire isAluResultZero;
    wire isBranch;
    // memory
    wire [31:0] branchAddress;
    wire [31:0] nextPc;
    wire [31:0] memoryReadData;
    // write back
    wire [31:0] registerWriteData;

    // __instruction fetching__
    Pc pc(
        .clk(clk),
        .rst(rst),
        .d(nextPc),
        .q(pcOut)
    );
    AddSub32bFlag pcIncrementAdder(
        .A(pcOut),
        .B(4),
        .Ci(1'b0),
        .Ctrl(1'b0),
        .S(pcPlusFour),
        .CF(), .OF(), .ZF(), .SF(), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );
    Rom32b instructionMemory(
        .rst(rst),
        .readAddress(pcOut),
        .data(instruction)
    );

    // __instruction decoding__
    LeftShift2b instructionShiftLeft2(
        .from({6'b0, instruction[25:0]}),
        .to(leftShiftedTargetAddress)
    );
    assign jumpAddress = {pcPlusFour[31:28], leftShiftedTargetAddress[27:0]};
    OpcodeControl control(
        .opcode(instruction[31:26]),
        .regDst(regDst),
        .jump(jump),
        .branch(branch),
        .branch_ne(branch_ne),
        .memRead(memRead),
        .memtoReg(memtoReg),
        .aluOp(aluOp),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite)
    );
    RegFile registers(
        .clk(clk),
        .rst(rst),
        .readRegister1(instruction[25:21]),
        .readRegister2(instruction[20:16]),
        .writeRegister(writeRegister),
        .writeData(registerWriteData),
        .writeEnable(regWrite),
        .readData1(registerReadData1),
        .readData2(registerReadData2)
    );
    SignExtend16To32 signExtend(
        .from(instruction[15:0]),
        .to(extendedImmediate)
    );

    // __executing__
    LeftShift2b immediateShiftLeft2(
        .from(extendedImmediate),
        .to(leftShiftedImmediate)
    );
    AddSub32bFlag pcOffsetAdder(
        .A(pcPlusFour),
        .B(leftShiftedImmediate),
        .Ci(1'b0),
        .Ctrl(1'b0),
        .S(offsetedPc),
        .CF(), .OF(), .ZF(), .SF(), .PF()  // 符号SF、进位CF、溢出OF、零标志ZF、奇偶PF
    );
    Mux2to1_32b aluSrcMux(
        .S(aluSrc),
        .I0(registerReadData2),
        .I1(extendedImmediate),
        .O(aluSourceB)
    );
    AluControl aluControl(
        .funct(instruction[5:0]),
        .aluOp(aluOp),
        .aluOpOut(aluOpOut)
    );
    Alu32b alu(
        .aluOp(aluOpOut),
        .leftOperand(registerReadData1),
        .rightOperand(aluSourceB),
        .aluResult(aluResult),
        .zero(isAluResultZero)
    );
    assign isBranch = isAluResultZero & branch | ~isAluResultZero & branch_ne;
    //  this is in execution section
    Mux2to1_5b regDstMux(
        .S(regDst),
        .I0(instruction[20:16]),
        .I1(instruction[15:11]),
        .O(writeRegister)
    );

    // __memory__
    Mux2to1_32b branchMux(
        .S(isBranch),
        .I0(pcPlusFour),
        .I1(offsetedPc),
        .O(branchAddress)
    );
    Ram32b dataMemory(
        .clk(clk),
        .rst(rst),
        .address(aluResult),
        .readEnable(memRead),
        .writeEnable(memWrite),
        .writeData(registerReadData2),
        .readData(memoryReadData)
    );

    // __write back__
    Mux2to1_32b jumpMux(
        .S(jump),
        .I0(branchAddress),
        .I1(jumpAddress),
        .O(nextPc)
    );
    Mux2to1_32b memtoRegMux(
        .S(memtoReg),
        .I0(aluResult),
        .I1(memoryReadData),
        .O(registerWriteData)
    );

endmodule // SingleCycleCpu

`endif
