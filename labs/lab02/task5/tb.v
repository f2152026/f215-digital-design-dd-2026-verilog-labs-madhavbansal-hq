// tb.v
// Self-checking testbench for the 4-bit add/sub ALU.
// Expected result is computed independently: 4-bit (a+b) for op=0 and
// 4-bit (a-b) for op=1 (mod 16, same as two's-complement wraparound).
//
// Three phases, so a failure tells you WHICH kind of problem you have:
//   A: op=0 held, sweep every (a,b)                -> add path
//   B: op=1 held, sweep every (a,b)                -> subtract path
//   C: hold a,b; change ONLY op (0 -> 1 -> 0)      -> is result sensitive to op?
 
module tb;
 
  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;
 
  // Instance named DUT so $dumpvars(0, DUT) resolves
  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );
 
  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end
 
  integer i, j;
  integer err_a, err_b, err_c;
  reg [3:0] expected;
 
  // Compare result to the independent reference; count and report mismatches.
  // Only the first 5 mismatches per phase are printed to keep output readable.
  task check;
    input [3:0] a_v, b_v;
    input       op_v;
    input [8*7-1:0] phase;   // label
    inout integer   errs;
    begin
      expected = op_v ? (a_v - b_v) : (a_v + b_v);
      if (t_result !== expected) begin
        errs = errs + 1;
        if (errs <= 5)
          $display("FAIL [%0s]: a=%0d b=%0d op=%b | got %0d expected %0d",
                   phase, a_v, b_v, op_v, t_result, expected);
      end
    end
  endtask
 
  initial begin
    err_a = 0; err_b = 0; err_c = 0;
 
    // ---- Phase A: add path ----
    t_op = 0;
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 16; j = j + 1) begin
        t_a = i; t_b = j; #5;
        check(i[3:0], j[3:0], 1'b0, "ADD", err_a);
      end
 
    // ---- Phase B: subtract path ----
    t_op = 1;
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 16; j = j + 1) begin
        t_a = i; t_b = j; #5;
        check(i[3:0], j[3:0], 1'b1, "SUB", err_b);
      end
 
    // ---- Phase C: change ONLY op while a,b stay put ----
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 16; j = j + 1) begin
        t_op = 0; t_a = i; t_b = j; #5;   // (a,b changed here, as well)
        t_op = 1; #5;                      // ONLY op changes
        check(i[3:0], j[3:0], 1'b1, "OP0>1", err_c);
        t_op = 0; #5;                      // ONLY op changes back
        check(i[3:0], j[3:0], 1'b0, "OP1>0", err_c);
      end
 
    $display("---- summary ----");
    $display("Phase A (add)          : %0d mismatches / 256", err_a);
    $display("Phase B (subtract)     : %0d mismatches / 256", err_b);
    $display("Phase C (op-only change): %0d mismatches / 512", err_c);
    if (err_a + err_b + err_c == 0) $display("PASS: ALU correct for all tested cases");
    else                            $display("FAIL");
    $finish;
  end
 
endmodule