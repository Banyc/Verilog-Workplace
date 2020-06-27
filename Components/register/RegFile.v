`ifndef __RegFile__
`define __RegFile__

module RegFile(
    clk,
    rst,
    readRegister1,
    readRegister2,
    writeRegister,
    writeData,
    writeEnable,

    readData1,
    readData2,

    // debug only
    readRegisterDebug,
    readDataDebug
);
    input wire clk;
    input wire rst;
    input wire [4:0] readRegister1;
    input wire [4:0] readRegister2;
    input wire [4:0] writeRegister;
    input wire [31:0] writeData;
    input wire writeEnable;
    output reg [31:0] readData1;
    output reg [31:0] readData2;

    // debug
    input wire [4:0] readRegisterDebug;
    output wire [31:0] readDataDebug;
    assign readDataDebug = memory[readRegisterDebug];

    reg [31:0] memory [31:1];

    always @(*) begin
        if (readRegister1 == 0) begin
            readData1 <= 0;
        end else begin
            readData1 <= memory[readRegister1];
        end
        if (readRegister2 == 0) begin
            readData2 <= 0;
        end else begin
            readData2 <= memory[readRegister2];
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory[1] <= 0;
            memory[2] <= 0;
            memory[3] <= 0;
            memory[4] <= 0;
            memory[5] <= 0;
            memory[6] <= 0;
            memory[7] <= 0;
            memory[8] <= 0;
            memory[9] <= 0;
            memory[10] <= 0;
            memory[11] <= 0;
            memory[12] <= 0;
            memory[13] <= 0;
            memory[14] <= 0;
            memory[15] <= 0;
            memory[16] <= 0;
            memory[17] <= 0;
            memory[18] <= 0;
            memory[19] <= 0;
            memory[20] <= 0;
            memory[21] <= 0;
            memory[22] <= 0;
            memory[23] <= 0;
            memory[24] <= 0;
            memory[25] <= 0;
            memory[26] <= 0;
            memory[27] <= 0;
            memory[28] <= 0;
            memory[29] <= 0;
            memory[30] <= 0;
            memory[31] <= 0;
        end else if (writeEnable && writeRegister != 0) begin
            memory[writeRegister] <= writeData;
        end
    end

endmodule // RegFile

`endif
