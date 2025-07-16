module processor (
    input clk
);
// stage1
reg [31:0] IFID_Instruction;

// stage2
reg WB2, M2, EX2;
reg signed [63:0] rs1, rs2;
reg [4:0] IFID_rs1, IFID_rs2, IFID_rd;
reg [3:0] Alu_ctrl;
reg IDEX_MemRead, IDEX_MemWrite, IDEX_MemtoReg, IDEX_RegWrite; 

// stage3
reg WB3, M3;
reg signed [63:0] ALU_result;
reg signed [63:0] Data_to_write;
reg [4:0] rd3;
reg EXMEM_MemRead, EXMEM_MemWrite, EXMEM_MemtoReg, EXMEM_RegWrite;

reg IFID_write;
reg PCWrite;
reg [63:0] PC2, PC3;


// stage4
reg WB4;
reg signed [63:0] Data_from_memory;
reg signed [63:0] Data_from_ALU;
reg [4:0] rd4;
reg MEMWB_MemtoReg, MEMWB_RegWrite;


reg signed [63:0] IDEX_Data_to_write;
reg signed [63:0] immed64_3;


reg signed [63:0] registers[31:0];

// stage1
reg [63:0] PC;
wire [31:0] instruction;

// stage2
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
wire signed [63:0] imm64;
wire signed [63:0] Rs2;

// stage3
wire signed [63:0] ALU_output;
wire zero, overflow;
wire signed [63:0] read_data;
wire signed [63:0] write_data;

initial begin
    registers[0]  = 64'd0;
    registers[1]  = 64'd1;
    registers[2]  = 64'd2;
    registers[3]  = 64'd0;
    registers[4]  = 64'd4;
    registers[5]  = 64'd5;
    registers[6]  = 64'd0;
    registers[7]  = 64'd7;
    registers[8]  = 64'd0;
    registers[9]  = 64'd9;
    registers[10] = 64'd10;
    registers[11] = 64'd0;
    registers[12] = 64'd0;
    registers[13] = 64'd0;
    registers[14] = 64'd0;
    registers[15] = 64'd0;
    registers[16] = 64'd0;
    registers[17] = 64'd0;
    registers[18] = 64'd0;
    registers[19] = 64'd0;
    registers[20] = 64'd0;
    registers[21] = 64'd0;
    registers[22] = 64'd0;
    registers[23] = 64'd0;
    registers[24] = 64'd0;
    registers[25] = 64'd0;
    registers[26] = 64'd0;
    registers[27] = 64'd0;
    registers[28] = 64'd0;
    registers[29] = 64'd0;
    registers[30] = 64'd0;
    registers[31] = 64'd0;
    PC = 64'd0;
    IFID_Instruction = 32'h00000000;
    WB2 = 1'b0;
    M2 = 1'b0;
    EX2 = 1'b0;
    WB3 = 1'b0;
    M3 = 1'b0;
    WB4 = 1'b0;
    IFID_write = 1'b1;
    PCWrite = 1'b1;
end

instruction_memory inst_mem (
    .PC(PC),
    .instruction(instruction)
);

control_unit control (
    .opcode(IFID_Instruction[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);

immediate_extractor imm_gen (
    .instruction(IFID_Instruction),
    .imm64(imm64)
);

mux mux1 (
    .A(registers[IFID_Instruction[24:20]]), 
    .B(imm64), 
    .sel(ALUSrc), 
    .Y(Rs2)
);

wire [63:0] data;
assign data = registers[IFID_Instruction[24:20]];

wire [3:0] Aluctrl_input;
wire [3:0] ALUCtrl1;
assign Aluctrl_input = {IFID_Instruction[30], IFID_Instruction[14:12]};

alu_control alu_ctrl (
    .ALUOp(ALUOp),
    .funct(Aluctrl_input),
    .ALUCtrl(ALUCtrl1)
);

reg [1:0] ForwardA, ForwardB;
always @(*) begin
    ForwardA = 2'b00;
    ForwardB = 2'b00;
    if (WB3 && (rd3 != 0)) begin
        if (rd3 == rs1) ForwardA = 2'b10; 
        if (rd3 == rs2) ForwardB = 2'b10;
    end

    if (WB4 && (rd4 != 0)) begin
        if (rd4 == rs1) ForwardA = 2'b01;
        if (rd4 == rs2) ForwardB = 2'b01;
    end
end
reg [63:0] RS1,RS2;

always @(*) begin
    case (ForwardA)
        2'b00: RS1 = rs1; 
        2'b01: RS1 = rd4; 
        2'b10: RS1 = rd3;
        default: RS1 = 63'b0;
    endcase
end

always @(*) begin
    case (ForwardB)
        2'b00: RS2 = rs2;
        2'b01: RS2 = rd4;
        2'b10: RS2 = rd3;
        default: RS2 = 63'b0;
    endcase
end

ALU alu (
    .a(RS1),
    .b(RS2),
    .Alu_control(Alu_ctrl),
    .result(ALU_output),
    .zero(zero),
    .overflow(overflow)
);

reg Stall,IF_ID_Write,Flush;
reg PC_input;
// wire ID_EX_MemRead;
// wire [4:0] IF_ID_rs1, IF_ID_rs2;
// wire [4:0] IF_ID_rd;
// assign IF_ID_rs1 = IFID_Instruction[19:15];
// assign IF_ID_rs2 = IFID_Instruction[24:20];
// assign IF_ID_rd = IFID_rd;
// assign ID_EX_MemRead = IDEX_MemRead;



always @(*) begin
    // Default values (no stall or flush)
    PC_input = Branch && zero;
    Stall = 0;
    
    IF_ID_Write = 1;
    Flush = 0;

    // Handle Load-Use Hazard
    if (IDEX_MemRead && ((IFID_rd == IFID_Instruction[19:15] && IFID_rd != 0) || (IFID_rd == IFID_Instruction[24:20] && IFID_rd != 0))) begin
        Stall = 1;  
        PCWrite = 0;
        IF_ID_Write = 0;
    end

    // Handle Control Hazard (Branch)
    if (PC_input) begin // Branch Taken
        Flush = 1;   // Flush IF/ID pipeline register
        PCWrite = 1; // Allow PC to update to branch target
        IF_ID_Write = 1; // Continue fetching
    end
end
wire new_pc;
assign new_pc = (Branch && zero && Flush) ? PC3 + (immed64_3 << 1) : PC + 4;


Data_Memory data_mem (
    .MemRead(EXMEM_MemRead),
    .MemWrite(EXMEM_MemWrite),
    .address(ALU_result),
    .write_data(Data_to_write),
    .read_data(read_data)
);

mux mux2 (
    .A(Data_from_ALU),
    .B(Data_from_memory),
    .sel(MEMWB_MemtoReg),
    .Y(write_data)
);

always @(posedge clk) begin
    // stage1

    PC3 <= PC2;
    PC2 <= PC;    
    PC <= (PCWrite) ? new_pc : PC;
    
    registers[rd4] <= (WB4 && MEMWB_RegWrite) ? write_data : registers[rd4];
    
    rd4 <= rd3;
    WB4 <= WB3;
    MEMWB_MemtoReg <= EXMEM_MemRead;
    MEMWB_RegWrite <= EXMEM_RegWrite;
    Data_from_memory <= (M3 && EXMEM_MemRead) ? read_data : 64'd0;
    Data_from_ALU <= ALU_result;
    Data_to_write <= (IDEX_MemWrite) ? IDEX_Data_to_write : 64'd0;
    
    rd3 <= (EX2) ? IFID_rd : 5'd0;
    ALU_result <= (EX2) ? ALU_output : 64'd0;
    IDEX_Data_to_write <= data;
    

    // stage2
    WB3 <= WB2;
    M3 <= M2;
    IFID_rs1 <= (~Flush) ? IFID_Instruction[19:15] : 5'd0;
    IFID_rs2 <= (~Flush) ? IFID_Instruction[24:20] : 5'd0;
    IFID_rd <= (~Flush) ? IFID_Instruction[11:7] : 5'd0;
    rs1 <= (~Flush) ? registers[IFID_Instruction[19:15]] : 64'd0;
    rs2 <= (~Flush) ? Rs2 : 64'd0;
    
    
    M2 <= ((MemRead || MemWrite) && (~Flush)) ? 1'b1 : 1'b0;
    EX2 <= (~Flush && IFID_Instruction[0]) ? 1'b1 : 1'b0;
    WB2 <= (~Flush) ? RegWrite : 1'b0;
    Alu_ctrl <= (~Flush) ? ALUCtrl1 : 4'd0;
    
    EXMEM_MemRead <= IDEX_MemRead;
    EXMEM_MemWrite <= IDEX_MemWrite;
    EXMEM_MemtoReg <= IDEX_MemtoReg;
    EXMEM_RegWrite <= IDEX_RegWrite;
    IDEX_MemRead <=  (~Flush) ? MemRead : 1'b0;
    IDEX_MemWrite <= (~Flush) ? MemWrite : 1'b0;
    IDEX_MemtoReg <= (~Flush) ? MemtoReg : 1'b0;
    IDEX_RegWrite <= (~Flush) ? RegWrite : 1'b0;
    

    immed64_3 <= (EX2) ? imm64 : 64'd0;
    IFID_write <= (Flush) ? 1'b0 : 1'b1;
    IFID_Instruction <= (Flush) ? 32'd0 : instruction;
    
end

endmodule
