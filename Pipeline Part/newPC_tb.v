`timescale 1ns/1ps

module new_pc_tb;
    
    reg Branch;
    reg Zero;
    reg signed [63:0] imm; 
    reg [63:0] PC;
    wire [63:0] new_PC;

    
    new_pc uut (
        .Branch(Branch),
        .Zero(Zero),
        .imm(imm),
        .PC(PC),
        .new_PC(new_PC)
    );

    
    always #5 clk = ~clk;  

    
    initial begin
    
        clk = 1;
        PC = 64'd0;        
        imm = 64'd8;       
        Branch = 0;
        Zero = 0;
        
        // Case 1: Normal Execution (PC + 4)
        #10; 
        PC = 64'd0;  
        Branch = 0;  
        Zero = 0;  
        #1; 
        $display("Case 1 - PC: %d, New PC: %d (Expected: 4)", PC, new_PC);

        // Case 2: Branch not taken (Branch = 1, Zero = 0)
        #9;
        PC = 64'd4;
        Branch = 1;
        Zero = 0;
        #1; 
        $display("Case 2 - PC: %d, New PC: %d (Expected: 8)", PC, new_PC);

        // Case 3: Branch taken (Branch = 1, Zero = 1, Positive imm)
        #9; 
        PC = 64'd8;
        Branch = 1;
        Zero = 1;
        imm = 64'd16;  
        #1; 
        $display("Case 3 - PC: %d, New PC: %d (Expected: 8 + (16<<1) = 40)", PC, new_PC);

        // Case 4: Branch taken with negative immediate
        #9; 
        PC = 64'd40;
        Branch = 1;
        Zero = 1;
        imm = -64'd4;  
        #1; // 
        $display("Case 4 - PC: %d, New PC: %d (Expected: 40 + (-4<<1) = 32)", PC, new_PC);

        // Case 5: Branch taken with large negative immediate
        #9; 
        PC = 64'd50;
        Branch = 1;
        Zero = 1;
        imm = -64'd10;  
        #1; 
        $display("Case 5 - PC: %d, New PC: %d (Expected: 50 + (-10<<1) = 30)", PC, new_PC);

        
        #10;
        $finish;
    end

    
    initial begin
        $monitor("Time: %0t - PC: %0d, Branch: %0b, Zero: %0b, imm: %0d, new_PC: %0d", 
                 $time, PC, Branch, Zero, imm, new_PC);
    end
endmodule