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
  sc_in<sc_logic> if_axi_rd_ar_vld;
  sc_out<sc_logic> if_axi_rd_ar_rdy;
  sc_in<sc_lv<50> > if_axi_rd_ar_dat;
  sc_out<sc_logic> if_axi_rd_r_vld;
  sc_in<sc_logic> if_axi_rd_r_rdy;
  sc_out<sc_lv<141> > if_axi_rd_r_dat;
  sc_in<sc_logic> if_axi_wr_aw_vld;
  sc_out<sc_logic> if_axi_wr_aw_rdy;
  sc_in<sc_lv<50> > if_axi_wr_aw_dat;
  sc_in<sc_logic> if_axi_wr_w_vld;
  sc_out<sc_logic> if_axi_wr_w_rdy;
  sc_in<sc_lv<145> > if_axi_wr_w_dat;
  sc_out<sc_logic> if_axi_wr_b_vld;
  sc_in<sc_logic> if_axi_wr_b_rdy;
  sc_out<sc_lv<12> > if_axi_wr_b_dat;
  sc_in<sc_logic> input_port_vld;
  sc_out<sc_logic> input_port_rdy;
  sc_in<sc_lv<138> > input_port_dat;
  sc_out<sc_logic> output_port_vld;
  sc_in<sc_logic> output_port_rdy;
  sc_out<sc_lv<138> > output_port_dat;
  sc_in<sc_logic> start_vld;
  sc_out<sc_logic> start_rdy;
  sc_in<sc_logic> start_dat;
  sc_out<sc_logic> done_vld;
  sc_in<sc_logic> done_rdy;
  sc_out<sc_logic> done_dat;
public:
  ccs_DUT_wrapper(const sc_module_name& nm, const char *hdl_name)
  :
    mc_foreign_module(nm, hdl_name), 
    clk("clk"), 
    rst("rst"), 
    if_axi_rd_ar_vld("if_axi_rd_ar_vld"), 
    if_axi_rd_ar_rdy("if_axi_rd_ar_rdy"), 
    if_axi_rd_ar_dat("if_axi_rd_ar_dat"), 
    if_axi_rd_r_vld("if_axi_rd_r_vld"), 
    if_axi_rd_r_rdy("if_axi_rd_r_rdy"), 
    if_axi_rd_r_dat("if_axi_rd_r_dat"), 
    if_axi_wr_aw_vld("if_axi_wr_aw_vld"), 
    if_axi_wr_aw_rdy("if_axi_wr_aw_rdy"), 
    if_axi_wr_aw_dat("if_axi_wr_aw_dat"), 
    if_axi_wr_w_vld("if_axi_wr_w_vld"), 
    if_axi_wr_w_rdy("if_axi_wr_w_rdy"), 
    if_axi_wr_w_dat("if_axi_wr_w_dat"), 
    if_axi_wr_b_vld("if_axi_wr_b_vld"), 
    if_axi_wr_b_rdy("if_axi_wr_b_rdy"), 
    if_axi_wr_b_dat("if_axi_wr_b_dat"), 
    input_port_vld("input_port_vld"), 
    input_port_rdy("input_port_rdy"), 
    input_port_dat("input_port_dat"), 
    output_port_vld("output_port_vld"), 
    output_port_rdy("output_port_rdy"), 
    output_port_dat("output_port_dat"), 
    start_vld("start_vld"), 
    start_rdy("start_rdy"), 
    start_dat("start_dat"), 
    done_vld("done_vld"), 
    done_rdy("done_rdy"), 
    done_dat("done_dat")
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


