// ============================================================================
// Amazon FPGA Hardware Development Kit
//
// Copyright 2024 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.
// ============================================================================

//====================================================================================
// Top level module file for counter
//====================================================================================

`include "./concat_counter_top.v"

module counter
    #(
      parameter EN_DDR = 0,
      parameter EN_HBM = 0
    )
    (
      `include "cl_ports.vh"
    );

`include "cl_id_defines.vh"
`include "counter_defines.vh"

//==============================
// Simple counter Instantiation
//==============================
logic [31:0] counter_val;
logic [31:0] add_val;

counter_top u_counter_top (
      .clk(clk_main_a0),
      .rst(rst_main_n),
      .counter_out(counter_val),
      .add_out(add_val)
    );

//=============================================================================
// GLOBALS
//=============================================================================
always_comb begin
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

axi_register_slice_light AXIL_OCL_REG_SLC_BOT_SLR (
   .aclk          (clk_main_a0),
   .aresetn       (rst_main_n),

   .s_axi_awaddr  (ocl_cl_awaddr),
   .s_axi_awprot  (2'b00),
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

   // =========== Unused (Master) ports: TIE TO CONSTANTS! ==========
   .m_axi_awaddr  (),
   .m_axi_awprot  (),
   .m_axi_awvalid (),
   .m_axi_awready (1'b0),
   .m_axi_wdata   (),
   .m_axi_wstrb   (),
   .m_axi_wvalid  (),
   .m_axi_wready  (1'b0),
   .m_axi_bresp   (2'b0),
   .m_axi_bvalid  (1'b0),
   .m_axi_bready  (),
   .m_axi_araddr  (ocl_araddr),    // Still used
   .m_axi_arvalid (ocl_arvalid),
   .m_axi_arready (ocl_arready),
   .m_axi_rdata   (ocl_rdata),
   .m_axi_rresp   (ocl_rresp),
   .m_axi_rvalid  (ocl_rvalid),
   .m_axi_rready  (ocl_rready)
);

//=============================================================================
// AXI-Lite Read Channel FSM (simple: only one readable register)
//=============================================================================

logic axi_ar_handshake;
assign axi_ar_handshake = ocl_arvalid && ocl_arready;

always_ff @(posedge clk_main_a0 or negedge rst_main_n) begin
    if (!rst_main_n) begin
        ocl_rvalid  <= 1'b0;
        ocl_rdata   <= 32'h0;
        ocl_arready <= 1'b1;
    end else begin
        if (axi_ar_handshake) begin
            case (ocl_araddr[15:0])
                16'h0400: ocl_rdata <= counter_val;  // Deliver counter value at 0x400
                16'h0410: ocl_rdata <= add_val;
                default : ocl_rdata <= 32'hDEADBEEF;
            endcase
            ocl_rvalid  <= 1'b1;
            ocl_arready <= 1'b0;
        end

        if (ocl_rvalid && ocl_rready) begin
            ocl_rvalid  <= 1'b0;
            ocl_arready <= 1'b1;
        end
    end
end

assign ocl_rresp = 2'b00;  // Always OKAY

//=============================================================================
// AXI-Lite Write Channel: Reject all writes (SLVERR response)
//=============================================================================

logic write_response_pending;

always_ff @(posedge clk_main_a0 or negedge rst_main_n) begin
    if (!rst_main_n) begin
        ocl_awready <= 1'b0;
        ocl_wready  <= 1'b0;
        ocl_bvalid  <= 1'b0;
        ocl_bresp   <= 2'b00;
        write_response_pending <= 1'b0;
    end else begin
        // Accept address when not busy
        if (!write_response_pending && !ocl_bvalid) begin
            ocl_awready <= 1'b1;
        end else if (ocl_awvalid && ocl_awready) begin
            ocl_awready <= 1'b0;
            ocl_wready  <= 1'b1;
        end

        // Accept write data and generate response
        if (ocl_wvalid && ocl_wready) begin
            ocl_wready <= 1'b0;
            ocl_bvalid <= 1'b1;
            ocl_bresp  <= 2'b10; // SLVERR
            write_response_pending <= 1'b1;
        end

        // Complete write response handshake
        if (ocl_bvalid && ocl_bready) begin
            ocl_bvalid <= 1'b0;
            write_response_pending <= 1'b0;
        end
    end
end

//=============================================================================
// CL Output Ports (single driver for each signal)
//=============================================================================
/*always_comb begin
    // Read channel
    cl_ocl_arready = ocl_arready;
    cl_ocl_rvalid  = ocl_rvalid;
    cl_ocl_rdata   = ocl_rdata;
    cl_ocl_rresp   = ocl_rresp;
    // Write channel
    cl_ocl_awready = ocl_awready;
    cl_ocl_wready  = ocl_wready;
    cl_ocl_bvalid  = ocl_bvalid;
    cl_ocl_bresp   = ocl_bresp;
end*/

//=============================================================================
// PCIM
//=============================================================================

  // Cause Protocol Violations
  always_comb begin
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
  always_comb begin
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
  always_comb begin
    cl_sh_dma_pcis_bresp   = 'b0;
    cl_sh_dma_pcis_rresp   = 'b0;
    cl_sh_dma_pcis_rvalid  = 'b0;
  end

  // Remaining CL Output Ports
  always_comb begin
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
  always_comb begin
    cl_sda_bresp   = 'b0;
    cl_sda_rresp   = 'b0;
    cl_sda_rvalid  = 'b0;
  end

  // Remaining CL Output Ports
  always_comb begin
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

  always_comb begin
    cl_sh_ddr_stat_ack   = 'b0;
    cl_sh_ddr_stat_rdata = 'b0;
    cl_sh_ddr_stat_int   = 'b0;
  end

//=============================================================================
// USER-DEFIEND INTERRUPTS
//=============================================================================

  always_comb begin
    cl_sh_apppf_irq_req = 'b0;
  end

//=============================================================================
// VIRTUAL JTAG
//=============================================================================

  always_comb begin
    tdo = 'b0;
  end

//=============================================================================
// HBM MONITOR IO
//=============================================================================

  always_comb begin
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

  always_comb begin
    PCIE_EP_TXP    = 'b0;
    PCIE_EP_TXN    = 'b0;

    PCIE_RP_PERSTN = 'b0;
    PCIE_RP_TXP    = 'b0;
    PCIE_RP_TXN    = 'b0;
  end

endmodule // counter
