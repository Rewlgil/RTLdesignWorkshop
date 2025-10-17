module majority (a, b, c, m);
  input a, b, c;
  output m;

/* Approach 1 ******************************/
  // reg m;
  // always @(a or b or c) begin
  //   m = ((a + b + c) > 1) ? 1'b1 : 1'b0;
  // end

/* Approach 2 ******************************/
  assign m = (a & b) | (b & c) | (c & a);

endmodule
