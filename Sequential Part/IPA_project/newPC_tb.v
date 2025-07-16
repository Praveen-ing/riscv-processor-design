`timescale 1ns/1ps

module new_pc_tb;
    // Testbench signals
    reg clk;
    reg Branch;
    reg Zero;
    reg signed [63:0] imm; // Signed immediate
    reg [63:0] PC;
    wire [63:0] new_PC;

    // Instantiate the new_pc module
    new_pc uut (
        .clk(clk),
        .Branch(Branch),
        .Zero(Zero),
        .imm(imm),
        .PC(PC),
        .new_PC(new_PC)
    );

    // Clock generation (50% duty cycle)
    always #5 clk = ~clk;  

    // Test sequence
    initial begin
        // Initialize signals
        clk = 1; // Start high so first negedge happens at #5
        PC = 64'd0;        
        imm = 64'd8;       
        Branch = 0;
        Zero = 0;
        
        // Case 1: Normal Execution (PC + 4)
        #10; // Wait for a complete clock cycle
        PC = 64'd0;  
        Branch = 0;  
        Zero = 0;  
        #5; // Wait for negedge
        #1; // Small delay to let new_PC update
        $display("PC: %d, New PC: %d (Expected: 4)", PC, new_PC);

        // Case 2: Branch not taken (Branch = 1, Zero = 0)
        PC = 64'd4;
        Branch = 1;
        Zero = 0;
        #9; // Wait for next negedge (5+1+9=15)
        #1; // Small delay to let new_PC update
        $display("PC: %d, New PC: %d (Expected: 8)", PC, new_PC);

        // Case 3: Branch taken (Branch = 1, Zero = 1, Positive imm)
        PC = 64'd8;
        Branch = 1;
        Zero = 1;
        imm = 64'd16;  // Offset of 16
        #9; // Wait for next negedge
        #1; // Small delay to let new_PC update
        $display("PC: %d, New PC: %d (Expected: 8 + (16<<1) = 40)", PC, new_PC);

        // Case 4: Branch taken with negative immediate
        PC = 64'd40;
        Branch = 1;
        Zero = 1;
        imm = -64'd4;  // Offset of -4
        #9; // Wait for next negedge
        #1; // Small delay to let new_PC update
        $display("PC: %d, New PC: %d (Expected: 40 + (-4<<1) = 32)", PC, new_PC);

        // Case 5: Branch taken with large negative immediate
        PC = 64'd50;
        Branch = 1;
        Zero = 1;
        imm = -64'd10;  // Offset of -10
        #9; // Wait for next negedge
        #1; // Small delay to let new_PC update
        $display("PC: %d, New PC: %d (Expected: 50 + (-10<<1) = 30)", PC, new_PC);

        // End simulation
        #10;
        $finish;
    end
endmodule