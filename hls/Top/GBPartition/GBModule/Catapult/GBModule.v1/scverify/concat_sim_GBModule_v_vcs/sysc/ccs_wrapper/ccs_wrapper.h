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
	sc_in<sc_logic>  rva_in_vld;
	sc_in<sc_lv<169> >  rva_in_dat;
	sc_in<sc_logic>  rva_out_rdy;
	sc_in<sc_logic>  data_in_vld;
	sc_in<sc_lv<138> >  data_in_dat;
	sc_in<sc_logic>  data_out_rdy;
	sc_in<sc_logic>  pe_start_rdy;
	sc_in<sc_logic>  pe_done_vld;
	sc_in<sc_logic>  pe_done_dat;
	sc_in<sc_logic>  gb_done_rdy;

	//Output ports
	sc_out<sc_logic>  rva_in_rdy;
	sc_out<sc_logic>  rva_out_vld;
	sc_out<sc_lv<128> >  rva_out_dat;
	sc_out<sc_logic>  data_in_rdy;
	sc_out<sc_logic>  data_out_vld;
	sc_out<sc_lv<138> >  data_out_dat;
	sc_out<sc_logic>  pe_start_vld;
	sc_out<sc_logic>  pe_start_dat;
	sc_out<sc_logic>  pe_done_rdy;
	sc_out<sc_logic>  gb_done_vld;
	sc_out<sc_logic>  gb_done_dat;

	sc_signal<bool,SC_UNCHECKED_WRITERS> *sig_clk;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rst;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_in_vld;
	sc_signal<sc_lv<169>,SC_UNCHECKED_WRITERS > *sig_rva_in_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_out_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_data_in_vld;
	sc_signal<sc_lv<138>,SC_UNCHECKED_WRITERS > *sig_data_in_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_data_out_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_pe_start_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_pe_done_vld;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_pe_done_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_gb_done_rdy;

	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_in_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_out_vld;
	sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS > *sig_rva_out_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_data_in_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_data_out_vld;
	sc_signal<sc_lv<138>,SC_UNCHECKED_WRITERS > *sig_data_out_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_pe_start_vld;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_pe_start_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_pe_done_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_gb_done_vld;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_gb_done_dat;

	// Parameters

	SC_HAS_PROCESS(ccs_wrapper);
	ccs_wrapper(sc_module_name modelName): sc_module(modelName)
	{
		sig_clk = new sc_signal<bool,SC_UNCHECKED_WRITERS>("sig_clk");
		sig_rst = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rst");
		sig_rva_in_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_in_vld");
		sig_rva_in_dat = new sc_signal<sc_lv<169>,SC_UNCHECKED_WRITERS >("sig_rva_in_dat");
		sig_rva_out_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_out_rdy");
		sig_data_in_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_data_in_vld");
		sig_data_in_dat = new sc_signal<sc_lv<138>,SC_UNCHECKED_WRITERS >("sig_data_in_dat");
		sig_data_out_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_data_out_rdy");
		sig_pe_start_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_pe_start_rdy");
		sig_pe_done_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_pe_done_vld");
		sig_pe_done_dat = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_pe_done_dat");
		sig_gb_done_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_gb_done_rdy");

		sig_rva_in_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_in_rdy");
		sig_rva_out_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_out_vld");
		sig_rva_out_dat = new sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS >("sig_rva_out_dat");
		sig_data_in_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_data_in_rdy");
		sig_data_out_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_data_out_vld");
		sig_data_out_dat = new sc_signal<sc_lv<138>,SC_UNCHECKED_WRITERS >("sig_data_out_dat");
		sig_pe_start_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_pe_start_vld");
		sig_pe_start_dat = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_pe_start_dat");
		sig_pe_done_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_pe_done_rdy");
		sig_gb_done_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_gb_done_vld");
		sig_gb_done_dat = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_gb_done_dat");

		HDL_MODULE("ccs_wrapper", name(), basename());
		SC_METHOD(ccs_wrapper_clk_action); sensitive << clk; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rst_action); sensitive << rst; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_in_vld_action); sensitive << rva_in_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_in_dat_action); sensitive << rva_in_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_rdy_action); sensitive << rva_out_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_data_in_vld_action); sensitive << data_in_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_data_in_dat_action); sensitive << data_in_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_data_out_rdy_action); sensitive << data_out_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_pe_start_rdy_action); sensitive << pe_start_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_pe_done_vld_action); sensitive << pe_done_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_pe_done_dat_action); sensitive << pe_done_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gb_done_rdy_action); sensitive << gb_done_rdy; snps_sysc_mark_last_create_process_as_internal();

		SC_METHOD(ccs_wrapper_rva_in_rdy_action); sensitive << *sig_rva_in_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_vld_action); sensitive << *sig_rva_out_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_dat_action); sensitive << *sig_rva_out_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_data_in_rdy_action); sensitive << *sig_data_in_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_data_out_vld_action); sensitive << *sig_data_out_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_data_out_dat_action); sensitive << *sig_data_out_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_pe_start_vld_action); sensitive << *sig_pe_start_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_pe_start_dat_action); sensitive << *sig_pe_start_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_pe_done_rdy_action); sensitive << *sig_pe_done_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gb_done_vld_action); sensitive << *sig_gb_done_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gb_done_dat_action); sensitive << *sig_gb_done_dat; snps_sysc_mark_last_create_process_as_internal();

		std::string clk_string = name();
		clk_string += "_R_clk";
		alterString(clk_string, basename());
		hdl_connect_v_int(*sig_clk, clk_string.c_str(), HDL_OUTPUT);

		std::string rst_string = name();
		rst_string += "_R_rst";
		alterString(rst_string, basename());
		hdl_connect_v_int(*sig_rst, rst_string.c_str(), HDL_OUTPUT);

		std::string rva_in_vld_string = name();
		rva_in_vld_string += "_R_rva_in_vld";
		alterString(rva_in_vld_string, basename());
		hdl_connect_v_int(*sig_rva_in_vld, rva_in_vld_string.c_str(), HDL_OUTPUT);

		std::string rva_in_dat_string = name();
		rva_in_dat_string += "_R_rva_in_dat";
		alterString(rva_in_dat_string, basename());
		hdl_connect_v_int(*sig_rva_in_dat, rva_in_dat_string.c_str(), HDL_OUTPUT);

		std::string rva_out_rdy_string = name();
		rva_out_rdy_string += "_R_rva_out_rdy";
		alterString(rva_out_rdy_string, basename());
		hdl_connect_v_int(*sig_rva_out_rdy, rva_out_rdy_string.c_str(), HDL_OUTPUT);

		std::string data_in_vld_string = name();
		data_in_vld_string += "_R_data_in_vld";
		alterString(data_in_vld_string, basename());
		hdl_connect_v_int(*sig_data_in_vld, data_in_vld_string.c_str(), HDL_OUTPUT);

		std::string data_in_dat_string = name();
		data_in_dat_string += "_R_data_in_dat";
		alterString(data_in_dat_string, basename());
		hdl_connect_v_int(*sig_data_in_dat, data_in_dat_string.c_str(), HDL_OUTPUT);

		std::string data_out_rdy_string = name();
		data_out_rdy_string += "_R_data_out_rdy";
		alterString(data_out_rdy_string, basename());
		hdl_connect_v_int(*sig_data_out_rdy, data_out_rdy_string.c_str(), HDL_OUTPUT);

		std::string pe_start_rdy_string = name();
		pe_start_rdy_string += "_R_pe_start_rdy";
		alterString(pe_start_rdy_string, basename());
		hdl_connect_v_int(*sig_pe_start_rdy, pe_start_rdy_string.c_str(), HDL_OUTPUT);

		std::string pe_done_vld_string = name();
		pe_done_vld_string += "_R_pe_done_vld";
		alterString(pe_done_vld_string, basename());
		hdl_connect_v_int(*sig_pe_done_vld, pe_done_vld_string.c_str(), HDL_OUTPUT);

		std::string pe_done_dat_string = name();
		pe_done_dat_string += "_R_pe_done_dat";
		alterString(pe_done_dat_string, basename());
		hdl_connect_v_int(*sig_pe_done_dat, pe_done_dat_string.c_str(), HDL_OUTPUT);

		std::string gb_done_rdy_string = name();
		gb_done_rdy_string += "_R_gb_done_rdy";
		alterString(gb_done_rdy_string, basename());
		hdl_connect_v_int(*sig_gb_done_rdy, gb_done_rdy_string.c_str(), HDL_OUTPUT);

		std::string rva_in_rdy_string = name();
		alterString(rva_in_rdy_string, basename());
		rva_in_rdy_string += ".rva_in_rdy";
		hdl_connect_v_int(*sig_rva_in_rdy, rva_in_rdy_string.c_str(), HDL_INPUT);

		std::string rva_out_vld_string = name();
		alterString(rva_out_vld_string, basename());
		rva_out_vld_string += ".rva_out_vld";
		hdl_connect_v_int(*sig_rva_out_vld, rva_out_vld_string.c_str(), HDL_INPUT);

		std::string rva_out_dat_string = name();
		alterString(rva_out_dat_string, basename());
		rva_out_dat_string += ".rva_out_dat";
		hdl_connect_v_int(*sig_rva_out_dat, rva_out_dat_string.c_str(), HDL_INPUT);

		std::string data_in_rdy_string = name();
		alterString(data_in_rdy_string, basename());
		data_in_rdy_string += ".data_in_rdy";
		hdl_connect_v_int(*sig_data_in_rdy, data_in_rdy_string.c_str(), HDL_INPUT);

		std::string data_out_vld_string = name();
		alterString(data_out_vld_string, basename());
		data_out_vld_string += ".data_out_vld";
		hdl_connect_v_int(*sig_data_out_vld, data_out_vld_string.c_str(), HDL_INPUT);

		std::string data_out_dat_string = name();
		alterString(data_out_dat_string, basename());
		data_out_dat_string += ".data_out_dat";
		hdl_connect_v_int(*sig_data_out_dat, data_out_dat_string.c_str(), HDL_INPUT);

		std::string pe_start_vld_string = name();
		alterString(pe_start_vld_string, basename());
		pe_start_vld_string += ".pe_start_vld";
		hdl_connect_v_int(*sig_pe_start_vld, pe_start_vld_string.c_str(), HDL_INPUT);

		std::string pe_start_dat_string = name();
		alterString(pe_start_dat_string, basename());
		pe_start_dat_string += ".pe_start_dat";
		hdl_connect_v_int(*sig_pe_start_dat, pe_start_dat_string.c_str(), HDL_INPUT);

		std::string pe_done_rdy_string = name();
		alterString(pe_done_rdy_string, basename());
		pe_done_rdy_string += ".pe_done_rdy";
		hdl_connect_v_int(*sig_pe_done_rdy, pe_done_rdy_string.c_str(), HDL_INPUT);

		std::string gb_done_vld_string = name();
		alterString(gb_done_vld_string, basename());
		gb_done_vld_string += ".gb_done_vld";
		hdl_connect_v_int(*sig_gb_done_vld, gb_done_vld_string.c_str(), HDL_INPUT);

		std::string gb_done_dat_string = name();
		alterString(gb_done_dat_string, basename());
		gb_done_dat_string += ".gb_done_dat";
		hdl_connect_v_int(*sig_gb_done_dat, gb_done_dat_string.c_str(), HDL_INPUT);

		vcsModel = VcsDesign::getDesignInstance()->addModel("ccs_wrapper");
		vcsInstance = vcsModel->addInstance(name());
		vcsInstance->setScObj(this);
		vcsInstance->setNames("ccs_wrapper", name(), basename());
		vcsInstance->addPort("clk",  VcsPort::INPUT_PORT, 1, 0, "bool", VcsPort::BC_C);
		vcsInstance->addPort("rst",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_dat",  VcsPort::INPUT_PORT, 169, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("data_in_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("data_in_dat",  VcsPort::INPUT_PORT, 138, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("data_out_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("pe_start_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("pe_done_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("pe_done_dat",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("gb_done_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_dat",  VcsPort::OUTPUT_PORT, 128, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("data_in_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("data_out_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("data_out_dat",  VcsPort::OUTPUT_PORT, 138, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("pe_start_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("pe_start_dat",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("pe_done_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("gb_done_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("gb_done_dat",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
	};

	void ccs_wrapper_clk_action()
	{ sig_clk->write(clk.read());
	}
	void ccs_wrapper_rst_action()
	{ sig_rst->write(rst.read());
	}
	void ccs_wrapper_rva_in_vld_action()
	{ sig_rva_in_vld->write(rva_in_vld.read());
	}
	void ccs_wrapper_rva_in_dat_action()
	{ sig_rva_in_dat->write(rva_in_dat.read());
	}
	void ccs_wrapper_rva_out_rdy_action()
	{ sig_rva_out_rdy->write(rva_out_rdy.read());
	}
	void ccs_wrapper_data_in_vld_action()
	{ sig_data_in_vld->write(data_in_vld.read());
	}
	void ccs_wrapper_data_in_dat_action()
	{ sig_data_in_dat->write(data_in_dat.read());
	}
	void ccs_wrapper_data_out_rdy_action()
	{ sig_data_out_rdy->write(data_out_rdy.read());
	}
	void ccs_wrapper_pe_start_rdy_action()
	{ sig_pe_start_rdy->write(pe_start_rdy.read());
	}
	void ccs_wrapper_pe_done_vld_action()
	{ sig_pe_done_vld->write(pe_done_vld.read());
	}
	void ccs_wrapper_pe_done_dat_action()
	{ sig_pe_done_dat->write(pe_done_dat.read());
	}
	void ccs_wrapper_gb_done_rdy_action()
	{ sig_gb_done_rdy->write(gb_done_rdy.read());
	}

	void ccs_wrapper_rva_in_rdy_action()
	{ rva_in_rdy.write((*sig_rva_in_rdy).read());
	}
	void ccs_wrapper_rva_out_vld_action()
	{ rva_out_vld.write((*sig_rva_out_vld).read());
	}
	void ccs_wrapper_rva_out_dat_action()
	{ rva_out_dat.write((*sig_rva_out_dat).read());
	}
	void ccs_wrapper_data_in_rdy_action()
	{ data_in_rdy.write((*sig_data_in_rdy).read());
	}
	void ccs_wrapper_data_out_vld_action()
	{ data_out_vld.write((*sig_data_out_vld).read());
	}
	void ccs_wrapper_data_out_dat_action()
	{ data_out_dat.write((*sig_data_out_dat).read());
	}
	void ccs_wrapper_pe_start_vld_action()
	{ pe_start_vld.write((*sig_pe_start_vld).read());
	}
	void ccs_wrapper_pe_start_dat_action()
	{ pe_start_dat.write((*sig_pe_start_dat).read());
	}
	void ccs_wrapper_pe_done_rdy_action()
	{ pe_done_rdy.write((*sig_pe_done_rdy).read());
	}
	void ccs_wrapper_gb_done_vld_action()
	{ gb_done_vld.write((*sig_gb_done_vld).read());
	}
	void ccs_wrapper_gb_done_dat_action()
	{ gb_done_dat.write((*sig_gb_done_dat).read());
	}

	const char *kind() const { return "dki_module_verilog"; }
};


#endif
