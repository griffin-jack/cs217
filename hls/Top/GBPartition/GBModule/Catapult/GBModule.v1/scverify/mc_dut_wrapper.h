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
  sc_in<sc_logic> data_in_vld;
  sc_out<sc_logic> data_in_rdy;
  sc_in<sc_lv<138> > data_in_dat;
  sc_out<sc_logic> data_out_vld;
  sc_in<sc_logic> data_out_rdy;
  sc_out<sc_lv<138> > data_out_dat;
  sc_out<sc_logic> pe_start_vld;
  sc_in<sc_logic> pe_start_rdy;
  sc_out<sc_logic> pe_start_dat;
  sc_in<sc_logic> pe_done_vld;
  sc_out<sc_logic> pe_done_rdy;
  sc_in<sc_logic> pe_done_dat;
  sc_out<sc_logic> gb_done_vld;
  sc_in<sc_logic> gb_done_rdy;
  sc_out<sc_logic> gb_done_dat;
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
    data_in_vld("data_in_vld"), 
    data_in_rdy("data_in_rdy"), 
    data_in_dat("data_in_dat"), 
    data_out_vld("data_out_vld"), 
    data_out_rdy("data_out_rdy"), 
    data_out_dat("data_out_dat"), 
    pe_start_vld("pe_start_vld"), 
    pe_start_rdy("pe_start_rdy"), 
    pe_start_dat("pe_start_dat"), 
    pe_done_vld("pe_done_vld"), 
    pe_done_rdy("pe_done_rdy"), 
    pe_done_dat("pe_done_dat"), 
    gb_done_vld("gb_done_vld"), 
    gb_done_rdy("gb_done_rdy"), 
    gb_done_dat("gb_done_dat")
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


