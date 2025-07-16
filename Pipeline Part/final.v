//iverilog final.v instruction_memory.v control.v immed.v mux.v ALU_ctrl.v alu.v data_memory.v Cla64bit.v final_tb.v register.v 
//

module processor (
    input clk
);
    reg [63:0] PC;
    reg RegWrite;
    reg signed [63:0] write_data;
    reg [31:0] current_instruction;

    initial begin
        write_data = 64'h0000000000000000;
        RegWrite = 1'b0;
        PC = 64'h0000000000000000;
        current_instruction = 32'h00000000;
    end

    wire [31:0] instruction;
    wire [63:0] rs1,reg2;
    wire signed [63:0] rs2;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc;
    wire [1:0] ALUOp;
    wire signed [63:0] imm64;
    reg [3:0] ALUCtrl;
    wire signed [63:0] ALU_result;
    wire zero;
    wire overflow;
    wire [63:0] new_PC;
    wire [63:0] write_data1;
    wire RegWrite1;

    instruction_memory intr_fetch(
        .PC(PC),
        .instruction(instruction)
    );

    
    always @(*) begin
        current_instruction <= instruction;
    end

    register_file register(
        .RegWrite(RegWrite),
        .read_reg1(current_instruction[19:15]),
        .read_reg2(current_instruction[24:20]),
        .write_reg(current_instruction[11:7]),
        .write_data(write_data),
        .read_data1(rs1),
        .read_data2(reg2)
    );


    control_unit control(
        .opcode(current_instruction[6:0]),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite1)
    );


    always @(posedge clk) begin
        RegWrite <= RegWrite1;
    end

    immediate_extractor imme(
        .instruction(current_instruction),
        .imm64(imm64)
    );


    mux mux1(
        .A(reg2),
        .B(imm64),
        .sel(ALUSrc),
        .Y(rs2)
    );

    
    wire [3:0] Aluctrl_input;
    assign Aluctrl_input = {current_instruction[30], current_instruction[14:12]};

    wire [3:0] ALUCtrl1;
    alu_control alu_input(
        .ALUOp(ALUOp),
        .funct(Aluctrl_input),
        .ALUCtrl(ALUCtrl1)
    );

    always @(*) begin
        ALUCtrl <= ALUCtrl1;
    end

    ALU alu(
        .a(rs1),
        .b(rs2),
        .Alu_control(ALUCtrl),
        .result(ALU_result),
        .zero(zero),
        .overflow(overflow)
    );

    new_pc New_Pc(
        .Branch(Branch),
        .Zero(zero),
        .imm(imm64),
        .PC(PC),
        .new_PC(new_PC)
    );

    always @(posedge clk) begin
        //if(instruction[6:0] == 7'b0000000)begin
            //$finish;
        //end
        PC <= new_PC;
    end

    Data_Memory data(
        //.clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(ALU_result),
        .write_data(reg2),
        .read_data(write_data1)
    );

    
    wire signed [63:0] final_write_data;
    mux write_data_mux(
        .A(ALU_result),
        .B(write_data1),
        .sel(MemtoReg),
        .Y(final_write_data)
    );

    always @(*) begin
        write_data <= final_write_data;
    end

endmodule