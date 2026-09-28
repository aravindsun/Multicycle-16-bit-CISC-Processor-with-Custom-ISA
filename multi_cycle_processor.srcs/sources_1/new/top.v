module top(
    input wire clk,
    input wire rst
    );

    wire [15:0] PC_OUT, D, ALU_OUT, MEM_OUT, D_OUT;
    wire [4:0] opcode, address;
    wire [2:0] rd, rs1, rs2;
    wire CARRY, ZERO;

    wire PC_L, PC_INC, IPR_L, IR_L, RD_N, WR_N, PC_E, AL_E;
    wire TR1_L, TR2_L;
    wire [2:0] AL_S;
    wire SEL_RS1, SEL_RS2, LOAD_RD, MEM_ADDR_SEL, MEM_IN_SEL;

    wire R1_L, R2_L, R3_L, R4_L, R5_L, R6_L, R7_L, R8_L;
    wire R1_E, R2_E, R3_E, R4_E, R5_E, R6_E, R7_E, R8_E;

    wire [5:0] mem_addr;
    wire [15:0] mem_in;

    assign mem_addr = MEM_ADDR_SEL ? {1'b0, address} : PC_OUT[5:0];
    assign mem_in = D;

    controller ctrl(
        .clk(clk), .rst(rst), .opcode(opcode), .CARRY(CARRY), .ZERO(ZERO),
        .PC_L(PC_L), .PC_INC(PC_INC), .IPR_L(IPR_L), .IR_L(IR_L),
        .RD_N(RD_N), .WR_N(WR_N), .PC_E(PC_E), .AL_E(AL_E),
        .TR1_L(TR1_L), .TR2_L(TR2_L), .AL_S(AL_S),
        .SEL_RS1(SEL_RS1), .SEL_RS2(SEL_RS2), .LOAD_RD(LOAD_RD),
        .MEM_ADDR_SEL(MEM_ADDR_SEL), .MEM_IN_SEL(MEM_IN_SEL)
    );

    reg_decode rdec(
        .rd(rd), .rs1(rs1), .rs2(rs2),
        .LOAD_RD(LOAD_RD),
        .SEL_RS1(SEL_RS1),
        .SEL_RS2(SEL_RS2 | MEM_IN_SEL),
        .R1_L(R1_L), .R2_L(R2_L), .R3_L(R3_L), .R4_L(R4_L),
        .R5_L(R5_L), .R6_L(R6_L), .R7_L(R7_L), .R8_L(R8_L),
        .R1_E(R1_E), .R2_E(R2_E), .R3_E(R3_E), .R4_E(R4_E),
        .R5_E(R5_E), .R6_E(R6_E), .R7_E(R7_E), .R8_E(R8_E)
    );

    register_bank rbank(
        .clk(clk),.rst(rst),
        .R1_L(R1_L), .R2_L(R2_L), .R3_L(R3_L), .R4_L(R4_L),
        .R5_L(R5_L), .R6_L(R6_L), .R7_L(R7_L), .R8_L(R8_L),
        .R1_E(R1_E), .R2_E(R2_E), .R3_E(R3_E), .R4_E(R4_E),
        .R5_E(R5_E), .R6_E(R6_E), .R7_E(R7_E), .R8_E(R8_E),
        .D_IN(D),
        .D_OUT(D_OUT)
    );

    memory mem(
        .clk(clk), .WR_N(WR_N), .ADDR(mem_addr),
        .MEM_IN(mem_in), .MEM_OUT(MEM_OUT)
    );

    PC pc_reg(
        .clk(clk), .rst(rst), .PC_L(PC_L), .PC_INC(PC_INC),
        .PC_IN({11'b0, address}), .PC_OUT(PC_OUT)
    );

    ALU alu(
        .clk(clk), .rst(rst), .TR1_L(TR1_L), .TR2_L(TR2_L), .AL_E(AL_E),
        .AL_S(AL_S), .ALU_IN(D), .ALU_OUT(ALU_OUT),
        .CARRY(CARRY), .ZERO(ZERO)
    );

    pre_ins_decoder decoder(
        .clk(clk), .rst(rst), .IPR_L(IPR_L), .IR_L(IR_L),
        .PRE_IN(MEM_OUT),
        .opcode(opcode), .rd(rd), .rs2(rs2), .rs1(rs1), .address(address)
    );

    mux datamux(
        .RD_N(RD_N), .PC_E(PC_E),
        .R_E(SEL_RS1 | SEL_RS2 | MEM_IN_SEL),
        .AL_E(AL_E),
        .MEM_OUT(MEM_OUT), .PC_OUT(PC_OUT),
        .D_OUT(D_OUT),
        .ALU_OUT(ALU_OUT),
        .D(D)
    );

endmodule