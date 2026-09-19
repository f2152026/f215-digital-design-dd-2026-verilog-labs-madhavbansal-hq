// mux_df.v
// 2-to-1 multiplexer, DATAFLOW style.
//
// Fix: dataflow modeling uses continuous assignment (assign), which drives a
// NET. So Y must be a wire, not a reg (a reg/variable can only be assigned
// inside procedural blocks like always/initial).
 
module mux_df (
  input       I0,
  input       I1,
  input       S,
  output wire Y
);
 
  assign Y = S ? I1 : I0;
 
endmodule