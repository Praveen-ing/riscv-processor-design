`timescale 1ns/1ps

module ALU_tb;
    reg [63:0] a, b;
    reg [3:0] Alu_control;
    wire [63:0] result;
    wire zero, overflow;

    ALU uut (
        .a(a),
        .b(b),
        .Alu_control(Alu_control),
        .result(result),
        .zero(zero),
        .overflow(overflow)
    );

    
    task display_result;
        input [63:0] a, b;
        input [3:0] control;
        input [63:0] expected_result;
        input expected_zero, expected_overflow;
        
        begin
            $display("Test: a=%d, b=%d, Control=%b | Result=%d, Zero=%b, Overflow=%b | Expected: Result=%d, Zero=%b, Overflow=%b",
                     a, b, control, result, zero, overflow, expected_result, expected_zero, expected_overflow);
        end
    endtask

    initial begin
        

        $display("\nStarting ALU Testbench...\n");

        
        a = 64'd10; b = 64'd20; Alu_control = 4'b0000; #10;
        display_result(a, b, Alu_control, 64'd30, 1'b0, 1'b0); // Expected: 30, zero=0, overflow=0
        
        
        a = 64'h7FFFFFFFFFFFFFFF; b = 64'd1; Alu_control = 4'b0000; #10;
        display_result(a, b, Alu_control, 64'h8000000000000000, 1'b0, 1'b1); // Expected: overflow=1
        
        
        a = 64'd30; b = 64'd10; Alu_control = 4'b0001; #10;
        display_result(a, b, Alu_control, 64'd20, 1'b0, 1'b0); // Expected: 20, zero=0, overflow=0

        // Test zero flag (BEQ condition)
        a = 64'd50; b = 64'd50; Alu_control = 4'b0001; #10;
        display_result(a, b, Alu_control, 64'd0, 1'b1, 1'b0); // Expected: zero=1

        // Test subtraction overflow (negative result)
        a = 64'h8000000000000000; b = 64'd1; Alu_control = 4'b0001; #10;
        display_result(a, b, Alu_control, 64'h7FFFFFFFFFFFFFFF, 1'b0, 1'b1); // Expected: overflow=1
        
        // -------- TEST AND OPERATION --------
        a = 64'b1010; b = 64'b1100; Alu_control = 4'b0010; #10;
        display_result(a, b, Alu_control, 64'b1000, 1'b0, 1'b0); // Expected: 1000, zero=0, overflow=0
        
        // -------- TEST OR OPERATION --------
        a = 64'b1010; b = 64'b1100; Alu_control = 4'b0011; #10;
        display_result(a, b, Alu_control, 64'b1110, 1'b0, 1'b0); // Expected: 1110, zero=0, overflow=0

        // -------- TEST EDGE CASES --------
        // Case: Both inputs zero
        a = 64'd0; b = 64'd0; Alu_control = 4'b0000; #10;
        display_result(a, b, Alu_control, 64'd0, 1'b1, 1'b0); // Expected: 0, zero=1
        
        // Case: Large numbers addition
        a = 64'hFFFFFFFFFFFFFFFF; b = 64'd1; Alu_control = 4'b0000; #10;
        display_result(a, b, Alu_control, 64'd0, 1'b1, 1'b1); // Expected: overflow

        // Case: Large numbers subtraction
        a = 64'hFFFFFFFFFFFFFFFF; b = 64'h7FFFFFFFFFFFFFFF; Alu_control = 4'b0001; #10;
        display_result(a, b, Alu_control, 64'h8000000000000000, 1'b0, 1'b1); // Expected: overflow

        $display("\nALU Testbench Completed.\n");

        // End simulation
        #10;
        $finish;
    end
endmodule