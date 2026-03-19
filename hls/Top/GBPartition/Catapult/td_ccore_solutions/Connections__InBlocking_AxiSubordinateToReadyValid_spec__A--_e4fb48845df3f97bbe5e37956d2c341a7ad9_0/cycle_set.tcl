
# Loop constraints
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp CSTEPS_FROM {{. == 0}}
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp/main CSTEPS_FROM {{. == 3} {.. == 0}}

# IO operation constraints
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp/main/io_read(ccs_ccore_start:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp/main/this.rdy.write:asn(this.rdy) CSTEPS_FROM {{.. == 1}}
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp/main/this.rdy.write#1:asn(this.rdy) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp/main/data.data:asn CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp/main/data.data:io_write(data.data:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp/main/return:asn CSTEPS_FROM {{.. == 2}}
directive set /Connections::InBlocking<AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>::Read,Connections::SYN_PORT>::PopNB/core/core:rlp/main/return:io_write(return:rsc.@) CSTEPS_FROM {{.. == 2}}

# Sync operation constraints

# Real operation constraints

# Probe constraints
