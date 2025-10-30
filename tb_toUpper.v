/*
 * `tb_toUpper.v`
 * Test bench for the toUpper module.
 * This test bench will:
 * 1. Instantiate the `toUpper` module.
 * 2. Provide all 20 test case inputs from the project description.
 * 3. Monitor and print the inputs and outputs to the console.
 * 4. Generate a waveform file `waveform.vcd` for analysis.
 * 5. Use a parameter `INTER_INPUT_DELAY` for stress testing.
 */
`timescale 1ns / 1ps

module tb_toUpper;

    // This parameter controls the time between test inputs.
    // Based on the report, the critical path delay is 100 ns.
    // A value > 100 ns (like 120 ns) should work.
    // A value < 100 ns (like 99 ns) should fail.
    parameter INTER_INPUT_DELAY = 120;
    
    // Inputs to the UUT (Unit Under Test)
    reg [7:0] input_char;
    
    // Outputs from the UUT
    wire [7:0] output_char;

    // Instantiate the Unit Under Test
    toUpper UUT (
        .O(output_char),
        .I(input_char)
    );
    
    // Initial block to provide stimulus
    initial begin
        // Setup waveform dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_toUpper);

        // Monitor to print changes to the console
        $monitor("Time = %0t ns | Input: %d (%b) | Output: %d (%b)",
                 $time, input_char, input_char, output_char, output_char);

        // --- Start Test Cases ---
        // ( 40
        #INTER_INPUT_DELAY input_char = 40;
        // H 72
        #INTER_INPUT_DELAY input_char = 72;
        // · 183
        #INTER_INPUT_DELAY input_char = 183;
        // ƒ 131
        #INTER_INPUT_DELAY input_char = 131;
        // | 124
        #INTER_INPUT_DELAY input_char = 124;
        // DC4 20
        #INTER_INPUT_DELAY input_char = 20;
        // ë 235
        #INTER_INPUT_DELAY input_char = 235;
        // a 97  -> should convert to 65
        #INTER_INPUT_DELAY input_char = 97;
        // A 65
        #INTER_INPUT_DELAY input_char = 65;
        // z 122 -> should convert to 90
        #INTER_INPUT_DELAY input_char = 122;
        // G 71
        #INTER_INPUT_DELAY input_char = 71;
        // m 109 -> should convert to 77
        #INTER_INPUT_DELAY input_char = 109;
        // ' 146
        #INTER_INPUT_DELAY input_char = 146;
        // 0 48
        #INTER_INPUT_DELAY input_char = 48;
        // Ï 207
        #INTER_INPUT_DELAY input_char = 207;
        // : 58
        #INTER_INPUT_DELAY input_char = 58;
        // { 123
        #INTER_INPUT_DELAY input_char = 123;
        // ” 148
        #INTER_INPUT_DELAY input_char = 148;
        // DEL 127
        #INTER_INPUT_DELAY input_char = 127;
        
        // Add one last delay to see the final output clearly
        #INTER_INPUT_DELAY;

        // Finish the simulation
        $finish;
    end
    
endmodule
