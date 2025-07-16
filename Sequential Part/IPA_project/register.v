module register_file (
    input wire clk,                  // Clock signal
    input wire RegWrite,             // Enable register write
    input wire [4:0] read_reg1,      // Read register 1 (5-bit address)
    input wire [4:0] read_reg2,      // Read register 2 (5-bit address)
    input wire [4:0] write_reg,      // Write register (5-bit address)
    input wire [63:0] write_data,    // Data to write into the register
    output wire [63:0] read_data1,   // Data read from register 1
    output wire [63:0] read_data2    // Data read from register 2
);
    logic [63:0] registers [31:0];
        initial begin
            registers[0]  = 64'h0000000000000000;  
            registers[1]  = 64'h0000000000000001;
            registers[2]  = 64'h0000000000000002;
            registers[3]  = 64'h0000000000000003;
            registers[4]  = 64'h0000000000000004;
            registers[5]  = 64'h0000000000000005;
            registers[6]  = 64'h0000000000000006;
            registers[7]  = 64'h0000000000000007;
            registers[8]  = 64'h0000000000000008;
            registers[9]  = 64'h0000000000000009;
            registers[10] = 64'h000000000000000A;
            registers[11] = 64'h000000000000000B;
            registers[12] = 64'h000000000000000C;
            registers[13] = 64'h000000000000000D;
            registers[14] = 64'h000000000000000E;
            registers[15] = 64'h000000000000000F;
            registers[16] = 64'h0000000000000010;
            registers[17] = 64'h0000000000000011;
            registers[18] = 64'h0000000000000012;
            registers[19] = 64'h0000000000000013;
            registers[20] = 64'h0000000000000014;
            registers[21] = 64'h0000000000000015;
            registers[22] = 64'h0000000000000016;
            registers[23] = 64'h0000000000000017;
            registers[24] = 64'h0000000000000018;
            registers[25] = 64'h0000000000000019;
            registers[26] = 64'h000000000000001A;
            registers[27] = 64'h000000000000001B;
            registers[28] = 64'h000000000000001C;
            registers[29] = 64'h000000000000001D;
            registers[30] = 64'h000000000000001E;
            registers[31] = 64'h000000000000001F;
        end 
         // Read operation (combinational logic)
        assign read_data1 = registers[read_reg1];  
        assign read_data2 = registers[read_reg2];  
        always @(posedge clk) begin
        registers[write_reg] <= (RegWrite && write_reg != 5'b00000) ? write_data : registers[write_reg];
    end
endmodule

