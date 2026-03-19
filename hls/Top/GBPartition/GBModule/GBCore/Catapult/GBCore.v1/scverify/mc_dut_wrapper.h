// mc_dut_wrapper.h
#ifndef INCLUDED_CCS_DUT_WRAPPER_H
#define INCLUDED_CCS_DUT_WRAPPER_H

#ifndef SC_USE_STD_STRING
#define SC_USE_STD_STRING
#endif

#include <systemc.h>
#include <mc_simulator_extensions.h>

#ifdef CCS_SYSC
namespace HDL {
#endif

// Create a foreign module wrapper around the HDL
#ifdef VCS_SYSTEMC
// VCS support - ccs_DUT_wrapper is derived from VCS-generated SystemC wrapper around HDL code
class ccs_DUT_wrapper : public ccs_wrapper
{
public:
  ccs_DUT_wrapper(const sc_module_name& nm, const char *hdl_name)
  : ccs_wrapper(nm)
  {}
  ~ccs_DUT_wrapper() {}
};

#else
// non VCS simulators - ccs_DUT_wrapper is derived from mc_foreign_module (adding 2nd ctor arg)
class ccs_DUT_wrapper: public mc_foreign_module
{
public:
  // Interface Ports
  sc_in<bool> clk;
  sc_in<sc_logic> rst;
  sc_in<sc_logic> rva_in_large_vld;
  sc_out<sc_logic> rva_in_large_rdy;
  sc_in<sc_lv<169> > rva_in_large_dat;
  sc_out<sc_logic> rva_out_large_vld;
  sc_in<sc_logic> rva_out_large_rdy;
  sc_out<sc_lv<128> > rva_out_large_dat;
  sc_in<sc_logic> nmp_large_req_vld;
  sc_out<sc_logic> nmp_large_req_rdy;
  sc_in<sc_lv<155> > nmp_large_req_dat;
  sc_out<sc_logic> nmp_large_rsp_vld;
  sc_in<sc_logic> nmp_large_rsp_rdy;
  sc_out<sc_lv<128> > nmp_large_rsp_dat;
  sc_in<sc_logic> gbcontrol_large_req_vld;
  sc_out<sc_logic> gbcontrol_large_req_rdy;
  sc_in<sc_lv<155> > gbcontrol_large_req_dat;
  sc_out<sc_logic> gbcontrol_large_rsp_vld;
  sc_in<sc_logic> gbcontrol_large_rsp_rdy;
  sc_out<sc_lv<128> > gbcontrol_large_rsp_dat;
  sc_in<sc_lv<32> > SC_SRAM_CONFIG;
public:
  ccs_DUT_wrapper(const sc_module_name& nm, const char *hdl_name)
  :
    mc_foreign_module(nm, hdl_name), 
    clk("clk"), 
    rst("rst"), 
    rva_in_large_vld("rva_in_large_vld"), 
    rva_in_large_rdy("rva_in_large_rdy"), 
    rva_in_large_dat("rva_in_large_dat"), 
    rva_out_large_vld("rva_out_large_vld"), 
    rva_out_large_rdy("rva_out_large_rdy"), 
    rva_out_large_dat("rva_out_large_dat"), 
    nmp_large_req_vld("nmp_large_req_vld"), 
    nmp_large_req_rdy("nmp_large_req_rdy"), 
    nmp_large_req_dat("nmp_large_req_dat"), 
    nmp_large_rsp_vld("nmp_large_rsp_vld"), 
    nmp_large_rsp_rdy("nmp_large_rsp_rdy"), 
    nmp_large_rsp_dat("nmp_large_rsp_dat"), 
    gbcontrol_large_req_vld("gbcontrol_large_req_vld"), 
    gbcontrol_large_req_rdy("gbcontrol_large_req_rdy"), 
    gbcontrol_large_req_dat("gbcontrol_large_req_dat"), 
    gbcontrol_large_rsp_vld("gbcontrol_large_rsp_vld"), 
    gbcontrol_large_rsp_rdy("gbcontrol_large_rsp_rdy"), 
    gbcontrol_large_rsp_dat("gbcontrol_large_rsp_dat"), 
    SC_SRAM_CONFIG("SC_SRAM_CONFIG")
  {
    elaborate_foreign_module(hdl_name);
  }

  ~ccs_DUT_wrapper() {}
};
#endif // VCS_SYSTEMC

#ifdef CCS_SYSC
} // namespace HDL
#endif
#endif // INCLUDED_CCS_DUT_WRAPPER_H


