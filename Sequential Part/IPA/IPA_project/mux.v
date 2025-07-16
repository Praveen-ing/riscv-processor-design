module mux (
    input wire [63:0] A, B,  
    input wire sel,          
    output wire [63:0] Y     
);
    assign Y = sel ? B : A; // Simple 64-bit MUX using conditional operator
endmodule