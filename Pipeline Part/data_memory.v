//iverilog -o Data_Memory_tb Data_Memory.v Data_Memory_tb.v
//vvp Data_Memory_tb

module Data_Memory 
(
    //input clk,            
    input MemRead,             
    input MemWrite,            
    input [63:0] address,    
    input [63:0] write_data,  
    output reg [63:0] read_data  
);

    reg [63:0] data_memory [0:255];  
    initial begin
        // data_memory[0]=64'h0000000000000000;
        // data_memory[1]=64'h0000000000000001;
        // data_memory[2]=64'h0000000000000002;
        // data_memory[3]=64'h0000000000000003;
        // data_memory[4]=64'h0000000000000004;
        // data_memory[5]=64'h0000000000000005;
        // data_memory[6]=64'h0000000000000006;
        // data_memory[7]=64'h0000000000000007;
        // data_memory[8]=64'h0000000000000008;
        data_memory[0]  = 64'h0000000000000000;
        data_memory[1]  = 64'h0000000000000000;
        data_memory[2]  = 64'h0000000000000000;
        data_memory[3]  = 64'h0000000000000000;
        data_memory[4]  = 64'h0000000000000000;
        data_memory[5]  = 64'h0000000000000000;
        data_memory[6]  = 64'h0000000000000000;
        data_memory[7]  = 64'h0000000000000000;
        data_memory[8]  = 64'h0000000000000000;
        data_memory[9]  = 64'h0000000000000000;
        data_memory[10] = 64'h0000000000000000;
        data_memory[11] = 64'h0000000000000000;
        data_memory[12] = 64'h0000000000000000;
        data_memory[13] = 64'h0000000000000000;
        data_memory[14] = 64'h0000000000000000;
        data_memory[15] = 64'h0000000000000000;
        data_memory[16] = 64'h0000000000000000;
        data_memory[17] = 64'h0000000000000010;
        data_memory[18] = 64'h0000000000000000;
        data_memory[19] = 64'h0000000000000000;
        data_memory[20] = 64'h0000000000000000;
        data_memory[21] = 64'h0000000000000000;
        data_memory[22] = 64'h0000000000000000;
        data_memory[23] = 64'h0000000000000000;
        data_memory[24] = 64'h0000000000000000;
        data_memory[25] = 64'h0000000000000000;
        data_memory[26] = 64'h0000000000000000;
        data_memory[27] = 64'h0000000000000000;
        data_memory[28] = 64'h0000000000000000;
        data_memory[29] = 64'h0000000000000000;
        data_memory[30] = 64'h0000000000000000;
        data_memory[31] = 64'h0000000000000000;
        data_memory[32] = 64'h0000000000000000;
        data_memory[33] = 64'h0000000000000000;
        data_memory[34] = 64'h0000000000000000;
        data_memory[35] = 64'h0000000000000000;
        data_memory[36] = 64'h0000000000000000;
        data_memory[37] = 64'h0000000000000000;
        data_memory[38] = 64'h0000000000000000;
        data_memory[39] = 64'h0000000000000000;
        data_memory[40] = 64'h0000000000000000;
        data_memory[41] = 64'h0000000000000000;
        data_memory[42] = 64'h0000000000000000;
        data_memory[43] = 64'h0000000000000000;
        data_memory[44] = 64'h0000000000000000;
        data_memory[45] = 64'h0000000000000000;
        data_memory[46] = 64'h0000000000000000;
        data_memory[47] = 64'h0000000000000000;
        data_memory[48] = 64'h0000000000000000;
        data_memory[49] = 64'h0000000000000000;
        data_memory[50] = 64'h0000000000000000;
        data_memory[51] = 64'h0000000000000000;
        data_memory[52] = 64'h0000000000000000;
        data_memory[53] = 64'h0000000000000000;
        data_memory[54] = 64'h0000000000000000;
        data_memory[55] = 64'h0000000000000000;
        data_memory[56] = 64'h0000000000000000;
        data_memory[57] = 64'h0000000000000000;
        data_memory[58] = 64'h0000000000000000;
        data_memory[59] = 64'h0000000000000000;
        data_memory[60] = 64'h0000000000000000;
        data_memory[61] = 64'h0000000000000000;
        data_memory[62] = 64'h0000000000000000;
        data_memory[63] = 64'h0000000000000000;
        data_memory[64]  = 64'h0000000000000000;
        data_memory[65]  = 64'h0000000000000000;
        data_memory[66]  = 64'h0000000000000000;
        data_memory[67]  = 64'h0000000000000000;
        data_memory[68]  = 64'h0000000000000000;
        data_memory[69]  = 64'h0000000000000000;
        data_memory[70]  = 64'h0000000000000000;
        data_memory[71]  = 64'h0000000000000000;
        data_memory[72]  = 64'h0000000000000000;
        data_memory[73]  = 64'h0000000000000000;
        data_memory[74] = 64'h0000000000000000;
        data_memory[75] = 64'h0000000000000000;
        data_memory[76] = 64'h0000000000000000;
        data_memory[77] = 64'h0000000000000000;
        data_memory[78] = 64'h0000000000000000;
        data_memory[79] = 64'h0000000000000000;
        data_memory[80] = 64'h0000000000000000;
        data_memory[81] = 64'h0000000000000000;
        data_memory[82] = 64'h0000000000000000;
        data_memory[83] = 64'h0000000000000000;
        data_memory[84] = 64'h0000000000000000;
        data_memory[85] = 64'h0000000000000000;
        data_memory[86] = 64'h0000000000000000;
        data_memory[87] = 64'h0000000000000000;
        data_memory[88] = 64'h0000000000000000;
        data_memory[89] = 64'h0000000000000000;
        data_memory[90] = 64'h0000000000000000;
        data_memory[91] = 64'h0000000000000000;
        data_memory[92] = 64'h0000000000000000;
        data_memory[93] = 64'h0000000000000000;
        data_memory[94] = 64'h0000000000000000;
        data_memory[95] = 64'h0000000000000000;
        data_memory[96] = 64'h0000000000000000;
        data_memory[97] = 64'h0000000000000000;
        data_memory[98] = 64'h0000000000000000;
        data_memory[99] = 64'h0000000000000000;
        data_memory[100] = 64'h0000000000000000;
        data_memory[101] = 64'h0000000000000000;
        data_memory[102] = 64'h0000000000000000;
        data_memory[103] = 64'h0000000000000000;
        data_memory[104] = 64'h0000000000000000;
        data_memory[105] = 64'h0000000000000000;
        data_memory[106] = 64'h0000000000000000;
        data_memory[107] = 64'h0000000000000000;
        data_memory[108] = 64'h0000000000000000;
        data_memory[109] = 64'h0000000000000000;
        data_memory[110] = 64'h0000000000000000;
        data_memory[111] = 64'h0000000000000000;
        data_memory[112] = 64'h0000000000000000;
        data_memory[113] = 64'h0000000000000000;
        data_memory[114] = 64'h0000000000000000;
        data_memory[115] = 64'h0000000000000000;
        data_memory[116] = 64'h0000000000000000;
        data_memory[117] = 64'h0000000000000000;
        data_memory[118] = 64'h0000000000000000;
        data_memory[119] = 64'h0000000000000000;
        data_memory[120] = 64'h0000000000000000;
        data_memory[121] = 64'h0000000000000000;
        data_memory[122] = 64'h0000000000000000;
        data_memory[123] = 64'h0000000000000000;
        data_memory[124] = 64'h0000000000000000;
        data_memory[125] = 64'h0000000000000000;
        data_memory[126] = 64'h0000000000000000;
        data_memory[127] = 64'h0000000000000000;
    end

    
    always @(*) begin
        if (MemWrite) 
            data_memory[address[9:0]] <= write_data;
    end

    
    always @(*) begin
        if (MemRead) 
            read_data <= data_memory[address[9:0]];
    end

endmodule