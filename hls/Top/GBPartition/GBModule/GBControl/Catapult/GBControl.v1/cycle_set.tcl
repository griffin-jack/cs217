
# Loop constraints
directive set /GBControl/GBControlRun/GBControlRun:rlp CSTEPS_FROM {{. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while CSTEPS_FROM {{. == 4} {.. == 1}}

# IO operation constraints

# Sync operation constraints

# Real operation constraints
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator-<49,true>:acc CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.GetTimestepIndexGBControl:switch-lp:mux1h CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.GetTimestepIndexGBControl:switch-lp:and CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::RunFSM:switch-lp:mux CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::RunFSM:switch-lp:mux#1 CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/large_req.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/large_rsp.Pop() CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/data_out.Push() CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/pe_start.Push() CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/data_in.PopNB() CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator-<49,true>#1:acc CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.GetTimestepIndexGBControl#1:switch-lp:mux1h CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.GetTimestepIndexGBControl#1:switch-lp:and CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/large_req.Push()#1 CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator-<49,true>#2:acc CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.GetTimestepIndexGBControl#2:switch-lp:mux1h CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.GetTimestepIndexGBControl#2:switch-lp:and CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/large_req.Push()#2 CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/large_rsp.Pop()#1 CSTEPS_FROM {{.. == 1}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/data_out.Push()#1 CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::RunFSM:switch-lp:GBControl::RunFSM:switch-lp:mux#7 CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/rva_in.PopNB() CSTEPS_FROM {{.. == 2}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigRead:gbcontrol_config.ConfigRead:and#1 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigRead:gbcontrol_config.ConfigRead:and#2 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux#1 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigRead:gbcontrol_config.ConfigRead:and#4 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux#3 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigRead:gbcontrol_config.ConfigRead:and#5 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux#4 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigRead:gbcontrol_config.ConfigRead:and#6 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux#5 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigRead:gbcontrol_config.ConfigRead:and#7 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux#6 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigRead:gbcontrol_config.ConfigRead:and#8 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux#7 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigWrite:mux CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiWrite:mux CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:if:mux CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux#2 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:if:mux#11 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiRead:mux#8 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:if:mux#17 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#17 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#16 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#14 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#13 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#11 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#10 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#12 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#15 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#18 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/rva_out.Push() CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/start.PopNB() CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#19 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#8 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#9 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.ConfigWrite:mux#2 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxiWrite:mux#2 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:if:mux#2 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#2 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#10 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#11 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#12 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#13 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#14 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#15 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#16 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#18 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#19 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#20 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#20 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#21 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#22 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#23 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#24 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#25 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::DecodeAxi:mux#21 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/while:mux#26 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::UpdateFSM:switch-lp:GBControl::UpdateFSM:switch-lp:and#7 CSTEPS_FROM {{.. == 4}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::UpdateFSM:switch-lp:GBControl::UpdateFSM:switch-lp:and#8 CSTEPS_FROM {{.. == 4}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator-<8,false>:acc CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator+=<8,false>:acc CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.UpdateVectorCounter:gbcontrol_config.UpdateVectorCounter:and CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/pe_done.PopNB() CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator-<8,false>#1:acc CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator+=<8,false>#1:acc CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.UpdateVectorCounter#1:gbcontrol_config.UpdateVectorCounter#1:and CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator-<16,false>:acc CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/done.Push() CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/operator+=<16,false>:acc CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/gbcontrol_config.UpdateTimestepCounter:gbcontrol_config.UpdateTimestepCounter:and#1 CSTEPS_FROM {{.. == 3}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::UpdateFSM:switch-lp:mux1h#3 CSTEPS_FROM {{.. == 4}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::UpdateFSM:switch-lp:mux1h#4 CSTEPS_FROM {{.. == 4}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::UpdateFSM:switch-lp:mux1h#5 CSTEPS_FROM {{.. == 4}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::UpdateFSM:switch-lp:and CSTEPS_FROM {{.. == 4}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::UpdateFSM:switch-lp:or#2 CSTEPS_FROM {{.. == 4}}
directive set /GBControl/GBControlRun/GBControlRun:rlp/while/GBControl::UpdateFSM:switch-lp:mux1h#6 CSTEPS_FROM {{.. == 4}}

# Probe constraints
