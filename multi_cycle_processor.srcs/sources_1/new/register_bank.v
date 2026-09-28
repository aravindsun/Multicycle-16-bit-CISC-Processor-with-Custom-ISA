`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2026 21:30:17
// Design Name: 
// Module Name: register_bank
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_bank(
    input wire clk,
    input wire rst,
    input wire R1_L, R2_L, R3_L, R4_L, R5_L, R6_L,
               R7_L, R8_L,
    input wire R1_E, R2_E, R3_E, R4_E, R5_E, R6_E,
               R7_E, R8_E,
    input wire [15:0]D_IN,
    output reg [15:0]D_OUT         
    );
    
    wire [15:0]D_OUT1, D_OUT2, D_OUT3, D_OUT4,
               D_OUT5, D_OUT6, D_OUT7, D_OUT8;
               
    register r1(.clk(clk), .rst(rst), .R_L(R1_L), .D_IN(D_IN), .D_OUT(D_OUT1));
    register r2(.clk(clk), .rst(rst), .R_L(R2_L), .D_IN(D_IN), .D_OUT(D_OUT2));
    register r3(.clk(clk), .rst(rst), .R_L(R3_L), .D_IN(D_IN), .D_OUT(D_OUT3));
    register r4(.clk(clk), .rst(rst), .R_L(R4_L), .D_IN(D_IN), .D_OUT(D_OUT4));
    register r5(.clk(clk), .rst(rst), .R_L(R5_L), .D_IN(D_IN), .D_OUT(D_OUT5));
    register r6(.clk(clk), .rst(rst), .R_L(R6_L), .D_IN(D_IN), .D_OUT(D_OUT6));
    register r7(.clk(clk), .rst(rst), .R_L(R7_L), .D_IN(D_IN), .D_OUT(D_OUT7));
    register r8(.clk(clk), .rst(rst), .R_L(R8_L), .D_IN(D_IN), .D_OUT(D_OUT8));
    
    always@(*) begin
        case({R1_E, R2_E, R3_E, R4_E, R5_E, R6_E,R7_E, R8_E})
            8'b10000000 : D_OUT = D_OUT1;
            8'b01000000 : D_OUT = D_OUT2;
            8'b00100000 : D_OUT = D_OUT3;
            8'b00010000 : D_OUT = D_OUT4;
            8'b00001000 : D_OUT = D_OUT5;
            8'b00000100 : D_OUT = D_OUT6;
            8'b00000010 : D_OUT = D_OUT7;
            8'b00000001 : D_OUT = D_OUT8;
            default : D_OUT = 8'b0;
        endcase
    end                   
endmodule
