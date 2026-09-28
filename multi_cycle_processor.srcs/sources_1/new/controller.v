module controller(
    input wire clk,
    input wire rst,
    input wire [4:0] opcode,
    input wire CARRY,
    input wire ZERO,

    output reg PC_L, PC_INC,
    output reg IPR_L, IR_L,
    output reg RD_N, WR_N,
    output reg PC_E, AL_E,
    output reg TR1_L, TR2_L,
    output reg [2:0] AL_S,
    output reg SEL_RS1, SEL_RS2,
    output reg LOAD_RD,
    output reg MEM_ADDR_SEL,
    output reg MEM_IN_SEL
    );

    localparam OP_ADD    = 5'b00000;
    localparam OP_SUB    = 5'b00001;
    localparam OP_LD     = 5'b00010;
    localparam OP_ST     = 5'b00011;
    localparam OP_INC    = 5'b00100;
    localparam OP_DEC    = 5'b00101;
    localparam OP_SHIFTL = 5'b00110;
    localparam OP_RRC    = 5'b00111;
    localparam OP_JMP    = 5'b01000;
    localparam OP_JZ     = 5'b01001;
    localparam OP_JNZ    = 5'b01010;
    localparam OP_JC     = 5'b01011;
    localparam OP_JNC    = 5'b01100;

    localparam S_FETCH1  = 0;
    localparam S_FETCH2  = 1;
    localparam S_DECODE  = 2;
    localparam S_LD1     = 3;
    localparam S_ST1     = 4;
    localparam S_ALU_T1  = 5;
    localparam S_ALU_T2  = 6;
    localparam S_ALU_WB  = 7;
    localparam S_JMP     = 8;
    localparam S_JCOND   = 9;

    reg [3:0] state, next_state;

    always@(posedge clk) begin
        if(rst) state <= S_FETCH1;
        else    state <= next_state;
    end

    always@(*) begin
        PC_L = 0; PC_INC = 0;
        IPR_L = 0; IR_L = 0;
        RD_N = 1; WR_N = 1;
        PC_E = 0; AL_E = 0;
        TR1_L = 0; TR2_L = 0;
        AL_S = 3'b000;
        SEL_RS1 = 0; SEL_RS2 = 0;
        LOAD_RD = 0;
        MEM_ADDR_SEL = 0;
        MEM_IN_SEL = 0;
        next_state = state;

        case(state)

            S_FETCH1: begin
                RD_N = 0;
                MEM_ADDR_SEL = 0;
                IPR_L = 1;
                PC_INC = 1;
                next_state = S_FETCH2;
            end


            S_FETCH2: begin
                IR_L = 1;
                next_state = S_DECODE;
            end


            S_DECODE: begin
                RD_N = 0;
                MEM_ADDR_SEL = 0;
                IPR_L = 1;
                PC_INC = 1;

                case(opcode)
                    OP_LD:  next_state = S_LD1;
                    OP_ST:  next_state = S_ST1;
                    OP_ADD, OP_SUB: next_state = S_ALU_T1;
                    OP_INC, OP_DEC, OP_SHIFTL, OP_RRC: next_state = S_ALU_T1;
                    OP_JMP: next_state = S_JMP;
                    OP_JZ, OP_JNZ, OP_JC, OP_JNC: next_state = S_JCOND;
                    default: next_state = S_FETCH2;
                endcase
            end

            S_LD1: begin
                LOAD_RD = 1;
                RD_N = 0;
                MEM_ADDR_SEL = 1;
                next_state = S_FETCH2;
            end

            S_ST1: begin
                WR_N = 0;
                MEM_ADDR_SEL = 1;
                MEM_IN_SEL = 1;
                next_state = S_FETCH2;
            end

            S_ALU_T1: begin
                SEL_RS1 = 1;
                TR1_L = 1;
                if(opcode == OP_ADD || opcode == OP_SUB)
                    next_state = S_ALU_T2;
                else
                    next_state = S_ALU_WB;
            end
            S_ALU_T2: begin
                SEL_RS2 = 1;
                TR2_L = 1;
                next_state = S_ALU_WB;
            end
            S_ALU_WB: begin
                AL_E = 1;
                LOAD_RD = 1;
                case(opcode)
                    OP_ADD:    AL_S = 3'b000;
                    OP_SUB:    AL_S = 3'b001;
                    OP_INC:    AL_S = 3'b010;
                    OP_DEC:    AL_S = 3'b011;
                    OP_SHIFTL: AL_S = 3'b100;
                    OP_RRC:    AL_S = 3'b101;
                    default:   AL_S = 3'b000;
                endcase
                next_state = S_FETCH2;
            end

            S_JMP: begin
                PC_L = 1;
                next_state = S_FETCH1;
            end

            S_JCOND: begin
                if((opcode == OP_JZ  && ZERO)   ||
                   (opcode == OP_JNZ && ~ZERO)  ||
                   (opcode == OP_JC  && CARRY)  ||
                   (opcode == OP_JNC && ~CARRY)) begin
                    PC_L = 1;
                    next_state = S_FETCH1;
                end
                else begin
                    next_state = S_FETCH2;
                end
            end

            default: next_state = S_FETCH1;
        endcase
    end
endmodule