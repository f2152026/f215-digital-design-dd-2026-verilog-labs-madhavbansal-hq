// mux_beh.v
// 2-to-1 multiplexer, BEHAVIORAL style.
//
// Fix: behavioral modeling assigns inside an always block (procedural
// assignment), which can only drive a VARIABLE. So Y must be a reg, not a
// wire (a net can only be driven by assign / primitive / module outputs).
 
module mux_beh (
  input      I0,
  input      I1,
  input      S,
  output reg Y
);
 
  always @(*) begin
    if (S)
      Y = I1;
    else
      Y = I0;
  end
 
endmodule