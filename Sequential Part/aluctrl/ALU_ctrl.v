module alu_control (
    input  wire [1:0]  ALUOp,    
    input  wire [3:0]  funct,   
    output reg  [3:0]  ALUCtrl   
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUCtrl = 4'b0010;  
        2'b01: ALUCtrl = 4'b0110;  
        2'b10: begin             
            case (funct)
                4'b1000: ALUCtrl = 4'b0110; 
                4'b0000: ALUCtrl = 4'b0010;
                4'b0111: ALUCtrl = 4'b0001; 
                4'b0110: ALUCtrl = 4'b0011;  
                default: ALUCtrl = 4'b0000;
            endcase
        end
        default: ALUCtrl = 4'b0000;
    endcase
end

endmodule
