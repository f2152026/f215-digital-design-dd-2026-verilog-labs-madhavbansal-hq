// tb.v
// Testbench for the lut ROM: sweeps every address and checks dout == sel*sel.
 
module tb;
 
  // Parameters match the lut defaults (WIDTH=8, DEPTH=4 -> 2-bit address)
  localparam WIDTH = 8;
  localparam DEPTH = 4;
 
  // Inputs are driven by the testbench -> reg; outputs come from the DUT -> wire
  reg  [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0]         t_dout;
 
  // Instance is named DUT so $dumpvars(0, DUT) below resolves
  lut #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );
 
  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end
 
  integer k;
  integer errors;
 
  initial begin
    errors = 0;
    // Apply every address 0..DEPTH-1, 5 time units apart
    for (k = 0; k < DEPTH; k = k + 1) begin
      t_sel = k;
      #5;
      if (t_dout !== k * k) begin
        errors = errors + 1;
        $display("MISMATCH: sel=%0d dout=%0d expected=%0d", k, t_dout, k * k);
      end
    end
    // Go back to a lower address to show dout follows sel combinationally
    t_sel = 2; #5;
    if (t_dout !== 4) begin
      errors = errors + 1;
      $display("MISMATCH: sel=2 dout=%0d expected=4", t_dout);
    end
    if (errors == 0) $display("PASS: all lut outputs match sel*sel");
    else             $display("FAIL: %0d mismatches", errors);
    $finish;
  end
 
  initial
    $monitor($time, " sel=%0d | dout=%0d (%b)", t_sel, t_dout, t_dout);
 
endmodule