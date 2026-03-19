# written for flow package Vivado 
set sdc_version 1.7 

create_clock -name clk -period 4.0 -waveform { 0.0 2.0 } [get_ports {clk}]
set_clock_uncertainty 0.0 [get_clocks {clk}]

create_clock -name virtual_io_clk -period 4.0
## IO TIMING CONSTRAINTS
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_in_large_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_in_large_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_in_large_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_out_large_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_out_large_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_out_large_dat[*]}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {nmp_large_req_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {nmp_large_req_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {nmp_large_req_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {nmp_large_rsp_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {nmp_large_rsp_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {nmp_large_rsp_dat[*]}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {gbcontrol_large_req_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {gbcontrol_large_req_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {gbcontrol_large_req_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {gbcontrol_large_rsp_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {gbcontrol_large_rsp_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {gbcontrol_large_rsp_dat[*]}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {SC_SRAM_CONFIG[*]}]

