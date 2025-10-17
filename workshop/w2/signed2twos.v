module signed2twos (s, t);
  input [7:0] s;
  output [7:0] t;

  reg [7:0] t;
  always @(s) begin
    if (s[7] == 1)
      t = ~(s & 8'h7f) + 8'h1;
    else
      t = s;
  end

endmodule
