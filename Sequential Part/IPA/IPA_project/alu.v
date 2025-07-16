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

