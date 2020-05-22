// a hex display
// outputs links to common anode

// __Sample of use__
// MC14495 base_display(
//         .LE(is_disabled),
//         .D0(num_to_display[0]),
//         .D1(num_to_display[1]),
//         .D2(num_to_display[2]),
//         .D3(num_to_display[3]),
//         .Point(point_to_display),
//         .a(segment[0]),
//         .b(segment[1]),
//         .c(segment[2]),
//         .d(segment[3]),
//         .e(segment[4]),
//         .f(segment[5]),
//         .g(segment[6]),
//         .p(segment[7])
//         );

`ifndef __MC14495
`define __MC14495

module MC14495(
    input wire LE,  // 0: enabled
    input wire D0,  // 1st digit
    input wire D1,  // 2nd digit
    input wire D2,  // 3rd digit
    input wire D3,  // 4th digit
    input wire Point,  // 1: activated
    output reg a, b, c, d, e, f, g,  // 0: activated
    output wire p  // 0: activated
);

    assign p = ~Point;

    reg [6:0] positiveHex;
    always @ * begin
        case ({D3, D2, D1, D0})
            4'b0000 :      	//Hexadecimal 0
                positiveHex = 7'b1111110;
            4'b0001 :    		//Hexadecimal 1
                positiveHex = 7'b0110000  ;
            4'b0010 :  		// Hexadecimal 2
                positiveHex = 7'b1101101 ; 
            4'b0011 : 		// Hexadecimal 3
                positiveHex = 7'b1111001 ;
            4'b0100 :		// Hexadecimal 4
                positiveHex = 7'b0110011 ;
            4'b0101 :		// Hexadecimal 5
                positiveHex = 7'b1011011 ;  
            4'b0110 :		// Hexadecimal 6
                positiveHex = 7'b1011111 ;
            4'b0111 :		// Hexadecimal 7
                positiveHex = 7'b1110000;
            4'b1000 :     		 //Hexadecimal 8
                positiveHex = 7'b1111111;
            4'b1001 :    		//Hexadecimal 9
                positiveHex = 7'b1111011 ;
            4'b1010 :  		// Hexadecimal A
                positiveHex = 7'b1110111 ; 
            4'b1011 : 		// Hexadecimal B
                positiveHex = 7'b0011111;
            4'b1100 :		// Hexadecimal C
                positiveHex = 7'b1001110 ;
            4'b1101 :		// Hexadecimal D
                positiveHex = 7'b0111101 ;
            4'b1110 :		// Hexadecimal E
                positiveHex = 7'b1001111 ;
            4'b1111 :		// Hexadecimal F
                positiveHex = 7'b1000111 ;
        endcase
        if (LE == 1'b1) begin
            positiveHex = 7'b0000000;
        end
        {a, b, c, d, e, f, g} = ~positiveHex;
    end

endmodule
`endif
