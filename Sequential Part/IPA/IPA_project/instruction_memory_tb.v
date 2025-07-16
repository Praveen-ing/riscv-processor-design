`timescale 1ns / 1ps

module tb_instruction_memory;

    reg [63:0] PC;           
    reg clk;                 
    wire [31:0] instruction;  

    instruction_memory uut (
        .PC(PC),
        .clk(clk),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin
    
        clk = 0;
        PC = 0;

        
        #10 PC = 4; 
        #10 PC = 1; 
        
        #20 $finish; 
    end

    
    initial begin
        $monitor("Time = %0t | PC = %0d | Instruction = %h", $time, PC, instruction);
    end

endmodule