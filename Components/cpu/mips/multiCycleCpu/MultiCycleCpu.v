`ifndef __MultiCycleCpu__
`define __MultiCycleCpu__

`include "./Components/shift/LeftShift2b.v"
`include "./Components/shift/SignExtend16To32.v"
`include "./Components/shift/ShiftLeft16b.v"
`include "./Components/register/RegFile.v"
`include "./Components/register/Pc.v"
`include "./Components/register/Register32b.v"
`include "./Components/mux/Mux2to1_5b.v"
`include "./Components/mux/Mux2to1_32b.v"
`include "./Components/mux/Mux4to1_32b.v"
`include "./Components/memory/Ram32b.v"
`include "./Components/adder/Alu32b.v"
`include "./Components/cpu/mips/multiCycleCpu/MultiCycleControl.v"
`include "./Components/cpu/AluControl.v"

module MultiCycleCpu(
    clk,
    rst,
    // ports for Ram32b
    memoryReadDataAddress,
    memRead,
    memWrite,
    registerReadData2,
    freshMemoryReadData,
    // ports for RegFile
    readRegister1,
    readRegister2,
    writeRegister,
    registerWriteData,
    regWrite,
    freshRegisterReadData1,
    freshRegisterReadData2,
    // custom outputs
    instruction,
    pcOut,
    state
);
    input wire clk;
    input wire rst;

    output wire [31:0] instruction;
    output wire [4:0] readRegister1;
    output wire [4:0] readRegister2;
    output wire [31:0] pcOut;
    output wire [3:0] state;

    assign readRegister1 = instruction[25:21];
    assign readRegister2 = instruction[20:16];

    // instruction fetching
    // wire [31:0] instruction;
    // wire [31:0] pcOut;
    wire [31:0] memoryReadData;
    // instruction decoding
    wire [1:0] pcWriteCond;
    wire pcWrite;
    wire iorD;
    output wire memRead;
    output wire memWrite;
    wire memToReg;
    wire irWrite;
    wire [1:0] pcSource;
    wire [1:0] aluOp;
    wire [1:0] aluSrcB;
    wire aluSrcA;
    output wire regWrite;
    wire regDst;
    input wire [31:0] freshRegisterReadData1;
    input wire [31:0] freshRegisterReadData2;
    wire [31:0] registerReadData1;
    output wire [31:0] registerReadData2;
    wire [31:0] leftShiftedTargetAddress;
    wire [31:0] jumpAddress;
    wire [31:0] extendedImmediate;
    wire [31:0] upperImmediate;
    // executing
    wire [31:0] leftShiftedImmediate;
    wire [31:0] aluSourceAOperand;
    wire [31:0] aluSourceBOperand;
    wire [3:0] aluOpOut;
    wire [31:0] freshAluOut;
    wire [31:0] aluResult;
    wire isAluResultZero;
    wire isBranch;
    wire [4:0] secondaryRegister;  // from rt or rd
    output wire [4:0] writeRegister;  // from secondaryRegister or $ra
    // memory
    output wire [31:0] memoryReadDataAddress;
    input wire [31:0] freshMemoryReadData;
    // write back
    wire [31:0] branchAddress;
    wire [31:0] branchJumpAddress;
    wire [31:0] nextPc;
    wire [31:0] memtoRegMuxOutData;
    wire [31:0] jumpAndLinkForRegisterDataMuxOutData;
    output wire [31:0] registerWriteData;

    // __instruction fetching__
    Pc pc(
        .clk(clk),
        .rst(rst),
        .enableWrite((isAluResultZero & pcWriteCond[0]) | (~isAluResultZero & pcWriteCond[1]) | pcWrite),
        .d(nextPc),
        .q(pcOut)
    );
    Register32b instructionRegister(
        .clk(clk),
        .enableWrite(irWrite),
        .d(freshMemoryReadData),
        .q(instruction)
    );
    Register32b memoryDataRegister(
        .clk(clk),
        .enableWrite(1'b1),
        .d(freshMemoryReadData),
        .q(memoryReadData)
    );

    // __instruction decoding__
    LeftShift2b instructionShiftLeft2(
        .from({6'b0, instruction[25:0]}),
        .to(leftShiftedTargetAddress)
    );
    // {PC[31:28], target << 2}
    assign jumpAddress = {pcOut[31:28], leftShiftedTargetAddress[27:0]};
    MultiCycleControl control(
        .clk(clk),
        .rst(rst),
        .opcode(instruction[31:26]),
        .funct(instruction[5:0]),
        .pcWriteCond(pcWriteCond),
        .pcWrite(pcWrite),
        .iorD(iorD),
        .memRead(memRead),
        .memWrite(memWrite),
        .memToReg(memToReg),
        .irWrite(irWrite),
        .pcSource(pcSource),
        .aluOp(aluOp),
        .aluSrcB(aluSrcB),
        .aluSrcA(aluSrcA),
        .regWrite(regWrite),
        .regDst(regDst),

        // custom
        .state(state)
    );
    Register32b aRegister(
        .clk(clk),
        .enableWrite(1'b1),
        .d(freshRegisterReadData1),
        .q(registerReadData1)
    );
    Register32b bRegister(
        .clk(clk),
        .enableWrite(1'b1),
        .d(freshRegisterReadData2),
        .q(registerReadData2)
    );
    // PC + (signExtend(instruction[15:0]) << 2)
        SignExtend16To32 signExtend(
            .from(instruction[15:0]),
            .to(extendedImmediate)
        );
        LeftShift2b immediateShiftLeft2(
            .from(extendedImmediate),
            .to(leftShiftedImmediate)  // {signs, immediate << 2}
        );
    ShiftLeftN ShiftLeft16b(
        .from(extendedImmediate),
        .to(upperImmediate)
    );

    // __executing__
    Mux2to1_32b aluSrcAMux(
        .S(aluSrcA),
        .I0(pcOut),
        .I1(registerReadData1),
        .O(aluSourceAOperand)
    );
    Mux4to1_32b aluSrcBMux(
        .S(aluSrcB),
        .I0(registerReadData2),
        .I1(32'h4),
        .I2(extendedImmediate),
        .I3(leftShiftedImmediate),
        .O(aluSourceBOperand)
    );  // source B of ALU
    AluControl aluControl(
        .opcode(instruction[31:26]),
        .funct(instruction[5:0]),
        .aluOp(aluOp),
        .aluOpOut(aluOpOut)
    );
    Alu32b alu(
        .aluOp(aluOpOut),
        .leftOperand(aluSourceAOperand),
        .rightOperand(aluSourceBOperand),
        .aluResult(freshAluOut),
        .zero(isAluResultZero)
    );
    Register32b aluOutRegister(
        .clk(clk),
        .enableWrite(1'b1),
        .d(freshAluOut),
        .q(aluResult)
    );
    //  this is in execution section
    Mux2to1_5b regDstMux(
        .S(regDst),
        .I0(instruction[20:16]),
        .I1(instruction[15:11]),
        .O(writeRegister)
    );

    // __memory__
    Mux2to1_32b iorDMux(
        .S(iorD),
        .I0(pcOut),
        .I1(aluResult),
        .O(memoryReadDataAddress)
    );

    // __write back__
        // PC-related
        Mux4to1_32b pcSourceMux(
            .S(pcSource),
            .I0(freshAluOut),
            .I1(aluResult),
            .I2(jumpAddress),
            .I3(32'b0),
            .O(nextPc)
        );
        // related to write data for registers
        Mux2to1_32b memToRegMux(
            .S(memToReg),
            .I0(aluResult),
            .I1(memoryReadData),
            .O(registerWriteData)
        );

endmodule

`endif
