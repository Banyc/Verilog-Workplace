`include "./Components/flipFlop/RisingEdge_DFlipFlop.v"

module Counter4b (
// Inputs
    clk,

// Output
    Qb, Qc, Qd, Qa, Rc
);
    // Inputs
    input wire clk;
    // Output
    output wire Qa;
    output wire Qb;
    output wire Qc;
    output wire Qd;
    output wire Rc;

    wire d2;
    wire d3;
    wire d4;

    RisingEdge_DFlipFlop fd1(.D(~Qa), .clk(clk), .Q(Qa));

    assign d2 = ~(Qa ^ ~Qb);
    RisingEdge_DFlipFlop fd2(.D(d2), .clk(clk), .Q(Qb));

    assign d3 = ~(~(~Qa | ~Qb) ^ ~Qc);
    RisingEdge_DFlipFlop fd3(.D(d3), .clk(clk), .Q(Qc));

    assign d4 = ~(~(~Qa | ~Qb | ~Qc) ^ ~Qd);
    RisingEdge_DFlipFlop fd4(.D(d4), .clk(clk), .Q(Qd));

    assign Rc = ~(~Qa | ~Qb | ~Qc | ~Qd);

endmodule
