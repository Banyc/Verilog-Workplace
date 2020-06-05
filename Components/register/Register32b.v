`ifndef __Register32b__
`define __Register32b__

module Register32b(
    clk,
    enableWrite,
    d,
    q
);
    input wire clk;
    input wire enableWrite;
    input wire [31:0] d;
    output reg [31:0] q;

    always @(posedge clk) begin
        if (enableWrite)
            q <= d;
    end

endmodule // Register32b

`endif
