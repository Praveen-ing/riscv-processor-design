module processor (
    input clk
);
    // Registers
    reg [63:0] PC;
    reg RegWrite;
    reg [63:0] write_data;
    reg [31:0] current_instruction; // Register to hold the current instruction

    // Initial values
    initial begin
        write_data = 64'h0000000000000000;
        RegWrite = 1'b0;
        PC = 64'h0000000000000000;
        current_instruction = 32'h00000000;
    end

    // Wires
    wire [31:0] instruction;  // Wire from instruction memory
    wire [63:0] rs1, rs2, reg2;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc;
    wire [1:0] ALUOp;
    wire signed [63:0] imm64;
    wire [3:0] ALUCtrl;
    wire [63:0] ALU_result;
    wire zero;
    wire overflow;
    wire [63:0] new_PC;
    wire [63:0] write_data1;
    wire RegWrite1;

    // Instruction fetch
    instruction_memory intr_fetch(
        .PC(PC),
        .instruction(instruction)
    );

    // Synchronize instruction fetch with processor operation
    //always @(posedge clk) begin
    
     always @(*) begin
        // Correctly fetch instruction (little-endian)
        current_instruction <= instruction;
    end
    //end

    // Register file - use synchronized instruction
    register_file register(
        .clk(clk),
        .RegWrite(RegWrite),
        .read_reg1(current_instruction[19:15]),
        .read_reg2(current_instruction[24:20]),
        .write_reg(current_instruction[11:7]),
        .write_data(write_data),
        .read_data1(rs1),
        .read_data2(reg2)
    );

    // Control unit - use synchronized instruction
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

    // Update RegWrite signal
    always @(posedge clk) begin
        RegWrite <= RegWrite1;
    end

    // Immediate generator - use synchronized instruction
    immediate_extractor imme(
        .instruction(current_instruction),
        .imm64(imm64)
    );

    // ALU source mux
    mux mux1(
        .A(reg2),
        .B(imm64),
        .sel(ALUSrc),
        .Y(rs2)
    );

    // ALU control - use synchronized instruction
    wire [3:0] Aluctrl_input;
    assign Aluctrl_input = {current_instruction[30], current_instruction[14:12]};

    alu_control alu_input(
        .ALUOp(ALUOp),
        .funct(Aluctrl_input),
        .ALUCtrl(ALUCtrl)
    );

    // ALU
    ALU alu(
        .a(rs1),
        .b(rs2),
        .Alu_control(ALUCtrl),
        .result(ALU_result),
        .zero(zero),
        .overflow(overflow)
    );

    // Data memory
    Data_Memory data(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(ALU_result),
        .write_data(reg2),
        .read_data(write_data1)
    );

    // Write data mux (for MemtoReg)
    wire [63:0] final_write_data;
    mux write_data_mux(
        .A(ALU_result),
        .B(write_data1),
        .sel(MemtoReg),
        .Y(final_write_data)
    );

    // Update write_data at positive clock edge
    always @(posedge clk) begin
        write_data <= final_write_data;
    end

    // PC update logic
    new_pc New_Pc(
        .Branch(Branch),
        .Zero(zero),
        .imm(imm64),
        .PC(PC),
        .new_PC(new_PC)
    );

    // PC update at positive edge to synchronize with other operations
    always @(posedge clk) begin
        PC <= new_PC;
    end

endmodule