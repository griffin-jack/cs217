// Created during runtime of your simulation.


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_1'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_1'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_2'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<spec::GB::Large::DataReq,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_2'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<spec::GB::Large::DataReq,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_3'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...> ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_3'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...>::DummyPortManager ;


endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_4'
//  already present as module \sysc$Connections::Combinational<spec::GB::Large::DataReq,...> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_4'
//  already present as module \sysc$Connections::Combinational<spec::GB::Large::DataReq,...>::DummyPortManager 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.comb_ba_5'
//  already present as module \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dummyPortManager_5'
//  already present as module \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...>::DummyPortManager 


//  Stop traversal at instance 'sc_main.tb.dut.ccs_rtl' with bf_type=BF_SC_DKI_MODULE_T

//  Verilog wrapper module for SystemC instance 'sc_main.tb.dut'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$CCS_RTL::sysc_sim_wrapper ;

  //  instance:  ccs_rtl (BF_SC_DKI_MODULE_T)
  // Instance type = Verilog
  reg \ccs_rtl_R_clk ;
  reg \ccs_rtl_R_rst ;
  reg \ccs_rtl_R_rva_in_large_vld ;
  reg [168:0] \ccs_rtl_R_rva_in_large_dat ;
  reg \ccs_rtl_R_rva_out_large_rdy ;
  reg \ccs_rtl_R_nmp_large_req_vld ;
  reg [154:0] \ccs_rtl_R_nmp_large_req_dat ;
  reg \ccs_rtl_R_nmp_large_rsp_rdy ;
  reg \ccs_rtl_R_gbcontrol_large_req_vld ;
  reg [154:0] \ccs_rtl_R_gbcontrol_large_req_dat ;
  reg \ccs_rtl_R_gbcontrol_large_rsp_rdy ;
  reg [31:0] \ccs_rtl_R_SC_SRAM_CONFIG ;

  ccs_wrapper  ccs_rtl (
     .clk(\ccs_rtl_R_clk ),
     .rst(\ccs_rtl_R_rst ),
     .rva_in_large_vld(\ccs_rtl_R_rva_in_large_vld ),
     .rva_in_large_dat(\ccs_rtl_R_rva_in_large_dat ),
     .rva_out_large_rdy(\ccs_rtl_R_rva_out_large_rdy ),
     .nmp_large_req_vld(\ccs_rtl_R_nmp_large_req_vld ),
     .nmp_large_req_dat(\ccs_rtl_R_nmp_large_req_dat ),
     .nmp_large_rsp_rdy(\ccs_rtl_R_nmp_large_rsp_rdy ),
     .gbcontrol_large_req_vld(\ccs_rtl_R_gbcontrol_large_req_vld ),
     .gbcontrol_large_req_dat(\ccs_rtl_R_gbcontrol_large_req_dat ),
     .gbcontrol_large_rsp_rdy(\ccs_rtl_R_gbcontrol_large_rsp_rdy ),
     .SC_SRAM_CONFIG(\ccs_rtl_R_SC_SRAM_CONFIG )
  );


  //  signal:  ccs_rtl_SIG_clk
  //  signal:  ccs_rtl_SIG_rst
  //  signal:  ccs_rtl_SIG_rva_in_large_vld
  //  signal:  ccs_rtl_SIG_rva_in_large_rdy
  //  signal:  ccs_rtl_SIG_rva_in_large_dat
  //  signal:  ccs_rtl_SIG_rva_out_large_vld
  //  signal:  ccs_rtl_SIG_rva_out_large_rdy
  //  signal:  ccs_rtl_SIG_rva_out_large_dat
  //  signal:  ccs_rtl_SIG_nmp_large_req_vld
  //  signal:  ccs_rtl_SIG_nmp_large_req_rdy
  //  signal:  ccs_rtl_SIG_nmp_large_req_dat
  //  signal:  ccs_rtl_SIG_nmp_large_rsp_vld
  //  signal:  ccs_rtl_SIG_nmp_large_rsp_rdy
  //  signal:  ccs_rtl_SIG_nmp_large_rsp_dat
  //  signal:  ccs_rtl_SIG_gbcontrol_large_req_vld
  //  signal:  ccs_rtl_SIG_gbcontrol_large_req_rdy
  //  signal:  ccs_rtl_SIG_gbcontrol_large_req_dat
  //  signal:  ccs_rtl_SIG_gbcontrol_large_rsp_vld
  //  signal:  ccs_rtl_SIG_gbcontrol_large_rsp_rdy
  //  signal:  ccs_rtl_SIG_gbcontrol_large_rsp_dat
  //  signal:  ccs_rtl_SIG_SC_SRAM_CONFIG
  //  signal:  SIG_SC_LOGIC_0
  //  signal:  SIG_SC_LOGIC_1
  //  port:  clk
  //  port:  rst
  //  port:  rva_in_large_vld
  //  port:  rva_in_large_rdy
  //  port:  rva_in_large_dat
  //  port:  rva_out_large_vld
  //  port:  rva_out_large_rdy
  //  port:  rva_out_large_dat
  //  port:  nmp_large_req_vld
  //  port:  nmp_large_req_rdy
  //  port:  nmp_large_req_dat
  //  port:  nmp_large_rsp_vld
  //  port:  nmp_large_rsp_rdy
  //  port:  nmp_large_rsp_dat
  //  port:  gbcontrol_large_req_vld
  //  port:  gbcontrol_large_req_rdy
  //  port:  gbcontrol_large_req_dat
  //  port:  gbcontrol_large_rsp_vld
  //  port:  gbcontrol_large_rsp_rdy
  //  port:  gbcontrol_large_rsp_dat
  //  port:  SC_SRAM_CONFIG
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
  //  port:  out_vld_2
  //  port:  out_rdy_2
  //  port:  out_dat_2
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
  //  process:  run

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_d2mport_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::DirectToMarshalledInPort<RVSink<spec::Axi::rvaCfg>::Write> ;

  //  signal:  signal_0
  //  port:  port_0
  //  process:  do_direct2marshalled

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_m2dport_0'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::MarshalledToDirectOutPort<RVSink<spec::Axi::rvaCfg>::Read> ;

  //  signal:  signal_0
  //  port:  port_0
  //  port:  port_1
  //  process:  do_marshalled2direct

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_d2mport_1'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::DirectToMarshalledInPort<spec::GB::Large::DataReq> ;

  //  signal:  signal_0
  //  port:  port_0
  //  process:  do_direct2marshalled

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_m2dport_1'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module \sysc$Connections::MarshalledToDirectOutPort<spec::GB::Large::DataRsp<1u>> ;

  //  signal:  signal_0
  //  port:  port_0
  //  port:  port_1
  //  process:  do_marshalled2direct

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_d2mport_2'
//  already present as module \sysc$Connections::DirectToMarshalledInPort<spec::GB::Large::DataReq> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb.dynamic_m2dport_2'
//  already present as module \sysc$Connections::MarshalledToDirectOutPort<spec::GB::Large::DataRsp<1u>> 


//  Verilog wrapper module for SystemC instance 'sc_main.tb'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sysc$testbench;

  //  instance:  comb_ba_0 (BF_MODULE_T)
  \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...>  comb_ba_0();

  //  instance:  dummyPortManager_0 (BF_MODULE_T)
  \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...>::DummyPortManager  dummyPortManager_0();

  //  instance:  comb_ba_1 (BF_MODULE_T)
  \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...>  comb_ba_1();

  //  instance:  dummyPortManager_1 (BF_MODULE_T)
  \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...>::DummyPortManager  dummyPortManager_1();

  //  instance:  comb_ba_2 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::GB::Large::DataReq,...>  comb_ba_2();

  //  instance:  dummyPortManager_2 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::GB::Large::DataReq,...>::DummyPortManager  dummyPortManager_2();

  //  instance:  comb_ba_3 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...>  comb_ba_3();

  //  instance:  dummyPortManager_3 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...>::DummyPortManager  dummyPortManager_3();

  //  instance:  comb_ba_4 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::GB::Large::DataReq,...>  comb_ba_4();

  //  instance:  dummyPortManager_4 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::GB::Large::DataReq,...>::DummyPortManager  dummyPortManager_4();

  //  instance:  comb_ba_5 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...>  comb_ba_5();

  //  instance:  dummyPortManager_5 (BF_MODULE_T)
  \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...>::DummyPortManager  dummyPortManager_5();

  //  instance:  dut (BF_MODULE_T)
  \sysc$CCS_RTL::sysc_sim_wrapper  dut();

  //  instance:  source (BF_MODULE_T)
  sysc$Source source();

  //  instance:  dest (BF_MODULE_T)
  sysc$Dest dest();

  //  instance:  dynamic_d2mport_0 (BF_MODULE_T)
  \sysc$Connections::DirectToMarshalledInPort<RVSink<spec::Axi::rvaCfg>::Write>  dynamic_d2mport_0();

  //  instance:  dynamic_m2dport_0 (BF_MODULE_T)
  \sysc$Connections::MarshalledToDirectOutPort<RVSink<spec::Axi::rvaCfg>::Read>  dynamic_m2dport_0();

  //  instance:  dynamic_d2mport_1 (BF_MODULE_T)
  \sysc$Connections::DirectToMarshalledInPort<spec::GB::Large::DataReq>  dynamic_d2mport_1();

  //  instance:  dynamic_m2dport_1 (BF_MODULE_T)
  \sysc$Connections::MarshalledToDirectOutPort<spec::GB::Large::DataRsp<1u>>  dynamic_m2dport_1();

  //  instance:  dynamic_d2mport_2 (BF_MODULE_T)
  \sysc$Connections::DirectToMarshalledInPort<spec::GB::Large::DataReq>  dynamic_d2mport_2();

  //  instance:  dynamic_m2dport_2 (BF_MODULE_T)
  \sysc$Connections::MarshalledToDirectOutPort<spec::GB::Large::DataRsp<1u>>  dynamic_m2dport_2();


  //  signal:  clk
  //  signal:  rst
  //  signal:  sc_sram_config
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
  //  process:  run

endmodule


//  Verilog wrapper module for SystemC instance 'sc_main'
`noinline
(*vcs_systemc_2,vcs_systemc_skel*) module sc_main;

  //  instance:  tb (BF_MODULE_T)
  sysc$testbench tb();



endmodule


// VCS:  sysc_uni_top_module_name=sc_main
// use sc_main.tb.comb_ba_0 \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...> 
// use sc_main.tb.dummyPortManager_0 \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Write,...>::DummyPortManager 
// use sc_main.tb.comb_ba_1 \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...> 
// use sc_main.tb.dummyPortManager_1 \sysc$Connections::Combinational<RVSink<spec::Axi::rvaCfg>::Read,...>::DummyPortManager 
// use sc_main.tb.comb_ba_2 \sysc$Connections::Combinational<spec::GB::Large::DataReq,...> 
// use sc_main.tb.dummyPortManager_2 \sysc$Connections::Combinational<spec::GB::Large::DataReq,...>::DummyPortManager 
// use sc_main.tb.comb_ba_3 \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...> 
// use sc_main.tb.dummyPortManager_3 \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...>::DummyPortManager 
// use sc_main.tb.comb_ba_4 \sysc$Connections::Combinational<spec::GB::Large::DataReq,...> 
// use sc_main.tb.dummyPortManager_4 \sysc$Connections::Combinational<spec::GB::Large::DataReq,...>::DummyPortManager 
// use sc_main.tb.comb_ba_5 \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...> 
// use sc_main.tb.dummyPortManager_5 \sysc$Connections::Combinational<spec::GB::Large::DataRsp<1u>,...>::DummyPortManager 
// use sc_main.tb.dut \sysc$CCS_RTL::sysc_sim_wrapper 
// use sc_main.tb.source sysc$Source
// use sc_main.tb.dest sysc$Dest
// use sc_main.tb.dynamic_d2mport_0 \sysc$Connections::DirectToMarshalledInPort<RVSink<spec::Axi::rvaCfg>::Write> 
// use sc_main.tb.dynamic_m2dport_0 \sysc$Connections::MarshalledToDirectOutPort<RVSink<spec::Axi::rvaCfg>::Read> 
// use sc_main.tb.dynamic_d2mport_1 \sysc$Connections::DirectToMarshalledInPort<spec::GB::Large::DataReq> 
// use sc_main.tb.dynamic_m2dport_1 \sysc$Connections::MarshalledToDirectOutPort<spec::GB::Large::DataRsp<1u>> 
// use sc_main.tb.dynamic_d2mport_2 \sysc$Connections::DirectToMarshalledInPort<spec::GB::Large::DataReq> 
// use sc_main.tb.dynamic_m2dport_2 \sysc$Connections::MarshalledToDirectOutPort<spec::GB::Large::DataRsp<1u>> 
// use sc_main.tb sysc$testbench
// use sc_main sc_main

