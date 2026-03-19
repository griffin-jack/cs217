# written for flow package Vivado 
set sdc_version 1.7 

create_clock -name virtual_io_clk -period 1.48974
## IO TIMING CONSTRAINTS
set_max_delay 1.48974 -from [all_inputs] -to [all_outputs]
set_input_delay 0.0 -clock virtual_io_clk [get_ports {mantissa[*]}]
set_output_delay 0.0 -clock virtual_io_clk [get_ports {rtn[*]}]

