// SCVerify DUT wrapper used for SystemC > HDL interface bindings


module ccs_wrapper (
  clk, rst, interrupt, if_axi_rd_ar_vld, if_axi_rd_ar_rdy, if_axi_rd_ar_dat, if_axi_rd_r_vld, if_axi_rd_r_rdy,
      if_axi_rd_r_dat, if_axi_wr_aw_vld, if_axi_wr_aw_rdy, if_axi_wr_aw_dat, if_axi_wr_w_vld, if_axi_wr_w_rdy,
      if_axi_wr_w_dat, if_axi_wr_b_vld, if_axi_wr_b_rdy, if_axi_wr_b_dat
);
  input clk;
  input rst;
  output interrupt;
  input if_axi_rd_ar_vld;
  output if_axi_rd_ar_rdy;
  input [49:0] if_axi_rd_ar_dat;
  output if_axi_rd_r_vld;
  input if_axi_rd_r_rdy;
  output [140:0] if_axi_rd_r_dat;
  input if_axi_wr_aw_vld;
  output if_axi_wr_aw_rdy;
  input [49:0] if_axi_wr_aw_dat;
  input if_axi_wr_w_vld;
  output if_axi_wr_w_rdy;
  input [144:0] if_axi_wr_w_dat;
  output if_axi_wr_b_vld;
  input if_axi_wr_b_rdy;
  output [11:0] if_axi_wr_b_dat;


  Top dut_inst (
    .clk(clk),
    .rst(rst),
    .interrupt(interrupt),
    .if_axi_rd_ar_vld(if_axi_rd_ar_vld),
    .if_axi_rd_ar_rdy(if_axi_rd_ar_rdy),
    .if_axi_rd_ar_dat(if_axi_rd_ar_dat),
    .if_axi_rd_r_vld(if_axi_rd_r_vld),
    .if_axi_rd_r_rdy(if_axi_rd_r_rdy),
    .if_axi_rd_r_dat(if_axi_rd_r_dat),
    .if_axi_wr_aw_vld(if_axi_wr_aw_vld),
    .if_axi_wr_aw_rdy(if_axi_wr_aw_rdy),
    .if_axi_wr_aw_dat(if_axi_wr_aw_dat),
    .if_axi_wr_w_vld(if_axi_wr_w_vld),
    .if_axi_wr_w_rdy(if_axi_wr_w_rdy),
    .if_axi_wr_w_dat(if_axi_wr_w_dat),
    .if_axi_wr_b_vld(if_axi_wr_b_vld),
    .if_axi_wr_b_rdy(if_axi_wr_b_rdy),
    .if_axi_wr_b_dat(if_axi_wr_b_dat)
  );

endmodule

