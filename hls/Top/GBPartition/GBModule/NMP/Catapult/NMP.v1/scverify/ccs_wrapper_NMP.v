// SCVerify DUT wrapper used for SystemC > HDL interface bindings


module ccs_wrapper (
  clk, rst, rva_in_vld, rva_in_rdy, rva_in_dat, rva_out_vld, rva_out_rdy, rva_out_dat, start_vld, start_rdy, start_dat,
      done_vld, done_rdy, done_dat, large_req_vld, large_req_rdy, large_req_dat, large_rsp_vld, large_rsp_rdy,
      large_rsp_dat
);
  input clk;
  input rst;
  input rva_in_vld;
  output rva_in_rdy;
  input [168:0] rva_in_dat;
  output rva_out_vld;
  input rva_out_rdy;
  output [127:0] rva_out_dat;
  input start_vld;
  output start_rdy;
  input start_dat;
  output done_vld;
  input done_rdy;
  output done_dat;
  output large_req_vld;
  input large_req_rdy;
  output [154:0] large_req_dat;
  input large_rsp_vld;
  output large_rsp_rdy;
  input [127:0] large_rsp_dat;


  NMP dut_inst (
    .clk(clk),
    .rst(rst),
    .rva_in_vld(rva_in_vld),
    .rva_in_rdy(rva_in_rdy),
    .rva_in_dat(rva_in_dat),
    .rva_out_vld(rva_out_vld),
    .rva_out_rdy(rva_out_rdy),
    .rva_out_dat(rva_out_dat),
    .start_vld(start_vld),
    .start_rdy(start_rdy),
    .start_dat(start_dat),
    .done_vld(done_vld),
    .done_rdy(done_rdy),
    .done_dat(done_dat),
    .large_req_vld(large_req_vld),
    .large_req_rdy(large_req_rdy),
    .large_req_dat(large_req_dat),
    .large_rsp_vld(large_rsp_vld),
    .large_rsp_rdy(large_rsp_rdy),
    .large_rsp_dat(large_rsp_dat)
  );

endmodule

