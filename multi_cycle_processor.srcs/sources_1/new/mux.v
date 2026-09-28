module mux(
    input wire RD_N,
    input wire PC_E,
    input wire R_E,
    input wire AL_E,
    input wire [15:0]MEM_OUT,
    input wire [15:0]PC_OUT,
    input wire [15:0]D_OUT,
    input wire [15:0]ALU_OUT,
    output reg [15:0]D
    );
    
    always@(*) begin
        if(~RD_N) D = MEM_OUT;
        else if(PC_E) D = PC_OUT;
        else if(R_E) D = D_OUT;
        else if(AL_E) D = ALU_OUT;
        else D = 16'b0;
    end        
endmodule
