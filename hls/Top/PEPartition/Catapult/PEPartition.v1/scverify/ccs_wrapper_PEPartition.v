// SCVerify DUT wrapper used for SystemC > HDL interface bindings


module ccs_wrapper (
  clk, rst, if_axi_rd_ar_vld, if_axi_rd_ar_rdy, if_axi_rd_ar_dat, if_axi_rd_r_vld, if_axi_rd_r_rdy, if_axi_rd_r_dat,
      if_axi_wr_aw_vld, if_axi_wr_aw_rdy, if_axi_wr_aw_dat, if_axi_wr_w_vld, if_axi_wr_w_rdy, if_axi_wr_w_dat,
      if_axi_wr_b_vld, if_axi_wr_b_rdy, if_axi_wr_b_dat, input_port_vld, input_port_rdy, input_port_dat, output_port_vld,
      output_port_rdy, output_port_dat, start_vld, start_rdy, start_dat, done_vld, done_rdy, done_dat
);
  input clk;
  input rst;
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
  input input_port_vld;
  output input_port_rdy;
  input [137:0] input_port_dat;
  output output_port_vld;
  input output_port_rdy;
  output [137:0] output_port_dat;
  input start_vld;
  output start_rdy;
  input start_dat;
  output done_vld;
  input done_rdy;
  output done_dat;


  PEPartition dut_inst (
    .clk(clk),
    .rst(rst),
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
    .if_axi_wr_b_dat(if_axi_wr_b_dat),
    .input_port_vld(input_port_vld),
    .input_port_rdy(input_port_rdy),
    .input_port_dat(input_port_dat),
    .output_port_vld(output_port_vld),
    .output_port_rdy(output_port_rdy),
    .output_port_dat(output_port_dat),
    .start_vld(start_vld),
    .start_rdy(start_rdy),
    .start_dat(start_dat),
    .done_vld(done_vld),
    .done_rdy(done_rdy),
    .done_dat(done_dat)
  );

endmodule

