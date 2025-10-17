`timescale 1ns/100ps

module tb2;

  // required signals
  reg clk;
  reg [7:0] s;
  wire [7:0] t, expected_t;

  // dump file controls
  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(2, tb2);
  end

  // instantiate DUT
  signed2twos DUT (.s(s), .t(t));

  // instantiate ref
  ref2 ref2_0 (.s(s), .t(expected_t));

  // drive and check
  task drive_and_check;
    input [7:0] sin;

    begin
      s <= #1 sin;
      @(posedge clk);
      if (t !== expected_t) begin
        $display ("time:%t | ERROR: s = %b. expected t = %b, actual t = %b", $time, s, expected_t, t);
        @(posedge clk);
        //$stop;
        $finish;
      end
      else begin
        $display ("time:%t | s = %b. expected t = %b, actual t = %b", $time, s, expected_t, t);
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
    for (i = 0; i <=255; i=i+1) begin
      s = i;
      drive_and_check(s);
    end
    $display ("time:%t | TEST PASSED.", $time);
    $finish;
  end

endmodule
