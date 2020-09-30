`ifndef __Rom32b__
`define __Rom32b__


// word size := 32 bits
// address size := 32 bits
// 最小寻址单位
// minimal address identification := 8 bits == 1 byte
module Rom32b(
    rst,
    readAddress,
    data
);
    input wire rst;
    input wire [31:0] readAddress;
    output wire [31:0] data;

    // replace by ip core wrapper here
    // reg [7:0] memory [32'h0100000: 32'h0101000];
    reg [7:0] memory [32'h0010000: 32'h0000000];

    assign data = {
        memory[readAddress],
        memory[readAddress + 1],
        memory[readAddress + 2],
        memory[readAddress + 3]
    };

    always @(posedge rst) begin
        if (rst) begin
            // big endian
            $readmemh("./Components/memory/rom.txt", memory);
        end
    end

endmodule // Rom32b

`endif
