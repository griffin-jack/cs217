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
	sc_in<sc_logic>  start_vld;
	sc_in<sc_logic>  start_dat;
	sc_in<sc_logic>  done_rdy;
	sc_in<sc_logic>  large_req_rdy;
	sc_in<sc_logic>  large_rsp_vld;
	sc_in<sc_lv<128> >  large_rsp_dat;

	//Output ports
	sc_out<sc_logic>  rva_in_rdy;
	sc_out<sc_logic>  rva_out_vld;
	sc_out<sc_lv<128> >  rva_out_dat;
	sc_out<sc_logic>  start_rdy;
	sc_out<sc_logic>  done_vld;
	sc_out<sc_logic>  done_dat;
	sc_out<sc_logic>  large_req_vld;
	sc_out<sc_lv<155> >  large_req_dat;
	sc_out<sc_logic>  large_rsp_rdy;

	sc_signal<bool,SC_UNCHECKED_WRITERS> *sig_clk;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rst;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_in_vld;
	sc_signal<sc_lv<169>,SC_UNCHECKED_WRITERS > *sig_rva_in_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_out_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_start_vld;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_start_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_done_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_large_req_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_large_rsp_vld;
	sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS > *sig_large_rsp_dat;

	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_in_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_out_vld;
	sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS > *sig_rva_out_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_start_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_done_vld;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_done_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_large_req_vld;
	sc_signal<sc_lv<155>,SC_UNCHECKED_WRITERS > *sig_large_req_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_large_rsp_rdy;

	// Parameters

	SC_HAS_PROCESS(ccs_wrapper);
	ccs_wrapper(sc_module_name modelName): sc_module(modelName)
	{
		sig_clk = new sc_signal<bool,SC_UNCHECKED_WRITERS>("sig_clk");
		sig_rst = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rst");
		sig_rva_in_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_in_vld");
		sig_rva_in_dat = new sc_signal<sc_lv<169>,SC_UNCHECKED_WRITERS >("sig_rva_in_dat");
		sig_rva_out_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_out_rdy");
		sig_start_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_start_vld");
		sig_start_dat = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_start_dat");
		sig_done_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_done_rdy");
		sig_large_req_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_large_req_rdy");
		sig_large_rsp_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_large_rsp_vld");
		sig_large_rsp_dat = new sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS >("sig_large_rsp_dat");

		sig_rva_in_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_in_rdy");
		sig_rva_out_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_out_vld");
		sig_rva_out_dat = new sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS >("sig_rva_out_dat");
		sig_start_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_start_rdy");
		sig_done_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_done_vld");
		sig_done_dat = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_done_dat");
		sig_large_req_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_large_req_vld");
		sig_large_req_dat = new sc_signal<sc_lv<155>,SC_UNCHECKED_WRITERS >("sig_large_req_dat");
		sig_large_rsp_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_large_rsp_rdy");

		HDL_MODULE("ccs_wrapper", name(), basename());
		SC_METHOD(ccs_wrapper_clk_action); sensitive << clk; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rst_action); sensitive << rst; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_in_vld_action); sensitive << rva_in_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_in_dat_action); sensitive << rva_in_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_rdy_action); sensitive << rva_out_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_start_vld_action); sensitive << start_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_start_dat_action); sensitive << start_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_done_rdy_action); sensitive << done_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_large_req_rdy_action); sensitive << large_req_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_large_rsp_vld_action); sensitive << large_rsp_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_large_rsp_dat_action); sensitive << large_rsp_dat; snps_sysc_mark_last_create_process_as_internal();

		SC_METHOD(ccs_wrapper_rva_in_rdy_action); sensitive << *sig_rva_in_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_vld_action); sensitive << *sig_rva_out_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_dat_action); sensitive << *sig_rva_out_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_start_rdy_action); sensitive << *sig_start_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_done_vld_action); sensitive << *sig_done_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_done_dat_action); sensitive << *sig_done_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_large_req_vld_action); sensitive << *sig_large_req_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_large_req_dat_action); sensitive << *sig_large_req_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_large_rsp_rdy_action); sensitive << *sig_large_rsp_rdy; snps_sysc_mark_last_create_process_as_internal();

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

		std::string start_vld_string = name();
		start_vld_string += "_R_start_vld";
		alterString(start_vld_string, basename());
		hdl_connect_v_int(*sig_start_vld, start_vld_string.c_str(), HDL_OUTPUT);

		std::string start_dat_string = name();
		start_dat_string += "_R_start_dat";
		alterString(start_dat_string, basename());
		hdl_connect_v_int(*sig_start_dat, start_dat_string.c_str(), HDL_OUTPUT);

		std::string done_rdy_string = name();
		done_rdy_string += "_R_done_rdy";
		alterString(done_rdy_string, basename());
		hdl_connect_v_int(*sig_done_rdy, done_rdy_string.c_str(), HDL_OUTPUT);

		std::string large_req_rdy_string = name();
		large_req_rdy_string += "_R_large_req_rdy";
		alterString(large_req_rdy_string, basename());
		hdl_connect_v_int(*sig_large_req_rdy, large_req_rdy_string.c_str(), HDL_OUTPUT);

		std::string large_rsp_vld_string = name();
		large_rsp_vld_string += "_R_large_rsp_vld";
		alterString(large_rsp_vld_string, basename());
		hdl_connect_v_int(*sig_large_rsp_vld, large_rsp_vld_string.c_str(), HDL_OUTPUT);

		std::string large_rsp_dat_string = name();
		large_rsp_dat_string += "_R_large_rsp_dat";
		alterString(large_rsp_dat_string, basename());
		hdl_connect_v_int(*sig_large_rsp_dat, large_rsp_dat_string.c_str(), HDL_OUTPUT);

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

		std::string start_rdy_string = name();
		alterString(start_rdy_string, basename());
		start_rdy_string += ".start_rdy";
		hdl_connect_v_int(*sig_start_rdy, start_rdy_string.c_str(), HDL_INPUT);

		std::string done_vld_string = name();
		alterString(done_vld_string, basename());
		done_vld_string += ".done_vld";
		hdl_connect_v_int(*sig_done_vld, done_vld_string.c_str(), HDL_INPUT);

		std::string done_dat_string = name();
		alterString(done_dat_string, basename());
		done_dat_string += ".done_dat";
		hdl_connect_v_int(*sig_done_dat, done_dat_string.c_str(), HDL_INPUT);

		std::string large_req_vld_string = name();
		alterString(large_req_vld_string, basename());
		large_req_vld_string += ".large_req_vld";
		hdl_connect_v_int(*sig_large_req_vld, large_req_vld_string.c_str(), HDL_INPUT);

		std::string large_req_dat_string = name();
		alterString(large_req_dat_string, basename());
		large_req_dat_string += ".large_req_dat";
		hdl_connect_v_int(*sig_large_req_dat, large_req_dat_string.c_str(), HDL_INPUT);

		std::string large_rsp_rdy_string = name();
		alterString(large_rsp_rdy_string, basename());
		large_rsp_rdy_string += ".large_rsp_rdy";
		hdl_connect_v_int(*sig_large_rsp_rdy, large_rsp_rdy_string.c_str(), HDL_INPUT);

		vcsModel = VcsDesign::getDesignInstance()->addModel("ccs_wrapper");
		vcsInstance = vcsModel->addInstance(name());
		vcsInstance->setScObj(this);
		vcsInstance->setNames("ccs_wrapper", name(), basename());
		vcsInstance->addPort("clk",  VcsPort::INPUT_PORT, 1, 0, "bool", VcsPort::BC_C);
		vcsInstance->addPort("rst",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_dat",  VcsPort::INPUT_PORT, 169, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("start_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("start_dat",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("done_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("large_req_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("large_rsp_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("large_rsp_dat",  VcsPort::INPUT_PORT, 128, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_dat",  VcsPort::OUTPUT_PORT, 128, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("start_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("done_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("done_dat",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("large_req_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("large_req_dat",  VcsPort::OUTPUT_PORT, 155, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("large_rsp_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
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
	void ccs_wrapper_start_vld_action()
	{ sig_start_vld->write(start_vld.read());
	}
	void ccs_wrapper_start_dat_action()
	{ sig_start_dat->write(start_dat.read());
	}
	void ccs_wrapper_done_rdy_action()
	{ sig_done_rdy->write(done_rdy.read());
	}
	void ccs_wrapper_large_req_rdy_action()
	{ sig_large_req_rdy->write(large_req_rdy.read());
	}
	void ccs_wrapper_large_rsp_vld_action()
	{ sig_large_rsp_vld->write(large_rsp_vld.read());
	}
	void ccs_wrapper_large_rsp_dat_action()
	{ sig_large_rsp_dat->write(large_rsp_dat.read());
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
	void ccs_wrapper_start_rdy_action()
	{ start_rdy.write((*sig_start_rdy).read());
	}
	void ccs_wrapper_done_vld_action()
	{ done_vld.write((*sig_done_vld).read());
	}
	void ccs_wrapper_done_dat_action()
	{ done_dat.write((*sig_done_dat).read());
	}
	void ccs_wrapper_large_req_vld_action()
	{ large_req_vld.write((*sig_large_req_vld).read());
	}
	void ccs_wrapper_large_req_dat_action()
	{ large_req_dat.write((*sig_large_req_dat).read());
	}
	void ccs_wrapper_large_rsp_rdy_action()
	{ large_rsp_rdy.write((*sig_large_rsp_rdy).read());
	}

	const char *kind() const { return "dki_module_verilog"; }
};


#endif
