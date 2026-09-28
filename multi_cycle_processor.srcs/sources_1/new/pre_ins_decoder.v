module pre_ins_decoder(
    input wire clk,
    input wire rst,
    input wire IPR_L,
    input wire IR_L,
    input wire [15:0]PRE_IN,
    output wire [4:0] opcode,
    output wire [2:0] rd,
    output wire [2:0] rs2,
    output wire [2:0] rs1,
    output wire [4:0] address
    );
    
    wire [15:0]TMP, INS_OUT;
    prefetch_reg uut1(.clk(clk), .rst(rst), .IPR_L(IPR_L), .PRE_IN(PRE_IN), .PRE_OUT(TMP));
    ins_register uut2(.clk(clk), .rst(rst), .IR_L(IR_L), .INS_IN(TMP), .INS_OUT(INS_OUT));
    
    assign opcode  = INS_OUT[15:11];
    assign rd      = INS_OUT[10:8];
    assign rs2     = INS_OUT[7:5];
    assign rs1     = INS_OUT[4:2];
    assign address = INS_OUT[4:0];
    
endmodule
