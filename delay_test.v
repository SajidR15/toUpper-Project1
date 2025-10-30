`timescale 1ns / 1ps

module delay_test;
    reg [7:0] A;
    wire [7:0] Y;
    
    integer delay;
    integer errors;
    integer i;
    integer j;
    
    toUpper uut (.A(A), .Y(Y));
    
    initial begin
        $display("Finding minimum working delay...");
        $display("Delay(ns)  Result");
        $display("-----------------");
        
        // Test delays from 60ns down to 10ns
        for (delay = 60; delay >= 10; delay = delay - 5) begin
            errors = 0;
            
            // Test critical cases that exercise the longest paths
            A = 8'd97;  #delay; if (Y !== 8'd65) errors = errors + 1;  // a->A
            A = 8'd122; #delay; if (Y !== 8'd90) errors = errors + 1;  // z->Z  
            A = 8'd109; #delay; if (Y !== 8'd77) errors = errors + 1;  // m->M
            A = 8'd65;  #delay; if (Y !== 8'd65) errors = errors + 1;  // A->A
            A = 8'd72;  #delay; if (Y !== 8'd72) errors = errors + 1;  // H->H
            
            if (errors == 0) begin
                $display("  %0d        PASS", delay);
            end else begin
                $display("  %0d        FAIL (%0d errors)", delay, errors);
            end
            
            #20; // Small gap between delay tests
        end
        
        $display("-----------------");
        $display("Minimum working delay is the smallest PASS value above");
        #10 $finish;
    end
endmodule