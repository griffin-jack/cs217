
# Loop constraints
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp CSTEPS_FROM {{. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while CSTEPS_FROM {{. == 3} {.. == 1}}

# IO operation constraints

# Sync operation constraints

# Real operation constraints
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/arb.pick:mux#1 CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/arb.pick:mux#5 CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#2 CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#3 CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#4 CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/if_axi_rd.ar.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#11 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#12 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#15 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#16 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/if_axi_wr.aw.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#18 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#22 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#23 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/if_rv_wr.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/if_rv_rd.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:if#3:else:if:else:acc CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/operator+=<32,false>:acc CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/if_axi_rd.r.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:if#3:else:mux#2 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:if#3:mux#4 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/if_axi_wr.w.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/if_rv_wr.Push()#1 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/if_axi_wr.b.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/operator+=<24,false>:acc CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#37 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#29 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:if#3:else:mux#1 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:if#3:mux#2 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#30 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:else#3:if:mux CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:else#3:mux#3 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#31 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#32 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:else#3:if:mux#1 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:else#3:mux#4 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#33 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#35 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#36 CSTEPS_FROM {{.. == 2}}
directive set /GBPartition/AxiSubordinateToReadyValid<spec::Axi::axiCfg,spec::Axi::rvaCfg>/run/run:rlp/while/while:mux#38 CSTEPS_FROM {{.. == 2}}

# Probe constraints
