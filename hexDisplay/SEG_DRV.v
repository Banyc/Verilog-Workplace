`include "./hexDisplay/MC14495.v"
`include "./register/ShiftReg8b.v"

// drive 8 hexs on motherboard
module SEG_DRV(
    clk,
    start,
    en,
    num,
    point,
    finish,
    serial_clk,
    serial_seg
);
    input wire clk;
    input wire start;  // positive edge
    input wire [7:0] en;  // enable; 0: enabled
    input wire [31:0] num;
    input wire [7:0] point;  // 1: activated
    output wire finish;
    output wire serial_clk;  // clk for serial
    output wire serial_seg;  // serial output; 0: activated
    
    wire [63:0] seg;
    wire [63:0] shiftReg;
    reg old_start;
    reg [6:0] ttl;  // time to live
    reg should_shift;

    initial begin
        old_start = 1'b0;
        ttl = 0;
        should_shift = 1'b0;
    end

    assign finish = ~should_shift;
    assign serial_clk = ~clk & should_shift;  // reverse the clk

    // get parallel input  // from low end to big end for each module
    MC14495 m0(
        .LE(en[0]),
        .D0(num[0]),
        .D1(num[1]),
        .D2(num[2]),
        .D3(num[3]),
        .Point(point[0]),
        .a(seg[0]),
        .b(seg[1]),
        .c(seg[2]),
        .d(seg[3]),
        .e(seg[4]),
        .f(seg[5]),
        .g(seg[6]),
        .p(seg[7]));  // lowest end
    MC14495 m1(
        .LE(en[1]),
        .D0(num[4]),
        .D1(num[5]),
        .D2(num[6]),
        .D3(num[7]),
        .Point(point[1]),
        .a(seg[8]),
        .b(seg[9]),
        .c(seg[10]),
        .d(seg[11]),
        .e(seg[12]),
        .f(seg[13]),
        .g(seg[14]),
        .p(seg[15]));
    MC14495 m2(
        .LE(en[2]),
        .D0(num[8]),
        .D1(num[9]),
        .D2(num[10]),
        .D3(num[11]),
        .Point(point[2]),
        .a(seg[16]),
        .b(seg[17]),
        .c(seg[18]),
        .d(seg[19]),
        .e(seg[20]),
        .f(seg[21]),
        .g(seg[22]),
        .p(seg[23]));
    MC14495 m3(
        .LE(en[3]),
        .D0(num[12]),
        .D1(num[13]),
        .D2(num[14]),
        .D3(num[15]),
        .Point(point[3]),
        .a(seg[24]),
        .b(seg[25]),
        .c(seg[26]),
        .d(seg[27]),
        .e(seg[28]),
        .f(seg[29]),
        .g(seg[30]),
        .p(seg[31]));
    MC14495 m4(
        .LE(en[4]),
        .D0(num[16]),
        .D1(num[17]),
        .D2(num[18]),
        .D3(num[19]),
        .Point(point[4]),
        .a(seg[32]),
        .b(seg[33]),
        .c(seg[34]),
        .d(seg[35]),
        .e(seg[36]),
        .f(seg[37]),
        .g(seg[38]),
        .p(seg[39]));
    MC14495 m5(
        .LE(en[5]),
        .D0(num[20]),
        .D1(num[21]),
        .D2(num[22]),
        .D3(num[23]),
        .Point(point[5]),
        .a(seg[40]),
        .b(seg[41]),
        .c(seg[42]),
        .d(seg[43]),
        .e(seg[44]),
        .f(seg[45]),
        .g(seg[46]),
        .p(seg[47]));
    MC14495 m6(
        .LE(en[6]),
        .D0(num[24]),
        .D1(num[25]),
        .D2(num[26]),
        .D3(num[27]),
        .Point(point[6]),
        .a(seg[48]),
        .b(seg[49]),
        .c(seg[50]),
        .d(seg[51]),
        .e(seg[52]),
        .f(seg[53]),
        .g(seg[54]),
        .p(seg[55]));
    MC14495 m7(
        .LE(en[7]),
        .D0(num[28]),
        .D1(num[29]),
        .D2(num[30]),
        .D3(num[31]),
        .Point(point[7]),
        .a(seg[56]),
        .b(seg[57]),
        .c(seg[58]),
        .d(seg[59]),
        .e(seg[60]),
        .f(seg[61]),
        .g(seg[62]),
        .p(seg[63]));  // highest end

    // parallel signal to serial
    ShiftReg8b s7(clk, ~should_shift, shiftReg[0], 
        {
            seg[0],
            seg[1],
            seg[2],
            seg[3],
            seg[4],
            seg[5],
            seg[6],
            seg[7]
        }, shiftReg[63:56]);  // highest part
    ShiftReg8b s6(clk, ~should_shift, shiftReg[56], 
        {
            seg[8],
            seg[9],
            seg[10],
            seg[11],
            seg[12],
            seg[13],
            seg[14],
            seg[15]
        }, shiftReg[55:48]);
    ShiftReg8b s5(clk, ~should_shift, shiftReg[48], 
        {
            seg[16],
            seg[17],
            seg[18],
            seg[19],
            seg[20],
            seg[21],
            seg[22],
            seg[23]
        }, shiftReg[47:40]);
    ShiftReg8b s4(clk, ~should_shift, shiftReg[40], 
        {
            seg[24],
            seg[25],
            seg[26],
            seg[27],
            seg[28],
            seg[29],
            seg[30],
            seg[31]
        }, shiftReg[39:32]);
    ShiftReg8b s3(clk, ~should_shift, shiftReg[32], 
        {
            seg[32],
            seg[33],
            seg[34],
            seg[35],
            seg[36],
            seg[37],
            seg[38],
            seg[39]
        }, shiftReg[31:24]);
    ShiftReg8b s2(clk, ~should_shift, shiftReg[24], 
        {
            seg[40],
            seg[41],
            seg[42],
            seg[43],
            seg[44],
            seg[45],
            seg[46],
            seg[47]
        }, shiftReg[23:16]);
    ShiftReg8b s1(clk, ~should_shift, shiftReg[16], 
        {
            seg[48],
            seg[49],
            seg[50],
            seg[51],
            seg[52],
            seg[53],
            seg[54],
            seg[55]
        }, shiftReg[15:8]);
    ShiftReg8b s0(clk, ~should_shift, shiftReg[8], 
        {
            seg[56],
            seg[57],
            seg[58],
            seg[59],
            seg[60],
            seg[61],
            seg[62],
            seg[63]
        }, shiftReg[7:0]);  // lowest part
    

    assign serial_seg = shiftReg[0];

    // second round
    always @(posedge clk) begin
        old_start <= start;
    end

    always @(posedge clk) begin
        // first round
        // IF positive edge of start AND no shifting is running (i.e. finished)
        if ((old_start == 1'b0) && (start == 1'b1) && (ttl == 0)) begin
            ttl <= 64;  // there are total 64 segments to shift
        end
        // second round
        if (ttl > 0) begin
            should_shift <= 1'b1;
            ttl <= ttl - 1;
        end else begin
            should_shift <= 1'b0;
        end
    end

endmodule // SEG_DRV
