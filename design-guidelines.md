## Design Guidelines

1. **Module name shall match the filename**
   - Each file shall contain only one module.
   - **Reason:** Easy to identify module origin.
   - **Example:** Module `xyz` → filename `xyz.v`.

2. **Signal naming convention: `from_to_name`**
   - `from`: signal source module name  
   - `to`: signal destination module name
   - `name`: signal identifier  
   - **Reason:** Clarifies source and destination.
   - **Example:**
     ```
     aa_bb_xx    // signal xx, output from module aa, consumed by module bb
     bb_cc_yy    // signal yy, output from module bb, consumed by module cc
     ```

3. **Module instantiation shall use explicit port specification**
   - **Reason:** Guarantees proper signal connections.
   - **Format:**
     ```
     MODULE_NAME MODULE_NAME_INSTANCE_NUMBER
     (.PORT_NAME(SIGNAL_NAME), ...);
     ```
   - **Good Example:**
     ```
     xyz xyz0 (.x(a), .y(b), .z(c));
     ```
   - **Bad Example:**
     ```
     xyz xyz0 (a, b, c);
     ```

5. **Outputs from every module shall be flip-flop outputs**
   - **Reason:** Easier for synthesis, debugging, and physical design work.

6. **(Depends on the project) Use synchronous reset (active high)**

7. **Use only active high signals (except for compatibility)**
   - **Reason:** Simplifies coding and minimize misunderstanding.

8. **No implied memory or latches**
   - **Good Example:**
     ```verilog
     always @ (x or y)
       s = x;
       if (y)
         s = ~x;
     ```
   - **Bad Example:**
     ```verilog
     always @ (x or y)
       if (y)
         s = ~x;
     ```

9. **Use synchronizers for clock domain crossing**
   - **Reason:** Prevents metastability.

10. **Reset only first-stage flip-flops in a pipelined design**
   - **Reason:** Ensures stable post-reset behavior.

11. **No bi-directional signals on chip**
    - **Reason:** Avoids EMI/SI issues.

12. **Case statements shall be full and parallel**
    - **Reason:** Guarantees no implied memory.

13. **Top module shall contain only instantiations**
    - **Reason:** No stray design in top level.

15. **A variable shall be assigned in only one block**
    - **Reason:** Violating this causes RTL/synthesis behavior mismatch.
    - **Bad Example:**
      ```verilog
      always@(x or y)
        z = -y;
      always@(x or y)
        z = x;
      ```
    - **Good Example:**
      ```verilog
      always@(x or y)
        z = x & y;
      ```

17. **Bus index for n-bit signals shall run from `n-1` (MSB) to `0` (LSB):** `[n-1:0]`
    - **Reason:** Compatibility with simulation and synthesis tools.

18. **Use non-blocking assignments in memory blocks**
    - **Example:**
      ```verilog
      always@(posedge clk)
        a_d1 <= #1 a;
      ```
19. **For simulation, use positive clk2q delays**
    - **Reason:** Guarantees no signal transition at clock transition time.
    - 2 examples are given. Use one.
    - **Example 1: (Waiving `#1` warnings at synthesis time)**
      ```verilog
      always@(posedge clk)
        a_d1 <= #1 a;
      ```
    - **Example 2: (define `RTL_SIM` for running simulation)**
      ```verilog
      `ifdef RTL_SIM
        `define CLK2Q #1
      `else
        `define CLK2Q
      `endif

      always@(posedge clk)
        a_d1 <= `CLK2Q a;
      ```
