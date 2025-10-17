module signed_mag_compare (a, b, aLTb, aGTb, aEQb);
        
  input [6:0] a, b;
  output aLTb, aGTb, aEQb;

  reg aLTb, aGTb, aEQb;
  always @(a or b) begin
    if ((a == b) | 
        ((a[5:0] == 0) & (b[5:0] == 0))) begin
      aLTb = 1'b0;
      aGTb = 1'b0;
      aEQb = 1'b1;
    end
    else if (a[6] == b[6]) begin
      if (a[5:0] < b[5:0]) begin
        aLTb = a[6] ? 1'b0 : 1'b1;
        aGTb = a[6] ? 1'b1 : 1'b0;
        aEQb = 1'b0;
      end 
      else begin
        aLTb = a[6] ? 1'b1 : 1'b0;
        aGTb = a[6] ? 1'b0 : 1'b1;
        aEQb = 1'b0;
      end
    end
    else begin
      aLTb = a[6] ? 1'b1 : 1'b0;
      aGTb = a[6] ? 1'b0 : 1'b1;
      aEQb = 1'b0;
    end
  end

endmodule
