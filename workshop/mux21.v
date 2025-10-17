module mux21 (s, a, b, f);
  input s, a, b;
  output f;
  
  reg f;
  
  always @ ( s or a or b)
    if (s)
	  f = b;
	else
	  f = a;
	  
endmodule