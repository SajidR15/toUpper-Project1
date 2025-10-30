/*
 * `toUpper.v`
 * Implements an 8-bit toUpper() function using only primitive
 * gate instantiations with specified propagation delays.
 *
 * This version corrects a bug in the lt_122 comparator.
 */
`timescale 1ns / 1ps

module toUpper (
    output [7:0] O,
    input [7:0] I
);

    // Delays
    localparam DELAY_NOT = 5;
    localparam DELAY_AND = 10;
    localparam DELAY_OR  = 10;
    localparam DELAY_XOR = 15;
    localparam DELAY_BUF = 4;

    // --- Final Output Logic ---
    wire is_lowercase, not_is_lowercase;
    
    // Pass-through for bits 0, 1, 2, 3, 4, 6, 7
    buf #(DELAY_BUF) B0 (O[0], I[0]);
    buf #(DELAY_BUF) B1 (O[1], I[1]);
    buf #(DELAY_BUF) B2 (O[2], I[2]);
    buf #(DELAY_BUF) B3 (O[3], I[3]);
    buf #(DELAY_BUF) B4 (O[4], I[4]);
    buf #(DELAY_BUF) B6 (O[6], I[6]);
    buf #(DELAY_BUF) B7 (O[7], I[7]);

    // Gating logic for bit 5
    // O[5] = I[5] AND (NOT is_lowercase)
    not #(DELAY_NOT) NOT_IS_LC (not_is_lowercase, is_lowercase);
    and #(DELAY_AND) GATED_BIT5 (O[5], I[5], not_is_lowercase);


    // --- `is_lowercase` Logic ---
    // is_lowercase = (I >= 97) AND (I <= 122)
    wire gte_97, lte_122;
    and #(DELAY_AND) IS_LC (is_lowercase, gte_97, lte_122);

    // --- Comparator 1: I >= 97 (01100001) ---
    wire gt_97, eq_97;
    wire [7:0] x; // x[i] = I[i] XNOR B[i]
    
    // B[7:0] = 01100001
    not #(DELAY_NOT) X7 (x[7], I[7]); // I[7] XNOR 0
    buf #(DELAY_BUF) X6 (x[6], I[6]); // I[6] XNOR 1
    buf #(DELAY_BUF) X5 (x[5], I[5]); // I[5] XNOR 1
    not #(DELAY_NOT) X4 (x[4], I[4]); // I[4] XNOR 0
    not #(DELAY_NOT) X3 (x[3], I[3]); // I[3] XNOR 0
    not #(DELAY_NOT) X2 (x[2], I[2]); // I[2] XNOR 0
    not #(DELAY_NOT) X1 (x[1], I[1]); // I[1] XNOR 0
    buf #(DELAY_BUF) X0 (x[0], I[0]); // I[0] XNOR 1

    // eq_97 = (I == 97) = x[7] & x[6] & ... & x[0] (AND tree)
    wire x7_6, x5_4, x3_2, x1_0, x7_4, x3_0;
    and #(DELAY_AND) EQ1 (x7_6, x[7], x[6]);
    and #(DELAY_AND) EQ2 (x5_4, x[5], x[4]);
    and #(DELAY_AND) EQ3 (x3_2, x[3], x[2]);
    and #(DELAY_AND) EQ4 (x1_0, x[1], x[0]);
    and #(DELAY_AND) EQ5 (x7_4, x7_6, x5_4);
    and #(DELAY_AND) EQ6 (x3_0, x3_2, x1_0);
    and #(DELAY_AND) EQ_97 (eq_97, x7_4, x3_0);

    // gt_97 = (I > 97) = I[7]B'[7] + x[7]I[6]B'[6] + x[7]x[6]I[5]B'[5] + ...
    // B_97 = 01100001. B'[7]=1, B'[6]=0, B'[5]=0, B'[4]=1, B'[3]=1, B'[2]=1, B'[1]=1, B'[0]=0
    wire t1, t4, t5, t6, t7;
    wire t4_a, t4_b, t5_a, t5_b, t6_a, t6_b, t7_a, t7_b; // intermediate ANDs
    
    buf #(DELAY_BUF) GT_T1 (t1, I[7]);  // t1 = I[7] & 1
    
    and #(DELAY_AND) T4A (t4_a, x[7], x[6]);
    and #(DELAY_AND) T4B (t4_b, t4_a, x[5]);
    and #(DELAY_AND) GT_T4 (t4, t4_b, I[4]); // t4 = x[7..5] & I[4] & 1
    
    and #(DELAY_AND) T5A (t5_a, t4_b, x[4]);
    and #(DELAY_AND) GT_T5 (t5, t5_a, I[3]); // t5 = x[7..4] & I[3] & 1

    and #(DELAY_AND) T6A (t6_a, t5_a, x[3]);
    and #(DELAY_AND) GT_T6 (t6, t6_a, I[2]); // t6 = x[7..3] & I[2] & 1
    
    and #(DELAY_AND) T7A (t7_a, t6_a, x[2]);
    and #(DELAY_AND) GT_T7 (t7, t7_a, I[1]); // t7 = x[7..2] & I[1] & 1
    
    // OR tree for gt_97 = t1 | t4 | t5 | t6 | t7
    wire or1, or2, or3;
    or #(DELAY_OR) GT_OR1 (or1, t1, t4);
    or #(DELAY_OR) GT_OR2 (or2, t5, t6);
    or #(DELAY_OR) GT_OR3 (or3, or2, t7);
    or #(DELAY_OR) GT_97 (gt_97, or1, or3);
    
    // gte_97 = (I > 97) OR (I == 97)
    or #(DELAY_OR) GTE_97 (gte_97, gt_97, eq_97);


    // --- Comparator 2: I <= 122 (01111010) ---
    wire lt_122, eq_122;
    wire [7:0] y; // y[i] = I[i] XNOR B[i]
    
    // B[7:0] = 01111010
    not #(DELAY_NOT) Y7 (y[7], I[7]); // I[7] XNOR 0
    buf #(DELAY_BUF) Y6 (y[6], I[6]); // I[6] XNOR 1
    buf #(DELAY_BUF) Y5 (y[5], I[5]); // I[5] XNOR 1
    buf #(DELAY_BUF) Y4 (y[4], I[4]); // I[4] XNOR 1
    buf #(DELAY_BUF) Y3 (y[3], I[3]); // I[3] XNOR 1
    not #(DELAY_NOT) Y2 (y[2], I[2]); // I[2] XNOR 0
    buf #(DELAY_BUF) Y1 (y[1], I[1]); // I[1] XNOR 1
    not #(DELAY_NOT) Y0 (y[0], I[0]); // I[0] XNOR 0

    // eq_122 = (I == 122) = y[7] & y[6] & ... & y[0] (AND tree)
    wire y7_6, y5_4, y3_2, y1_0, y7_4, y3_0;
    and #(DELAY_AND) EQ1_122 (y7_6, y[7], y[6]);
    and #(DELAY_AND) EQ2_122 (y5_4, y[5], y[4]);
    and #(DELAY_AND) EQ3_122 (y3_2, y[3], y[2]);
    and #(DELAY_AND) EQ4_122 (y1_0, y[1], y[0]);
    and #(DELAY_AND) EQ5_122 (y7_4, y7_6, y5_4);
    and #(DELAY_AND) EQ6_122 (y3_0, y3_2, y1_0);
    and #(DELAY_AND) EQ_122 (eq_122, y7_4, y3_0);

    // lt_122 = (I < 122) = I'[7]B[7] + y[7]I'[6]B[6] + y[7]y[6]I'[5]B'[5] + ...
    // B_122 = 01111010.
    wire lt_t2, lt_t3, lt_t4, lt_t5, lt_t7;
    wire not_I6, not_I5, not_I4, not_I3, not_I1;
    wire lt_a2, lt_a3, lt_a4, lt_a5, lt_a7_int, lt_a7;
    
    // t1 = I'[7] & B[7] = I'[7] & 0 = 0
    not #(DELAY_NOT) NI6 (not_I6, I[6]);
    and #(DELAY_AND) LT_T2 (lt_t2, y[7], not_I6); // t2 = y[7] & I'[6] & 1
    
    not #(DELAY_NOT) NI5 (not_I5, I[5]);
    and #(DELAY_AND) LT_A3 (lt_a3, y[7], y[6]);
    and #(DELAY_AND) LT_T3 (lt_t3, lt_a3, not_I5); // t3 = y[7..6] & I'[5] & 1
    
    not #(DELAY_NOT) NI4 (not_I4, I[4]);
    and #(DELAY_AND) LT_A4 (lt_a4, lt_a3, y[5]);
    and #(DELAY_AND) LT_T4 (lt_t4, lt_a4, not_I4); // t4 = y[7..5] & I'[4] & 1
    
    not #(DELAY_NOT) NI3 (not_I3, I[3]);
    and #(DELAY_AND) LT_A5 (lt_a5, lt_a4, y[4]);
    and #(DELAY_AND) LT_T5 (lt_t5, lt_a5, not_I3); // t5 = y[7..4] & I'[3] & 1

    // t6 = y[7..3] & I'[2] & B[2] = ... & 0 = 0
    
    // *** BUG FIX IS HERE ***
    not #(DELAY_NOT) NI1 (not_I1, I[1]);
    and #(DELAY_AND) LT_A7_int (lt_a7_int, lt_a5, y[3]);
    and #(DELAY_AND) LT_A7 (lt_a7, lt_a7_int, y[2]); // This was the missing term
    and #(DELAY_AND) LT_T7 (lt_t7, lt_a7, not_I1); // t7 = y[7..3] & y[2] & I'[1] & 1
    // *** END BUG FIX ***
    
    // t8 = ... & B[0] = ... & 0 = 0
    
    // OR tree for lt_122 = t2 | t3 | t4 | t5 | t7
    wire lt_or1, lt_or2, lt_or3;
    or #(DELAY_OR) LT_OR1 (lt_or1, lt_t2, lt_t3);
    or #(DELAY_OR) LT_OR2 (lt_or2, lt_t4, lt_t5);
    or #(DELAY_OR) LT_OR3 (lt_or3, lt_or2, lt_t7);
    or #(DELAY_OR) LT_122 (lt_122, lt_or1, lt_or3);
    
    // lte_122 = (I < 122) OR (I == 122)
    or #(DELAY_OR) LTE_122 (lte_122, lt_122, eq_122);
    
endmodule

