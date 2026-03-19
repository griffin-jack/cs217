CU_MOD_OBJS =  \
objs/iZcvQ_d.o objs/w1QIf_d.o objs/qa2ez_d.o objs/hUDmy_d.o objs/Rdmaq_d.o  \
objs/dDNdA_d.o objs/y1jUq_d.o objs/jmrsW_d.o objs/sJrKt_d.o objs/DfCCR_d.o  \
objs/hrQY9_d.o objs/pxT65_d.o objs/ZyG8n_d.o objs/sD9ad_d.o objs/j1K3R_d.o  \
objs/Ct4uC_d.o objs/v71SV_d.o objs/HFkPf_d.o objs/Ejrtu_d.o objs/GdI28_d.o  \
objs/rAik1_d.o objs/W7xp7_d.o objs/W43I4_d.o objs/K1yb7_d.o objs/vWnIr_d.o  \
objs/reYIK_d.o objs/G9402_d.o objs/vvQKt_d.o objs/kPybZ_d.o objs/arfci_d.o  \
objs/t75Iy_d.o objs/nufJf_d.o objs/JKbYh_d.o objs/D6TMz_d.o objs/axsE2_d.o  \
objs/eny0H_d.o objs/FnRQb_d.o objs/D8gcj_d.o objs/ghBn0_d.o objs/H2EBc_d.o  \
objs/MsKwC_d.o objs/SGzzD_d.o objs/LLaKH_d.o objs/DqKak_d.o objs/pWVHr_d.o  \
amcQwB.o objs/amcQw_d.o objs/dDvPr_d.o objs/iVwwW_d.o objs/R42QI_d.o  \
objs/FsQnD_d.o objs/WVsfM_d.o objs/fV6YS_d.o objs/bNMwG_d.o objs/KfFbf_d.o  \
objs/EhGrC_d.o objs/rFSKF_d.o objs/wTIrB_d.o objs/mJYbq_d.o 

CU_MOD_C_OBJS =  \


$(CU_MOD_C_OBJS): %.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

CU_OBJS = $(CU_MOD_OBJS) $(CU_MOD_C_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

PRE_LDFLAGS += -Wl,--whole-archive
STRIPFLAGS += -Wl,--no-whole-archive
