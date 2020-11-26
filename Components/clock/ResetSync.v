// ResetSync.v
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_Resets.pdf

module ResetSync (
    rst_n,
    clk,
    asyncrst_n
);
    output rst_n;
    input clk, asyncrst_n;
    reg rst_n, rff1;
    
    always @(posedge clk or negedge asyncrst_n) begin
        if (!asyncrst_n) {rst_n,rff1} <= 2'b0;
        else {rst_n,rff1} <= {rff1,1'b1};
    end

endmodule
