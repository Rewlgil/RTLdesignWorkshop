module arb (clk, reset, req_a, req_b, grant_a, grant_b);

  input clk, reset;
  input req_a, req_b;
  output grant_a, grant_b;

  /* State list:
   * 0 : last granted B
   * 1 : last granted A
   */
  reg state, next_state;

  /********************* Memory (M) **********************/
  always @(posedge clk) begin
    if (reset)
      state <= #1 1'b0;
    else
      state <= #1 next_state;
  end

  /******** Next State Combinational Logic (NSCL) ********/
  always @(state, req_a, req_b) begin
    case ({req_a, req_b})
      2'b00: next_state = state;
      2'b01: next_state = 1'b0;
      2'b10: next_state = 1'b1;
      2'b11: next_state = ~state;
      default: next_state = 1'b0;
    endcase
  end

  /********** Output Combinational Logic (OCL) ***********/
  reg grant_a, grant_b;
  always @(state, req_a, req_b) begin
    case ({req_a, req_b})
      2'b00: {grant_a, grant_b} = 2'b00;
      2'b01: {grant_a, grant_b} = 2'b01;
      2'b10: {grant_a, grant_b} = 2'b10;
      2'b11: {grant_a, grant_b} = state ? 2'b01 : 2'b10;
      default: {grant_a, grant_b} = 2'b00;
    endcase
  end

endmodule
