module register_file 
(                 
    input wire RegWrite,          
    input wire [4:0] read_reg1,      
    input wire [4:0] read_reg2,      
    input wire [4:0] write_reg,      
    input wire [63:0] write_data,    
    output wire [63:0] read_data1,   
    output wire [63:0] read_data2    
);
    logic signed [63:0] registers [31:0];
        initial begin   
            registers[0]  = 64'h0000000000000000;  
            registers[1]  = 64'h0000000000000001;
            registers[2]  = 64'd0;
            registers[3]  = 64'h0000000000000003;
            registers[4]  = 64'd10;
            registers[5]  = 64'd15;
            registers[6]  = 64'd15;
            registers[7]  = 64'h0000000000000000;
            registers[8]  = 64'd20;
            registers[9]  = 64'd100;
            registers[10] = 64'd0;
            registers[11] = 64'd0;
            registers[12] = 64'd16;
            registers[13] = 64'd19;
            registers[14] = 64'h0000000000000000;
            registers[15] = 64'h0000000000000000;
            registers[16] = 64'h0000000000000000;
            registers[17] = 64'h0000000000000000;
            registers[18] = 64'h0000000000000000;
            registers[19] = 64'h0000000000000000;
            registers[20] = 64'h0000000000000000;
            registers[21] = 64'h0000000000000000;
            registers[22] = 64'h0000000000000000;
            registers[23] = 64'h0000000000000000;
            registers[24] = 64'h0000000000000000;
            registers[25] = 64'h0000000000000000;
            registers[26] = 64'h000000000000001A;
            registers[27] = 64'd0;
            registers[28] = 64'd2;
            registers[29] = 64'd0;
            registers[30] = 64'd1;
            
            registers[31] = 64'd10;
        end 
         
        assign read_data1 = registers[read_reg1];  
        assign read_data2 = registers[read_reg2];  
        always @(*) begin
        registers[write_reg] <= (RegWrite && write_reg != 5'b00000) ? write_data : registers[write_reg];
        end
endmodule
