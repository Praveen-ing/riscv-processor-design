`timescale 1ns / 1ps

module processor (
    input clk
);

reg [31:0] IFID_Instruction;
reg [63:0] IFID_PC;
reg [63:0] IDEX_rs1, IDEX_rs2;
reg [4:0] IDEX_rd;
wire [3:0] IDEX_ALUCtrl;
reg IDEX_MemRead, IDEX_MemWrite, IDEX_MemtoReg, IDEX_RegWrite, IDEX_ALUSrc;
reg signed [63:0] IDEX_imm64;
reg [3:0] IDEX_ALUCtrl_reg;

reg [63:0] EXMEM_ALU_result;
reg [63:0] EXMEM_Data_to_write;
reg [4:0] EXMEM_rd;
reg EXMEM_MemRead, EXMEM_MemWrite, EXMEM_MemtoReg, EXMEM_RegWrite;

wire [63:0] MEMWB_Data_from_memory;
reg [63:0] MEMWB_Data_from_ALU;
reg [4:0] MEMWB_rd;
reg MEMWB_MemtoReg, MEMWB_RegWrite;

reg signed [63:0] registers[31:0];
reg [63:0] PC;
wire [31:0] instruction;

wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
wire signed [63:0] imm64;
wire signed [63:0] ALU_output;
wire zero;

initial begin
    registers[0]  = 64'd0;
    registers[1]  = 64'd0;
    registers[2]  = 64'd0;
    registers[3]  = 64'd0;
    registers[4]  = 64'd0;
    registers[5]  = 64'd0;
    registers[6]  = 64'd0;
    registers[7]  = 64'd0;
    registers[8]  = 64'd0;
    registers[9]  = 64'd0;
    registers[10] = 64'd0;
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
    //instruction = 32'd0;
    IFID_Instruction = 32'h00000000;
    EXMEM_MemRead = 1'b0;
    EXMEM_Memwrite = 1'b0;
    EXMEM_MemtoReg = 1'b0;
    EXMEM_RegWrite = 1'b0;

    MEMWB_MemtoReg = 1'b0;
    MEMWB_RegWrite = 1'b0;
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

alu_control alu_ctrl (
    .ALUOp(ALUOp),
    .funct({IFID_Instruction[30], IFID_Instruction[14:12]}),
    .ALUCtrl(IDEX_ALUCtrl)
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

ALU alu (
    .a(IDEX_rs1),
    .b(IDEX_ALUSrc ? IDEX_imm64 : IDEX_rs2),
    .Alu_control(IDEX_ALUCtrl),
    .result(ALU_output),
    .zero(zero)
);

Data_Memory data_mem (
    .MemRead(EXMEM_MemRead),
    .MemWrite(EXMEM_MemWrite),
    .address(EXMEM_ALU_result),
    .write_data(EXMEM_Data_to_write),
    .read_data(MEMWB_Data_from_memory)
);

always @(posedge clk) begin
    IFID_Instruction <= instruction;
    //IFID_PC <= PC;
    PC <= PC + 4;
    
    IDEX_rs1 <= registers[IFID_Instruction[19:15]];
    IDEX_rs2 <= registers[IFID_Instruction[24:20]];
    IDEX_rd <= IFID_Instruction[11:7];
    IDEX_imm64 <= imm64;
    IDEX_ALUCtrl_reg <= IDEX_ALUCtrl;
    IDEX_MemRead <= MemRead;
    IDEX_MemWrite <= MemWrite;
    IDEX_MemtoReg <= MemtoReg;
    IDEX_RegWrite <= RegWrite;
    IDEX_ALUSrc <= ALUSrc;
    
    EXMEM_ALU_result <= ALU_output;
    EXMEM_Data_to_write <= IDEX_rs2;
    EXMEM_rd <= IDEX_rd;
    EXMEM_MemRead <= IDEX_MemRead;
    EXMEM_MemWrite <= IDEX_MemWrite;
    EXMEM_MemtoReg <= IDEX_MemtoReg;
    EXMEM_RegWrite <= IDEX_RegWrite;
    
    MEMWB_Data_from_ALU <= EXMEM_ALU_result;
    MEMWB_rd <= EXMEM_rd;
    MEMWB_MemtoReg <= EXMEM_MemtoReg;
    MEMWB_RegWrite <= EXMEM_RegWrite;
    
    if (MEMWB_RegWrite)
        registers[MEMWB_rd] <= MEMWB_MemtoReg ? MEMWB_Data_from_memory : MEMWB_Data_from_ALU;
end
endmodule
