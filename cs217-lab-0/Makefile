DESIGN_NAME ?= counter_top
AWS_DESIGN_NAME ?= counter

REPO_TOP 	?= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/)
SRC_HOME 	?= $(REPO_TOP)/src
HLS_HOME 	?= $(SRC_HOME)/hls
AWS_HOME	?= ./$(AWS_DESIGN_NAME)

systemc_sim:
	cd $(SRC_HOME)/$(DESIGN_NAME) && make sim_test && make run

hls_sim:
	cd $(HLS_HOME)/$(DESIGN_NAME) && make hls && make vcs_sim
	cp $(HLS_HOME)/$(DESIGN_NAME)/Catapult/$(DESIGN_NAME).v1/concat_$(DESIGN_NAME).v $(AWS_HOME)/design/

hls_sim_debug:
	cd $(HLS_HOME)/$(DESIGN_NAME) && make vcs_debug
	verdi -ssf $(HLS_HOME)/$(DESIGN_NAME)/default.fsdb -dbdir $(HLS_HOME)/$(DESIGN_NAME)/Catapult/$(DESIGN_NAME).v1/scverify/concat_sim_$(DESIGN_NAME)_v_vcs/sc_main.daidir/

rtl_copy:
	cp $(HLS_HOME)/$(DESIGN_NAME)/Catapult/$(DESIGN_NAME).v1/concat_$(DESIGN_NAME).v $(AWS_HOME)/design/

submission:
	zip lab0-submission.zip src/counter_top/counter_module.h src/counter_top/add.h counter/design/concat_counter_top.v
clean:
	cd $(SRC_HOME)/$(DESIGN_NAME) && make clean
	cd $(HLS_HOME)/$(DESIGN_NAME) && make clean
	rm -rf ./catapult_cache
	rm -rf ./*~
	rm -rf ./*.key
	rm -rf ./core*
	rm -rf ./Catapult*
	rm -rf ./catapult*
	rm -rf ./*.log
	rm -rf ./design_checker_*.tcl
	rm -rf ./DVE*
	rm -rf ./verdi*
	rm -rf ./slec*	
	rm -rf ./novas*	
	rm -rf ./*.fsdb
	rm -rf ./*.saif*
	rm -rf ./*.vpd 

