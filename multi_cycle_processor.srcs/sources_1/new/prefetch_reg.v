module prefetch_reg(
    input wire clk,
    input wire rst,
    input wire IPR_L,
    input wire [15:0]PRE_IN,
    output reg [15:0]PRE_OUT
    );
    
    always@(posedge clk) begin
        if(rst) PRE_OUT <= 16'b0;
        else if(IPR_L) PRE_OUT <= PRE_IN;
    end
endmodule
