-- Copyright (C) 1991-2012 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 32-bit"
-- VERSION "Version 12.1 Build 177 11/07/2012 SJ Full Version"

-- DATE "02/24/2014 10:44:45"

-- 
-- Device: Altera EP4CE75F23C7 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	gate_nios_interface IS
    PORT (
	sysclk : IN std_logic;
	reset_n : IN std_logic;
	avs_chipselect : IN std_logic;
	avs_address : IN std_logic_vector(3 DOWNTO 0);
	avs_write : IN std_logic;
	avs_read : IN std_logic;
	avs_writedata : IN std_logic_vector(31 DOWNTO 0);
	avs_readdata : OUT std_logic_vector(31 DOWNTO 0);
	avs_waitrequest : OUT std_logic;
	coe_sysclk : IN std_logic;
	coe_gate_address : IN std_logic_vector(3 DOWNTO 0);
	coe_gate_write : IN std_logic;
	coe_gate_read : IN std_logic;
	coe_gate_writedata : IN std_logic_vector(31 DOWNTO 0);
	coe_gate_readdata : OUT std_logic_vector(31 DOWNTO 0);
	coe_gate_waitrequest : OUT std_logic
	);
END gate_nios_interface;

-- Design Ports Information
-- avs_readdata[0]	=>  Location: PIN_T4,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[1]	=>  Location: PIN_B15,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[2]	=>  Location: PIN_B14,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[3]	=>  Location: PIN_U2,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[4]	=>  Location: PIN_R5,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[5]	=>  Location: PIN_A15,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[6]	=>  Location: PIN_P4,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[7]	=>  Location: PIN_T5,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[8]	=>  Location: PIN_A14,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[9]	=>  Location: PIN_V4,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[10]	=>  Location: PIN_W2,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[11]	=>  Location: PIN_D13,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[12]	=>  Location: PIN_Y1,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[13]	=>  Location: PIN_Y2,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[14]	=>  Location: PIN_V3,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[15]	=>  Location: PIN_C13,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[16]	=>  Location: PIN_U1,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[17]	=>  Location: PIN_W1,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[18]	=>  Location: PIN_R4,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[19]	=>  Location: PIN_E12,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[20]	=>  Location: PIN_T3,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[21]	=>  Location: PIN_N6,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[22]	=>  Location: PIN_V2,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[23]	=>  Location: PIN_P5,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[24]	=>  Location: PIN_A13,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[25]	=>  Location: PIN_R3,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[26]	=>  Location: PIN_E14,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[27]	=>  Location: PIN_E11,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[28]	=>  Location: PIN_E13,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[29]	=>  Location: PIN_B13,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[30]	=>  Location: PIN_V1,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_readdata[31]	=>  Location: PIN_AA1,	 I/O Standard: 3.0-V PCI,	 Current Strength: Maximum Current
-- avs_waitrequest	=>  Location: PIN_P20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[0]	=>  Location: PIN_AB18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[1]	=>  Location: PIN_AB3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[2]	=>  Location: PIN_AB9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[3]	=>  Location: PIN_AA17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[4]	=>  Location: PIN_Y13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[5]	=>  Location: PIN_AB8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[6]	=>  Location: PIN_AA13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[7]	=>  Location: PIN_W7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[8]	=>  Location: PIN_AB14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[9]	=>  Location: PIN_AA6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[10]	=>  Location: PIN_W13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[11]	=>  Location: PIN_Y17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[12]	=>  Location: PIN_W17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[13]	=>  Location: PIN_W20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[14]	=>  Location: PIN_Y7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[15]	=>  Location: PIN_AA5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[16]	=>  Location: PIN_W8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[17]	=>  Location: PIN_AA9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[18]	=>  Location: PIN_AB10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[19]	=>  Location: PIN_AA18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[20]	=>  Location: PIN_AA14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[21]	=>  Location: PIN_AB16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[22]	=>  Location: PIN_U20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[23]	=>  Location: PIN_U10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[24]	=>  Location: PIN_V10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[25]	=>  Location: PIN_AB17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[26]	=>  Location: PIN_AA10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[27]	=>  Location: PIN_AA15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[28]	=>  Location: PIN_U19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[29]	=>  Location: PIN_AA4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[30]	=>  Location: PIN_AB15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_readdata[31]	=>  Location: PIN_AA16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_waitrequest	=>  Location: PIN_R20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sysclk	=>  Location: PIN_T2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_sysclk	=>  Location: PIN_G1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_address[0]	=>  Location: PIN_R22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_address[1]	=>  Location: PIN_R21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_address[1]	=>  Location: PIN_P22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_address[0]	=>  Location: PIN_R19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_address[2]	=>  Location: PIN_U21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_address[3]	=>  Location: PIN_N19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_address[3]	=>  Location: PIN_U22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_address[2]	=>  Location: PIN_L22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_read	=>  Location: PIN_N20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_write	=>  Location: PIN_P21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_chipselect	=>  Location: PIN_M22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_write	=>  Location: PIN_N21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset_n	=>  Location: PIN_T1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- coe_gate_read	=>  Location: PIN_R18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[0]	=>  Location: PIN_W15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[0]	=>  Location: PIN_AB7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[1]	=>  Location: PIN_AB4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[1]	=>  Location: PIN_AB5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[2]	=>  Location: PIN_V16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[2]	=>  Location: PIN_AA3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[3]	=>  Location: PIN_AA20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[3]	=>  Location: PIN_V8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[4]	=>  Location: PIN_Y15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[4]	=>  Location: PIN_Y10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[5]	=>  Location: PIN_AB13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[5]	=>  Location: PIN_U11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[6]	=>  Location: PIN_AB20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[6]	=>  Location: PIN_R14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[7]	=>  Location: PIN_Y14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[7]	=>  Location: PIN_W14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[8]	=>  Location: PIN_AA21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[8]	=>  Location: PIN_W19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[9]	=>  Location: PIN_AA7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[9]	=>  Location: PIN_AA8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[10]	=>  Location: PIN_U14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[10]	=>  Location: PIN_V13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[11]	=>  Location: PIN_T15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[11]	=>  Location: PIN_T16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[12]	=>  Location: PIN_AB6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[12]	=>  Location: PIN_Y6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[13]	=>  Location: PIN_R16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[13]	=>  Location: PIN_V12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[14]	=>  Location: PIN_U16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[14]	=>  Location: PIN_U17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[15]	=>  Location: PIN_U12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[15]	=>  Location: PIN_Y22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[16]	=>  Location: PIN_V14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[16]	=>  Location: PIN_AB19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[17]	=>  Location: PIN_V15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[17]	=>  Location: PIN_U9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[18]	=>  Location: PIN_N18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[18]	=>  Location: PIN_W6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[19]	=>  Location: PIN_Y8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[19]	=>  Location: PIN_Y21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[20]	=>  Location: PIN_W10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[20]	=>  Location: PIN_A12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[21]	=>  Location: PIN_V11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[21]	=>  Location: PIN_B12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[22]	=>  Location: PIN_V21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[22]	=>  Location: PIN_N22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[23]	=>  Location: PIN_M20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[23]	=>  Location: PIN_M21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[24]	=>  Location: PIN_U15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[24]	=>  Location: PIN_V9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[25]	=>  Location: PIN_M19,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[25]	=>  Location: PIN_G22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[26]	=>  Location: PIN_W21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[26]	=>  Location: PIN_G21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[27]	=>  Location: PIN_W22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[27]	=>  Location: PIN_M16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[28]	=>  Location: PIN_T17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[28]	=>  Location: PIN_V22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[29]	=>  Location: PIN_T18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[29]	=>  Location: PIN_R17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[30]	=>  Location: PIN_T20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[30]	=>  Location: PIN_T19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- avs_writedata[31]	=>  Location: PIN_AA11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- coe_gate_writedata[31]	=>  Location: PIN_AA19,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF gate_nios_interface IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_sysclk : std_logic;
SIGNAL ww_reset_n : std_logic;
SIGNAL ww_avs_chipselect : std_logic;
SIGNAL ww_avs_address : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_avs_write : std_logic;
SIGNAL ww_avs_read : std_logic;
SIGNAL ww_avs_writedata : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_avs_readdata : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_avs_waitrequest : std_logic;
SIGNAL ww_coe_sysclk : std_logic;
SIGNAL ww_coe_gate_address : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_coe_gate_write : std_logic;
SIGNAL ww_coe_gate_read : std_logic;
SIGNAL ww_coe_gate_writedata : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_coe_gate_readdata : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_coe_gate_waitrequest : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAIN_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAIN_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTAADDR_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBADDR_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAIN_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAIN_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTAADDR_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBADDR_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \sysclk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \reset_n~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \coe_sysclk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \avs_read~input_o\ : std_logic;
SIGNAL \coe_gate_read~input_o\ : std_logic;
SIGNAL \avs_readdata[0]~output_o\ : std_logic;
SIGNAL \avs_readdata[1]~output_o\ : std_logic;
SIGNAL \avs_readdata[2]~output_o\ : std_logic;
SIGNAL \avs_readdata[3]~output_o\ : std_logic;
SIGNAL \avs_readdata[4]~output_o\ : std_logic;
SIGNAL \avs_readdata[5]~output_o\ : std_logic;
SIGNAL \avs_readdata[6]~output_o\ : std_logic;
SIGNAL \avs_readdata[7]~output_o\ : std_logic;
SIGNAL \avs_readdata[8]~output_o\ : std_logic;
SIGNAL \avs_readdata[9]~output_o\ : std_logic;
SIGNAL \avs_readdata[10]~output_o\ : std_logic;
SIGNAL \avs_readdata[11]~output_o\ : std_logic;
SIGNAL \avs_readdata[12]~output_o\ : std_logic;
SIGNAL \avs_readdata[13]~output_o\ : std_logic;
SIGNAL \avs_readdata[14]~output_o\ : std_logic;
SIGNAL \avs_readdata[15]~output_o\ : std_logic;
SIGNAL \avs_readdata[16]~output_o\ : std_logic;
SIGNAL \avs_readdata[17]~output_o\ : std_logic;
SIGNAL \avs_readdata[18]~output_o\ : std_logic;
SIGNAL \avs_readdata[19]~output_o\ : std_logic;
SIGNAL \avs_readdata[20]~output_o\ : std_logic;
SIGNAL \avs_readdata[21]~output_o\ : std_logic;
SIGNAL \avs_readdata[22]~output_o\ : std_logic;
SIGNAL \avs_readdata[23]~output_o\ : std_logic;
SIGNAL \avs_readdata[24]~output_o\ : std_logic;
SIGNAL \avs_readdata[25]~output_o\ : std_logic;
SIGNAL \avs_readdata[26]~output_o\ : std_logic;
SIGNAL \avs_readdata[27]~output_o\ : std_logic;
SIGNAL \avs_readdata[28]~output_o\ : std_logic;
SIGNAL \avs_readdata[29]~output_o\ : std_logic;
SIGNAL \avs_readdata[30]~output_o\ : std_logic;
SIGNAL \avs_readdata[31]~output_o\ : std_logic;
SIGNAL \avs_waitrequest~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[0]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[1]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[2]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[3]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[4]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[5]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[6]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[7]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[8]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[9]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[10]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[11]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[12]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[13]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[14]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[15]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[16]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[17]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[18]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[19]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[20]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[21]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[22]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[23]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[24]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[25]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[26]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[27]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[28]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[29]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[30]~output_o\ : std_logic;
SIGNAL \coe_gate_readdata[31]~output_o\ : std_logic;
SIGNAL \coe_gate_waitrequest~output_o\ : std_logic;
SIGNAL \avs_chipselect~input_o\ : std_logic;
SIGNAL \avs_write~input_o\ : std_logic;
SIGNAL \we_a_next~0_combout\ : std_logic;
SIGNAL \we_a_reg~feeder_combout\ : std_logic;
SIGNAL \reset_n~input_o\ : std_logic;
SIGNAL \reset_n~inputclkctrl_outclk\ : std_logic;
SIGNAL \we_a_reg~q\ : std_logic;
SIGNAL \coe_gate_write~input_o\ : std_logic;
SIGNAL \we_b_reg~feeder_combout\ : std_logic;
SIGNAL \we_b_reg~q\ : std_logic;
SIGNAL \sysclk~input_o\ : std_logic;
SIGNAL \sysclk~inputclkctrl_outclk\ : std_logic;
SIGNAL \coe_sysclk~input_o\ : std_logic;
SIGNAL \coe_sysclk~inputclkctrl_outclk\ : std_logic;
SIGNAL \avs_writedata[0]~input_o\ : std_logic;
SIGNAL \avs_address[0]~input_o\ : std_logic;
SIGNAL \avs_address[2]~input_o\ : std_logic;
SIGNAL \avs_address[3]~input_o\ : std_logic;
SIGNAL \coe_gate_address[2]~input_o\ : std_logic;
SIGNAL \coe_gate_waitrequest_next~1_combout\ : std_logic;
SIGNAL \avs_address[1]~input_o\ : std_logic;
SIGNAL \coe_gate_address[1]~input_o\ : std_logic;
SIGNAL \coe_gate_address[0]~input_o\ : std_logic;
SIGNAL \coe_gate_waitrequest_next~0_combout\ : std_logic;
SIGNAL \coe_gate_waitrequest_next~2_combout\ : std_logic;
SIGNAL \avs_waitrequest_next~0_combout\ : std_logic;
SIGNAL \avs_address_reg[1]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[0]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[0]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_waitrequest_next~3_combout\ : std_logic;
SIGNAL \coe_gate_address_reg[1]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_address_reg[2]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_address[3]~input_o\ : std_logic;
SIGNAL \coe_gate_address_reg[3]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[1]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[1]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[2]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[2]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[3]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[3]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[4]~input_o\ : std_logic;
SIGNAL \avs_writedata[5]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[5]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[6]~input_o\ : std_logic;
SIGNAL \avs_writedata[7]~input_o\ : std_logic;
SIGNAL \avs_writedata[8]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[8]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[9]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[9]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[10]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[10]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[11]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[11]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[12]~input_o\ : std_logic;
SIGNAL \avs_writedata[13]~input_o\ : std_logic;
SIGNAL \avs_writedata[14]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[14]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[15]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[15]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[16]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[16]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[17]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[1]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[2]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[2]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[3]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[4]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[4]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[5]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[5]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[6]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[6]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[7]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[8]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[8]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[9]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[9]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[10]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[10]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[11]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[12]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[12]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[13]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[13]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[14]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[14]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[15]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[15]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[16]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[16]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[17]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[17]~feeder_combout\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0~portadataout\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a1\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a2\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a3\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a4\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a5\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a6\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a7\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a8\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a9\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a10\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a11\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a12\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a13\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a14\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a15\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a16\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a17\ : std_logic;
SIGNAL \avs_writedata[18]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[18]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[18]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[18]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[19]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[19]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[20]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[20]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[21]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[21]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[22]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[22]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[23]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[23]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[24]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[24]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[25]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[25]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[26]~input_o\ : std_logic;
SIGNAL \avs_writedata[27]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[27]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[28]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[28]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[29]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[29]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[30]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[30]~feeder_combout\ : std_logic;
SIGNAL \avs_writedata[31]~input_o\ : std_logic;
SIGNAL \avs_writedata_reg[31]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[19]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[19]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[20]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[21]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[21]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[22]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[22]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[23]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[23]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[24]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[24]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[25]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[25]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[26]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[27]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[28]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[28]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[29]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[29]~feeder_combout\ : std_logic;
SIGNAL \coe_gate_writedata[30]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata[31]~input_o\ : std_logic;
SIGNAL \coe_gate_writedata_reg[31]~feeder_combout\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18~portadataout\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a19\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a20\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a21\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a22\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a23\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a24\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a25\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a26\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a27\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a28\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a29\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a30\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a31\ : std_logic;
SIGNAL \avs_waitrequest_next~0_wirecell_combout\ : std_logic;
SIGNAL \avs_waitrequest_reg~q\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a1~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a2~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a3~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a4~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a5~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a6~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a7~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a8~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a9~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a10~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a11~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a12~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a13~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a14~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a15~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a16~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a17~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a19~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a20~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a21~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a22~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a23~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a24~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a25~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a26~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a27~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a28~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a29~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a30~PORTBDATAOUT0\ : std_logic;
SIGNAL \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a31~PORTBDATAOUT0\ : std_logic;
SIGNAL \coe_gate_waitrequest_next~3_wirecell_combout\ : std_logic;
SIGNAL \coe_gate_waitrequest_reg~q\ : std_logic;
SIGNAL coe_gate_writedata_reg : std_logic_vector(31 DOWNTO 0);
SIGNAL coe_gate_address_reg : std_logic_vector(3 DOWNTO 0);
SIGNAL avs_writedata_reg : std_logic_vector(31 DOWNTO 0);
SIGNAL avs_address_reg : std_logic_vector(3 DOWNTO 0);

BEGIN

ww_sysclk <= sysclk;
ww_reset_n <= reset_n;
ww_avs_chipselect <= avs_chipselect;
ww_avs_address <= avs_address;
ww_avs_write <= avs_write;
ww_avs_read <= avs_read;
ww_avs_writedata <= avs_writedata;
avs_readdata <= ww_avs_readdata;
avs_waitrequest <= ww_avs_waitrequest;
ww_coe_sysclk <= coe_sysclk;
ww_coe_gate_address <= coe_gate_address;
ww_coe_gate_write <= coe_gate_write;
ww_coe_gate_read <= coe_gate_read;
ww_coe_gate_writedata <= coe_gate_writedata;
coe_gate_readdata <= ww_coe_gate_readdata;
coe_gate_waitrequest <= ww_coe_gate_waitrequest;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAIN_bus\ <= (avs_writedata_reg(17) & avs_writedata_reg(16) & avs_writedata_reg(15) & avs_writedata_reg(14) & avs_writedata_reg(13) & avs_writedata_reg(12) & 
avs_writedata_reg(11) & avs_writedata_reg(10) & avs_writedata_reg(9) & avs_writedata_reg(8) & avs_writedata_reg(7) & avs_writedata_reg(6) & avs_writedata_reg(5) & avs_writedata_reg(4) & avs_writedata_reg(3) & avs_writedata_reg(2) & 
avs_writedata_reg(1) & avs_writedata_reg(0));

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAIN_bus\ <= (coe_gate_writedata_reg(17) & coe_gate_writedata_reg(16) & coe_gate_writedata_reg(15) & coe_gate_writedata_reg(14) & coe_gate_writedata_reg(13) & 
coe_gate_writedata_reg(12) & coe_gate_writedata_reg(11) & coe_gate_writedata_reg(10) & coe_gate_writedata_reg(9) & coe_gate_writedata_reg(8) & coe_gate_writedata_reg(7) & coe_gate_writedata_reg(6) & coe_gate_writedata_reg(5) & 
coe_gate_writedata_reg(4) & coe_gate_writedata_reg(3) & coe_gate_writedata_reg(2) & coe_gate_writedata_reg(1) & coe_gate_writedata_reg(0));

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTAADDR_bus\ <= (avs_address_reg(3) & avs_address_reg(2) & avs_address_reg(1) & avs_address_reg(0));

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBADDR_bus\ <= (coe_gate_address_reg(3) & coe_gate_address_reg(2) & coe_gate_address_reg(1) & coe_gate_address_reg(0));

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0~portadataout\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(0);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a1\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(1);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a2\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(2);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a3\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(3);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a4\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(4);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a5\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(5);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a6\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(6);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a7\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(7);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a8\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(8);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a9\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(9);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a10\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(10);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a11\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(11);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a12\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(12);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a13\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(13);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a14\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(14);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a15\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(15);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a16\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(16);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a17\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\(17);

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(0);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a1~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(1);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a2~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(2);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a3~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(3);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a4~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(4);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a5~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(5);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a6~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(6);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a7~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(7);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a8~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(8);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a9~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(9);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a10~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(10);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a11~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(11);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a12~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(12);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a13~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(13);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a14~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(14);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a15~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(15);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a16~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(16);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a17~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(17);

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAIN_bus\ <= (gnd & gnd & gnd & gnd & avs_writedata_reg(31) & avs_writedata_reg(30) & avs_writedata_reg(29) & avs_writedata_reg(28) & avs_writedata_reg(27) & 
avs_writedata_reg(26) & avs_writedata_reg(25) & avs_writedata_reg(24) & avs_writedata_reg(23) & avs_writedata_reg(22) & avs_writedata_reg(21) & avs_writedata_reg(20) & avs_writedata_reg(19) & avs_writedata_reg(18));

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAIN_bus\ <= (gnd & gnd & gnd & gnd & coe_gate_writedata_reg(31) & coe_gate_writedata_reg(30) & coe_gate_writedata_reg(29) & coe_gate_writedata_reg(28) & 
coe_gate_writedata_reg(27) & coe_gate_writedata_reg(26) & coe_gate_writedata_reg(25) & coe_gate_writedata_reg(24) & coe_gate_writedata_reg(23) & coe_gate_writedata_reg(22) & coe_gate_writedata_reg(21) & coe_gate_writedata_reg(20) & 
coe_gate_writedata_reg(19) & coe_gate_writedata_reg(18));

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTAADDR_bus\ <= (avs_address_reg(3) & avs_address_reg(2) & avs_address_reg(1) & avs_address_reg(0));

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBADDR_bus\ <= (coe_gate_address_reg(3) & coe_gate_address_reg(2) & coe_gate_address_reg(1) & coe_gate_address_reg(0));

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18~portadataout\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(0);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a19\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(1);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a20\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(2);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a21\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(3);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a22\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(4);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a23\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(5);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a24\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(6);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a25\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(7);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a26\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(8);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a27\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(9);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a28\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(10);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a29\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(11);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a30\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(12);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a31\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\(13);

\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(0);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a19~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(1);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a20~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(2);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a21~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(3);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a22~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(4);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a23~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(5);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a24~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(6);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a25~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(7);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a26~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(8);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a27~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(9);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a28~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(10);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a29~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(11);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a30~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(12);
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a31~PORTBDATAOUT0\ <= \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\(13);

\sysclk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \sysclk~input_o\);

\reset_n~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \reset_n~input_o\);

\coe_sysclk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \coe_sysclk~input_o\);

-- Location: IOIBUF_X94_Y26_N22
\avs_read~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_read,
	o => \avs_read~input_o\);

-- Location: IOIBUF_X94_Y18_N1
\coe_gate_read~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_read,
	o => \coe_gate_read~input_o\);

-- Location: IOOBUF_X0_Y5_N16
\avs_readdata[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0~portadataout\,
	devoe => ww_devoe,
	o => \avs_readdata[0]~output_o\);

-- Location: IOOBUF_X60_Y62_N9
\avs_readdata[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a1\,
	devoe => ww_devoe,
	o => \avs_readdata[1]~output_o\);

-- Location: IOOBUF_X53_Y62_N23
\avs_readdata[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a2\,
	devoe => ww_devoe,
	o => \avs_readdata[2]~output_o\);

-- Location: IOOBUF_X0_Y20_N2
\avs_readdata[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a3\,
	devoe => ww_devoe,
	o => \avs_readdata[3]~output_o\);

-- Location: IOOBUF_X0_Y7_N2
\avs_readdata[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a4\,
	devoe => ww_devoe,
	o => \avs_readdata[4]~output_o\);

-- Location: IOOBUF_X60_Y62_N2
\avs_readdata[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a5\,
	devoe => ww_devoe,
	o => \avs_readdata[5]~output_o\);

-- Location: IOOBUF_X0_Y21_N2
\avs_readdata[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a6\,
	devoe => ww_devoe,
	o => \avs_readdata[6]~output_o\);

-- Location: IOOBUF_X0_Y4_N16
\avs_readdata[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a7\,
	devoe => ww_devoe,
	o => \avs_readdata[7]~output_o\);

-- Location: IOOBUF_X53_Y62_N16
\avs_readdata[8]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a8\,
	devoe => ww_devoe,
	o => \avs_readdata[8]~output_o\);

-- Location: IOOBUF_X0_Y10_N2
\avs_readdata[9]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a9\,
	devoe => ww_devoe,
	o => \avs_readdata[9]~output_o\);

-- Location: IOOBUF_X0_Y16_N9
\avs_readdata[10]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a10\,
	devoe => ww_devoe,
	o => \avs_readdata[10]~output_o\);

-- Location: IOOBUF_X60_Y62_N23
\avs_readdata[11]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a11\,
	devoe => ww_devoe,
	o => \avs_readdata[11]~output_o\);

-- Location: IOOBUF_X0_Y15_N16
\avs_readdata[12]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a12\,
	devoe => ww_devoe,
	o => \avs_readdata[12]~output_o\);

-- Location: IOOBUF_X0_Y16_N23
\avs_readdata[13]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a13\,
	devoe => ww_devoe,
	o => \avs_readdata[13]~output_o\);

-- Location: IOOBUF_X0_Y10_N9
\avs_readdata[14]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a14\,
	devoe => ww_devoe,
	o => \avs_readdata[14]~output_o\);

-- Location: IOOBUF_X60_Y62_N16
\avs_readdata[15]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a15\,
	devoe => ww_devoe,
	o => \avs_readdata[15]~output_o\);

-- Location: IOOBUF_X0_Y20_N9
\avs_readdata[16]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a16\,
	devoe => ww_devoe,
	o => \avs_readdata[16]~output_o\);

-- Location: IOOBUF_X0_Y16_N16
\avs_readdata[17]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a17\,
	devoe => ww_devoe,
	o => \avs_readdata[17]~output_o\);

-- Location: IOOBUF_X0_Y18_N23
\avs_readdata[18]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18~portadataout\,
	devoe => ww_devoe,
	o => \avs_readdata[18]~output_o\);

-- Location: IOOBUF_X49_Y62_N2
\avs_readdata[19]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a19\,
	devoe => ww_devoe,
	o => \avs_readdata[19]~output_o\);

-- Location: IOOBUF_X0_Y14_N9
\avs_readdata[20]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a20\,
	devoe => ww_devoe,
	o => \avs_readdata[20]~output_o\);

-- Location: IOOBUF_X0_Y18_N16
\avs_readdata[21]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a21\,
	devoe => ww_devoe,
	o => \avs_readdata[21]~output_o\);

-- Location: IOOBUF_X0_Y19_N2
\avs_readdata[22]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a22\,
	devoe => ww_devoe,
	o => \avs_readdata[22]~output_o\);

-- Location: IOOBUF_X0_Y19_N23
\avs_readdata[23]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a23\,
	devoe => ww_devoe,
	o => \avs_readdata[23]~output_o\);

-- Location: IOOBUF_X51_Y62_N2
\avs_readdata[24]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a24\,
	devoe => ww_devoe,
	o => \avs_readdata[24]~output_o\);

-- Location: IOOBUF_X0_Y17_N9
\avs_readdata[25]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a25\,
	devoe => ww_devoe,
	o => \avs_readdata[25]~output_o\);

-- Location: IOOBUF_X62_Y62_N16
\avs_readdata[26]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a26\,
	devoe => ww_devoe,
	o => \avs_readdata[26]~output_o\);

-- Location: IOOBUF_X49_Y62_N16
\avs_readdata[27]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a27\,
	devoe => ww_devoe,
	o => \avs_readdata[27]~output_o\);

-- Location: IOOBUF_X53_Y62_N9
\avs_readdata[28]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a28\,
	devoe => ww_devoe,
	o => \avs_readdata[28]~output_o\);

-- Location: IOOBUF_X51_Y62_N9
\avs_readdata[29]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a29\,
	devoe => ww_devoe,
	o => \avs_readdata[29]~output_o\);

-- Location: IOOBUF_X0_Y19_N16
\avs_readdata[30]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a30\,
	devoe => ww_devoe,
	o => \avs_readdata[30]~output_o\);

-- Location: IOOBUF_X0_Y11_N9
\avs_readdata[31]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a31\,
	devoe => ww_devoe,
	o => \avs_readdata[31]~output_o\);

-- Location: IOOBUF_X94_Y21_N2
\avs_waitrequest~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \avs_waitrequest_reg~q\,
	devoe => ww_devoe,
	o => \avs_waitrequest~output_o\);

-- Location: IOOBUF_X73_Y0_N23
\coe_gate_readdata[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[0]~output_o\);

-- Location: IOOBUF_X5_Y0_N2
\coe_gate_readdata[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a1~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[1]~output_o\);

-- Location: IOOBUF_X38_Y0_N2
\coe_gate_readdata[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a2~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[2]~output_o\);

-- Location: IOOBUF_X73_Y0_N16
\coe_gate_readdata[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a3~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[3]~output_o\);

-- Location: IOOBUF_X58_Y0_N16
\coe_gate_readdata[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a4~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[4]~output_o\);

-- Location: IOOBUF_X36_Y0_N2
\coe_gate_readdata[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a5~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[5]~output_o\);

-- Location: IOOBUF_X51_Y0_N9
\coe_gate_readdata[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a6~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[6]~output_o\);

-- Location: IOOBUF_X11_Y0_N9
\coe_gate_readdata[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a7~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[7]~output_o\);

-- Location: IOOBUF_X56_Y0_N23
\coe_gate_readdata[8]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a8~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[8]~output_o\);

-- Location: IOOBUF_X9_Y0_N2
\coe_gate_readdata[9]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a9~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[9]~output_o\);

-- Location: IOOBUF_X58_Y0_N23
\coe_gate_readdata[10]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a10~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[10]~output_o\);

-- Location: IOOBUF_X78_Y0_N2
\coe_gate_readdata[11]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a11~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[11]~output_o\);

-- Location: IOOBUF_X78_Y0_N9
\coe_gate_readdata[12]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a12~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[12]~output_o\);

-- Location: IOOBUF_X94_Y8_N23
\coe_gate_readdata[13]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a13~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[13]~output_o\);

-- Location: IOOBUF_X11_Y0_N2
\coe_gate_readdata[14]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a14~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[14]~output_o\);

-- Location: IOOBUF_X9_Y0_N9
\coe_gate_readdata[15]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a15~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[15]~output_o\);

-- Location: IOOBUF_X13_Y0_N9
\coe_gate_readdata[16]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a16~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[16]~output_o\);

-- Location: IOOBUF_X38_Y0_N9
\coe_gate_readdata[17]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a17~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[17]~output_o\);

-- Location: IOOBUF_X47_Y0_N2
\coe_gate_readdata[18]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[18]~output_o\);

-- Location: IOOBUF_X73_Y0_N2
\coe_gate_readdata[19]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a19~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[19]~output_o\);

-- Location: IOOBUF_X53_Y0_N2
\coe_gate_readdata[20]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a20~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[20]~output_o\);

-- Location: IOOBUF_X62_Y0_N16
\coe_gate_readdata[21]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a21~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[21]~output_o\);

-- Location: IOOBUF_X94_Y11_N16
\coe_gate_readdata[22]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a22~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[22]~output_o\);

-- Location: IOOBUF_X34_Y0_N2
\coe_gate_readdata[23]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a23~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[23]~output_o\);

-- Location: IOOBUF_X31_Y0_N9
\coe_gate_readdata[24]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a24~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[24]~output_o\);

-- Location: IOOBUF_X73_Y0_N9
\coe_gate_readdata[25]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a25~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[25]~output_o\);

-- Location: IOOBUF_X47_Y0_N9
\coe_gate_readdata[26]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a26~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[26]~output_o\);

-- Location: IOOBUF_X58_Y0_N9
\coe_gate_readdata[27]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a27~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[27]~output_o\);

-- Location: IOOBUF_X94_Y11_N9
\coe_gate_readdata[28]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a28~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[28]~output_o\);

-- Location: IOOBUF_X7_Y0_N2
\coe_gate_readdata[29]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a29~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[29]~output_o\);

-- Location: IOOBUF_X58_Y0_N2
\coe_gate_readdata[30]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a30~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[30]~output_o\);

-- Location: IOOBUF_X62_Y0_N23
\coe_gate_readdata[31]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a31~PORTBDATAOUT0\,
	devoe => ww_devoe,
	o => \coe_gate_readdata[31]~output_o\);

-- Location: IOOBUF_X94_Y16_N2
\coe_gate_waitrequest~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \coe_gate_waitrequest_reg~q\,
	devoe => ww_devoe,
	o => \coe_gate_waitrequest~output_o\);

-- Location: IOIBUF_X94_Y28_N15
\avs_chipselect~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_chipselect,
	o => \avs_chipselect~input_o\);

-- Location: IOIBUF_X94_Y28_N22
\avs_write~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_write,
	o => \avs_write~input_o\);

-- Location: LCCOMB_X93_Y28_N24
\we_a_next~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \we_a_next~0_combout\ = (\avs_chipselect~input_o\ & \avs_write~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \avs_chipselect~input_o\,
	datad => \avs_write~input_o\,
	combout => \we_a_next~0_combout\);

-- Location: LCCOMB_X93_Y18_N2
\we_a_reg~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \we_a_reg~feeder_combout\ = \we_a_next~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \we_a_next~0_combout\,
	combout => \we_a_reg~feeder_combout\);

-- Location: IOIBUF_X0_Y30_N22
\reset_n~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset_n,
	o => \reset_n~input_o\);

-- Location: CLKCTRL_G3
\reset_n~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \reset_n~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \reset_n~inputclkctrl_outclk\);

-- Location: FF_X93_Y18_N3
we_a_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \we_a_reg~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \we_a_reg~q\);

-- Location: IOIBUF_X94_Y23_N1
\coe_gate_write~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_write,
	o => \coe_gate_write~input_o\);

-- Location: LCCOMB_X56_Y11_N28
\we_b_reg~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \we_b_reg~feeder_combout\ = \coe_gate_write~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_write~input_o\,
	combout => \we_b_reg~feeder_combout\);

-- Location: FF_X56_Y11_N29
we_b_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \we_b_reg~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \we_b_reg~q\);

-- Location: IOIBUF_X0_Y30_N15
\sysclk~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sysclk,
	o => \sysclk~input_o\);

-- Location: CLKCTRL_G4
\sysclk~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \sysclk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \sysclk~inputclkctrl_outclk\);

-- Location: IOIBUF_X0_Y30_N8
\coe_sysclk~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_sysclk,
	o => \coe_sysclk~input_o\);

-- Location: CLKCTRL_G2
\coe_sysclk~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \coe_sysclk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \coe_sysclk~inputclkctrl_outclk\);

-- Location: IOIBUF_X71_Y0_N22
\avs_writedata[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(0),
	o => \avs_writedata[0]~input_o\);

-- Location: FF_X63_Y8_N21
\avs_writedata_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_writedata[0]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(0));

-- Location: IOIBUF_X94_Y21_N22
\avs_address[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_address(0),
	o => \avs_address[0]~input_o\);

-- Location: IOIBUF_X94_Y18_N8
\avs_address[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_address(2),
	o => \avs_address[2]~input_o\);

-- Location: IOIBUF_X94_Y26_N8
\avs_address[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_address(3),
	o => \avs_address[3]~input_o\);

-- Location: IOIBUF_X94_Y35_N22
\coe_gate_address[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_address(2),
	o => \coe_gate_address[2]~input_o\);

-- Location: LCCOMB_X93_Y18_N22
\coe_gate_waitrequest_next~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_waitrequest_next~1_combout\ = (\coe_gate_address[3]~input_o\ & (\avs_address[3]~input_o\ & (\avs_address[2]~input_o\ $ (!\coe_gate_address[2]~input_o\)))) # (!\coe_gate_address[3]~input_o\ & (!\avs_address[3]~input_o\ & (\avs_address[2]~input_o\ 
-- $ (!\coe_gate_address[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000010000100001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \coe_gate_address[3]~input_o\,
	datab => \avs_address[2]~input_o\,
	datac => \avs_address[3]~input_o\,
	datad => \coe_gate_address[2]~input_o\,
	combout => \coe_gate_waitrequest_next~1_combout\);

-- Location: IOIBUF_X94_Y21_N15
\avs_address[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_address(1),
	o => \avs_address[1]~input_o\);

-- Location: IOIBUF_X94_Y23_N8
\coe_gate_address[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_address(1),
	o => \coe_gate_address[1]~input_o\);

-- Location: IOIBUF_X94_Y19_N8
\coe_gate_address[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_address(0),
	o => \coe_gate_address[0]~input_o\);

-- Location: LCCOMB_X93_Y18_N0
\coe_gate_waitrequest_next~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_waitrequest_next~0_combout\ = (\avs_address[0]~input_o\ & (\coe_gate_address[0]~input_o\ & (\avs_address[1]~input_o\ $ (!\coe_gate_address[1]~input_o\)))) # (!\avs_address[0]~input_o\ & (!\coe_gate_address[0]~input_o\ & (\avs_address[1]~input_o\ 
-- $ (!\coe_gate_address[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \avs_address[0]~input_o\,
	datab => \avs_address[1]~input_o\,
	datac => \coe_gate_address[1]~input_o\,
	datad => \coe_gate_address[0]~input_o\,
	combout => \coe_gate_waitrequest_next~0_combout\);

-- Location: LCCOMB_X93_Y18_N8
\coe_gate_waitrequest_next~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_waitrequest_next~2_combout\ = (\coe_gate_waitrequest_next~1_combout\ & \coe_gate_waitrequest_next~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \coe_gate_waitrequest_next~1_combout\,
	datad => \coe_gate_waitrequest_next~0_combout\,
	combout => \coe_gate_waitrequest_next~2_combout\);

-- Location: LCCOMB_X93_Y18_N18
\avs_waitrequest_next~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_waitrequest_next~0_combout\ = (((\we_a_next~0_combout\) # (!\coe_gate_waitrequest_next~2_combout\)) # (!\coe_gate_write~input_o\)) # (!\avs_read~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \avs_read~input_o\,
	datab => \coe_gate_write~input_o\,
	datac => \coe_gate_waitrequest_next~2_combout\,
	datad => \we_a_next~0_combout\,
	combout => \avs_waitrequest_next~0_combout\);

-- Location: FF_X93_Y18_N21
\avs_address_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_address[0]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \avs_waitrequest_next~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_address_reg(0));

-- Location: LCCOMB_X93_Y18_N26
\avs_address_reg[1]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_address_reg[1]~feeder_combout\ = \avs_address[1]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_address[1]~input_o\,
	combout => \avs_address_reg[1]~feeder_combout\);

-- Location: FF_X93_Y18_N27
\avs_address_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_address_reg[1]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	ena => \avs_waitrequest_next~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_address_reg(1));

-- Location: FF_X93_Y18_N25
\avs_address_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_address[2]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \avs_waitrequest_next~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_address_reg(2));

-- Location: FF_X93_Y18_N11
\avs_address_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_address[3]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \avs_waitrequest_next~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_address_reg(3));

-- Location: IOIBUF_X20_Y0_N8
\coe_gate_writedata[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(0),
	o => \coe_gate_writedata[0]~input_o\);

-- Location: LCCOMB_X54_Y8_N16
\coe_gate_writedata_reg[0]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[0]~feeder_combout\ = \coe_gate_writedata[0]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[0]~input_o\,
	combout => \coe_gate_writedata_reg[0]~feeder_combout\);

-- Location: FF_X54_Y8_N17
\coe_gate_writedata_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[0]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(0));

-- Location: LCCOMB_X93_Y18_N28
\coe_gate_waitrequest_next~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_waitrequest_next~3_combout\ = (((\coe_gate_write~input_o\) # (!\coe_gate_waitrequest_next~2_combout\)) # (!\we_a_next~0_combout\)) # (!\coe_gate_read~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \coe_gate_read~input_o\,
	datab => \we_a_next~0_combout\,
	datac => \coe_gate_waitrequest_next~2_combout\,
	datad => \coe_gate_write~input_o\,
	combout => \coe_gate_waitrequest_next~3_combout\);

-- Location: FF_X56_Y11_N31
\coe_gate_address_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_address[0]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \coe_gate_waitrequest_next~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_address_reg(0));

-- Location: LCCOMB_X56_Y11_N16
\coe_gate_address_reg[1]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_address_reg[1]~feeder_combout\ = \coe_gate_address[1]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_address[1]~input_o\,
	combout => \coe_gate_address_reg[1]~feeder_combout\);

-- Location: FF_X56_Y11_N17
\coe_gate_address_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_address_reg[1]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	ena => \coe_gate_waitrequest_next~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_address_reg(1));

-- Location: LCCOMB_X56_Y11_N26
\coe_gate_address_reg[2]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_address_reg[2]~feeder_combout\ = \coe_gate_address[2]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_address[2]~input_o\,
	combout => \coe_gate_address_reg[2]~feeder_combout\);

-- Location: FF_X56_Y11_N27
\coe_gate_address_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_address_reg[2]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	ena => \coe_gate_waitrequest_next~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_address_reg(2));

-- Location: IOIBUF_X94_Y17_N1
\coe_gate_address[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_address(3),
	o => \coe_gate_address[3]~input_o\);

-- Location: LCCOMB_X56_Y11_N4
\coe_gate_address_reg[3]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_address_reg[3]~feeder_combout\ = \coe_gate_address[3]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_address[3]~input_o\,
	combout => \coe_gate_address_reg[3]~feeder_combout\);

-- Location: FF_X56_Y11_N5
\coe_gate_address_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_address_reg[3]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	ena => \coe_gate_waitrequest_next~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_address_reg(3));

-- Location: IOIBUF_X9_Y0_N15
\avs_writedata[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(1),
	o => \avs_writedata[1]~input_o\);

-- Location: LCCOMB_X54_Y8_N18
\avs_writedata_reg[1]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[1]~feeder_combout\ = \avs_writedata[1]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[1]~input_o\,
	combout => \avs_writedata_reg[1]~feeder_combout\);

-- Location: FF_X54_Y8_N19
\avs_writedata_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[1]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(1));

-- Location: IOIBUF_X85_Y0_N1
\avs_writedata[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(2),
	o => \avs_writedata[2]~input_o\);

-- Location: LCCOMB_X56_Y8_N8
\avs_writedata_reg[2]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[2]~feeder_combout\ = \avs_writedata[2]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[2]~input_o\,
	combout => \avs_writedata_reg[2]~feeder_combout\);

-- Location: FF_X56_Y8_N9
\avs_writedata_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[2]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(2));

-- Location: IOIBUF_X80_Y0_N8
\avs_writedata[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(3),
	o => \avs_writedata[3]~input_o\);

-- Location: LCCOMB_X56_Y8_N6
\avs_writedata_reg[3]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[3]~feeder_combout\ = \avs_writedata[3]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[3]~input_o\,
	combout => \avs_writedata_reg[3]~feeder_combout\);

-- Location: FF_X56_Y8_N7
\avs_writedata_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[3]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(3));

-- Location: IOIBUF_X60_Y0_N1
\avs_writedata[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(4),
	o => \avs_writedata[4]~input_o\);

-- Location: FF_X56_Y8_N29
\avs_writedata_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_writedata[4]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(4));

-- Location: IOIBUF_X51_Y0_N1
\avs_writedata[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(5),
	o => \avs_writedata[5]~input_o\);

-- Location: LCCOMB_X54_Y8_N12
\avs_writedata_reg[5]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[5]~feeder_combout\ = \avs_writedata[5]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[5]~input_o\,
	combout => \avs_writedata_reg[5]~feeder_combout\);

-- Location: FF_X54_Y8_N13
\avs_writedata_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[5]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(5));

-- Location: IOIBUF_X80_Y0_N1
\avs_writedata[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(6),
	o => \avs_writedata[6]~input_o\);

-- Location: FF_X56_Y8_N11
\avs_writedata_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_writedata[6]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(6));

-- Location: IOIBUF_X60_Y0_N8
\avs_writedata[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(7),
	o => \avs_writedata[7]~input_o\);

-- Location: FF_X56_Y8_N15
\avs_writedata_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_writedata[7]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(7));

-- Location: IOIBUF_X94_Y4_N15
\avs_writedata[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(8),
	o => \avs_writedata[8]~input_o\);

-- Location: LCCOMB_X66_Y8_N4
\avs_writedata_reg[8]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[8]~feeder_combout\ = \avs_writedata[8]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[8]~input_o\,
	combout => \avs_writedata_reg[8]~feeder_combout\);

-- Location: FF_X66_Y8_N5
\avs_writedata_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[8]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(8));

-- Location: IOIBUF_X18_Y0_N1
\avs_writedata[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(9),
	o => \avs_writedata[9]~input_o\);

-- Location: LCCOMB_X49_Y8_N0
\avs_writedata_reg[9]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[9]~feeder_combout\ = \avs_writedata[9]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[9]~input_o\,
	combout => \avs_writedata_reg[9]~feeder_combout\);

-- Location: FF_X49_Y8_N1
\avs_writedata_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[9]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(9));

-- Location: IOIBUF_X67_Y0_N1
\avs_writedata[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(10),
	o => \avs_writedata[10]~input_o\);

-- Location: LCCOMB_X59_Y8_N0
\avs_writedata_reg[10]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[10]~feeder_combout\ = \avs_writedata[10]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[10]~input_o\,
	combout => \avs_writedata_reg[10]~feeder_combout\);

-- Location: FF_X59_Y8_N1
\avs_writedata_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[10]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(10));

-- Location: IOIBUF_X71_Y0_N1
\avs_writedata[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(11),
	o => \avs_writedata[11]~input_o\);

-- Location: LCCOMB_X59_Y8_N22
\avs_writedata_reg[11]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[11]~feeder_combout\ = \avs_writedata[11]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[11]~input_o\,
	combout => \avs_writedata_reg[11]~feeder_combout\);

-- Location: FF_X59_Y8_N23
\avs_writedata_reg[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[11]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(11));

-- Location: IOIBUF_X11_Y0_N22
\avs_writedata[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(12),
	o => \avs_writedata[12]~input_o\);

-- Location: FF_X54_Y8_N3
\avs_writedata_reg[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_writedata[12]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(12));

-- Location: IOIBUF_X90_Y0_N8
\avs_writedata[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(13),
	o => \avs_writedata[13]~input_o\);

-- Location: FF_X59_Y8_N25
\avs_writedata_reg[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_writedata[13]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(13));

-- Location: IOIBUF_X88_Y0_N22
\avs_writedata[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(14),
	o => \avs_writedata[14]~input_o\);

-- Location: LCCOMB_X56_Y8_N22
\avs_writedata_reg[14]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[14]~feeder_combout\ = \avs_writedata[14]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[14]~input_o\,
	combout => \avs_writedata_reg[14]~feeder_combout\);

-- Location: FF_X56_Y8_N23
\avs_writedata_reg[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[14]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(14));

-- Location: IOIBUF_X60_Y0_N22
\avs_writedata[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(15),
	o => \avs_writedata[15]~input_o\);

-- Location: LCCOMB_X56_Y8_N26
\avs_writedata_reg[15]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[15]~feeder_combout\ = \avs_writedata[15]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[15]~input_o\,
	combout => \avs_writedata_reg[15]~feeder_combout\);

-- Location: FF_X56_Y8_N27
\avs_writedata_reg[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[15]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(15));

-- Location: IOIBUF_X67_Y0_N8
\avs_writedata[16]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(16),
	o => \avs_writedata[16]~input_o\);

-- Location: LCCOMB_X59_Y8_N14
\avs_writedata_reg[16]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[16]~feeder_combout\ = \avs_writedata[16]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[16]~input_o\,
	combout => \avs_writedata_reg[16]~feeder_combout\);

-- Location: FF_X59_Y8_N15
\avs_writedata_reg[16]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[16]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(16));

-- Location: IOIBUF_X69_Y0_N1
\avs_writedata[17]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(17),
	o => \avs_writedata[17]~input_o\);

-- Location: FF_X62_Y8_N5
\avs_writedata_reg[17]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_writedata[17]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(17));

-- Location: IOIBUF_X11_Y0_N15
\coe_gate_writedata[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(1),
	o => \coe_gate_writedata[1]~input_o\);

-- Location: FF_X54_Y8_N25
\coe_gate_writedata_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_writedata[1]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(1));

-- Location: IOIBUF_X5_Y0_N8
\coe_gate_writedata[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(2),
	o => \coe_gate_writedata[2]~input_o\);

-- Location: LCCOMB_X54_Y8_N14
\coe_gate_writedata_reg[2]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[2]~feeder_combout\ = \coe_gate_writedata[2]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[2]~input_o\,
	combout => \coe_gate_writedata_reg[2]~feeder_combout\);

-- Location: FF_X54_Y8_N15
\coe_gate_writedata_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[2]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(2));

-- Location: IOIBUF_X13_Y0_N15
\coe_gate_writedata[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(3),
	o => \coe_gate_writedata[3]~input_o\);

-- Location: FF_X54_Y8_N1
\coe_gate_writedata_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_writedata[3]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(3));

-- Location: IOIBUF_X47_Y0_N15
\coe_gate_writedata[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(4),
	o => \coe_gate_writedata[4]~input_o\);

-- Location: LCCOMB_X54_Y8_N30
\coe_gate_writedata_reg[4]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[4]~feeder_combout\ = \coe_gate_writedata[4]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[4]~input_o\,
	combout => \coe_gate_writedata_reg[4]~feeder_combout\);

-- Location: FF_X54_Y8_N31
\coe_gate_writedata_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[4]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(4));

-- Location: IOIBUF_X45_Y0_N15
\coe_gate_writedata[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(5),
	o => \coe_gate_writedata[5]~input_o\);

-- Location: LCCOMB_X54_Y8_N10
\coe_gate_writedata_reg[5]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[5]~feeder_combout\ = \coe_gate_writedata[5]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[5]~input_o\,
	combout => \coe_gate_writedata_reg[5]~feeder_combout\);

-- Location: FF_X54_Y8_N11
\coe_gate_writedata_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[5]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(5));

-- Location: IOIBUF_X92_Y0_N8
\coe_gate_writedata[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(6),
	o => \coe_gate_writedata[6]~input_o\);

-- Location: LCCOMB_X56_Y8_N0
\coe_gate_writedata_reg[6]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[6]~feeder_combout\ = \coe_gate_writedata[6]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[6]~input_o\,
	combout => \coe_gate_writedata_reg[6]~feeder_combout\);

-- Location: FF_X56_Y8_N1
\coe_gate_writedata_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[6]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(6));

-- Location: IOIBUF_X62_Y0_N1
\coe_gate_writedata[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(7),
	o => \coe_gate_writedata[7]~input_o\);

-- Location: FF_X56_Y8_N21
\coe_gate_writedata_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_writedata[7]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(7));

-- Location: IOIBUF_X94_Y8_N15
\coe_gate_writedata[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(8),
	o => \coe_gate_writedata[8]~input_o\);

-- Location: LCCOMB_X56_Y8_N2
\coe_gate_writedata_reg[8]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[8]~feeder_combout\ = \coe_gate_writedata[8]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[8]~input_o\,
	combout => \coe_gate_writedata_reg[8]~feeder_combout\);

-- Location: FF_X56_Y8_N3
\coe_gate_writedata_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[8]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(8));

-- Location: IOIBUF_X36_Y0_N8
\coe_gate_writedata[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(9),
	o => \coe_gate_writedata[9]~input_o\);

-- Location: LCCOMB_X54_Y8_N8
\coe_gate_writedata_reg[9]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[9]~feeder_combout\ = \coe_gate_writedata[9]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[9]~input_o\,
	combout => \coe_gate_writedata_reg[9]~feeder_combout\);

-- Location: FF_X54_Y8_N9
\coe_gate_writedata_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[9]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(9));

-- Location: IOIBUF_X62_Y0_N8
\coe_gate_writedata[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(10),
	o => \coe_gate_writedata[10]~input_o\);

-- Location: LCCOMB_X56_Y8_N12
\coe_gate_writedata_reg[10]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[10]~feeder_combout\ = \coe_gate_writedata[10]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[10]~input_o\,
	combout => \coe_gate_writedata_reg[10]~feeder_combout\);

-- Location: FF_X56_Y8_N13
\coe_gate_writedata_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[10]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(10));

-- Location: IOIBUF_X88_Y0_N1
\coe_gate_writedata[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(11),
	o => \coe_gate_writedata[11]~input_o\);

-- Location: FF_X56_Y8_N19
\coe_gate_writedata_reg[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_writedata[11]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(11));

-- Location: IOIBUF_X5_Y0_N15
\coe_gate_writedata[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(12),
	o => \coe_gate_writedata[12]~input_o\);

-- Location: LCCOMB_X54_Y8_N20
\coe_gate_writedata_reg[12]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[12]~feeder_combout\ = \coe_gate_writedata[12]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[12]~input_o\,
	combout => \coe_gate_writedata_reg[12]~feeder_combout\);

-- Location: FF_X54_Y8_N21
\coe_gate_writedata_reg[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[12]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(12));

-- Location: IOIBUF_X56_Y0_N15
\coe_gate_writedata[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(13),
	o => \coe_gate_writedata[13]~input_o\);

-- Location: LCCOMB_X56_Y8_N24
\coe_gate_writedata_reg[13]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[13]~feeder_combout\ = \coe_gate_writedata[13]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[13]~input_o\,
	combout => \coe_gate_writedata_reg[13]~feeder_combout\);

-- Location: FF_X56_Y8_N25
\coe_gate_writedata_reg[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[13]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(13));

-- Location: IOIBUF_X88_Y0_N15
\coe_gate_writedata[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(14),
	o => \coe_gate_writedata[14]~input_o\);

-- Location: LCCOMB_X56_Y8_N16
\coe_gate_writedata_reg[14]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[14]~feeder_combout\ = \coe_gate_writedata[14]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[14]~input_o\,
	combout => \coe_gate_writedata_reg[14]~feeder_combout\);

-- Location: FF_X56_Y8_N17
\coe_gate_writedata_reg[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[14]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(14));

-- Location: IOIBUF_X94_Y8_N8
\coe_gate_writedata[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(15),
	o => \coe_gate_writedata[15]~input_o\);

-- Location: LCCOMB_X56_Y8_N4
\coe_gate_writedata_reg[15]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[15]~feeder_combout\ = \coe_gate_writedata[15]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[15]~input_o\,
	combout => \coe_gate_writedata_reg[15]~feeder_combout\);

-- Location: FF_X56_Y8_N5
\coe_gate_writedata_reg[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[15]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(15));

-- Location: IOIBUF_X76_Y0_N1
\coe_gate_writedata[16]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(16),
	o => \coe_gate_writedata[16]~input_o\);

-- Location: LCCOMB_X56_Y8_N30
\coe_gate_writedata_reg[16]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[16]~feeder_combout\ = \coe_gate_writedata[16]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[16]~input_o\,
	combout => \coe_gate_writedata_reg[16]~feeder_combout\);

-- Location: FF_X56_Y8_N31
\coe_gate_writedata_reg[16]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[16]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(16));

-- Location: IOIBUF_X13_Y0_N22
\coe_gate_writedata[17]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(17),
	o => \coe_gate_writedata[17]~input_o\);

-- Location: LCCOMB_X54_Y8_N22
\coe_gate_writedata_reg[17]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[17]~feeder_combout\ = \coe_gate_writedata[17]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[17]~input_o\,
	combout => \coe_gate_writedata_reg[17]~feeder_combout\);

-- Location: FF_X54_Y8_N23
\coe_gate_writedata_reg[17]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[17]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(17));

-- Location: M9K_X55_Y8_N0
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0\ : cycloneive_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "true_dual_port_ram_dual_clock:true_dual_port_ram_dual_clock_1|altsyncram:ram_rtl_0|altsyncram_a6n1:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 4,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 18,
	port_a_first_address => 0,
	port_a_first_bit_number => 0,
	port_a_last_address => 15,
	port_a_logical_ram_depth => 16,
	port_a_logical_ram_width => 32,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 4,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 18,
	port_b_first_address => 0,
	port_b_first_bit_number => 0,
	port_b_last_address => 15,
	port_b_logical_ram_depth => 16,
	port_b_logical_ram_width => 32,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => \we_a_reg~q\,
	portare => VCC,
	portbwe => \we_b_reg~q\,
	portbre => VCC,
	clk0 => \sysclk~inputclkctrl_outclk\,
	clk1 => \coe_sysclk~inputclkctrl_outclk\,
	portadatain => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAIN_bus\,
	portbdatain => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAIN_bus\,
	portaaddr => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTAADDR_bus\,
	portbaddr => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAOUT_bus\,
	portbdataout => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\);

-- Location: IOIBUF_X94_Y27_N22
\avs_writedata[18]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(18),
	o => \avs_writedata[18]~input_o\);

-- Location: LCCOMB_X66_Y11_N8
\avs_writedata_reg[18]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[18]~feeder_combout\ = \avs_writedata[18]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[18]~input_o\,
	combout => \avs_writedata_reg[18]~feeder_combout\);

-- Location: FF_X66_Y11_N9
\avs_writedata_reg[18]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[18]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(18));

-- Location: IOIBUF_X7_Y0_N15
\coe_gate_writedata[18]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(18),
	o => \coe_gate_writedata[18]~input_o\);

-- Location: LCCOMB_X54_Y11_N24
\coe_gate_writedata_reg[18]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[18]~feeder_combout\ = \coe_gate_writedata[18]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[18]~input_o\,
	combout => \coe_gate_writedata_reg[18]~feeder_combout\);

-- Location: FF_X54_Y11_N25
\coe_gate_writedata_reg[18]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[18]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(18));

-- Location: IOIBUF_X20_Y0_N1
\avs_writedata[19]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(19),
	o => \avs_writedata[19]~input_o\);

-- Location: LCCOMB_X51_Y8_N8
\avs_writedata_reg[19]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[19]~feeder_combout\ = \avs_writedata[19]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[19]~input_o\,
	combout => \avs_writedata_reg[19]~feeder_combout\);

-- Location: FF_X51_Y8_N9
\avs_writedata_reg[19]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[19]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(19));

-- Location: IOIBUF_X45_Y0_N1
\avs_writedata[20]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(20),
	o => \avs_writedata[20]~input_o\);

-- Location: LCCOMB_X52_Y8_N0
\avs_writedata_reg[20]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[20]~feeder_combout\ = \avs_writedata[20]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[20]~input_o\,
	combout => \avs_writedata_reg[20]~feeder_combout\);

-- Location: FF_X52_Y8_N1
\avs_writedata_reg[20]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[20]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(20));

-- Location: IOIBUF_X45_Y0_N8
\avs_writedata[21]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(21),
	o => \avs_writedata[21]~input_o\);

-- Location: LCCOMB_X52_Y8_N2
\avs_writedata_reg[21]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[21]~feeder_combout\ = \avs_writedata[21]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[21]~input_o\,
	combout => \avs_writedata_reg[21]~feeder_combout\);

-- Location: FF_X52_Y8_N3
\avs_writedata_reg[21]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[21]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(21));

-- Location: IOIBUF_X94_Y16_N8
\avs_writedata[22]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(22),
	o => \avs_writedata[22]~input_o\);

-- Location: LCCOMB_X66_Y11_N14
\avs_writedata_reg[22]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[22]~feeder_combout\ = \avs_writedata[22]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[22]~input_o\,
	combout => \avs_writedata_reg[22]~feeder_combout\);

-- Location: FF_X66_Y11_N15
\avs_writedata_reg[22]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[22]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(22));

-- Location: IOIBUF_X94_Y29_N15
\avs_writedata[23]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(23),
	o => \avs_writedata[23]~input_o\);

-- Location: LCCOMB_X63_Y11_N0
\avs_writedata_reg[23]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[23]~feeder_combout\ = \avs_writedata[23]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[23]~input_o\,
	combout => \avs_writedata_reg[23]~feeder_combout\);

-- Location: FF_X63_Y11_N1
\avs_writedata_reg[23]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[23]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(23));

-- Location: IOIBUF_X69_Y0_N8
\avs_writedata[24]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(24),
	o => \avs_writedata[24]~input_o\);

-- Location: LCCOMB_X62_Y8_N2
\avs_writedata_reg[24]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[24]~feeder_combout\ = \avs_writedata[24]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[24]~input_o\,
	combout => \avs_writedata_reg[24]~feeder_combout\);

-- Location: FF_X62_Y8_N3
\avs_writedata_reg[24]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[24]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(24));

-- Location: IOIBUF_X94_Y30_N8
\avs_writedata[25]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(25),
	o => \avs_writedata[25]~input_o\);

-- Location: LCCOMB_X59_Y11_N28
\avs_writedata_reg[25]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[25]~feeder_combout\ = \avs_writedata[25]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[25]~input_o\,
	combout => \avs_writedata_reg[25]~feeder_combout\);

-- Location: FF_X59_Y11_N29
\avs_writedata_reg[25]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[25]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(25));

-- Location: IOIBUF_X94_Y13_N8
\avs_writedata[26]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(26),
	o => \avs_writedata[26]~input_o\);

-- Location: FF_X66_Y11_N13
\avs_writedata_reg[26]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \avs_writedata[26]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(26));

-- Location: IOIBUF_X94_Y12_N1
\avs_writedata[27]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(27),
	o => \avs_writedata[27]~input_o\);

-- Location: LCCOMB_X59_Y12_N20
\avs_writedata_reg[27]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[27]~feeder_combout\ = \avs_writedata[27]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[27]~input_o\,
	combout => \avs_writedata_reg[27]~feeder_combout\);

-- Location: FF_X59_Y12_N21
\avs_writedata_reg[27]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[27]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(27));

-- Location: IOIBUF_X94_Y6_N1
\avs_writedata[28]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(28),
	o => \avs_writedata[28]~input_o\);

-- Location: LCCOMB_X66_Y11_N18
\avs_writedata_reg[28]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[28]~feeder_combout\ = \avs_writedata[28]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[28]~input_o\,
	combout => \avs_writedata_reg[28]~feeder_combout\);

-- Location: FF_X66_Y11_N19
\avs_writedata_reg[28]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[28]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(28));

-- Location: IOIBUF_X94_Y7_N1
\avs_writedata[29]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(29),
	o => \avs_writedata[29]~input_o\);

-- Location: LCCOMB_X66_Y11_N4
\avs_writedata_reg[29]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[29]~feeder_combout\ = \avs_writedata[29]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[29]~input_o\,
	combout => \avs_writedata_reg[29]~feeder_combout\);

-- Location: FF_X66_Y11_N5
\avs_writedata_reg[29]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[29]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(29));

-- Location: IOIBUF_X94_Y13_N1
\avs_writedata[30]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(30),
	o => \avs_writedata[30]~input_o\);

-- Location: LCCOMB_X66_Y11_N10
\avs_writedata_reg[30]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[30]~feeder_combout\ = \avs_writedata[30]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[30]~input_o\,
	combout => \avs_writedata_reg[30]~feeder_combout\);

-- Location: FF_X66_Y11_N11
\avs_writedata_reg[30]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[30]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(30));

-- Location: IOIBUF_X49_Y0_N22
\avs_writedata[31]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_avs_writedata(31),
	o => \avs_writedata[31]~input_o\);

-- Location: LCCOMB_X54_Y8_N28
\avs_writedata_reg[31]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_writedata_reg[31]~feeder_combout\ = \avs_writedata[31]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_writedata[31]~input_o\,
	combout => \avs_writedata_reg[31]~feeder_combout\);

-- Location: FF_X54_Y8_N29
\avs_writedata_reg[31]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_writedata_reg[31]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => avs_writedata_reg(31));

-- Location: IOIBUF_X94_Y9_N15
\coe_gate_writedata[19]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(19),
	o => \coe_gate_writedata[19]~input_o\);

-- Location: LCCOMB_X56_Y11_N10
\coe_gate_writedata_reg[19]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[19]~feeder_combout\ = \coe_gate_writedata[19]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[19]~input_o\,
	combout => \coe_gate_writedata_reg[19]~feeder_combout\);

-- Location: FF_X56_Y11_N11
\coe_gate_writedata_reg[19]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[19]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(19));

-- Location: IOIBUF_X47_Y62_N1
\coe_gate_writedata[20]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(20),
	o => \coe_gate_writedata[20]~input_o\);

-- Location: FF_X54_Y11_N3
\coe_gate_writedata_reg[20]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_writedata[20]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(20));

-- Location: IOIBUF_X47_Y62_N8
\coe_gate_writedata[21]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(21),
	o => \coe_gate_writedata[21]~input_o\);

-- Location: LCCOMB_X54_Y11_N12
\coe_gate_writedata_reg[21]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[21]~feeder_combout\ = \coe_gate_writedata[21]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[21]~input_o\,
	combout => \coe_gate_writedata_reg[21]~feeder_combout\);

-- Location: FF_X54_Y11_N13
\coe_gate_writedata_reg[21]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[21]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(21));

-- Location: IOIBUF_X94_Y27_N15
\coe_gate_writedata[22]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(22),
	o => \coe_gate_writedata[22]~input_o\);

-- Location: LCCOMB_X56_Y11_N20
\coe_gate_writedata_reg[22]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[22]~feeder_combout\ = \coe_gate_writedata[22]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[22]~input_o\,
	combout => \coe_gate_writedata_reg[22]~feeder_combout\);

-- Location: FF_X56_Y11_N21
\coe_gate_writedata_reg[22]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[22]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(22));

-- Location: IOIBUF_X94_Y30_N22
\coe_gate_writedata[23]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(23),
	o => \coe_gate_writedata[23]~input_o\);

-- Location: LCCOMB_X56_Y11_N6
\coe_gate_writedata_reg[23]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[23]~feeder_combout\ = \coe_gate_writedata[23]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[23]~input_o\,
	combout => \coe_gate_writedata_reg[23]~feeder_combout\);

-- Location: FF_X56_Y11_N7
\coe_gate_writedata_reg[23]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[23]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(23));

-- Location: IOIBUF_X31_Y0_N15
\coe_gate_writedata[24]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(24),
	o => \coe_gate_writedata[24]~input_o\);

-- Location: LCCOMB_X54_Y11_N10
\coe_gate_writedata_reg[24]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[24]~feeder_combout\ = \coe_gate_writedata[24]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[24]~input_o\,
	combout => \coe_gate_writedata_reg[24]~feeder_combout\);

-- Location: FF_X54_Y11_N11
\coe_gate_writedata_reg[24]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[24]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(24));

-- Location: IOIBUF_X94_Y31_N8
\coe_gate_writedata[25]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(25),
	o => \coe_gate_writedata[25]~input_o\);

-- Location: LCCOMB_X56_Y11_N8
\coe_gate_writedata_reg[25]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[25]~feeder_combout\ = \coe_gate_writedata[25]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[25]~input_o\,
	combout => \coe_gate_writedata_reg[25]~feeder_combout\);

-- Location: FF_X56_Y11_N9
\coe_gate_writedata_reg[25]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[25]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(25));

-- Location: IOIBUF_X94_Y31_N1
\coe_gate_writedata[26]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(26),
	o => \coe_gate_writedata[26]~input_o\);

-- Location: FF_X56_Y11_N19
\coe_gate_writedata_reg[26]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_writedata[26]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(26));

-- Location: IOIBUF_X94_Y30_N1
\coe_gate_writedata[27]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(27),
	o => \coe_gate_writedata[27]~input_o\);

-- Location: FF_X59_Y11_N31
\coe_gate_writedata_reg[27]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_writedata[27]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(27));

-- Location: IOIBUF_X94_Y16_N15
\coe_gate_writedata[28]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(28),
	o => \coe_gate_writedata[28]~input_o\);

-- Location: LCCOMB_X56_Y11_N24
\coe_gate_writedata_reg[28]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[28]~feeder_combout\ = \coe_gate_writedata[28]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[28]~input_o\,
	combout => \coe_gate_writedata_reg[28]~feeder_combout\);

-- Location: FF_X56_Y11_N25
\coe_gate_writedata_reg[28]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[28]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(28));

-- Location: IOIBUF_X94_Y14_N1
\coe_gate_writedata[29]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(29),
	o => \coe_gate_writedata[29]~input_o\);

-- Location: LCCOMB_X56_Y11_N22
\coe_gate_writedata_reg[29]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[29]~feeder_combout\ = \coe_gate_writedata[29]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[29]~input_o\,
	combout => \coe_gate_writedata_reg[29]~feeder_combout\);

-- Location: FF_X56_Y11_N23
\coe_gate_writedata_reg[29]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[29]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(29));

-- Location: IOIBUF_X94_Y14_N8
\coe_gate_writedata[30]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(30),
	o => \coe_gate_writedata[30]~input_o\);

-- Location: FF_X56_Y11_N13
\coe_gate_writedata_reg[30]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	asdata => \coe_gate_writedata[30]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(30));

-- Location: IOIBUF_X76_Y0_N8
\coe_gate_writedata[31]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_coe_gate_writedata(31),
	o => \coe_gate_writedata[31]~input_o\);

-- Location: LCCOMB_X56_Y11_N14
\coe_gate_writedata_reg[31]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_writedata_reg[31]~feeder_combout\ = \coe_gate_writedata[31]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_writedata[31]~input_o\,
	combout => \coe_gate_writedata_reg[31]~feeder_combout\);

-- Location: FF_X56_Y11_N15
\coe_gate_writedata_reg[31]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_writedata_reg[31]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => coe_gate_writedata_reg(31));

-- Location: M9K_X55_Y11_N0
\true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18\ : cycloneive_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "true_dual_port_ram_dual_clock:true_dual_port_ram_dual_clock_1|altsyncram:ram_rtl_0|altsyncram_a6n1:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "bidir_dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 4,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 18,
	port_a_first_address => 0,
	port_a_first_bit_number => 18,
	port_a_last_address => 15,
	port_a_logical_ram_depth => 16,
	port_a_logical_ram_width => 32,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 4,
	port_b_data_in_clock => "clock1",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 18,
	port_b_first_address => 0,
	port_b_first_bit_number => 18,
	port_b_last_address => 15,
	port_b_logical_ram_depth => 16,
	port_b_logical_ram_width => 32,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	port_b_write_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => \we_a_reg~q\,
	portare => VCC,
	portbwe => \we_b_reg~q\,
	portbre => VCC,
	clk0 => \sysclk~inputclkctrl_outclk\,
	clk1 => \coe_sysclk~inputclkctrl_outclk\,
	portadatain => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAIN_bus\,
	portbdatain => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAIN_bus\,
	portaaddr => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTAADDR_bus\,
	portbaddr => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portadataout => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTADATAOUT_bus\,
	portbdataout => \true_dual_port_ram_dual_clock_1|ram_rtl_0|auto_generated|ram_block1a18_PORTBDATAOUT_bus\);

-- Location: LCCOMB_X93_Y18_N4
\avs_waitrequest_next~0_wirecell\ : cycloneive_lcell_comb
-- Equation(s):
-- \avs_waitrequest_next~0_wirecell_combout\ = !\avs_waitrequest_next~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \avs_waitrequest_next~0_combout\,
	combout => \avs_waitrequest_next~0_wirecell_combout\);

-- Location: FF_X93_Y18_N5
avs_waitrequest_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \avs_waitrequest_next~0_wirecell_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \avs_waitrequest_reg~q\);

-- Location: LCCOMB_X93_Y16_N20
\coe_gate_waitrequest_next~3_wirecell\ : cycloneive_lcell_comb
-- Equation(s):
-- \coe_gate_waitrequest_next~3_wirecell_combout\ = !\coe_gate_waitrequest_next~3_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \coe_gate_waitrequest_next~3_combout\,
	combout => \coe_gate_waitrequest_next~3_wirecell_combout\);

-- Location: FF_X93_Y16_N21
coe_gate_waitrequest_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \coe_sysclk~inputclkctrl_outclk\,
	d => \coe_gate_waitrequest_next~3_wirecell_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \coe_gate_waitrequest_reg~q\);

ww_avs_readdata(0) <= \avs_readdata[0]~output_o\;

ww_avs_readdata(1) <= \avs_readdata[1]~output_o\;

ww_avs_readdata(2) <= \avs_readdata[2]~output_o\;

ww_avs_readdata(3) <= \avs_readdata[3]~output_o\;

ww_avs_readdata(4) <= \avs_readdata[4]~output_o\;

ww_avs_readdata(5) <= \avs_readdata[5]~output_o\;

ww_avs_readdata(6) <= \avs_readdata[6]~output_o\;

ww_avs_readdata(7) <= \avs_readdata[7]~output_o\;

ww_avs_readdata(8) <= \avs_readdata[8]~output_o\;

ww_avs_readdata(9) <= \avs_readdata[9]~output_o\;

ww_avs_readdata(10) <= \avs_readdata[10]~output_o\;

ww_avs_readdata(11) <= \avs_readdata[11]~output_o\;

ww_avs_readdata(12) <= \avs_readdata[12]~output_o\;

ww_avs_readdata(13) <= \avs_readdata[13]~output_o\;

ww_avs_readdata(14) <= \avs_readdata[14]~output_o\;

ww_avs_readdata(15) <= \avs_readdata[15]~output_o\;

ww_avs_readdata(16) <= \avs_readdata[16]~output_o\;

ww_avs_readdata(17) <= \avs_readdata[17]~output_o\;

ww_avs_readdata(18) <= \avs_readdata[18]~output_o\;

ww_avs_readdata(19) <= \avs_readdata[19]~output_o\;

ww_avs_readdata(20) <= \avs_readdata[20]~output_o\;

ww_avs_readdata(21) <= \avs_readdata[21]~output_o\;

ww_avs_readdata(22) <= \avs_readdata[22]~output_o\;

ww_avs_readdata(23) <= \avs_readdata[23]~output_o\;

ww_avs_readdata(24) <= \avs_readdata[24]~output_o\;

ww_avs_readdata(25) <= \avs_readdata[25]~output_o\;

ww_avs_readdata(26) <= \avs_readdata[26]~output_o\;

ww_avs_readdata(27) <= \avs_readdata[27]~output_o\;

ww_avs_readdata(28) <= \avs_readdata[28]~output_o\;

ww_avs_readdata(29) <= \avs_readdata[29]~output_o\;

ww_avs_readdata(30) <= \avs_readdata[30]~output_o\;

ww_avs_readdata(31) <= \avs_readdata[31]~output_o\;

ww_avs_waitrequest <= \avs_waitrequest~output_o\;

ww_coe_gate_readdata(0) <= \coe_gate_readdata[0]~output_o\;

ww_coe_gate_readdata(1) <= \coe_gate_readdata[1]~output_o\;

ww_coe_gate_readdata(2) <= \coe_gate_readdata[2]~output_o\;

ww_coe_gate_readdata(3) <= \coe_gate_readdata[3]~output_o\;

ww_coe_gate_readdata(4) <= \coe_gate_readdata[4]~output_o\;

ww_coe_gate_readdata(5) <= \coe_gate_readdata[5]~output_o\;

ww_coe_gate_readdata(6) <= \coe_gate_readdata[6]~output_o\;

ww_coe_gate_readdata(7) <= \coe_gate_readdata[7]~output_o\;

ww_coe_gate_readdata(8) <= \coe_gate_readdata[8]~output_o\;

ww_coe_gate_readdata(9) <= \coe_gate_readdata[9]~output_o\;

ww_coe_gate_readdata(10) <= \coe_gate_readdata[10]~output_o\;

ww_coe_gate_readdata(11) <= \coe_gate_readdata[11]~output_o\;

ww_coe_gate_readdata(12) <= \coe_gate_readdata[12]~output_o\;

ww_coe_gate_readdata(13) <= \coe_gate_readdata[13]~output_o\;

ww_coe_gate_readdata(14) <= \coe_gate_readdata[14]~output_o\;

ww_coe_gate_readdata(15) <= \coe_gate_readdata[15]~output_o\;

ww_coe_gate_readdata(16) <= \coe_gate_readdata[16]~output_o\;

ww_coe_gate_readdata(17) <= \coe_gate_readdata[17]~output_o\;

ww_coe_gate_readdata(18) <= \coe_gate_readdata[18]~output_o\;

ww_coe_gate_readdata(19) <= \coe_gate_readdata[19]~output_o\;

ww_coe_gate_readdata(20) <= \coe_gate_readdata[20]~output_o\;

ww_coe_gate_readdata(21) <= \coe_gate_readdata[21]~output_o\;

ww_coe_gate_readdata(22) <= \coe_gate_readdata[22]~output_o\;

ww_coe_gate_readdata(23) <= \coe_gate_readdata[23]~output_o\;

ww_coe_gate_readdata(24) <= \coe_gate_readdata[24]~output_o\;

ww_coe_gate_readdata(25) <= \coe_gate_readdata[25]~output_o\;

ww_coe_gate_readdata(26) <= \coe_gate_readdata[26]~output_o\;

ww_coe_gate_readdata(27) <= \coe_gate_readdata[27]~output_o\;

ww_coe_gate_readdata(28) <= \coe_gate_readdata[28]~output_o\;

ww_coe_gate_readdata(29) <= \coe_gate_readdata[29]~output_o\;

ww_coe_gate_readdata(30) <= \coe_gate_readdata[30]~output_o\;

ww_coe_gate_readdata(31) <= \coe_gate_readdata[31]~output_o\;

ww_coe_gate_waitrequest <= \coe_gate_waitrequest~output_o\;
END structure;


