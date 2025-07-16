module Cla64bit (
    input [63:0] A, B,  
    output [63:0] Sum,
    output overflow   
);
    wire [63:0] G, P;
    wire [64:0] C;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            and(G[i], A[i], B[i]); 
            xor(P[i], A[i], B[i]);
        end
    endgenerate

    assign C[0] = 1'b0;
    generate
        for (i = 0; i <= 63; i = i + 1) begin
            wire temp;
            and(temp, P[i], C[i]);
            or(C[i+1], G[i], temp); 
        end
    endgenerate

    xor (overflow,C[64],C[63]);

    generate
        for (i = 0; i < 64; i = i + 1) begin : sum_logic
            xor(Sum[i], P[i], C[i]);
        end
    endgenerate


endmodule



