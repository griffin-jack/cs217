// SystemC wrapper header for DKI connect HDL model import
// This file must be compiled with other SystemC files

#ifndef ccs_wrapper_h_
#define ccs_wrapper_h_

#include "systemc.h"
#include <string.h>
#include "cosim/bf/hdl_connect_v.h"
#include "cosim/bf/VcsDesign.h"
#include "cosim/bf/snps_hdl_param.h"

extern "C" unsigned int* Mccs_wrapper_1(unsigned int*, char*);
extern "C" std::string BF_get_hdl_name(SC_CORE sc_object *);


struct ccs_wrapper : sc_module {
	VcsModel    *vcsModel;
	VcsInstance *vcsInstance;

	//Input ports
	sc_in<bool>  clk;
	sc_in<sc_logic>  rst;
	sc_in<sc_logic>  if_axi_rd_ar_vld;
	sc_in<sc_lv<50> >  if_axi_rd_ar_dat;
	sc_in<sc_logic>  if_axi_rd_r_rdy;
	sc_in<sc_logic>  if_axi_wr_aw_vld;
	sc_in<sc_lv<50> >  if_axi_wr_aw_dat;
	sc_in<sc_logic>  if_axi_wr_w_vld;
	sc_in<sc_lv<145> >  if_axi_wr_w_dat;
	sc_in<sc_logic>  if_axi_wr_b_rdy;

	//Output ports
	sc_out<sc_logic>  interrupt;
	sc_out<sc_logic>  if_axi_rd_ar_rdy;
	sc_out<sc_logic>  if_axi_rd_r_vld;
	sc_out<sc_lv<141> >  if_axi_rd_r_dat;
	sc_out<sc_logic>  if_axi_wr_aw_rdy;
	sc_out<sc_logic>  if_axi_wr_w_rdy;
	sc_out<sc_logic>  if_axi_wr_b_vld;
	sc_out<sc_lv<12> >  if_axi_wr_b_dat;

	sc_signal<bool,SC_UNCHECKED_WRITERS> *sig_clk;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rst;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_rd_ar_vld;
	sc_signal<sc_lv<50>,SC_UNCHECKED_WRITERS > *sig_if_axi_rd_ar_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_rd_r_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_wr_aw_vld;
	sc_signal<sc_lv<50>,SC_UNCHECKED_WRITERS > *sig_if_axi_wr_aw_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_wr_w_vld;
	sc_signal<sc_lv<145>,SC_UNCHECKED_WRITERS > *sig_if_axi_wr_w_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_wr_b_rdy;

	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_interrupt;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_rd_ar_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_rd_r_vld;
	sc_signal<sc_lv<141>,SC_UNCHECKED_WRITERS > *sig_if_axi_rd_r_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_wr_aw_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_wr_w_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_if_axi_wr_b_vld;
	sc_signal<sc_lv<12>,SC_UNCHECKED_WRITERS > *sig_if_axi_wr_b_dat;

	// Parameters

	SC_HAS_PROCESS(ccs_wrapper);
	ccs_wrapper(sc_module_name modelName): sc_module(modelName)
	{
		sig_clk = new sc_signal<bool,SC_UNCHECKED_WRITERS>("sig_clk");
		sig_rst = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rst");
		sig_if_axi_rd_ar_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_rd_ar_vld");
		sig_if_axi_rd_ar_dat = new sc_signal<sc_lv<50>,SC_UNCHECKED_WRITERS >("sig_if_axi_rd_ar_dat");
		sig_if_axi_rd_r_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_rd_r_rdy");
		sig_if_axi_wr_aw_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_wr_aw_vld");
		sig_if_axi_wr_aw_dat = new sc_signal<sc_lv<50>,SC_UNCHECKED_WRITERS >("sig_if_axi_wr_aw_dat");
		sig_if_axi_wr_w_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_wr_w_vld");
		sig_if_axi_wr_w_dat = new sc_signal<sc_lv<145>,SC_UNCHECKED_WRITERS >("sig_if_axi_wr_w_dat");
		sig_if_axi_wr_b_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_wr_b_rdy");

		sig_interrupt = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_interrupt");
		sig_if_axi_rd_ar_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_rd_ar_rdy");
		sig_if_axi_rd_r_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_rd_r_vld");
		sig_if_axi_rd_r_dat = new sc_signal<sc_lv<141>,SC_UNCHECKED_WRITERS >("sig_if_axi_rd_r_dat");
		sig_if_axi_wr_aw_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_wr_aw_rdy");
		sig_if_axi_wr_w_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_wr_w_rdy");
		sig_if_axi_wr_b_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_if_axi_wr_b_vld");
		sig_if_axi_wr_b_dat = new sc_signal<sc_lv<12>,SC_UNCHECKED_WRITERS >("sig_if_axi_wr_b_dat");

		HDL_MODULE("ccs_wrapper", name(), basename());
		SC_METHOD(ccs_wrapper_clk_action); sensitive << clk; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rst_action); sensitive << rst; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_rd_ar_vld_action); sensitive << if_axi_rd_ar_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_rd_ar_dat_action); sensitive << if_axi_rd_ar_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_rd_r_rdy_action); sensitive << if_axi_rd_r_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_aw_vld_action); sensitive << if_axi_wr_aw_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_aw_dat_action); sensitive << if_axi_wr_aw_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_w_vld_action); sensitive << if_axi_wr_w_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_w_dat_action); sensitive << if_axi_wr_w_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_b_rdy_action); sensitive << if_axi_wr_b_rdy; snps_sysc_mark_last_create_process_as_internal();

		SC_METHOD(ccs_wrapper_interrupt_action); sensitive << *sig_interrupt; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_rd_ar_rdy_action); sensitive << *sig_if_axi_rd_ar_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_rd_r_vld_action); sensitive << *sig_if_axi_rd_r_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_rd_r_dat_action); sensitive << *sig_if_axi_rd_r_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_aw_rdy_action); sensitive << *sig_if_axi_wr_aw_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_w_rdy_action); sensitive << *sig_if_axi_wr_w_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_b_vld_action); sensitive << *sig_if_axi_wr_b_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_if_axi_wr_b_dat_action); sensitive << *sig_if_axi_wr_b_dat; snps_sysc_mark_last_create_process_as_internal();

		std::string clk_string = name();
		clk_string += "_R_clk";
		alterString(clk_string, basename());
		hdl_connect_v_int(*sig_clk, clk_string.c_str(), HDL_OUTPUT);

		std::string rst_string = name();
		rst_string += "_R_rst";
		alterString(rst_string, basename());
		hdl_connect_v_int(*sig_rst, rst_string.c_str(), HDL_OUTPUT);

		std::string if_axi_rd_ar_vld_string = name();
		if_axi_rd_ar_vld_string += "_R_if_axi_rd_ar_vld";
		alterString(if_axi_rd_ar_vld_string, basename());
		hdl_connect_v_int(*sig_if_axi_rd_ar_vld, if_axi_rd_ar_vld_string.c_str(), HDL_OUTPUT);

		std::string if_axi_rd_ar_dat_string = name();
		if_axi_rd_ar_dat_string += "_R_if_axi_rd_ar_dat";
		alterString(if_axi_rd_ar_dat_string, basename());
		hdl_connect_v_int(*sig_if_axi_rd_ar_dat, if_axi_rd_ar_dat_string.c_str(), HDL_OUTPUT);

		std::string if_axi_rd_r_rdy_string = name();
		if_axi_rd_r_rdy_string += "_R_if_axi_rd_r_rdy";
		alterString(if_axi_rd_r_rdy_string, basename());
		hdl_connect_v_int(*sig_if_axi_rd_r_rdy, if_axi_rd_r_rdy_string.c_str(), HDL_OUTPUT);

		std::string if_axi_wr_aw_vld_string = name();
		if_axi_wr_aw_vld_string += "_R_if_axi_wr_aw_vld";
		alterString(if_axi_wr_aw_vld_string, basename());
		hdl_connect_v_int(*sig_if_axi_wr_aw_vld, if_axi_wr_aw_vld_string.c_str(), HDL_OUTPUT);

		std::string if_axi_wr_aw_dat_string = name();
		if_axi_wr_aw_dat_string += "_R_if_axi_wr_aw_dat";
		alterString(if_axi_wr_aw_dat_string, basename());
		hdl_connect_v_int(*sig_if_axi_wr_aw_dat, if_axi_wr_aw_dat_string.c_str(), HDL_OUTPUT);

		std::string if_axi_wr_w_vld_string = name();
		if_axi_wr_w_vld_string += "_R_if_axi_wr_w_vld";
		alterString(if_axi_wr_w_vld_string, basename());
		hdl_connect_v_int(*sig_if_axi_wr_w_vld, if_axi_wr_w_vld_string.c_str(), HDL_OUTPUT);

		std::string if_axi_wr_w_dat_string = name();
		if_axi_wr_w_dat_string += "_R_if_axi_wr_w_dat";
		alterString(if_axi_wr_w_dat_string, basename());
		hdl_connect_v_int(*sig_if_axi_wr_w_dat, if_axi_wr_w_dat_string.c_str(), HDL_OUTPUT);

		std::string if_axi_wr_b_rdy_string = name();
		if_axi_wr_b_rdy_string += "_R_if_axi_wr_b_rdy";
		alterString(if_axi_wr_b_rdy_string, basename());
		hdl_connect_v_int(*sig_if_axi_wr_b_rdy, if_axi_wr_b_rdy_string.c_str(), HDL_OUTPUT);

		std::string interrupt_string = name();
		alterString(interrupt_string, basename());
		interrupt_string += ".interrupt";
		hdl_connect_v_int(*sig_interrupt, interrupt_string.c_str(), HDL_INPUT);

		std::string if_axi_rd_ar_rdy_string = name();
		alterString(if_axi_rd_ar_rdy_string, basename());
		if_axi_rd_ar_rdy_string += ".if_axi_rd_ar_rdy";
		hdl_connect_v_int(*sig_if_axi_rd_ar_rdy, if_axi_rd_ar_rdy_string.c_str(), HDL_INPUT);

		std::string if_axi_rd_r_vld_string = name();
		alterString(if_axi_rd_r_vld_string, basename());
		if_axi_rd_r_vld_string += ".if_axi_rd_r_vld";
		hdl_connect_v_int(*sig_if_axi_rd_r_vld, if_axi_rd_r_vld_string.c_str(), HDL_INPUT);

		std::string if_axi_rd_r_dat_string = name();
		alterString(if_axi_rd_r_dat_string, basename());
		if_axi_rd_r_dat_string += ".if_axi_rd_r_dat";
		hdl_connect_v_int(*sig_if_axi_rd_r_dat, if_axi_rd_r_dat_string.c_str(), HDL_INPUT);

		std::string if_axi_wr_aw_rdy_string = name();
		alterString(if_axi_wr_aw_rdy_string, basename());
		if_axi_wr_aw_rdy_string += ".if_axi_wr_aw_rdy";
		hdl_connect_v_int(*sig_if_axi_wr_aw_rdy, if_axi_wr_aw_rdy_string.c_str(), HDL_INPUT);

		std::string if_axi_wr_w_rdy_string = name();
		alterString(if_axi_wr_w_rdy_string, basename());
		if_axi_wr_w_rdy_string += ".if_axi_wr_w_rdy";
		hdl_connect_v_int(*sig_if_axi_wr_w_rdy, if_axi_wr_w_rdy_string.c_str(), HDL_INPUT);

		std::string if_axi_wr_b_vld_string = name();
		alterString(if_axi_wr_b_vld_string, basename());
		if_axi_wr_b_vld_string += ".if_axi_wr_b_vld";
		hdl_connect_v_int(*sig_if_axi_wr_b_vld, if_axi_wr_b_vld_string.c_str(), HDL_INPUT);

		std::string if_axi_wr_b_dat_string = name();
		alterString(if_axi_wr_b_dat_string, basename());
		if_axi_wr_b_dat_string += ".if_axi_wr_b_dat";
		hdl_connect_v_int(*sig_if_axi_wr_b_dat, if_axi_wr_b_dat_string.c_str(), HDL_INPUT);

		vcsModel = VcsDesign::getDesignInstance()->addModel("ccs_wrapper");
		vcsInstance = vcsModel->addInstance(name());
		vcsInstance->setScObj(this);
		vcsInstance->setNames("ccs_wrapper", name(), basename());
		vcsInstance->addPort("clk",  VcsPort::INPUT_PORT, 1, 0, "bool", VcsPort::BC_C);
		vcsInstance->addPort("rst",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_rd_ar_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_rd_ar_dat",  VcsPort::INPUT_PORT, 50, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_rd_r_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_aw_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_aw_dat",  VcsPort::INPUT_PORT, 50, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_w_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_w_dat",  VcsPort::INPUT_PORT, 145, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_b_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("interrupt",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_rd_ar_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_rd_r_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_rd_r_dat",  VcsPort::OUTPUT_PORT, 141, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_aw_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_w_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_b_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("if_axi_wr_b_dat",  VcsPort::OUTPUT_PORT, 12, 0, "sc_lv", VcsPort::BC_C);
	};

	void ccs_wrapper_clk_action()
	{ sig_clk->write(clk.read());
	}
	void ccs_wrapper_rst_action()
	{ sig_rst->write(rst.read());
	}
	void ccs_wrapper_if_axi_rd_ar_vld_action()
	{ sig_if_axi_rd_ar_vld->write(if_axi_rd_ar_vld.read());
	}
	void ccs_wrapper_if_axi_rd_ar_dat_action()
	{ sig_if_axi_rd_ar_dat->write(if_axi_rd_ar_dat.read());
	}
	void ccs_wrapper_if_axi_rd_r_rdy_action()
	{ sig_if_axi_rd_r_rdy->write(if_axi_rd_r_rdy.read());
	}
	void ccs_wrapper_if_axi_wr_aw_vld_action()
	{ sig_if_axi_wr_aw_vld->write(if_axi_wr_aw_vld.read());
	}
	void ccs_wrapper_if_axi_wr_aw_dat_action()
	{ sig_if_axi_wr_aw_dat->write(if_axi_wr_aw_dat.read());
	}
	void ccs_wrapper_if_axi_wr_w_vld_action()
	{ sig_if_axi_wr_w_vld->write(if_axi_wr_w_vld.read());
	}
	void ccs_wrapper_if_axi_wr_w_dat_action()
	{ sig_if_axi_wr_w_dat->write(if_axi_wr_w_dat.read());
	}
	void ccs_wrapper_if_axi_wr_b_rdy_action()
	{ sig_if_axi_wr_b_rdy->write(if_axi_wr_b_rdy.read());
	}

	void ccs_wrapper_interrupt_action()
	{ interrupt.write((*sig_interrupt).read());
	}
	void ccs_wrapper_if_axi_rd_ar_rdy_action()
	{ if_axi_rd_ar_rdy.write((*sig_if_axi_rd_ar_rdy).read());
	}
	void ccs_wrapper_if_axi_rd_r_vld_action()
	{ if_axi_rd_r_vld.write((*sig_if_axi_rd_r_vld).read());
	}
	void ccs_wrapper_if_axi_rd_r_dat_action()
	{ if_axi_rd_r_dat.write((*sig_if_axi_rd_r_dat).read());
	}
	void ccs_wrapper_if_axi_wr_aw_rdy_action()
	{ if_axi_wr_aw_rdy.write((*sig_if_axi_wr_aw_rdy).read());
	}
	void ccs_wrapper_if_axi_wr_w_rdy_action()
	{ if_axi_wr_w_rdy.write((*sig_if_axi_wr_w_rdy).read());
	}
	void ccs_wrapper_if_axi_wr_b_vld_action()
	{ if_axi_wr_b_vld.write((*sig_if_axi_wr_b_vld).read());
	}
	void ccs_wrapper_if_axi_wr_b_dat_action()
	{ if_axi_wr_b_dat.write((*sig_if_axi_wr_b_dat).read());
	}

	const char *kind() const { return "dki_module_verilog"; }
};


#endif
