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
	sc_in<sc_logic>  rva_in_large_vld;
	sc_in<sc_lv<169> >  rva_in_large_dat;
	sc_in<sc_logic>  rva_out_large_rdy;
	sc_in<sc_logic>  nmp_large_req_vld;
	sc_in<sc_lv<155> >  nmp_large_req_dat;
	sc_in<sc_logic>  nmp_large_rsp_rdy;
	sc_in<sc_logic>  gbcontrol_large_req_vld;
	sc_in<sc_lv<155> >  gbcontrol_large_req_dat;
	sc_in<sc_logic>  gbcontrol_large_rsp_rdy;
	sc_in<sc_lv<32> >  SC_SRAM_CONFIG;

	//Output ports
	sc_out<sc_logic>  rva_in_large_rdy;
	sc_out<sc_logic>  rva_out_large_vld;
	sc_out<sc_lv<128> >  rva_out_large_dat;
	sc_out<sc_logic>  nmp_large_req_rdy;
	sc_out<sc_logic>  nmp_large_rsp_vld;
	sc_out<sc_lv<128> >  nmp_large_rsp_dat;
	sc_out<sc_logic>  gbcontrol_large_req_rdy;
	sc_out<sc_logic>  gbcontrol_large_rsp_vld;
	sc_out<sc_lv<128> >  gbcontrol_large_rsp_dat;

	sc_signal<bool,SC_UNCHECKED_WRITERS> *sig_clk;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rst;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_in_large_vld;
	sc_signal<sc_lv<169>,SC_UNCHECKED_WRITERS > *sig_rva_in_large_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_out_large_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_nmp_large_req_vld;
	sc_signal<sc_lv<155>,SC_UNCHECKED_WRITERS > *sig_nmp_large_req_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_nmp_large_rsp_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_gbcontrol_large_req_vld;
	sc_signal<sc_lv<155>,SC_UNCHECKED_WRITERS > *sig_gbcontrol_large_req_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_gbcontrol_large_rsp_rdy;
	sc_signal<sc_lv<32>,SC_UNCHECKED_WRITERS > *sig_SC_SRAM_CONFIG;

	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_in_large_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_rva_out_large_vld;
	sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS > *sig_rva_out_large_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_nmp_large_req_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_nmp_large_rsp_vld;
	sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS > *sig_nmp_large_rsp_dat;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_gbcontrol_large_req_rdy;
	sc_signal<sc_logic,SC_UNCHECKED_WRITERS> *sig_gbcontrol_large_rsp_vld;
	sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS > *sig_gbcontrol_large_rsp_dat;

	// Parameters

	SC_HAS_PROCESS(ccs_wrapper);
	ccs_wrapper(sc_module_name modelName): sc_module(modelName)
	{
		sig_clk = new sc_signal<bool,SC_UNCHECKED_WRITERS>("sig_clk");
		sig_rst = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rst");
		sig_rva_in_large_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_in_large_vld");
		sig_rva_in_large_dat = new sc_signal<sc_lv<169>,SC_UNCHECKED_WRITERS >("sig_rva_in_large_dat");
		sig_rva_out_large_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_out_large_rdy");
		sig_nmp_large_req_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_nmp_large_req_vld");
		sig_nmp_large_req_dat = new sc_signal<sc_lv<155>,SC_UNCHECKED_WRITERS >("sig_nmp_large_req_dat");
		sig_nmp_large_rsp_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_nmp_large_rsp_rdy");
		sig_gbcontrol_large_req_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_gbcontrol_large_req_vld");
		sig_gbcontrol_large_req_dat = new sc_signal<sc_lv<155>,SC_UNCHECKED_WRITERS >("sig_gbcontrol_large_req_dat");
		sig_gbcontrol_large_rsp_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_gbcontrol_large_rsp_rdy");
		sig_SC_SRAM_CONFIG = new sc_signal<sc_lv<32>,SC_UNCHECKED_WRITERS >("sig_SC_SRAM_CONFIG");

		sig_rva_in_large_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_in_large_rdy");
		sig_rva_out_large_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_rva_out_large_vld");
		sig_rva_out_large_dat = new sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS >("sig_rva_out_large_dat");
		sig_nmp_large_req_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_nmp_large_req_rdy");
		sig_nmp_large_rsp_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_nmp_large_rsp_vld");
		sig_nmp_large_rsp_dat = new sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS >("sig_nmp_large_rsp_dat");
		sig_gbcontrol_large_req_rdy = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_gbcontrol_large_req_rdy");
		sig_gbcontrol_large_rsp_vld = new sc_signal<sc_logic,SC_UNCHECKED_WRITERS>("sig_gbcontrol_large_rsp_vld");
		sig_gbcontrol_large_rsp_dat = new sc_signal<sc_lv<128>,SC_UNCHECKED_WRITERS >("sig_gbcontrol_large_rsp_dat");

		HDL_MODULE("ccs_wrapper", name(), basename());
		SC_METHOD(ccs_wrapper_clk_action); sensitive << clk; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rst_action); sensitive << rst; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_in_large_vld_action); sensitive << rva_in_large_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_in_large_dat_action); sensitive << rva_in_large_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_large_rdy_action); sensitive << rva_out_large_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_nmp_large_req_vld_action); sensitive << nmp_large_req_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_nmp_large_req_dat_action); sensitive << nmp_large_req_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_nmp_large_rsp_rdy_action); sensitive << nmp_large_rsp_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gbcontrol_large_req_vld_action); sensitive << gbcontrol_large_req_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gbcontrol_large_req_dat_action); sensitive << gbcontrol_large_req_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gbcontrol_large_rsp_rdy_action); sensitive << gbcontrol_large_rsp_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_SC_SRAM_CONFIG_action); sensitive << SC_SRAM_CONFIG; snps_sysc_mark_last_create_process_as_internal();

		SC_METHOD(ccs_wrapper_rva_in_large_rdy_action); sensitive << *sig_rva_in_large_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_large_vld_action); sensitive << *sig_rva_out_large_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_rva_out_large_dat_action); sensitive << *sig_rva_out_large_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_nmp_large_req_rdy_action); sensitive << *sig_nmp_large_req_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_nmp_large_rsp_vld_action); sensitive << *sig_nmp_large_rsp_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_nmp_large_rsp_dat_action); sensitive << *sig_nmp_large_rsp_dat; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gbcontrol_large_req_rdy_action); sensitive << *sig_gbcontrol_large_req_rdy; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gbcontrol_large_rsp_vld_action); sensitive << *sig_gbcontrol_large_rsp_vld; snps_sysc_mark_last_create_process_as_internal();
		SC_METHOD(ccs_wrapper_gbcontrol_large_rsp_dat_action); sensitive << *sig_gbcontrol_large_rsp_dat; snps_sysc_mark_last_create_process_as_internal();

		std::string clk_string = name();
		clk_string += "_R_clk";
		alterString(clk_string, basename());
		hdl_connect_v_int(*sig_clk, clk_string.c_str(), HDL_OUTPUT);

		std::string rst_string = name();
		rst_string += "_R_rst";
		alterString(rst_string, basename());
		hdl_connect_v_int(*sig_rst, rst_string.c_str(), HDL_OUTPUT);

		std::string rva_in_large_vld_string = name();
		rva_in_large_vld_string += "_R_rva_in_large_vld";
		alterString(rva_in_large_vld_string, basename());
		hdl_connect_v_int(*sig_rva_in_large_vld, rva_in_large_vld_string.c_str(), HDL_OUTPUT);

		std::string rva_in_large_dat_string = name();
		rva_in_large_dat_string += "_R_rva_in_large_dat";
		alterString(rva_in_large_dat_string, basename());
		hdl_connect_v_int(*sig_rva_in_large_dat, rva_in_large_dat_string.c_str(), HDL_OUTPUT);

		std::string rva_out_large_rdy_string = name();
		rva_out_large_rdy_string += "_R_rva_out_large_rdy";
		alterString(rva_out_large_rdy_string, basename());
		hdl_connect_v_int(*sig_rva_out_large_rdy, rva_out_large_rdy_string.c_str(), HDL_OUTPUT);

		std::string nmp_large_req_vld_string = name();
		nmp_large_req_vld_string += "_R_nmp_large_req_vld";
		alterString(nmp_large_req_vld_string, basename());
		hdl_connect_v_int(*sig_nmp_large_req_vld, nmp_large_req_vld_string.c_str(), HDL_OUTPUT);

		std::string nmp_large_req_dat_string = name();
		nmp_large_req_dat_string += "_R_nmp_large_req_dat";
		alterString(nmp_large_req_dat_string, basename());
		hdl_connect_v_int(*sig_nmp_large_req_dat, nmp_large_req_dat_string.c_str(), HDL_OUTPUT);

		std::string nmp_large_rsp_rdy_string = name();
		nmp_large_rsp_rdy_string += "_R_nmp_large_rsp_rdy";
		alterString(nmp_large_rsp_rdy_string, basename());
		hdl_connect_v_int(*sig_nmp_large_rsp_rdy, nmp_large_rsp_rdy_string.c_str(), HDL_OUTPUT);

		std::string gbcontrol_large_req_vld_string = name();
		gbcontrol_large_req_vld_string += "_R_gbcontrol_large_req_vld";
		alterString(gbcontrol_large_req_vld_string, basename());
		hdl_connect_v_int(*sig_gbcontrol_large_req_vld, gbcontrol_large_req_vld_string.c_str(), HDL_OUTPUT);

		std::string gbcontrol_large_req_dat_string = name();
		gbcontrol_large_req_dat_string += "_R_gbcontrol_large_req_dat";
		alterString(gbcontrol_large_req_dat_string, basename());
		hdl_connect_v_int(*sig_gbcontrol_large_req_dat, gbcontrol_large_req_dat_string.c_str(), HDL_OUTPUT);

		std::string gbcontrol_large_rsp_rdy_string = name();
		gbcontrol_large_rsp_rdy_string += "_R_gbcontrol_large_rsp_rdy";
		alterString(gbcontrol_large_rsp_rdy_string, basename());
		hdl_connect_v_int(*sig_gbcontrol_large_rsp_rdy, gbcontrol_large_rsp_rdy_string.c_str(), HDL_OUTPUT);

		std::string SC_SRAM_CONFIG_string = name();
		SC_SRAM_CONFIG_string += "_R_SC_SRAM_CONFIG";
		alterString(SC_SRAM_CONFIG_string, basename());
		hdl_connect_v_int(*sig_SC_SRAM_CONFIG, SC_SRAM_CONFIG_string.c_str(), HDL_OUTPUT);

		std::string rva_in_large_rdy_string = name();
		alterString(rva_in_large_rdy_string, basename());
		rva_in_large_rdy_string += ".rva_in_large_rdy";
		hdl_connect_v_int(*sig_rva_in_large_rdy, rva_in_large_rdy_string.c_str(), HDL_INPUT);

		std::string rva_out_large_vld_string = name();
		alterString(rva_out_large_vld_string, basename());
		rva_out_large_vld_string += ".rva_out_large_vld";
		hdl_connect_v_int(*sig_rva_out_large_vld, rva_out_large_vld_string.c_str(), HDL_INPUT);

		std::string rva_out_large_dat_string = name();
		alterString(rva_out_large_dat_string, basename());
		rva_out_large_dat_string += ".rva_out_large_dat";
		hdl_connect_v_int(*sig_rva_out_large_dat, rva_out_large_dat_string.c_str(), HDL_INPUT);

		std::string nmp_large_req_rdy_string = name();
		alterString(nmp_large_req_rdy_string, basename());
		nmp_large_req_rdy_string += ".nmp_large_req_rdy";
		hdl_connect_v_int(*sig_nmp_large_req_rdy, nmp_large_req_rdy_string.c_str(), HDL_INPUT);

		std::string nmp_large_rsp_vld_string = name();
		alterString(nmp_large_rsp_vld_string, basename());
		nmp_large_rsp_vld_string += ".nmp_large_rsp_vld";
		hdl_connect_v_int(*sig_nmp_large_rsp_vld, nmp_large_rsp_vld_string.c_str(), HDL_INPUT);

		std::string nmp_large_rsp_dat_string = name();
		alterString(nmp_large_rsp_dat_string, basename());
		nmp_large_rsp_dat_string += ".nmp_large_rsp_dat";
		hdl_connect_v_int(*sig_nmp_large_rsp_dat, nmp_large_rsp_dat_string.c_str(), HDL_INPUT);

		std::string gbcontrol_large_req_rdy_string = name();
		alterString(gbcontrol_large_req_rdy_string, basename());
		gbcontrol_large_req_rdy_string += ".gbcontrol_large_req_rdy";
		hdl_connect_v_int(*sig_gbcontrol_large_req_rdy, gbcontrol_large_req_rdy_string.c_str(), HDL_INPUT);

		std::string gbcontrol_large_rsp_vld_string = name();
		alterString(gbcontrol_large_rsp_vld_string, basename());
		gbcontrol_large_rsp_vld_string += ".gbcontrol_large_rsp_vld";
		hdl_connect_v_int(*sig_gbcontrol_large_rsp_vld, gbcontrol_large_rsp_vld_string.c_str(), HDL_INPUT);

		std::string gbcontrol_large_rsp_dat_string = name();
		alterString(gbcontrol_large_rsp_dat_string, basename());
		gbcontrol_large_rsp_dat_string += ".gbcontrol_large_rsp_dat";
		hdl_connect_v_int(*sig_gbcontrol_large_rsp_dat, gbcontrol_large_rsp_dat_string.c_str(), HDL_INPUT);

		vcsModel = VcsDesign::getDesignInstance()->addModel("ccs_wrapper");
		vcsInstance = vcsModel->addInstance(name());
		vcsInstance->setScObj(this);
		vcsInstance->setNames("ccs_wrapper", name(), basename());
		vcsInstance->addPort("clk",  VcsPort::INPUT_PORT, 1, 0, "bool", VcsPort::BC_C);
		vcsInstance->addPort("rst",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_large_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_large_dat",  VcsPort::INPUT_PORT, 169, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_large_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("nmp_large_req_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("nmp_large_req_dat",  VcsPort::INPUT_PORT, 155, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("nmp_large_rsp_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("gbcontrol_large_req_vld",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("gbcontrol_large_req_dat",  VcsPort::INPUT_PORT, 155, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("gbcontrol_large_rsp_rdy",  VcsPort::INPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("SC_SRAM_CONFIG",  VcsPort::INPUT_PORT, 32, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("rva_in_large_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_large_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("rva_out_large_dat",  VcsPort::OUTPUT_PORT, 128, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("nmp_large_req_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("nmp_large_rsp_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("nmp_large_rsp_dat",  VcsPort::OUTPUT_PORT, 128, 0, "sc_lv", VcsPort::BC_C);
		vcsInstance->addPort("gbcontrol_large_req_rdy",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("gbcontrol_large_rsp_vld",  VcsPort::OUTPUT_PORT, 1, 0, "sc_logic", VcsPort::BC_C);
		vcsInstance->addPort("gbcontrol_large_rsp_dat",  VcsPort::OUTPUT_PORT, 128, 0, "sc_lv", VcsPort::BC_C);
	};

	void ccs_wrapper_clk_action()
	{ sig_clk->write(clk.read());
	}
	void ccs_wrapper_rst_action()
	{ sig_rst->write(rst.read());
	}
	void ccs_wrapper_rva_in_large_vld_action()
	{ sig_rva_in_large_vld->write(rva_in_large_vld.read());
	}
	void ccs_wrapper_rva_in_large_dat_action()
	{ sig_rva_in_large_dat->write(rva_in_large_dat.read());
	}
	void ccs_wrapper_rva_out_large_rdy_action()
	{ sig_rva_out_large_rdy->write(rva_out_large_rdy.read());
	}
	void ccs_wrapper_nmp_large_req_vld_action()
	{ sig_nmp_large_req_vld->write(nmp_large_req_vld.read());
	}
	void ccs_wrapper_nmp_large_req_dat_action()
	{ sig_nmp_large_req_dat->write(nmp_large_req_dat.read());
	}
	void ccs_wrapper_nmp_large_rsp_rdy_action()
	{ sig_nmp_large_rsp_rdy->write(nmp_large_rsp_rdy.read());
	}
	void ccs_wrapper_gbcontrol_large_req_vld_action()
	{ sig_gbcontrol_large_req_vld->write(gbcontrol_large_req_vld.read());
	}
	void ccs_wrapper_gbcontrol_large_req_dat_action()
	{ sig_gbcontrol_large_req_dat->write(gbcontrol_large_req_dat.read());
	}
	void ccs_wrapper_gbcontrol_large_rsp_rdy_action()
	{ sig_gbcontrol_large_rsp_rdy->write(gbcontrol_large_rsp_rdy.read());
	}
	void ccs_wrapper_SC_SRAM_CONFIG_action()
	{ sig_SC_SRAM_CONFIG->write(SC_SRAM_CONFIG.read());
	}

	void ccs_wrapper_rva_in_large_rdy_action()
	{ rva_in_large_rdy.write((*sig_rva_in_large_rdy).read());
	}
	void ccs_wrapper_rva_out_large_vld_action()
	{ rva_out_large_vld.write((*sig_rva_out_large_vld).read());
	}
	void ccs_wrapper_rva_out_large_dat_action()
	{ rva_out_large_dat.write((*sig_rva_out_large_dat).read());
	}
	void ccs_wrapper_nmp_large_req_rdy_action()
	{ nmp_large_req_rdy.write((*sig_nmp_large_req_rdy).read());
	}
	void ccs_wrapper_nmp_large_rsp_vld_action()
	{ nmp_large_rsp_vld.write((*sig_nmp_large_rsp_vld).read());
	}
	void ccs_wrapper_nmp_large_rsp_dat_action()
	{ nmp_large_rsp_dat.write((*sig_nmp_large_rsp_dat).read());
	}
	void ccs_wrapper_gbcontrol_large_req_rdy_action()
	{ gbcontrol_large_req_rdy.write((*sig_gbcontrol_large_req_rdy).read());
	}
	void ccs_wrapper_gbcontrol_large_rsp_vld_action()
	{ gbcontrol_large_rsp_vld.write((*sig_gbcontrol_large_rsp_vld).read());
	}
	void ccs_wrapper_gbcontrol_large_rsp_dat_action()
	{ gbcontrol_large_rsp_dat.write((*sig_gbcontrol_large_rsp_dat).read());
	}

	const char *kind() const { return "dki_module_verilog"; }
};


#endif
