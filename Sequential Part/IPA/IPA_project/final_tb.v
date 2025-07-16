`timescale 1ns/1ps

module processor_tb;
    reg clk;
    
    // Instantiate the processor
    processor uut (
        .clk(clk)
    );

    // Clock Generation: 10ns period (100MHz)
    always #5 clk = ~clk;

    // Simulation setup
    initial begin
        // Initialize clock
        clk = 0;

        // Display Header
        $display("\nTime\t PC      \tCurrent Instr\tBranch\t ALU_ctrl\t rs1\trs2      \tALU_result\tWrite_Data");

        // Monitor key signals at each timestep
        $monitor("%0t\t %h\t%h\t%b\t %h\t %h\t%h\t%h", 
                 $time, 
                 uut.PC, 
                 uut.current_instruction,  // Use current_instruction (registered)
                 uut.Branch, 
                 uut.ALUCtrl,
                 uut.rs1,
                 uut.rs2, 
                 uut.ALU_result, 
                 //uut.zero
                 uut.write_data
        );

        // Run for 20 clock cycles to observe execution
        #40;

        // Print register file state at the end
        $display("\nFinal Register File State:");
        $display("x0  = %h", uut.register.registers[0]);
        $display("x1  = %h", uut.register.registers[1]);
        $display("x5  = %h", uut.register.registers[5]);
        $display("x6  = %h", uut.register.registers[6]);
        $display("x7  = %h", uut.register.registers[7]);
        $display("x14 = %h", uut.register.registers[14]);

        // Print data memory state
        $display("\nData Memory at Address 8:");
        $display("mem[8] = %h", {uut.data.memory[8], uut.data.memory[7], uut.data.memory[6], uut.data.memory[5]});

        // Stop simulation
        $finish;
    end

    // Optional: Add waveform dumping if needed
    initial begin
        //$dumpfile("processor_tb.vcd");
        //$dumpvars(0, processor_tb);
    end

endmodule
