module new_pc (
    input wire clk,              
    input wire Branch,           
    input wire Zero,            
    input wire signed [63:0] imm, 
    input wire [63:0] PC,        
    output reg [63:0] new_PC     
);

    wire [63:0] pc_plus_4, branch_target;
    wire branch_taken;

    assign pc_plus_4 = PC + 64'd4;

    assign branch_target = PC + (imm << 1); 

    
    assign branch_taken = Branch & Zero;

    
    always @(negedge clk) begin
      new_PC <= branch_taken ? branch_target : pc_plus_4;
    end

endmodule
