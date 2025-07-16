module tb_immediate_extractor;
    reg [31:0] instruction;
    wire signed [63:0] imm64;

    immediate_extractor uut (
        .instruction(instruction),
        .imm64(imm64)
    );

    initial begin
        // Test case 1: Immediate = 127
        instruction = 32'b10000110100101010010111110100011;  
        #10;
        $display("SD Instruction: %b", instruction);
        $display("Extracted Immediate (64-bit): %b", imm64);

        // Test case 2: Immediate = 64
        instruction = 32'b10000001001010100110100000000011;
        #10;
        $display("LD Instruction: %b", instruction);
        $display("Extracted Immediate (64-bit): %b", imm64);

        // Test case 3: Unknown opcode (should return 0)
        instruction = 32'b1111111_01001_01010_010_00001_0000000;
        #10;
        $display("Unknown Instruction: %b", instruction);
        $display("Extracted Immediate (64-bit): %b", imm64);

        $finish;
    end
endmodule