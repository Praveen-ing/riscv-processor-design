module immediate_extractor (
    input  wire [31:0] instruction,   
    output reg signed [63:0] imm64          
);

    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b0100011: begin // Store (SD)
                // Sign-extend from bit 31 (the sign bit of instruction[31:25])
                imm64 = {{52{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end

            7'b0000011: begin // Load (LD)
                // Sign-extend from bit 31 (the sign bit of instruction[31:20])
                imm64 = {{52{instruction[31]}}, instruction[31:20]};
            end

            7'b1100011: begin
                imm64 = {{52{instruction[31]}},instruction[31:25],instruction[11:7]};
            end

            default:
                imm64 = 64'd0;
        endcase
    end

endmodule