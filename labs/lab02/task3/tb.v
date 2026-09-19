// tb.v
// Self-checking, exhaustive testbench for comp2 (2-bit unsigned comparator).
// Applies all 16 (A,B) combinations and checks, for each one:
//   1. GT, LT, EQ each match the expected relation of A and B
//   2. exactly one of GT, LT, EQ is high (one-hot)
// Prints a per-vector FAIL line for every problem and a final PASS/FAIL.
 
module tb;
 
  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;
 
  // Instance named DUT so $dumpvars(0, DUT) resolves
  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
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
  integer errors;
  reg exp_gt, exp_lt, exp_eq;
 
  initial begin
    errors = 0;
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        // Expected values from the plain definition of the comparison
        exp_gt = (i >  j);
        exp_lt = (i <  j);
        exp_eq = (i == j);
        #5;  // let the outputs settle
 
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          errors = errors + 1;
          $display("FAIL: A=%0d B=%0d | got GT=%b LT=%b EQ=%b | expected GT=%b LT=%b EQ=%b",
                   i, j, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
        end
        // Independent property check: exactly one output high
        if ((t_gt + t_lt + t_eq) !== 1) begin
          errors = errors + 1;
          $display("FAIL: A=%0d B=%0d | not one-hot (GT=%b LT=%b EQ=%b)",
                   i, j, t_gt, t_lt, t_eq);
        end
      end
    end
 
    if (errors == 0) $display("PASS: all 16 input combinations correct");
    else             $display("FAIL: %0d check(s) failed", errors);
    $finish;
  end
 
  initial
    $monitor($time, " A=%b B=%b | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);
 
endmodule