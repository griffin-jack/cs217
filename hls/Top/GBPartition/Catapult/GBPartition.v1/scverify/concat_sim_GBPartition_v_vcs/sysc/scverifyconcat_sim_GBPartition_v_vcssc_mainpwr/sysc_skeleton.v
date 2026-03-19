// Created during runtime of your simulation.


//  Verilog wrapper module for SystemC instance 'sc_main.tb.master'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$ManagerFromFile<spec::Axi::axiCfg,...> ;

  //  signal:  signal_0
  //  port:  if_rd__ar_vld
  //  port:  if_rd__ar_rdy
  //  port:  if_rd__ar_dat
  //  port:  if_rd__r_vld
  //  port:  if_rd__r_rdy
  //  port:  if_rd__r_dat
  //  port:  if_wr__aw_vld
  //  port:  if_wr__aw_rdy
  //  port:  if_wr__aw_dat
  //  port:  if_wr__w_vld
  //  port:  if_wr__w_rdy
  //  port:  if_wr__w_dat
  //  port:  if_wr__b_vld
  //  port:  if_wr__b_rdy
  //  port:  if_wr__b_dat
  //  port:  reset_bar
  //  port:  clk
  //  port:  port_0
  //  process:  run

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<spec::StreamType,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_1'
//  already present as module \sysc$Connections::Combinational<spec::StreamType,...> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_1'
//  already present as module \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_2'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<bool,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_2'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<bool,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_3'
//  already present as module \sysc$Connections::Combinational<bool,...> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_3'
//  already present as module \sysc$Connections::Combinational<bool,...>::DummyPortManager 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_4'
//  already present as module \sysc$Connections::Combinational<bool,...> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_4'
//  already present as module \sysc$Connections::Combinational<bool,...>::DummyPortManager 


//  Stop traversal at instance 'sc_main.tb.dut.ccs_rtl' with bf_type=BF_SC_DKI_MODULE_T

//  Verilog wrapper module for SystemC instance 'sc_main.tb.dut'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$CCS_RTL::sysc_sim_wrapper ;

  //  instance:  ccs_rtl (BF_SC_DKI_MODULE_T)
  // Instance type = Verilog
  reg \ccs_rtl_R_clk ;
  reg \ccs_rtl_R_rst ;
  reg \ccs_rtl_R_gb_done_rdy ;
  reg \ccs_rtl_R_if_axi_rd_ar_vld ;
  reg [49:0] \ccs_rtl_R_if_axi_rd_ar_dat ;
  reg \ccs_rtl_R_if_axi_rd_r_rdy ;
  reg \ccs_rtl_R_if_axi_wr_aw_vld ;
  reg [49:0] \ccs_rtl_R_if_axi_wr_aw_dat ;
  reg \ccs_rtl_R_if_axi_wr_w_vld ;
  reg [144:0] \ccs_rtl_R_if_axi_wr_w_dat ;
  reg \ccs_rtl_R_if_axi_wr_b_rdy ;
  reg \ccs_rtl_R_data_in_vld ;
  reg [137:0] \ccs_rtl_R_data_in_dat ;
  reg \ccs_rtl_R_data_out_rdy ;
  reg \ccs_rtl_R_pe_start_rdy ;
  reg \ccs_rtl_R_pe_done_vld ;
  reg \ccs_rtl_R_pe_done_dat ;

  ccs_wrapper  ccs_rtl (
     .clk(\ccs_rtl_R_clk ),
     .rst(\ccs_rtl_R_rst ),
     .gb_done_rdy(\ccs_rtl_R_gb_done_rdy ),
     .if_axi_rd_ar_vld(\ccs_rtl_R_if_axi_rd_ar_vld ),
     .if_axi_rd_ar_dat(\ccs_rtl_R_if_axi_rd_ar_dat ),
     .if_axi_rd_r_rdy(\ccs_rtl_R_if_axi_rd_r_rdy ),
     .if_axi_wr_aw_vld(\ccs_rtl_R_if_axi_wr_aw_vld ),
     .if_axi_wr_aw_dat(\ccs_rtl_R_if_axi_wr_aw_dat ),
     .if_axi_wr_w_vld(\ccs_rtl_R_if_axi_wr_w_vld ),
     .if_axi_wr_w_dat(\ccs_rtl_R_if_axi_wr_w_dat ),
     .if_axi_wr_b_rdy(\ccs_rtl_R_if_axi_wr_b_rdy ),
     .data_in_vld(\ccs_rtl_R_data_in_vld ),
     .data_in_dat(\ccs_rtl_R_data_in_dat ),
     .data_out_rdy(\ccs_rtl_R_data_out_rdy ),
     .pe_start_rdy(\ccs_rtl_R_pe_start_rdy ),
     .pe_done_vld(\ccs_rtl_R_pe_done_vld ),
     .pe_done_dat(\ccs_rtl_R_pe_done_dat )
  );


  //  signal:  ccs_rtl_SIG_clk
  //  signal:  ccs_rtl_SIG_rst
  //  signal:  ccs_rtl_SIG_gb_done_vld
  //  signal:  ccs_rtl_SIG_gb_done_rdy
  //  signal:  ccs_rtl_SIG_gb_done_dat
  //  signal:  ccs_rtl_SIG_if_axi_rd_ar_vld
  //  signal:  ccs_rtl_SIG_if_axi_rd_ar_rdy
  //  signal:  ccs_rtl_SIG_if_axi_rd_ar_dat
  //  signal:  ccs_rtl_SIG_if_axi_rd_r_vld
  //  signal:  ccs_rtl_SIG_if_axi_rd_r_rdy
  //  signal:  ccs_rtl_SIG_if_axi_rd_r_dat
  //  signal:  ccs_rtl_SIG_if_axi_wr_aw_vld
  //  signal:  ccs_rtl_SIG_if_axi_wr_aw_rdy
  //  signal:  ccs_rtl_SIG_if_axi_wr_aw_dat
  //  signal:  ccs_rtl_SIG_if_axi_wr_w_vld
  //  signal:  ccs_rtl_SIG_if_axi_wr_w_rdy
  //  signal:  ccs_rtl_SIG_if_axi_wr_w_dat
  //  signal:  ccs_rtl_SIG_if_axi_wr_b_vld
  //  signal:  ccs_rtl_SIG_if_axi_wr_b_rdy
  //  signal:  ccs_rtl_SIG_if_axi_wr_b_dat
  //  signal:  ccs_rtl_SIG_data_in_vld
  //  signal:  ccs_rtl_SIG_data_in_rdy
  //  signal:  ccs_rtl_SIG_data_in_dat
  //  signal:  ccs_rtl_SIG_data_out_vld
  //  signal:  ccs_rtl_SIG_data_out_rdy
  //  signal:  ccs_rtl_SIG_data_out_dat
  //  signal:  ccs_rtl_SIG_pe_start_vld
  //  signal:  ccs_rtl_SIG_pe_start_rdy
  //  signal:  ccs_rtl_SIG_pe_start_dat
  //  signal:  ccs_rtl_SIG_pe_done_vld
  //  signal:  ccs_rtl_SIG_pe_done_rdy
  //  signal:  ccs_rtl_SIG_pe_done_dat
  //  signal:  SIG_SC_LOGIC_0
  //  signal:  SIG_SC_LOGIC_1
  //  port:  clk
  //  port:  rst
  //  port:  gb_done_vld
  //  port:  gb_done_rdy
  //  port:  gb_done_dat
  //  port:  if_axi_rd__ar_vld
  //  port:  if_axi_rd__ar_rdy
  //  port:  if_axi_rd__ar_dat
  //  port:  if_axi_rd__r_vld
  //  port:  if_axi_rd__r_rdy
  //  port:  if_axi_rd__r_dat
  //  port:  if_axi_wr__aw_vld
  //  port:  if_axi_wr__aw_rdy
  //  port:  if_axi_wr__aw_dat
  //  port:  if_axi_wr__w_vld
  //  port:  if_axi_wr__w_rdy
  //  port:  if_axi_wr__w_dat
  //  port:  if_axi_wr__b_vld
  //  port:  if_axi_wr__b_rdy
  //  port:  if_axi_wr__b_dat
  //  port:  data_in_vld
  //  port:  data_in_rdy
  //  port:  data_in_dat
  //  port:  data_out_vld
  //  port:  data_out_rdy
  //  port:  data_out_dat
  //  port:  pe_start_vld
  //  port:  pe_start_rdy
  //  port:  pe_start_dat
  //  port:  pe_done_vld
  //  port:  pe_done_rdy
  //  port:  pe_done_dat
  //  process:  update_proc

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.source'
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
  //  process:  run

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dest'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sysc$Dest;

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
  //  process:  PopOutport
  //  process:  PopStart
  //  process:  PopDone
  //  process:  SimStop

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_read__ar_comb_BA'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_read__ar_dummyPortManager'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_read__r_comb_BA'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::ReadPayload,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_read__r_dummyPortManager'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::ReadPayload,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_write__aw_comb_BA'
//  already present as module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_write__aw_dummyPortManager'
//  already present as module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...>::DummyPortManager 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_write__w_comb_BA'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WritePayload,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_write__w_dummyPortManager'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WritePayload,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_write__b_comb_BA'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WRespPayload,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.axi_write__b_dummyPortManager'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WRespPayload,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_d2mport_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::AddrPayload> ;

  //  signal:  signal_0
  //  port:  port_0
  //  process:  do_direct2marshalled

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_d2mport_1'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::WritePayload> ;

  //  signal:  signal_0
  //  port:  port_0
  //  process:  do_direct2marshalled

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_m2dport_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::MarshalledToDirectOutPort<axi::axi4<spec::Axi::axiCfg>::WRespPayload> ;

  //  signal:  signal_0
  //  port:  port_0
  //  port:  port_1
  //  process:  do_marshalled2direct

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_d2mport_2'
//  already present as module \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::AddrPayload> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_m2dport_1'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::MarshalledToDirectOutPort<axi::axi4<spec::Axi::axiCfg>::ReadPayload> ;

  //  signal:  signal_0
  //  port:  port_0
  //  port:  port_1
  //  process:  do_marshalled2direct

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_d2mport_3'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::DirectToMarshalledInPort<spec::StreamType> ;

  //  signal:  signal_0
  //  port:  port_0
  //  process:  do_direct2marshalled

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_m2dport_2'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::MarshalledToDirectOutPort<spec::StreamType> ;

  //  signal:  signal_0
  //  port:  port_0
  //  port:  port_1
  //  process:  do_marshalled2direct

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_d2mport_4'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::DirectToMarshalledInPort<bool> ;

  //  signal:  signal_0
  //  port:  port_0
  //  process:  do_direct2marshalled

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_m2dport_3'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::MarshalledToDirectOutPort<bool> ;

  //  signal:  signal_0
  //  port:  port_0
  //  port:  port_1
  //  process:  do_marshalled2direct

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_m2dport_4'
//  already present as module \sysc$Connections::MarshalledToDirectOutPort<bool> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sysc$testbench;

  //  instance:  master (BF_MODULE_T)
  \sysc$ManagerFromFile<spec::Axi::axiCfg,...>  master();

  //  instance:  comb_ba_0 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::StreamType,...>  comb_ba_0();

  //  instance:  dummyPortManager_0 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager  dummyPortManager_0();

  //  instance:  comb_ba_1 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::StreamType,...>  comb_ba_1();

  //  instance:  dummyPortManager_1 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager  dummyPortManager_1();

  //  instance:  comb_ba_2 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>  comb_ba_2();

  //  instance:  dummyPortManager_2 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>::DummyPortManager  dummyPortManager_2();

  //  instance:  comb_ba_3 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>  comb_ba_3();

  //  instance:  dummyPortManager_3 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>::DummyPortManager  dummyPortManager_3();

  //  instance:  comb_ba_4 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>  comb_ba_4();

  //  instance:  dummyPortManager_4 (BF_MODULE_T)
  \sysc$Connections::Combinational<bool,...>::DummyPortManager  dummyPortManager_4();

  //  instance:  dut (BF_MODULE_T)
  \sysc$CCS_RTL::sysc_sim_wrapper  dut();

  //  instance:  source (BF_MODULE_T)
  sysc$Source source();

  //  instance:  dest (BF_MODULE_T)
  sysc$Dest dest();

  //  instance:  axi_read__ar_comb_BA (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...>  axi_read__ar_comb_BA();

  //  instance:  axi_read__ar_dummyPortManager (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...>::DummyPortManager  axi_read__ar_dummyPortManager();

  //  instance:  axi_read__r_comb_BA (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::ReadPayload,...>  axi_read__r_comb_BA();

  //  instance:  axi_read__r_dummyPortManager (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::ReadPayload,...>::DummyPortManager  axi_read__r_dummyPortManager();

  //  instance:  axi_write__aw_comb_BA (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...>  axi_write__aw_comb_BA();

  //  instance:  axi_write__aw_dummyPortManager (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...>::DummyPortManager  axi_write__aw_dummyPortManager();

  //  instance:  axi_write__w_comb_BA (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WritePayload,...>  axi_write__w_comb_BA();

  //  instance:  axi_write__w_dummyPortManager (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WritePayload,...>::DummyPortManager  axi_write__w_dummyPortManager();

  //  instance:  axi_write__b_comb_BA (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WRespPayload,...>  axi_write__b_comb_BA();

  //  instance:  axi_write__b_dummyPortManager (BF_MODULE_T)
  \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WRespPayload,...>::DummyPortManager  axi_write__b_dummyPortManager();

  //  instance:  dynamic_d2mport_0 (BF_MODULE_T)
  \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::AddrPayload>  dynamic_d2mport_0();

  //  instance:  dynamic_d2mport_1 (BF_MODULE_T)
  \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::WritePayload>  dynamic_d2mport_1();

  //  instance:  dynamic_m2dport_0 (BF_MODULE_T)
  \sysc$Connections::MarshalledToDirectOutPort<axi::axi4<spec::Axi::axiCfg>::WRespPayload>  dynamic_m2dport_0();

  //  instance:  dynamic_d2mport_2 (BF_MODULE_T)
  \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::AddrPayload>  dynamic_d2mport_2();

  //  instance:  dynamic_m2dport_1 (BF_MODULE_T)
  \sysc$Connections::MarshalledToDirectOutPort<axi::axi4<spec::Axi::axiCfg>::ReadPayload>  dynamic_m2dport_1();

  //  instance:  dynamic_d2mport_3 (BF_MODULE_T)
  \sysc$Connections::DirectToMarshalledInPort<spec::StreamType>  dynamic_d2mport_3();

  //  instance:  dynamic_m2dport_2 (BF_MODULE_T)
  \sysc$Connections::MarshalledToDirectOutPort<spec::StreamType>  dynamic_m2dport_2();

  //  instance:  dynamic_d2mport_4 (BF_MODULE_T)
  \sysc$Connections::DirectToMarshalledInPort<bool>  dynamic_d2mport_4();

  //  instance:  dynamic_m2dport_3 (BF_MODULE_T)
  \sysc$Connections::MarshalledToDirectOutPort<bool>  dynamic_m2dport_3();

  //  instance:  dynamic_m2dport_4 (BF_MODULE_T)
  \sysc$Connections::MarshalledToDirectOutPort<bool>  dynamic_m2dport_4();


  //  signal:  clk
  //  signal:  rst
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
  //  signal:  axi_read__ar_comb_in_vld
  //  signal:  axi_read__ar_comb_in_rdy
  //  signal:  axi_read__ar_comb_out_vld
  //  signal:  axi_read__ar_comb_out_rdy
  //  signal:  axi_read__ar_comb_in_dat
  //  signal:  axi_read__ar_comb_out_dat
  //  signal:  axi_read__r_comb_in_vld
  //  signal:  axi_read__r_comb_in_rdy
  //  signal:  axi_read__r_comb_out_vld
  //  signal:  axi_read__r_comb_out_rdy
  //  signal:  axi_read__r_comb_in_dat
  //  signal:  axi_read__r_comb_out_dat
  //  signal:  axi_write__aw_comb_in_vld
  //  signal:  axi_write__aw_comb_in_rdy
  //  signal:  axi_write__aw_comb_out_vld
  //  signal:  axi_write__aw_comb_out_rdy
  //  signal:  axi_write__aw_comb_in_dat
  //  signal:  axi_write__aw_comb_out_dat
  //  signal:  axi_write__w_comb_in_vld
  //  signal:  axi_write__w_comb_in_rdy
  //  signal:  axi_write__w_comb_out_vld
  //  signal:  axi_write__w_comb_out_rdy
  //  signal:  axi_write__w_comb_in_dat
  //  signal:  axi_write__w_comb_out_dat
  //  signal:  axi_write__b_comb_in_vld
  //  signal:  axi_write__b_comb_in_rdy
  //  signal:  axi_write__b_comb_out_vld
  //  signal:  axi_write__b_comb_out_rdy
  //  signal:  axi_write__b_comb_in_dat
  //  signal:  axi_write__b_comb_out_dat
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
  //  port:  axi_read__ar_sim_out_vld
  //  port:  axi_read__ar_sim_out_rdy
  //  port:  axi_read__ar_sim_out_dat
  //  port:  axi_read__ar_sim_in_vld
  //  port:  axi_read__ar_sim_in_rdy
  //  port:  axi_read__ar_sim_in_dat
  //  port:  axi_read__r_sim_out_vld
  //  port:  axi_read__r_sim_out_rdy
  //  port:  axi_read__r_sim_out_dat
  //  port:  axi_read__r_sim_in_vld
  //  port:  axi_read__r_sim_in_rdy
  //  port:  axi_read__r_sim_in_dat
  //  port:  axi_write__aw_sim_out_vld
  //  port:  axi_write__aw_sim_out_rdy
  //  port:  axi_write__aw_sim_out_dat
  //  port:  axi_write__aw_sim_in_vld
  //  port:  axi_write__aw_sim_in_rdy
  //  port:  axi_write__aw_sim_in_dat
  //  port:  axi_write__w_sim_out_vld
  //  port:  axi_write__w_sim_out_rdy
  //  port:  axi_write__w_sim_out_dat
  //  port:  axi_write__w_sim_in_vld
  //  port:  axi_write__w_sim_in_rdy
  //  port:  axi_write__w_sim_in_dat
  //  port:  axi_write__b_sim_out_vld
  //  port:  axi_write__b_sim_out_rdy
  //  port:  axi_write__b_sim_out_dat
  //  port:  axi_write__b_sim_in_vld
  //  port:  axi_write__b_sim_in_rdy
  //  port:  axi_write__b_sim_in_dat
  //  process:  method_p_0
  //  process:  method_p_1
  //  process:  method_p_2
  //  process:  method_p_3
  //  process:  method_p_4
  //  process:  method_p_5
  //  process:  method_p_6
  //  process:  method_p_7
  //  process:  method_p_8
  //  process:  method_p_9
  //  process:  run

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sc_main;

  //  instance:  tb (BF_MODULE_T)
  sysc$testbench tb();



endmodule


// VCS:  sysc_uni_top_module_name=sc_main
// use sc_main.tb.master \sysc$ManagerFromFile<spec::Axi::axiCfg,...> 
// use sc_main.tb.comb_ba_0 \sysc$Connections::Combinational<spec::StreamType,...> 
// use sc_main.tb.dummyPortManager_0 \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager 
// use sc_main.tb.comb_ba_1 \sysc$Connections::Combinational<spec::StreamType,...> 
// use sc_main.tb.dummyPortManager_1 \sysc$Connections::Combinational<spec::StreamType,...>::DummyPortManager 
// use sc_main.tb.comb_ba_2 \sysc$Connections::Combinational<bool,...> 
// use sc_main.tb.dummyPortManager_2 \sysc$Connections::Combinational<bool,...>::DummyPortManager 
// use sc_main.tb.comb_ba_3 \sysc$Connections::Combinational<bool,...> 
// use sc_main.tb.dummyPortManager_3 \sysc$Connections::Combinational<bool,...>::DummyPortManager 
// use sc_main.tb.comb_ba_4 \sysc$Connections::Combinational<bool,...> 
// use sc_main.tb.dummyPortManager_4 \sysc$Connections::Combinational<bool,...>::DummyPortManager 
// use sc_main.tb.dut \sysc$CCS_RTL::sysc_sim_wrapper 
// use sc_main.tb.source sysc$Source
// use sc_main.tb.dest sysc$Dest
// use sc_main.tb.axi_read__ar_comb_BA \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...> 
// use sc_main.tb.axi_read__ar_dummyPortManager \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...>::DummyPortManager 
// use sc_main.tb.axi_read__r_comb_BA \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::ReadPayload,...> 
// use sc_main.tb.axi_read__r_dummyPortManager \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::ReadPayload,...>::DummyPortManager 
// use sc_main.tb.axi_write__aw_comb_BA \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...> 
// use sc_main.tb.axi_write__aw_dummyPortManager \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::AddrPayload,...>::DummyPortManager 
// use sc_main.tb.axi_write__w_comb_BA \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WritePayload,...> 
// use sc_main.tb.axi_write__w_dummyPortManager \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WritePayload,...>::DummyPortManager 
// use sc_main.tb.axi_write__b_comb_BA \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WRespPayload,...> 
// use sc_main.tb.axi_write__b_dummyPortManager \sysc$Connections::Combinational<axi::axi4<spec::Axi::axiCfg>::WRespPayload,...>::DummyPortManager 
// use sc_main.tb.dynamic_d2mport_0 \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::AddrPayload> 
// use sc_main.tb.dynamic_d2mport_1 \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::WritePayload> 
// use sc_main.tb.dynamic_m2dport_0 \sysc$Connections::MarshalledToDirectOutPort<axi::axi4<spec::Axi::axiCfg>::WRespPayload> 
// use sc_main.tb.dynamic_d2mport_2 \sysc$Connections::DirectToMarshalledInPort<axi::axi4<spec::Axi::axiCfg>::AddrPayload> 
// use sc_main.tb.dynamic_m2dport_1 \sysc$Connections::MarshalledToDirectOutPort<axi::axi4<spec::Axi::axiCfg>::ReadPayload> 
// use sc_main.tb.dynamic_d2mport_3 \sysc$Connections::DirectToMarshalledInPort<spec::StreamType> 
// use sc_main.tb.dynamic_m2dport_2 \sysc$Connections::MarshalledToDirectOutPort<spec::StreamType> 
// use sc_main.tb.dynamic_d2mport_4 \sysc$Connections::DirectToMarshalledInPort<bool> 
// use sc_main.tb.dynamic_m2dport_3 \sysc$Connections::MarshalledToDirectOutPort<bool> 
// use sc_main.tb.dynamic_m2dport_4 \sysc$Connections::MarshalledToDirectOutPort<bool> 
// use sc_main.tb sysc$testbench
// use sc_main sc_main

