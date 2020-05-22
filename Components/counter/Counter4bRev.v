// reversible counter with 4 bits as output

module Counter4bRev(clk, s, cnt, Rc);
    input wire clk, s;  // s = 0: decrement; s = 1: increment
    output reg [3:0] cnt;
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
