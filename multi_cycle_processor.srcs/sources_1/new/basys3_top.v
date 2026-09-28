module basys3_top(
    input  wire clk,          // 100 MHz onboard clock
    input  wire rst,          // BTN or SW connected to reset
    output wire [15:0] led,   // R1 (remainder) on LEDs
    output wire [6:0]  seg,   // seven-segment cathodes
    output reg [3:0]  an     // seven-segment anodes (digit select)
    );

    wire [15:0] R1_val, R3_val;

    top cpu_inst(
        .clk(clk),
        .rst(rst)
    );

    assign R1_val = cpu_inst.rbank.D_OUT1;
    assign R3_val = cpu_inst.rbank.D_OUT3;

    // R1 (remainder) directly on LEDs
    assign led = R1_val;

    // ---- 7-segment display of R3 (quotient), 4 hex digits, multiplexed ----
    reg [19:0] refresh_cnt;
    wire [1:0] digit_sel;
    reg [3:0]  nibble;
    reg [6:0]  seg_pattern;

    always @(posedge clk or posedge rst) begin
        if (rst) refresh_cnt <= 20'b0;
        else     refresh_cnt <= refresh_cnt + 1'b1;
    end

    assign digit_sel = refresh_cnt[19:18]; // ~190Hz per-digit refresh rate

    always @(*) begin
        case(digit_sel)
            2'b00: nibble = R3_val[3:0];
            2'b01: nibble = R3_val[7:4];
            2'b10: nibble = R3_val[11:8];
            2'b11: nibble = R3_val[15:12];
        endcase
    end

    always @(*) begin
        case(digit_sel)
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
            default: an = 4'b1111;
        endcase
    end

    // Active-low common-anode 7-seg hex decoder
    always @(*) begin
        case(nibble)
            4'h0: seg_pattern = 7'b1000000;
            4'h1: seg_pattern = 7'b1111001;
            4'h2: seg_pattern = 7'b0100100;
            4'h3: seg_pattern = 7'b0110000;
            4'h4: seg_pattern = 7'b0011001;
            4'h5: seg_pattern = 7'b0010010;
            4'h6: seg_pattern = 7'b0000010;
            4'h7: seg_pattern = 7'b1111000;
            4'h8: seg_pattern = 7'b0000000;
            4'h9: seg_pattern = 7'b0010000;
            4'hA: seg_pattern = 7'b0001000;
            4'hB: seg_pattern = 7'b0000011;
            4'hC: seg_pattern = 7'b1000110;
            4'hD: seg_pattern = 7'b0100001;
            4'hE: seg_pattern = 7'b0000110;
            4'hF: seg_pattern = 7'b0001110;
            default: seg_pattern = 7'b1111111;
        endcase
    end

    assign seg = seg_pattern;

endmodule