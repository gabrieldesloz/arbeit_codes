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
static const char *ng0 = "D:/Projetos/VHDL/L8/FPGA_Board/FPGA_V00_73/WRAPPER_EJET.vhd";
extern char *IEEE_P_2592010699;



static void work_a_0031572365_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(191, ng0);

LAB3:    t1 = (t0 + 6792U);
    t2 = *((char **)t1);
    t1 = (t0 + 9896);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 6U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 9800);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_0031572365_3212880686_p_1(char *t0)
{
    char t12[16];
    char t14[16];
    char t19[16];
    char t28[16];
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    unsigned int t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t13;
    char *t15;
    char *t16;
    int t17;
    unsigned int t18;
    char *t20;
    int t21;
    char *t22;
    int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned char t26;
    char *t27;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    unsigned char t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    char *t38;

LAB0:    xsi_set_current_line(193, ng0);

LAB3:    t1 = (t0 + 7912U);
    t2 = *((char **)t1);
    t3 = (15 - 15);
    t4 = (t3 * 1U);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t6 = (t0 + 8072U);
    t7 = *((char **)t6);
    t8 = (7 - 2);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t6 = (t7 + t10);
    t13 = ((IEEE_P_2592010699) + 4024);
    t15 = (t14 + 0U);
    t16 = (t15 + 0U);
    *((int *)t16) = 15;
    t16 = (t15 + 4U);
    *((int *)t16) = 3;
    t16 = (t15 + 8U);
    *((int *)t16) = -1;
    t17 = (3 - 15);
    t18 = (t17 * -1);
    t18 = (t18 + 1);
    t16 = (t15 + 12U);
    *((unsigned int *)t16) = t18;
    t16 = (t19 + 0U);
    t20 = (t16 + 0U);
    *((int *)t20) = 2;
    t20 = (t16 + 4U);
    *((int *)t20) = 1;
    t20 = (t16 + 8U);
    *((int *)t20) = -1;
    t21 = (1 - 2);
    t18 = (t21 * -1);
    t18 = (t18 + 1);
    t20 = (t16 + 12U);
    *((unsigned int *)t20) = t18;
    t11 = xsi_base_array_concat(t11, t12, t13, (char)97, t1, t14, (char)97, t6, t19, (char)101);
    t20 = (t0 + 7912U);
    t22 = *((char **)t20);
    t23 = (0 - 15);
    t18 = (t23 * -1);
    t24 = (1U * t18);
    t25 = (0 + t24);
    t20 = (t22 + t25);
    t26 = *((unsigned char *)t20);
    t29 = ((IEEE_P_2592010699) + 4024);
    t27 = xsi_base_array_concat(t27, t28, t29, (char)97, t11, t12, (char)99, t26, (char)101);
    t30 = (13U + 2U);
    t31 = (t30 + 1U);
    t32 = (16U != t31);
    if (t32 == 1)
        goto LAB5;

LAB6:    t33 = (t0 + 9960);
    t34 = (t33 + 56U);
    t35 = *((char **)t34);
    t36 = (t35 + 56U);
    t37 = *((char **)t36);
    memcpy(t37, t27, 16U);
    xsi_driver_first_trans_fast_port(t33);

LAB2:    t38 = (t0 + 9816);
    *((int *)t38) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(16U, t31, 0);
    goto LAB6;

}


extern void work_a_0031572365_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0031572365_3212880686_p_0,(void *)work_a_0031572365_3212880686_p_1};
	xsi_register_didat("work_a_0031572365_3212880686", "isim/TB_WRAPPER_EJET_isim_beh.exe.sim/work/a_0031572365_3212880686.didat");
	xsi_register_executes(pe);
}
