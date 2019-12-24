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

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_1242562249;
char *STD_TEXTIO;
char *IEEE_P_3499444699;
char *IEEE_P_3620187407;
char *IEEE_P_3564397177;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    ieee_p_1242562249_init();
    work_a_1137710856_3212880686_init();
    work_a_1079923209_3212880686_init();
    std_textio_init();
    xilinxcorelib_a_0444651080_3212880686_init();
    work_a_0424870495_2243392631_init();
    xilinxcorelib_a_3876434376_3212880686_init();
    work_a_3786477155_2174193164_init();
    work_a_3555750065_3212880686_init();
    work_a_0429953353_3212880686_init();
    work_a_4064905707_3212880686_init();
    work_a_0031572365_3212880686_init();
    work_a_3497438131_3212880686_init();
    ieee_p_3564397177_init();
    xilinxcorelib_a_4178852058_2959432447_init();
    xilinxcorelib_a_2264554271_1709443946_init();
    xilinxcorelib_a_1475005910_0543512595_init();
    xilinxcorelib_a_3486675826_3212880686_init();
    work_a_1007132421_1412886299_init();
    work_a_1460662316_3212880686_init();
    work_a_2476274569_3212880686_init();
    work_a_2671833429_2372691052_init();


    xsi_register_tops("work_a_2671833429_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3564397177 = xsi_get_engine_memory("ieee_p_3564397177");

    return xsi_run_simulation(argc, argv);

}
