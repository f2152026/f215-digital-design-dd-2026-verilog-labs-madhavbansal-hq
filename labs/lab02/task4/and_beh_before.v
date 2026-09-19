// and_beh_before.v
// 2-input AND gate, BEHAVIORAL style, delay BEFORE the assignment.
//
//   #5 y = a & b;
//
// The block first waits 5 units (doing nothing, and NOT watching a/b), then
// evaluates a & b using the values at the END of the wait and assigns them.
// While it is sitting in the #5, changes on a or b are missed entirely.
 
module and_beh_before (
  input      a,
  input      b,
  output reg y
);
 
  always @(a or b) begin
    #5 y = a & b;
  end
 
endmodule