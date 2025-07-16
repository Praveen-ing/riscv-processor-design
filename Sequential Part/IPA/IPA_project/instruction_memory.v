module instruction_memory (
    input [63:0] PC,     
    output reg [31:0] instruction
);
    // Memory array - 1KB
    reg [7:0] memory [0:1023];

    // Initialize memory with instructions
    initial begin
        // First instruction: add x14, x14, x7 (0x00774833)
        memory[0] = 8'hB3; // Least significant byte
        memory[1] = 8'h04;
        memory[2] = 8'h74;
        memory[3] = 8'h00; // Most significant byte
        
        // Second instruction: addi x5, x0, 10 (0x00A00293)
        memory[4] = 8'h93;
        memory[5] = 8'h02;
        memory[6] = 8'hA0;
        memory[7] = 8'h00;
        
        // Third instruction: sw x5, 8(x0) (0x00502423)
        memory[8] = 8'h23;
        memory[9] = 8'h24;
        memory[10] = 8'h50;
        memory[11] = 8'h00;
        
        // Fourth instruction: lw x6, 8(x0) (0x00802303)
        memory[12] = 8'h03;
        memory[13] = 8'h23;
        memory[14] = 8'h80;
        memory[15] = 8'h00;
        
        // Fifth instruction: beq x5, x6, 8 (0x00628463)
        memory[16] = 8'h63;
        memory[17] = 8'h84;
        memory[18] = 8'h62;
        memory[19] = 8'h00;
    end

    // Fetch instruction (combinational)
    always @(*) begin
        // Correctly fetch instruction (little-endian)
        instruction = {memory[PC+3], memory[PC+2], memory[PC+1], memory[PC]};
    end
endmodule