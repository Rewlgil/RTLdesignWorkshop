`timescale 1ns/100ps

module tb3;

  // required signals
  reg clk;
  reg [6:0] a, b;
  wire aLTb, aGTb, aEQb, expected_aLTb, expected_aGTb, expected_aEQb;

  // dump file controls
  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(2, tb3);
  end

  // instantiate DUT
  signed_mag_compare DUT (.a(a), .b(b), .aLTb(aLTb), .aGTb(aGTb), .aEQb(aEQb));

  // instantiate ref
  ref3 ref3_0 (.a(a), .b(b), .aLTb(expected_aLTb), .aGTb(expected_aGTb), .aEQb(expected_aEQb));

  // drive and check
  task drive_and_check;
    input [6:0] ain, bin;

    begin
      {a, b} <= #1 {ain, bin};
      @(posedge clk);
      if (!((aLTb === expected_aLTb) && (aEQb === expected_aEQb) && (aGTb === expected_aGTb))) begin
        $display ("time:%t | ERROR: a, b = %b, %b. expected aLTb aGTb aEQb = %b %b %b, actual = %b %b %b",
           $time, a, b, expected_aLTb, expected_aGTb, expected_aEQb, aLTb, aGTb, aEQb);
        @(posedge clk);
        //$stop;
        $finish;
      end
      else begin
        $display ("time:%t | a, b = %b, %b. expected aLTb aGTb aEQb = %b %b %b, actual = %b %b %b",
           $time, a, b, expected_aLTb, expected_aGTb, expected_aEQb, aLTb, aGTb, aEQb);
      end
    end
  endtask

  // clk generator
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // test all combos
  integer i, j;
  initial begin
    for (j = 0; j <=127; j=j+1) begin
      a = j;
      for (i = 0; i <=127; i=i+1) begin
        b = i;
        drive_and_check(a, b);
      end
    end
    $display ("time:%t | TEST PASSED.", $time);
    $finish;
  end

endmodule
