`timescale 1ns/1ps

module processor_tb;
    // Testbench signals
    reg clk;
    wire [63:0] write_data;
    
    // Instantiate the processor
    processor uut (
        .clk(clk),
        .write_data(write_data)
    );
    
    // Clock generation (50% duty cycle)
    always #5 clk = ~clk;
    
    // Variables for monitoring
    integer cycle_count;
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        cycle_count = 0;
        
        // Start monitoring
        $display("Starting processor simulation");
        $display("==============================");
        $display("Cycle\tPC\t\tInstruction\t\tALU Result\tWrite Data");
        $display("------------------------------------------------------");
        
        // Run for 20 clock cycles
        #200;
        
        // End simulation
        $display("==============================");
        $display("Simulation completed after %d cycles", cycle_count);
        $finish;
    end
    
    // Monitor important signals on each positive edge
    always @(posedge clk) begin
        cycle_count = cycle_count + 1;
        
        // Display current state on positive edge (after PC gets updated)
        #1; // Small delay to let signals propagate
        $display("%d\t%h\t%h\t%h\t%h", 
                 cycle_count, 
                 uut.PC, 
                 uut.instruction, 
                 uut.ALU_result, 
                 write_data);
        
        // Add specific test cases based on instruction execution
        case (cycle_count)
            1: // First instruction
                check_processor_state("Cycle 1");
            5: // Fifth instruction
                check_processor_state("Cycle 5");
            10: // Tenth instruction
                check_processor_state("Cycle 10");
            default: ; // Do nothing
        endcase
    end
    
    // Task to check processor's internal state at specific points
    task check_processor_state;
        input [100:0] test_name;
        begin
            $display("\n%s:", test_name);
            $display("PC = %h", uut.PC);
            $display("Instruction = %b", uut.instruction);
            $display("RegWrite = %b", uut.RegWrite);
            $display("Branch = %b", uut.Branch);
            $display("MemRead = %b", uut.MemRead);
            $display("MemWrite = %b", uut.MemWrite);
            $display("ALU Result = %h", uut.ALU_result);
            $display("Zero Flag = %b", uut.zero);
            $display("Immediate = %h (signed: %d)", uut.imm64, $signed(uut.imm64));
        end
    endtask

endmodule