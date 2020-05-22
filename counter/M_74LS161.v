`ifndef __M_74LS161
`define __M_74LS161

module M_74LS161(
    CR, LD, CT_P, CT_T, CP, D, Q, CO
);
    input wire CR;  // 0: async reset to zeros
    input wire LD;  // 0: sync load
    input wire CT_P;  // enable
    input wire CT_T;  // enable
    input wire CP;  // positive edge
    input wire [3:0] D;
    output reg [3:0] Q = 4'b0;
    output wire CO;

    assign CO = &Q & CT_T;  // reset indicator

    always @(posedge CP or negedge CR) begin
        if (CR == 0) begin
            Q <= 0;
        end
        else if (LD == 0) begin
            Q <= D;
        end
        else if (CT_P == 0 || CT_T == 0) begin
            Q <= Q;
        end
        else begin  // CT_P && CT_T
            if (Q == 4'hF) begin
                Q <= 0;
            end
            else begin
                Q <= Q + 1;
            end
        end
    end

endmodule // M_74LS161
`endif
