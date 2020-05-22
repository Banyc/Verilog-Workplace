// reversible counter with 16 bits as output

module Counter16bRev(clk, s, cnt, Rc);
    input wire clk, s;
    output reg [15:0] cnt;
    output wire Rc;

    initial cnt = 0;

    assign Rc = (~s & (~|cnt)) | (s & (&cnt));
    always @ (posedge clk) begin
        if (s)
            cnt <= cnt + 1;
        else
            cnt <= cnt - 1;
    end
endmodule
