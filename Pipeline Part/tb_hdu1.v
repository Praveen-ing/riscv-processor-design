`timescale 1ns / 1ps

module HazardDetectionUnit_tb;

    // Testbench signals
    reg ID_EX_MemRead;
    reg [4:0] ID_EX_RegisterRd;
    reg [4:0] IF_ID_RegisterRs1;
    reg [4:0] IF_ID_RegisterRs2;
    reg BranchTaken;

    wire Stall;
    wire PCWrite;
    wire IF_ID_Write;
    wire Flush;

    // Instantiate the Hazard Detection Unit
    HazardDetectionUnit uut (
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_RegisterRd(ID_EX_RegisterRd),
        .IF_ID_RegisterRs1(IF_ID_RegisterRs1),
        .IF_ID_RegisterRs2(IF_ID_RegisterRs2),
        .BranchTaken(BranchTaken),
        .Stall(Stall),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .Flush(Flush)
    );

    // Test sequence
    initial begin
        // Initialize inputs
        ID_EX_MemRead = 0;
        ID_EX_RegisterRd = 5'b00000;
        IF_ID_RegisterRs1 = 5'b00000;
        IF_ID_RegisterRs2 = 5'b00000;
        BranchTaken = 0;

        #10; // Small delay

        // Test Case 1: No hazard (all defaults)
        $display("Test Case 1: No hazard");
        #10;
        $display("Stall = %b, PCWrite = %b, IF_ID_Write = %b, Flush = %b", Stall, PCWrite, IF_ID_Write, Flush);

        // Test Case 2: Load-use hazard (EX stage is loading to a register used in ID stage)
        ID_EX_MemRead = 1;
        ID_EX_RegisterRd = 5'b00010; // EX stage writing to x2
        IF_ID_RegisterRs1 = 5'b00010; // ID stage using x2
        IF_ID_RegisterRs2 = 5'b00000;
        $display("Test Case 2: Load-use hazard (EX writing to x2, ID using x2)");
        #10;
        $display("Stall = %b, PCWrite = %b, IF_ID_Write = %b, Flush = %b", Stall, PCWrite, IF_ID_Write, Flush);

        // Test Case 3: Load-use hazard (EX stage writing to Rs2 instead of Rs1)
        IF_ID_RegisterRs1 = 5'b00000; // Not matching
        IF_ID_RegisterRs2 = 5'b00010; // Now matching Rs2
        $display("Test Case 3: Load-use hazard (EX writing to x2, ID using x2 as Rs2)");
        #10;
        $display("Stall = %b, PCWrite = %b, IF_ID_Write = %b, Flush = %b", Stall, PCWrite, IF_ID_Write, Flush);

        // Test Case 4: No Load-use hazard (Different registers)
        ID_EX_RegisterRd = 5'b00100;
        IF_ID_RegisterRs1 = 5'b00010;
        IF_ID_RegisterRs2 = 5'b00011;
        $display("Test Case 4: No load-use hazard (Different registers)");
        #10;
        $display("Stall = %b, PCWrite = %b, IF_ID_Write = %b, Flush = %b", Stall, PCWrite, IF_ID_Write, Flush);

        // Test Case 5: Branch taken (Control Hazard)
        ID_EX_MemRead = 0;
        BranchTaken = 1;
        $display("Test Case 5: Branch Taken (Flush should be 1)");
        #10;
        $display("Stall = %b, PCWrite = %b, IF_ID_Write = %b, Flush = %b", Stall, PCWrite, IF_ID_Write, Flush);

        // Test Case 6: Branch not taken (No control hazard)
        BranchTaken = 0;
        $display("Test Case 6: Branch Not Taken (Normal Execution)");
        #10;
        $display("Stall = %b, PCWrite = %b, IF_ID_Write = %b, Flush = %b", Stall, PCWrite, IF_ID_Write, Flush);

        // End simulation
        $display("Testbench completed.");
        $stop;
    end

endmodule
