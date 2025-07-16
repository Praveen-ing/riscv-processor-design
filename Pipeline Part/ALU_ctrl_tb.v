`timescale 1ns / 1ps

module alu_control_tb;
    
    reg [1:0] ALUOp;
    reg [3:0] funct;
    wire [3:0] ALUCtrl;
    
    alu_control uut (
        .ALUOp(ALUOp),
        .funct(funct),
        .ALUCtrl(ALUCtrl)
    );
    
    initial begin
        $monitor("Time = %0t | ALUOp = %b | funct = %b | ALUCtrl = %b", $time, ALUOp, funct, ALUCtrl);
        
        // Test Case 1: Load/Store Operations (LD, SD)
        ALUOp = 2'b00;
        funct = 4'b0000;
        #10;
        
        // Test Case 2: Branch (BEQ)
        ALUOp = 2'b01;
        funct = 4'b0000;
        #10;
        
        // Test Case 3: R-Type ADD
        ALUOp = 2'b10;
        funct = 4'b0000;
        #10;
        
        // Test Case 4: R-Type SUB
        ALUOp = 2'b10;
        funct = 4'b1000;
        #10;
        
        // Test Case 5: R-Type AND 
        ALUOp = 2'b10;
        funct = 4'b0111;
        #10;
        
        // Test Case 6: R-Type OR
        ALUOp = 2'b10;
        funct = 4'b0110;
        #10;
        
        // Test Case 7: Default case
        ALUOp = 2'b11;
        funct = 4'b1111;
        #10;
        
        $finish;
    end

endmodule