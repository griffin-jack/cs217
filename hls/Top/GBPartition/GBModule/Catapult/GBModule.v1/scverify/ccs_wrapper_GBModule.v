// SCVerify DUT wrapper used for SystemC > HDL interface bindings


module ccs_wrapper (
  clk, rst, rva_in_vld, rva_in_rdy, rva_in_dat, rva_out_vld, rva_out_rdy, rva_out_dat, data_in_vld, data_in_rdy,
      data_in_dat, data_out_vld, data_out_rdy, data_out_dat, pe_start_vld, pe_start_rdy, pe_start_dat, pe_done_vld,
      pe_done_rdy, pe_done_dat, gb_done_vld, gb_done_rdy, gb_done_dat
);
  input clk;
  input rst;
  input rva_in_vld;
  output rva_in_rdy;
  input [168:0] rva_in_dat;
  output rva_out_vld;
  input rva_out_rdy;
  output [127:0] rva_out_dat;
  input data_in_vld;
  output data_in_rdy;
  input [137:0] data_in_dat;
  output data_out_vld;
  input data_out_rdy;
  output [137:0] data_out_dat;
  output pe_start_vld;
  input pe_start_rdy;
  output pe_start_dat;
  input pe_done_vld;
  output pe_done_rdy;
  input pe_done_dat;
  output gb_done_vld;
  input gb_done_rdy;
  output gb_done_dat;


  GBModule dut_inst (
    .clk(clk),
    .rst(rst),
    .rva_in_vld(rva_in_vld),
    .rva_in_rdy(rva_in_rdy),
    .rva_in_dat(rva_in_dat),
    .rva_out_vld(rva_out_vld),
    .rva_out_rdy(rva_out_rdy),
    .rva_out_dat(rva_out_dat),
    .data_in_vld(data_in_vld),
    .data_in_rdy(data_in_rdy),
    .data_in_dat(data_in_dat),
    .data_out_vld(data_out_vld),
    .data_out_rdy(data_out_rdy),
    .data_out_dat(data_out_dat),
    .pe_start_vld(pe_start_vld),
    .pe_start_rdy(pe_start_rdy),
    .pe_start_dat(pe_start_dat),
    .pe_done_vld(pe_done_vld),
    .pe_done_rdy(pe_done_rdy),
    .pe_done_dat(pe_done_dat),
    .gb_done_vld(gb_done_vld),
    .gb_done_rdy(gb_done_rdy),
    .gb_done_dat(gb_done_dat)
  );

endmodule

