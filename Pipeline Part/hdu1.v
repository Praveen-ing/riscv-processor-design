module HazardDetectionUnit
(
    input wire ID_EX_MemRead,          // Load instruction in EX stage
    input wire [4:0] ID_EX_RegisterRd, // Destination register in EX stage
    input wire [4:0] IF_ID_RegisterRs1, // Source register 1 in ID stage
    input wire [4:0] IF_ID_RegisterRs2, // Source register 2 in ID stage
    input wire BranchTaken,            // Combined signal: Branch & ALUZero

    output reg Stall,       // Stall signal for load-use hazard
    output reg PCWrite,     // Control signal to stop PC update
    output reg IF_ID_Write, // Control signal to stop instruction fetch
    output reg Flush        // Control signal to flush incorrect instruction
);


endmodule

// iverilog -o hdu1_tb hdu1.v tb_hdu1.v
//vvp hdu1_tb