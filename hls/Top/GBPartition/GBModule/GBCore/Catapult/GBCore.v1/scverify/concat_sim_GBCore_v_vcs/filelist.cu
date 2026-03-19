CU_MOD_OBJS =  \
objs/k4svV_d.o objs/QTGUU_d.o objs/qa2ez_d.o objs/twdmw_d.o objs/hUbWW_d.o  \
objs/UkwbZ_d.o objs/TLtVI_d.o objs/qANTT_d.o objs/pEYbb_d.o objs/VQrLj_d.o  \
objs/Jbdmi_d.o objs/CYMgp_d.o objs/fnzrK_d.o objs/GdI28_d.o objs/AP9Cn_d.o  \
objs/afKNj_d.o objs/MS0rI_d.o objs/K1yb7_d.o objs/eZJ7L_d.o objs/r2tp9_d.o  \
objs/rnMJf_d.o objs/reYIK_d.o objs/jaL9z_d.o objs/y4Syk_d.o objs/J1PeJ_d.o  \
objs/gjf0U_d.o objs/H9Z7T_d.o objs/G4Ndq_d.o objs/U4Muw_d.o objs/gJyhD_d.o  \
objs/utxZA_d.o objs/EKDBS_d.o objs/Dmq1A_d.o objs/SGzzD_d.o objs/ivvkU_d.o  \
objs/Eqhzx_d.o objs/iKtzy_d.o amcQwB.o objs/amcQw_d.o objs/T25IP_d.o  \
objs/q4NAQ_d.o objs/EhGrC_d.o 

CU_MOD_C_OBJS =  \


$(CU_MOD_C_OBJS): %.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

CU_OBJS = $(CU_MOD_OBJS) $(CU_MOD_C_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

PRE_LDFLAGS += -Wl,--whole-archive
STRIPFLAGS += -Wl,--no-whole-archive
