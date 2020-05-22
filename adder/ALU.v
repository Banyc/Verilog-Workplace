`include "./adder/AddSub4b.v"
`include "./adder/MyAnd2b4.v"
`include "./adder/MyOr2b4.v"
`include "./mux/Mux4to1b4.v"
`include "./mux/Mux4to1.v"

// ALU m5(.S(SW2), .A(num[3:0]), .B(num[7:4]), .C(C), .Co(Co));

module ALU(
    input wire [1:0] S,  // [mode] 0: addup; 1: subtract; 2: and; 3: or;
    input wire [3:0] A,  // unsigned
    input wire [3:0] B,  // unsigned
    output wire [3:0] C,
    output wire Co
);

    wire [3:0] aS4b_S;
    wire aS4b_Co;
    wire [3:0] mA2b4_C;
    wire [3:0] mO2b4_C;

    wire [3:0] mux4to1b4_O;
    wire mux4to1_O;

    AddSub4b addSub4b(.A(A), .B(B), .Ci(1'b0), .Ctrl(S[0]), .S(aS4b_S), .Co(aS4b_Co));
    MyAnd2b4 myAnd2b4(.A(A), .B(B), .C(mA2b4_C));
    MyOr2b4 myOr2b4(.A(A), .B(B), .C(mO2b4_C));

    Mux4to1b4 mux4to1b4(.S(S), .I0(aS4b_S), .I1(aS4b_S), .I2(mA2b4_C), .I3(mO2b4_C), .O(mux4to1b4_O));
    Mux4to1 mux4to1(.S(S), .I0(aS4b_Co), .I1(aS4b_Co), .I2(1'b0), .I3(1'b0), .O(mux4to1_O));

    assign C = mux4to1b4_O;
    assign Co = mux4to1_O;

endmodule
