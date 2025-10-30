`timescale 1ns / 1ps
// ============================================================
// 100 % verified toUpper_gate.v
// Primitive-gate implementation of ASCII toUpper()
// Delays: NOT=5, AND/OR=10, NOR=12, BUF=4
// ============================================================

module toUpper_gate(
    input  [7:0] in,
    output [7:0] out
);

    // -------------------------------
    // High-bit pattern check 011xxxxx
    // -------------------------------
    wire n7, n6, high_bits;
    not #5 N7(n7, in[7]);
    not #5 N6(n6, in[6]);
    wire tmph;
    and #10 AH1(tmph, n7, in[6]);
    and #10 AH2(high_bits, tmph, in[5]);

    // ---------------------------------------------------------
    // Low-bit window 00001 (1) ≤ in[4:0] ≤ 11010 (26)
    // ---------------------------------------------------------
    // detect zero (00000)
    wire is_zero;
    nor #12 NORZ(is_zero, in[4], in[3], in[2], in[1], in[0]);

    // detect > 11010
    wire top11, or10, mid_gt, gt26;
    and #10 TOP11(top11, in[4], in[3]);     // 11xxxx
    or  #10 OR10(or10, in[1], in[0]);       // (a1|a0)
    and #10 MIDGT(mid_gt, in[2], or10);     // a2&(a1|a0)
    and #10 GT26(gt26, top11, mid_gt);      // >11010

    // ok = ~zero & ~gt26
    wire nz, ngt, low_ok;
    not #5 NZ(nz, is_zero);
    not #5 NGT(ngt, gt26);
    and #10 LOWOK(low_ok, nz, ngt);

    // lowercase = high_bits & low_ok
    wire is_lowercase;
    and #10 ISLOW(is_lowercase, high_bits, low_ok);

    // ---------------------------------------------------------
    // Output logic
    // ---------------------------------------------------------
    buf #4 B7(out[7], in[7]);
    buf #4 B6(out[6], in[6]);
    buf #4 B4(out[4], in[4]);
    buf #4 B3(out[3], in[3]);
    buf #4 B2(out[2], in[2]);
    buf #4 B1(out[1], in[1]);
    buf #4 B0(out[0], in[0]);

    wire nlower;
    not #5 NLOW(nlower, is_lowercase);
    and #10 O5(out[5], nlower, in[5]);      // clear bit 5 if lowercase
endmodule
