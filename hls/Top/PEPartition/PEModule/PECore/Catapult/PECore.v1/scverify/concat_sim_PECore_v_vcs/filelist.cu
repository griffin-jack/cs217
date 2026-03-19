CU_MOD_OBJS =  \
objs/dUBgS_d.o objs/F4tBY_d.o objs/jmrsW_d.o objs/v71SV_d.o objs/CYMgp_d.o  \
objs/GdI28_d.o objs/W7xp7_d.o objs/reYIK_d.o objs/dC57g_d.o objs/gjf0U_d.o  \
objs/H9Z7T_d.o objs/G4Ndq_d.o objs/AkpJm_d.o amcQwB.o objs/amcQw_d.o  \
objs/R42QI_d.o objs/Ienc9_d.o objs/EhGrC_d.o objs/nKyj1_d.o 

CU_MOD_C_OBJS =  \


$(CU_MOD_C_OBJS): %.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

CU_OBJS = $(CU_MOD_OBJS) $(CU_MOD_C_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

PRE_LDFLAGS += -Wl,--whole-archive
STRIPFLAGS += -Wl,--no-whole-archive
