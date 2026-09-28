module memory(
    input  wire        clk,
    input  wire        WR_N,
    input  wire [5:0]  ADDR,
    input  wire [15:0] MEM_IN,
    output wire [15:0] MEM_OUT
    );

    // Instantiate the Distributed Memory Generator IP
    dist_mem_gen_0 u_mem (
        .a   (ADDR),     // address input
        .d   (MEM_IN),   // data input
        .clk (clk),      // clock
        .we  (~WR_N),    // write enable (active high in IP, so invert WR_N)
        .spo (MEM_OUT)   // single-port output
    );

endmodule
