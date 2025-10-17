`timescale 1ns/100ps

module tb6;

  // required signals
  reg clk, reset;
  reg req_a, req_b;
  wire grant_a, grant_b;
  wire expected_grant_a, expected_grant_b;

  // dump file controls
  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(2, tb6);
  end

  // instantiate DUT
  arb DUT ( .clk(clk), .reset(reset), .req_a(req_a), .req_b(req_b),
            .grant_a(grant_a), .grant_b(grant_b) );

  // instantiate ref
  ref6 ref6_0 (  .clk(clk), .reset(reset), .req_a(req_a), .req_b(req_b),
                 .grant_a(expected_grant_a), .grant_b(expected_grant_b) );

  // drive and check
  task drive_and_check;
    input reset_in;
    input [1:0] req_in;

    reg [1:0] expected;

    begin
      {reset, req_a, req_b} <= #1 {reset_in, req_in};
      @(posedge clk);

      expected = reset? 2'bxx : {expected_grant_a, expected_grant_b};

      if (!reset && (! (expected === {grant_a, grant_b}) ) ) begin
        $display ("time:%06t | ERROR: reset = %b {req_a, req_b} = %02b, {grant_a, grantb} expected = %02b actual = %02b",
                  $time, reset, {req_a,req_b}, expected, {grant_a, grant_b});
        @(posedge clk);
        //$stop;
        $finish;
      end
      else begin
        $display ("time:%06t | reset = %b {req_a, req_b} = %02b, {grant_a, grantb} expected = %02b actual = %02b",
                  $time, reset, {req_a,req_b}, expected, {grant_a, grant_b});
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
  reg [1:0] req_random;
  initial begin

    // examples
    $display ("time:%06t | ---- testing examples", $time);
    drive_and_check(1'b1, 2'bxx);
    drive_and_check(1'b0, 2'b00);
    drive_and_check(1'b0, 2'b11);
    drive_and_check(1'b0, 2'b11);
    drive_and_check(1'b0, 2'b01);
    drive_and_check(1'b0, 2'b10);
    drive_and_check(1'b0, 2'b11);
    drive_and_check(1'b0, 2'b10);
    drive_and_check(1'b0, 2'b11);

    // random
    $display ("time:%06t | ---- testing random", $time);
    drive_and_check(1'b0, 2'b00);
    drive_and_check(1'b1, 2'bxx);
    for (i = 0; i < 32; i = i+1) begin
      req_random = $random;
      drive_and_check(1'b0, req_random);
    end

    $display ("time:%06t | TEST PASSED.", $time);
    $finish;
  end

endmodule
