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
static const char *ng0 = "//SMKN33/S10067/Projetos/VHDL/L8/Ejector_Board/EJECTORS_V022/MANUAL_TEJET.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );
char *ieee_p_3620187407_sub_436279890_3965413181(char *, char *, char *, char *, int );
int ieee_p_3620187407_sub_514432868_3965413181(char *, char *, char *);
char *ieee_p_3620187407_sub_674691591_3965413181(char *, char *, char *, char *, unsigned char );


static void work_a_0350452580_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(53, ng0);

LAB3:    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5080);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4968);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_0350452580_3212880686_p_1(char *t0)
{
    char t13[16];
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    int t11;
    int t12;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    xsi_set_current_line(59, ng0);
    t1 = (t0 + 1152U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4984);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(60, ng0);
    t3 = (t0 + 1512U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(67, ng0);
    t1 = (t0 + 1032U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(70, ng0);
    t1 = (t0 + 2928U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t12 = (t11 + 1);
    t1 = (t0 + 2928U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t12;
    xsi_set_current_line(71, ng0);
    t1 = (t0 + 2928U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    if (t11 == 100)
        goto LAB12;

LAB17:    if (t11 == 1000)
        goto LAB13;

LAB18:    if (t11 == 2000)
        goto LAB14;

LAB19:    if (t11 == 3000)
        goto LAB15;

LAB20:
LAB16:
LAB11:
LAB9:    xsi_set_current_line(95, ng0);
    t1 = (t0 + 1992U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB27;

LAB29:    xsi_set_current_line(104, ng0);
    t1 = (t0 + 3048U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    xsi_set_current_line(105, ng0);
    t1 = (t0 + 9090);
    t4 = (t0 + 5400);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(106, ng0);
    t1 = (t0 + 2632U);
    t3 = *((char **)t1);
    t1 = (t0 + 5336);
    t4 = (t1 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t3, 5U);
    xsi_driver_first_trans_fast(t1);

LAB28:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(61, ng0);
    t3 = (t0 + 2928U);
    t7 = *((char **)t3);
    t3 = (t7 + 0);
    *((int *)t3) = 0;
    xsi_set_current_line(62, ng0);
    t1 = (t0 + 5144);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(63, ng0);
    t1 = (t0 + 5208);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(64, ng0);
    t1 = (t0 + 9080);
    t4 = (t0 + 5272);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    goto LAB6;

LAB8:    xsi_set_current_line(68, ng0);
    t1 = (t0 + 2928U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = 0;
    goto LAB9;

LAB12:    xsi_set_current_line(74, ng0);
    t1 = (t0 + 2152U);
    t4 = *((char **)t1);
    t2 = *((unsigned char *)t4);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB22;

LAB24:    xsi_set_current_line(77, ng0);
    t1 = (t0 + 9085);
    t4 = (t0 + 5272);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 5U);
    xsi_driver_first_trans_fast(t4);

LAB23:    goto LAB11;

LAB13:    xsi_set_current_line(80, ng0);
    t1 = (t0 + 5144);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    goto LAB11;

LAB14:    xsi_set_current_line(82, ng0);
    t1 = (t0 + 5144);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(83, ng0);
    t1 = (t0 + 5208);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    goto LAB11;

LAB15:    xsi_set_current_line(85, ng0);
    t1 = (t0 + 5144);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(86, ng0);
    t1 = (t0 + 5208);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    goto LAB11;

LAB21:;
LAB22:    xsi_set_current_line(75, ng0);
    t1 = (t0 + 2632U);
    t7 = *((char **)t1);
    t1 = (t0 + 8972U);
    t8 = ieee_p_3620187407_sub_436279890_3965413181(IEEE_P_3620187407, t13, t7, t1, 1);
    t9 = (t13 + 12U);
    t14 = *((unsigned int *)t9);
    t15 = (1U * t14);
    t6 = (5U != t15);
    if (t6 == 1)
        goto LAB25;

LAB26:    t10 = (t0 + 5272);
    t16 = (t10 + 56U);
    t17 = *((char **)t16);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t8, 5U);
    xsi_driver_first_trans_fast(t10);
    goto LAB23;

LAB25:    xsi_size_not_matching(5U, t15, 0);
    goto LAB26;

LAB27:    xsi_set_current_line(96, ng0);
    t1 = (t0 + 2472U);
    t4 = *((char **)t1);
    t1 = (t0 + 5336);
    t7 = (t1 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t4, 5U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(97, ng0);
    t1 = (t0 + 3048U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t2 = (t11 == 800);
    if (t2 != 0)
        goto LAB30;

LAB32:    xsi_set_current_line(101, ng0);
    t1 = (t0 + 3048U);
    t3 = *((char **)t1);
    t11 = *((int *)t3);
    t12 = (t11 + 1);
    t1 = (t0 + 3048U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t12;

LAB31:    goto LAB28;

LAB30:    xsi_set_current_line(98, ng0);
    t1 = (t0 + 2472U);
    t4 = *((char **)t1);
    t1 = (t0 + 8972U);
    t7 = ieee_p_3620187407_sub_674691591_3965413181(IEEE_P_3620187407, t13, t4, t1, (unsigned char)3);
    t8 = (t13 + 12U);
    t14 = *((unsigned int *)t8);
    t15 = (1U * t14);
    t5 = (5U != t15);
    if (t5 == 1)
        goto LAB33;

LAB34:    t9 = (t0 + 5400);
    t10 = (t9 + 56U);
    t16 = *((char **)t10);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t7, 5U);
    xsi_driver_first_trans_fast(t9);
    xsi_set_current_line(99, ng0);
    t1 = (t0 + 3048U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB31;

LAB33:    xsi_size_not_matching(5U, t15, 0);
    goto LAB34;

}

static void work_a_0350452580_3212880686_p_2(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    int t15;
    int t16;
    int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;

LAB0:    xsi_set_current_line(115, ng0);
    t1 = (t0 + 1312U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 5000);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(116, ng0);
    t3 = (t0 + 1512U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(120, ng0);
    t1 = (t0 + 1992U);
    t3 = *((char **)t1);
    t5 = *((unsigned char *)t3);
    t6 = (t5 == (unsigned char)3);
    if (t6 == 1)
        goto LAB11;

LAB12:    t1 = (t0 + 2152U);
    t4 = *((char **)t1);
    t13 = *((unsigned char *)t4);
    t14 = (t13 == (unsigned char)3);
    t2 = t14;

LAB13:    if (t2 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(159, ng0);
    t1 = (t0 + 9255);
    t4 = (t0 + 5464);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 32U);
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(160, ng0);
    t1 = (t0 + 3168U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;

LAB9:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(117, ng0);
    t3 = (t0 + 9095);
    t8 = (t0 + 5464);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t3, 32U);
    xsi_driver_first_trans_fast_port(t8);
    xsi_set_current_line(118, ng0);
    t1 = (t0 + 3168U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB6;

LAB8:    xsi_set_current_line(125, ng0);
    t1 = (t0 + 3168U);
    t7 = *((char **)t1);
    t15 = *((int *)t7);
    t16 = (t15 + 1);
    t1 = (t0 + 3168U);
    t8 = *((char **)t1);
    t1 = (t8 + 0);
    *((int *)t1) = t16;
    xsi_set_current_line(126, ng0);
    t1 = (t0 + 3168U);
    t3 = *((char **)t1);
    t15 = *((int *)t3);
    if (t15 == 2)
        goto LAB15;

LAB25:    if (t15 == 500)
        goto LAB16;

LAB26:    if (t15 == 600)
        goto LAB17;

LAB27:    if (t15 == 742)
        goto LAB18;

LAB28:    if (t15 == 884)
        goto LAB19;

LAB29:    if (t15 == 1026)
        goto LAB20;

LAB30:    if (t15 == 1168)
        goto LAB21;

LAB31:    if (t15 == 1310)
        goto LAB22;

LAB32:    if (t15 == 8191)
        goto LAB23;

LAB33:
LAB24:
LAB14:    goto LAB9;

LAB11:    t2 = (unsigned char)1;
    goto LAB13;

LAB15:    xsi_set_current_line(128, ng0);
    t1 = (t0 + 2312U);
    t4 = *((char **)t1);
    t1 = (t0 + 8972U);
    t16 = ieee_p_3620187407_sub_514432868_3965413181(IEEE_P_3620187407, t4, t1);
    t17 = (t16 - 31);
    t18 = (t17 * -1);
    t19 = (1 * t18);
    t20 = (0U + t19);
    t7 = (t0 + 5464);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_delta(t7, t20, 1, 0LL);
    goto LAB14;

LAB16:    xsi_set_current_line(130, ng0);
    t1 = (t0 + 9127);
    t4 = (t0 + 5464);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 32U);
    xsi_driver_first_trans_fast_port(t4);
    goto LAB14;

LAB17:    xsi_set_current_line(132, ng0);
    t1 = (t0 + 2312U);
    t3 = *((char **)t1);
    t1 = (t0 + 8972U);
    t15 = ieee_p_3620187407_sub_514432868_3965413181(IEEE_P_3620187407, t3, t1);
    t16 = (t15 - 31);
    t18 = (t16 * -1);
    t19 = (1 * t18);
    t20 = (0U + t19);
    t4 = (t0 + 5464);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_delta(t4, t20, 1, 0LL);
    goto LAB14;

LAB18:    xsi_set_current_line(134, ng0);
    t1 = (t0 + 9159);
    t4 = (t0 + 5464);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 32U);
    xsi_driver_first_trans_fast_port(t4);
    goto LAB14;

LAB19:    xsi_set_current_line(136, ng0);
    t1 = (t0 + 2312U);
    t3 = *((char **)t1);
    t1 = (t0 + 8972U);
    t15 = ieee_p_3620187407_sub_514432868_3965413181(IEEE_P_3620187407, t3, t1);
    t16 = (t15 - 31);
    t18 = (t16 * -1);
    t19 = (1 * t18);
    t20 = (0U + t19);
    t4 = (t0 + 5464);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_delta(t4, t20, 1, 0LL);
    goto LAB14;

LAB20:    xsi_set_current_line(138, ng0);
    t1 = (t0 + 9191);
    t4 = (t0 + 5464);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 32U);
    xsi_driver_first_trans_fast_port(t4);
    goto LAB14;

LAB21:    xsi_set_current_line(140, ng0);
    t1 = (t0 + 2312U);
    t3 = *((char **)t1);
    t1 = (t0 + 8972U);
    t15 = ieee_p_3620187407_sub_514432868_3965413181(IEEE_P_3620187407, t3, t1);
    t16 = (t15 - 31);
    t18 = (t16 * -1);
    t19 = (1 * t18);
    t20 = (0U + t19);
    t4 = (t0 + 5464);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_delta(t4, t20, 1, 0LL);
    goto LAB14;

LAB22:    xsi_set_current_line(142, ng0);
    t1 = (t0 + 9223);
    t4 = (t0 + 5464);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 32U);
    xsi_driver_first_trans_fast_port(t4);
    goto LAB14;

LAB23:    xsi_set_current_line(152, ng0);
    t1 = (t0 + 3168U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB14;

LAB34:;
}


extern void work_a_0350452580_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0350452580_3212880686_p_0,(void *)work_a_0350452580_3212880686_p_1,(void *)work_a_0350452580_3212880686_p_2};
	xsi_register_didat("work_a_0350452580_3212880686", "isim/TB_MANUAL_TEJET_isim_beh.exe.sim/work/a_0350452580_3212880686.didat");
	xsi_register_executes(pe);
}
