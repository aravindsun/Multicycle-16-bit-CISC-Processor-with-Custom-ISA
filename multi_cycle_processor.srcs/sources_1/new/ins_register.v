module ins_register(
    input wire clk,
    input wire rst,
    input wire IR_L,
    input wire [15:0]INS_IN,
    output reg [15:0]INS_OUT
    );
    
    always@(posedge clk) begin
        if(rst) INS_OUT <= 16'b0;
        else if(IR_L) INS_OUT <= INS_IN;
    end
endmodule
