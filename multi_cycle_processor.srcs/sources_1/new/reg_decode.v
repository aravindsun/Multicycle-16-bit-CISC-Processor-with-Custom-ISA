module reg_decode(
    input wire [2:0] rd,
    input wire [2:0] rs1,
    input wire [2:0] rs2,
    input wire       LOAD_RD,
    input wire       SEL_RS1,
    input wire       SEL_RS2,
    output reg R1_L, R2_L, R3_L, R4_L, R5_L, R6_L, R7_L, R8_L,
    output reg R1_E, R2_E, R3_E, R4_E, R5_E, R6_E, R7_E, R8_E
    );

    always@(*) begin
        {R1_L,R2_L,R3_L,R4_L,R5_L,R6_L,R7_L,R8_L} = 8'b0;
        if(LOAD_RD) begin
            case(rd)
                3'd0: R1_L = 1'b1;
                3'd1: R2_L = 1'b1;
                3'd2: R3_L = 1'b1;
                3'd3: R4_L = 1'b1;
                3'd4: R5_L = 1'b1;
                3'd5: R6_L = 1'b1;
                3'd6: R7_L = 1'b1;
                3'd7: R8_L = 1'b1;
            endcase
        end
    end

    always@(*) begin
        {R1_E,R2_E,R3_E,R4_E,R5_E,R6_E,R7_E,R8_E} = 8'b0;
        if(SEL_RS1) begin
            case(rs1)
                3'd0: R1_E = 1'b1;
                3'd1: R2_E = 1'b1;
                3'd2: R3_E = 1'b1;
                3'd3: R4_E = 1'b1;
                3'd4: R5_E = 1'b1;
                3'd5: R6_E = 1'b1;
                3'd6: R7_E = 1'b1;
                3'd7: R8_E = 1'b1;
            endcase
        end
        else if(SEL_RS2) begin
            case(rs2)
                3'd0: R1_E = 1'b1;
                3'd1: R2_E = 1'b1;
                3'd2: R3_E = 1'b1;
                3'd3: R4_E = 1'b1;
                3'd4: R5_E = 1'b1;
                3'd5: R6_E = 1'b1;
                3'd6: R7_E = 1'b1;
                3'd7: R8_E = 1'b1;
            endcase
        end
    end
endmodule