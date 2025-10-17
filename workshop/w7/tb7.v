`timescale 1ns/100ps

module tb7;

  // required signals
  reg clk, reset;
  reg [3:0] r;
  wire [3:0] m, expected_m;

  // dump file controls
  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(2, tb7);
  end

  // instantiate DUT
  remme DUT ( .clk(clk), .reset(reset), .r(r), .m(m) );

  // instantiate ref
  ref7 ref7_0 ( .clk(clk), .reset(reset), .r(r), .m(expected_m) );

  // drive and check
  task drive_and_check;
    input reset_in;
    input [3:0] r_in;

    reg [3:0] exp_m;

    begin
      {reset, r} <= #1 {reset_in, r_in};
      @(posedge clk);

      exp_m = reset? 4'bx : expected_m;

      if (!reset && (! (exp_m === m) ) ) begin
        $display ("time:%06t | ERROR: reset = %b r = %h, expected m = %h actual = %h",
                  $time, reset, r, exp_m, m);
        @(posedge clk);
        //$stop;
        $finish;
      end
      else begin
        $display ("time:%06t | reset = %b r = %h, expected m = %h actual = %h",
                  $time, reset, r, exp_m, m);
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
  reg [3:0] r_random;
  reg [1:0] repeat_random;
  initial begin

    // example 1
    $display ("time:%06t | ---- testing example 1", $time);
    drive_and_check(1, 4'h4);
    drive_and_check(0, 4'h7);
    drive_and_check(0, 4'hf);
    drive_and_check(0, 4'h3);
    drive_and_check(0, 4'h6);
    drive_and_check(0, 4'h2);
    drive_and_check(0, 4'hf);
    drive_and_check(0, 4'h5);
    drive_and_check(0, 4'h7);

    // example 2
    $display ("time:%06t | ---- testing example 2", $time);
    drive_and_check(1, 4'h2);
    drive_and_check(0, 4'hf);
    drive_and_check(0, 4'ha);
    drive_and_check(0, 4'hf);
    drive_and_check(0, 4'hf);
    drive_and_check(0, 4'h9);
    drive_and_check(0, 4'h3);
    drive_and_check(0, 4'hf);
    drive_and_check(0, 4'h6);

    // random
    $display ("time:%06t | ---- testing random", $time);
    drive_and_check(0, 4'h0);
    drive_and_check(1, 4'bx);
    
    for (j = 0; j < 6; j = j+1) begin
      for (i = 0; i < 8; i = i+1) begin
        r_random = $random;
        drive_and_check(0, r_random);
      end
      repeat_random = $random;
      for (i = 0; i < repeat_random; i = i + 1) begin
        drive_and_check(0, 4'hf);
      end
      for (i = 0; i < 2; i = i+1) begin
        r_random = $random;
        drive_and_check(0, r_random);
      end
    end 

    $display ("time:%06t | TEST PASSED.", $time);
    $finish;
  end

endmodule
