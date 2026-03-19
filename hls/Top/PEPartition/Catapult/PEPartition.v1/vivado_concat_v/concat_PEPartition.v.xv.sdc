# written for flow package Vivado 
set sdc_version 1.7 

create_clock -name clk -period 4.0 -waveform { 0.0 2.0 } [get_ports {clk}]
set_clock_uncertainty 0.0 [get_clocks {clk}]

create_clock -name virtual_io_clk -period 4.0
## IO TIMING CONSTRAINTS
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_rd_ar_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_rd_ar_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_rd_ar_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_rd_r_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_rd_r_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_rd_r_dat[*]}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_aw_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_aw_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_aw_dat[*]}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_w_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_w_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_w_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_b_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_b_rdy}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {if_axi_wr_b_dat[*]}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {start_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {start_rdy}]
set_input_delay 0.0 -clock virtual_io_clk [get_ports {input_port_vld}]
set_output_delay 0.0 -clock virtual_io_clk [get_ports {input_port_rdy}]
set_input_delay 0.0 -clock virtual_io_clk [get_ports {input_port_dat[*]}]
set_output_delay 0.0 -clock virtual_io_clk [get_ports {output_port_vld}]
set_input_delay 0.0 -clock virtual_io_clk [get_ports {output_port_rdy}]
set_output_delay 0.0 -clock virtual_io_clk [get_ports {output_port_dat[*]}]
set_input_delay 0.0 -clock virtual_io_clk [get_ports {start_dat}]
set_output_delay 0.0 -clock virtual_io_clk [get_ports {done_vld}]
set_input_delay 0.0 -clock virtual_io_clk [get_ports {done_rdy}]
set_output_delay 0.0 -clock virtual_io_clk [get_ports {done_dat}]

