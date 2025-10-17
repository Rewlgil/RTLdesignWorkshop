module ref_minimux (in0, in1, in2, s, out);
  input [7:0] in0, in1, in2;
  input [1:0] s;
  output [7:0] out;

  reg [7:0] out;

  always @(s or in0 or in1 or in2)
    case (s)
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
      2'b11: out = 0;
    endcase
endmodule

module ref4 (in0, in1, in2, select,
                 out0, out1, out2, valid);
  input [7:0] in0, in1, in2;
  input [5:0] select;
  output [7:0] out0, out1, out2;
  output valid;

  wire [1:0] s0, s1, s2;

  assign s0 = select[1:0];
  assign s1 = select[3:2];
  assign s2 = select[5:4];

  ref_minimux ref_minimux0 (.in0(in0), .in1(in1), .in2(in2), .s(s0), .out(out0));
  ref_minimux ref_minimux1 (.in0(in0), .in1(in1), .in2(in2), .s(s1), .out(out1));
  ref_minimux ref_minimux2 (.in0(in0), .in1(in1), .in2(in2), .s(s2), .out(out2));

  assign valid = !( (s0 == 2'b11) || (s1 == 2'b11) || (s2 == 2'b11) || (s0 == s1) || (s0 == s2) || (s1 == s2) );

endmodule
