`timescale 1ns / 1ps

module stress_test;
    reg [7:0] A;
    wire [7:0] Y;
    
    integer i;
    integer errors;
    reg [7:0] test_inputs [0:18];
    reg [7:0] expected [0:18];
    
    toUpper uut (.A(A), .Y(Y));
    
    initial begin
        // Initialize test vectors
        test_inputs[0] = 8'd40;   expected[0] = 8'd40;   // (
        test_inputs[1] = 8'd72;   expected[1] = 8'd72;   // H
        test_inputs[2] = 8'd183;  expected[2] = 8'd183;  // ·
        test_inputs[3] = 8'd131;  expected[3] = 8'd131;  // ƒ
        test_inputs[4] = 8'd124;  expected[4] = 8'd124;  // |
        test_inputs[5] = 8'd20;   expected[5] = 8'd20;   // DC4
        test_inputs[6] = 8'd235;  expected[6] = 8'd235;  // ë
        test_inputs[7] = 8'd97;   expected[7] = 8'd65;   // a -> A
        test_inputs[8] = 8'd65;   expected[8] = 8'd65;   // A -> A
        test_inputs[9] = 8'd122;  expected[9] = 8'd90;   // z -> Z
        test_inputs[10] = 8'd71;  expected[10] = 8'd71;  // G
        test_inputs[11] = 8'd109; expected[11] = 8'd77;  // m -> M
        test_inputs[12] = 8'd146; expected[12] = 8'd146; // '
        test_inputs[13] = 8'd48;  expected[13] = 8'd48;  // 0
        test_inputs[14] = 8'd207; expected[14] = 8'd207; // Ï
        test_inputs[15] = 8'd58;  expected[15] = 8'd58;  // :
        test_inputs[16] = 8'd123; expected[16] = 8'd123; // {
        test_inputs[17] = 8'd148; expected[17] = 8'd148; // ”
        test_inputs[18] = 8'd127; expected[18] = 8'd127; // DEL
        
        $dumpfile("stress_waveform.vcd");
        $dumpvars(0, stress_test);
        
        errors = 0;
        
        $display("==========================================");
        $display("    STRESS TEST at Minimum Delay (45ns)");
        $display("==========================================");
        $display("Time\tInput\tOutput\tExpected\tStatus");
        $display("-----\t-----\t------\t--------\t------");
        
        for (i = 0; i < 19; i = i + 1) begin
            A = test_inputs[i];
            #45; // Test at minimum working delay
            
            if (Y === expected[i]) begin
                $display("%4d\t%3d\t%3d\t%3d\t\tPASS", $time, A, Y, expected[i]);
            end else begin
                $display("%4d\t%3d\t%3d\t%3d\t\tFAIL", $time, A, Y, expected[i]);
                errors = errors + 1;
            end
        end
        
        $display("==========================================");
        if (errors == 0) begin
            $display("STRESS TEST PASSED at 45ns delay!");
        end else begin
            $display("STRESS TEST FAILED: %0d errors at 45ns delay", errors);
        end
        $display("==========================================");
        
        #10 $finish;
    end
endmodule