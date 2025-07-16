// Compile: iverilog -o Alu_tb.vvp Alu_tb.v Alu.v
// Run: vvp Alu_tb.vvp
// View Waveform: gtkwave Alu_tb.vcd





module ALU (
    input [63:0] a,
    input [63:0] b,
    input [3:0] Alu_control,  // Control signal
    output reg [63:0] result,
    output reg zero,   
    output reg overflow  
);

    wire [63:0] sum_result;
    wire sum_cout;
    wire sum_overflow;
    wire [63:0] diff_result;
    wire diff_cout;
    wire diff_overflow;
    wire [63:0] and_result;
    wire [63:0] or_result;

    // 64-bit Adder
    adder_64bit adder (
        .a(a),
        .b(b),
        .cin(1'b0),  // Removed cin from ALU
        .sum(sum_result),
        .cout(sum_cout),
        .overflow(sum_overflow)
    );

    // 64-bit Subtractor
    Subtractor_64bit subtractor (
        .a(a),
        .b(b),
        .cin(1'b1), 
        .diff(diff_result),
        .cout(diff_cout),
        .overflow(diff_overflow)
    );

    // AND Operation
    And_64bit and_gate (
        .a(a),
        .b(b),
        .result(and_result)
    );

    // OR Operation
    Or_64bit or_gate (
        .a(a),
        .b(b),
        .result(or_result)
    );

    always @(*) begin
        zero = 1'b0;  // Ensure zero is reset unless required
        case (Alu_control)  // Changed from opcode to Alu_control
            4'b0010: begin // ADD (for addition & load/store address calculation)
                result = sum_result;
                overflow = sum_overflow;
            end
            4'b0110: begin // SUB (for subtraction & branch comparison)
                result = diff_result;
                overflow = diff_overflow;
                zero = (diff_result == 64'b0) ? 1'b1 : 1'b0; // For BEQ
            end
            4'b0000: begin // AND
                result = and_result;
                overflow = 1'b0;
            end
            4'b0001: begin // OR
                result = or_result;
                overflow = 1'b0;
            end
            default: begin
                result = 64'b0;
                overflow = 1'b0;
                zero = 1'b0;
            end
        endcase
    end
endmodule