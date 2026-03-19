
# Loop constraints
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp CSTEPS_FROM {{. == 0}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main CSTEPS_FROM {{. == 3} {.. == 0}}

# IO operation constraints
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/io_read(ccs_ccore_start:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/this.rdy.write:asn(this.rdy) CSTEPS_FROM {{.. == 1}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/this.rdy.write#1:asn(this.rdy) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/this.read_msg:asn(marshaller.Marshaller:v)#1 CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/marshaller.AddField<ac_int<10,false>,10>:else:bits:io_write(data.id:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/marshaller.AddField<ac_int<32,false>,32>:else:bits:io_write(data.addr:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/marshaller.AddField<ac_int<8,false>,8>:else:bits:io_write(data.len:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/return:asn CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<axi::axi4<spec::Axi::axiCfg>::AddrPayload,Connections::SYN_PORT>::PopNB/core/core:rlp/main/return:io_write(return:rsc.@) CSTEPS_FROM {{.. == 2}}

# Sync operation constraints

# Real operation constraints

# Probe constraints
