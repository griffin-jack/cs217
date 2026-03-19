# written for flow package Vivado 
set sdc_version 1.7 

create_clock -name ccs_CLU_clk -period 4.0 -waveform { 0.0 2.0 } [get_ports {ccs_CLU_clk}]
set_clock_uncertainty 0.0 [get_clocks {ccs_CLU_clk}]

create_clock -name virtual_io_clk -period 4.0
## IO TIMING CONSTRAINTS
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_1[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_2[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_3[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_4[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_5[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_6[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_7[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_8[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_9[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_10[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_11[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_12[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_13[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_14[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_15[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_16[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {I_17[*]}]
set_output_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {O_1[*]}]
set_input_delay -clock [get_clocks {ccs_CLU_clk}] 0.0 [get_ports {ccs_CLU_en}]

