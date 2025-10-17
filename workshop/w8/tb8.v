`timescale 1ns/100ps

module tb8;

  // required signals
  reg clk, reset;
  reg a, b;
  wire t, expected_t, c, expected_c;

  // dump file controls
  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(2, tb8);
  end

  // instantiate DUT
  vend DUT ( .clk(clk), .reset(reset), .a(a), .b(b), .t(t), .c(c) );

  // instantiate ref
  ref8 ref8_0 ( .clk(clk), .reset(reset), .a(a), .b(b), .t(expected_t), .c(expected_c) );

  // drive and check
  task drive_and_check;
    input reset_in;
    input b_in, a_in;

    reg exp_t, exp_c;

    begin
      {reset, b, a} <= #1 {reset_in, b_in, a_in};
      @(posedge clk);

      exp_t = reset? 1'bx : expected_t;
      exp_c = reset? 1'bx : expected_c;

      if (!reset && (!   ((exp_t === t) && (exp_c === c)) ) ) begin
        $display ("time:%06t | ERROR: reset = %b, b a = %b %b, expected t c = %b %b actual = %b %b",
                  $time, reset, b, a, exp_t, exp_c, t, c);
        @(posedge clk);
        //$stop;
        $finish;
      end
      else begin
        $display ("time:%06t | reset = %b, b a = %b %b, expected t c = %b %b actual = %b %b",
                  $time, reset, b, a, exp_t, exp_c, t, c);
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
  reg a_rand, b_rand;
  initial begin

    // test all arcs
    $display ("time:%06t | ---- testing all arcs", $time);
    drive_and_check(1, 1'bx, 1'bx);  // reset
    drive_and_check(0, 0, 0); // A0
    drive_and_check(0, 0, 1); // A1
    drive_and_check(0, 0, 0); // B0
    drive_and_check(0, 0, 1); // B1
    drive_and_check(0, 0, 0); // C0
    drive_and_check(0, 0, 1); // C1
    drive_and_check(0, 0, 0); // D0
    drive_and_check(0, 0, 1); // D1
    drive_and_check(0, 0, 0); // A0
    drive_and_check(0, 1, 1); // A2
    drive_and_check(0, 1, 1); // C2
    drive_and_check(0, 0, 0); // A0
    drive_and_check(0, 0, 1); // A1
    drive_and_check(0, 1, 1); // B2
    drive_and_check(0, 1, 1); // C2

    // random drives
    $display ("time:%06t | ---- random checks", $time);
    drive_and_check(1, 1'bx, 1'bx);  // reset
    for (i = 0; i < 256; i = i+1) begin
      a_rand = $random; b_rand = $random;
      drive_and_check(0, b_rand, a_rand);
    end

    $display ("time:%06t | TEST PASSED.", $time);
    $finish;
  end

endmodule
