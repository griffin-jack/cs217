CU_MOD_OBJS =  \
objs/iZcvQ_d.o objs/pvbZf_d.o objs/Irctx_d.o objs/NmrGz_d.o objs/w1QIf_d.o  \
objs/qa2ez_d.o objs/hUDmy_d.o objs/qGE6Q_d.o objs/y1jUq_d.o objs/jmrsW_d.o  \
objs/JjigC_d.o objs/NuTmk_d.o objs/mRd2z_d.o objs/sJrKt_d.o objs/kWcQw_d.o  \
objs/m7VqJ_d.o objs/DfCCR_d.o objs/hrQY9_d.o objs/KapMW_d.o objs/T4Ucj_d.o  \
objs/fLk4v_d.o objs/Fcimv_d.o objs/v71SV_d.o objs/QchQr_d.o objs/Za5Lv_d.o  \
objs/Ejrtu_d.o objs/GdI28_d.o objs/VW20m_d.o objs/W7xp7_d.o objs/NpKvt_d.o  \
objs/nRgSA_d.o objs/Jtfim_d.o objs/K1yb7_d.o objs/KF5Rs_d.o objs/aZJLD_d.o  \
objs/reYIK_d.o objs/GA73D_d.o objs/xq5L7_d.o objs/i23Zw_d.o objs/UEQux_d.o  \
objs/YC6w1_d.o objs/nYdyI_d.o objs/nufJf_d.o objs/tSMUb_d.o objs/D6TMz_d.o  \
objs/eny0H_d.o objs/FnRQb_d.o objs/fpRib_d.o objs/IgDPt_d.o objs/TFFKF_d.o  \
objs/MsKwC_d.o objs/SGzzD_d.o objs/LLaKH_d.o objs/Fec3a_d.o objs/EAmqW_d.o  \
objs/hpw25_d.o objs/bcgs4_d.o objs/DqKak_d.o amcQwB.o objs/amcQw_d.o  \
objs/YH0kJ_d.o objs/QDh6K_d.o objs/R42QI_d.o objs/ky4An_d.o objs/VvfCC_d.o  \
objs/z4Pe4_d.o objs/WndHV_d.o objs/qPu64_d.o objs/RERtt_d.o objs/q0pMP_d.o  \
objs/bNMwG_d.o objs/LHTuk_d.o objs/uii1B_d.o objs/QCY8P_d.o objs/EhGrC_d.o  \
objs/rFSKF_d.o objs/LkgaE_d.o objs/UkqeP_d.o 

CU_MOD_C_OBJS =  \


$(CU_MOD_C_OBJS): %.o: %.c
	$(CC_CG) $(CFLAGS_CG) -c -o $@ $<
CU_UDP_OBJS = \


CU_LVL_OBJS = \
SIM_l.o 

CU_OBJS = $(CU_MOD_OBJS) $(CU_MOD_C_OBJS) $(CU_UDP_OBJS) $(CU_LVL_OBJS)

PRE_LDFLAGS += -Wl,--whole-archive
STRIPFLAGS += -Wl,--no-whole-archive
