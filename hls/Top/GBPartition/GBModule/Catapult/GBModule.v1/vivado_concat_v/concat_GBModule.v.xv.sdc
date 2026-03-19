# written for flow package Vivado 
set sdc_version 1.7 

create_clock -name clk -period 4.0 -waveform { 0.0 2.0 } [get_ports {clk}]
set_clock_uncertainty 0.0 [get_clocks {clk}]

create_clock -name virtual_io_clk -period 4.0
## IO TIMING CONSTRAINTS
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_in_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_in_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_in_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_out_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_out_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {rva_out_dat[*]}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {data_in_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {data_in_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {data_in_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {data_out_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {data_out_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {data_out_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {pe_start_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {pe_start_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {pe_start_dat}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {pe_done_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {pe_done_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {pe_done_dat}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {gb_done_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {gb_done_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {gb_done_dat}]

