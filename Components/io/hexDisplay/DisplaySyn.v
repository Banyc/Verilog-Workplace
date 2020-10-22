`include "./Components/mux/Mux4to1.v"
`include "./Components/mux/Mux4to1b4.v"

// dynamic scanning
// time divded chances for each of the four Hex display

module DisplaySyn(
    input wire [1:0] Scan,
    input wire [15:0] Hexs,  // four numbers in 2 based
    input wire [3:0] Point,
    input wire [3:0] LES,
    output wire [3:0] HEX,  // selected number to display in 2 based
    output wire P,  // point for the selected hex display
    output wire LE,  // is selected hex display enabled
    output reg [3:0] AN  // whose turn for which hex display  // 0: enabled
);

    // for the 2 based indicators to the displaying number
    Mux4to1b4 mux4to1b4(.S(Scan), .I0(Hexs[3:0]), .I1(Hexs[7:4]), .I2(Hexs[11:8]), .I3(Hexs[15:12]), .O(HEX[3:0])); 

    // for the point
    Mux4to1 mux4to1_1(.S(Scan), .I0(Point[0]), .I1(Point[1]), .I2(Point[2]), .I3(Point[3]), .O(P)); 

    // for the custom "enable" of each Hex display
    Mux4to1 mux4to1_2(.S(Scan), .I0(LES[0]), .I1(LES[1]), .I2(LES[2]), .I3(LES[3]), .O(LE)); 

    // to scan each hex display
    reg [3:0] d2_4e_output;
    always @ * begin
        d2_4e_output[0] = 1'b0;
        d2_4e_output[1] = 1'b0;
        d2_4e_output[2] = 1'b0;
        d2_4e_output[3] = 1'b0;
        case (Scan)
            2'b00: 
                d2_4e_output[0] = 1'b1;
            2'b01: 
                d2_4e_output[1] = 1'b1;
            2'b10: 
                d2_4e_output[2] = 1'b1;
            2'b11: 
                d2_4e_output[3] = 1'b1;
        endcase
        AN = ~d2_4e_output;
    end

endmodule
