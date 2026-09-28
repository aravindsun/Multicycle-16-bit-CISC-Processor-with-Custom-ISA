module PC(
    input wire clk,
    input wire rst,
    input wire PC_L,
    input wire PC_INC,
    input wire [15:0]PC_IN,
    output reg [15:0]PC_OUT
    );
    
    always@(posedge clk) begin
        if(rst) PC_OUT <= 16'b0;
        else begin
            if(PC_L) PC_OUT <= PC_IN;
            else if(PC_INC) PC_OUT <= PC_OUT + 16'b1;   
        end   
    end
    
endmodule
