//iverilog -o Data_Memory_tb Data_Memory.v Data_Memory_tb.v
//vvp Data_Memory_tb

module Data_Memory 
(
    input clk,            
    input MemRead,             
    input MemWrite,            
    input [63:0] address,    
    input [63:0] write_data,  
    output reg [63:0] read_data  
);

    reg [63:0] memory [0:255];  
    initial begin
        memory[0]=64'h0000000000000000;
        memory[1]=64'h0000000000000001;
        memory[2]=64'h0000000000000002;
        memory[3]=64'h0000000000000003;
        memory[4]=64'h0000000000000004;
        memory[5]=64'h0000000000000005;
        memory[6]=64'h0000000000000006;
        memory[7]=64'h0000000000000007;
        memory[8]=64'h0000000000000008;
    end

    // Write Operation on negedge clk
    always @(negedge clk) begin
        if (MemWrite) 
            memory[address[9:0]] <= write_data; 
    end

    // Read Operation - Fixed to avoid resetting read_data
    always @(negedge clk) begin
        if (MemRead) 
            read_data <= memory[address[9:0]];  
    end

endmodule
