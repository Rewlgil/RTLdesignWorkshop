`timescale 1ns/100ps

module tb1;

  // required signals
  reg clk;
  reg a, b, c;
  wire m, expected_m;

  // dump file controls
  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(2, tb1);
  end

  // instantiate DUT
  majority DUT (.a(a), .b(b), .c(c), .m(m));

  // instantiate ref
  ref1 ref1_0 (.a(a), .b(b), .c(c), .m(expected_m));

  // drive and check
  task drive_and_check;
    input ain, bin, cin;

    begin
      {a, b, c} <= #1 {ain, bin, cin};
      @(posedge clk);
      if (m !== expected_m) begin
        $display ("time:%t | ERROR: a, b, c = %b %b %b. expected m = %b, actual m = %b", $time, a, b, c, expected_m, m);
        @(posedge clk);
        //$stop;
        $finish;
      end
      else begin
        $display ("time:%t | a, b, c = %b %b %b. expected m = %b, actual m = %b", $time, a, b, c, expected_m, m);
      end
    end
  endtask

  // clk generator
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // test all combos
  integer i;
  initial begin
    for (i = 0; i <=7; i=i+1) begin
      {a, b, c} = i;
      drive_and_check(a, b, c);
    end
    $display ("time:%t | TEST PASSED.", $time);
    $finish;
  end

endmodule
