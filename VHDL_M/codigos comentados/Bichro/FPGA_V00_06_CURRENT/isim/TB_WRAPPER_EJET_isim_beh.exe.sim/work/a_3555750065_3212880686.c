/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xc3576ebc */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/Projetos/VHDL/L8/FPGA_Board/FPGA_V00_73/EJ_CLEAR_COUNT.vhd";
extern char *IEEE_P_3620187407;
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );
char *ieee_p_3620187407_sub_436351764_3965413181(char *, char *, char *, char *, int );


static void work_a_3555750065_3212880686_p_0(char *t0)
{
    char t5[16];
    char *t1;
    char *t2;
    char *t3;
    char *t6;
    char *t7;
    int t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;

LAB0:    xsi_set_current_line(48, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t1 = (t0 + 5864U);
    t3 = (t0 + 5927);
    t6 = (t5 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 16;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t8 = (16 - 0);
    t9 = (t8 * 1);
    t9 = (t9 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t9;
    t10 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t3, t5);
    if (t10 != 0)
        goto LAB3;

LAB4:
LAB5:    t15 = (t0 + 3656);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    *((unsigned char *)t19) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t15);

LAB2:    t20 = (t0 + 3560);
    *((int *)t20) = 1;

LAB1:    return;
LAB3:    t7 = (t0 + 3656);
    t11 = (t7 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t7);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_3555750065_3212880686_p_1(char *t0)
{
    char t35[16];
    char *t1;
    char *t2;
    char *t3;
    int t4;
    char *t5;
    char *t6;
    int t7;
    char *t8;
    char *t9;
    int t10;
    char *t11;
    char *t12;
    int t13;
    char *t14;
    char *t15;
    int t16;
    char *t17;
    int t19;
    char *t20;
    int t22;
    char *t23;
    int t25;
    char *t26;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    unsigned char t33;
    unsigned char t34;
    unsigned int t36;
    unsigned int t37;

LAB0:    xsi_set_current_line(53, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t1 = (t0 + 5944);
    t4 = xsi_mem_cmp(t1, t2, 3U);
    if (t4 == 1)
        goto LAB3;

LAB12:    t5 = (t0 + 5947);
    t7 = xsi_mem_cmp(t5, t2, 3U);
    if (t7 == 1)
        goto LAB4;

LAB13:    t8 = (t0 + 5950);
    t10 = xsi_mem_cmp(t8, t2, 3U);
    if (t10 == 1)
        goto LAB5;

LAB14:    t11 = (t0 + 5953);
    t13 = xsi_mem_cmp(t11, t2, 3U);
    if (t13 == 1)
        goto LAB6;

LAB15:    t14 = (t0 + 5956);
    t16 = xsi_mem_cmp(t14, t2, 3U);
    if (t16 == 1)
        goto LAB7;

LAB16:    t17 = (t0 + 5959);
    t19 = xsi_mem_cmp(t17, t2, 3U);
    if (t19 == 1)
        goto LAB8;

LAB17:    t20 = (t0 + 5962);
    t22 = xsi_mem_cmp(t20, t2, 3U);
    if (t22 == 1)
        goto LAB9;

LAB18:    t23 = (t0 + 5965);
    t25 = xsi_mem_cmp(t23, t2, 3U);
    if (t25 == 1)
        goto LAB10;

LAB19:
LAB11:    xsi_set_current_line(63, ng0);
    t1 = (t0 + 6104);
    t3 = (t0 + 3720);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 17U);
    xsi_driver_first_trans_fast(t3);

LAB2:    xsi_set_current_line(67, ng0);
    t1 = (t0 + 1352U);
    t2 = *((char **)t1);
    t33 = *((unsigned char *)t2);
    t34 = (t33 == (unsigned char)3);
    if (t34 != 0)
        goto LAB21;

LAB23:    t1 = (t0 + 1152U);
    t33 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t33 != 0)
        goto LAB24;

LAB25:
LAB22:    t1 = (t0 + 3576);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(55, ng0);
    t26 = (t0 + 5968);
    t28 = (t0 + 3720);
    t29 = (t28 + 56U);
    t30 = *((char **)t29);
    t31 = (t30 + 56U);
    t32 = *((char **)t31);
    memcpy(t32, t26, 17U);
    xsi_driver_first_trans_fast(t28);
    goto LAB2;

LAB4:    xsi_set_current_line(56, ng0);
    t1 = (t0 + 5985);
    t3 = (t0 + 3720);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 17U);
    xsi_driver_first_trans_fast(t3);
    goto LAB2;

LAB5:    xsi_set_current_line(57, ng0);
    t1 = (t0 + 6002);
    t3 = (t0 + 3720);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 17U);
    xsi_driver_first_trans_fast(t3);
    goto LAB2;

LAB6:    xsi_set_current_line(58, ng0);
    t1 = (t0 + 6019);
    t3 = (t0 + 3720);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 17U);
    xsi_driver_first_trans_fast(t3);
    goto LAB2;

LAB7:    xsi_set_current_line(59, ng0);
    t1 = (t0 + 6036);
    t3 = (t0 + 3720);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 17U);
    xsi_driver_first_trans_fast(t3);
    goto LAB2;

LAB8:    xsi_set_current_line(60, ng0);
    t1 = (t0 + 6053);
    t3 = (t0 + 3720);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 17U);
    xsi_driver_first_trans_fast(t3);
    goto LAB2;

LAB9:    xsi_set_current_line(61, ng0);
    t1 = (t0 + 6070);
    t3 = (t0 + 3720);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 17U);
    xsi_driver_first_trans_fast(t3);
    goto LAB2;

LAB10:    xsi_set_current_line(62, ng0);
    t1 = (t0 + 6087);
    t3 = (t0 + 3720);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 17U);
    xsi_driver_first_trans_fast(t3);
    goto LAB2;

LAB20:;
LAB21:    xsi_set_current_line(68, ng0);
    t1 = (t0 + 1672U);
    t3 = *((char **)t1);
    t1 = (t0 + 3784);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t3, 17U);
    xsi_driver_first_trans_fast(t1);
    goto LAB22;

LAB24:    xsi_set_current_line(70, ng0);
    t2 = (t0 + 1832U);
    t3 = *((char **)t2);
    t2 = (t0 + 5864U);
    t5 = (t0 + 6121);
    t8 = (t35 + 0U);
    t9 = (t8 + 0U);
    *((int *)t9) = 0;
    t9 = (t8 + 4U);
    *((int *)t9) = 16;
    t9 = (t8 + 8U);
    *((int *)t9) = 1;
    t4 = (16 - 0);
    t36 = (t4 * 1);
    t36 = (t36 + 1);
    t9 = (t8 + 12U);
    *((unsigned int *)t9) = t36;
    t34 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t3, t2, t5, t35);
    if (t34 != 0)
        goto LAB26;

LAB28:    xsi_set_current_line(73, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t1 = (t0 + 5864U);
    t3 = ieee_p_3620187407_sub_436351764_3965413181(IEEE_P_3620187407, t35, t2, t1, 1);
    t5 = (t35 + 12U);
    t36 = *((unsigned int *)t5);
    t37 = (1U * t36);
    t33 = (17U != t37);
    if (t33 == 1)
        goto LAB29;

LAB30:    t6 = (t0 + 3784);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    t11 = (t9 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t3, 17U);
    xsi_driver_first_trans_fast(t6);

LAB27:    goto LAB22;

LAB26:    xsi_set_current_line(71, ng0);
    t9 = (t0 + 1672U);
    t11 = *((char **)t9);
    t9 = (t0 + 3784);
    t12 = (t9 + 56U);
    t14 = *((char **)t12);
    t15 = (t14 + 56U);
    t17 = *((char **)t15);
    memcpy(t17, t11, 17U);
    xsi_driver_first_trans_fast(t9);
    goto LAB27;

LAB29:    xsi_size_not_matching(17U, t37, 0);
    goto LAB30;

}


extern void work_a_3555750065_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3555750065_3212880686_p_0,(void *)work_a_3555750065_3212880686_p_1};
	xsi_register_didat("work_a_3555750065_3212880686", "isim/TB_WRAPPER_EJET_isim_beh.exe.sim/work/a_3555750065_3212880686.didat");
	xsi_register_executes(pe);
}
