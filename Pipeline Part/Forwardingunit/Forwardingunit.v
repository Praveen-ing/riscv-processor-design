module ForwardingUnit 
(
    input wire [4:0] rs1, 
    input wire [4:0] rs2, 
    input wire [4:0] rd3, 
    input wire [4:0] rd4, 
    input wire WB3, 
    input wire WB4, 
    output reg [1:0] ForwardA, 
    output reg [1:0] ForwardB
);

always @(*) 
begin
    //No forwarding condn
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    // Check if rd3 is the destination and should be forwarded
    if (WB3 && (rd3 != 0)) begin
        if (rd3 == rs1) ForwardA = 2'b10; 
        if (rd3 == rs2) ForwardB = 2'b10;
    end

    // Check if rd4 is the destination and should be forwarded
    if (WB4 && (rd4 != 0)) begin
        if (rd4 == rs1) ForwardA = 2'b01;
        if (rd4 == rs2) ForwardB = 2'b01;
    end
end

endmodule
