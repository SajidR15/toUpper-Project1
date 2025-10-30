`timescale 1ns / 1ps

module toUpper_tb;
    reg [7:0] A;
    wire [7:0] Y;
    
    // Instantiate the unit under test
    toUpper uut (.A(A), .Y(Y));
    
    initial begin
        $display("Time\tInput\tOutput\tSymbol");
        $monitor("%4d\t%h\t%h\t%s", $time, A, Y, get_symbol(Y));
        
        // Test cases from the provided list
        #20 A = 8'd40;   // (
        #20 A = 8'd72;   // H
        #20 A = 8'd183;  // ·
        #20 A = 8'd131;  // ƒ
        #20 A = 8'd124;  // |
        #20 A = 8'd20;   // DC4
        #20 A = 8'd235;  // ë
        #20 A = 8'd97;   // a
        #20 A = 8'd65;   // A
        #20 A = 8'd122;  // z
        #20 A = 8'd71;   // G
        #20 A = 8'd109;  // m
        #20 A = 8'd146;  // '
        #20 A = 8'd48;   // 0
        #20 A = 8'd207;  // Ï
        #20 A = 8'd58;   // :
        #20 A = 8'd123;  // {
        #20 A = 8'd148;  // ”
        #20 A = 8'd127;  // DEL
        
        #20 $finish;
    end
    
    // Function to get symbol representation
    function string get_symbol;
        input [7:0] code;
        begin
            case(code)
                8'd40: get_symbol = "(";
                8'd72: get_symbol = "H";
                8'd183: get_symbol = "·";
                8'd131: get_symbol = "ƒ";
                8'd124: get_symbol = "|";
                8'd20: get_symbol = "DC4";
                8'd235: get_symbol = "ë";
                8'd97: get_symbol = "a";
                8'd65: get_symbol = "A";
                8'd90: get_symbol = "Z";  // Expected output for 'z'
                8'd71: get_symbol = "G";
                8'd77: get_symbol = "M";  // Expected output for 'm'
                8'd146: get_symbol = "'";
                8'd48: get_symbol = "0";
                8'd207: get_symbol = "Ï";
                8'd58: get_symbol = ":";
                8'd123: get_symbol = "{";
                8'd148: get_symbol = "”";
                8'd127: get_symbol = "DEL";
                default: get_symbol = "?";
            endcase
        end
    endfunction
    
    initial begin
        $dumpfile("toUpper_waveform.vcd");
        $dumpvars(0, toUpper_tb);
    end
    
endmodule