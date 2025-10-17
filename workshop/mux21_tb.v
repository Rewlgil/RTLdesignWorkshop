`timescale 1ns/100ps 
module mux21_tb;

 //inputs
 reg s, a, b;
 //outputs
 wire f;

 mux21 DUT(
  .s(s),
  .a(a),
  .b(b),
  .f(f)
 );

 //initialize inputs

 initial begin
//simulation files dumped to the test_2_1mux file
  $dumpfile("mux21_tb.vcd");
  $dumpvars(0,mux21_tb);

  #0   
       s =1'b0; a = 1'b0; b = 1'b0;
  #5   s =1'b0; a = 1'b0; b = 1'b1;
  #5   s =1'b0; a = 1'b1; b = 1'b0;
  #5   s =1'b0; a = 1'b1; b = 1'b1;
  #5   s =1'b1; a = 1'b0; b = 1'b0;
  #5   s =1'b1; a = 1'b0; b = 1'b1;
  #5   s =1'b1; a = 1'b1; b = 1'b0;
  #5   s =1'b1; a = 1'b1; b = 1'b1;

  #5 $finish;
 end
endmodule