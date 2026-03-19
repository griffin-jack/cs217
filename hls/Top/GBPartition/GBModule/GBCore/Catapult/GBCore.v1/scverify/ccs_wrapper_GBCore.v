// SCVerify DUT wrapper used for SystemC > HDL interface bindings


module ccs_wrapper (
  clk, rst, rva_in_large_vld, rva_in_large_rdy, rva_in_large_dat, rva_out_large_vld, rva_out_large_rdy, rva_out_large_dat,
      nmp_large_req_vld, nmp_large_req_rdy, nmp_large_req_dat, nmp_large_rsp_vld, nmp_large_rsp_rdy, nmp_large_rsp_dat,
      gbcontrol_large_req_vld, gbcontrol_large_req_rdy, gbcontrol_large_req_dat, gbcontrol_large_rsp_vld, gbcontrol_large_rsp_rdy,
      gbcontrol_large_rsp_dat, SC_SRAM_CONFIG
);
  input clk;
  input rst;
  input rva_in_large_vld;
  output rva_in_large_rdy;
  input [168:0] rva_in_large_dat;
  output rva_out_large_vld;
  input rva_out_large_rdy;
  output [127:0] rva_out_large_dat;
  input nmp_large_req_vld;
  output nmp_large_req_rdy;
  input [154:0] nmp_large_req_dat;
  output nmp_large_rsp_vld;
  input nmp_large_rsp_rdy;
  output [127:0] nmp_large_rsp_dat;
  input gbcontrol_large_req_vld;
  output gbcontrol_large_req_rdy;
  input [154:0] gbcontrol_large_req_dat;
  output gbcontrol_large_rsp_vld;
  input gbcontrol_large_rsp_rdy;
  output [127:0] gbcontrol_large_rsp_dat;
  input [31:0] SC_SRAM_CONFIG;


  GBCore dut_inst (
    .clk(clk),
    .rst(rst),
    .rva_in_large_vld(rva_in_large_vld),
    .rva_in_large_rdy(rva_in_large_rdy),
    .rva_in_large_dat(rva_in_large_dat),
    .rva_out_large_vld(rva_out_large_vld),
    .rva_out_large_rdy(rva_out_large_rdy),
    .rva_out_large_dat(rva_out_large_dat),
    .nmp_large_req_vld(nmp_large_req_vld),
    .nmp_large_req_rdy(nmp_large_req_rdy),
    .nmp_large_req_dat(nmp_large_req_dat),
    .nmp_large_rsp_vld(nmp_large_rsp_vld),
    .nmp_large_rsp_rdy(nmp_large_rsp_rdy),
    .nmp_large_rsp_dat(nmp_large_rsp_dat),
    .gbcontrol_large_req_vld(gbcontrol_large_req_vld),
    .gbcontrol_large_req_rdy(gbcontrol_large_req_rdy),
    .gbcontrol_large_req_dat(gbcontrol_large_req_dat),
    .gbcontrol_large_rsp_vld(gbcontrol_large_rsp_vld),
    .gbcontrol_large_rsp_rdy(gbcontrol_large_rsp_rdy),
    .gbcontrol_large_rsp_dat(gbcontrol_large_rsp_dat),
    .SC_SRAM_CONFIG(SC_SRAM_CONFIG)
  );

endmodule

