CU_MOD_OBJS =  \
objs/QTGUU_d.o objs/qa2ez_d.o objs/hUDmy_d.o objs/twdmw_d.o objs/y1jUq_d.o  \
objs/jmrsW_d.o objs/v71SV_d.o objs/CYMgp_d.o objs/rdFa5_d.o objs/GdI28_d.o  \
objs/W7xp7_d.o objs/K1yb7_d.o objs/eZJ7L_d.o objs/rnMJf_d.o objs/reYIK_d.o  \
objs/gjf0U_d.o objs/H9Z7T_d.o objs/G4Ndq_d.o objs/eny0H_d.o objs/AyU33_d.o  \
objs/SGzzD_d.o objs/D89LV_d.o objs/rZZKJ_d.o objs/iKtzy_d.o objs/hQubz_d.o  \
amcQwB.o objs/amcQw_d.o objs/R42QI_d.o objs/T25IP_d.o objs/bNMwG_d.o  \
objs/EhGrC_d.o objs/Skuhf_d.o 

CU_MOD_C_OBJS =  \


$(CU_MOD_C_OBJS): %.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

CU_OBJS = $(CU_MOD_OBJS) $(CU_MOD_C_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

PRE_LDFLAGS += -Wl,--whole-archive
STRIPFLAGS += -Wl,--no-whole-archive
