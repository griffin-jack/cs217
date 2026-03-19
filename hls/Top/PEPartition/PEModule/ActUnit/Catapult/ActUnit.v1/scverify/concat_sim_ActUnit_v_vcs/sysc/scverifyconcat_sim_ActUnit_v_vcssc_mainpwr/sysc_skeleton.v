// Created during runtime of your simulation.


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<bool,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<bool,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_1'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<nvhls::nv_scvector<ac_int<16,...>,...>,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_1'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<nvhls::nv_scvector<ac_int<16,...>,...>,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_2'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_2'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_3'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_3'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_4'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<spec::StreamType,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_4'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_5'
//  already present as module \sysc$Connections::Combinational<bool,...> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_5'
//  already present as module \sysc$Connections::Combinational<bool,...>::DummyPortManager 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dut'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sysc$ActUnit;

  //  port:  clk
  //  port:  rst
  //  port:  start_vld
  //  port:  start_rdy
  //  port:  start_dat
  //  port:  act_port_vld
  //  port:  act_port_rdy
  //  port:  act_port_dat
  //  port:  rva_in_vld
  //  port:  rva_in_rdy
  //  port:  rva_in_dat
  //  port:  rva_out_vld
  //  port:  rva_out_rdy
  //  port:  rva_out_dat
  //  port:  output_port_vld
  //  port:  output_port_rdy
  //  port:  output_port_dat
  //  port:  done_vld
  //  port:  done_rdy
  //  port:  done_dat
  //  process:  ActUnitRun

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.src'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sysc$Source;

  //  port:  port_0
  //  port:  port_1
  //  port:  out_vld_0
  //  port:  out_rdy_0
  //  port:  out_dat_0
  //  port:  out_vld_1
  //  port:  out_rdy_1
  //  port:  out_dat_1
  //  port:  out_vld_2
  //  port:  out_rdy_2
  //  port:  out_dat_2
  //  process:  run

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.snk'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sysc$Sink;

  //  port:  port_0
  //  port:  port_1
  //  port:  in_vld_0
  //  port:  in_rdy_0
  //  port:  in_dat_0
  //  port:  in_vld_1
  //  port:  in_rdy_1
  //  port:  in_dat_1
  //  port:  in_vld_2
  //  port:  in_rdy_2
  //  port:  in_dat_2
  //  process:  run

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sysc$Testbench;

  //  instance:  comb_ba_0 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>  comb_ba_0();

  //  instance:  dummyPortManager_0 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>::DummyPortManager  dummyPortManager_0();

  //  instance:  comb_ba_1 (BF_MODULE_T)
  \sysc$Connections::Combinational<nvhls::nv_scvector<ac_int<16,...>,...>,...>  comb_ba_1();

  //  instance:  dummyPortManager_1 (BF_MODULE_T)
  \sysc$Connections::Combinational<nvhls::nv_scvector<ac_int<16,...>,...>,...>::DummyPortManager  dummyPortManager_1();

  //  instance:  comb_ba_2 (BF_MODULE_T)
  \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...>  comb_ba_2();

  //  instance:  dummyPortManager_2 (BF_MODULE_T)
  \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...>::DummyPortManager  dummyPortManager_2();

  //  instance:  comb_ba_3 (BF_MODULE_T)
  \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...>  comb_ba_3();

  //  instance:  dummyPortManager_3 (BF_MODULE_T)
  \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...>::DummyPortManager  dummyPortManager_3();

  //  instance:  comb_ba_4 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::StreamType,...>  comb_ba_4();

  //  instance:  dummyPortManager_4 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager  dummyPortManager_4();

  //  instance:  comb_ba_5 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>  comb_ba_5();

  //  instance:  dummyPortManager_5 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>::DummyPortManager  dummyPortManager_5();

  //  instance:  dut (BF_MODULE_T)
  sysc$ActUnit dut();

  //  instance:  src (BF_MODULE_T)
  sysc$Source src();

  //  instance:  snk (BF_MODULE_T)
  sysc$Sink snk();


  //  signal:  clk
  //  signal:  signal_0
  //  signal:  comb_in_vld_0
  //  signal:  comb_in_rdy_0
  //  signal:  comb_out_vld_0
  //  signal:  comb_out_rdy_0
  //  signal:  comb_in_dat_0
  //  signal:  comb_out_dat_0
  //  signal:  comb_in_vld_1
  //  signal:  comb_in_rdy_1
  //  signal:  comb_out_vld_1
  //  signal:  comb_out_rdy_1
  //  signal:  comb_in_dat_1
  //  signal:  comb_out_dat_1
  //  signal:  comb_in_vld_2
  //  signal:  comb_in_rdy_2
  //  signal:  comb_out_vld_2
  //  signal:  comb_out_rdy_2
  //  signal:  comb_in_dat_2
  //  signal:  comb_out_dat_2
  //  signal:  comb_in_vld_3
  //  signal:  comb_in_rdy_3
  //  signal:  comb_out_vld_3
  //  signal:  comb_out_rdy_3
  //  signal:  comb_in_dat_3
  //  signal:  comb_out_dat_3
  //  signal:  comb_in_vld_4
  //  signal:  comb_in_rdy_4
  //  signal:  comb_out_vld_4
  //  signal:  comb_out_rdy_4
  //  signal:  comb_in_dat_4
  //  signal:  comb_out_dat_4
  //  signal:  comb_in_vld_5
  //  signal:  comb_in_rdy_5
  //  signal:  comb_out_vld_5
  //  signal:  comb_out_rdy_5
  //  signal:  comb_in_dat_5
  //  signal:  comb_out_dat_5
  //  port:  sim_out_0_vld
  //  port:  sim_out_0_rdy
  //  port:  sim_out_0_dat
  //  port:  sim_in_0_vld
  //  port:  sim_in_0_rdy
  //  port:  sim_in_0_dat
  //  port:  sim_out_1_vld
  //  port:  sim_out_1_rdy
  //  port:  sim_out_1_dat
  //  port:  sim_in_1_vld
  //  port:  sim_in_1_rdy
  //  port:  sim_in_1_dat
  //  port:  sim_out_2_vld
  //  port:  sim_out_2_rdy
  //  port:  sim_out_2_dat
  //  port:  sim_in_2_vld
  //  port:  sim_in_2_rdy
  //  port:  sim_in_2_dat
  //  port:  sim_out_3_vld
  //  port:  sim_out_3_rdy
  //  port:  sim_out_3_dat
  //  port:  sim_in_3_vld
  //  port:  sim_in_3_rdy
  //  port:  sim_in_3_dat
  //  port:  sim_out_4_vld
  //  port:  sim_out_4_rdy
  //  port:  sim_out_4_dat
  //  port:  sim_in_4_vld
  //  port:  sim_in_4_rdy
  //  port:  sim_in_4_dat
  //  port:  sim_out_5_vld
  //  port:  sim_out_5_rdy
  //  port:  sim_out_5_dat
  //  port:  sim_in_5_vld
  //  port:  sim_in_5_rdy
  //  port:  sim_in_5_dat
  //  process:  method_p_0
  //  process:  method_p_1
  //  process:  method_p_2
  //  process:  method_p_3
  //  process:  method_p_4
  //  process:  method_p_5
  //  process:  reset_driver

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sc_main;

  //  instance:  tb (BF_MODULE_T)
  sysc$Testbench tb();



endmodule


// VCS:  sysc_uni_top_module_name=sc_main
// use sc_main.tb.comb_ba_0 \sysc$Connections::Combinational<bool,...> 
// use sc_main.tb.dummyPortManager_0 \sysc$Connections::Combinational<bool,...>::DummyPortManager 
// use sc_main.tb.comb_ba_1 \sysc$Connections::Combinational<nvhls::nv_scvector<ac_int<16,...>,...>,...> 
// use sc_main.tb.dummyPortManager_1 \sysc$Connections::Combinational<nvhls::nv_scvector<ac_int<16,...>,...>,...>::DummyPortManager 
// use sc_main.tb.comb_ba_2 \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...> 
// use sc_main.tb.dummyPortManager_2 \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...>::DummyPortManager 
// use sc_main.tb.comb_ba_3 \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...> 
// use sc_main.tb.dummyPortManager_3 \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...>::DummyPortManager 
// use sc_main.tb.comb_ba_4 \sysc$Connections::Combinational<spec::StreamType,...> 
// use sc_main.tb.dummyPortManager_4 \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager 
// use sc_main.tb.comb_ba_5 \sysc$Connections::Combinational<bool,...> 
// use sc_main.tb.dummyPortManager_5 \sysc$Connections::Combinational<bool,...>::DummyPortManager 
// use sc_main.tb.dut sysc$ActUnit
// use sc_main.tb.src sysc$Source
// use sc_main.tb.snk sysc$Sink
// use sc_main.tb sysc$Testbench
// use sc_main sc_main

