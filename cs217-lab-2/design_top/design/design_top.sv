// ============================================================================
// Amazon FPGA Hardware Development Kit
//
// Copyright 2024 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amaz_n.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.
// ============================================================================

//====================================================================================
// Top level module file for design_top
//====================================================================================

`include "./concat_ActUnit.v"
`include "./counter.v"

module design_top
  #(
     parameter EN_DDR = 0,
     parameter EN_HBM = 0
   )
   (
`include "cl_ports.vh"
   );



`include "design_top_defines.vh"
`include "cl_id_defines.vh"
  
  // ---------- AXI-Lite (master side of the reg-slice) to our bridge ----------
  logic [15:0]  axil_awaddr_m;
  logic         axil_awvalid_m, axil_awready_m;
  logic [31:0]  axil_wdata_m;
  logic [3:0]   axil_wstrb_m;
  logic         axil_wvalid_m, axil_wready_m;
  logic [1:0]   axil_bresp_m;
  logic         axil_bvalid_m, axil_bready_m;

  logic [15:0]  axil_araddr_m;
  logic         axil_arvalid_m, axil_arready_m;
  logic [31:0]  axil_rdata_m;
  logic [1:0]   axil_rresp_m;
  logic         axil_rvalid_m, axil_rready_m;

  // ---------- ActUnit RVA channels ----------
  logic         rvain_vld,  rvain_rdy;
  logic [600:0] rvain_dat;              // {rw,addr[23:0],data[511:0]}

  logic         rvaout_vld, rvaout_rdy;
  logic [511:0] rvaout_dat;
  
  // ---------- ActUnit Input/Output Ports ----------
  logic         act_port_vld_in, act_port_rdy_out;
  logic [511:0] act_port_dat_in;

  logic         output_port_vld, output_port_rdy;
  logic [521:0] output_port_dat; 

  // ---------- ActUnit start ----------
  logic         start_vld, start_rdy;
  logic         start_dat;              // bool payload to ActUnit

  // ---------- ActUnit other ports (tied off) ----------
  logic         done_vld, done_rdy, done_dat;

  //==============================
  // Simple counter Instantiation
  //==============================
  logic [31:0] data_transfer_cycles;
  logic [31:0] compute_cycles;

  logic transfer_en, compute_en;
  assign compute_en = start_dat & ~done & ~output_port_valid_d;

  counter #(.WIDTH(32)) u_data_transfer_counter (
            .clk (clk_main_a0),
            .rst_n (rst_main_n),
            .en (transfer_en),
            .q (data_transfer_cycles)
          );

  counter #(.WIDTH(32)) u_compute_counter (
            .clk (clk_main_a0),
            .rst_n (rst_main_n),
            .en (compute_en),
            .q (compute_cycles)
          );



  //==============================
  // ActUnit instance
  //==============================

  // TODO 1: Instantiate your ActUnit module here
  //    1. All the wires needed are already declared above
  //    2. Connect the clock and reset signals (reset is active low, so no inversion needed)
  //    3. Connect the start signal wires
  //    4. Connect the RVA in/out signals
  //    5. Connect the act_port stream in signals
  //    6. Connect the output_port stream out signals
  //    7. Connect the done port signals 

  ////////// YOUR IMPLEMENTATION STARTS HERE //////////

  ActUnit u_ActUnit (
    .clk             (clk_main_a0),
    .rst             (rst_main_n),

    // Start Signal
    .start_vld       (start_vld),
    .start_rdy       (start_rdy),
    .start_dat       (start_dat),

    .rva_in_vld      (rvain_vld),
    .rva_in_rdy      (rvain_rdy),
    .rva_in_dat      (rvain_dat),

    .rva_out_vld     (rvaout_vld),
    .rva_out_rdy     (rvaout_rdy),
    .rva_out_dat     (rvaout_dat),

    // Act Port
    .act_port_vld    (act_port_vld_in),
    .act_port_rdy    (act_port_rdy_out),
    .act_port_dat    (act_port_dat_in),

    // Output Port
    .output_port_vld (output_port_vld),
    .output_port_rdy (output_port_rdy),
    .output_port_dat (output_port_dat),

    // Done Signal
    .done_vld        (done_vld),
    .done_rdy        (done_rdy),
    .done_dat        (done_dat)
  );
 
  ///////// YOUR IMPLEMENTATION ENDS HERE //////////

  //=============================================================================
  // GLOBALS
  //=============================================================================
  always_comb
  begin
    cl_sh_flr_done    = 1'b1;
    cl_sh_status0     = 32'h0;
    cl_sh_status1     = 32'h0;
    cl_sh_status2     = 32'h0;
    cl_sh_id0         = `CL_SH_ID0;
    cl_sh_id1         = `CL_SH_ID1;
    cl_sh_status_vled = 16'h0;
    cl_sh_dma_wr_full = 1'b0;
    cl_sh_dma_rd_full = 1'b0;
  end

  //=============================================================================
  // OCL REGISTER SLICE INSTANCE
  //=============================================================================

  // OCL AXI-Lite Register Slice Connections
  logic [15:0] ocl_awaddr;
  logic        ocl_awvalid;
  logic        ocl_awready;
  logic [31:0] ocl_wdata;
  logic [3:0]  ocl_wstrb;
  logic        ocl_wvalid;
  logic        ocl_wready;
  logic [1:0]  ocl_bresp;
  logic        ocl_bvalid;
  logic        ocl_bready;
  logic [15:0] ocl_araddr;
  logic        ocl_arvalid;
  logic        ocl_arready;
  logic [31:0] ocl_rdata;
  logic [1:0]  ocl_rresp;
  logic        ocl_rvalid;
  logic        ocl_rready;

  // Internal master-side signals from reg-slice to our simple AXI-Lite slave
  logic [2:0]   axil_awprot_m;

  axi_register_slice_light AXIL_OCL_REG_SLC_BOT_SLR (
                             .aclk          (clk_main_a0),
                             .aresetn       (rst_main_n),

                             // Shell → CL (slave port of slice)
                             .s_axi_awaddr  (ocl_cl_awaddr),
                             .s_axi_awprot  ('0),
                             .s_axi_awvalid (ocl_cl_awvalid),
                             .s_axi_awready (cl_ocl_awready),
                             .s_axi_wdata   (ocl_cl_wdata),
                             .s_axi_wstrb   (ocl_cl_wstrb),
                             .s_axi_wvalid  (ocl_cl_wvalid),
                             .s_axi_wready  (cl_ocl_wready),
                             .s_axi_bresp   (cl_ocl_bresp),
                             .s_axi_bvalid  (cl_ocl_bvalid),
                             .s_axi_bready  (ocl_cl_bready),
                             .s_axi_araddr  (ocl_cl_araddr),
                             .s_axi_arvalid (ocl_cl_arvalid),
                             .s_axi_arready (cl_ocl_arready),
                             .s_axi_rdata   (cl_ocl_rdata),
                             .s_axi_rresp   (cl_ocl_rresp),
                             .s_axi_rvalid  (cl_ocl_rvalid),
                             .s_axi_rready  (ocl_cl_rready),

                             // CL-internal master side (wire these!)
                             .m_axi_awaddr  (axil_awaddr_m),
                             .m_axi_awprot  (axil_awprot_m),
                             .m_axi_awvalid (axil_awvalid_m),
                             .m_axi_awready (axil_awready_m),
                             .m_axi_wdata   (axil_wdata_m),
                             .m_axi_wstrb   (axil_wstrb_m),
                             .m_axi_wvalid  (axil_wvalid_m),
                             .m_axi_wready  (axil_wready_m),
                             .m_axi_bresp   (axil_bresp_m),
                             .m_axi_bvalid  (axil_bvalid_m),
                             .m_axi_bready  (axil_bready_m),

                             .m_axi_araddr  (axil_araddr_m),
                             .m_axi_arvalid (axil_arvalid_m),
                             .m_axi_arready (axil_arready_m),
                             .m_axi_rdata   (axil_rdata_m),
                             .m_axi_rresp   (axil_rresp_m),
                             .m_axi_rvalid  (axil_rvalid_m),
                             .m_axi_rready  (axil_rready_m)
                           );

  //=============================================================================
  // AXI-Lite to internal logic (simple decoder + RVA bridge)
  //=============================================================================
  // Simple AXI-Lite slave accepting one write/read at a time
  // Write channel bookkeeping
  logic        wr_aw_captured, wr_w_captured;
  logic [15:0] wr_addr_q;
  logic [31:0] wr_data_q;

  // Default AXI responses
  assign axil_awprot_m = 3'b000;

  // Ready when not holding captured info
  logic axi_ready;
  assign axil_awready_m = ~wr_aw_captured && axi_ready;
  assign axil_wready_m  = ~wr_w_captured && axi_ready;


  logic [600:0] rvain_dat_sig;
  logic [511:0] act_port_dat_sig;
  logic [4:0] act_write_idx;

  // BRESP/valid generation
  always_ff @(posedge clk_main_a0 or negedge rst_main_n) begin
    if (!rst_main_n) begin
      wr_aw_captured <= 1'b0;
      wr_w_captured  <= 1'b0;
      wr_addr_q      <= '0;
      wr_data_q      <= '0;
      axil_bvalid_m  <= 1'b0;
      axil_bresp_m   <= 2'b00;

      // RVA in defaults
      rvain_dat_sig      <= '0;
      rvain_dat          <= '0;
      rvain_vld          <= 1'b0;

      // act_port in defaults
      act_port_dat_sig <= '0;
      act_port_dat_in  <= '0;
      act_port_vld_in  <= 1'b0;
      act_write_idx    <= '0;

      // Start defaults
      start_dat         <= 1'b0;
      start_vld         <= 1'b0;

      transfer_en <= 1'b0;

      axi_ready <= 1'b1;

    end else begin
      // Capture address/data
      if (axil_awvalid_m && axil_awready_m) begin
        wr_aw_captured <= 1'b1;
        wr_addr_q      <= axil_awaddr_m;
      end
      if (axil_wvalid_m && axil_wready_m) begin
        wr_w_captured <= 1'b1;
        wr_data_q     <= axil_wdata_m;
      end

      // Fire a write when both parts captured and no BRESP pending
      if (wr_aw_captured && wr_w_captured && !axil_bvalid_m) begin
        for (int i = 0; i < LOOP_RVA_IN; i++) begin 
            if (wr_addr_q == (ADDR_RVA_IN_START + i*4)) begin
              if ( i == LOOP_RVA_IN - 1 ) begin // Last write
                rvain_dat_sig[600:576] <= wr_data_q[24:0]; // Capture final bits
                rvain_dat <= {wr_data_q[24:0], rvain_dat_sig[575:0]};
                rvain_vld <= 1'b1;
                axi_ready <= 1'b0;
              end
              else begin
                  rvain_dat_sig[(i+1)*32-1 -: 32] <= wr_data_q;
                  axi_ready <= 1'b1;
              end
            end
        end

        for (int i = 0; i < LOOP_ACT_PORT; i++) begin // 19*32 = 608 bits
          if (wr_addr_q == (ADDR_ACT_PORT_START + i*4)) begin
            if ( i == LOOP_ACT_PORT - 1 ) begin // Last write
              act_port_vld_in <= 1'b1;
              axi_ready <= 1'b0;
              act_port_dat_in <= {wr_data_q, act_port_dat_sig[479:0]};
            
            end
              act_port_dat_sig[(i+1)*32-1 -: 32] <= wr_data_q;
              axi_ready <= 1'b1;
          end
        end

        unique case (wr_addr_q)
          ADDR_START_CFG: begin
            start_dat <= wr_data_q[0];
            start_vld <= 1'b1;
            axi_ready <= 1'b0;
          end
          ADDR_TX_COUNTER_EN: begin
            transfer_en <= wr_data_q[0];
            axi_ready <= 1'b1;
          end
          default: begin
          end
        endcase
        wr_aw_captured <= 1'b0;
        wr_w_captured  <= 1'b0;
        axil_bvalid_m  <= 1'b1;
      end

      else if (rvain_rdy && rvain_vld && ~axil_bvalid_m) begin
        rvain_vld <= 1'b0;
        axi_ready <= 1'b1;
      end
      
      else if (act_port_vld_in && act_port_rdy_out && ~axil_bvalid_m) begin
          act_port_vld_in <= 1'b0;
          axi_ready <= 1'b1;
      end
      
      else if (start_rdy && start_vld) begin
        start_vld <= 1'b0;
        axi_ready <= 1'b1;
      end

      else if (axil_bvalid_m && axil_bready_m) begin
        axil_bvalid_m <= 1'b0;
      end
    end
  end

  logic [511:0] rvaout_dat_q;
  logic rva_valid_d;

  logic output_port_valid_d;
  logic [521:0] output_port_dat_q;

  // Tie off new ports
  logic done;

  // AXI-Lite read handshake: respond in-place
  always_ff @(posedge clk_main_a0 or negedge rst_main_n) begin
    if (!rst_main_n) begin
      axil_arready_m <= 1'b1;
      axil_rvalid_m  <= 1'b0;
      axil_rdata_m   <= 32'h0;
      axil_rresp_m   <= 2'b00;

      done_rdy <= 1'b1;
      done <= 1'b0;

      output_port_valid_d <= 1'b0;
      output_port_rdy     <= 1'b1;
      output_port_dat_q   <= '0;

      rvaout_rdy <= 1'b1; 
      rvaout_dat_q <= '0;
      rva_valid_d <= 1'b0;

    end else begin

      if (done_rdy && done_vld) begin
        done_rdy <= 1'b0;
        done <= done_dat;
        //$display("Done signal received: %0b", done_dat);
      end
      else 
        done_rdy <= 1'b1; 

      if (output_port_rdy && output_port_vld && ~output_port_valid_d) begin
        output_port_dat_q <= output_port_dat;
        output_port_valid_d <= 1'b1;
        output_port_rdy <= 1'b0;
        //$display("Output Port Message Received: 0x%h", output_port_dat);
      end

      if (rvaout_vld && rvaout_rdy) begin
        rvaout_dat_q <= rvaout_dat;
        rvaout_rdy <= 1'b0; 
        rva_valid_d <= 1'b1;
      end
      else 
        rvaout_rdy <= 1'b1; 
      
      if (axil_arvalid_m && axil_arready_m && rva_valid_d) begin
        axil_arready_m <= 1'b0;
        for (int i = 0; i < LOOP_RVA_OUT; i++) begin // 16 * 32 = 512 bits
            if (axil_araddr_m == (ADDR_RVA_OUT_START + i*4)) begin
                axil_rdata_m <= rvaout_dat_q[(i+1)*32-1 -: 32];
                if (i == (LOOP_RVA_OUT - 1)) begin
                    rva_valid_d <= 1'b0;
                end
            end
        end
        axil_rresp_m  <= 2'b00;
        axil_rvalid_m <= 1'b1;
      end
      if (axil_arvalid_m && axil_arready_m && output_port_valid_d) begin
        // TODO 2: Add read response for the output port
        //    1. When axil_araddr_m matches ADDR_OUTPUT_PORT_START and for all the address offsets till LOOP_OUTPUT_PORT,
        //       assign output_port_dat_q to read axi data
        //    2. You will need to handle the last read differently as the output port data width is 522 bits
        //    3. Look the example above for rvaout read response for reference

        //////// YOUR IMPLEMENTATION STARTS HERE //////////

        axil_arready_m <= 1'b0; // Block new address requests while handling this one
        
        for (int i = 0; i < LOOP_OUTPUT_PORT; i++) begin 
            if (axil_araddr_m == (ADDR_OUTPUT_PORT_START + i*4)) begin
                if (i == (LOOP_OUTPUT_PORT - 1)) begin
                    // Last read: Handle the 522-bit width (bits 521:512 are remaining)
                    // Pad the upper 22 bits with zeros
                    axil_rdata_m <= {22'b0, output_port_dat_q[521:512]};
                    
                    // CRITICAL FIX: Clear valid and assert ready to enable next packet transfer
                    output_port_valid_d <= 1'b0;
                    output_port_rdy <= 1'b1;
                end
                else begin
                    // Standard 32-bit chunks
                    axil_rdata_m <= output_port_dat_q[(i+1)*32-1 -: 32];
                end
            end
        end
        axil_rresp_m  <= 2'b00;
        axil_rvalid_m <= 1'b1;

        ///////// YOUR IMPLEMENTATION ENDS HERE //////////
      end
      if (axil_arvalid_m && axil_arready_m && ~output_port_valid_d && ~rva_valid_d) begin
        // TODO 3: Add read response for the two counters
        //   1. When axil_araddr_m matches ADDR_TX_COUNTER_READ, assign data_transfer_cycles to read axi data
        //   2. When axil_araddr_m matches ADDR_COMPUTE_COUNTER_READ, assign compute_cycles to read axi data

        ////// YOUR IMPLEMENTATION STARTS HERE //////////

        axil_arready_m <= 1'b0;
        
        case (axil_araddr_m)
            ADDR_TX_COUNTER_READ: begin
                axil_rdata_m <= data_transfer_cycles;
            end
            ADDR_COMPUTE_COUNTER_READ: begin
                axil_rdata_m <= compute_cycles;
            end
            default: begin
                axil_rdata_m <= 32'h0;
            end
        endcase
        
        axil_rresp_m  <= 2'b00;
        axil_rvalid_m <= 1'b1;

        ////// YOUR IMPLEMENTATION ENDS HERE //////////

      end
      if (axil_rvalid_m && axil_rready_m) begin
        axil_rvalid_m  <= 1'b0;
        axil_arready_m <= 1'b1;
      end
    end
  end

  //=============================================================================
  // PCIM
  //=============================================================================

  // Cause Protocol Violations
  always_comb
  begin
    cl_sh_pcim_awaddr  = 'b0;
    cl_sh_pcim_awsize  = 'b0;
    cl_sh_pcim_awburst = 'b0;
    cl_sh_pcim_awvalid = 'b0;

    cl_sh_pcim_wdata   = 'b0;
    cl_sh_pcim_wstrb   = 'b0;
    cl_sh_pcim_wlast   = 'b0;
    cl_sh_pcim_wvalid  = 'b0;

    cl_sh_pcim_araddr  = 'b0;
    cl_sh_pcim_arsize  = 'b0;
    cl_sh_pcim_arburst = 'b0;
    cl_sh_pcim_arvalid = 'b0;
  end

  // Remaining CL Output Ports
  always_comb
  begin
    cl_sh_pcim_awid    = 'b0;
    cl_sh_pcim_awlen   = 'b0;
    cl_sh_pcim_awcache = 'b0;
    cl_sh_pcim_awlock  = 'b0;
    cl_sh_pcim_awprot  = 'b0;
    cl_sh_pcim_awqos   = 'b0;
    cl_sh_pcim_awuser  = 'b0;

    cl_sh_pcim_wid     = 'b0;
    cl_sh_pcim_wuser   = 'b0;

    cl_sh_pcim_arid    = 'b0;
    cl_sh_pcim_arlen   = 'b0;
    cl_sh_pcim_arcache = 'b0;
    cl_sh_pcim_arlock  = 'b0;
    cl_sh_pcim_arprot  = 'b0;
    cl_sh_pcim_arqos   = 'b0;
    cl_sh_pcim_aruser  = 'b0;

    cl_sh_pcim_rready  = 'b0;
  end

  //=============================================================================
  // PCIS
  //=============================================================================

  // Cause Protocol Violations
  always_comb
  begin
    cl_sh_dma_pcis_bresp   = 'b0;
    cl_sh_dma_pcis_rresp   = 'b0;
    cl_sh_dma_pcis_rvalid  = 'b0;
  end

  // Remaining CL Output Ports
  always_comb
  begin
    cl_sh_dma_pcis_awready = 'b0;

    cl_sh_dma_pcis_wready  = 'b0;

    cl_sh_dma_pcis_bid     = 'b0;
    cl_sh_dma_pcis_bvalid  = 'b0;

    cl_sh_dma_pcis_arready  = 'b0;

    cl_sh_dma_pcis_rid     = 'b0;
    cl_sh_dma_pcis_rdata   = 'b0;
    cl_sh_dma_pcis_rlast   = 'b0;
    cl_sh_dma_pcis_ruser   = 'b0;
  end

  //=============================================================================
  // SDA
  //=============================================================================

  // Cause Protocol Violations
  always_comb
  begin
    cl_sda_bresp   = 'b0;
    cl_sda_rresp   = 'b0;
    cl_sda_rvalid  = 'b0;
  end

  // Remaining CL Output Ports
  always_comb
  begin
    cl_sda_awready = 'b0;
    cl_sda_wready  = 'b0;

    cl_sda_bvalid = 'b0;

    cl_sda_arready = 'b0;

    cl_sda_rdata   = 'b0;
  end

  //=============================================================================
  // SH_DDR
  //=============================================================================

  sh_ddr
    #(
      .DDR_PRESENT (EN_DDR)
    )
    SH_DDR
    (
      .clk                       (clk_main_a0 ),
      .rst_n                     (            ),
      .stat_clk                  (clk_main_a0 ),
      .stat_rst_n                (            ),
      .CLK_DIMM_DP               (CLK_DIMM_DP ),
      .CLK_DIMM_DN               (CLK_DIMM_DN ),
      .M_ACT_N                   (M_ACT_N     ),
      .M_MA                      (M_MA        ),
      .M_BA                      (M_BA        ),
      .M_BG                      (M_BG        ),
      .M_CKE                     (M_CKE       ),
      .M_ODT                     (M_ODT       ),
      .M_CS_N                    (M_CS_N      ),
      .M_CLK_DN                  (M_CLK_DN    ),
      .M_CLK_DP                  (M_CLK_DP    ),
      .M_PAR                     (M_PAR       ),
      .M_DQ                      (M_DQ        ),
      .M_ECC                     (M_ECC       ),
      .M_DQS_DP                  (M_DQS_DP    ),
      .M_DQS_DN                  (M_DQS_DN    ),
      .cl_RST_DIMM_N             (RST_DIMM_N  ),
      .cl_sh_ddr_axi_awid        (            ),
      .cl_sh_ddr_axi_awaddr      (            ),
      .cl_sh_ddr_axi_awlen       (            ),
      .cl_sh_ddr_axi_awsize      (            ),
      .cl_sh_ddr_axi_awvalid     (            ),
      .cl_sh_ddr_axi_awburst     (            ),
      .cl_sh_ddr_axi_awuser      (            ),
      .cl_sh_ddr_axi_awready     (            ),
      .cl_sh_ddr_axi_wdata       (            ),
      .cl_sh_ddr_axi_wstrb       (            ),
      .cl_sh_ddr_axi_wlast       (            ),
      .cl_sh_ddr_axi_wvalid      (            ),
      .cl_sh_ddr_axi_wready      (            ),
      .cl_sh_ddr_axi_bid         (            ),
      .cl_sh_ddr_axi_bresp       (            ),
      .cl_sh_ddr_axi_bvalid      (            ),
      .cl_sh_ddr_axi_bready      (            ),
      .cl_sh_ddr_axi_arid        (            ),
      .cl_sh_ddr_axi_araddr      (            ),
      .cl_sh_ddr_axi_arlen       (            ),
      .cl_sh_ddr_axi_arsize      (            ),
      .cl_sh_ddr_axi_arvalid     (            ),
      .cl_sh_ddr_axi_arburst     (            ),
      .cl_sh_ddr_axi_aruser      (            ),
      .cl_sh_ddr_axi_arready     (            ),
      .cl_sh_ddr_axi_rid         (            ),
      .cl_sh_ddr_axi_rdata       (            ),
      .cl_sh_ddr_axi_rresp       (            ),
      .cl_sh_ddr_axi_rlast       (            ),
      .cl_sh_ddr_axi_rvalid      (            ),
      .cl_sh_ddr_axi_rready      (            ),
      .sh_ddr_stat_bus_addr      (            ),
      .sh_ddr_stat_bus_wdata     (            ),
      .sh_ddr_stat_bus_wr        (            ),
      .sh_ddr_stat_bus_rd        (            ),
      .sh_ddr_stat_bus_ack       (            ),
      .sh_ddr_stat_bus_rdata     (            ),
      .ddr_sh_stat_int           (            ),
      .sh_cl_ddr_is_ready        (            )
    );

  always_comb
  begin
    cl_sh_ddr_stat_ack   = 'b0;
    cl_sh_ddr_stat_rdata = 'b0;
    cl_sh_ddr_stat_int   = 'b0;
  end

  //=============================================================================
  // USER-DEFIEND INTERRUPTS
  //=============================================================================

  always_comb
  begin
    cl_sh_apppf_irq_req = 'b0;
  end

  //=============================================================================
  // VIRTUAL JTAG
  //=============================================================================

  always_comb
  begin
    tdo = 'b0;
  end

  //=============================================================================
  // HBM MONITOR IO
  //=============================================================================

  always_comb
  begin
    hbm_apb_paddr_1   = 'b0;
    hbm_apb_pprot_1   = 'b0;
    hbm_apb_psel_1    = 'b0;
    hbm_apb_penable_1 = 'b0;
    hbm_apb_pwrite_1  = 'b0;
    hbm_apb_pwdata_1  = 'b0;
    hbm_apb_pstrb_1   = 'b0;
    hbm_apb_pready_1  = 'b0;
    hbm_apb_prdata_1  = 'b0;
    hbm_apb_pslverr_1 = 'b0;

    hbm_apb_paddr_0   = 'b0;
    hbm_apb_pprot_0   = 'b0;
    hbm_apb_psel_0    = 'b0;
    hbm_apb_penable_0 = 'b0;
    hbm_apb_pwrite_0  = 'b0;
    hbm_apb_pwdata_0  = 'b0;
    hbm_apb_pstrb_0   = 'b0;
    hbm_apb_pready_0  = 'b0;
    hbm_apb_prdata_0  = 'b0;
    hbm_apb_pslverr_0 = 'b0;
  end

  //=============================================================================
  //
  //=============================================================================

  always_comb
  begin
    PCIE_EP_TXP    = 'b0;
    PCIE_EP_TXN    = 'b0;

    PCIE_RP_PERSTN = 'b0;
    PCIE_RP_TXP    = 'b0;
    PCIE_RP_TXN    = 'b0;
  end

endmodule // design_top
