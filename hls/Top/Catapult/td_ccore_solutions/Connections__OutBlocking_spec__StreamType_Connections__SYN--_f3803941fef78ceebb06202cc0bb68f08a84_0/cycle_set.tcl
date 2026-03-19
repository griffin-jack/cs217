
# Loop constraints
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp CSTEPS_FROM {{. == 0}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main CSTEPS_FROM {{. == 3} {.. == 0}}

# IO operation constraints
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/m.logical_addr:io_read(m.logical_addr:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/m.index:io_read(m.index:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/m.data.data:io_read(m.data.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/io_read(ccs_ccore_start:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/this.vld.write:asn(this.vld) CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/marshaller.AddField<ac_int<8,false>,8>:if:asn CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:asn CSTEPS_FROM {{.. == 2}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/this.vld.write#1:asn(this.vld) CSTEPS_FROM {{.. == 2}}

# Sync operation constraints

# Real operation constraints
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux#1 CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux#2 CSTEPS_FROM {{.. == 1}}
directive set /Connections::OutBlocking<spec::StreamType,Connections::SYN_PORT>::Push/core/core:rlp/main/this.Push#1:do:mux#4 CSTEPS_FROM {{.. == 1}}

# Probe constraints
