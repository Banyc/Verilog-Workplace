module MyOr2b4(
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [3:0] C
);

    assign C[0] = A[0] | B[0];
    assign C[1] = A[1] | B[1];
    assign C[2] = A[2] | B[2];
    assign C[3] = A[3] | B[3];

endmodule
