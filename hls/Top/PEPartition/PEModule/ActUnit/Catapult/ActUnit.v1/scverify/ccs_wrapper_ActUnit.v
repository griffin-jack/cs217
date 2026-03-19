// SCVerify DUT wrapper used for SystemC > HDL interface bindings


module ccs_wrapper (
  clk, rst, start_vld, start_rdy, start_dat, act_port_vld, act_port_rdy, act_port_dat, rva_in_vld, rva_in_rdy,
      rva_in_dat, rva_out_vld, rva_out_rdy, rva_out_dat, output_port_vld, output_port_rdy, output_port_dat, done_vld,
      done_rdy, done_dat
);
  input clk;
  input rst;
  input start_vld;
  output start_rdy;
  input start_dat;
  input act_port_vld;
  output act_port_rdy;
  input [255:0] act_port_dat;
  input rva_in_vld;
  output rva_in_rdy;
  input [168:0] rva_in_dat;
  output rva_out_vld;
  input rva_out_rdy;
  output [127:0] rva_out_dat;
  output output_port_vld;
  input output_port_rdy;
  output [137:0] output_port_dat;
  output done_vld;
  input done_rdy;
  output done_dat;


  ActUnit dut_inst (
    .clk(clk),
    .rst(rst),
    .start_vld(start_vld),
    .start_rdy(start_rdy),
    .start_dat(start_dat),
    .act_port_vld(act_port_vld),
    .act_port_rdy(act_port_rdy),
    .act_port_dat(act_port_dat),
    .rva_in_vld(rva_in_vld),
    .rva_in_rdy(rva_in_rdy),
    .rva_in_dat(rva_in_dat),
    .rva_out_vld(rva_out_vld),
    .rva_out_rdy(rva_out_rdy),
    .rva_out_dat(rva_out_dat),
    .output_port_vld(output_port_vld),
    .output_port_rdy(output_port_rdy),
    .output_port_dat(output_port_dat),
    .done_vld(done_vld),
    .done_rdy(done_rdy),
    .done_dat(done_dat)
  );

endmodule

