module ALU(
    input wire clk,
    input wire rst,
    input wire TR1_L, TR2_L,
    input wire AL_E,
    input wire [2:0]AL_S,        
    input wire [15:0]ALU_IN,
    output wire [15:0]ALU_OUT,
    output reg CARRY,        
    output wire ZERO
    );
    
    reg [15:0]TR1, TR2;
    reg [16:0]ALU_TMP;
    reg carry_comb;

    always@(posedge clk) begin
        if(rst) begin
            TR1 <= 16'b0;
            TR2 <= 16'b0;
        end
        else if(TR1_L) TR1 <= ALU_IN;
        else if(TR2_L) TR2 <= ALU_IN;
    end
    
    always@(*) begin
        case(AL_S)
            3'b000 : ALU_TMP = {1'b0, TR1} + {1'b0, TR2};// ADD
            3'b001 : ALU_TMP = {1'b0, TR1} - {1'b0, TR2};// SUB
            3'b010 : ALU_TMP = {1'b0, TR1} + 17'b1;// INC
            3'b011 : ALU_TMP = {1'b0, TR1} - 17'b1;// DEC
            3'b100 : ALU_TMP = {TR1[15:0], 1'b0};// SHIFTL: shift left, MSB -> carry
            3'b101 : ALU_TMP = {TR1[0], CARRY, TR1[15:1]};// RRC: rotate right through carry
            default : ALU_TMP = 17'b0;
        endcase
    end  

    always@(posedge clk) begin
        if(rst) CARRY <= 1'b0;
        else if(AL_E)    CARRY <= ALU_TMP[16];
    end

    assign ALU_OUT = ALU_TMP[15:0]; 
    assign ZERO = ~(|ALU_OUT);  

endmodule