// and_df.v
// 2-input AND gate, DATAFLOW style, with a 5-unit delay.
//
// A delay on a continuous assignment is an INERTIAL delay: every time a or b
// changes, the expression is re-evaluated and any still-pending output change
// is cancelled and replaced. A pulse shorter than 5 units is therefore
// filtered out, just like a real gate that can't respond that fast.
 
module and_df (
  input  a,
  input  b,
  output y
);
 
  assign #5 y = a & b;
 
endmodule