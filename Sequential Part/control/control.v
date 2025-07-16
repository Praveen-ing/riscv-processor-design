module control_unit (
    input  wire [6:0] opcode,  
    output reg Branch,   
    output reg MemRead,  
    output reg MemtoReg, 
    output reg [1:0] ALUOp,    
    output reg MemWrite, 
    output reg ALUSrc,   
    output reg RegWrite  
);

    always @(*) begin
        
        Branch   = 0;
        MemRead  = 0;
        MemtoReg = 0;
        ALUOp    = 2'b00;
        MemWrite = 0;
        ALUSrc   = 0;
        RegWrite = 0;

        case (opcode)
            7'b0110011: begin  // R-type (ADD, SUB, AND, OR, etc.)
                RegWrite = 1;
                ALUSrc   = 0; 
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end

            7'b0000011: begin  //I-type Load (LW - Load Word)
                RegWrite = 1;
                ALUSrc   = 1; 
                MemtoReg = 1; 
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end


            7'b0100011: begin  // S-type Store (SW - Store Word)
                RegWrite = 0;
                ALUSrc   = 1; 
                MemtoReg = 0;  
                MemRead  = 0;
                MemWrite = 1;  
                Branch   = 0;
                ALUOp    = 2'b00;
            end

            7'b1100011: begin  // SB-type Branch (BEQ - Branch if Equal)
                RegWrite = 0;
                ALUSrc   = 0;  
                MemtoReg = 0;  
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1; 
                ALUOp    = 2'b01;
            end

            default: begin 
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end
        endcase
    end
endmodule
