module tb_fir_filter;

    logic clk;
    logic reset;
    logic signed [7:0] x_in;
    logic signed [17:0] y_out;
    logic fault_enable;
    logic fault_detected;

    integer test_count;
    integer pass_count;

    // TMR DUT
    tmr_fir DUT (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .fault_enable(fault_enable),
        .y_out(y_out),
        .fault_detected(fault_detected)
    );

    // Clock
    always #5 clk = ~clk;

    // Waveform
    initial begin
        $dumpfile("tmr_fault_detector.vcd");
        $dumpvars(0, tb_fir_filter);
    end

    // Output checking
    task check_output(input integer expected_value);
        begin
            #1;
            test_count = test_count + 1;

            if (y_out == expected_value) begin
                $display("TEST %0d : PASS | Expected = %0d | Actual = %0d",
                         test_count, expected_value, y_out);
                pass_count = pass_count + 1;
            end
            else begin
                $display("TEST %0d : FAIL | Expected = %0d | Actual = %0d",
                         test_count, expected_value, y_out);
            end
        end
    endtask

    initial begin

        clk = 0;
        reset = 1;
        x_in = 0;
        fault_enable = 0;

        test_count = 0;
        pass_count = 0;

        // Reset
        #12;
        reset = 0;

        // Test 1
        #8 x_in = 1;
        #10;
        check_output(1);

        // Test 2
        x_in = 2;
        #10;
        check_output(4);

        // Test 3
        x_in = 3;
        #10;
        check_output(10);

        // Test 4
        x_in = 4;
        #10;
        check_output(20);

        // Test 5
        x_in = 5;
        #10;
        check_output(30);

        #10;

        // ========================================
        // Fault Injection Test
        // ========================================

        fault_enable = 1;

        x_in = 6;
        #10;

        $display("--------------------------------");
        $display("FAULT INJECTION TEST");
        $display("Fault Enabled  = %0d", fault_enable);
        $display("Fault Detected = %0d", fault_detected);
        $display("Final Output   = %0d", y_out);
        $display("--------------------------------");

        fault_enable = 0;

        #10;

        // Final summary
        $display("--------------------------------");
        $display("TMR Verification Complete");
        $display("Tests Passed = %0d / %0d",
                 pass_count, test_count);
        $display("--------------------------------");

        $finish;

    end

endmodule