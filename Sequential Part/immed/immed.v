module immediate_extractor (
    input  wire [31:0] instruction,   
    output reg  [63:0] imm64          
);

    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b0100011: // Store (SD)
                imm64 = {52'b0, instruction[31:25], instruction[11:7]};

            7'b0000011: // Load (LD)
                imm64 = {52'b0, instruction[31:20]};

            default:
                imm64 = 64'd0;
        endcase
    end

endmodule
