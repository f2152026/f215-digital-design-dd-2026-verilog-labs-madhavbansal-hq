// alu.v
// 1-bit-opcode ALU: op=0 -> add, op=1 -> sub. 4-bit operands.
// Subtraction is implemented the way real hardware does it: negate b (one's
// complement, then +1 for two's complement) and add.
//
// Fixes (both found with the self-checking testbench):
//   1. Sensitivity list: was @(a, b), so a change on op alone never re-ran
//      the block and result went stale. Now @(*), which covers every signal
//      the block reads (a, b, op).
//   2. Blocking vs non-blocking: the subtract path chains b_inv -> b_twos ->
//      result, so each step needs the value the previous step just produced.
//      Non-blocking (<=) defers the update to the end of the time step, so
//      b_twos and result were computed from OLD values. Combinational logic
//      inside an always @(*) block uses blocking (=) assignments.
 
module alu (
  input      [3:0] a,
  input      [3:0] b,
  input             op,      // 0 = add, 1 = sub
  output reg [3:0] result
);
 
  reg [3:0] b_inv;
  reg [3:0] b_twos;
 
  always @(*) begin
    case (op)
      1'b0: begin
        result = a + b;                 // add
      end
      1'b1: begin
        b_inv  = ~b;                    // sub, via two's complement
        b_twos = b_inv + 1;
        result = a + b_twos;
      end
    endcase
  end
 
endmodule