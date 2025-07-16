`timescale 1ns/1ps

module control_unit_tb;

    reg [6:0] opcode;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;
    

    control_unit uut (
        .opcode(opcode),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    initial begin
        
        $monitor("Time=%0t | Opcode=%b | Branch=%b | MemRead=%b | MemtoReg=%b | ALUOp=%b | MemWrite=%b | ALUSrc=%b | RegWrite=%b", 
                 $time, opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
        
        
        opcode = 7'b0110011; #10;  // R-type
        opcode = 7'b0000011; #10;  // Load
        opcode = 7'b0100011; #10;  // Store
        opcode = 7'b1100011; #10;  // Branch 
        opcode = 7'b1111111; #10;  // Default
        
  
        $finish;
    end
endmodule
