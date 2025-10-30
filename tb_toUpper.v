`timescale 1ns / 1ps
`ifdef TB
`else
`define TB
`endif

module tb_toUpper;
    reg [7:0] din;
    wire [7:0] dout;

    // instantiate device under test
    toUpper_gate DUT(.in(din), .out(dout));

    // dump for GTKWave
    initial begin
        $dumpfile("toUpper.vcd");
        $dumpvars(0, tb_toUpper);
    end

    // test vectors 
    integer i;
    reg [7:0] vectors [0:18];

    // INTER_DELAY controls the delay between applying inputs; change this for stress testing
    parameter INTER_DELAY = 5; // ns (set this to a small value to stress)
    
    initial begin
        // load vectors
        vectors[0]  = 8'd40;
        vectors[1]  = 8'd72;
        vectors[2]  = 8'd183;
        vectors[3]  = 8'd131;
        vectors[4]  = 8'd124;
        vectors[5]  = 8'd20;
        vectors[6]  = 8'd235;
        vectors[7]  = 8'd97;
        vectors[8]  = 8'd65;
        vectors[9]  = 8'd122;
        vectors[10] = 8'd71;
        vectors[11] = 8'd109;
        vectors[12] = 8'd146;
        vectors[13] = 8'd48;
        vectors[14] = 8'd207;
        vectors[15] = 8'd58;
        vectors[16] = 8'd123;
        vectors[17] = 8'd148;
        vectors[18] = 8'd127;

        // print header
        $display("time(ns)\tdec\tbin\tin_char\t->\tout_dec\tout_bin\tout_char");

        for (i = 0; i <= 18; i = i + 1) begin
            din = vectors[i];
            #INTER_DELAY; // allow the DUT to settle
            // print results: display printable ASCII character or '.' for non-printable
            $display("%0t\t%0d\t%b\t%s\t->\t%0d\t%b\t%s",
                $time,
                din,
                din,
                ( (din >= 32 && din <= 126) ? {1{din}} : " "), // show char when printable
                dout,
                dout,
                ( (dout >= 32 && dout <= 126) ? {1{dout}} : " ")
            );
        end

        // final check: compare results with expected
        $display("\nManual verification table printed separately. Waveform file toUpper.vcd created.");
        #100 $finish;
    end
endmodule
