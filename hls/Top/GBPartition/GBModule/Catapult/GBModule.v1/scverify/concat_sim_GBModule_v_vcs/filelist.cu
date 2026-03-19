CU_MOD_OBJS =  \
objs/qa2ez_d.o objs/jiMpH_d.o objs/Hidni_d.o objs/cZFur_d.o objs/hUDmy_d.o  \
objs/hYrju_d.o objs/y1jUq_d.o objs/jmrsW_d.o objs/qwZbI_d.o objs/CvxTV_d.o  \
objs/PdWts_d.o objs/gkQpH_d.o objs/D3idU_d.o objs/v71SV_d.o objs/M3k2R_d.o  \
objs/CYMgp_d.o objs/zLWxG_d.o objs/iLpFp_d.o objs/GdI28_d.o objs/yGaN5_d.o  \
objs/HYBZ8_d.o objs/W7xp7_d.o objs/K1yb7_d.o objs/rDPUH_d.o objs/kZ2fM_d.o  \
objs/a120c_d.o objs/RWbuk_d.o objs/r9wi0_d.o objs/rnMJf_d.o objs/MnLeY_d.o  \
objs/reYIK_d.o objs/Sz06J_d.o objs/D0ckG_d.o objs/gjf0U_d.o objs/z5RPU_d.o  \
objs/dKPhq_d.o objs/H9Z7T_d.o objs/SmI6n_d.o objs/G4Ndq_d.o objs/eny0H_d.o  \
objs/txR6b_d.o objs/WRC7C_d.o objs/MDTJr_d.o objs/IQ8wM_d.o objs/SGzzD_d.o  \
objs/W2rcS_d.o objs/smf7f_d.o objs/mysAf_d.o objs/iKtzy_d.o amcQwB.o  \
objs/amcQw_d.o objs/zyiRu_d.o objs/wvW6t_d.o objs/AsULx_d.o objs/sVfAb_d.o  \
objs/R42QI_d.o objs/uSkgc_d.o objs/jIc1p_d.o objs/JzZvd_d.o objs/RYxWA_d.o  \
objs/bNMwG_d.o objs/EhGrC_d.o objs/rsjaG_d.o objs/hhEeY_d.o objs/DChjj_d.o  \
objs/DuVSD_d.o 

CU_MOD_C_OBJS =  \


$(CU_MOD_C_OBJS): %.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

CU_OBJS = $(CU_MOD_OBJS) $(CU_MOD_C_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

PRE_LDFLAGS += -Wl,--whole-archive
STRIPFLAGS += -Wl,--no-whole-archive
