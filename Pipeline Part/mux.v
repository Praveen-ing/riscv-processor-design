module mux 
(
    input wire signed [63:0] A, 
    input wire signed [63:0] B,  
    input wire sel,          
    output wire signed [63:0] Y     
);
    assign Y = sel ? B : A; 
endmodule