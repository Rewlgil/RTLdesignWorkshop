`timescale 1ns/100ps

module tb9;

  // required signals
  reg clk, reset;
  reg [1:0] n;
  reg [7:0] t;
  wire [1:0] n_best, expected_n_best;
  wire [7:0] t_best, expected_t_best;

  // dump file controls
  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(2, tb9);
  end

  // instantiate DUT
  flt DUT ( .clk(clk), .reset(reset), .n(n), .t(t), .n_best(n_best), .t_best(t_best) );

  // instantiate ref
  ref9 ref9_0 ( .clk(clk), .reset(reset), .n(n), .t(t), .n_best(expected_n_best), .t_best(expected_t_best) );

  // drive and check
  task drive_and_check;
    input reset_in;
    input [1:0] n_in;
    input [7:0] t_in;

    reg [1:0] exp_n_best;
    reg [7:0] exp_t_best;

    begin
      {reset, n, t} <= #1 {reset_in, n_in, t_in};
      @(posedge clk);

      exp_n_best = reset? 1'bx : expected_n_best;
      exp_t_best = reset? 1'bx : expected_t_best;

      if (!reset && (!   ((exp_n_best === n_best) && (exp_t_best === t_best)) ) ) begin
        $display ("time:%06t | ERROR: reset = %b, n t = %01d %03d, expected n_best t_best = %01d %03d actual = %01d %03d",
                  $time, reset, n, t, exp_n_best, exp_t_best, n_best, t_best);
        @(posedge clk);
        //$stop;
        $finish;
      end
      else begin
        $display ("time:%06t | reset = %b, n t = %01d %03d, expected n_best t_best = %01d %03d actual = %01d %03d",
                  $time, reset, n, t, exp_n_best, exp_t_best, n_best, t_best);
      end
    end
  endtask

  // clk generator
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // random 8-bit
  function [7:0] rnd;
    input dummy;
    rnd = $random & 8'hff;
  endfunction

  // test all combos
  integer i;
  reg [1:0] n_rand;
  reg [7:0] t_rand;
  reg [7:0] t_best_ever;
  initial begin

    // test all arcs
    $display ("time:%06t | ---- testing example", $time);
    drive_and_check(1, 2'bx, 8'bx);  // reset
    drive_and_check(0, 2'd0, rnd(0)); // 01
    drive_and_check(0, 2'd1, 8'd128); // 02
    drive_and_check(0, 2'd2, 8'd127); // 03
    drive_and_check(0, 2'd3, 8'd129); // 04
    drive_and_check(0, 2'd0, rnd(0)); // 05
    drive_and_check(0, 2'd2, 8'd126); // 06
    drive_and_check(0, 2'd2, 8'd129); // 07
    drive_and_check(0, 2'd1, 8'd124); // 08
    drive_and_check(0, 2'd3, 8'd124); // 09
    drive_and_check(0, 2'd1, 8'd125); // 10
    drive_and_check(0, 2'd2, 8'd126); // 11
    drive_and_check(0, 2'd0, rnd(0)); // 12

    // random drives
    $display ("time:%06t | ---- random checks", $time);
    drive_and_check(1, 2'bx, 8'bx);  // reset
    for (i = 0; i < 26; i = i+1) begin
      n_rand = $random; t_rand = $random;
      drive_and_check(0, n_rand, t_rand);
    end

    $display ("time:%06t | TEST PASSED.", $time);
    $finish;
  end

endmodule
