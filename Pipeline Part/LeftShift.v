module LeftShift (
    input  [63:0] A,    
    input  [5:0] B,   
    output reg [63:0] Result 
);
    integer i; 

    always @(*) begin
        Result = A; 
        for (i = 0; i < B; i = i + 1) begin
            Result = {Result[62:0], 1'b0};
        end
    end

endmodule
