module mux3to1 (
    input wire [63:0] A,   // Input 0
    input wire [63:0] B,   // Input 1
    input wire [63:0] C,   // Input 2
    input wire [1:0] sel,    // 2-bit Select Line (00, 01, 10)
    output reg [63:0] out    // Output Register
);

always @(*) begin
    case (sel)
        2'b00: out = A;  // Select input 0
        2'b01: out = B;  // Select input 1
        2'b10: out = C;  // Select input 2
        default: out = 63'b0;  // Default case (shouldn't happen)
    endcase
end

endmodule
