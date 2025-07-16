module processor (
    input clk,
    output wire [63:0] write_data
);
reg [63:0] PC;
wire [31:0] instruction;
wire regwrite;
initial begin
 write_data = 64'h0000000000000000;
 regwrite = 1'b0;
 PC = 64'h0000000000000000;
end
reg reg1,rs2,reg2;
wire Branch, MemRead,MemtoReg, MemWrite, ALUSrc,RegWrite;
wire [1:0] ALUOp;
wire signed [63:0] imm64;
wire [3:0] ALUCtrl;
wire [63:0] ALU_result;
wire zero;
wire overflow;


instruction_memory intr_fetch(
  .PC(PC),
  .clk(clk),
  .instruction(instruction)
);

register_file register(
  .clk(clk),
  .RegWrite(regwrite),
  .read_reg1(instruction[19:15]),
  .read_reg2(instruction[24:20]),
  .write_reg(instruction[11:7]),
  .write_data(write_data),
  .read_data1(reg1),
  .read_data2(rs2)
);

control_unit control(
  .opcode(instruction[6:0]),
  .Branch(Branch),
  .MemRead(MemRead),
  .MemtoReg(MemtoReg),
  .ALUOp(ALUOp),
  .MemWrite(MemWrite),
  .ALUSrc(ALUSrc),
  .regwrite(RegWrite)
);

immediate_extractor imme(
  .instruction(instruction),
  .imm64(imm64)
);

mux mux1(
  .A(rs2),
  .B(imm64),
  .sel(ALUSrc),
  .Y(reg2)
);

wire [3:0] Aluctrl_input;
assign Aluctrl_input = {instruction[30],instruction[14:12]};

alu_control alu_input(
  .ALUOp(ALUOp),
  .funct(Aluctrl_input),
  .ALUCtrl(ALUCtrl)
);

ALU alu(
  .a(reg1),
  .b(reg2),
  .Alu_control(ALUCtrl),
  .result(ALU_result),
  .zero(zero),
  .overflow(overflow)
);

Data_Memory data(
  .clk(clk),
  .MemRead(MemRead),
  .MemWrite(MemWrite),
  .address(ALU_result),
  .write_data(rs2),
  .read_data(write_data)
);

new_pc New_Pc(
  .clk(clk),
  .Branch(Branch),
  .Zero(zero),
  .imm(imm64),
  .PC(PC),
  .new_PC(PC)
);

endmodule