
# Loop constraints
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp CSTEPS_FROM {{. == 1}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while CSTEPS_FROM {{. == 4} {.. == 1}}

# IO operation constraints
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/while:if:case-3:if:asn CSTEPS_FROM {{.. == 3}}

# Sync operation constraints

# Real operation constraints
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/rva_in.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/pe_rva_in.Push() CSTEPS_FROM {{.. == 2}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/pe_rva_in.Push()#1 CSTEPS_FROM {{.. == 2}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/act_rva_in.Push() CSTEPS_FROM {{.. == 2}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/pe_rva_in.Push()#2 CSTEPS_FROM {{.. == 2}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/act_rva_in.Push()#1 CSTEPS_FROM {{.. == 2}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/start.PopNB() CSTEPS_FROM {{.. == 2}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/while:mux#1 CSTEPS_FROM {{.. == 3}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/pe_start.Push() CSTEPS_FROM {{.. == 3}}
directive set /PEModule/PERVA/RVAInRun/RVAInRun:rlp/while/act_start.Push() CSTEPS_FROM {{.. == 3}}

# Probe constraints

# Loop constraints
directive set /PEModule/PERVA/RVAOutRun/RVAOutRun:rlp CSTEPS_FROM {{. == 1}}
directive set /PEModule/PERVA/RVAOutRun/RVAOutRun:rlp/while CSTEPS_FROM {{. == 4} {.. == 1}}

# IO operation constraints

# Sync operation constraints

# Real operation constraints
directive set /PEModule/PERVA/RVAOutRun/RVAOutRun:rlp/while/pe_rva_out.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /PEModule/PERVA/RVAOutRun/RVAOutRun:rlp/while/act_rva_out.PopNB() CSTEPS_FROM {{.. == 2}}
directive set /PEModule/PERVA/RVAOutRun/RVAOutRun:rlp/while/while:mux CSTEPS_FROM {{.. == 3}}
directive set /PEModule/PERVA/RVAOutRun/RVAOutRun:rlp/while/rva_out.Push() CSTEPS_FROM {{.. == 3}}

# Probe constraints
