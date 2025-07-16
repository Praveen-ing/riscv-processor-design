`timescale 1ns / 1ps

module processor_tb;
    reg clk;
    integer i;

    // Instantiate the processor module
    processor uut (
        .clk(clk)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Simulation run time
    initial begin
        #80; // Run simulation for 200 time units
        $finish;
    end

    // Display register contents at each clock cycle
    always @(posedge clk) begin
        $display("--------------------------------------------------------------------------------");
        $display("Time: %0t | PC: %0d | Instruction: %h", $time, uut.PC, uut.IFID_Instruction);
        $display("--------------------------------------------------------------------------------");
        $display("| IFID_rs1  | IFID_rs2  | IFID_rd   | rs1           | rs2           |");
        $display("| %-9d | %-9d | %-9d | %-13d | %-13d |", uut.IFID_rs1, uut.IFID_rs2, uut.IFID_rd, uut.rs1, uut.rs2);
        
        $display("--------------------------------------------------------------------------------");
        $display("| WB2  | M2   | EX2  | ALU_Control | ALU_result      | Data_to_write   | rd3   |");
        $display("| %-4b | %-4b | %-4b | %-10b | %-16d | %-16d | %-4d |", 
                 uut.WB2, uut.M2, uut.EX2, uut.Alu_ctrl, uut.ALU_result, uut.Data_to_write, uut.rd3);
        
        $display("--------------------------------------------------------------------------------");
        $display("| WB3  | M3   | Data_from_memory  | Data_from_ALU    | rd4   | WB4  |");
        $display("| %-4b | %-4b | %-17d | %-17d | %-4d | %-4b |",
                 uut.WB3, uut.M3, uut.Data_from_memory, uut.Data_from_ALU, uut.rd4, uut.WB4);
        $display("| PCWrite | IF_ID_Write | Stall | Flush | new_pc | target | immed64_2 | PC3 |");
        $display("| %-8b | %-10b | %-4b | %-4b | %-6d | %-6d | %-10d | %-6d |", uut.PCWrite, uut.IF_ID_Write, uut.Stall, uut.Flush, uut.new_pc, uut.target, uut.immed64_2, uut.PC3);
        
        $display("| %-4d |",uut.data_mem.data_memory[30]);
        
        $display("--------------------------------------------------------------------------------");
        $display("Registers:");
        
        for (i = 0; i < 32; i = i + 1) begin
            $display("R[%02d]: %16d", i, uut.registers[i]);
        end
        $display("--------------------------------------------------------------------------------\n");
    end
endmodule
