`ifndef __Ram32b__
`define __Ram32b__


// posedge write; negedge read
// word size := 32 bits
// address size := 32 bits
// 最小寻址单位
// minimal address identification := 8 bits == 1 byte
module Ram32b(
    clk,
    rst,
    address,
    readEnable,
    writeEnable,
    writeData,
    readData
);
    input wire clk;
    input wire rst;
    input wire [31:0] address;
    input wire readEnable;
    input wire writeEnable;
    input wire [31:0] writeData;
    output reg [31:0] readData;

    // replace by ip core wrapper here
    // reg [7:0] memory [32'h0100000: 32'h0101000];
    reg [7:0] memory [32'h00000100: 32'h00000000];
    // reg [7:0] memory [32'h40000000: 32'h00000000];

    always @(posedge rst) begin
        if (rst) begin
            // big endian
            $readmemh("./Components/memory/ram.txt", memory);
        end
    end
    always @(posedge clk) begin
        if (writeEnable) begin
            memory[address] <= writeData[31:24];
            memory[address + 1] <= writeData[23:16];
            memory[address + 2] <= writeData[15:8];
            memory[address + 3] <= writeData[7:0];
        end
    end
    always @(negedge clk) begin
        if (readEnable) begin
            readData <= {
                memory[address],
                memory[address + 1],
                memory[address + 2],
                memory[address + 3]
            };
        end
    end
endmodule // Ram32b

`endif
