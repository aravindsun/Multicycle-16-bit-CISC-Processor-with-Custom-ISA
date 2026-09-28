`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2026 18:48:28
// Design Name: 
// Module Name: tb_top
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

`timescale 1ns/1ps

module tb_top;

  reg clk;
  reg rst;

  // Instantiate the DUT (Device Under Test)
  top uut1 (
    .clk(clk),
    .rst(rst)
  );

  // Clock generation: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset sequence
  initial begin
    rst = 1;          // Assert reset
    #40 rst = 0;      // Deassert reset after 10 ns
  end

  // Optional: simulation stop
  initial begin
    #100000 $finish;     // End simulation after 2000 ns
  end

endmodule

