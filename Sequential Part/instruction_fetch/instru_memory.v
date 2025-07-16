module instruction_memory (
    input [63:0] PC,     
    input clk,          
    output reg [31:0] instruction
);

    reg [7:0] memory [0:1023];

    
    initial begin
        memory[0] = 8'h20;
        memory[1] = 8'h13;
        memory[2] = 8'h24;
        memory[3] = 8'h30;
        memory[4] = 8'h25;
        memory[5] = 8'h40;
        memory[6] = 8'h40;
        memory[7] = 8'h40;
        memory[8] = 8'h40;
        memory[9] = 8'h40;
        memory[10] = 8'h40;
        memory[11] = 8'h40;
        memory[12] = 8'h40;
        memory[13] = 8'h40;
        memory[14] = 8'h40;
        memory[15] = 8'h40;
        memory[16] = 8'h40;
        memory[17] = 8'h40;
        memory[18] = 8'h40;
        memory[19] = 8'h40;
    end

    

    reg [5:0] rs2;
    initial begin
        rs2 = 6'd2;
    end
    wire [63:0] A1;
    LeftShift sll (.A(PC), .B(rs2), .Result(A1));

    wire [63:0] A2;
    wire [63:0] A3;
    wire [63:0] A4;

    wire overflow1;
    wire overflow2;
    wire overflow3;

    Cla64bit  add (.A(A1), .B(64'b1), .Sum(A2), .overflow(overflow1));
    Cla64bit  add1 (.A(A1), .B(64'b10), .Sum(A3), .overflow(overflow2));
    Cla64bit  add2 (.A(A1), .B(64'b11), .Sum(A4), .overflow(overflow3));


    always @(posedge clk) begin
        instruction = {memory[A4], memory[A3], memory[A2], memory[A1]}; 
    end

endmodule
