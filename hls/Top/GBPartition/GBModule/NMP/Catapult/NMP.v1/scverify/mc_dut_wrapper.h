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
  sc_in<sc_logic> rva_in_vld;
  sc_out<sc_logic> rva_in_rdy;
  sc_in<sc_lv<169> > rva_in_dat;
  sc_out<sc_logic> rva_out_vld;
  sc_in<sc_logic> rva_out_rdy;
  sc_out<sc_lv<128> > rva_out_dat;
  sc_in<sc_logic> start_vld;
  sc_out<sc_logic> start_rdy;
  sc_in<sc_logic> start_dat;
  sc_out<sc_logic> done_vld;
  sc_in<sc_logic> done_rdy;
  sc_out<sc_logic> done_dat;
  sc_out<sc_logic> large_req_vld;
  sc_in<sc_logic> large_req_rdy;
  sc_out<sc_lv<155> > large_req_dat;
  sc_in<sc_logic> large_rsp_vld;
  sc_out<sc_logic> large_rsp_rdy;
  sc_in<sc_lv<128> > large_rsp_dat;
public:
  ccs_DUT_wrapper(const sc_module_name& nm, const char *hdl_name)
  :
    mc_foreign_module(nm, hdl_name), 
    clk("clk"), 
    rst("rst"), 
    rva_in_vld("rva_in_vld"), 
    rva_in_rdy("rva_in_rdy"), 
    rva_in_dat("rva_in_dat"), 
    rva_out_vld("rva_out_vld"), 
    rva_out_rdy("rva_out_rdy"), 
    rva_out_dat("rva_out_dat"), 
    start_vld("start_vld"), 
    start_rdy("start_rdy"), 
    start_dat("start_dat"), 
    done_vld("done_vld"), 
    done_rdy("done_rdy"), 
    done_dat("done_dat"), 
    large_req_vld("large_req_vld"), 
    large_req_rdy("large_req_rdy"), 
    large_req_dat("large_req_dat"), 
    large_rsp_vld("large_rsp_vld"), 
    large_rsp_rdy("large_rsp_rdy"), 
    large_rsp_dat("large_rsp_dat")
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


