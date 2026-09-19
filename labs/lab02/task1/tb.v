// tb.v
// Testbench for the 2-to-1 mux: applies all 8 combinations of I0, I1, S
// (5 time units apart) to DUT and observes the output.
 
module tb;
 
  // DUT inputs are driven from the testbench -> variables (reg)
  reg   t_i0, t_i1, t_s;
  // DUT output is driven by the DUT -> net (wire)
  wire  t_y;
 
  // Instantiate DUT, connecting t_i0, t_i1, t_s, t_y to its ports.
  // The instance is named DUT so that $dumpvars(0, DUT) below resolves.
  DUT DUT (
    .I0 (t_i0),
    .I1 (t_i1),
    .S  (t_s),
    .Y  (t_y)
  );
 
  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end
 
  initial begin
    // Apply all 8 combinations, {t_i0, t_i1, t_s} counting 000 -> 111
    {t_i0, t_i1, t_s} = 3'b000;  #5;
    {t_i0, t_i1, t_s} = 3'b001;  #5;
    {t_i0, t_i1, t_s} = 3'b010;  #5;
    {t_i0, t_i1, t_s} = 3'b011;  #5;
    {t_i0, t_i1, t_s} = 3'b100;  #5;
    {t_i0, t_i1, t_s} = 3'b101;  #5;
    {t_i0, t_i1, t_s} = 3'b110;  #5;
    {t_i0, t_i1, t_s} = 3'b111;  #5;
    $finish;
  end
 
  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y);
 
endmodule