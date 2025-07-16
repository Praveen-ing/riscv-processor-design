module processor (
    input clk
);

reg [31:0] IFID_Instruction;

reg WB2,M2,EX2;
reg [63:0] rs1,rs2;
reg [4:0] IFID_rs1,IFID_rs2,IFID_rd;
reg Alu_ctrl;

reg WB3,M3;
reg signed [63:0] ALU_result;
reg signed [63:0] Data_to_write;
reg [4:0] rd3;

reg WB4;
reg [63:0] Data_from_memory;
reg [63:0] Data_from_ALU;
reg [4:0] rd4;

reg signed [63:0] registers[31:0];
reg [63:0] PC;
wire [31:0] instruction;

wire reg_write;

wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc;
wire [1:0] ALUOp;

wire signed [63:0] imm64;
wire signed [63:0] Rs2;
wire [4:0] ifid_rs2,ifid_rd;

wire signed [63:0] ALU_output;
wire zero;
wire overflow;

wire signed [63:0] read_data;

wire [63:0] write_data;

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


    PC = 64'h0000000000000000;
    IFID_Instruction = 32'h00000000;
    WB2 = 1'b0;
    M2 = 1'b0;
    EX2 = 1'b0;
    WB3 = 1'b0;
    M3 = 1'b0;
    WB4 = 1'b0;
end


instruction_memory intr_fetch(
    .PC(PC),
    .instruction(instruction)
);

control_unit control(
    .opcode(IFID_Instruction[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(reg_write)
);

immediate_extractor imm_gen(
    .instruction(IFID_Instruction),
    .imm64(imm64)
);

mux mux1(
   .A(registers[IFID_Instruction[24:20]]), 
   .B(imm64), 
   .sel(ALUSrc), 
   .Y(Rs2)
);

assign ifid_rs2 = (MemRead) ? 5'b00000 : IFID_Instruction[24:20];
assign ifid_rd = (MemWrite) ? 5'b00000 : IFID_Instruction[11:7];

wire [3:0] Aluctrl_input;
wire [3:0] ALUCtrl1;
assign Aluctrl_input = {IFID_Instruction[30], IFID_Instruction[14:12]};

alu_control alu_input(
    .ALUOp(ALUOp),
    .funct(Aluctrl_input),
    .ALUCtrl(ALUCtrl1)
);

// wire [1:0] ForwardA, ForwardB;

// if (WB3 && (rd3 != 0)) begin
//     if (rd3 == rs1) ForwardA = 2'b10; 
//     if (rd3 == rs2) ForwardB = 2'b10;
// end

//     // Check if rd4 is the destination and should be forwarded
// if (WB4 && (rd4 != 0)) begin
//     if (rd4 == rs1) ForwardA = 2'b01;
//     if (rd4 == rs2) ForwardB = 2'b01;
// end




ALU alu(
    .a(rs1),
    .b(rs2),
    .Alu_control(ALUCtrl1),
    .result(ALU_output),
    .zero(zero),
    .overflow(overflow)
);

Data_Memory data_mem(
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .address(ALU_result),
    .write_data(Data_to_write),
    .read_data(read_data)
);

mux mux2(
    .A(Data_from_ALU),
    .B(Data_from_memory),
    .sel(MemtoReg),
    .Y(write_data)
);


always @(posedge clk) begin
    IFID_Instruction <= instruction;

    IFID_rs1 <= IFID_Instruction[19:15];
    IFID_rs2 <= ifid_rs2;
    IFID_rd <= ifid_rd;
    rs1 <= registers[IFID_Instruction[19:15]];
    rs2 <= registers[Rs2];
    WB4 <= WB3;
    WB3 <= WB2;
    M3 <= M2;
    M2 <= (MemRead || MemWrite) ? 1'b1 : 1'b0;
    EX2 <= 1'b1;
    WB2 <= (MemtoReg) ? 1'b1 : 1'b0;
    Alu_ctrl <= ALUCtrl1;

    ALU_result <= (EX2) ? ALU_output : 64'd0;
    Data_to_write <= (EX2) ? rs2 : 64'd0;
    rd3 <= (EX2) ? IFID_rd : 5'd0;

    Data_from_memory <= (M3) ? read_data : 64'd0;
    Data_from_ALU <= (M3) ? ALU_result : 64'd0;
    rd4 <= (M3) ? rd3 : 5'd0;

    
    registers[rd4] <= (WB4 && reg_write) ? write_data : 64'd0;

    PC <= PC + 4;

end



endmodule