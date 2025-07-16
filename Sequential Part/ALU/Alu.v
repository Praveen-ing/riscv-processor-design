// Compile: iverilog -o Alu_tb.vvp Alu_tb.v Alu.v
// Run: vvp Alu_tb.vvp
// View Waveform: gtkwave Alu_tb.vcd

module FullAdder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire w1, w2, w3;
    xor g1(w1, a, b);
    xor g2(sum, w1, cin);
    and g3(w2, a, b);
    and g4(w3, w1, cin);
    or  g5(cout, w2, w3);
endmodule

module OverflowDetector (
    input a_sign,
    input b_sign,
    input diff_sign,
    output overflow
);
    wire w1, w2;
    and g1(w1, ~a_sign, b_sign, diff_sign);
    and g2(w2, a_sign, ~b_sign, ~diff_sign);
    or g3(overflow, w1, w2);
endmodule

module adder_64bit (
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [63:0] sum,
    output cout,
    output overflow
);
    wire [64:0] c;
    assign c[0] = cin;
    assign cout = c[64];
    xor(overflow, c[64], c[63]);
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen
            FullAdder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout(c[i+1])
            );
        end
    endgenerate
endmodule

module Subtractor_64bit (
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [63:0] diff,
    output cout,
    output overflow
);
    wire [64:0] c;
    assign c[0] = cin;
    assign cout = c[64];
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen
            FullAdder fs (
                .a(a[i]),
                .b(~b[i]),
                .cin(c[i]),
                .sum(diff[i]),
                .cout(c[i+1])
            );
        end
    endgenerate
    
    OverflowDetector ovf (
        .a_sign(a[63]),
        .b_sign(b[63]),
        .diff_sign(diff[63]),
        .overflow(overflow)
    );
endmodule

module And_64bit (
    input [63:0] a,
    input [63:0] b,
    output [63:0] result
);
    genvar i;
    generate
        for(i=0; i<64; i=i+1) begin: And_block
            and And_inst(result[i], a[i], b[i]);
        end
    endgenerate
endmodule

module Or_64bit (
    input [63:0] a,
    input [63:0] b,
    output [63:0] result
);
    genvar i;
    generate
        for(i=0; i<64; i=i+1) begin: Or_block
            or Or_inst(result[i], a[i], b[i]);
        end
    endgenerate
endmodule

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
            4'b0000: begin // ADD (for addition & load/store address calculation)
                result = sum_result;
                overflow = sum_overflow;
            end
            4'b0001: begin // SUB (for subtraction & branch comparison)
                result = diff_result;
                overflow = diff_overflow;
                zero = (diff_result == 64'b0) ? 1'b1 : 1'b0; // For BEQ
            end
            4'b0010: begin // AND
                result = and_result;
                overflow = 1'b0;
            end
            4'b0011: begin // OR
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
