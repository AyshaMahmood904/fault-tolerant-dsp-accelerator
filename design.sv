// ============================================
// FIR Accelerator
// ============================================

module fir_accelerator (
    input logic clk,
    input logic reset,
    input logic signed [7:0] x_in,
    output logic signed [17:0] y_out
);

    logic signed [7:0] x1, x2, x3;

    localparam logic signed [7:0] H0 = 1;
    localparam logic signed [7:0] H1 = 2;
    localparam logic signed [7:0] H2 = 3;
    localparam logic signed [7:0] H3 = 4;

    logic signed [15:0] mult0;
    logic signed [15:0] mult1;
    logic signed [15:0] mult2;
    logic signed [15:0] mult3;

    logic signed [16:0] sum01;
    logic signed [16:0] sum23;
    logic signed [17:0] final_sum;

    assign mult0 = x_in * H0;
    assign mult1 = x1 * H1;
    assign mult2 = x2 * H2;
    assign mult3 = x3 * H3;

    assign sum01 = $signed(mult0) + $signed(mult1);
    assign sum23 = $signed(mult2) + $signed(mult3);

    assign final_sum = $signed(sum01) + $signed(sum23);

    always_ff @(posedge clk) begin
        if (reset) begin
            x1 <= 0;
            x2 <= 0;
            x3 <= 0;
            y_out <= 0;
        end
        else begin
            y_out <= final_sum;
            x3 <= x2;
            x2 <= x1;
            x1 <= x_in;
        end
    end

endmodule


// ============================================
// Triple Modular Redundancy FIR
// ============================================

module tmr_fir (
    input logic clk,
    input logic reset,
    input logic signed [7:0] x_in,
    input logic fault_enable,
    output logic signed [17:0] y_out,
    output logic fault_detected
);

    logic signed [17:0] y0;
    logic signed [17:0] y1;
    logic signed [17:0] y2;

    logic signed [17:0] y0_correct;

    // Three FIR accelerator copies
    fir_accelerator FIR0 (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_out(y0_correct)
    );

    fir_accelerator FIR1 (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_out(y1)
    );

    fir_accelerator FIR2 (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_out(y2)
    );

    // Fault injection into FIR0
    always_comb begin
        if (fault_enable)
            y0 = y0_correct + 8;
        else
            y0 = y0_correct;
    end

    // Majority voter
    always_comb begin
        if (y0 == y1)
            y_out = y0;
        else if (y0 == y2)
            y_out = y0;
        else
            y_out = y1;
    end

    // Fault detector
    always_comb begin
        if ((y0 != y1) || (y0 != y2) || (y1 != y2))
            fault_detected = 1;
        else
            fault_detected = 0;
    end

endmodule