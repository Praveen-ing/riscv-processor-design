`timescale 1ns / 1ps

module ALU_tb;
    reg [63:0] a, b;
    reg [3:0] Alu_control;
    wire [63:0] result;
    wire zero, overflow;

    // Instantiate the ALU module
    ALU uut (
        .a(a),
        .b(b),
        .Alu_control(Alu_control),
        .result(result),
        .zero(zero),
        .overflow(overflow)
    );

    initial begin
        // Apply test vectors for subtraction
        $display("Testing ALU subtraction operation...");
        
        // Test Case 1: Subtraction of two numbers with no overflow
        a = 64'd100;
        b = 64'd50;
        Alu_control = 4'b0001;  // Subtraction operation
        #10;  
        $display("a = %d, b = %d, result = %0d, overflow = %b, zero = %b", 
                 a, b, $signed(result), overflow, zero);

        // Test Case 2: Subtraction with negative result (check sign extension)
        a = 64'd50;
        b = 64'd100;
        Alu_control = 4'b0001;  // Subtraction operation
        #10;  
        $display("a = %d, b = %d, result = %0d, overflow = %b, zero = %b", 
                 a, b, $signed(result), overflow, zero);

        // Test Case 3: Subtraction resulting in zero (for zero flag check)
        a = 64'd50;
        b = 64'd50;
        Alu_control = 4'b0001;  // Subtraction operation
        #10;  
        $display("a = %d, b = %d, result = %0d, overflow = %b, zero = %b", 
                 a, b, $signed(result), overflow, zero);

        // Test Case 4: Subtraction with large numbers
        a = 64'sd9223372036854775807;  // Max positive 64-bit signed int
        b = 64'sd1;
        Alu_control = 4'b0001;  // Subtraction operation
        #10;  
        $display("a = %0d, b = %0d, result = %0d, overflow = %b, zero = %b", 
                 a, b, $signed(result), overflow, zero);

        // Test Case 5: Subtraction causing overflow
        a = -64'sd9223372036854775808; // Most negative 64-bit signed number
        b = 64'sd1;
        Alu_control = 4'b0001;  // Subtraction operation
        #10;  
        $display("a = %0d, b = %0d, result = %0d, overflow = %b, zero = %b", 
                 a, b, $signed(result), overflow, zero);

        // End simulation
        $finish;
    end
endmodule
