`timescale 1ns / 1ps

module ForwardingUnit_tb;

    // Inputs
    reg [4:0] Rs1, Rs2, Rd1, Rd2;
    reg Wb1, Wb2;

    // Outputs
    wire [1:0] ForwardA, ForwardB;

    // Instantiate the Forwarding Unit
    ForwardingUnit uut (
        .Rs1(Rs1),
        .Rs2(Rs2),
        .Rd1(Rd1),
        .Rd2(Rd2),
        .Wb1(Wb1),
        .Wb2(Wb2),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    initial begin
        // Monitor output values
        $monitor("Time=%0t | Rs1=%d Rs2=%d Rd1=%d Rd2=%d Wb1=%b Wb2=%b | ForwardA=%b ForwardB=%b", 
                  $time, Rs1, Rs2, Rd1, Rd2, Wb1, Wb2, ForwardA, ForwardB);

        // Test Case 1: No Forwarding
        Rs1 = 5'd1; Rs2 = 5'd2; Rd1 = 5'd3; Rd2 = 5'd4; Wb1 = 0; Wb2 = 0;
        #10;

        // Test Case 2: Forward from EX/MEM (Rd1 -> Rs1)
        Rs1 = 5'd3; Rs2 = 5'd2; Rd1 = 5'd3; Wb1 = 1; Wb2 = 0;
        #10;

        // Test Case 3: Forward from EX/MEM (Rd1 -> Rs2)
        Rs1 = 5'd1; Rs2 = 5'd3; Rd1 = 5'd3; Wb1 = 1; Wb2 = 0;
        #10;

        // Test Case 4: Forward from MEM/WB (Rd2 -> Rs1)
        Rs1 = 5'd4; Rs2 = 5'd2; Rd2 = 5'd4; Wb1 = 0; Wb2 = 1;
        #10;

        // Test Case 5: Forward from MEM/WB (Rd2 -> Rs2)
        Rs1 = 5'd1; Rs2 = 5'd4; Rd2 = 5'd4; Wb1 = 0; Wb2 = 1;
        #10;

        // Test Case 6: Both Forwarding (EX/MEM -> Rs1, MEM/WB -> Rs2)
        Rs1 = 5'd3; Rs2 = 5'd4; Rd1 = 5'd3; Rd2 = 5'd4; Wb1 = 1; Wb2 = 1;
        #10;

        $finish; // End simulation
    end

endmodule
