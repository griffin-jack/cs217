
# Loop constraints
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp CSTEPS_FROM {{. == 0}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main CSTEPS_FROM {{. == 3} {.. == 0}}

# IO operation constraints
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/m.write_data.data:io_read(m.write_data.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/m.timestep_index:io_read(m.timestep_index:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/m.vector_index:io_read(m.vector_index:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/m.memory_index:io_read(m.memory_index:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/m.is_write:io_read(m.is_write:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/io_read(ccs_ccore_start:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.vld.write:asn(this.vld) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/marshaller.AddField<ac_int<8,true>,8>:if:asn CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:asn CSTEPS_FROM {{.. == 2}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.vld.write#1:asn(this.vld) CSTEPS_FROM {{.. == 2}}

# Sync operation constraints

# Real operation constraints
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux#1 CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux#2 CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux#3 CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux#4 CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux#6 CSTEPS_FROM {{.. == 1}}

# Probe constraints
