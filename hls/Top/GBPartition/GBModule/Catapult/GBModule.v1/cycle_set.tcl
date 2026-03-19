
# Loop constraints
directive set /GBModule/RVAInRun/RVAInRun:rlp CSTEPS_FROM {{. == 1}}
directive set /GBModule/RVAInRun/RVAInRun:rlp/while CSTEPS_FROM {{. == 3} {.. == 1}}

# IO operation constraints
directive set /GBModule/RVAInRun/RVAInRun:rlp/while/while:if:if:asn CSTEPS_FROM {{.. == 2}}

# Sync operation constraints

# Real operation constraints
directive set /GBModule/RVAInRun/RVAInRun:rlp/while/rva_in.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /GBModule/RVAInRun/RVAInRun:rlp/while/gbcore_rva_in.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBModule/RVAInRun/RVAInRun:rlp/while/nmp_rva_in.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBModule/RVAInRun/RVAInRun:rlp/while/gbcontrol_rva_in.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBModule/RVAInRun/RVAInRun:rlp/while/gbcontrol_start.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBModule/RVAInRun/RVAInRun:rlp/while/nmp_start.Push() CSTEPS_FROM {{.. == 2}}

# Probe constraints

# Loop constraints
directive set /GBModule/RVAOutRun/RVAOutRun:rlp CSTEPS_FROM {{. == 1}}
directive set /GBModule/RVAOutRun/RVAOutRun:rlp/while CSTEPS_FROM {{. == 5} {.. == 1}}

# IO operation constraints

# Sync operation constraints

# Real operation constraints
directive set /GBModule/RVAOutRun/RVAOutRun:rlp/while/gbcore_rva_out.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /GBModule/RVAOutRun/RVAOutRun:rlp/while/nmp_rva_out.PopNB() CSTEPS_FROM {{.. == 2}}
directive set /GBModule/RVAOutRun/RVAOutRun:rlp/while/gbcontrol_rva_out.PopNB() CSTEPS_FROM {{.. == 3}}
directive set /GBModule/RVAOutRun/RVAOutRun:rlp/while/while:while:mux1h CSTEPS_FROM {{.. == 4}}
directive set /GBModule/RVAOutRun/RVAOutRun:rlp/while/rva_out.Push() CSTEPS_FROM {{.. == 4}}

# Probe constraints

# Loop constraints
directive set /GBModule/GBDoneRun/GBDoneRun:rlp CSTEPS_FROM {{. == 1}}
directive set /GBModule/GBDoneRun/GBDoneRun:rlp/while CSTEPS_FROM {{. == 4} {.. == 1}}

# IO operation constraints

# Sync operation constraints

# Real operation constraints
directive set /GBModule/GBDoneRun/GBDoneRun:rlp/while/gbcontrol_done.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /GBModule/GBDoneRun/GBDoneRun:rlp/while/nmp_done.PopNB() CSTEPS_FROM {{.. == 2}}
directive set /GBModule/GBDoneRun/GBDoneRun:rlp/while/gb_done.Push() CSTEPS_FROM {{.. == 3}}

# Probe constraints
