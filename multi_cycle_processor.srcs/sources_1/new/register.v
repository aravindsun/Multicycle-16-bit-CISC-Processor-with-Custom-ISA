module register(
  input wire clk,
  input wire rst,
  input wire R_L,
  input wire[15:0]D_IN,
  output reg[15:0]D_OUT
);
  
  always@(posedge clk) begin
    if(rst) D_OUT <= 16'b0;
    else if(R_L)
      D_OUT <= D_IN;
  end 
  
endmodule