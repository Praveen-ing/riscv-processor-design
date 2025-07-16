`timescale 1ns/1ps

module Data_Memory_tb;
    
    // Testbench Signals
    reg clk;
    reg MemRead;
    reg MemWrite;
    reg [63:0] address;
    reg [63:0] write_data;
    wire [63:0] read_data;

    // Instantiate Data_Memory module
    Data_Memory uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock Generation (50% duty cycle)
    always #5 clk = ~clk;  // 10 ns period

    initial begin
        // Initialize signals
        clk = 1;
        MemRead = 0;
        MemWrite = 0;
        address = 0;
        write_data = 0;

        // Wait for memory initialization
        #10;

        // Test Case 1: Read from pre-initialized memory (memory[3])
        address = 3; 
        write_data = 64'h0000000000000000; 
        MemRead = 1;
        #10;
        MemRead = 0;

        // Test Case 2: Write operation
        address = 3;  // Memory location 20
        write_data = 64'hDEADBEEFCAFEBABE;  // Test data
        MemWrite = 1;
        #10;
        MemWrite = 0;  // Disable write

        MemRead = 1;
        write_data = 64'h0000000000000000;
        address = 3;
        #10;
        //MemRead = 0;

        // // Test Case 3: Read the newly written data
        // #10;
        // MemRead = 1;
        // #10;
        // MemRead = 0;

        // // Test Case 4: Another Write-Read Cycle
        // #10;
        // address = 8;  
        // write_data = 64'h123456789ABCDEF0;  
        // MemWrite = 1;
        // #10;
        // MemWrite = 0;

        // #10;
        MemRead = 1;
        write_data  = 64'h0000000000000000;
        address = 8;
        //MemRead = 0;

        // End simulation
        #10;
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t | clk=%b | MemRead=%b | MemWrite=%b | Addr=%d | WriteData=%h | ReadData=%h", 
                  $time, clk, MemRead, MemWrite, address, write_data, read_data);
    end

endmodule