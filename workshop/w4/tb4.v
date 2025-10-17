`timescale 1ns/100ps

module tb4;

  // required signals
  reg clk;
  reg [7:0] in0, in1, in2;
  reg [5:0] select;
  wire valid, expected_valid;
  wire [7:0] out0, expected_out0;
  wire [7:0] out1, expected_out1;
  wire [7:0] out2, expected_out2;


  // dump file controls
  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(2, tb4);
  end

  // instantiate DUT
  crossbar DUT (.in0(in0), .in1(in1), .in2(in2), .select(select),
                .out0(out0), .out1(out1), .out2(out2), .valid(valid));

  // instantiate ref
  ref4 ref4_0 (.in0(in0), .in1(in1), .in2(in2), .select(select),
               .out0(expected_out0), .out1(expected_out1), .out2(expected_out2), .valid(expected_valid));

  // drive and check
  task drive_and_check;
    input [7:0] in0d, in1d, in2d;
    input [5:0] selectd;

    begin
      {in0, in1, in2, select} <= #1 {in0d, in1d, in2d, selectd};
      @(posedge clk);
      if (!((out0 === expected_out0) && (out1 === expected_out1) && (out2 === expected_out2) &&
            (valid === expected_valid))) begin
        $display ("time:%06t | ERROR: in2, in1, in0 = %02h, %02h %02h. select = %d %d %d", $time, in2, in1, in0, select[5:4], select[3:2], select[1:0]);
        $display ("            |        expected valid %b, actual %b. expected out2 out1 out0 %02h %02h %02h, actual %02h %02h %02h",
                  expected_valid, valid, expected_out2, expected_out1, expected_out0, out2, out1, out0);
        @(posedge clk);
        //$stop;
        $finish;
      end
      else begin
        $display ("time:%06t | in2, in1, in0 = %02h, %02h %02h. select = %d %d %d", $time, in2, in1, in0, select[5:4], select[3:2], select[1:0]);
        $display ("            | expected valid %b, actual %b. expected out2 out1 out0 %02h %02h %02h, actual %02h %02h %02h",
                  expected_valid, valid, expected_out2, expected_out1, expected_out0, out2, out1, out0);
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

    // test 1, same random data, all select
    for (j = 0; j <=16; j=j+1) begin
      in0 = $random; in1 = in0; in2 = in0;
      for (i = 0; i <=64; i=i+1) begin
        select = i;
        drive_and_check(in0, in1, in2, select);
      end
    end

    // test 2, all 0 data, all select
    in0 = 0; in1 = in0; in2 = 0;
    for (i = 0; i <=64; i=i+1) begin
      select = i;
      drive_and_check(in0, in1, in2, select);
    end

    // test 3, random data, all select
    for (j = 0; j <=16; j=j+1) begin
      in0 = $random; in1 = $random; in2 = $random;
      for (i = 0; i <=64; i=i+1) begin
        select = i;
        drive_and_check(in0, in1, in2, select);
      end
    end

    // test 4, random data, random select
    for (j = 0; j <=16; j=j+1) begin
      in0 = $random; in1 = $random; in2 = $random;
      for (i = 0; i <=64; i=i+1) begin
        select = $random;
        drive_and_check(in0, in1, in2, select);
      end
    end

    $display ("time:%06t | TEST PASSED.", $time);
    $finish;
  end

endmodule
