// ============================================================================
// Amazon FPGA Hardware Development Kit
// ============================================================================

`include "common_base_test.svh"
`include "design_top_defines.vh"

module design_top_base_test();
import tb_type_defines_pkg::*;


  function automatic real rabs(input real x);
    return (x < 0.0) ? -x : x;
  endfunction

  function automatic int round(input real x);
    return (x > 0.0) ? $floor(x + 0.5) : $ceil(x - 0.5);
  endfunction

  // New reference functions from testbench.cpp
  function automatic real fixed2float(logic signed [kActWordWidth-1:0] val);
      return $itor(val) / (2.0**kActNumFrac);
  endfunction

  function automatic logic signed [kActWordWidth-1:0] float2fixed(real val);
      return round(val * (2.0**kActNumFrac));
  endfunction

  task automatic tanh_ref(input logic [WIDTH_RVA-1:0] vec_in, output logic [WIDTH_RVA-1:0] vec_out);
      for (int i = 0; i < kNumVectorLanes; i++) begin
          logic signed [kActWordWidth-1:0] lane_in = vec_in[i*kActWordWidth +: kActWordWidth];
          real in_float = fixed2float(lane_in);
          real out_float = $tanh(in_float);
          vec_out[i*kActWordWidth +: kActWordWidth] = float2fixed(out_float);
          //$display("Tanh Ref Lane %0d: in=%f in_float=%f out_float=%f, out=%f", i, lane_in, in_float, out_float, vec_out[i*kActWordWidth +: kActWordWidth]);
      end
  endtask

  function automatic real sigmoid_ref(real val);
      return 1.0 / (1.0 + $exp(-val));
  endfunction

  task automatic silu_ref(input logic [WIDTH_RVA-1:0] vec_in, output logic [WIDTH_RVA-1:0] vec_out);
      for (int i = 0; i < kNumVectorLanes; i++) begin
          logic signed [kActWordWidth-1:0] lane_in = vec_in[i*kActWordWidth +: kActWordWidth];
          real in_float = fixed2float(lane_in);
          real out_float = in_float * sigmoid_ref(in_float);
          vec_out[i*kActWordWidth +: kActWordWidth] = float2fixed(out_float);
      end
  endtask
  
  task automatic gelu_ref(input logic [WIDTH_RVA-1:0] vec_in, output logic [WIDTH_RVA-1:0] vec_out);
      for (int i = 0; i < kNumVectorLanes; i++) begin
          logic signed [kActWordWidth-1:0] lane_in = vec_in[i*kActWordWidth +: kActWordWidth];
          real in_float = fixed2float(lane_in);
          real temp = 14.0/22.00;
          real sqrt_pi = $sqrt(temp);
          real out_float = 0.5 * in_float * (1 + $tanh(sqrt_pi * (in_float + 0.044715 * in_float * in_float * in_float)));
          vec_out[i*kActWordWidth +: kActWordWidth] = float2fixed(out_float);
      end
      
  endtask
  
  task automatic relu_ref(input logic [WIDTH_RVA-1:0] vec_in, output logic [WIDTH_RVA-1:0] vec_out);
      for (int i = 0; i < kNumVectorLanes; i++) begin
          logic signed [kActWordWidth-1:0] lane_in = vec_in[i*kActWordWidth +: kActWordWidth];
          real in_float = fixed2float(lane_in);
          real out_float = (in_float > 0) ? in_float : 0;
          vec_out[i*kActWordWidth +: kActWordWidth] = float2fixed(out_float);
      end
  endtask

  task automatic start_data_transfer_counter();
    logic [ADDR_WIDTH_OCL - 1 : 0] addr;
    logic [WIDTH_AXI - 1:0] data;
    addr = ADDR_TX_COUNTER_EN;
    data = 32'h1;
    ocl_wr32(addr, data);
  endtask

  task automatic stop_data_transfer_counter();
    logic [ADDR_WIDTH_OCL - 1 : 0] addr;
    logic [WIDTH_AXI - 1:0] data;
    addr = ADDR_TX_COUNTER_EN;
    data = 32'h0;
    ocl_wr32(addr, data);
  endtask

  task automatic get_data_transfer_cycles();
    logic [ADDR_WIDTH_OCL - 1 : 0] addr;
    logic [WIDTH_AXI - 1:0] data;
    addr = ADDR_TX_COUNTER_READ;
    ocl_rd32(addr, data);
    $display("Data transfer cycles: %0d", data);
  endtask

  task automatic get_compute_cycles();
    logic [ADDR_WIDTH_OCL - 1 : 0] addr;
    logic [WIDTH_AXI - 1:0] data;
    addr = ADDR_COMPUTE_COUNTER_READ;
    ocl_rd32(addr, data);
    $display("Compute cycles: %0d", data);
  endtask


  task automatic compare_act_vectors(
    input [WIDTH_OUTPUT_PORT- 1 : 0] dut_vec_flat,
    input [WIDTH_RVA-1:0] goldenVec
  );
    real diff_sum = 0.0;
    real mse_sum = 0.0;
    real avg_pct;

    logic signed [WIDTH_RVA-1:0] output_flat;
    output_flat = dut_vec_flat[WIDTH_RVA-1:0]; // Extract only

    for (int j = 0; j < kNumVectorLanes; j++) begin
      logic signed [kActWordWidth-1:0] act_i_signed = output_flat[j*kActWordWidth +: kActWordWidth];
      logic signed [kActWordWidth-1:0] exp_i_signed = goldenVec[j*kActWordWidth +: kActWordWidth];

      real a = fixed2float(act_i_signed);
      real e = fixed2float(exp_i_signed);

      real term, mse;
      real diff = rabs(a - e);
      mse  = diff * diff;
      if (rabs(e) < 1)
        term = diff;
      else
        term =  diff / rabs(e);

      diff_sum += term;
      mse_sum += mse;

      $display("OutputPort Computed value = %f and expected value = %f (lane %0d)  err=%0.3f%%",
              a, e, j, 100.0*term);
    end

    avg_pct = (diff_sum * 100.0) / kNumVectorLanes;
    $display("Dest: Average difference observed in compute Act and expected value %0.3f%%", avg_pct);
    $display("Dest: MSE observed in compute Act: %0.6f%%", (mse_sum * 100) / kNumVectorLanes);
  endtask


  task automatic ocl_wr32(input logic [ADDR_WIDTH_OCL - 1 : 0] addr, input logic [WIDTH_AXI - 1:0] data);
    tb.poke_ocl(.addr(addr), .data(data));
  endtask

  task automatic ocl_rva_wr32(input logic [WIDTH_RVA_IN - 1 : 0] data);
  logic [WIDTH_AXI - 1:0] w;
  logic [ADDR_WIDTH_OCL - 1 : 0] addr;
    for (int i = 0; i < LOOP_RVA_IN; i++)
      begin
        addr = ADDR_RVA_IN_START + i*4; 
        w = data[i*WIDTH_AXI +: WIDTH_AXI];
        ocl_wr32(addr, w);
        #1ns;
      end
  endtask
  
  task automatic ocl_act_wr(input logic [WIDTH_RVA-1:0] data);
    logic [WIDTH_AXI - 1:0] w;
    logic [ADDR_WIDTH_OCL - 1 : 0] addr;
    for (int i = 0; i < 16; i++) begin
        addr = ADDR_ACT_PORT_START + i*4;
        w = data[i*WIDTH_AXI +: WIDTH_AXI];
        ocl_wr32(addr, w);
        #1ns;
    end
  endtask

  task automatic randomize(output logic [WIDTH_RVA - 1 : 0] randomised_data);
  for (int i = 0; i < kNumVectorLanes * kActWordWidth / WIDTH_AXI; i++)
      randomised_data[i*WIDTH_AXI +: WIDTH_AXI] = $urandom();
  endtask

  task automatic rva_format(input logic rw,
                             input logic [ADDR_WIDTH_RVA_IN - 1 : 0] addr,
                             input logic [WIDTH_RVA - 1 : 0] data,
                             output logic [WIDTH_RVA_IN - 1 : 0] rva_msg);
    rva_msg = 0;
    rva_msg[600] = rw;
    rva_msg[599:536] = 64'hffff_ffff_ffff_ffff; // wstrb
    rva_msg[535:512] = addr;
    rva_msg[511:0] = data;
  endtask

  task automatic ocl_rva_r32(input logic [WIDTH_AXI - 1:0] error_cnt, input logic [WIDTH_RVA - 1 : 0] data_cmp, input logic [WIDTH_RVA_IN - 1 : 0] rva_in);
  logic [WIDTH_AXI - 1:0] r;
  logic [WIDTH_RVA - 1:0] data;
  logic [ADDR_WIDTH_OCL - 1:0] addr;

  ocl_rva_wr32(rva_in);

    for (int i = 0; i < 16; i++) // 16 * 32 = 512 bits
      begin
        addr = ADDR_RVA_OUT_START + i*4;
        ocl_rd32(addr, r);
        data[i*32 +: 32] = r;
        #1ns;
      end
    if (data !== data_cmp) begin
      $error("RVA readback mismatch: exp=0x%h got=0x%h", data_cmp, data);
      error_cnt++;
    end
    else
      $display("RVA readback OK: 0x%h", data);
  endtask

  task automatic ocl_rd32(input logic [ADDR_WIDTH_OCL - 1 : 0] addr, output logic [WIDTH_AXI - 1:0] data);
    tb.peek_ocl(.addr(addr), .data(data));
  endtask

  logic [WIDTH_AXI - 1:0] w;
  logic [ADDR_WIDTH_OCL - 1 : 0] addr_w;
  logic [WIDTH_AXI - 1:0] input_word;
  logic [ADDR_WIDTH_OCL - 1 : 0] addr_in;
  logic [ADDR_WIDTH_OCL - 1 : 0] addr_cfg;
  logic [WIDTH_AXI - 1:0] rd;

  logic rva_in_rw;
  logic [WIDTH_RVA - 1 : 0] rva_in_data, rva_out;
  logic [ADDR_WIDTH_RVA_IN - 1 : 0] rva_in_addr;
  logic [WIDTH_RVA_IN - 1 : 0] rva_in;

  logic [WIDTH_AXI - 1:0] error_cnt;

  logic [WIDTH_RVA-1:0] test_in [0:15];
  logic [WIDTH_RVA-1:0] expected_out [0:15];
  logic [WIDTH_OUTPUT_PORT-1:0] output_obtained_flat [0:15];
  
  logic [WIDTH_RVA-1:0] expected_output_q[$];

  /*initial begin
    #40000ns;
    $finish;
    end*/


  initial
  begin
    error_cnt = 'b0;
    tb.power_up(.clk_recipe_a(ClockRecipe::A0),
              .clk_recipe_b(ClockRecipe::B0),
              .clk_recipe_c(ClockRecipe::C0));

    #500ns;

    for (int i = 0; i < 4; i++) begin
      randomize(test_in[i]);
    end

    // Calculate all expected outputs first
    tanh_ref(test_in[0], expected_out[0]);
    silu_ref(test_in[1], expected_out[1]);
    gelu_ref(expected_out[1], expected_out[2]);
    relu_ref(expected_out[2], expected_out[3]);

    $display("---- CONFIGURE ActUnit ----");
    start_data_transfer_counter();

    rva_in_rw = 1;

    rva_in_data = 512'd0;
    rva_in_data[127:0] = 128'h0000_0000_0000_0000_0000_0101_0A04_0001;
    rva_in_addr = 24'h800010;
    rva_format(rva_in_rw, rva_in_addr, rva_in_data, rva_in);
    ocl_rva_wr32(rva_in);

    rva_in_data = 512'd0;
    rva_in_data[127:0] = 128'h0000_0000_0000_44C4_44F4_44E4_3440_B030;
    rva_in_addr = 24'h800020;
    rva_format(rva_in_rw, rva_in_addr, rva_in_data, rva_in);
    ocl_rva_wr32(rva_in);
    
    rva_in_data = 512'd0;
    rva_in_data[127:0] = 128'h0000_0000_0000_0000_0000_004C_1C24_44D4;
    rva_in_addr = 24'h800030;
    rva_format(rva_in_rw, rva_in_addr, rva_in_data, rva_in);
    ocl_rva_wr32(rva_in);
    
    $display("---- START ----");
    addr_w = ADDR_START_CFG;
    input_word = 32'h1;
    ocl_wr32(addr_w, input_word);
    #100ns;
    stop_data_transfer_counter();
    
    // Provide inputs and check outputs
    $display("---- PROVIDE INPUTS AND READ OUTPUTS ----");
    
    // Tanh
    ocl_act_wr(test_in[0]);
    #50ns;

    // Silu
    ocl_act_wr(test_in[1]);
    #50ns;
    
    // Gelu needs no new input
    
    // Relu needs no new input
    
    // Read all outputs
    for (int j = 0; j < 4; j++) begin
      for (int i = 0; i < LOOP_OUTPUT_PORT; i++) begin
          addr_w = ADDR_OUTPUT_PORT_START + i*4;
          start_data_transfer_counter();
          ocl_rd32(addr_w, rd);
          stop_data_transfer_counter();
          output_obtained_flat[j][i*WIDTH_AXI +: WIDTH_AXI] = rd;
      end
      compare_act_vectors(output_obtained_flat[j], expected_out[j]);
    end

    get_data_transfer_cycles();
    get_compute_cycles();
    
    
    #500ns;
    tb.power_down();
    if (error_cnt == 0)
      $display("---- TEST FINISHED ----");
    else
      report_pass_fail_status(0);
    
    $finish;
  end
endmodule
