module AS(sel, A, B, S, O);
  input [3:0] A, B;
  input sel;
  output [3:0] S;
  output O;

  wire t1, t2, t3, t4;
  wire C1, C2, C3, C4;

  xor (t1, sel, B[0]);
  FA fa1(A[0], t1, sel, S[0], C1);

  xor (t2, sel, B[1]);
  FA fa2(A[1], t2, C1, S[1], C2);

  xor (t3, sel, B[2]);
  FA fa3(A[2], t3, C2, S[2], C3);

  xor (t4, sel, B[3]);
  FA fa4(A[3], t4, C3, S[3], C4);

  xor (O, C3, C4);

endmodule

module FA(A, B, Cin, sum, Cout);
  input A, B, Cin;
  output sum, Cout;
  wire t1, t2, t3;
  
  xor (t1, A, B);
  xor (sum, t1, Cin);
  and (t2, Cin, t1);
  and (t3, A, B);
  or (Cout, t2, t3);
  
endmodule




