// and_beh_intra.v
// 2-input AND gate, BEHAVIORAL style, INTRA-assignment delay.
//
//   y = #5 a & b;
//
// The right-hand side a & b is evaluated IMMEDIATELY (at the moment the block
// wakes up), then the block waits 5 units and only then writes that saved
// value to y. The value assigned can therefore be stale by the time it lands,
// and, as above, the block ignores a/b changes while it waits.
 
module and_beh_intra (
  input      a,
  input      b,
  output reg y
);
 
  always @(a or b) begin
    y = #5 a & b;
  end
 
endmodule