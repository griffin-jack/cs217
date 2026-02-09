`include "common_base_test.svh"

module counter_base_test();
   import tb_type_defines_pkg::*;

   logic [31:0] counter_val;
   logic [31:0] add_val;

   logic [15:0] addr = 16'h400;
   logic [15:0] add_addr = 16'h410;

   initial begin
      tb.power_up(.clk_recipe_a(ClockRecipe::A0),
                  .clk_recipe_b(ClockRecipe::B0),
                  .clk_recipe_c(ClockRecipe::C0));

      $display("[Testbench] Power-up complete.");

      // Let the counter increment for a few hundred ns
      #1000ns;

      $display("[Testbench] Wait complete.");

      // Read from OCL AXI-lite address 0x0000
      
      tb.peek_ocl(.addr(addr), .data(counter_val));
      tb.peek_ocl(.addr(add_addr), .data(add_val));
      $display("[Testbench] Counter value read = %0d and add value read = %0d", counter_val, add_val);

      #100ns;
      tb.peek_ocl(.addr(addr), .data(counter_val));
      tb.peek_ocl(.addr(add_addr), .data(add_val));
      $display("[Testbench] Counter value read = %0d and add value read = %0d", counter_val, add_val);

      // Optional: test expectations
      if (counter_val == 0) begin
         $error("Counter did not increment as expected.");
         report_pass_fail_status(0);
      end 
      else begin
      if (add_val - counter_val <= 5) begin
         $error("Addition did not happen as expected.");
         report_pass_fail_status(0);
      end 
      else begin
         $display("Test passed");
         report_pass_fail_status(1);
      end
      end

      tb.power_down();
      $finish;
   end

   initial begin
   #40000ns;
   $finish;
   end

endmodule
