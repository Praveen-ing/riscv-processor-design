module tb_mux3to1;

    reg
 [63:0] A, B, C;    // Inputs
    reg [1:0] sel;         // Select lines
    wire [63:0] out;       // Output

    // Instantiate the MUX module
    mux3to1 uut (
        .A(A),
        .B(B),
        .C(C),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Assign test values
        A = 64'hAAAAAAAAAAAAAAAA;  // Input A
        B = 64'hBBBBBBBBBBBBBBBB;  // Input B
        C = 64'hCCCCCCCCCCCCCCCC;  // Input C

        // Select A (sel = 00)
        sel = 2'b00; #10;
        $display("sel = %b, out = %h (Expected: %h)", sel, out, A);
        
        // Select B (sel = 01)
        sel = 2'b01; #10;
        $display("sel = %b, out = %h (Expected: %h)", sel, out, B);
        
        // Select C (sel = 10)
        sel = 2'b10; #10;
        $display("sel = %b, out = %h (Expected: %h)", sel, out, C);

        // Default case (should be 0, but sel = 11 is undefined in mux)
        sel = 2'b11; #10;
        $display("sel = %b, out = %h (Expected: Undefined or 0)", sel, out);

        // End simulation
        $finish;
    end

endmodule
