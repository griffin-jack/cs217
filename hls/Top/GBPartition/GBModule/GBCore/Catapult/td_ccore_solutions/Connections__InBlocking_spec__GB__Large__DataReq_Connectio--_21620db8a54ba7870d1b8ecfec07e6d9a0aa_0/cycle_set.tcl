
# Loop constraints
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp CSTEPS_FROM {{. == 0}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main CSTEPS_FROM {{. == 3} {.. == 0}}

# IO operation constraints
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/io_read(ccs_ccore_start:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/this.rdy.write:asn(this.rdy) CSTEPS_FROM {{.. == 1}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/this.rdy.write#1:asn(this.rdy) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/this.read_msg:asn(marshaller.Marshaller:v)#1 CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/marshaller.AddField<ac_int<1,false>,1>:else:bits:io_write(data.is_write:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/marshaller.AddField<ac_int<2,false>,2>:else:bits:io_write(data.memory_index:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/marshaller.AddField<ac_int<8,false>,8>:else:bits:io_write(data.vector_index:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/marshaller.AddField<ac_int<16,false>,16>:else:bits:io_write(data.timestep_index:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/data.write_data.data:io_write(data.write_data.data:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/return:asn CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<spec::GB::Large::DataReq,Connections::SYN_PORT>::PopNB/core/core:rlp/main/return:io_write(return:rsc.@) CSTEPS_FROM {{.. == 2}}

# Sync operation constraints

# Real operation constraints

# Probe constraints
