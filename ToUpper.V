`timescale 1ns / 1ps

module toUpper(
    input [7:0] A,
    output [7:0] Y
);
    // Internal wires
    wire not_A7, not_A6, not_A5, not_A4, not_A3, not_A2, not_A1, not_A0;
    wire and1, and2, and3, and4, and5, or1, or2, or3;
    wire lowercase;
    
    // Inverters for needed signals
    not #5 not7(not_A7, A[7]);
    not #5 not6(not_A6, A[6]);
    not #5 not5(not_A5, A[5]);
    not #5 not4(not_A4, A[4]);
    not #5 not3(not_A3, A[3]);
    not #5 not2(not_A2, A[2]);
    not #5 not1(not_A1, A[1]);
    not #5 not0(not_A0, A[0]);
    
    // Lowercase detection logic: L = A7'·A6·A5·(A4 + A3 + A2·A1' + A2·A1·A0')
    
    // A2·A1'
    and #10 and_gate1(and1, A[2], not_A1);
    
    // A2·A1·A0'
    and #10 and_gate2(and2, A[2], A[1]);
    and #10 and_gate3(and3, and2, not_A0);
    
    // A4 + A3 + A2·A1' + A2·A1·A0'
    or #10 or_gate1(or1, A[4], A[3]);
    or #10 or_gate2(or2, and1, and3);
    or #10 or_gate3(or3, or1, or2);
    
    // A7'·A6·A5·(above expression)
    and #10 and_gate4(and4, not_A7, A[6]);
    and #10 and_gate5(and5, and4, A[5]);
    and #10 and_gate6(lowercase, and5, or3);
    
    // Output bits
    // Y[7:0] mostly pass through, except Y[5] = A[5] AND NOT lowercase
    wire not_lowercase;
    not #5 not_low(not_lowercase, lowercase);
    and #10 and_y5(Y[5], A[5], not_lowercase);
    
    // Direct connections for other bits
    buf #4 buf7(Y[7], A[7]);
    buf #4 buf6(Y[6], A[6]);
    buf #4 buf4(Y[4], A[4]);
    buf #4 buf3(Y[3], A[3]);
    buf #4 buf2(Y[2], A[2]);
    buf #4 buf1(Y[1], A[1]);
    buf #4 buf0(Y[0], A[0]);

endmodule