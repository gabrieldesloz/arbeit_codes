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

-- DATE "01/28/2014 15:16:03"

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

ENTITY 	adder_ovf IS
    PORT (
	sysclk : IN std_logic;
	reset_n : IN std_logic;
	start_calc_i : IN std_logic;
	val_1_i : IN std_logic_vector(31 DOWNTO 0);
	val_2_i : IN std_logic_vector(31 DOWNTO 0);
	val_3_i : IN std_logic_vector(31 DOWNTO 0);
	val_o : OUT std_logic_vector(31 DOWNTO 0);
	done_o : OUT std_logic;
	ovf_o : OUT std_logic;
	POS_OVF : IN std_logic_vector(31 DOWNTO 0);
	NEG_OVF : IN std_logic_vector(31 DOWNTO 0)
	);
END adder_ovf;

-- Design Ports Information
-- val_o[0]	=>  Location: PIN_C4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[1]	=>  Location: PIN_B3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[2]	=>  Location: PIN_A13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[3]	=>  Location: PIN_C20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[4]	=>  Location: PIN_D8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[5]	=>  Location: PIN_B21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[6]	=>  Location: PIN_E8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[7]	=>  Location: PIN_A15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[8]	=>  Location: PIN_F17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[9]	=>  Location: PIN_E15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[10]	=>  Location: PIN_E21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[11]	=>  Location: PIN_H17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[12]	=>  Location: PIN_D20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[13]	=>  Location: PIN_G18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[14]	=>  Location: PIN_D15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[15]	=>  Location: PIN_H18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[16]	=>  Location: PIN_B18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[17]	=>  Location: PIN_C21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[18]	=>  Location: PIN_E22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[19]	=>  Location: PIN_C22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[20]	=>  Location: PIN_F19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[21]	=>  Location: PIN_F20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[22]	=>  Location: PIN_A17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[23]	=>  Location: PIN_B17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[24]	=>  Location: PIN_A16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[25]	=>  Location: PIN_C15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[26]	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[27]	=>  Location: PIN_B15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[28]	=>  Location: PIN_E12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[29]	=>  Location: PIN_M20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[30]	=>  Location: PIN_N18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_o[31]	=>  Location: PIN_J20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- done_o	=>  Location: PIN_E13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ovf_o	=>  Location: PIN_D19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sysclk	=>  Location: PIN_G1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset_n	=>  Location: PIN_T2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[31]	=>  Location: PIN_AA12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[30]	=>  Location: PIN_AB12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[29]	=>  Location: PIN_F22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[28]	=>  Location: PIN_G3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[25]	=>  Location: PIN_D17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[26]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[27]	=>  Location: PIN_G4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[24]	=>  Location: PIN_C18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[22]	=>  Location: PIN_D13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[23]	=>  Location: PIN_F11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[21]	=>  Location: PIN_T20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[18]	=>  Location: PIN_AB20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[19]	=>  Location: PIN_U19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[20]	=>  Location: PIN_W15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[17]	=>  Location: PIN_AA20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[15]	=>  Location: PIN_W17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[16]	=>  Location: PIN_T15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[7]	=>  Location: PIN_P21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[6]	=>  Location: PIN_E11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[5]	=>  Location: PIN_C10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[4]	=>  Location: PIN_F15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[3]	=>  Location: PIN_A20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[2]	=>  Location: PIN_E16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[0]	=>  Location: PIN_E7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[1]	=>  Location: PIN_C6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[14]	=>  Location: PIN_A19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[11]	=>  Location: PIN_C17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[10]	=>  Location: PIN_B19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[13]	=>  Location: PIN_C19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[12]	=>  Location: PIN_K21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[9]	=>  Location: PIN_J22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- POS_OVF[8]	=>  Location: PIN_AB18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[31]	=>  Location: PIN_U21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[30]	=>  Location: PIN_F21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[29]	=>  Location: PIN_R18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[21]	=>  Location: PIN_R19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[17]	=>  Location: PIN_R21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[18]	=>  Location: PIN_W19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[20]	=>  Location: PIN_W21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[19]	=>  Location: PIN_N20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[16]	=>  Location: PIN_R22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[15]	=>  Location: PIN_Y17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[7]	=>  Location: PIN_D10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[6]	=>  Location: PIN_H22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[5]	=>  Location: PIN_F10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[4]	=>  Location: PIN_F14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[3]	=>  Location: PIN_B10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[2]	=>  Location: PIN_J21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[1]	=>  Location: PIN_A8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[0]	=>  Location: PIN_H7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[14]	=>  Location: PIN_U15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[10]	=>  Location: PIN_P20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[11]	=>  Location: PIN_AA17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[13]	=>  Location: PIN_AA18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[12]	=>  Location: PIN_V15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[9]	=>  Location: PIN_D18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[8]	=>  Location: PIN_AB19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[28]	=>  Location: PIN_C2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[25]	=>  Location: PIN_C1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[26]	=>  Location: PIN_F8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[27]	=>  Location: PIN_B8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[24]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[23]	=>  Location: PIN_B9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NEG_OVF[22]	=>  Location: PIN_A18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[0]	=>  Location: PIN_E6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[0]	=>  Location: PIN_B4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[0]	=>  Location: PIN_E5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- start_calc_i	=>  Location: PIN_D6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[1]	=>  Location: PIN_D2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[1]	=>  Location: PIN_G7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[1]	=>  Location: PIN_C8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[2]	=>  Location: PIN_C13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[2]	=>  Location: PIN_P22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[2]	=>  Location: PIN_T22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[3]	=>  Location: PIN_T21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[3]	=>  Location: PIN_C7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[3]	=>  Location: PIN_F7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[4]	=>  Location: PIN_A4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[4]	=>  Location: PIN_T1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[4]	=>  Location: PIN_C3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[5]	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[5]	=>  Location: PIN_A3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[5]	=>  Location: PIN_E14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[6]	=>  Location: PIN_B22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[6]	=>  Location: PIN_F9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[6]	=>  Location: PIN_D7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[7]	=>  Location: PIN_L22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[7]	=>  Location: PIN_F13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[7]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[8]	=>  Location: PIN_B20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[8]	=>  Location: PIN_B6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[8]	=>  Location: PIN_J18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[9]	=>  Location: PIN_D22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[9]	=>  Location: PIN_E3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[9]	=>  Location: PIN_J5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[10]	=>  Location: PIN_U22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[10]	=>  Location: PIN_Y13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[10]	=>  Location: PIN_B2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[11]	=>  Location: PIN_H19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[11]	=>  Location: PIN_F1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[11]	=>  Location: PIN_H5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[12]	=>  Location: PIN_H20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[12]	=>  Location: PIN_AB14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[12]	=>  Location: PIN_W13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[13]	=>  Location: PIN_M19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[13]	=>  Location: PIN_AB16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[13]	=>  Location: PIN_H3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[14]	=>  Location: PIN_R20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[14]	=>  Location: PIN_Y15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[14]	=>  Location: PIN_AA15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[15]	=>  Location: PIN_R17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[15]	=>  Location: PIN_A7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[15]	=>  Location: PIN_Y14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[16]	=>  Location: PIN_W22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[16]	=>  Location: PIN_E4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[16]	=>  Location: PIN_AB15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[17]	=>  Location: PIN_T19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[17]	=>  Location: PIN_L21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[17]	=>  Location: PIN_G5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[18]	=>  Location: PIN_AB17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[18]	=>  Location: PIN_V12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[18]	=>  Location: PIN_B1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[19]	=>  Location: PIN_E9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[19]	=>  Location: PIN_A6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[19]	=>  Location: PIN_U12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[20]	=>  Location: PIN_AA19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[20]	=>  Location: PIN_A14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[20]	=>  Location: PIN_J4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[21]	=>  Location: PIN_M16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[21]	=>  Location: PIN_E1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[21]	=>  Location: PIN_H2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[22]	=>  Location: PIN_N19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[22]	=>  Location: PIN_B7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[22]	=>  Location: PIN_H4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[23]	=>  Location: PIN_M21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[23]	=>  Location: PIN_B14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[23]	=>  Location: PIN_A5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[24]	=>  Location: PIN_D21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[24]	=>  Location: PIN_V13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[24]	=>  Location: PIN_K18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[25]	=>  Location: PIN_U14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[25]	=>  Location: PIN_F2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[25]	=>  Location: PIN_N21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[26]	=>  Location: PIN_Y21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[26]	=>  Location: PIN_J6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[26]	=>  Location: PIN_AA11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[27]	=>  Location: PIN_AB11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[27]	=>  Location: PIN_H6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[27]	=>  Location: PIN_W14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[28]	=>  Location: PIN_V14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[28]	=>  Location: PIN_V21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[28]	=>  Location: PIN_H1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[29]	=>  Location: PIN_K19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[29]	=>  Location: PIN_Y22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[29]	=>  Location: PIN_U20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[30]	=>  Location: PIN_N22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[30]	=>  Location: PIN_AA16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[30]	=>  Location: PIN_H21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_3_i[31]	=>  Location: PIN_J19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_2_i[31]	=>  Location: PIN_M22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- val_1_i[31]	=>  Location: PIN_V22,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF adder_ovf IS
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
SIGNAL ww_start_calc_i : std_logic;
SIGNAL ww_val_1_i : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_val_2_i : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_val_3_i : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_val_o : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_done_o : std_logic;
SIGNAL ww_ovf_o : std_logic;
SIGNAL ww_POS_OVF : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_NEG_OVF : std_logic_vector(31 DOWNTO 0);
SIGNAL \reset_n~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \sysclk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \sum_tmp_reg[9]~52_combout\ : std_logic;
SIGNAL \LessThan1~2_combout\ : std_logic;
SIGNAL \LessThan1~5_combout\ : std_logic;
SIGNAL \LessThan1~7_combout\ : std_logic;
SIGNAL \LessThan1~8_combout\ : std_logic;
SIGNAL \LessThan1~9_combout\ : std_logic;
SIGNAL \LessThan1~10_combout\ : std_logic;
SIGNAL \LessThan1~11_combout\ : std_logic;
SIGNAL \LessThan1~12_combout\ : std_logic;
SIGNAL \LessThan1~13_combout\ : std_logic;
SIGNAL \LessThan1~14_combout\ : std_logic;
SIGNAL \LessThan1~15_combout\ : std_logic;
SIGNAL \LessThan1~19_combout\ : std_logic;
SIGNAL \LessThan1~20_combout\ : std_logic;
SIGNAL \LessThan1~21_combout\ : std_logic;
SIGNAL \LessThan1~22_combout\ : std_logic;
SIGNAL \LessThan1~23_combout\ : std_logic;
SIGNAL \LessThan1~24_combout\ : std_logic;
SIGNAL \LessThan1~25_combout\ : std_logic;
SIGNAL \LessThan1~26_combout\ : std_logic;
SIGNAL \LessThan1~27_combout\ : std_logic;
SIGNAL \LessThan1~41_combout\ : std_logic;
SIGNAL \LessThan1~42_combout\ : std_logic;
SIGNAL \LessThan1~44_combout\ : std_logic;
SIGNAL \LessThan1~54_combout\ : std_logic;
SIGNAL \process_1~2_combout\ : std_logic;
SIGNAL \process_1~3_combout\ : std_logic;
SIGNAL \process_1~4_combout\ : std_logic;
SIGNAL \process_1~5_combout\ : std_logic;
SIGNAL \process_1~6_combout\ : std_logic;
SIGNAL \process_1~7_combout\ : std_logic;
SIGNAL \LessThan0~9_combout\ : std_logic;
SIGNAL \LessThan0~13_combout\ : std_logic;
SIGNAL \LessThan0~14_combout\ : std_logic;
SIGNAL \LessThan0~15_combout\ : std_logic;
SIGNAL \LessThan0~17_combout\ : std_logic;
SIGNAL \LessThan0~26_combout\ : std_logic;
SIGNAL \LessThan0~30_combout\ : std_logic;
SIGNAL \LessThan0~31_combout\ : std_logic;
SIGNAL \LessThan0~32_combout\ : std_logic;
SIGNAL \LessThan0~33_combout\ : std_logic;
SIGNAL \LessThan0~34_combout\ : std_logic;
SIGNAL \LessThan0~35_combout\ : std_logic;
SIGNAL \LessThan0~36_combout\ : std_logic;
SIGNAL \LessThan0~37_combout\ : std_logic;
SIGNAL \LessThan0~38_combout\ : std_logic;
SIGNAL \LessThan0~39_combout\ : std_logic;
SIGNAL \LessThan0~50_combout\ : std_logic;
SIGNAL \POS_OVF[31]~input_o\ : std_logic;
SIGNAL \POS_OVF[26]~input_o\ : std_logic;
SIGNAL \POS_OVF[27]~input_o\ : std_logic;
SIGNAL \POS_OVF[24]~input_o\ : std_logic;
SIGNAL \POS_OVF[23]~input_o\ : std_logic;
SIGNAL \POS_OVF[21]~input_o\ : std_logic;
SIGNAL \POS_OVF[18]~input_o\ : std_logic;
SIGNAL \POS_OVF[6]~input_o\ : std_logic;
SIGNAL \POS_OVF[4]~input_o\ : std_logic;
SIGNAL \POS_OVF[3]~input_o\ : std_logic;
SIGNAL \POS_OVF[1]~input_o\ : std_logic;
SIGNAL \POS_OVF[9]~input_o\ : std_logic;
SIGNAL \POS_OVF[8]~input_o\ : std_logic;
SIGNAL \NEG_OVF[31]~input_o\ : std_logic;
SIGNAL \NEG_OVF[30]~input_o\ : std_logic;
SIGNAL \NEG_OVF[20]~input_o\ : std_logic;
SIGNAL \NEG_OVF[0]~input_o\ : std_logic;
SIGNAL \NEG_OVF[10]~input_o\ : std_logic;
SIGNAL \NEG_OVF[13]~input_o\ : std_logic;
SIGNAL \NEG_OVF[12]~input_o\ : std_logic;
SIGNAL \NEG_OVF[9]~input_o\ : std_logic;
SIGNAL \NEG_OVF[8]~input_o\ : std_logic;
SIGNAL \NEG_OVF[26]~input_o\ : std_logic;
SIGNAL \NEG_OVF[24]~input_o\ : std_logic;
SIGNAL \NEG_OVF[23]~input_o\ : std_logic;
SIGNAL \val_2_i[0]~input_o\ : std_logic;
SIGNAL \val_3_i[1]~input_o\ : std_logic;
SIGNAL \val_2_i[1]~input_o\ : std_logic;
SIGNAL \val_3_i[2]~input_o\ : std_logic;
SIGNAL \val_1_i[2]~input_o\ : std_logic;
SIGNAL \val_3_i[3]~input_o\ : std_logic;
SIGNAL \val_2_i[3]~input_o\ : std_logic;
SIGNAL \val_2_i[4]~input_o\ : std_logic;
SIGNAL \val_3_i[5]~input_o\ : std_logic;
SIGNAL \val_1_i[5]~input_o\ : std_logic;
SIGNAL \val_1_i[6]~input_o\ : std_logic;
SIGNAL \val_3_i[7]~input_o\ : std_logic;
SIGNAL \val_1_i[7]~input_o\ : std_logic;
SIGNAL \val_2_i[8]~input_o\ : std_logic;
SIGNAL \val_3_i[9]~input_o\ : std_logic;
SIGNAL \val_1_i[9]~input_o\ : std_logic;
SIGNAL \val_3_i[10]~input_o\ : std_logic;
SIGNAL \val_1_i[10]~input_o\ : std_logic;
SIGNAL \val_2_i[11]~input_o\ : std_logic;
SIGNAL \val_2_i[12]~input_o\ : std_logic;
SIGNAL \val_1_i[13]~input_o\ : std_logic;
SIGNAL \val_1_i[14]~input_o\ : std_logic;
SIGNAL \val_3_i[15]~input_o\ : std_logic;
SIGNAL \val_1_i[15]~input_o\ : std_logic;
SIGNAL \val_1_i[16]~input_o\ : std_logic;
SIGNAL \val_2_i[17]~input_o\ : std_logic;
SIGNAL \val_1_i[18]~input_o\ : std_logic;
SIGNAL \val_3_i[19]~input_o\ : std_logic;
SIGNAL \val_2_i[19]~input_o\ : std_logic;
SIGNAL \val_2_i[20]~input_o\ : std_logic;
SIGNAL \val_1_i[21]~input_o\ : std_logic;
SIGNAL \val_3_i[22]~input_o\ : std_logic;
SIGNAL \val_2_i[22]~input_o\ : std_logic;
SIGNAL \val_3_i[23]~input_o\ : std_logic;
SIGNAL \val_1_i[23]~input_o\ : std_logic;
SIGNAL \val_1_i[24]~input_o\ : std_logic;
SIGNAL \val_3_i[25]~input_o\ : std_logic;
SIGNAL \val_2_i[25]~input_o\ : std_logic;
SIGNAL \val_2_i[26]~input_o\ : std_logic;
SIGNAL \val_3_i[27]~input_o\ : std_logic;
SIGNAL \val_1_i[27]~input_o\ : std_logic;
SIGNAL \val_2_i[28]~input_o\ : std_logic;
SIGNAL \val_3_i[29]~input_o\ : std_logic;
SIGNAL \val_1_i[29]~input_o\ : std_logic;
SIGNAL \val_1_i[30]~input_o\ : std_logic;
SIGNAL \val_1_i[31]~input_o\ : std_logic;
SIGNAL \val_3_reg[1]~feeder_combout\ : std_logic;
SIGNAL \val_2_reg[1]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[2]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[2]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[3]~feeder_combout\ : std_logic;
SIGNAL \val_2_reg[3]~feeder_combout\ : std_logic;
SIGNAL \val_2_reg[4]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[5]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[6]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[9]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[10]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[10]~feeder_combout\ : std_logic;
SIGNAL \val_2_reg[12]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[14]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[15]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[15]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[16]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[18]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[19]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[21]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[22]~feeder_combout\ : std_logic;
SIGNAL \val_2_reg[22]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[23]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[23]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[24]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[25]~feeder_combout\ : std_logic;
SIGNAL \val_2_reg[25]~feeder_combout\ : std_logic;
SIGNAL \val_2_reg[26]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[27]~feeder_combout\ : std_logic;
SIGNAL \val_3_reg[29]~feeder_combout\ : std_logic;
SIGNAL \val_1_reg[31]~feeder_combout\ : std_logic;
SIGNAL \val_o[0]~output_o\ : std_logic;
SIGNAL \val_o[1]~output_o\ : std_logic;
SIGNAL \val_o[2]~output_o\ : std_logic;
SIGNAL \val_o[3]~output_o\ : std_logic;
SIGNAL \val_o[4]~output_o\ : std_logic;
SIGNAL \val_o[5]~output_o\ : std_logic;
SIGNAL \val_o[6]~output_o\ : std_logic;
SIGNAL \val_o[7]~output_o\ : std_logic;
SIGNAL \val_o[8]~output_o\ : std_logic;
SIGNAL \val_o[9]~output_o\ : std_logic;
SIGNAL \val_o[10]~output_o\ : std_logic;
SIGNAL \val_o[11]~output_o\ : std_logic;
SIGNAL \val_o[12]~output_o\ : std_logic;
SIGNAL \val_o[13]~output_o\ : std_logic;
SIGNAL \val_o[14]~output_o\ : std_logic;
SIGNAL \val_o[15]~output_o\ : std_logic;
SIGNAL \val_o[16]~output_o\ : std_logic;
SIGNAL \val_o[17]~output_o\ : std_logic;
SIGNAL \val_o[18]~output_o\ : std_logic;
SIGNAL \val_o[19]~output_o\ : std_logic;
SIGNAL \val_o[20]~output_o\ : std_logic;
SIGNAL \val_o[21]~output_o\ : std_logic;
SIGNAL \val_o[22]~output_o\ : std_logic;
SIGNAL \val_o[23]~output_o\ : std_logic;
SIGNAL \val_o[24]~output_o\ : std_logic;
SIGNAL \val_o[25]~output_o\ : std_logic;
SIGNAL \val_o[26]~output_o\ : std_logic;
SIGNAL \val_o[27]~output_o\ : std_logic;
SIGNAL \val_o[28]~output_o\ : std_logic;
SIGNAL \val_o[29]~output_o\ : std_logic;
SIGNAL \val_o[30]~output_o\ : std_logic;
SIGNAL \val_o[31]~output_o\ : std_logic;
SIGNAL \done_o~output_o\ : std_logic;
SIGNAL \ovf_o~output_o\ : std_logic;
SIGNAL \sysclk~input_o\ : std_logic;
SIGNAL \sysclk~inputclkctrl_outclk\ : std_logic;
SIGNAL \val_3_i[0]~input_o\ : std_logic;
SIGNAL \val_3_reg[0]~feeder_combout\ : std_logic;
SIGNAL \reset_n~input_o\ : std_logic;
SIGNAL \reset_n~inputclkctrl_outclk\ : std_logic;
SIGNAL \sum_tmp_reg[0]~34_combout\ : std_logic;
SIGNAL \val_1_i[0]~input_o\ : std_logic;
SIGNAL \Add0~0_combout\ : std_logic;
SIGNAL \state_reg~10_combout\ : std_logic;
SIGNAL \state_reg.CHECK~q\ : std_logic;
SIGNAL \start_calc_i~input_o\ : std_logic;
SIGNAL \state_reg~9_combout\ : std_logic;
SIGNAL \state_reg.IDLE~q\ : std_logic;
SIGNAL \state_reg.IDLE~1_combout\ : std_logic;
SIGNAL \state_reg~11_combout\ : std_logic;
SIGNAL \state_reg.SUM_1~q\ : std_logic;
SIGNAL \state_reg~8_combout\ : std_logic;
SIGNAL \state_reg.SUM_2~q\ : std_logic;
SIGNAL \state_reg.IDLE~0_combout\ : std_logic;
SIGNAL \sum_tmp_reg[0]~35\ : std_logic;
SIGNAL \sum_tmp_reg[1]~36_combout\ : std_logic;
SIGNAL \val_1_i[1]~input_o\ : std_logic;
SIGNAL \Add0~1\ : std_logic;
SIGNAL \Add0~2_combout\ : std_logic;
SIGNAL \sum_tmp_reg[1]~37\ : std_logic;
SIGNAL \sum_tmp_reg[2]~38_combout\ : std_logic;
SIGNAL \val_2_i[2]~input_o\ : std_logic;
SIGNAL \Add0~3\ : std_logic;
SIGNAL \Add0~4_combout\ : std_logic;
SIGNAL \sum_tmp_reg[2]~39\ : std_logic;
SIGNAL \sum_tmp_reg[3]~40_combout\ : std_logic;
SIGNAL \val_1_i[3]~input_o\ : std_logic;
SIGNAL \Add0~5\ : std_logic;
SIGNAL \Add0~6_combout\ : std_logic;
SIGNAL \val_3_i[4]~input_o\ : std_logic;
SIGNAL \val_3_reg[4]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[3]~41\ : std_logic;
SIGNAL \sum_tmp_reg[4]~42_combout\ : std_logic;
SIGNAL \val_1_i[4]~input_o\ : std_logic;
SIGNAL \Add0~7\ : std_logic;
SIGNAL \Add0~8_combout\ : std_logic;
SIGNAL \sum_tmp_reg[4]~43\ : std_logic;
SIGNAL \sum_tmp_reg[5]~44_combout\ : std_logic;
SIGNAL \val_2_i[5]~input_o\ : std_logic;
SIGNAL \val_2_reg[5]~feeder_combout\ : std_logic;
SIGNAL \Add0~9\ : std_logic;
SIGNAL \Add0~10_combout\ : std_logic;
SIGNAL \val_3_i[6]~input_o\ : std_logic;
SIGNAL \sum_tmp_reg[5]~45\ : std_logic;
SIGNAL \sum_tmp_reg[6]~46_combout\ : std_logic;
SIGNAL \val_2_i[6]~input_o\ : std_logic;
SIGNAL \Add0~11\ : std_logic;
SIGNAL \Add0~12_combout\ : std_logic;
SIGNAL \sum_tmp_reg[6]~47\ : std_logic;
SIGNAL \sum_tmp_reg[7]~48_combout\ : std_logic;
SIGNAL \val_2_i[7]~input_o\ : std_logic;
SIGNAL \val_2_reg[7]~feeder_combout\ : std_logic;
SIGNAL \Add0~13\ : std_logic;
SIGNAL \Add0~14_combout\ : std_logic;
SIGNAL \val_3_i[8]~input_o\ : std_logic;
SIGNAL \val_3_reg[8]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[7]~49\ : std_logic;
SIGNAL \sum_tmp_reg[8]~50_combout\ : std_logic;
SIGNAL \val_1_i[8]~input_o\ : std_logic;
SIGNAL \Add0~15\ : std_logic;
SIGNAL \Add0~16_combout\ : std_logic;
SIGNAL \sum_tmp_reg[9]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[9]~input_o\ : std_logic;
SIGNAL \Add0~17\ : std_logic;
SIGNAL \Add0~18_combout\ : std_logic;
SIGNAL \sum_tmp_reg[8]~51\ : std_logic;
SIGNAL \sum_tmp_reg[9]~53\ : std_logic;
SIGNAL \sum_tmp_reg[10]~54_combout\ : std_logic;
SIGNAL \sum_tmp_reg[10]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[10]~input_o\ : std_logic;
SIGNAL \Add0~19\ : std_logic;
SIGNAL \Add0~20_combout\ : std_logic;
SIGNAL \val_3_i[11]~input_o\ : std_logic;
SIGNAL \val_3_reg[11]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[10]~55\ : std_logic;
SIGNAL \sum_tmp_reg[11]~56_combout\ : std_logic;
SIGNAL \sum_tmp_reg[11]~feeder_combout\ : std_logic;
SIGNAL \val_1_i[11]~input_o\ : std_logic;
SIGNAL \val_1_reg[11]~feeder_combout\ : std_logic;
SIGNAL \Add0~21\ : std_logic;
SIGNAL \Add0~22_combout\ : std_logic;
SIGNAL \val_3_i[12]~input_o\ : std_logic;
SIGNAL \val_3_reg[12]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[11]~57\ : std_logic;
SIGNAL \sum_tmp_reg[12]~58_combout\ : std_logic;
SIGNAL \sum_tmp_reg[12]~feeder_combout\ : std_logic;
SIGNAL \val_1_i[12]~input_o\ : std_logic;
SIGNAL \val_1_reg[12]~feeder_combout\ : std_logic;
SIGNAL \Add0~23\ : std_logic;
SIGNAL \Add0~24_combout\ : std_logic;
SIGNAL \val_3_i[13]~input_o\ : std_logic;
SIGNAL \val_3_reg[13]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[12]~59\ : std_logic;
SIGNAL \sum_tmp_reg[13]~60_combout\ : std_logic;
SIGNAL \sum_tmp_reg[13]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[13]~input_o\ : std_logic;
SIGNAL \Add0~25\ : std_logic;
SIGNAL \Add0~26_combout\ : std_logic;
SIGNAL \val_3_i[14]~input_o\ : std_logic;
SIGNAL \val_3_reg[14]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[13]~61\ : std_logic;
SIGNAL \sum_tmp_reg[14]~62_combout\ : std_logic;
SIGNAL \sum_tmp_reg[14]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[14]~input_o\ : std_logic;
SIGNAL \val_2_reg[14]~feeder_combout\ : std_logic;
SIGNAL \Add0~27\ : std_logic;
SIGNAL \Add0~28_combout\ : std_logic;
SIGNAL \sum_tmp_reg[14]~63\ : std_logic;
SIGNAL \sum_tmp_reg[15]~64_combout\ : std_logic;
SIGNAL \sum_tmp_reg[15]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[15]~input_o\ : std_logic;
SIGNAL \val_2_reg[15]~feeder_combout\ : std_logic;
SIGNAL \Add0~29\ : std_logic;
SIGNAL \Add0~30_combout\ : std_logic;
SIGNAL \val_3_i[16]~input_o\ : std_logic;
SIGNAL \val_3_reg[16]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[15]~65\ : std_logic;
SIGNAL \sum_tmp_reg[16]~66_combout\ : std_logic;
SIGNAL \sum_tmp_reg[16]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[16]~input_o\ : std_logic;
SIGNAL \Add0~31\ : std_logic;
SIGNAL \Add0~32_combout\ : std_logic;
SIGNAL \val_3_i[17]~input_o\ : std_logic;
SIGNAL \val_3_reg[17]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[16]~67\ : std_logic;
SIGNAL \sum_tmp_reg[17]~68_combout\ : std_logic;
SIGNAL \sum_tmp_reg[17]~feeder_combout\ : std_logic;
SIGNAL \val_1_i[17]~input_o\ : std_logic;
SIGNAL \val_1_reg[17]~feeder_combout\ : std_logic;
SIGNAL \Add0~33\ : std_logic;
SIGNAL \Add0~34_combout\ : std_logic;
SIGNAL \val_3_i[18]~input_o\ : std_logic;
SIGNAL \val_3_reg[18]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[17]~69\ : std_logic;
SIGNAL \sum_tmp_reg[18]~70_combout\ : std_logic;
SIGNAL \sum_tmp_reg[18]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[18]~input_o\ : std_logic;
SIGNAL \val_2_reg[18]~feeder_combout\ : std_logic;
SIGNAL \Add0~35\ : std_logic;
SIGNAL \Add0~36_combout\ : std_logic;
SIGNAL \sum_tmp_reg[18]~71\ : std_logic;
SIGNAL \sum_tmp_reg[19]~72_combout\ : std_logic;
SIGNAL \sum_tmp_reg[19]~feeder_combout\ : std_logic;
SIGNAL \val_1_i[19]~input_o\ : std_logic;
SIGNAL \val_1_reg[19]~feeder_combout\ : std_logic;
SIGNAL \Add0~37\ : std_logic;
SIGNAL \Add0~38_combout\ : std_logic;
SIGNAL \val_3_i[20]~input_o\ : std_logic;
SIGNAL \val_3_reg[20]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[19]~73\ : std_logic;
SIGNAL \sum_tmp_reg[20]~74_combout\ : std_logic;
SIGNAL \sum_tmp_reg[20]~feeder_combout\ : std_logic;
SIGNAL \val_1_i[20]~input_o\ : std_logic;
SIGNAL \Add0~39\ : std_logic;
SIGNAL \Add0~40_combout\ : std_logic;
SIGNAL \val_3_i[21]~input_o\ : std_logic;
SIGNAL \val_3_reg[21]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[20]~75\ : std_logic;
SIGNAL \sum_tmp_reg[21]~76_combout\ : std_logic;
SIGNAL \sum_tmp_reg[21]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[21]~input_o\ : std_logic;
SIGNAL \Add0~41\ : std_logic;
SIGNAL \Add0~42_combout\ : std_logic;
SIGNAL \sum_tmp_reg[21]~77\ : std_logic;
SIGNAL \sum_tmp_reg[22]~78_combout\ : std_logic;
SIGNAL \sum_tmp_reg[22]~feeder_combout\ : std_logic;
SIGNAL \val_1_i[22]~input_o\ : std_logic;
SIGNAL \Add0~43\ : std_logic;
SIGNAL \Add0~44_combout\ : std_logic;
SIGNAL \sum_tmp_reg[22]~79\ : std_logic;
SIGNAL \sum_tmp_reg[23]~80_combout\ : std_logic;
SIGNAL \val_2_i[23]~input_o\ : std_logic;
SIGNAL \val_2_reg[23]~feeder_combout\ : std_logic;
SIGNAL \Add0~45\ : std_logic;
SIGNAL \Add0~46_combout\ : std_logic;
SIGNAL \val_3_i[24]~input_o\ : std_logic;
SIGNAL \val_3_reg[24]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[23]~81\ : std_logic;
SIGNAL \sum_tmp_reg[24]~82_combout\ : std_logic;
SIGNAL \sum_tmp_reg[24]~feeder_combout\ : std_logic;
SIGNAL \val_2_i[24]~input_o\ : std_logic;
SIGNAL \Add0~47\ : std_logic;
SIGNAL \Add0~48_combout\ : std_logic;
SIGNAL \sum_tmp_reg[24]~83\ : std_logic;
SIGNAL \sum_tmp_reg[25]~84_combout\ : std_logic;
SIGNAL \val_1_i[25]~input_o\ : std_logic;
SIGNAL \Add0~49\ : std_logic;
SIGNAL \Add0~50_combout\ : std_logic;
SIGNAL \val_3_i[26]~input_o\ : std_logic;
SIGNAL \val_3_reg[26]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[25]~85\ : std_logic;
SIGNAL \sum_tmp_reg[26]~86_combout\ : std_logic;
SIGNAL \val_1_i[26]~input_o\ : std_logic;
SIGNAL \Add0~51\ : std_logic;
SIGNAL \Add0~52_combout\ : std_logic;
SIGNAL \sum_tmp_reg[26]~87\ : std_logic;
SIGNAL \sum_tmp_reg[27]~88_combout\ : std_logic;
SIGNAL \val_2_i[27]~input_o\ : std_logic;
SIGNAL \val_2_reg[27]~feeder_combout\ : std_logic;
SIGNAL \Add0~53\ : std_logic;
SIGNAL \Add0~54_combout\ : std_logic;
SIGNAL \val_3_i[28]~input_o\ : std_logic;
SIGNAL \val_3_reg[28]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[27]~89\ : std_logic;
SIGNAL \sum_tmp_reg[28]~90_combout\ : std_logic;
SIGNAL \val_1_i[28]~input_o\ : std_logic;
SIGNAL \Add0~55\ : std_logic;
SIGNAL \Add0~56_combout\ : std_logic;
SIGNAL \sum_tmp_reg[28]~91\ : std_logic;
SIGNAL \sum_tmp_reg[29]~92_combout\ : std_logic;
SIGNAL \val_2_i[29]~input_o\ : std_logic;
SIGNAL \val_2_reg[29]~feeder_combout\ : std_logic;
SIGNAL \Add0~57\ : std_logic;
SIGNAL \Add0~58_combout\ : std_logic;
SIGNAL \val_3_i[30]~input_o\ : std_logic;
SIGNAL \val_3_reg[30]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[29]~93\ : std_logic;
SIGNAL \sum_tmp_reg[30]~94_combout\ : std_logic;
SIGNAL \val_2_i[30]~input_o\ : std_logic;
SIGNAL \Add0~59\ : std_logic;
SIGNAL \Add0~60_combout\ : std_logic;
SIGNAL \val_3_i[31]~input_o\ : std_logic;
SIGNAL \val_3_reg[31]~feeder_combout\ : std_logic;
SIGNAL \sum_tmp_reg[30]~95\ : std_logic;
SIGNAL \sum_tmp_reg[31]~97\ : std_logic;
SIGNAL \sum_tmp_reg[32]~99\ : std_logic;
SIGNAL \sum_tmp_reg[33]~100_combout\ : std_logic;
SIGNAL \val_2_i[31]~input_o\ : std_logic;
SIGNAL \val_2_reg[31]~feeder_combout\ : std_logic;
SIGNAL \Add0~61\ : std_logic;
SIGNAL \Add0~63\ : std_logic;
SIGNAL \Add0~64_combout\ : std_logic;
SIGNAL \done_o_reg~feeder_combout\ : std_logic;
SIGNAL \done_o_reg~q\ : std_logic;
SIGNAL \POS_OVF[22]~input_o\ : std_logic;
SIGNAL \LessThan1~52_combout\ : std_logic;
SIGNAL \POS_OVF[28]~input_o\ : std_logic;
SIGNAL \POS_OVF[25]~input_o\ : std_logic;
SIGNAL \LessThan1~4_combout\ : std_logic;
SIGNAL \LessThan1~6_combout\ : std_logic;
SIGNAL \LessThan1~53_combout\ : std_logic;
SIGNAL \POS_OVF[30]~input_o\ : std_logic;
SIGNAL \POS_OVF[29]~input_o\ : std_logic;
SIGNAL \LessThan1~3_combout\ : std_logic;
SIGNAL \process_1~0_combout\ : std_logic;
SIGNAL \POS_OVF[13]~input_o\ : std_logic;
SIGNAL \LessThan1~46_combout\ : std_logic;
SIGNAL \POS_OVF[14]~input_o\ : std_logic;
SIGNAL \POS_OVF[11]~input_o\ : std_logic;
SIGNAL \POS_OVF[12]~input_o\ : std_logic;
SIGNAL \LessThan1~43_combout\ : std_logic;
SIGNAL \LessThan1~45_combout\ : std_logic;
SIGNAL \LessThan1~48_combout\ : std_logic;
SIGNAL \LessThan1~47_combout\ : std_logic;
SIGNAL \LessThan1~49_combout\ : std_logic;
SIGNAL \LessThan1~50_combout\ : std_logic;
SIGNAL \POS_OVF[16]~input_o\ : std_logic;
SIGNAL \POS_OVF[15]~input_o\ : std_logic;
SIGNAL \LessThan1~28_combout\ : std_logic;
SIGNAL \POS_OVF[17]~input_o\ : std_logic;
SIGNAL \POS_OVF[20]~input_o\ : std_logic;
SIGNAL \LessThan1~17_combout\ : std_logic;
SIGNAL \POS_OVF[19]~input_o\ : std_logic;
SIGNAL \LessThan1~16_combout\ : std_logic;
SIGNAL \LessThan1~18_combout\ : std_logic;
SIGNAL \LessThan1~29_combout\ : std_logic;
SIGNAL \POS_OVF[10]~input_o\ : std_logic;
SIGNAL \LessThan1~36_combout\ : std_logic;
SIGNAL \LessThan1~37_combout\ : std_logic;
SIGNAL \LessThan1~38_combout\ : std_logic;
SIGNAL \LessThan1~39_combout\ : std_logic;
SIGNAL \POS_OVF[7]~input_o\ : std_logic;
SIGNAL \POS_OVF[5]~input_o\ : std_logic;
SIGNAL \POS_OVF[2]~input_o\ : std_logic;
SIGNAL \POS_OVF[0]~input_o\ : std_logic;
SIGNAL \LessThan1~30_combout\ : std_logic;
SIGNAL \LessThan1~31_combout\ : std_logic;
SIGNAL \LessThan1~32_combout\ : std_logic;
SIGNAL \LessThan1~56_combout\ : std_logic;
SIGNAL \LessThan1~33_combout\ : std_logic;
SIGNAL \LessThan1~34_combout\ : std_logic;
SIGNAL \LessThan1~35_combout\ : std_logic;
SIGNAL \LessThan1~40_combout\ : std_logic;
SIGNAL \LessThan1~51_combout\ : std_logic;
SIGNAL \process_1~1_combout\ : std_logic;
SIGNAL \NEG_OVF[28]~input_o\ : std_logic;
SIGNAL \NEG_OVF[25]~input_o\ : std_logic;
SIGNAL \LessThan0~41_combout\ : std_logic;
SIGNAL \NEG_OVF[27]~input_o\ : std_logic;
SIGNAL \LessThan0~48_combout\ : std_logic;
SIGNAL \LessThan0~49_combout\ : std_logic;
SIGNAL \LessThan0~51_combout\ : std_logic;
SIGNAL \LessThan0~52_combout\ : std_logic;
SIGNAL \LessThan0~53_combout\ : std_logic;
SIGNAL \NEG_OVF[22]~input_o\ : std_logic;
SIGNAL \LessThan0~46_combout\ : std_logic;
SIGNAL \LessThan0~42_combout\ : std_logic;
SIGNAL \LessThan0~43_combout\ : std_logic;
SIGNAL \LessThan0~47_combout\ : std_logic;
SIGNAL \LessThan0~54_combout\ : std_logic;
SIGNAL \NEG_OVF[29]~input_o\ : std_logic;
SIGNAL \LessThan0~3_combout\ : std_logic;
SIGNAL \sum_tmp_reg[32]~98_combout\ : std_logic;
SIGNAL \sum_tmp_reg[31]~96_combout\ : std_logic;
SIGNAL \Add0~62_combout\ : std_logic;
SIGNAL \LessThan0~2_combout\ : std_logic;
SIGNAL \LessThan1~55_combout\ : std_logic;
SIGNAL \LessThan0~44_combout\ : std_logic;
SIGNAL \NEG_OVF[16]~input_o\ : std_logic;
SIGNAL \NEG_OVF[21]~input_o\ : std_logic;
SIGNAL \NEG_OVF[19]~input_o\ : std_logic;
SIGNAL \LessThan0~5_combout\ : std_logic;
SIGNAL \NEG_OVF[18]~input_o\ : std_logic;
SIGNAL \LessThan0~4_combout\ : std_logic;
SIGNAL \LessThan0~6_combout\ : std_logic;
SIGNAL \LessThan0~18_combout\ : std_logic;
SIGNAL \LessThan0~12_combout\ : std_logic;
SIGNAL \NEG_OVF[17]~input_o\ : std_logic;
SIGNAL \LessThan0~10_combout\ : std_logic;
SIGNAL \LessThan0~11_combout\ : std_logic;
SIGNAL \NEG_OVF[15]~input_o\ : std_logic;
SIGNAL \LessThan0~7_combout\ : std_logic;
SIGNAL \LessThan0~8_combout\ : std_logic;
SIGNAL \LessThan0~16_combout\ : std_logic;
SIGNAL \NEG_OVF[14]~input_o\ : std_logic;
SIGNAL \NEG_OVF[11]~input_o\ : std_logic;
SIGNAL \LessThan0~25_combout\ : std_logic;
SIGNAL \LessThan0~27_combout\ : std_logic;
SIGNAL \LessThan0~28_combout\ : std_logic;
SIGNAL \NEG_OVF[7]~input_o\ : std_logic;
SIGNAL \NEG_OVF[6]~input_o\ : std_logic;
SIGNAL \NEG_OVF[5]~input_o\ : std_logic;
SIGNAL \NEG_OVF[4]~input_o\ : std_logic;
SIGNAL \NEG_OVF[3]~input_o\ : std_logic;
SIGNAL \NEG_OVF[2]~input_o\ : std_logic;
SIGNAL \NEG_OVF[1]~input_o\ : std_logic;
SIGNAL \LessThan0~19_combout\ : std_logic;
SIGNAL \LessThan0~20_combout\ : std_logic;
SIGNAL \LessThan0~21_combout\ : std_logic;
SIGNAL \LessThan0~55_combout\ : std_logic;
SIGNAL \LessThan0~22_combout\ : std_logic;
SIGNAL \LessThan0~23_combout\ : std_logic;
SIGNAL \LessThan0~24_combout\ : std_logic;
SIGNAL \LessThan0~29_combout\ : std_logic;
SIGNAL \LessThan0~40_combout\ : std_logic;
SIGNAL \LessThan0~45_combout\ : std_logic;
SIGNAL \process_1~8_combout\ : std_logic;
SIGNAL \ovf_sign_next~0_combout\ : std_logic;
SIGNAL \ovf_sign_reg~q\ : std_logic;
SIGNAL val_3_reg : std_logic_vector(31 DOWNTO 0);
SIGNAL val_2_reg : std_logic_vector(31 DOWNTO 0);
SIGNAL val_1_reg : std_logic_vector(31 DOWNTO 0);
SIGNAL sum_tmp_reg : std_logic_vector(33 DOWNTO 0);
SIGNAL \ALT_INV_state_reg.SUM_2~q\ : std_logic;

BEGIN

ww_sysclk <= sysclk;
ww_reset_n <= reset_n;
ww_start_calc_i <= start_calc_i;
ww_val_1_i <= val_1_i;
ww_val_2_i <= val_2_i;
ww_val_3_i <= val_3_i;
val_o <= ww_val_o;
done_o <= ww_done_o;
ovf_o <= ww_ovf_o;
ww_POS_OVF <= POS_OVF;
ww_NEG_OVF <= NEG_OVF;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\reset_n~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \reset_n~input_o\);

\sysclk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \sysclk~input_o\);
\ALT_INV_state_reg.SUM_2~q\ <= NOT \state_reg.SUM_2~q\;

-- Location: LCCOMB_X67_Y53_N0
\sum_tmp_reg[9]~52\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[9]~52_combout\ = (val_3_reg(9) & ((sum_tmp_reg(9) & (\sum_tmp_reg[8]~51\ & VCC)) # (!sum_tmp_reg(9) & (!\sum_tmp_reg[8]~51\)))) # (!val_3_reg(9) & ((sum_tmp_reg(9) & (!\sum_tmp_reg[8]~51\)) # (!sum_tmp_reg(9) & ((\sum_tmp_reg[8]~51\) # 
-- (GND)))))
-- \sum_tmp_reg[9]~53\ = CARRY((val_3_reg(9) & (!sum_tmp_reg(9) & !\sum_tmp_reg[8]~51\)) # (!val_3_reg(9) & ((!\sum_tmp_reg[8]~51\) # (!sum_tmp_reg(9)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(9),
	datab => sum_tmp_reg(9),
	datad => VCC,
	cin => \sum_tmp_reg[8]~51\,
	combout => \sum_tmp_reg[9]~52_combout\,
	cout => \sum_tmp_reg[9]~53\);

-- Location: FF_X66_Y54_N17
\val_2_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[0]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(0));

-- Location: FF_X67_Y54_N11
\val_3_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[1]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(1));

-- Location: FF_X66_Y54_N11
\val_2_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[1]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(1));

-- Location: FF_X67_Y54_N13
\val_3_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[2]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(2));

-- Location: FF_X66_Y54_N9
\val_1_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[2]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(2));

-- Location: FF_X67_Y54_N7
\val_3_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[3]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(3));

-- Location: FF_X66_Y54_N7
\val_2_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[3]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(3));

-- Location: FF_X66_Y54_N13
\val_2_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[4]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(4));

-- Location: FF_X68_Y54_N5
\val_3_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[5]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(5));

-- Location: FF_X66_Y54_N27
\val_1_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[5]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(5));

-- Location: FF_X66_Y54_N5
\val_1_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[6]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(6));

-- Location: FF_X68_Y54_N21
\val_3_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_3_i[7]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(7));

-- Location: FF_X66_Y54_N31
\val_1_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[7]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(7));

-- Location: FF_X66_Y53_N7
\val_2_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[8]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(8));

-- Location: FF_X68_Y53_N5
\val_3_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[9]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(9));

-- Location: FF_X66_Y53_N21
\val_1_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[9]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(9));

-- Location: FF_X68_Y53_N3
\val_3_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[10]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(10));

-- Location: FF_X65_Y53_N1
\val_1_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[10]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(10));

-- Location: FF_X66_Y53_N11
\val_2_reg[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[11]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(11));

-- Location: FF_X65_Y53_N17
\val_2_reg[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[12]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(12));

-- Location: FF_X66_Y53_N29
\val_1_reg[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[13]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(13));

-- Location: FF_X65_Y53_N3
\val_1_reg[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[14]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(14));

-- Location: FF_X68_Y53_N21
\val_3_reg[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[15]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(15));

-- Location: FF_X65_Y53_N15
\val_1_reg[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[15]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(15));

-- Location: FF_X65_Y53_N13
\val_1_reg[16]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[16]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(16));

-- Location: FF_X66_Y53_N27
\val_2_reg[17]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[17]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(17));

-- Location: FF_X65_Y53_N9
\val_1_reg[18]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[18]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(18));

-- Location: FF_X63_Y53_N17
\val_3_reg[19]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[19]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(19));

-- Location: FF_X65_Y53_N27
\val_2_reg[19]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[19]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(19));

-- Location: FF_X65_Y53_N11
\val_2_reg[20]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[20]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(20));

-- Location: FF_X63_Y53_N3
\val_1_reg[21]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[21]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(21));

-- Location: FF_X68_Y53_N31
\val_3_reg[22]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[22]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(22));

-- Location: FF_X62_Y53_N21
\val_2_reg[22]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[22]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(22));

-- Location: FF_X68_Y53_N9
\val_3_reg[23]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[23]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(23));

-- Location: FF_X63_Y53_N1
\val_1_reg[23]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[23]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(23));

-- Location: FF_X66_Y52_N31
\val_1_reg[24]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[24]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(24));

-- Location: FF_X67_Y52_N27
\val_3_reg[25]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[25]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(25));

-- Location: FF_X66_Y52_N25
\val_2_reg[25]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[25]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(25));

-- Location: FF_X66_Y52_N27
\val_2_reg[26]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[26]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(26));

-- Location: FF_X67_Y52_N31
\val_3_reg[27]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[27]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(27));

-- Location: FF_X66_Y52_N7
\val_1_reg[27]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[27]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(27));

-- Location: FF_X66_Y52_N9
\val_2_reg[28]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[28]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(28));

-- Location: FF_X67_Y52_N23
\val_3_reg[29]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[29]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(29));

-- Location: FF_X66_Y52_N11
\val_1_reg[29]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[29]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(29));

-- Location: FF_X66_Y52_N13
\val_1_reg[30]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[30]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(30));

-- Location: FF_X66_Y52_N23
\val_1_reg[31]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[31]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(31));

-- Location: LCCOMB_X68_Y50_N12
\LessThan1~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~2_combout\ = (\POS_OVF[31]~input_o\ & (sum_tmp_reg(33) & (sum_tmp_reg(32) & sum_tmp_reg(31)))) # (!\POS_OVF[31]~input_o\ & (!sum_tmp_reg(33) & (!sum_tmp_reg(32) & !sum_tmp_reg(31))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[31]~input_o\,
	datab => sum_tmp_reg(33),
	datac => sum_tmp_reg(32),
	datad => sum_tmp_reg(31),
	combout => \LessThan1~2_combout\);

-- Location: LCCOMB_X68_Y58_N10
\LessThan1~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~5_combout\ = (sum_tmp_reg(24) & ((\POS_OVF[27]~input_o\ $ (sum_tmp_reg(27))) # (!\POS_OVF[24]~input_o\))) # (!sum_tmp_reg(24) & ((\POS_OVF[24]~input_o\) # (\POS_OVF[27]~input_o\ $ (sum_tmp_reg(27)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110111111110110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(24),
	datab => \POS_OVF[24]~input_o\,
	datac => \POS_OVF[27]~input_o\,
	datad => sum_tmp_reg(27),
	combout => \LessThan1~5_combout\);

-- Location: LCCOMB_X68_Y58_N26
\LessThan1~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~7_combout\ = (!\POS_OVF[22]~input_o\ & sum_tmp_reg(22))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \POS_OVF[22]~input_o\,
	datad => sum_tmp_reg(22),
	combout => \LessThan1~7_combout\);

-- Location: LCCOMB_X68_Y58_N12
\LessThan1~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~8_combout\ = (\LessThan1~6_combout\ & ((sum_tmp_reg(23) & ((\LessThan1~7_combout\) # (!\POS_OVF[23]~input_o\))) # (!sum_tmp_reg(23) & (!\POS_OVF[23]~input_o\ & \LessThan1~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(23),
	datab => \POS_OVF[23]~input_o\,
	datac => \LessThan1~7_combout\,
	datad => \LessThan1~6_combout\,
	combout => \LessThan1~8_combout\);

-- Location: LCCOMB_X68_Y58_N22
\LessThan1~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~9_combout\ = (!\POS_OVF[24]~input_o\ & (sum_tmp_reg(24) & (sum_tmp_reg(27) $ (!\POS_OVF[27]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(27),
	datab => \POS_OVF[24]~input_o\,
	datac => \POS_OVF[27]~input_o\,
	datad => sum_tmp_reg(24),
	combout => \LessThan1~9_combout\);

-- Location: LCCOMB_X68_Y58_N28
\LessThan1~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~10_combout\ = (\LessThan1~9_combout\ & (!\LessThan1~4_combout\ & (\POS_OVF[28]~input_o\ $ (!sum_tmp_reg(28)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[28]~input_o\,
	datab => sum_tmp_reg(28),
	datac => \LessThan1~9_combout\,
	datad => \LessThan1~4_combout\,
	combout => \LessThan1~10_combout\);

-- Location: LCCOMB_X68_Y58_N30
\LessThan1~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~11_combout\ = (\POS_OVF[28]~input_o\ & (!\POS_OVF[27]~input_o\ & (sum_tmp_reg(28) & sum_tmp_reg(27)))) # (!\POS_OVF[28]~input_o\ & ((sum_tmp_reg(28)) # ((!\POS_OVF[27]~input_o\ & sum_tmp_reg(27)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111000100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[27]~input_o\,
	datab => \POS_OVF[28]~input_o\,
	datac => sum_tmp_reg(28),
	datad => sum_tmp_reg(27),
	combout => \LessThan1~11_combout\);

-- Location: LCCOMB_X68_Y58_N24
\LessThan1~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~12_combout\ = (\POS_OVF[27]~input_o\ & (sum_tmp_reg(27) & (\POS_OVF[28]~input_o\ $ (!sum_tmp_reg(28))))) # (!\POS_OVF[27]~input_o\ & (!sum_tmp_reg(27) & (\POS_OVF[28]~input_o\ $ (!sum_tmp_reg(28)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[27]~input_o\,
	datab => \POS_OVF[28]~input_o\,
	datac => sum_tmp_reg(28),
	datad => sum_tmp_reg(27),
	combout => \LessThan1~12_combout\);

-- Location: LCCOMB_X68_Y58_N18
\LessThan1~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~13_combout\ = (sum_tmp_reg(25) & !\POS_OVF[25]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => sum_tmp_reg(25),
	datad => \POS_OVF[25]~input_o\,
	combout => \LessThan1~13_combout\);

-- Location: LCCOMB_X68_Y58_N8
\LessThan1~14\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~14_combout\ = (\LessThan1~12_combout\ & ((sum_tmp_reg(26) & ((\LessThan1~13_combout\) # (!\POS_OVF[26]~input_o\))) # (!sum_tmp_reg(26) & (\LessThan1~13_combout\ & !\POS_OVF[26]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000111000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(26),
	datab => \LessThan1~13_combout\,
	datac => \POS_OVF[26]~input_o\,
	datad => \LessThan1~12_combout\,
	combout => \LessThan1~14_combout\);

-- Location: LCCOMB_X68_Y58_N14
\LessThan1~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~15_combout\ = (\LessThan1~11_combout\) # ((\LessThan1~10_combout\) # ((\LessThan1~14_combout\) # (\LessThan1~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~11_combout\,
	datab => \LessThan1~10_combout\,
	datac => \LessThan1~14_combout\,
	datad => \LessThan1~8_combout\,
	combout => \LessThan1~15_combout\);

-- Location: LCCOMB_X71_Y53_N30
\LessThan1~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~19_combout\ = (sum_tmp_reg(15) & !\POS_OVF[15]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => sum_tmp_reg(15),
	datad => \POS_OVF[15]~input_o\,
	combout => \LessThan1~19_combout\);

-- Location: LCCOMB_X71_Y53_N16
\LessThan1~20\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~20_combout\ = (\LessThan1~18_combout\ & ((\LessThan1~19_combout\ & ((sum_tmp_reg(16)) # (!\POS_OVF[16]~input_o\))) # (!\LessThan1~19_combout\ & (!\POS_OVF[16]~input_o\ & sum_tmp_reg(16)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~19_combout\,
	datab => \POS_OVF[16]~input_o\,
	datac => sum_tmp_reg(16),
	datad => \LessThan1~18_combout\,
	combout => \LessThan1~20_combout\);

-- Location: LCCOMB_X71_Y53_N26
\LessThan1~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~21_combout\ = (!\POS_OVF[17]~input_o\ & (sum_tmp_reg(17) & (sum_tmp_reg(20) $ (!\POS_OVF[20]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(20),
	datab => \POS_OVF[17]~input_o\,
	datac => \POS_OVF[20]~input_o\,
	datad => sum_tmp_reg(17),
	combout => \LessThan1~21_combout\);

-- Location: LCCOMB_X71_Y53_N20
\LessThan1~22\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~22_combout\ = (\LessThan1~21_combout\ & (!\LessThan1~16_combout\ & (\POS_OVF[21]~input_o\ $ (!sum_tmp_reg(21)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[21]~input_o\,
	datab => sum_tmp_reg(21),
	datac => \LessThan1~21_combout\,
	datad => \LessThan1~16_combout\,
	combout => \LessThan1~22_combout\);

-- Location: LCCOMB_X71_Y53_N22
\LessThan1~23\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~23_combout\ = (\POS_OVF[21]~input_o\ & (!\POS_OVF[20]~input_o\ & (sum_tmp_reg(21) & sum_tmp_reg(20)))) # (!\POS_OVF[21]~input_o\ & ((sum_tmp_reg(21)) # ((!\POS_OVF[20]~input_o\ & sum_tmp_reg(20)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111000101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[21]~input_o\,
	datab => \POS_OVF[20]~input_o\,
	datac => sum_tmp_reg(21),
	datad => sum_tmp_reg(20),
	combout => \LessThan1~23_combout\);

-- Location: LCCOMB_X71_Y53_N12
\LessThan1~24\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~24_combout\ = (\POS_OVF[21]~input_o\ & (sum_tmp_reg(21) & (\POS_OVF[20]~input_o\ $ (!sum_tmp_reg(20))))) # (!\POS_OVF[21]~input_o\ & (!sum_tmp_reg(21) & (\POS_OVF[20]~input_o\ $ (!sum_tmp_reg(20)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000010000100001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[21]~input_o\,
	datab => \POS_OVF[20]~input_o\,
	datac => sum_tmp_reg(21),
	datad => sum_tmp_reg(20),
	combout => \LessThan1~24_combout\);

-- Location: LCCOMB_X71_Y53_N2
\LessThan1~25\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~25_combout\ = (!\POS_OVF[18]~input_o\ & sum_tmp_reg(18))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \POS_OVF[18]~input_o\,
	datad => sum_tmp_reg(18),
	combout => \LessThan1~25_combout\);

-- Location: LCCOMB_X71_Y53_N4
\LessThan1~26\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~26_combout\ = (\LessThan1~24_combout\ & ((\POS_OVF[19]~input_o\ & (sum_tmp_reg(19) & \LessThan1~25_combout\)) # (!\POS_OVF[19]~input_o\ & ((sum_tmp_reg(19)) # (\LessThan1~25_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010001000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~24_combout\,
	datab => \POS_OVF[19]~input_o\,
	datac => sum_tmp_reg(19),
	datad => \LessThan1~25_combout\,
	combout => \LessThan1~26_combout\);

-- Location: LCCOMB_X71_Y53_N10
\LessThan1~27\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~27_combout\ = (\LessThan1~23_combout\) # ((\LessThan1~22_combout\) # ((\LessThan1~26_combout\) # (\LessThan1~20_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~23_combout\,
	datab => \LessThan1~22_combout\,
	datac => \LessThan1~26_combout\,
	datad => \LessThan1~20_combout\,
	combout => \LessThan1~27_combout\);

-- Location: LCCOMB_X69_Y54_N0
\LessThan1~41\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~41_combout\ = (!\POS_OVF[8]~input_o\ & sum_tmp_reg(8))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \POS_OVF[8]~input_o\,
	datad => sum_tmp_reg(8),
	combout => \LessThan1~41_combout\);

-- Location: LCCOMB_X70_Y54_N10
\LessThan1~42\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~42_combout\ = (\LessThan1~38_combout\ & ((\POS_OVF[9]~input_o\ & (sum_tmp_reg(9) & \LessThan1~41_combout\)) # (!\POS_OVF[9]~input_o\ & ((sum_tmp_reg(9)) # (\LessThan1~41_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[9]~input_o\,
	datab => sum_tmp_reg(9),
	datac => \LessThan1~41_combout\,
	datad => \LessThan1~38_combout\,
	combout => \LessThan1~42_combout\);

-- Location: LCCOMB_X70_Y54_N26
\LessThan1~44\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~44_combout\ = (sum_tmp_reg(10) & (!\POS_OVF[10]~input_o\ & (\POS_OVF[13]~input_o\ $ (!sum_tmp_reg(13)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(10),
	datab => \POS_OVF[10]~input_o\,
	datac => \POS_OVF[13]~input_o\,
	datad => sum_tmp_reg(13),
	combout => \LessThan1~44_combout\);

-- Location: LCCOMB_X68_Y50_N8
\LessThan1~54\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~54_combout\ = (\NEG_OVF[29]~input_o\ & !sum_tmp_reg(29))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \NEG_OVF[29]~input_o\,
	datad => sum_tmp_reg(29),
	combout => \LessThan1~54_combout\);

-- Location: LCCOMB_X68_Y50_N26
\process_1~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~2_combout\ = (\LessThan0~2_combout\ & ((\NEG_OVF[30]~input_o\ & ((\LessThan1~54_combout\) # (!sum_tmp_reg(30)))) # (!\NEG_OVF[30]~input_o\ & (!sum_tmp_reg(30) & \LessThan1~54_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[30]~input_o\,
	datab => sum_tmp_reg(30),
	datac => \LessThan1~54_combout\,
	datad => \LessThan0~2_combout\,
	combout => \process_1~2_combout\);

-- Location: LCCOMB_X68_Y50_N20
\process_1~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~3_combout\ = (!\POS_OVF[29]~input_o\ & sum_tmp_reg(29))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \POS_OVF[29]~input_o\,
	datad => sum_tmp_reg(29),
	combout => \process_1~3_combout\);

-- Location: LCCOMB_X68_Y50_N10
\process_1~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~4_combout\ = (\LessThan1~2_combout\ & ((sum_tmp_reg(30) & ((\process_1~3_combout\) # (!\POS_OVF[30]~input_o\))) # (!sum_tmp_reg(30) & (!\POS_OVF[30]~input_o\ & \process_1~3_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000101000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~2_combout\,
	datab => sum_tmp_reg(30),
	datac => \POS_OVF[30]~input_o\,
	datad => \process_1~3_combout\,
	combout => \process_1~4_combout\);

-- Location: LCCOMB_X68_Y50_N28
\process_1~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~5_combout\ = (!sum_tmp_reg(33) & ((\POS_OVF[31]~input_o\) # ((sum_tmp_reg(32)) # (sum_tmp_reg(31)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[31]~input_o\,
	datab => sum_tmp_reg(33),
	datac => sum_tmp_reg(32),
	datad => sum_tmp_reg(31),
	combout => \process_1~5_combout\);

-- Location: LCCOMB_X68_Y50_N30
\process_1~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~6_combout\ = (sum_tmp_reg(33) & (((!sum_tmp_reg(31)) # (!sum_tmp_reg(32))) # (!\NEG_OVF[31]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[31]~input_o\,
	datab => sum_tmp_reg(33),
	datac => sum_tmp_reg(32),
	datad => sum_tmp_reg(31),
	combout => \process_1~6_combout\);

-- Location: LCCOMB_X68_Y50_N0
\process_1~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~7_combout\ = (\process_1~6_combout\) # ((\process_1~5_combout\) # ((\process_1~2_combout\) # (\process_1~4_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \process_1~6_combout\,
	datab => \process_1~5_combout\,
	datac => \process_1~2_combout\,
	datad => \process_1~4_combout\,
	combout => \process_1~7_combout\);

-- Location: LCCOMB_X70_Y53_N22
\LessThan0~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~9_combout\ = (\NEG_OVF[18]~input_o\ & ((\NEG_OVF[19]~input_o\ $ (sum_tmp_reg(19))) # (!sum_tmp_reg(18)))) # (!\NEG_OVF[18]~input_o\ & ((sum_tmp_reg(18)) # (\NEG_OVF[19]~input_o\ $ (sum_tmp_reg(19)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111110110111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[18]~input_o\,
	datab => \NEG_OVF[19]~input_o\,
	datac => sum_tmp_reg(19),
	datad => sum_tmp_reg(18),
	combout => \LessThan0~9_combout\);

-- Location: LCCOMB_X70_Y53_N26
\LessThan0~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~13_combout\ = (\NEG_OVF[20]~input_o\ & (sum_tmp_reg(20) & (\NEG_OVF[21]~input_o\ $ (!sum_tmp_reg(21))))) # (!\NEG_OVF[20]~input_o\ & (!sum_tmp_reg(20) & (\NEG_OVF[21]~input_o\ $ (!sum_tmp_reg(21)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001000000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[20]~input_o\,
	datab => sum_tmp_reg(20),
	datac => \NEG_OVF[21]~input_o\,
	datad => sum_tmp_reg(21),
	combout => \LessThan0~13_combout\);

-- Location: LCCOMB_X70_Y53_N24
\LessThan0~14\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~14_combout\ = (\NEG_OVF[18]~input_o\ & !sum_tmp_reg(18))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \NEG_OVF[18]~input_o\,
	datad => sum_tmp_reg(18),
	combout => \LessThan0~14_combout\);

-- Location: LCCOMB_X70_Y53_N18
\LessThan0~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~15_combout\ = (\LessThan0~13_combout\ & ((\NEG_OVF[19]~input_o\ & ((\LessThan0~14_combout\) # (!sum_tmp_reg(19)))) # (!\NEG_OVF[19]~input_o\ & (!sum_tmp_reg(19) & \LessThan0~14_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000101000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~13_combout\,
	datab => \NEG_OVF[19]~input_o\,
	datac => sum_tmp_reg(19),
	datad => \LessThan0~14_combout\,
	combout => \LessThan0~15_combout\);

-- Location: LCCOMB_X70_Y54_N30
\LessThan0~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~17_combout\ = \NEG_OVF[15]~input_o\ $ (sum_tmp_reg(15))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \NEG_OVF[15]~input_o\,
	datad => sum_tmp_reg(15),
	combout => \LessThan0~17_combout\);

-- Location: LCCOMB_X69_Y53_N26
\LessThan0~26\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~26_combout\ = (sum_tmp_reg(12) & ((\NEG_OVF[13]~input_o\ $ (sum_tmp_reg(13))) # (!\NEG_OVF[12]~input_o\))) # (!sum_tmp_reg(12) & ((\NEG_OVF[12]~input_o\) # (\NEG_OVF[13]~input_o\ $ (sum_tmp_reg(13)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(12),
	datab => \NEG_OVF[13]~input_o\,
	datac => \NEG_OVF[12]~input_o\,
	datad => sum_tmp_reg(13),
	combout => \LessThan0~26_combout\);

-- Location: LCCOMB_X69_Y54_N30
\LessThan0~30\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~30_combout\ = (\NEG_OVF[8]~input_o\ & !sum_tmp_reg(8))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[8]~input_o\,
	datad => sum_tmp_reg(8),
	combout => \LessThan0~30_combout\);

-- Location: LCCOMB_X69_Y54_N4
\LessThan0~31\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~31_combout\ = (\LessThan0~27_combout\ & ((\NEG_OVF[9]~input_o\ & ((\LessThan0~30_combout\) # (!sum_tmp_reg(9)))) # (!\NEG_OVF[9]~input_o\ & (!sum_tmp_reg(9) & \LessThan0~30_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[9]~input_o\,
	datab => sum_tmp_reg(9),
	datac => \LessThan0~30_combout\,
	datad => \LessThan0~27_combout\,
	combout => \LessThan0~31_combout\);

-- Location: LCCOMB_X69_Y53_N22
\LessThan0~32\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~32_combout\ = (\NEG_OVF[11]~input_o\ & ((\NEG_OVF[12]~input_o\ $ (sum_tmp_reg(12))) # (!sum_tmp_reg(11)))) # (!\NEG_OVF[11]~input_o\ & ((sum_tmp_reg(11)) # (\NEG_OVF[12]~input_o\ $ (sum_tmp_reg(12)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[11]~input_o\,
	datab => \NEG_OVF[12]~input_o\,
	datac => sum_tmp_reg(11),
	datad => sum_tmp_reg(12),
	combout => \LessThan0~32_combout\);

-- Location: LCCOMB_X69_Y53_N4
\LessThan0~33\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~33_combout\ = (\NEG_OVF[10]~input_o\ & (!sum_tmp_reg(10) & (\NEG_OVF[13]~input_o\ $ (!sum_tmp_reg(13)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[10]~input_o\,
	datab => \NEG_OVF[13]~input_o\,
	datac => sum_tmp_reg(10),
	datad => sum_tmp_reg(13),
	combout => \LessThan0~33_combout\);

-- Location: LCCOMB_X69_Y53_N18
\LessThan0~34\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~34_combout\ = (!\LessThan0~32_combout\ & (\LessThan0~33_combout\ & (\NEG_OVF[14]~input_o\ $ (!sum_tmp_reg(14)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~32_combout\,
	datab => \NEG_OVF[14]~input_o\,
	datac => \LessThan0~33_combout\,
	datad => sum_tmp_reg(14),
	combout => \LessThan0~34_combout\);

-- Location: LCCOMB_X69_Y53_N24
\LessThan0~35\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~35_combout\ = (\NEG_OVF[14]~input_o\ & (((!sum_tmp_reg(13) & \NEG_OVF[13]~input_o\)) # (!sum_tmp_reg(14)))) # (!\NEG_OVF[14]~input_o\ & (!sum_tmp_reg(13) & (\NEG_OVF[13]~input_o\ & !sum_tmp_reg(14))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000011011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(13),
	datab => \NEG_OVF[14]~input_o\,
	datac => \NEG_OVF[13]~input_o\,
	datad => sum_tmp_reg(14),
	combout => \LessThan0~35_combout\);

-- Location: LCCOMB_X69_Y53_N30
\LessThan0~36\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~36_combout\ = (sum_tmp_reg(13) & (\NEG_OVF[13]~input_o\ & (\NEG_OVF[14]~input_o\ $ (!sum_tmp_reg(14))))) # (!sum_tmp_reg(13) & (!\NEG_OVF[13]~input_o\ & (\NEG_OVF[14]~input_o\ $ (!sum_tmp_reg(14)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000010000100001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(13),
	datab => \NEG_OVF[14]~input_o\,
	datac => \NEG_OVF[13]~input_o\,
	datad => sum_tmp_reg(14),
	combout => \LessThan0~36_combout\);

-- Location: LCCOMB_X69_Y53_N16
\LessThan0~37\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~37_combout\ = (\NEG_OVF[11]~input_o\ & !sum_tmp_reg(11))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[11]~input_o\,
	datac => sum_tmp_reg(11),
	combout => \LessThan0~37_combout\);

-- Location: LCCOMB_X69_Y53_N10
\LessThan0~38\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~38_combout\ = (\LessThan0~36_combout\ & ((\LessThan0~37_combout\ & ((\NEG_OVF[12]~input_o\) # (!sum_tmp_reg(12)))) # (!\LessThan0~37_combout\ & (\NEG_OVF[12]~input_o\ & !sum_tmp_reg(12)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000010101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~36_combout\,
	datab => \LessThan0~37_combout\,
	datac => \NEG_OVF[12]~input_o\,
	datad => sum_tmp_reg(12),
	combout => \LessThan0~38_combout\);

-- Location: LCCOMB_X69_Y54_N26
\LessThan0~39\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~39_combout\ = (\LessThan0~35_combout\) # ((\LessThan0~38_combout\) # ((\LessThan0~31_combout\) # (\LessThan0~34_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~35_combout\,
	datab => \LessThan0~38_combout\,
	datac => \LessThan0~31_combout\,
	datad => \LessThan0~34_combout\,
	combout => \LessThan0~39_combout\);

-- Location: LCCOMB_X67_Y55_N26
\LessThan0~50\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~50_combout\ = (sum_tmp_reg(28) & (\NEG_OVF[27]~input_o\ & (!sum_tmp_reg(27) & \NEG_OVF[28]~input_o\))) # (!sum_tmp_reg(28) & ((\NEG_OVF[28]~input_o\) # ((\NEG_OVF[27]~input_o\ & !sum_tmp_reg(27)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101110100000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(28),
	datab => \NEG_OVF[27]~input_o\,
	datac => sum_tmp_reg(27),
	datad => \NEG_OVF[28]~input_o\,
	combout => \LessThan0~50_combout\);

-- Location: IOIBUF_X49_Y0_N8
\POS_OVF[31]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(31),
	o => \POS_OVF[31]~input_o\);

-- Location: IOIBUF_X45_Y62_N15
\POS_OVF[26]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(26),
	o => \POS_OVF[26]~input_o\);

-- Location: IOIBUF_X0_Y58_N1
\POS_OVF[27]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(27),
	o => \POS_OVF[27]~input_o\);

-- Location: IOIBUF_X88_Y62_N8
\POS_OVF[24]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(24),
	o => \POS_OVF[24]~input_o\);

-- Location: IOIBUF_X49_Y62_N22
\POS_OVF[23]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(23),
	o => \POS_OVF[23]~input_o\);

-- Location: IOIBUF_X94_Y13_N1
\POS_OVF[21]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(21),
	o => \POS_OVF[21]~input_o\);

-- Location: IOIBUF_X80_Y0_N1
\POS_OVF[18]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(18),
	o => \POS_OVF[18]~input_o\);

-- Location: IOIBUF_X49_Y62_N15
\POS_OVF[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(6),
	o => \POS_OVF[6]~input_o\);

-- Location: IOIBUF_X92_Y62_N22
\POS_OVF[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(4),
	o => \POS_OVF[4]~input_o\);

-- Location: IOIBUF_X83_Y62_N1
\POS_OVF[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(3),
	o => \POS_OVF[3]~input_o\);

-- Location: IOIBUF_X23_Y62_N1
\POS_OVF[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(1),
	o => \POS_OVF[1]~input_o\);

-- Location: IOIBUF_X94_Y38_N1
\POS_OVF[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(9),
	o => \POS_OVF[9]~input_o\);

-- Location: IOIBUF_X73_Y0_N22
\POS_OVF[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(8),
	o => \POS_OVF[8]~input_o\);

-- Location: IOIBUF_X94_Y18_N8
\NEG_OVF[31]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(31),
	o => \NEG_OVF[31]~input_o\);

-- Location: IOIBUF_X94_Y43_N8
\NEG_OVF[30]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(30),
	o => \NEG_OVF[30]~input_o\);

-- Location: IOIBUF_X94_Y13_N8
\NEG_OVF[20]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(20),
	o => \NEG_OVF[20]~input_o\);

-- Location: IOIBUF_X0_Y54_N22
\NEG_OVF[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(0),
	o => \NEG_OVF[0]~input_o\);

-- Location: IOIBUF_X94_Y21_N1
\NEG_OVF[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(10),
	o => \NEG_OVF[10]~input_o\);

-- Location: IOIBUF_X73_Y0_N1
\NEG_OVF[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(13),
	o => \NEG_OVF[13]~input_o\);

-- Location: IOIBUF_X69_Y0_N1
\NEG_OVF[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(12),
	o => \NEG_OVF[12]~input_o\);

-- Location: IOIBUF_X88_Y62_N15
\NEG_OVF[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(9),
	o => \NEG_OVF[9]~input_o\);

-- Location: IOIBUF_X76_Y0_N1
\NEG_OVF[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(8),
	o => \NEG_OVF[8]~input_o\);

-- Location: IOIBUF_X20_Y62_N1
\NEG_OVF[26]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(26),
	o => \NEG_OVF[26]~input_o\);

-- Location: IOIBUF_X43_Y62_N1
\NEG_OVF[24]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(24),
	o => \NEG_OVF[24]~input_o\);

-- Location: IOIBUF_X43_Y62_N8
\NEG_OVF[23]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(23),
	o => \NEG_OVF[23]~input_o\);

-- Location: IOIBUF_X23_Y62_N22
\val_2_i[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(0),
	o => \val_2_i[0]~input_o\);

-- Location: IOIBUF_X0_Y54_N8
\val_3_i[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(1),
	o => \val_3_i[1]~input_o\);

-- Location: IOIBUF_X5_Y62_N8
\val_2_i[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(1),
	o => \val_2_i[1]~input_o\);

-- Location: IOIBUF_X60_Y62_N15
\val_3_i[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(2),
	o => \val_3_i[2]~input_o\);

-- Location: IOIBUF_X94_Y31_N22
\val_1_i[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(2),
	o => \val_1_i[2]~input_o\);

-- Location: IOIBUF_X94_Y31_N15
\val_3_i[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(3),
	o => \val_3_i[3]~input_o\);

-- Location: IOIBUF_X29_Y62_N8
\val_2_i[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(3),
	o => \val_2_i[3]~input_o\);

-- Location: IOIBUF_X0_Y30_N22
\val_2_i[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(4),
	o => \val_2_i[4]~input_o\);

-- Location: IOIBUF_X25_Y62_N1
\val_3_i[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(5),
	o => \val_3_i[5]~input_o\);

-- Location: IOIBUF_X62_Y62_N15
\val_1_i[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(5),
	o => \val_1_i[5]~input_o\);

-- Location: IOIBUF_X23_Y62_N8
\val_1_i[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(6),
	o => \val_1_i[6]~input_o\);

-- Location: IOIBUF_X94_Y35_N22
\val_3_i[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(7),
	o => \val_3_i[7]~input_o\);

-- Location: IOIBUF_X51_Y62_N8
\val_1_i[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(7),
	o => \val_1_i[7]~input_o\);

-- Location: IOIBUF_X34_Y62_N22
\val_2_i[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(8),
	o => \val_2_i[8]~input_o\);

-- Location: IOIBUF_X94_Y49_N22
\val_3_i[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(9),
	o => \val_3_i[9]~input_o\);

-- Location: IOIBUF_X0_Y47_N8
\val_1_i[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(9),
	o => \val_1_i[9]~input_o\);

-- Location: IOIBUF_X94_Y17_N1
\val_3_i[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(10),
	o => \val_3_i[10]~input_o\);

-- Location: IOIBUF_X0_Y57_N1
\val_1_i[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(10),
	o => \val_1_i[10]~input_o\);

-- Location: IOIBUF_X0_Y47_N1
\val_2_i[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(11),
	o => \val_2_i[11]~input_o\);

-- Location: IOIBUF_X56_Y0_N22
\val_2_i[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(12),
	o => \val_2_i[12]~input_o\);

-- Location: IOIBUF_X0_Y50_N8
\val_1_i[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(13),
	o => \val_1_i[13]~input_o\);

-- Location: IOIBUF_X58_Y0_N8
\val_1_i[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(14),
	o => \val_1_i[14]~input_o\);

-- Location: IOIBUF_X94_Y14_N1
\val_3_i[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(15),
	o => \val_3_i[15]~input_o\);

-- Location: IOIBUF_X60_Y0_N8
\val_1_i[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(15),
	o => \val_1_i[15]~input_o\);

-- Location: IOIBUF_X58_Y0_N1
\val_1_i[16]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(16),
	o => \val_1_i[16]~input_o\);

-- Location: IOIBUF_X94_Y35_N15
\val_2_i[17]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(17),
	o => \val_2_i[17]~input_o\);

-- Location: IOIBUF_X0_Y57_N8
\val_1_i[18]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(18),
	o => \val_1_i[18]~input_o\);

-- Location: IOIBUF_X31_Y62_N15
\val_3_i[19]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(19),
	o => \val_3_i[19]~input_o\);

-- Location: IOIBUF_X34_Y62_N15
\val_2_i[19]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(19),
	o => \val_2_i[19]~input_o\);

-- Location: IOIBUF_X53_Y62_N15
\val_2_i[20]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(20),
	o => \val_2_i[20]~input_o\);

-- Location: IOIBUF_X0_Y42_N8
\val_1_i[21]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(21),
	o => \val_1_i[21]~input_o\);

-- Location: IOIBUF_X94_Y26_N8
\val_3_i[22]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(22),
	o => \val_3_i[22]~input_o\);

-- Location: IOIBUF_X34_Y62_N8
\val_2_i[22]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(22),
	o => \val_2_i[22]~input_o\);

-- Location: IOIBUF_X94_Y30_N22
\val_3_i[23]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(23),
	o => \val_3_i[23]~input_o\);

-- Location: IOIBUF_X27_Y62_N22
\val_1_i[23]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(23),
	o => \val_1_i[23]~input_o\);

-- Location: IOIBUF_X94_Y40_N1
\val_1_i[24]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(24),
	o => \val_1_i[24]~input_o\);

-- Location: IOIBUF_X67_Y0_N1
\val_3_i[25]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(25),
	o => \val_3_i[25]~input_o\);

-- Location: IOIBUF_X0_Y48_N8
\val_2_i[25]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(25),
	o => \val_2_i[25]~input_o\);

-- Location: IOIBUF_X0_Y52_N22
\val_2_i[26]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(26),
	o => \val_2_i[26]~input_o\);

-- Location: IOIBUF_X49_Y0_N15
\val_3_i[27]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(27),
	o => \val_3_i[27]~input_o\);

-- Location: IOIBUF_X62_Y0_N1
\val_1_i[27]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(27),
	o => \val_1_i[27]~input_o\);

-- Location: IOIBUF_X94_Y16_N8
\val_2_i[28]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(28),
	o => \val_2_i[28]~input_o\);

-- Location: IOIBUF_X94_Y36_N1
\val_3_i[29]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(29),
	o => \val_3_i[29]~input_o\);

-- Location: IOIBUF_X94_Y11_N15
\val_1_i[29]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(29),
	o => \val_1_i[29]~input_o\);

-- Location: IOIBUF_X94_Y40_N8
\val_1_i[30]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(30),
	o => \val_1_i[30]~input_o\);

-- Location: IOIBUF_X94_Y16_N15
\val_1_i[31]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(31),
	o => \val_1_i[31]~input_o\);

-- Location: LCCOMB_X67_Y54_N10
\val_3_reg[1]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[1]~feeder_combout\ = \val_3_i[1]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[1]~input_o\,
	combout => \val_3_reg[1]~feeder_combout\);

-- Location: LCCOMB_X66_Y54_N10
\val_2_reg[1]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[1]~feeder_combout\ = \val_2_i[1]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[1]~input_o\,
	combout => \val_2_reg[1]~feeder_combout\);

-- Location: LCCOMB_X67_Y54_N12
\val_3_reg[2]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[2]~feeder_combout\ = \val_3_i[2]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[2]~input_o\,
	combout => \val_3_reg[2]~feeder_combout\);

-- Location: LCCOMB_X66_Y54_N8
\val_1_reg[2]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[2]~feeder_combout\ = \val_1_i[2]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[2]~input_o\,
	combout => \val_1_reg[2]~feeder_combout\);

-- Location: LCCOMB_X67_Y54_N6
\val_3_reg[3]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[3]~feeder_combout\ = \val_3_i[3]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[3]~input_o\,
	combout => \val_3_reg[3]~feeder_combout\);

-- Location: LCCOMB_X66_Y54_N6
\val_2_reg[3]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[3]~feeder_combout\ = \val_2_i[3]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[3]~input_o\,
	combout => \val_2_reg[3]~feeder_combout\);

-- Location: LCCOMB_X66_Y54_N12
\val_2_reg[4]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[4]~feeder_combout\ = \val_2_i[4]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[4]~input_o\,
	combout => \val_2_reg[4]~feeder_combout\);

-- Location: LCCOMB_X68_Y54_N4
\val_3_reg[5]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[5]~feeder_combout\ = \val_3_i[5]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[5]~input_o\,
	combout => \val_3_reg[5]~feeder_combout\);

-- Location: LCCOMB_X66_Y54_N4
\val_1_reg[6]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[6]~feeder_combout\ = \val_1_i[6]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[6]~input_o\,
	combout => \val_1_reg[6]~feeder_combout\);

-- Location: LCCOMB_X68_Y53_N4
\val_3_reg[9]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[9]~feeder_combout\ = \val_3_i[9]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[9]~input_o\,
	combout => \val_3_reg[9]~feeder_combout\);

-- Location: LCCOMB_X68_Y53_N2
\val_3_reg[10]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[10]~feeder_combout\ = \val_3_i[10]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[10]~input_o\,
	combout => \val_3_reg[10]~feeder_combout\);

-- Location: LCCOMB_X65_Y53_N0
\val_1_reg[10]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[10]~feeder_combout\ = \val_1_i[10]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[10]~input_o\,
	combout => \val_1_reg[10]~feeder_combout\);

-- Location: LCCOMB_X65_Y53_N16
\val_2_reg[12]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[12]~feeder_combout\ = \val_2_i[12]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[12]~input_o\,
	combout => \val_2_reg[12]~feeder_combout\);

-- Location: LCCOMB_X65_Y53_N2
\val_1_reg[14]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[14]~feeder_combout\ = \val_1_i[14]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[14]~input_o\,
	combout => \val_1_reg[14]~feeder_combout\);

-- Location: LCCOMB_X68_Y53_N20
\val_3_reg[15]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[15]~feeder_combout\ = \val_3_i[15]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[15]~input_o\,
	combout => \val_3_reg[15]~feeder_combout\);

-- Location: LCCOMB_X65_Y53_N14
\val_1_reg[15]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[15]~feeder_combout\ = \val_1_i[15]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[15]~input_o\,
	combout => \val_1_reg[15]~feeder_combout\);

-- Location: LCCOMB_X65_Y53_N12
\val_1_reg[16]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[16]~feeder_combout\ = \val_1_i[16]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[16]~input_o\,
	combout => \val_1_reg[16]~feeder_combout\);

-- Location: LCCOMB_X65_Y53_N8
\val_1_reg[18]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[18]~feeder_combout\ = \val_1_i[18]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[18]~input_o\,
	combout => \val_1_reg[18]~feeder_combout\);

-- Location: LCCOMB_X63_Y53_N16
\val_3_reg[19]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[19]~feeder_combout\ = \val_3_i[19]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[19]~input_o\,
	combout => \val_3_reg[19]~feeder_combout\);

-- Location: LCCOMB_X63_Y53_N2
\val_1_reg[21]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[21]~feeder_combout\ = \val_1_i[21]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[21]~input_o\,
	combout => \val_1_reg[21]~feeder_combout\);

-- Location: LCCOMB_X68_Y53_N30
\val_3_reg[22]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[22]~feeder_combout\ = \val_3_i[22]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[22]~input_o\,
	combout => \val_3_reg[22]~feeder_combout\);

-- Location: LCCOMB_X62_Y53_N20
\val_2_reg[22]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[22]~feeder_combout\ = \val_2_i[22]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[22]~input_o\,
	combout => \val_2_reg[22]~feeder_combout\);

-- Location: LCCOMB_X68_Y53_N8
\val_3_reg[23]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[23]~feeder_combout\ = \val_3_i[23]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[23]~input_o\,
	combout => \val_3_reg[23]~feeder_combout\);

-- Location: LCCOMB_X63_Y53_N0
\val_1_reg[23]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[23]~feeder_combout\ = \val_1_i[23]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[23]~input_o\,
	combout => \val_1_reg[23]~feeder_combout\);

-- Location: LCCOMB_X66_Y52_N30
\val_1_reg[24]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[24]~feeder_combout\ = \val_1_i[24]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[24]~input_o\,
	combout => \val_1_reg[24]~feeder_combout\);

-- Location: LCCOMB_X67_Y52_N26
\val_3_reg[25]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[25]~feeder_combout\ = \val_3_i[25]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[25]~input_o\,
	combout => \val_3_reg[25]~feeder_combout\);

-- Location: LCCOMB_X66_Y52_N24
\val_2_reg[25]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[25]~feeder_combout\ = \val_2_i[25]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[25]~input_o\,
	combout => \val_2_reg[25]~feeder_combout\);

-- Location: LCCOMB_X66_Y52_N26
\val_2_reg[26]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[26]~feeder_combout\ = \val_2_i[26]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[26]~input_o\,
	combout => \val_2_reg[26]~feeder_combout\);

-- Location: LCCOMB_X67_Y52_N30
\val_3_reg[27]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[27]~feeder_combout\ = \val_3_i[27]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[27]~input_o\,
	combout => \val_3_reg[27]~feeder_combout\);

-- Location: LCCOMB_X67_Y52_N22
\val_3_reg[29]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[29]~feeder_combout\ = \val_3_i[29]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[29]~input_o\,
	combout => \val_3_reg[29]~feeder_combout\);

-- Location: LCCOMB_X66_Y52_N22
\val_1_reg[31]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[31]~feeder_combout\ = \val_1_i[31]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[31]~input_o\,
	combout => \val_1_reg[31]~feeder_combout\);

-- Location: IOOBUF_X7_Y62_N9
\val_o[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(0),
	devoe => ww_devoe,
	o => \val_o[0]~output_o\);

-- Location: IOOBUF_X18_Y62_N9
\val_o[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(1),
	devoe => ww_devoe,
	o => \val_o[1]~output_o\);

-- Location: IOOBUF_X51_Y62_N2
\val_o[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(2),
	devoe => ww_devoe,
	o => \val_o[2]~output_o\);

-- Location: IOOBUF_X94_Y54_N9
\val_o[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(3),
	devoe => ww_devoe,
	o => \val_o[3]~output_o\);

-- Location: IOOBUF_X27_Y62_N2
\val_o[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(4),
	devoe => ww_devoe,
	o => \val_o[4]~output_o\);

-- Location: IOOBUF_X94_Y54_N16
\val_o[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(5),
	devoe => ww_devoe,
	o => \val_o[5]~output_o\);

-- Location: IOOBUF_X27_Y62_N9
\val_o[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(6),
	devoe => ww_devoe,
	o => \val_o[6]~output_o\);

-- Location: IOOBUF_X60_Y62_N2
\val_o[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(7),
	devoe => ww_devoe,
	o => \val_o[7]~output_o\);

-- Location: IOOBUF_X94_Y58_N9
\val_o[8]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(8),
	devoe => ww_devoe,
	o => \val_o[8]~output_o\);

-- Location: IOOBUF_X71_Y62_N2
\val_o[9]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(9),
	devoe => ww_devoe,
	o => \val_o[9]~output_o\);

-- Location: IOOBUF_X94_Y47_N16
\val_o[10]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(10),
	devoe => ww_devoe,
	o => \val_o[10]~output_o\);

-- Location: IOOBUF_X94_Y50_N16
\val_o[11]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(11),
	devoe => ww_devoe,
	o => \val_o[11]~output_o\);

-- Location: IOOBUF_X94_Y57_N2
\val_o[12]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(12),
	devoe => ww_devoe,
	o => \val_o[12]~output_o\);

-- Location: IOOBUF_X94_Y50_N23
\val_o[13]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(13),
	devoe => ww_devoe,
	o => \val_o[13]~output_o\);

-- Location: IOOBUF_X73_Y62_N23
\val_o[14]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(14),
	devoe => ww_devoe,
	o => \val_o[14]~output_o\);

-- Location: IOOBUF_X94_Y47_N2
\val_o[15]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(15),
	devoe => ww_devoe,
	o => \val_o[15]~output_o\);

-- Location: IOOBUF_X73_Y62_N16
\val_o[16]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(16),
	devoe => ww_devoe,
	o => \val_o[16]~output_o\);

-- Location: IOOBUF_X94_Y53_N16
\val_o[17]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(17),
	devoe => ww_devoe,
	o => \val_o[17]~output_o\);

-- Location: IOOBUF_X94_Y47_N23
\val_o[18]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(18),
	devoe => ww_devoe,
	o => \val_o[18]~output_o\);

-- Location: IOOBUF_X94_Y53_N23
\val_o[19]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(19),
	devoe => ww_devoe,
	o => \val_o[19]~output_o\);

-- Location: IOOBUF_X94_Y49_N2
\val_o[20]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(20),
	devoe => ww_devoe,
	o => \val_o[20]~output_o\);

-- Location: IOOBUF_X94_Y49_N9
\val_o[21]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(21),
	devoe => ww_devoe,
	o => \val_o[21]~output_o\);

-- Location: IOOBUF_X69_Y62_N23
\val_o[22]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(22),
	devoe => ww_devoe,
	o => \val_o[22]~output_o\);

-- Location: IOOBUF_X67_Y62_N2
\val_o[23]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(23),
	devoe => ww_devoe,
	o => \val_o[23]~output_o\);

-- Location: IOOBUF_X67_Y62_N9
\val_o[24]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(24),
	devoe => ww_devoe,
	o => \val_o[24]~output_o\);

-- Location: IOOBUF_X62_Y62_N9
\val_o[25]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(25),
	devoe => ww_devoe,
	o => \val_o[25]~output_o\);

-- Location: IOOBUF_X67_Y62_N16
\val_o[26]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(26),
	devoe => ww_devoe,
	o => \val_o[26]~output_o\);

-- Location: IOOBUF_X60_Y62_N9
\val_o[27]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(27),
	devoe => ww_devoe,
	o => \val_o[27]~output_o\);

-- Location: IOOBUF_X49_Y62_N2
\val_o[28]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(28),
	devoe => ww_devoe,
	o => \val_o[28]~output_o\);

-- Location: IOOBUF_X94_Y29_N16
\val_o[29]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(29),
	devoe => ww_devoe,
	o => \val_o[29]~output_o\);

-- Location: IOOBUF_X94_Y27_N23
\val_o[30]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(30),
	devoe => ww_devoe,
	o => \val_o[30]~output_o\);

-- Location: IOOBUF_X94_Y43_N2
\val_o[31]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => sum_tmp_reg(33),
	devoe => ww_devoe,
	o => \val_o[31]~output_o\);

-- Location: IOOBUF_X53_Y62_N9
\done_o~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \done_o_reg~q\,
	devoe => ww_devoe,
	o => \done_o~output_o\);

-- Location: IOOBUF_X85_Y62_N23
\ovf_o~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ovf_sign_reg~q\,
	devoe => ww_devoe,
	o => \ovf_o~output_o\);

-- Location: IOIBUF_X0_Y30_N8
\sysclk~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sysclk,
	o => \sysclk~input_o\);

-- Location: CLKCTRL_G2
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

-- Location: IOIBUF_X3_Y62_N15
\val_3_i[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(0),
	o => \val_3_i[0]~input_o\);

-- Location: LCCOMB_X67_Y54_N0
\val_3_reg[0]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[0]~feeder_combout\ = \val_3_i[0]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[0]~input_o\,
	combout => \val_3_reg[0]~feeder_combout\);

-- Location: IOIBUF_X0_Y30_N15
\reset_n~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset_n,
	o => \reset_n~input_o\);

-- Location: CLKCTRL_G4
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

-- Location: FF_X67_Y54_N1
\val_3_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[0]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(0));

-- Location: LCCOMB_X67_Y54_N14
\sum_tmp_reg[0]~34\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[0]~34_combout\ = (sum_tmp_reg(0) & (val_3_reg(0) $ (VCC))) # (!sum_tmp_reg(0) & (val_3_reg(0) & VCC))
-- \sum_tmp_reg[0]~35\ = CARRY((sum_tmp_reg(0) & val_3_reg(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(0),
	datab => val_3_reg(0),
	datad => VCC,
	combout => \sum_tmp_reg[0]~34_combout\,
	cout => \sum_tmp_reg[0]~35\);

-- Location: IOIBUF_X3_Y62_N22
\val_1_i[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(0),
	o => \val_1_i[0]~input_o\);

-- Location: FF_X66_Y54_N1
\val_1_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[0]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(0));

-- Location: LCCOMB_X66_Y54_N16
\Add0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~0_combout\ = (val_2_reg(0) & (val_1_reg(0) $ (VCC))) # (!val_2_reg(0) & (val_1_reg(0) & VCC))
-- \Add0~1\ = CARRY((val_2_reg(0) & val_1_reg(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(0),
	datab => val_1_reg(0),
	datad => VCC,
	combout => \Add0~0_combout\,
	cout => \Add0~1\);

-- Location: LCCOMB_X66_Y55_N18
\state_reg~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \state_reg~10_combout\ = (!\state_reg.SUM_1~q\ & (\state_reg.SUM_2~q\ & (!\state_reg.CHECK~q\ & \state_reg.IDLE~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.SUM_1~q\,
	datab => \state_reg.SUM_2~q\,
	datac => \state_reg.CHECK~q\,
	datad => \state_reg.IDLE~q\,
	combout => \state_reg~10_combout\);

-- Location: FF_X66_Y55_N19
\state_reg.CHECK\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \state_reg~10_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state_reg.CHECK~q\);

-- Location: IOIBUF_X18_Y62_N22
\start_calc_i~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_start_calc_i,
	o => \start_calc_i~input_o\);

-- Location: LCCOMB_X66_Y55_N16
\state_reg~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \state_reg~9_combout\ = (\state_reg.IDLE~1_combout\ & (!\state_reg.CHECK~q\ & ((\state_reg.IDLE~q\) # (\start_calc_i~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010001000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.IDLE~1_combout\,
	datab => \state_reg.CHECK~q\,
	datac => \state_reg.IDLE~q\,
	datad => \start_calc_i~input_o\,
	combout => \state_reg~9_combout\);

-- Location: FF_X66_Y55_N17
\state_reg.IDLE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \state_reg~9_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state_reg.IDLE~q\);

-- Location: LCCOMB_X66_Y55_N22
\state_reg.IDLE~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \state_reg.IDLE~1_combout\ = (\state_reg.CHECK~q\ & (!\state_reg.SUM_1~q\ & (!\state_reg.SUM_2~q\ & \state_reg.IDLE~q\))) # (!\state_reg.CHECK~q\ & ((\state_reg.SUM_1~q\ & (!\state_reg.SUM_2~q\ & \state_reg.IDLE~q\)) # (!\state_reg.SUM_1~q\ & 
-- (\state_reg.SUM_2~q\ $ (!\state_reg.IDLE~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001011000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.CHECK~q\,
	datab => \state_reg.SUM_1~q\,
	datac => \state_reg.SUM_2~q\,
	datad => \state_reg.IDLE~q\,
	combout => \state_reg.IDLE~1_combout\);

-- Location: LCCOMB_X66_Y55_N8
\state_reg~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \state_reg~11_combout\ = (\start_calc_i~input_o\ & (\state_reg.IDLE~1_combout\ & !\state_reg.IDLE~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \start_calc_i~input_o\,
	datac => \state_reg.IDLE~1_combout\,
	datad => \state_reg.IDLE~q\,
	combout => \state_reg~11_combout\);

-- Location: FF_X66_Y55_N9
\state_reg.SUM_1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \state_reg~11_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state_reg.SUM_1~q\);

-- Location: LCCOMB_X66_Y55_N14
\state_reg~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \state_reg~8_combout\ = (!\state_reg.CHECK~q\ & (\state_reg.SUM_1~q\ & (!\state_reg.SUM_2~q\ & \state_reg.IDLE~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.CHECK~q\,
	datab => \state_reg.SUM_1~q\,
	datac => \state_reg.SUM_2~q\,
	datad => \state_reg.IDLE~q\,
	combout => \state_reg~8_combout\);

-- Location: FF_X66_Y55_N15
\state_reg.SUM_2\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \state_reg~8_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state_reg.SUM_2~q\);

-- Location: LCCOMB_X67_Y55_N28
\state_reg.IDLE~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \state_reg.IDLE~0_combout\ = (\state_reg.IDLE~q\ & !\state_reg.CHECK~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \state_reg.IDLE~q\,
	datad => \state_reg.CHECK~q\,
	combout => \state_reg.IDLE~0_combout\);

-- Location: FF_X67_Y54_N15
\sum_tmp_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[0]~34_combout\,
	asdata => \Add0~0_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(0));

-- Location: LCCOMB_X67_Y54_N16
\sum_tmp_reg[1]~36\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[1]~36_combout\ = (val_3_reg(1) & ((sum_tmp_reg(1) & (\sum_tmp_reg[0]~35\ & VCC)) # (!sum_tmp_reg(1) & (!\sum_tmp_reg[0]~35\)))) # (!val_3_reg(1) & ((sum_tmp_reg(1) & (!\sum_tmp_reg[0]~35\)) # (!sum_tmp_reg(1) & ((\sum_tmp_reg[0]~35\) # 
-- (GND)))))
-- \sum_tmp_reg[1]~37\ = CARRY((val_3_reg(1) & (!sum_tmp_reg(1) & !\sum_tmp_reg[0]~35\)) # (!val_3_reg(1) & ((!\sum_tmp_reg[0]~35\) # (!sum_tmp_reg(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(1),
	datab => sum_tmp_reg(1),
	datad => VCC,
	cin => \sum_tmp_reg[0]~35\,
	combout => \sum_tmp_reg[1]~36_combout\,
	cout => \sum_tmp_reg[1]~37\);

-- Location: IOIBUF_X29_Y62_N1
\val_1_i[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(1),
	o => \val_1_i[1]~input_o\);

-- Location: FF_X66_Y54_N19
\val_1_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[1]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(1));

-- Location: LCCOMB_X66_Y54_N18
\Add0~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~2_combout\ = (val_2_reg(1) & ((val_1_reg(1) & (\Add0~1\ & VCC)) # (!val_1_reg(1) & (!\Add0~1\)))) # (!val_2_reg(1) & ((val_1_reg(1) & (!\Add0~1\)) # (!val_1_reg(1) & ((\Add0~1\) # (GND)))))
-- \Add0~3\ = CARRY((val_2_reg(1) & (!val_1_reg(1) & !\Add0~1\)) # (!val_2_reg(1) & ((!\Add0~1\) # (!val_1_reg(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(1),
	datab => val_1_reg(1),
	datad => VCC,
	cin => \Add0~1\,
	combout => \Add0~2_combout\,
	cout => \Add0~3\);

-- Location: FF_X67_Y54_N17
\sum_tmp_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[1]~36_combout\,
	asdata => \Add0~2_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(1));

-- Location: LCCOMB_X67_Y54_N18
\sum_tmp_reg[2]~38\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[2]~38_combout\ = ((val_3_reg(2) $ (sum_tmp_reg(2) $ (!\sum_tmp_reg[1]~37\)))) # (GND)
-- \sum_tmp_reg[2]~39\ = CARRY((val_3_reg(2) & ((sum_tmp_reg(2)) # (!\sum_tmp_reg[1]~37\))) # (!val_3_reg(2) & (sum_tmp_reg(2) & !\sum_tmp_reg[1]~37\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(2),
	datab => sum_tmp_reg(2),
	datad => VCC,
	cin => \sum_tmp_reg[1]~37\,
	combout => \sum_tmp_reg[2]~38_combout\,
	cout => \sum_tmp_reg[2]~39\);

-- Location: IOIBUF_X94_Y23_N8
\val_2_i[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(2),
	o => \val_2_i[2]~input_o\);

-- Location: FF_X66_Y54_N21
\val_2_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[2]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(2));

-- Location: LCCOMB_X66_Y54_N20
\Add0~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~4_combout\ = ((val_1_reg(2) $ (val_2_reg(2) $ (!\Add0~3\)))) # (GND)
-- \Add0~5\ = CARRY((val_1_reg(2) & ((val_2_reg(2)) # (!\Add0~3\))) # (!val_1_reg(2) & (val_2_reg(2) & !\Add0~3\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(2),
	datab => val_2_reg(2),
	datad => VCC,
	cin => \Add0~3\,
	combout => \Add0~4_combout\,
	cout => \Add0~5\);

-- Location: FF_X67_Y54_N19
\sum_tmp_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[2]~38_combout\,
	asdata => \Add0~4_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(2));

-- Location: LCCOMB_X67_Y54_N20
\sum_tmp_reg[3]~40\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[3]~40_combout\ = (val_3_reg(3) & ((sum_tmp_reg(3) & (\sum_tmp_reg[2]~39\ & VCC)) # (!sum_tmp_reg(3) & (!\sum_tmp_reg[2]~39\)))) # (!val_3_reg(3) & ((sum_tmp_reg(3) & (!\sum_tmp_reg[2]~39\)) # (!sum_tmp_reg(3) & ((\sum_tmp_reg[2]~39\) # 
-- (GND)))))
-- \sum_tmp_reg[3]~41\ = CARRY((val_3_reg(3) & (!sum_tmp_reg(3) & !\sum_tmp_reg[2]~39\)) # (!val_3_reg(3) & ((!\sum_tmp_reg[2]~39\) # (!sum_tmp_reg(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(3),
	datab => sum_tmp_reg(3),
	datad => VCC,
	cin => \sum_tmp_reg[2]~39\,
	combout => \sum_tmp_reg[3]~40_combout\,
	cout => \sum_tmp_reg[3]~41\);

-- Location: IOIBUF_X5_Y62_N1
\val_1_i[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(3),
	o => \val_1_i[3]~input_o\);

-- Location: FF_X66_Y54_N23
\val_1_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[3]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(3));

-- Location: LCCOMB_X66_Y54_N22
\Add0~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~6_combout\ = (val_2_reg(3) & ((val_1_reg(3) & (\Add0~5\ & VCC)) # (!val_1_reg(3) & (!\Add0~5\)))) # (!val_2_reg(3) & ((val_1_reg(3) & (!\Add0~5\)) # (!val_1_reg(3) & ((\Add0~5\) # (GND)))))
-- \Add0~7\ = CARRY((val_2_reg(3) & (!val_1_reg(3) & !\Add0~5\)) # (!val_2_reg(3) & ((!\Add0~5\) # (!val_1_reg(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(3),
	datab => val_1_reg(3),
	datad => VCC,
	cin => \Add0~5\,
	combout => \Add0~6_combout\,
	cout => \Add0~7\);

-- Location: FF_X67_Y54_N21
\sum_tmp_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[3]~40_combout\,
	asdata => \Add0~6_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(3));

-- Location: IOIBUF_X23_Y62_N15
\val_3_i[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(4),
	o => \val_3_i[4]~input_o\);

-- Location: LCCOMB_X67_Y54_N4
\val_3_reg[4]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[4]~feeder_combout\ = \val_3_i[4]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[4]~input_o\,
	combout => \val_3_reg[4]~feeder_combout\);

-- Location: FF_X67_Y54_N5
\val_3_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[4]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(4));

-- Location: LCCOMB_X67_Y54_N22
\sum_tmp_reg[4]~42\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[4]~42_combout\ = ((sum_tmp_reg(4) $ (val_3_reg(4) $ (!\sum_tmp_reg[3]~41\)))) # (GND)
-- \sum_tmp_reg[4]~43\ = CARRY((sum_tmp_reg(4) & ((val_3_reg(4)) # (!\sum_tmp_reg[3]~41\))) # (!sum_tmp_reg(4) & (val_3_reg(4) & !\sum_tmp_reg[3]~41\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(4),
	datab => val_3_reg(4),
	datad => VCC,
	cin => \sum_tmp_reg[3]~41\,
	combout => \sum_tmp_reg[4]~42_combout\,
	cout => \sum_tmp_reg[4]~43\);

-- Location: IOIBUF_X7_Y62_N1
\val_1_i[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(4),
	o => \val_1_i[4]~input_o\);

-- Location: FF_X66_Y54_N25
\val_1_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[4]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(4));

-- Location: LCCOMB_X66_Y54_N24
\Add0~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~8_combout\ = ((val_2_reg(4) $ (val_1_reg(4) $ (!\Add0~7\)))) # (GND)
-- \Add0~9\ = CARRY((val_2_reg(4) & ((val_1_reg(4)) # (!\Add0~7\))) # (!val_2_reg(4) & (val_1_reg(4) & !\Add0~7\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(4),
	datab => val_1_reg(4),
	datad => VCC,
	cin => \Add0~7\,
	combout => \Add0~8_combout\,
	cout => \Add0~9\);

-- Location: FF_X67_Y54_N23
\sum_tmp_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[4]~42_combout\,
	asdata => \Add0~8_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(4));

-- Location: LCCOMB_X67_Y54_N24
\sum_tmp_reg[5]~44\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[5]~44_combout\ = (val_3_reg(5) & ((sum_tmp_reg(5) & (\sum_tmp_reg[4]~43\ & VCC)) # (!sum_tmp_reg(5) & (!\sum_tmp_reg[4]~43\)))) # (!val_3_reg(5) & ((sum_tmp_reg(5) & (!\sum_tmp_reg[4]~43\)) # (!sum_tmp_reg(5) & ((\sum_tmp_reg[4]~43\) # 
-- (GND)))))
-- \sum_tmp_reg[5]~45\ = CARRY((val_3_reg(5) & (!sum_tmp_reg(5) & !\sum_tmp_reg[4]~43\)) # (!val_3_reg(5) & ((!\sum_tmp_reg[4]~43\) # (!sum_tmp_reg(5)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(5),
	datab => sum_tmp_reg(5),
	datad => VCC,
	cin => \sum_tmp_reg[4]~43\,
	combout => \sum_tmp_reg[5]~44_combout\,
	cout => \sum_tmp_reg[5]~45\);

-- Location: IOIBUF_X18_Y62_N1
\val_2_i[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(5),
	o => \val_2_i[5]~input_o\);

-- Location: LCCOMB_X66_Y54_N14
\val_2_reg[5]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[5]~feeder_combout\ = \val_2_i[5]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[5]~input_o\,
	combout => \val_2_reg[5]~feeder_combout\);

-- Location: FF_X66_Y54_N15
\val_2_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[5]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(5));

-- Location: LCCOMB_X66_Y54_N26
\Add0~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~10_combout\ = (val_1_reg(5) & ((val_2_reg(5) & (\Add0~9\ & VCC)) # (!val_2_reg(5) & (!\Add0~9\)))) # (!val_1_reg(5) & ((val_2_reg(5) & (!\Add0~9\)) # (!val_2_reg(5) & ((\Add0~9\) # (GND)))))
-- \Add0~11\ = CARRY((val_1_reg(5) & (!val_2_reg(5) & !\Add0~9\)) # (!val_1_reg(5) & ((!\Add0~9\) # (!val_2_reg(5)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(5),
	datab => val_2_reg(5),
	datad => VCC,
	cin => \Add0~9\,
	combout => \Add0~10_combout\,
	cout => \Add0~11\);

-- Location: FF_X67_Y54_N25
\sum_tmp_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[5]~44_combout\,
	asdata => \Add0~10_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(5));

-- Location: IOIBUF_X94_Y54_N22
\val_3_i[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(6),
	o => \val_3_i[6]~input_o\);

-- Location: FF_X68_Y54_N23
\val_3_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_3_i[6]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(6));

-- Location: LCCOMB_X67_Y54_N26
\sum_tmp_reg[6]~46\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[6]~46_combout\ = ((sum_tmp_reg(6) $ (val_3_reg(6) $ (!\sum_tmp_reg[5]~45\)))) # (GND)
-- \sum_tmp_reg[6]~47\ = CARRY((sum_tmp_reg(6) & ((val_3_reg(6)) # (!\sum_tmp_reg[5]~45\))) # (!sum_tmp_reg(6) & (val_3_reg(6) & !\sum_tmp_reg[5]~45\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(6),
	datab => val_3_reg(6),
	datad => VCC,
	cin => \sum_tmp_reg[5]~45\,
	combout => \sum_tmp_reg[6]~46_combout\,
	cout => \sum_tmp_reg[6]~47\);

-- Location: IOIBUF_X3_Y62_N1
\val_2_i[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(6),
	o => \val_2_i[6]~input_o\);

-- Location: FF_X66_Y54_N29
\val_2_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[6]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(6));

-- Location: LCCOMB_X66_Y54_N28
\Add0~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~12_combout\ = ((val_1_reg(6) $ (val_2_reg(6) $ (!\Add0~11\)))) # (GND)
-- \Add0~13\ = CARRY((val_1_reg(6) & ((val_2_reg(6)) # (!\Add0~11\))) # (!val_1_reg(6) & (val_2_reg(6) & !\Add0~11\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(6),
	datab => val_2_reg(6),
	datad => VCC,
	cin => \Add0~11\,
	combout => \Add0~12_combout\,
	cout => \Add0~13\);

-- Location: FF_X67_Y54_N27
\sum_tmp_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[6]~46_combout\,
	asdata => \Add0~12_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(6));

-- Location: LCCOMB_X67_Y54_N28
\sum_tmp_reg[7]~48\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[7]~48_combout\ = (val_3_reg(7) & ((sum_tmp_reg(7) & (\sum_tmp_reg[6]~47\ & VCC)) # (!sum_tmp_reg(7) & (!\sum_tmp_reg[6]~47\)))) # (!val_3_reg(7) & ((sum_tmp_reg(7) & (!\sum_tmp_reg[6]~47\)) # (!sum_tmp_reg(7) & ((\sum_tmp_reg[6]~47\) # 
-- (GND)))))
-- \sum_tmp_reg[7]~49\ = CARRY((val_3_reg(7) & (!sum_tmp_reg(7) & !\sum_tmp_reg[6]~47\)) # (!val_3_reg(7) & ((!\sum_tmp_reg[6]~47\) # (!sum_tmp_reg(7)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(7),
	datab => sum_tmp_reg(7),
	datad => VCC,
	cin => \sum_tmp_reg[6]~47\,
	combout => \sum_tmp_reg[7]~48_combout\,
	cout => \sum_tmp_reg[7]~49\);

-- Location: IOIBUF_X62_Y62_N22
\val_2_i[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(7),
	o => \val_2_i[7]~input_o\);

-- Location: LCCOMB_X66_Y54_N2
\val_2_reg[7]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[7]~feeder_combout\ = \val_2_i[7]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[7]~input_o\,
	combout => \val_2_reg[7]~feeder_combout\);

-- Location: FF_X66_Y54_N3
\val_2_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[7]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(7));

-- Location: LCCOMB_X66_Y54_N30
\Add0~14\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~14_combout\ = (val_1_reg(7) & ((val_2_reg(7) & (\Add0~13\ & VCC)) # (!val_2_reg(7) & (!\Add0~13\)))) # (!val_1_reg(7) & ((val_2_reg(7) & (!\Add0~13\)) # (!val_2_reg(7) & ((\Add0~13\) # (GND)))))
-- \Add0~15\ = CARRY((val_1_reg(7) & (!val_2_reg(7) & !\Add0~13\)) # (!val_1_reg(7) & ((!\Add0~13\) # (!val_2_reg(7)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(7),
	datab => val_2_reg(7),
	datad => VCC,
	cin => \Add0~13\,
	combout => \Add0~14_combout\,
	cout => \Add0~15\);

-- Location: FF_X67_Y54_N29
\sum_tmp_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[7]~48_combout\,
	asdata => \Add0~14_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(7));

-- Location: IOIBUF_X83_Y62_N8
\val_3_i[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(8),
	o => \val_3_i[8]~input_o\);

-- Location: LCCOMB_X68_Y54_N26
\val_3_reg[8]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[8]~feeder_combout\ = \val_3_i[8]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[8]~input_o\,
	combout => \val_3_reg[8]~feeder_combout\);

-- Location: FF_X68_Y54_N27
\val_3_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[8]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(8));

-- Location: LCCOMB_X67_Y54_N30
\sum_tmp_reg[8]~50\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[8]~50_combout\ = ((sum_tmp_reg(8) $ (val_3_reg(8) $ (!\sum_tmp_reg[7]~49\)))) # (GND)
-- \sum_tmp_reg[8]~51\ = CARRY((sum_tmp_reg(8) & ((val_3_reg(8)) # (!\sum_tmp_reg[7]~49\))) # (!sum_tmp_reg(8) & (val_3_reg(8) & !\sum_tmp_reg[7]~49\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(8),
	datab => val_3_reg(8),
	datad => VCC,
	cin => \sum_tmp_reg[7]~49\,
	combout => \sum_tmp_reg[8]~50_combout\,
	cout => \sum_tmp_reg[8]~51\);

-- Location: IOIBUF_X94_Y41_N8
\val_1_i[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(8),
	o => \val_1_i[8]~input_o\);

-- Location: FF_X66_Y53_N13
\val_1_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[8]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(8));

-- Location: LCCOMB_X66_Y53_N0
\Add0~16\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~16_combout\ = ((val_2_reg(8) $ (val_1_reg(8) $ (!\Add0~15\)))) # (GND)
-- \Add0~17\ = CARRY((val_2_reg(8) & ((val_1_reg(8)) # (!\Add0~15\))) # (!val_2_reg(8) & (val_1_reg(8) & !\Add0~15\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(8),
	datab => val_1_reg(8),
	datad => VCC,
	cin => \Add0~15\,
	combout => \Add0~16_combout\,
	cout => \Add0~17\);

-- Location: FF_X67_Y54_N31
\sum_tmp_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[8]~50_combout\,
	asdata => \Add0~16_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(8));

-- Location: LCCOMB_X68_Y53_N0
\sum_tmp_reg[9]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[9]~feeder_combout\ = \sum_tmp_reg[9]~52_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sum_tmp_reg[9]~52_combout\,
	combout => \sum_tmp_reg[9]~feeder_combout\);

-- Location: IOIBUF_X0_Y56_N22
\val_2_i[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(9),
	o => \val_2_i[9]~input_o\);

-- Location: FF_X66_Y53_N5
\val_2_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[9]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(9));

-- Location: LCCOMB_X66_Y53_N2
\Add0~18\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~18_combout\ = (val_1_reg(9) & ((val_2_reg(9) & (\Add0~17\ & VCC)) # (!val_2_reg(9) & (!\Add0~17\)))) # (!val_1_reg(9) & ((val_2_reg(9) & (!\Add0~17\)) # (!val_2_reg(9) & ((\Add0~17\) # (GND)))))
-- \Add0~19\ = CARRY((val_1_reg(9) & (!val_2_reg(9) & !\Add0~17\)) # (!val_1_reg(9) & ((!\Add0~17\) # (!val_2_reg(9)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(9),
	datab => val_2_reg(9),
	datad => VCC,
	cin => \Add0~17\,
	combout => \Add0~18_combout\,
	cout => \Add0~19\);

-- Location: FF_X68_Y53_N1
\sum_tmp_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[9]~feeder_combout\,
	asdata => \Add0~18_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(9));

-- Location: LCCOMB_X67_Y53_N2
\sum_tmp_reg[10]~54\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[10]~54_combout\ = ((val_3_reg(10) $ (sum_tmp_reg(10) $ (!\sum_tmp_reg[9]~53\)))) # (GND)
-- \sum_tmp_reg[10]~55\ = CARRY((val_3_reg(10) & ((sum_tmp_reg(10)) # (!\sum_tmp_reg[9]~53\))) # (!val_3_reg(10) & (sum_tmp_reg(10) & !\sum_tmp_reg[9]~53\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(10),
	datab => sum_tmp_reg(10),
	datad => VCC,
	cin => \sum_tmp_reg[9]~53\,
	combout => \sum_tmp_reg[10]~54_combout\,
	cout => \sum_tmp_reg[10]~55\);

-- Location: LCCOMB_X69_Y53_N20
\sum_tmp_reg[10]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[10]~feeder_combout\ = \sum_tmp_reg[10]~54_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \sum_tmp_reg[10]~54_combout\,
	combout => \sum_tmp_reg[10]~feeder_combout\);

-- Location: IOIBUF_X58_Y0_N15
\val_2_i[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(10),
	o => \val_2_i[10]~input_o\);

-- Location: FF_X66_Y53_N19
\val_2_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[10]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(10));

-- Location: LCCOMB_X66_Y53_N4
\Add0~20\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~20_combout\ = ((val_1_reg(10) $ (val_2_reg(10) $ (!\Add0~19\)))) # (GND)
-- \Add0~21\ = CARRY((val_1_reg(10) & ((val_2_reg(10)) # (!\Add0~19\))) # (!val_1_reg(10) & (val_2_reg(10) & !\Add0~19\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(10),
	datab => val_2_reg(10),
	datad => VCC,
	cin => \Add0~19\,
	combout => \Add0~20_combout\,
	cout => \Add0~21\);

-- Location: FF_X69_Y53_N21
\sum_tmp_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[10]~feeder_combout\,
	asdata => \Add0~20_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(10));

-- Location: IOIBUF_X94_Y45_N1
\val_3_i[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(11),
	o => \val_3_i[11]~input_o\);

-- Location: LCCOMB_X68_Y53_N16
\val_3_reg[11]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[11]~feeder_combout\ = \val_3_i[11]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[11]~input_o\,
	combout => \val_3_reg[11]~feeder_combout\);

-- Location: FF_X68_Y53_N17
\val_3_reg[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[11]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(11));

-- Location: LCCOMB_X67_Y53_N4
\sum_tmp_reg[11]~56\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[11]~56_combout\ = (sum_tmp_reg(11) & ((val_3_reg(11) & (\sum_tmp_reg[10]~55\ & VCC)) # (!val_3_reg(11) & (!\sum_tmp_reg[10]~55\)))) # (!sum_tmp_reg(11) & ((val_3_reg(11) & (!\sum_tmp_reg[10]~55\)) # (!val_3_reg(11) & ((\sum_tmp_reg[10]~55\) # 
-- (GND)))))
-- \sum_tmp_reg[11]~57\ = CARRY((sum_tmp_reg(11) & (!val_3_reg(11) & !\sum_tmp_reg[10]~55\)) # (!sum_tmp_reg(11) & ((!\sum_tmp_reg[10]~55\) # (!val_3_reg(11)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(11),
	datab => val_3_reg(11),
	datad => VCC,
	cin => \sum_tmp_reg[10]~55\,
	combout => \sum_tmp_reg[11]~56_combout\,
	cout => \sum_tmp_reg[11]~57\);

-- Location: LCCOMB_X69_Y53_N14
\sum_tmp_reg[11]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[11]~feeder_combout\ = \sum_tmp_reg[11]~56_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[11]~56_combout\,
	combout => \sum_tmp_reg[11]~feeder_combout\);

-- Location: IOIBUF_X0_Y46_N1
\val_1_i[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(11),
	o => \val_1_i[11]~input_o\);

-- Location: LCCOMB_X65_Y53_N18
\val_1_reg[11]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[11]~feeder_combout\ = \val_1_i[11]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[11]~input_o\,
	combout => \val_1_reg[11]~feeder_combout\);

-- Location: FF_X65_Y53_N19
\val_1_reg[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[11]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(11));

-- Location: LCCOMB_X66_Y53_N6
\Add0~22\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~22_combout\ = (val_2_reg(11) & ((val_1_reg(11) & (\Add0~21\ & VCC)) # (!val_1_reg(11) & (!\Add0~21\)))) # (!val_2_reg(11) & ((val_1_reg(11) & (!\Add0~21\)) # (!val_1_reg(11) & ((\Add0~21\) # (GND)))))
-- \Add0~23\ = CARRY((val_2_reg(11) & (!val_1_reg(11) & !\Add0~21\)) # (!val_2_reg(11) & ((!\Add0~21\) # (!val_1_reg(11)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(11),
	datab => val_1_reg(11),
	datad => VCC,
	cin => \Add0~21\,
	combout => \Add0~22_combout\,
	cout => \Add0~23\);

-- Location: FF_X69_Y53_N15
\sum_tmp_reg[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[11]~feeder_combout\,
	asdata => \Add0~22_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(11));

-- Location: IOIBUF_X94_Y45_N8
\val_3_i[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(12),
	o => \val_3_i[12]~input_o\);

-- Location: LCCOMB_X68_Y53_N26
\val_3_reg[12]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[12]~feeder_combout\ = \val_3_i[12]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[12]~input_o\,
	combout => \val_3_reg[12]~feeder_combout\);

-- Location: FF_X68_Y53_N27
\val_3_reg[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[12]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(12));

-- Location: LCCOMB_X67_Y53_N6
\sum_tmp_reg[12]~58\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[12]~58_combout\ = ((sum_tmp_reg(12) $ (val_3_reg(12) $ (!\sum_tmp_reg[11]~57\)))) # (GND)
-- \sum_tmp_reg[12]~59\ = CARRY((sum_tmp_reg(12) & ((val_3_reg(12)) # (!\sum_tmp_reg[11]~57\))) # (!sum_tmp_reg(12) & (val_3_reg(12) & !\sum_tmp_reg[11]~57\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(12),
	datab => val_3_reg(12),
	datad => VCC,
	cin => \sum_tmp_reg[11]~57\,
	combout => \sum_tmp_reg[12]~58_combout\,
	cout => \sum_tmp_reg[12]~59\);

-- Location: LCCOMB_X69_Y53_N12
\sum_tmp_reg[12]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[12]~feeder_combout\ = \sum_tmp_reg[12]~58_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[12]~58_combout\,
	combout => \sum_tmp_reg[12]~feeder_combout\);

-- Location: IOIBUF_X58_Y0_N22
\val_1_i[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(12),
	o => \val_1_i[12]~input_o\);

-- Location: LCCOMB_X65_Y53_N22
\val_1_reg[12]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[12]~feeder_combout\ = \val_1_i[12]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[12]~input_o\,
	combout => \val_1_reg[12]~feeder_combout\);

-- Location: FF_X65_Y53_N23
\val_1_reg[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[12]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(12));

-- Location: LCCOMB_X66_Y53_N8
\Add0~24\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~24_combout\ = ((val_2_reg(12) $ (val_1_reg(12) $ (!\Add0~23\)))) # (GND)
-- \Add0~25\ = CARRY((val_2_reg(12) & ((val_1_reg(12)) # (!\Add0~23\))) # (!val_2_reg(12) & (val_1_reg(12) & !\Add0~23\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(12),
	datab => val_1_reg(12),
	datad => VCC,
	cin => \Add0~23\,
	combout => \Add0~24_combout\,
	cout => \Add0~25\);

-- Location: FF_X69_Y53_N13
\sum_tmp_reg[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[12]~feeder_combout\,
	asdata => \Add0~24_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(12));

-- Location: IOIBUF_X94_Y30_N8
\val_3_i[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(13),
	o => \val_3_i[13]~input_o\);

-- Location: LCCOMB_X68_Y53_N12
\val_3_reg[13]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[13]~feeder_combout\ = \val_3_i[13]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[13]~input_o\,
	combout => \val_3_reg[13]~feeder_combout\);

-- Location: FF_X68_Y53_N13
\val_3_reg[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[13]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(13));

-- Location: LCCOMB_X67_Y53_N8
\sum_tmp_reg[13]~60\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[13]~60_combout\ = (sum_tmp_reg(13) & ((val_3_reg(13) & (\sum_tmp_reg[12]~59\ & VCC)) # (!val_3_reg(13) & (!\sum_tmp_reg[12]~59\)))) # (!sum_tmp_reg(13) & ((val_3_reg(13) & (!\sum_tmp_reg[12]~59\)) # (!val_3_reg(13) & ((\sum_tmp_reg[12]~59\) # 
-- (GND)))))
-- \sum_tmp_reg[13]~61\ = CARRY((sum_tmp_reg(13) & (!val_3_reg(13) & !\sum_tmp_reg[12]~59\)) # (!sum_tmp_reg(13) & ((!\sum_tmp_reg[12]~59\) # (!val_3_reg(13)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(13),
	datab => val_3_reg(13),
	datad => VCC,
	cin => \sum_tmp_reg[12]~59\,
	combout => \sum_tmp_reg[13]~60_combout\,
	cout => \sum_tmp_reg[13]~61\);

-- Location: LCCOMB_X69_Y53_N6
\sum_tmp_reg[13]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[13]~feeder_combout\ = \sum_tmp_reg[13]~60_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[13]~60_combout\,
	combout => \sum_tmp_reg[13]~feeder_combout\);

-- Location: IOIBUF_X62_Y0_N15
\val_2_i[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(13),
	o => \val_2_i[13]~input_o\);

-- Location: FF_X66_Y53_N17
\val_2_reg[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[13]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(13));

-- Location: LCCOMB_X66_Y53_N10
\Add0~26\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~26_combout\ = (val_1_reg(13) & ((val_2_reg(13) & (\Add0~25\ & VCC)) # (!val_2_reg(13) & (!\Add0~25\)))) # (!val_1_reg(13) & ((val_2_reg(13) & (!\Add0~25\)) # (!val_2_reg(13) & ((\Add0~25\) # (GND)))))
-- \Add0~27\ = CARRY((val_1_reg(13) & (!val_2_reg(13) & !\Add0~25\)) # (!val_1_reg(13) & ((!\Add0~25\) # (!val_2_reg(13)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(13),
	datab => val_2_reg(13),
	datad => VCC,
	cin => \Add0~25\,
	combout => \Add0~26_combout\,
	cout => \Add0~27\);

-- Location: FF_X69_Y53_N7
\sum_tmp_reg[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[13]~feeder_combout\,
	asdata => \Add0~26_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(13));

-- Location: IOIBUF_X94_Y16_N1
\val_3_i[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(14),
	o => \val_3_i[14]~input_o\);

-- Location: LCCOMB_X68_Y53_N22
\val_3_reg[14]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[14]~feeder_combout\ = \val_3_i[14]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[14]~input_o\,
	combout => \val_3_reg[14]~feeder_combout\);

-- Location: FF_X68_Y53_N23
\val_3_reg[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[14]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(14));

-- Location: LCCOMB_X67_Y53_N10
\sum_tmp_reg[14]~62\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[14]~62_combout\ = ((sum_tmp_reg(14) $ (val_3_reg(14) $ (!\sum_tmp_reg[13]~61\)))) # (GND)
-- \sum_tmp_reg[14]~63\ = CARRY((sum_tmp_reg(14) & ((val_3_reg(14)) # (!\sum_tmp_reg[13]~61\))) # (!sum_tmp_reg(14) & (val_3_reg(14) & !\sum_tmp_reg[13]~61\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(14),
	datab => val_3_reg(14),
	datad => VCC,
	cin => \sum_tmp_reg[13]~61\,
	combout => \sum_tmp_reg[14]~62_combout\,
	cout => \sum_tmp_reg[14]~63\);

-- Location: LCCOMB_X69_Y53_N28
\sum_tmp_reg[14]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[14]~feeder_combout\ = \sum_tmp_reg[14]~62_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[14]~62_combout\,
	combout => \sum_tmp_reg[14]~feeder_combout\);

-- Location: IOIBUF_X60_Y0_N1
\val_2_i[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(14),
	o => \val_2_i[14]~input_o\);

-- Location: LCCOMB_X65_Y53_N20
\val_2_reg[14]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[14]~feeder_combout\ = \val_2_i[14]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[14]~input_o\,
	combout => \val_2_reg[14]~feeder_combout\);

-- Location: FF_X65_Y53_N21
\val_2_reg[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[14]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(14));

-- Location: LCCOMB_X66_Y53_N12
\Add0~28\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~28_combout\ = ((val_1_reg(14) $ (val_2_reg(14) $ (!\Add0~27\)))) # (GND)
-- \Add0~29\ = CARRY((val_1_reg(14) & ((val_2_reg(14)) # (!\Add0~27\))) # (!val_1_reg(14) & (val_2_reg(14) & !\Add0~27\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(14),
	datab => val_2_reg(14),
	datad => VCC,
	cin => \Add0~27\,
	combout => \Add0~28_combout\,
	cout => \Add0~29\);

-- Location: FF_X69_Y53_N29
\sum_tmp_reg[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[14]~feeder_combout\,
	asdata => \Add0~28_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(14));

-- Location: LCCOMB_X67_Y53_N12
\sum_tmp_reg[15]~64\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[15]~64_combout\ = (val_3_reg(15) & ((sum_tmp_reg(15) & (\sum_tmp_reg[14]~63\ & VCC)) # (!sum_tmp_reg(15) & (!\sum_tmp_reg[14]~63\)))) # (!val_3_reg(15) & ((sum_tmp_reg(15) & (!\sum_tmp_reg[14]~63\)) # (!sum_tmp_reg(15) & 
-- ((\sum_tmp_reg[14]~63\) # (GND)))))
-- \sum_tmp_reg[15]~65\ = CARRY((val_3_reg(15) & (!sum_tmp_reg(15) & !\sum_tmp_reg[14]~63\)) # (!val_3_reg(15) & ((!\sum_tmp_reg[14]~63\) # (!sum_tmp_reg(15)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(15),
	datab => sum_tmp_reg(15),
	datad => VCC,
	cin => \sum_tmp_reg[14]~63\,
	combout => \sum_tmp_reg[15]~64_combout\,
	cout => \sum_tmp_reg[15]~65\);

-- Location: LCCOMB_X70_Y54_N12
\sum_tmp_reg[15]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[15]~feeder_combout\ = \sum_tmp_reg[15]~64_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[15]~64_combout\,
	combout => \sum_tmp_reg[15]~feeder_combout\);

-- Location: IOIBUF_X34_Y62_N1
\val_2_i[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(15),
	o => \val_2_i[15]~input_o\);

-- Location: LCCOMB_X65_Y53_N24
\val_2_reg[15]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[15]~feeder_combout\ = \val_2_i[15]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[15]~input_o\,
	combout => \val_2_reg[15]~feeder_combout\);

-- Location: FF_X65_Y53_N25
\val_2_reg[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[15]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(15));

-- Location: LCCOMB_X66_Y53_N14
\Add0~30\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~30_combout\ = (val_1_reg(15) & ((val_2_reg(15) & (\Add0~29\ & VCC)) # (!val_2_reg(15) & (!\Add0~29\)))) # (!val_1_reg(15) & ((val_2_reg(15) & (!\Add0~29\)) # (!val_2_reg(15) & ((\Add0~29\) # (GND)))))
-- \Add0~31\ = CARRY((val_1_reg(15) & (!val_2_reg(15) & !\Add0~29\)) # (!val_1_reg(15) & ((!\Add0~29\) # (!val_2_reg(15)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(15),
	datab => val_2_reg(15),
	datad => VCC,
	cin => \Add0~29\,
	combout => \Add0~30_combout\,
	cout => \Add0~31\);

-- Location: FF_X70_Y54_N13
\sum_tmp_reg[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[15]~feeder_combout\,
	asdata => \Add0~30_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(15));

-- Location: IOIBUF_X94_Y12_N1
\val_3_i[16]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(16),
	o => \val_3_i[16]~input_o\);

-- Location: LCCOMB_X68_Y53_N10
\val_3_reg[16]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[16]~feeder_combout\ = \val_3_i[16]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[16]~input_o\,
	combout => \val_3_reg[16]~feeder_combout\);

-- Location: FF_X68_Y53_N11
\val_3_reg[16]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[16]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(16));

-- Location: LCCOMB_X67_Y53_N14
\sum_tmp_reg[16]~66\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[16]~66_combout\ = ((sum_tmp_reg(16) $ (val_3_reg(16) $ (!\sum_tmp_reg[15]~65\)))) # (GND)
-- \sum_tmp_reg[16]~67\ = CARRY((sum_tmp_reg(16) & ((val_3_reg(16)) # (!\sum_tmp_reg[15]~65\))) # (!sum_tmp_reg(16) & (val_3_reg(16) & !\sum_tmp_reg[15]~65\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(16),
	datab => val_3_reg(16),
	datad => VCC,
	cin => \sum_tmp_reg[15]~65\,
	combout => \sum_tmp_reg[16]~66_combout\,
	cout => \sum_tmp_reg[16]~67\);

-- Location: LCCOMB_X68_Y53_N6
\sum_tmp_reg[16]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[16]~feeder_combout\ = \sum_tmp_reg[16]~66_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[16]~66_combout\,
	combout => \sum_tmp_reg[16]~feeder_combout\);

-- Location: IOIBUF_X0_Y56_N15
\val_2_i[16]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(16),
	o => \val_2_i[16]~input_o\);

-- Location: FF_X63_Y53_N25
\val_2_reg[16]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[16]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(16));

-- Location: LCCOMB_X66_Y53_N16
\Add0~32\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~32_combout\ = ((val_1_reg(16) $ (val_2_reg(16) $ (!\Add0~31\)))) # (GND)
-- \Add0~33\ = CARRY((val_1_reg(16) & ((val_2_reg(16)) # (!\Add0~31\))) # (!val_1_reg(16) & (val_2_reg(16) & !\Add0~31\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(16),
	datab => val_2_reg(16),
	datad => VCC,
	cin => \Add0~31\,
	combout => \Add0~32_combout\,
	cout => \Add0~33\);

-- Location: FF_X68_Y53_N7
\sum_tmp_reg[16]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[16]~feeder_combout\,
	asdata => \Add0~32_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(16));

-- Location: IOIBUF_X94_Y14_N8
\val_3_i[17]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(17),
	o => \val_3_i[17]~input_o\);

-- Location: LCCOMB_X68_Y53_N28
\val_3_reg[17]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[17]~feeder_combout\ = \val_3_i[17]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[17]~input_o\,
	combout => \val_3_reg[17]~feeder_combout\);

-- Location: FF_X68_Y53_N29
\val_3_reg[17]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[17]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(17));

-- Location: LCCOMB_X67_Y53_N16
\sum_tmp_reg[17]~68\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[17]~68_combout\ = (sum_tmp_reg(17) & ((val_3_reg(17) & (\sum_tmp_reg[16]~67\ & VCC)) # (!val_3_reg(17) & (!\sum_tmp_reg[16]~67\)))) # (!sum_tmp_reg(17) & ((val_3_reg(17) & (!\sum_tmp_reg[16]~67\)) # (!val_3_reg(17) & ((\sum_tmp_reg[16]~67\) # 
-- (GND)))))
-- \sum_tmp_reg[17]~69\ = CARRY((sum_tmp_reg(17) & (!val_3_reg(17) & !\sum_tmp_reg[16]~67\)) # (!sum_tmp_reg(17) & ((!\sum_tmp_reg[16]~67\) # (!val_3_reg(17)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(17),
	datab => val_3_reg(17),
	datad => VCC,
	cin => \sum_tmp_reg[16]~67\,
	combout => \sum_tmp_reg[17]~68_combout\,
	cout => \sum_tmp_reg[17]~69\);

-- Location: LCCOMB_X71_Y53_N0
\sum_tmp_reg[17]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[17]~feeder_combout\ = \sum_tmp_reg[17]~68_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[17]~68_combout\,
	combout => \sum_tmp_reg[17]~feeder_combout\);

-- Location: IOIBUF_X0_Y56_N8
\val_1_i[17]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(17),
	o => \val_1_i[17]~input_o\);

-- Location: LCCOMB_X65_Y53_N30
\val_1_reg[17]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[17]~feeder_combout\ = \val_1_i[17]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[17]~input_o\,
	combout => \val_1_reg[17]~feeder_combout\);

-- Location: FF_X65_Y53_N31
\val_1_reg[17]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[17]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(17));

-- Location: LCCOMB_X66_Y53_N18
\Add0~34\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~34_combout\ = (val_2_reg(17) & ((val_1_reg(17) & (\Add0~33\ & VCC)) # (!val_1_reg(17) & (!\Add0~33\)))) # (!val_2_reg(17) & ((val_1_reg(17) & (!\Add0~33\)) # (!val_1_reg(17) & ((\Add0~33\) # (GND)))))
-- \Add0~35\ = CARRY((val_2_reg(17) & (!val_1_reg(17) & !\Add0~33\)) # (!val_2_reg(17) & ((!\Add0~33\) # (!val_1_reg(17)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(17),
	datab => val_1_reg(17),
	datad => VCC,
	cin => \Add0~33\,
	combout => \Add0~34_combout\,
	cout => \Add0~35\);

-- Location: FF_X71_Y53_N1
\sum_tmp_reg[17]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[17]~feeder_combout\,
	asdata => \Add0~34_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(17));

-- Location: IOIBUF_X73_Y0_N8
\val_3_i[18]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(18),
	o => \val_3_i[18]~input_o\);

-- Location: LCCOMB_X69_Y53_N2
\val_3_reg[18]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[18]~feeder_combout\ = \val_3_i[18]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[18]~input_o\,
	combout => \val_3_reg[18]~feeder_combout\);

-- Location: FF_X69_Y53_N3
\val_3_reg[18]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[18]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(18));

-- Location: LCCOMB_X67_Y53_N18
\sum_tmp_reg[18]~70\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[18]~70_combout\ = ((sum_tmp_reg(18) $ (val_3_reg(18) $ (!\sum_tmp_reg[17]~69\)))) # (GND)
-- \sum_tmp_reg[18]~71\ = CARRY((sum_tmp_reg(18) & ((val_3_reg(18)) # (!\sum_tmp_reg[17]~69\))) # (!sum_tmp_reg(18) & (val_3_reg(18) & !\sum_tmp_reg[17]~69\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(18),
	datab => val_3_reg(18),
	datad => VCC,
	cin => \sum_tmp_reg[17]~69\,
	combout => \sum_tmp_reg[18]~70_combout\,
	cout => \sum_tmp_reg[18]~71\);

-- Location: LCCOMB_X70_Y53_N28
\sum_tmp_reg[18]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[18]~feeder_combout\ = \sum_tmp_reg[18]~70_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[18]~70_combout\,
	combout => \sum_tmp_reg[18]~feeder_combout\);

-- Location: IOIBUF_X56_Y0_N15
\val_2_i[18]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(18),
	o => \val_2_i[18]~input_o\);

-- Location: LCCOMB_X63_Y53_N30
\val_2_reg[18]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[18]~feeder_combout\ = \val_2_i[18]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[18]~input_o\,
	combout => \val_2_reg[18]~feeder_combout\);

-- Location: FF_X63_Y53_N31
\val_2_reg[18]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[18]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(18));

-- Location: LCCOMB_X66_Y53_N20
\Add0~36\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~36_combout\ = ((val_1_reg(18) $ (val_2_reg(18) $ (!\Add0~35\)))) # (GND)
-- \Add0~37\ = CARRY((val_1_reg(18) & ((val_2_reg(18)) # (!\Add0~35\))) # (!val_1_reg(18) & (val_2_reg(18) & !\Add0~35\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(18),
	datab => val_2_reg(18),
	datad => VCC,
	cin => \Add0~35\,
	combout => \Add0~36_combout\,
	cout => \Add0~37\);

-- Location: FF_X70_Y53_N29
\sum_tmp_reg[18]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[18]~feeder_combout\,
	asdata => \Add0~36_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(18));

-- Location: LCCOMB_X67_Y53_N20
\sum_tmp_reg[19]~72\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[19]~72_combout\ = (val_3_reg(19) & ((sum_tmp_reg(19) & (\sum_tmp_reg[18]~71\ & VCC)) # (!sum_tmp_reg(19) & (!\sum_tmp_reg[18]~71\)))) # (!val_3_reg(19) & ((sum_tmp_reg(19) & (!\sum_tmp_reg[18]~71\)) # (!sum_tmp_reg(19) & 
-- ((\sum_tmp_reg[18]~71\) # (GND)))))
-- \sum_tmp_reg[19]~73\ = CARRY((val_3_reg(19) & (!sum_tmp_reg(19) & !\sum_tmp_reg[18]~71\)) # (!val_3_reg(19) & ((!\sum_tmp_reg[18]~71\) # (!sum_tmp_reg(19)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(19),
	datab => sum_tmp_reg(19),
	datad => VCC,
	cin => \sum_tmp_reg[18]~71\,
	combout => \sum_tmp_reg[19]~72_combout\,
	cout => \sum_tmp_reg[19]~73\);

-- Location: LCCOMB_X71_Y53_N14
\sum_tmp_reg[19]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[19]~feeder_combout\ = \sum_tmp_reg[19]~72_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[19]~72_combout\,
	combout => \sum_tmp_reg[19]~feeder_combout\);

-- Location: IOIBUF_X60_Y0_N22
\val_1_i[19]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(19),
	o => \val_1_i[19]~input_o\);

-- Location: LCCOMB_X65_Y53_N4
\val_1_reg[19]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_1_reg[19]~feeder_combout\ = \val_1_i[19]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_1_i[19]~input_o\,
	combout => \val_1_reg[19]~feeder_combout\);

-- Location: FF_X65_Y53_N5
\val_1_reg[19]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_1_reg[19]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(19));

-- Location: LCCOMB_X66_Y53_N22
\Add0~38\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~38_combout\ = (val_2_reg(19) & ((val_1_reg(19) & (\Add0~37\ & VCC)) # (!val_1_reg(19) & (!\Add0~37\)))) # (!val_2_reg(19) & ((val_1_reg(19) & (!\Add0~37\)) # (!val_1_reg(19) & ((\Add0~37\) # (GND)))))
-- \Add0~39\ = CARRY((val_2_reg(19) & (!val_1_reg(19) & !\Add0~37\)) # (!val_2_reg(19) & ((!\Add0~37\) # (!val_1_reg(19)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(19),
	datab => val_1_reg(19),
	datad => VCC,
	cin => \Add0~37\,
	combout => \Add0~38_combout\,
	cout => \Add0~39\);

-- Location: FF_X71_Y53_N15
\sum_tmp_reg[19]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[19]~feeder_combout\,
	asdata => \Add0~38_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(19));

-- Location: IOIBUF_X76_Y0_N8
\val_3_i[20]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(20),
	o => \val_3_i[20]~input_o\);

-- Location: LCCOMB_X68_Y53_N14
\val_3_reg[20]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[20]~feeder_combout\ = \val_3_i[20]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[20]~input_o\,
	combout => \val_3_reg[20]~feeder_combout\);

-- Location: FF_X68_Y53_N15
\val_3_reg[20]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[20]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(20));

-- Location: LCCOMB_X67_Y53_N22
\sum_tmp_reg[20]~74\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[20]~74_combout\ = ((sum_tmp_reg(20) $ (val_3_reg(20) $ (!\sum_tmp_reg[19]~73\)))) # (GND)
-- \sum_tmp_reg[20]~75\ = CARRY((sum_tmp_reg(20) & ((val_3_reg(20)) # (!\sum_tmp_reg[19]~73\))) # (!sum_tmp_reg(20) & (val_3_reg(20) & !\sum_tmp_reg[19]~73\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(20),
	datab => val_3_reg(20),
	datad => VCC,
	cin => \sum_tmp_reg[19]~73\,
	combout => \sum_tmp_reg[20]~74_combout\,
	cout => \sum_tmp_reg[20]~75\);

-- Location: LCCOMB_X70_Y53_N14
\sum_tmp_reg[20]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[20]~feeder_combout\ = \sum_tmp_reg[20]~74_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[20]~74_combout\,
	combout => \sum_tmp_reg[20]~feeder_combout\);

-- Location: IOIBUF_X0_Y43_N22
\val_1_i[20]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(20),
	o => \val_1_i[20]~input_o\);

-- Location: FF_X65_Y53_N29
\val_1_reg[20]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[20]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(20));

-- Location: LCCOMB_X66_Y53_N24
\Add0~40\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~40_combout\ = ((val_2_reg(20) $ (val_1_reg(20) $ (!\Add0~39\)))) # (GND)
-- \Add0~41\ = CARRY((val_2_reg(20) & ((val_1_reg(20)) # (!\Add0~39\))) # (!val_2_reg(20) & (val_1_reg(20) & !\Add0~39\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(20),
	datab => val_1_reg(20),
	datad => VCC,
	cin => \Add0~39\,
	combout => \Add0~40_combout\,
	cout => \Add0~41\);

-- Location: FF_X70_Y53_N15
\sum_tmp_reg[20]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[20]~feeder_combout\,
	asdata => \Add0~40_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(20));

-- Location: IOIBUF_X94_Y30_N1
\val_3_i[21]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(21),
	o => \val_3_i[21]~input_o\);

-- Location: LCCOMB_X68_Y53_N24
\val_3_reg[21]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[21]~feeder_combout\ = \val_3_i[21]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[21]~input_o\,
	combout => \val_3_reg[21]~feeder_combout\);

-- Location: FF_X68_Y53_N25
\val_3_reg[21]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[21]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(21));

-- Location: LCCOMB_X67_Y53_N24
\sum_tmp_reg[21]~76\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[21]~76_combout\ = (sum_tmp_reg(21) & ((val_3_reg(21) & (\sum_tmp_reg[20]~75\ & VCC)) # (!val_3_reg(21) & (!\sum_tmp_reg[20]~75\)))) # (!sum_tmp_reg(21) & ((val_3_reg(21) & (!\sum_tmp_reg[20]~75\)) # (!val_3_reg(21) & ((\sum_tmp_reg[20]~75\) # 
-- (GND)))))
-- \sum_tmp_reg[21]~77\ = CARRY((sum_tmp_reg(21) & (!val_3_reg(21) & !\sum_tmp_reg[20]~75\)) # (!sum_tmp_reg(21) & ((!\sum_tmp_reg[20]~75\) # (!val_3_reg(21)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(21),
	datab => val_3_reg(21),
	datad => VCC,
	cin => \sum_tmp_reg[20]~75\,
	combout => \sum_tmp_reg[21]~76_combout\,
	cout => \sum_tmp_reg[21]~77\);

-- Location: LCCOMB_X70_Y53_N4
\sum_tmp_reg[21]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[21]~feeder_combout\ = \sum_tmp_reg[21]~76_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[21]~76_combout\,
	combout => \sum_tmp_reg[21]~feeder_combout\);

-- Location: IOIBUF_X0_Y49_N22
\val_2_i[21]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(21),
	o => \val_2_i[21]~input_o\);

-- Location: FF_X65_Y53_N7
\val_2_reg[21]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[21]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(21));

-- Location: LCCOMB_X66_Y53_N26
\Add0~42\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~42_combout\ = (val_1_reg(21) & ((val_2_reg(21) & (\Add0~41\ & VCC)) # (!val_2_reg(21) & (!\Add0~41\)))) # (!val_1_reg(21) & ((val_2_reg(21) & (!\Add0~41\)) # (!val_2_reg(21) & ((\Add0~41\) # (GND)))))
-- \Add0~43\ = CARRY((val_1_reg(21) & (!val_2_reg(21) & !\Add0~41\)) # (!val_1_reg(21) & ((!\Add0~41\) # (!val_2_reg(21)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(21),
	datab => val_2_reg(21),
	datad => VCC,
	cin => \Add0~41\,
	combout => \Add0~42_combout\,
	cout => \Add0~43\);

-- Location: FF_X70_Y53_N5
\sum_tmp_reg[21]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[21]~feeder_combout\,
	asdata => \Add0~42_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(21));

-- Location: LCCOMB_X67_Y53_N26
\sum_tmp_reg[22]~78\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[22]~78_combout\ = ((val_3_reg(22) $ (sum_tmp_reg(22) $ (!\sum_tmp_reg[21]~77\)))) # (GND)
-- \sum_tmp_reg[22]~79\ = CARRY((val_3_reg(22) & ((sum_tmp_reg(22)) # (!\sum_tmp_reg[21]~77\))) # (!val_3_reg(22) & (sum_tmp_reg(22) & !\sum_tmp_reg[21]~77\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(22),
	datab => sum_tmp_reg(22),
	datad => VCC,
	cin => \sum_tmp_reg[21]~77\,
	combout => \sum_tmp_reg[22]~78_combout\,
	cout => \sum_tmp_reg[22]~79\);

-- Location: LCCOMB_X67_Y55_N8
\sum_tmp_reg[22]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[22]~feeder_combout\ = \sum_tmp_reg[22]~78_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[22]~78_combout\,
	combout => \sum_tmp_reg[22]~feeder_combout\);

-- Location: IOIBUF_X0_Y50_N1
\val_1_i[22]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(22),
	o => \val_1_i[22]~input_o\);

-- Location: FF_X63_Y53_N5
\val_1_reg[22]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[22]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(22));

-- Location: LCCOMB_X66_Y53_N28
\Add0~44\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~44_combout\ = ((val_2_reg(22) $ (val_1_reg(22) $ (!\Add0~43\)))) # (GND)
-- \Add0~45\ = CARRY((val_2_reg(22) & ((val_1_reg(22)) # (!\Add0~43\))) # (!val_2_reg(22) & (val_1_reg(22) & !\Add0~43\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(22),
	datab => val_1_reg(22),
	datad => VCC,
	cin => \Add0~43\,
	combout => \Add0~44_combout\,
	cout => \Add0~45\);

-- Location: FF_X67_Y55_N9
\sum_tmp_reg[22]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[22]~feeder_combout\,
	asdata => \Add0~44_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(22));

-- Location: LCCOMB_X67_Y53_N28
\sum_tmp_reg[23]~80\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[23]~80_combout\ = (val_3_reg(23) & ((sum_tmp_reg(23) & (\sum_tmp_reg[22]~79\ & VCC)) # (!sum_tmp_reg(23) & (!\sum_tmp_reg[22]~79\)))) # (!val_3_reg(23) & ((sum_tmp_reg(23) & (!\sum_tmp_reg[22]~79\)) # (!sum_tmp_reg(23) & 
-- ((\sum_tmp_reg[22]~79\) # (GND)))))
-- \sum_tmp_reg[23]~81\ = CARRY((val_3_reg(23) & (!sum_tmp_reg(23) & !\sum_tmp_reg[22]~79\)) # (!val_3_reg(23) & ((!\sum_tmp_reg[22]~79\) # (!sum_tmp_reg(23)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(23),
	datab => sum_tmp_reg(23),
	datad => VCC,
	cin => \sum_tmp_reg[22]~79\,
	combout => \sum_tmp_reg[23]~80_combout\,
	cout => \sum_tmp_reg[23]~81\);

-- Location: IOIBUF_X53_Y62_N22
\val_2_i[23]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(23),
	o => \val_2_i[23]~input_o\);

-- Location: LCCOMB_X63_Y53_N10
\val_2_reg[23]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[23]~feeder_combout\ = \val_2_i[23]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[23]~input_o\,
	combout => \val_2_reg[23]~feeder_combout\);

-- Location: FF_X63_Y53_N11
\val_2_reg[23]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[23]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(23));

-- Location: LCCOMB_X66_Y53_N30
\Add0~46\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~46_combout\ = (val_1_reg(23) & ((val_2_reg(23) & (\Add0~45\ & VCC)) # (!val_2_reg(23) & (!\Add0~45\)))) # (!val_1_reg(23) & ((val_2_reg(23) & (!\Add0~45\)) # (!val_2_reg(23) & ((\Add0~45\) # (GND)))))
-- \Add0~47\ = CARRY((val_1_reg(23) & (!val_2_reg(23) & !\Add0~45\)) # (!val_1_reg(23) & ((!\Add0~45\) # (!val_2_reg(23)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(23),
	datab => val_2_reg(23),
	datad => VCC,
	cin => \Add0~45\,
	combout => \Add0~46_combout\,
	cout => \Add0~47\);

-- Location: FF_X67_Y53_N29
\sum_tmp_reg[23]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[23]~80_combout\,
	asdata => \Add0~46_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(23));

-- Location: IOIBUF_X94_Y49_N15
\val_3_i[24]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(24),
	o => \val_3_i[24]~input_o\);

-- Location: LCCOMB_X68_Y53_N18
\val_3_reg[24]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[24]~feeder_combout\ = \val_3_i[24]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[24]~input_o\,
	combout => \val_3_reg[24]~feeder_combout\);

-- Location: FF_X68_Y53_N19
\val_3_reg[24]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[24]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(24));

-- Location: LCCOMB_X67_Y53_N30
\sum_tmp_reg[24]~82\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[24]~82_combout\ = ((sum_tmp_reg(24) $ (val_3_reg(24) $ (!\sum_tmp_reg[23]~81\)))) # (GND)
-- \sum_tmp_reg[24]~83\ = CARRY((sum_tmp_reg(24) & ((val_3_reg(24)) # (!\sum_tmp_reg[23]~81\))) # (!sum_tmp_reg(24) & (val_3_reg(24) & !\sum_tmp_reg[23]~81\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(24),
	datab => val_3_reg(24),
	datad => VCC,
	cin => \sum_tmp_reg[23]~81\,
	combout => \sum_tmp_reg[24]~82_combout\,
	cout => \sum_tmp_reg[24]~83\);

-- Location: LCCOMB_X67_Y55_N2
\sum_tmp_reg[24]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[24]~feeder_combout\ = \sum_tmp_reg[24]~82_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \sum_tmp_reg[24]~82_combout\,
	combout => \sum_tmp_reg[24]~feeder_combout\);

-- Location: IOIBUF_X62_Y0_N8
\val_2_i[24]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(24),
	o => \val_2_i[24]~input_o\);

-- Location: FF_X66_Y52_N1
\val_2_reg[24]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[24]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(24));

-- Location: LCCOMB_X66_Y52_N0
\Add0~48\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~48_combout\ = ((val_1_reg(24) $ (val_2_reg(24) $ (!\Add0~47\)))) # (GND)
-- \Add0~49\ = CARRY((val_1_reg(24) & ((val_2_reg(24)) # (!\Add0~47\))) # (!val_1_reg(24) & (val_2_reg(24) & !\Add0~47\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(24),
	datab => val_2_reg(24),
	datad => VCC,
	cin => \Add0~47\,
	combout => \Add0~48_combout\,
	cout => \Add0~49\);

-- Location: FF_X67_Y55_N3
\sum_tmp_reg[24]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[24]~feeder_combout\,
	asdata => \Add0~48_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(24));

-- Location: LCCOMB_X67_Y52_N0
\sum_tmp_reg[25]~84\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[25]~84_combout\ = (val_3_reg(25) & ((sum_tmp_reg(25) & (\sum_tmp_reg[24]~83\ & VCC)) # (!sum_tmp_reg(25) & (!\sum_tmp_reg[24]~83\)))) # (!val_3_reg(25) & ((sum_tmp_reg(25) & (!\sum_tmp_reg[24]~83\)) # (!sum_tmp_reg(25) & 
-- ((\sum_tmp_reg[24]~83\) # (GND)))))
-- \sum_tmp_reg[25]~85\ = CARRY((val_3_reg(25) & (!sum_tmp_reg(25) & !\sum_tmp_reg[24]~83\)) # (!val_3_reg(25) & ((!\sum_tmp_reg[24]~83\) # (!sum_tmp_reg(25)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(25),
	datab => sum_tmp_reg(25),
	datad => VCC,
	cin => \sum_tmp_reg[24]~83\,
	combout => \sum_tmp_reg[25]~84_combout\,
	cout => \sum_tmp_reg[25]~85\);

-- Location: IOIBUF_X94_Y28_N22
\val_1_i[25]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(25),
	o => \val_1_i[25]~input_o\);

-- Location: FF_X66_Y52_N3
\val_1_reg[25]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[25]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(25));

-- Location: LCCOMB_X66_Y52_N2
\Add0~50\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~50_combout\ = (val_2_reg(25) & ((val_1_reg(25) & (\Add0~49\ & VCC)) # (!val_1_reg(25) & (!\Add0~49\)))) # (!val_2_reg(25) & ((val_1_reg(25) & (!\Add0~49\)) # (!val_1_reg(25) & ((\Add0~49\) # (GND)))))
-- \Add0~51\ = CARRY((val_2_reg(25) & (!val_1_reg(25) & !\Add0~49\)) # (!val_2_reg(25) & ((!\Add0~49\) # (!val_1_reg(25)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(25),
	datab => val_1_reg(25),
	datad => VCC,
	cin => \Add0~49\,
	combout => \Add0~50_combout\,
	cout => \Add0~51\);

-- Location: FF_X67_Y52_N1
\sum_tmp_reg[25]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[25]~84_combout\,
	asdata => \Add0~50_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(25));

-- Location: IOIBUF_X94_Y9_N15
\val_3_i[26]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(26),
	o => \val_3_i[26]~input_o\);

-- Location: LCCOMB_X67_Y52_N28
\val_3_reg[26]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[26]~feeder_combout\ = \val_3_i[26]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[26]~input_o\,
	combout => \val_3_reg[26]~feeder_combout\);

-- Location: FF_X67_Y52_N29
\val_3_reg[26]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[26]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(26));

-- Location: LCCOMB_X67_Y52_N2
\sum_tmp_reg[26]~86\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[26]~86_combout\ = ((sum_tmp_reg(26) $ (val_3_reg(26) $ (!\sum_tmp_reg[25]~85\)))) # (GND)
-- \sum_tmp_reg[26]~87\ = CARRY((sum_tmp_reg(26) & ((val_3_reg(26)) # (!\sum_tmp_reg[25]~85\))) # (!sum_tmp_reg(26) & (val_3_reg(26) & !\sum_tmp_reg[25]~85\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(26),
	datab => val_3_reg(26),
	datad => VCC,
	cin => \sum_tmp_reg[25]~85\,
	combout => \sum_tmp_reg[26]~86_combout\,
	cout => \sum_tmp_reg[26]~87\);

-- Location: IOIBUF_X49_Y0_N22
\val_1_i[26]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(26),
	o => \val_1_i[26]~input_o\);

-- Location: FF_X66_Y52_N5
\val_1_reg[26]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[26]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(26));

-- Location: LCCOMB_X66_Y52_N4
\Add0~52\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~52_combout\ = ((val_2_reg(26) $ (val_1_reg(26) $ (!\Add0~51\)))) # (GND)
-- \Add0~53\ = CARRY((val_2_reg(26) & ((val_1_reg(26)) # (!\Add0~51\))) # (!val_2_reg(26) & (val_1_reg(26) & !\Add0~51\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(26),
	datab => val_1_reg(26),
	datad => VCC,
	cin => \Add0~51\,
	combout => \Add0~52_combout\,
	cout => \Add0~53\);

-- Location: FF_X67_Y52_N3
\sum_tmp_reg[26]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[26]~86_combout\,
	asdata => \Add0~52_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(26));

-- Location: LCCOMB_X67_Y52_N4
\sum_tmp_reg[27]~88\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[27]~88_combout\ = (val_3_reg(27) & ((sum_tmp_reg(27) & (\sum_tmp_reg[26]~87\ & VCC)) # (!sum_tmp_reg(27) & (!\sum_tmp_reg[26]~87\)))) # (!val_3_reg(27) & ((sum_tmp_reg(27) & (!\sum_tmp_reg[26]~87\)) # (!sum_tmp_reg(27) & 
-- ((\sum_tmp_reg[26]~87\) # (GND)))))
-- \sum_tmp_reg[27]~89\ = CARRY((val_3_reg(27) & (!sum_tmp_reg(27) & !\sum_tmp_reg[26]~87\)) # (!val_3_reg(27) & ((!\sum_tmp_reg[26]~87\) # (!sum_tmp_reg(27)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(27),
	datab => sum_tmp_reg(27),
	datad => VCC,
	cin => \sum_tmp_reg[26]~87\,
	combout => \sum_tmp_reg[27]~88_combout\,
	cout => \sum_tmp_reg[27]~89\);

-- Location: IOIBUF_X0_Y52_N15
\val_2_i[27]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(27),
	o => \val_2_i[27]~input_o\);

-- Location: LCCOMB_X66_Y52_N28
\val_2_reg[27]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[27]~feeder_combout\ = \val_2_i[27]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[27]~input_o\,
	combout => \val_2_reg[27]~feeder_combout\);

-- Location: FF_X66_Y52_N29
\val_2_reg[27]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[27]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(27));

-- Location: LCCOMB_X66_Y52_N6
\Add0~54\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~54_combout\ = (val_1_reg(27) & ((val_2_reg(27) & (\Add0~53\ & VCC)) # (!val_2_reg(27) & (!\Add0~53\)))) # (!val_1_reg(27) & ((val_2_reg(27) & (!\Add0~53\)) # (!val_2_reg(27) & ((\Add0~53\) # (GND)))))
-- \Add0~55\ = CARRY((val_1_reg(27) & (!val_2_reg(27) & !\Add0~53\)) # (!val_1_reg(27) & ((!\Add0~53\) # (!val_2_reg(27)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(27),
	datab => val_2_reg(27),
	datad => VCC,
	cin => \Add0~53\,
	combout => \Add0~54_combout\,
	cout => \Add0~55\);

-- Location: FF_X67_Y52_N5
\sum_tmp_reg[27]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[27]~88_combout\,
	asdata => \Add0~54_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(27));

-- Location: IOIBUF_X67_Y0_N8
\val_3_i[28]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(28),
	o => \val_3_i[28]~input_o\);

-- Location: LCCOMB_X67_Y52_N24
\val_3_reg[28]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[28]~feeder_combout\ = \val_3_i[28]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_3_i[28]~input_o\,
	combout => \val_3_reg[28]~feeder_combout\);

-- Location: FF_X67_Y52_N25
\val_3_reg[28]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[28]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(28));

-- Location: LCCOMB_X67_Y52_N6
\sum_tmp_reg[28]~90\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[28]~90_combout\ = ((sum_tmp_reg(28) $ (val_3_reg(28) $ (!\sum_tmp_reg[27]~89\)))) # (GND)
-- \sum_tmp_reg[28]~91\ = CARRY((sum_tmp_reg(28) & ((val_3_reg(28)) # (!\sum_tmp_reg[27]~89\))) # (!sum_tmp_reg(28) & (val_3_reg(28) & !\sum_tmp_reg[27]~89\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(28),
	datab => val_3_reg(28),
	datad => VCC,
	cin => \sum_tmp_reg[27]~89\,
	combout => \sum_tmp_reg[28]~90_combout\,
	cout => \sum_tmp_reg[28]~91\);

-- Location: IOIBUF_X0_Y41_N1
\val_1_i[28]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_1_i(28),
	o => \val_1_i[28]~input_o\);

-- Location: FF_X66_Y52_N17
\val_1_reg[28]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_1_i[28]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_1_reg(28));

-- Location: LCCOMB_X66_Y52_N8
\Add0~56\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~56_combout\ = ((val_2_reg(28) $ (val_1_reg(28) $ (!\Add0~55\)))) # (GND)
-- \Add0~57\ = CARRY((val_2_reg(28) & ((val_1_reg(28)) # (!\Add0~55\))) # (!val_2_reg(28) & (val_1_reg(28) & !\Add0~55\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_2_reg(28),
	datab => val_1_reg(28),
	datad => VCC,
	cin => \Add0~55\,
	combout => \Add0~56_combout\,
	cout => \Add0~57\);

-- Location: FF_X67_Y52_N7
\sum_tmp_reg[28]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[28]~90_combout\,
	asdata => \Add0~56_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(28));

-- Location: LCCOMB_X67_Y52_N8
\sum_tmp_reg[29]~92\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[29]~92_combout\ = (val_3_reg(29) & ((sum_tmp_reg(29) & (\sum_tmp_reg[28]~91\ & VCC)) # (!sum_tmp_reg(29) & (!\sum_tmp_reg[28]~91\)))) # (!val_3_reg(29) & ((sum_tmp_reg(29) & (!\sum_tmp_reg[28]~91\)) # (!sum_tmp_reg(29) & 
-- ((\sum_tmp_reg[28]~91\) # (GND)))))
-- \sum_tmp_reg[29]~93\ = CARRY((val_3_reg(29) & (!sum_tmp_reg(29) & !\sum_tmp_reg[28]~91\)) # (!val_3_reg(29) & ((!\sum_tmp_reg[28]~91\) # (!sum_tmp_reg(29)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_3_reg(29),
	datab => sum_tmp_reg(29),
	datad => VCC,
	cin => \sum_tmp_reg[28]~91\,
	combout => \sum_tmp_reg[29]~92_combout\,
	cout => \sum_tmp_reg[29]~93\);

-- Location: IOIBUF_X94_Y8_N8
\val_2_i[29]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(29),
	o => \val_2_i[29]~input_o\);

-- Location: LCCOMB_X66_Y52_N18
\val_2_reg[29]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[29]~feeder_combout\ = \val_2_i[29]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[29]~input_o\,
	combout => \val_2_reg[29]~feeder_combout\);

-- Location: FF_X66_Y52_N19
\val_2_reg[29]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[29]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(29));

-- Location: LCCOMB_X66_Y52_N10
\Add0~58\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~58_combout\ = (val_1_reg(29) & ((val_2_reg(29) & (\Add0~57\ & VCC)) # (!val_2_reg(29) & (!\Add0~57\)))) # (!val_1_reg(29) & ((val_2_reg(29) & (!\Add0~57\)) # (!val_2_reg(29) & ((\Add0~57\) # (GND)))))
-- \Add0~59\ = CARRY((val_1_reg(29) & (!val_2_reg(29) & !\Add0~57\)) # (!val_1_reg(29) & ((!\Add0~57\) # (!val_2_reg(29)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(29),
	datab => val_2_reg(29),
	datad => VCC,
	cin => \Add0~57\,
	combout => \Add0~58_combout\,
	cout => \Add0~59\);

-- Location: FF_X67_Y52_N9
\sum_tmp_reg[29]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[29]~92_combout\,
	asdata => \Add0~58_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(29));

-- Location: IOIBUF_X94_Y27_N15
\val_3_i[30]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(30),
	o => \val_3_i[30]~input_o\);

-- Location: LCCOMB_X67_Y52_N20
\val_3_reg[30]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[30]~feeder_combout\ = \val_3_i[30]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[30]~input_o\,
	combout => \val_3_reg[30]~feeder_combout\);

-- Location: FF_X67_Y52_N21
\val_3_reg[30]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[30]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(30));

-- Location: LCCOMB_X67_Y52_N10
\sum_tmp_reg[30]~94\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[30]~94_combout\ = ((sum_tmp_reg(30) $ (val_3_reg(30) $ (!\sum_tmp_reg[29]~93\)))) # (GND)
-- \sum_tmp_reg[30]~95\ = CARRY((sum_tmp_reg(30) & ((val_3_reg(30)) # (!\sum_tmp_reg[29]~93\))) # (!sum_tmp_reg(30) & (val_3_reg(30) & !\sum_tmp_reg[29]~93\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(30),
	datab => val_3_reg(30),
	datad => VCC,
	cin => \sum_tmp_reg[29]~93\,
	combout => \sum_tmp_reg[30]~94_combout\,
	cout => \sum_tmp_reg[30]~95\);

-- Location: IOIBUF_X62_Y0_N22
\val_2_i[30]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(30),
	o => \val_2_i[30]~input_o\);

-- Location: FF_X66_Y52_N15
\val_2_reg[30]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	asdata => \val_2_i[30]~input_o\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(30));

-- Location: LCCOMB_X66_Y52_N12
\Add0~60\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~60_combout\ = ((val_1_reg(30) $ (val_2_reg(30) $ (!\Add0~59\)))) # (GND)
-- \Add0~61\ = CARRY((val_1_reg(30) & ((val_2_reg(30)) # (!\Add0~59\))) # (!val_1_reg(30) & (val_2_reg(30) & !\Add0~59\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(30),
	datab => val_2_reg(30),
	datad => VCC,
	cin => \Add0~59\,
	combout => \Add0~60_combout\,
	cout => \Add0~61\);

-- Location: FF_X67_Y52_N11
\sum_tmp_reg[30]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[30]~94_combout\,
	asdata => \Add0~60_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(30));

-- Location: IOIBUF_X94_Y44_N22
\val_3_i[31]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_3_i(31),
	o => \val_3_i[31]~input_o\);

-- Location: LCCOMB_X67_Y52_N18
\val_3_reg[31]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_3_reg[31]~feeder_combout\ = \val_3_i[31]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_3_i[31]~input_o\,
	combout => \val_3_reg[31]~feeder_combout\);

-- Location: FF_X67_Y52_N19
\val_3_reg[31]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_3_reg[31]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_3_reg(31));

-- Location: LCCOMB_X67_Y52_N12
\sum_tmp_reg[31]~96\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[31]~96_combout\ = (sum_tmp_reg(31) & ((val_3_reg(31) & (\sum_tmp_reg[30]~95\ & VCC)) # (!val_3_reg(31) & (!\sum_tmp_reg[30]~95\)))) # (!sum_tmp_reg(31) & ((val_3_reg(31) & (!\sum_tmp_reg[30]~95\)) # (!val_3_reg(31) & ((\sum_tmp_reg[30]~95\) # 
-- (GND)))))
-- \sum_tmp_reg[31]~97\ = CARRY((sum_tmp_reg(31) & (!val_3_reg(31) & !\sum_tmp_reg[30]~95\)) # (!sum_tmp_reg(31) & ((!\sum_tmp_reg[30]~95\) # (!val_3_reg(31)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(31),
	datab => val_3_reg(31),
	datad => VCC,
	cin => \sum_tmp_reg[30]~95\,
	combout => \sum_tmp_reg[31]~96_combout\,
	cout => \sum_tmp_reg[31]~97\);

-- Location: LCCOMB_X67_Y52_N14
\sum_tmp_reg[32]~98\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[32]~98_combout\ = ((sum_tmp_reg(32) $ (val_3_reg(31) $ (!\sum_tmp_reg[31]~97\)))) # (GND)
-- \sum_tmp_reg[32]~99\ = CARRY((sum_tmp_reg(32) & ((val_3_reg(31)) # (!\sum_tmp_reg[31]~97\))) # (!sum_tmp_reg(32) & (val_3_reg(31) & !\sum_tmp_reg[31]~97\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(32),
	datab => val_3_reg(31),
	datad => VCC,
	cin => \sum_tmp_reg[31]~97\,
	combout => \sum_tmp_reg[32]~98_combout\,
	cout => \sum_tmp_reg[32]~99\);

-- Location: LCCOMB_X67_Y52_N16
\sum_tmp_reg[33]~100\ : cycloneive_lcell_comb
-- Equation(s):
-- \sum_tmp_reg[33]~100_combout\ = val_3_reg(31) $ (\sum_tmp_reg[32]~99\ $ (sum_tmp_reg(33)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => val_3_reg(31),
	datad => sum_tmp_reg(33),
	cin => \sum_tmp_reg[32]~99\,
	combout => \sum_tmp_reg[33]~100_combout\);

-- Location: IOIBUF_X94_Y28_N15
\val_2_i[31]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_val_2_i(31),
	o => \val_2_i[31]~input_o\);

-- Location: LCCOMB_X66_Y52_N20
\val_2_reg[31]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \val_2_reg[31]~feeder_combout\ = \val_2_i[31]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \val_2_i[31]~input_o\,
	combout => \val_2_reg[31]~feeder_combout\);

-- Location: FF_X66_Y52_N21
\val_2_reg[31]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \val_2_reg[31]~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => val_2_reg(31));

-- Location: LCCOMB_X66_Y52_N14
\Add0~62\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~62_combout\ = (val_1_reg(31) & ((val_2_reg(31) & (\Add0~61\ & VCC)) # (!val_2_reg(31) & (!\Add0~61\)))) # (!val_1_reg(31) & ((val_2_reg(31) & (!\Add0~61\)) # (!val_2_reg(31) & ((\Add0~61\) # (GND)))))
-- \Add0~63\ = CARRY((val_1_reg(31) & (!val_2_reg(31) & !\Add0~61\)) # (!val_1_reg(31) & ((!\Add0~61\) # (!val_2_reg(31)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(31),
	datab => val_2_reg(31),
	datad => VCC,
	cin => \Add0~61\,
	combout => \Add0~62_combout\,
	cout => \Add0~63\);

-- Location: LCCOMB_X66_Y52_N16
\Add0~64\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add0~64_combout\ = val_1_reg(31) $ (\Add0~63\ $ (!val_2_reg(31)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010100101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => val_1_reg(31),
	datad => val_2_reg(31),
	cin => \Add0~63\,
	combout => \Add0~64_combout\);

-- Location: FF_X67_Y52_N17
\sum_tmp_reg[33]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[33]~100_combout\,
	asdata => \Add0~64_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(33));

-- Location: LCCOMB_X66_Y55_N4
\done_o_reg~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \done_o_reg~feeder_combout\ = \state_reg.CHECK~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \state_reg.CHECK~q\,
	combout => \done_o_reg~feeder_combout\);

-- Location: FF_X66_Y55_N5
done_o_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \done_o_reg~feeder_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \done_o_reg~q\);

-- Location: IOIBUF_X60_Y62_N22
\POS_OVF[22]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(22),
	o => \POS_OVF[22]~input_o\);

-- Location: LCCOMB_X68_Y58_N0
\LessThan1~52\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~52_combout\ = \POS_OVF[22]~input_o\ $ (sum_tmp_reg(22))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \POS_OVF[22]~input_o\,
	datad => sum_tmp_reg(22),
	combout => \LessThan1~52_combout\);

-- Location: IOIBUF_X0_Y58_N8
\POS_OVF[28]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(28),
	o => \POS_OVF[28]~input_o\);

-- Location: IOIBUF_X88_Y62_N22
\POS_OVF[25]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(25),
	o => \POS_OVF[25]~input_o\);

-- Location: LCCOMB_X68_Y58_N20
\LessThan1~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~4_combout\ = (\POS_OVF[26]~input_o\ & ((\POS_OVF[25]~input_o\ $ (sum_tmp_reg(25))) # (!sum_tmp_reg(26)))) # (!\POS_OVF[26]~input_o\ & ((sum_tmp_reg(26)) # (\POS_OVF[25]~input_o\ $ (sum_tmp_reg(25)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111110110111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[26]~input_o\,
	datab => \POS_OVF[25]~input_o\,
	datac => sum_tmp_reg(25),
	datad => sum_tmp_reg(26),
	combout => \LessThan1~4_combout\);

-- Location: LCCOMB_X68_Y58_N16
\LessThan1~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~6_combout\ = (!\LessThan1~5_combout\ & (!\LessThan1~4_combout\ & (\POS_OVF[28]~input_o\ $ (!sum_tmp_reg(28)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~5_combout\,
	datab => \POS_OVF[28]~input_o\,
	datac => sum_tmp_reg(28),
	datad => \LessThan1~4_combout\,
	combout => \LessThan1~6_combout\);

-- Location: LCCOMB_X68_Y58_N6
\LessThan1~53\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~53_combout\ = (!\LessThan1~52_combout\ & (\LessThan1~6_combout\ & (\POS_OVF[23]~input_o\ $ (!sum_tmp_reg(23)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[23]~input_o\,
	datab => \LessThan1~52_combout\,
	datac => sum_tmp_reg(23),
	datad => \LessThan1~6_combout\,
	combout => \LessThan1~53_combout\);

-- Location: IOIBUF_X49_Y0_N1
\POS_OVF[30]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(30),
	o => \POS_OVF[30]~input_o\);

-- Location: IOIBUF_X94_Y42_N1
\POS_OVF[29]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(29),
	o => \POS_OVF[29]~input_o\);

-- Location: LCCOMB_X68_Y50_N18
\LessThan1~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~3_combout\ = \POS_OVF[29]~input_o\ $ (sum_tmp_reg(29))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \POS_OVF[29]~input_o\,
	datad => sum_tmp_reg(29),
	combout => \LessThan1~3_combout\);

-- Location: LCCOMB_X68_Y50_N24
\process_1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~0_combout\ = (\LessThan1~2_combout\ & (!\LessThan1~3_combout\ & (sum_tmp_reg(30) $ (!\POS_OVF[30]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~2_combout\,
	datab => sum_tmp_reg(30),
	datac => \POS_OVF[30]~input_o\,
	datad => \LessThan1~3_combout\,
	combout => \process_1~0_combout\);

-- Location: IOIBUF_X85_Y62_N15
\POS_OVF[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(13),
	o => \POS_OVF[13]~input_o\);

-- Location: LCCOMB_X70_Y54_N18
\LessThan1~46\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~46_combout\ = (\POS_OVF[14]~input_o\ & (sum_tmp_reg(13) & (!\POS_OVF[13]~input_o\ & sum_tmp_reg(14)))) # (!\POS_OVF[14]~input_o\ & ((sum_tmp_reg(14)) # ((sum_tmp_reg(13) & !\POS_OVF[13]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101110100000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[14]~input_o\,
	datab => sum_tmp_reg(13),
	datac => \POS_OVF[13]~input_o\,
	datad => sum_tmp_reg(14),
	combout => \LessThan1~46_combout\);

-- Location: IOIBUF_X78_Y62_N22
\POS_OVF[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(14),
	o => \POS_OVF[14]~input_o\);

-- Location: IOIBUF_X78_Y62_N8
\POS_OVF[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(11),
	o => \POS_OVF[11]~input_o\);

-- Location: IOIBUF_X94_Y38_N8
\POS_OVF[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(12),
	o => \POS_OVF[12]~input_o\);

-- Location: LCCOMB_X70_Y54_N4
\LessThan1~43\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~43_combout\ = (sum_tmp_reg(12) & ((\POS_OVF[11]~input_o\ $ (sum_tmp_reg(11))) # (!\POS_OVF[12]~input_o\))) # (!sum_tmp_reg(12) & ((\POS_OVF[12]~input_o\) # (\POS_OVF[11]~input_o\ $ (sum_tmp_reg(11)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(12),
	datab => \POS_OVF[11]~input_o\,
	datac => \POS_OVF[12]~input_o\,
	datad => sum_tmp_reg(11),
	combout => \LessThan1~43_combout\);

-- Location: LCCOMB_X70_Y54_N8
\LessThan1~45\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~45_combout\ = (\LessThan1~44_combout\ & (!\LessThan1~43_combout\ & (\POS_OVF[14]~input_o\ $ (!sum_tmp_reg(14)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~44_combout\,
	datab => \POS_OVF[14]~input_o\,
	datac => \LessThan1~43_combout\,
	datad => sum_tmp_reg(14),
	combout => \LessThan1~45_combout\);

-- Location: LCCOMB_X70_Y54_N2
\LessThan1~48\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~48_combout\ = (!\POS_OVF[11]~input_o\ & sum_tmp_reg(11))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \POS_OVF[11]~input_o\,
	datad => sum_tmp_reg(11),
	combout => \LessThan1~48_combout\);

-- Location: LCCOMB_X70_Y54_N16
\LessThan1~47\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~47_combout\ = (\POS_OVF[14]~input_o\ & (sum_tmp_reg(14) & (sum_tmp_reg(13) $ (!\POS_OVF[13]~input_o\)))) # (!\POS_OVF[14]~input_o\ & (!sum_tmp_reg(14) & (sum_tmp_reg(13) $ (!\POS_OVF[13]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[14]~input_o\,
	datab => sum_tmp_reg(13),
	datac => \POS_OVF[13]~input_o\,
	datad => sum_tmp_reg(14),
	combout => \LessThan1~47_combout\);

-- Location: LCCOMB_X70_Y54_N20
\LessThan1~49\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~49_combout\ = (\LessThan1~47_combout\ & ((sum_tmp_reg(12) & ((\LessThan1~48_combout\) # (!\POS_OVF[12]~input_o\))) # (!sum_tmp_reg(12) & (\LessThan1~48_combout\ & !\POS_OVF[12]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000111000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(12),
	datab => \LessThan1~48_combout\,
	datac => \POS_OVF[12]~input_o\,
	datad => \LessThan1~47_combout\,
	combout => \LessThan1~49_combout\);

-- Location: LCCOMB_X70_Y54_N14
\LessThan1~50\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~50_combout\ = (\LessThan1~42_combout\) # ((\LessThan1~46_combout\) # ((\LessThan1~45_combout\) # (\LessThan1~49_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~42_combout\,
	datab => \LessThan1~46_combout\,
	datac => \LessThan1~45_combout\,
	datad => \LessThan1~49_combout\,
	combout => \LessThan1~50_combout\);

-- Location: IOIBUF_X71_Y0_N1
\POS_OVF[16]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(16),
	o => \POS_OVF[16]~input_o\);

-- Location: IOIBUF_X78_Y0_N8
\POS_OVF[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(15),
	o => \POS_OVF[15]~input_o\);

-- Location: LCCOMB_X71_Y53_N8
\LessThan1~28\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~28_combout\ = sum_tmp_reg(15) $ (\POS_OVF[15]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => sum_tmp_reg(15),
	datad => \POS_OVF[15]~input_o\,
	combout => \LessThan1~28_combout\);

-- Location: IOIBUF_X80_Y0_N8
\POS_OVF[17]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(17),
	o => \POS_OVF[17]~input_o\);

-- Location: IOIBUF_X71_Y0_N22
\POS_OVF[20]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(20),
	o => \POS_OVF[20]~input_o\);

-- Location: LCCOMB_X71_Y53_N18
\LessThan1~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~17_combout\ = (sum_tmp_reg(20) & ((\POS_OVF[17]~input_o\ $ (sum_tmp_reg(17))) # (!\POS_OVF[20]~input_o\))) # (!sum_tmp_reg(20) & ((\POS_OVF[20]~input_o\) # (\POS_OVF[17]~input_o\ $ (sum_tmp_reg(17)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(20),
	datab => \POS_OVF[17]~input_o\,
	datac => \POS_OVF[20]~input_o\,
	datad => sum_tmp_reg(17),
	combout => \LessThan1~17_combout\);

-- Location: IOIBUF_X94_Y11_N8
\POS_OVF[19]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(19),
	o => \POS_OVF[19]~input_o\);

-- Location: LCCOMB_X71_Y53_N28
\LessThan1~16\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~16_combout\ = (\POS_OVF[18]~input_o\ & ((\POS_OVF[19]~input_o\ $ (sum_tmp_reg(19))) # (!sum_tmp_reg(18)))) # (!\POS_OVF[18]~input_o\ & ((sum_tmp_reg(18)) # (\POS_OVF[19]~input_o\ $ (sum_tmp_reg(19)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111110110111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[18]~input_o\,
	datab => \POS_OVF[19]~input_o\,
	datac => sum_tmp_reg(19),
	datad => sum_tmp_reg(18),
	combout => \LessThan1~16_combout\);

-- Location: LCCOMB_X71_Y53_N24
\LessThan1~18\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~18_combout\ = (!\LessThan1~17_combout\ & (!\LessThan1~16_combout\ & (\POS_OVF[21]~input_o\ $ (!sum_tmp_reg(21)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[21]~input_o\,
	datab => \LessThan1~17_combout\,
	datac => sum_tmp_reg(21),
	datad => \LessThan1~16_combout\,
	combout => \LessThan1~18_combout\);

-- Location: LCCOMB_X71_Y53_N6
\LessThan1~29\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~29_combout\ = (!\LessThan1~28_combout\ & (\LessThan1~18_combout\ & (sum_tmp_reg(16) $ (!\POS_OVF[16]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(16),
	datab => \POS_OVF[16]~input_o\,
	datac => \LessThan1~28_combout\,
	datad => \LessThan1~18_combout\,
	combout => \LessThan1~29_combout\);

-- Location: IOIBUF_X78_Y62_N15
\POS_OVF[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(10),
	o => \POS_OVF[10]~input_o\);

-- Location: LCCOMB_X70_Y54_N22
\LessThan1~36\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~36_combout\ = (sum_tmp_reg(10) & ((\POS_OVF[11]~input_o\ $ (sum_tmp_reg(11))) # (!\POS_OVF[10]~input_o\))) # (!sum_tmp_reg(10) & ((\POS_OVF[10]~input_o\) # (\POS_OVF[11]~input_o\ $ (sum_tmp_reg(11)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(10),
	datab => \POS_OVF[11]~input_o\,
	datac => \POS_OVF[10]~input_o\,
	datad => sum_tmp_reg(11),
	combout => \LessThan1~36_combout\);

-- Location: LCCOMB_X70_Y54_N24
\LessThan1~37\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~37_combout\ = (sum_tmp_reg(12) & ((\POS_OVF[13]~input_o\ $ (sum_tmp_reg(13))) # (!\POS_OVF[12]~input_o\))) # (!sum_tmp_reg(12) & ((\POS_OVF[12]~input_o\) # (\POS_OVF[13]~input_o\ $ (sum_tmp_reg(13)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(12),
	datab => \POS_OVF[13]~input_o\,
	datac => \POS_OVF[12]~input_o\,
	datad => sum_tmp_reg(13),
	combout => \LessThan1~37_combout\);

-- Location: LCCOMB_X70_Y54_N6
\LessThan1~38\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~38_combout\ = (!\LessThan1~36_combout\ & (!\LessThan1~37_combout\ & (\POS_OVF[14]~input_o\ $ (!sum_tmp_reg(14)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[14]~input_o\,
	datab => sum_tmp_reg(14),
	datac => \LessThan1~36_combout\,
	datad => \LessThan1~37_combout\,
	combout => \LessThan1~38_combout\);

-- Location: LCCOMB_X70_Y54_N0
\LessThan1~39\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~39_combout\ = (\LessThan1~38_combout\ & (\POS_OVF[9]~input_o\ $ (!sum_tmp_reg(9))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001100100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[9]~input_o\,
	datab => sum_tmp_reg(9),
	datad => \LessThan1~38_combout\,
	combout => \LessThan1~39_combout\);

-- Location: IOIBUF_X94_Y23_N1
\POS_OVF[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(7),
	o => \POS_OVF[7]~input_o\);

-- Location: IOIBUF_X40_Y62_N22
\POS_OVF[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(5),
	o => \POS_OVF[5]~input_o\);

-- Location: IOIBUF_X92_Y62_N15
\POS_OVF[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(2),
	o => \POS_OVF[2]~input_o\);

-- Location: IOIBUF_X16_Y62_N1
\POS_OVF[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_POS_OVF(0),
	o => \POS_OVF[0]~input_o\);

-- Location: LCCOMB_X67_Y54_N2
\LessThan1~30\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~30_combout\ = (\POS_OVF[1]~input_o\ & (!\POS_OVF[0]~input_o\ & (sum_tmp_reg(0) & sum_tmp_reg(1)))) # (!\POS_OVF[1]~input_o\ & ((sum_tmp_reg(1)) # ((!\POS_OVF[0]~input_o\ & sum_tmp_reg(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010100010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[1]~input_o\,
	datab => \POS_OVF[0]~input_o\,
	datac => sum_tmp_reg(0),
	datad => sum_tmp_reg(1),
	combout => \LessThan1~30_combout\);

-- Location: LCCOMB_X68_Y54_N0
\LessThan1~31\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~31_combout\ = (sum_tmp_reg(2) & ((\LessThan1~30_combout\) # (!\POS_OVF[2]~input_o\))) # (!sum_tmp_reg(2) & (!\POS_OVF[2]~input_o\ & \LessThan1~30_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111100001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => sum_tmp_reg(2),
	datac => \POS_OVF[2]~input_o\,
	datad => \LessThan1~30_combout\,
	combout => \LessThan1~31_combout\);

-- Location: LCCOMB_X68_Y54_N30
\LessThan1~32\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~32_combout\ = (\POS_OVF[3]~input_o\ & (sum_tmp_reg(3) & \LessThan1~31_combout\)) # (!\POS_OVF[3]~input_o\ & ((sum_tmp_reg(3)) # (\LessThan1~31_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110101000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[3]~input_o\,
	datab => sum_tmp_reg(3),
	datad => \LessThan1~31_combout\,
	combout => \LessThan1~32_combout\);

-- Location: LCCOMB_X68_Y54_N28
\LessThan1~56\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~56_combout\ = (\POS_OVF[4]~input_o\ & (\LessThan1~32_combout\ & sum_tmp_reg(4))) # (!\POS_OVF[4]~input_o\ & ((\LessThan1~32_combout\) # (sum_tmp_reg(4))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[4]~input_o\,
	datac => \LessThan1~32_combout\,
	datad => sum_tmp_reg(4),
	combout => \LessThan1~56_combout\);

-- Location: LCCOMB_X68_Y54_N16
\LessThan1~33\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~33_combout\ = (sum_tmp_reg(5) & ((\LessThan1~56_combout\) # (!\POS_OVF[5]~input_o\))) # (!sum_tmp_reg(5) & (!\POS_OVF[5]~input_o\ & \LessThan1~56_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111100001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => sum_tmp_reg(5),
	datac => \POS_OVF[5]~input_o\,
	datad => \LessThan1~56_combout\,
	combout => \LessThan1~33_combout\);

-- Location: LCCOMB_X68_Y54_N6
\LessThan1~34\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~34_combout\ = (\POS_OVF[6]~input_o\ & (sum_tmp_reg(6) & \LessThan1~33_combout\)) # (!\POS_OVF[6]~input_o\ & ((sum_tmp_reg(6)) # (\LessThan1~33_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[6]~input_o\,
	datac => sum_tmp_reg(6),
	datad => \LessThan1~33_combout\,
	combout => \LessThan1~34_combout\);

-- Location: LCCOMB_X68_Y54_N8
\LessThan1~35\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~35_combout\ = (sum_tmp_reg(7) & ((\LessThan1~34_combout\) # (!\POS_OVF[7]~input_o\))) # (!sum_tmp_reg(7) & (!\POS_OVF[7]~input_o\ & \LessThan1~34_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111100001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => sum_tmp_reg(7),
	datac => \POS_OVF[7]~input_o\,
	datad => \LessThan1~34_combout\,
	combout => \LessThan1~35_combout\);

-- Location: LCCOMB_X69_Y54_N18
\LessThan1~40\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~40_combout\ = (\LessThan1~39_combout\ & (\LessThan1~35_combout\ & (\POS_OVF[8]~input_o\ $ (!sum_tmp_reg(8)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \POS_OVF[8]~input_o\,
	datab => sum_tmp_reg(8),
	datac => \LessThan1~39_combout\,
	datad => \LessThan1~35_combout\,
	combout => \LessThan1~40_combout\);

-- Location: LCCOMB_X69_Y54_N6
\LessThan1~51\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~51_combout\ = (\LessThan1~27_combout\) # ((\LessThan1~29_combout\ & ((\LessThan1~50_combout\) # (\LessThan1~40_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~27_combout\,
	datab => \LessThan1~50_combout\,
	datac => \LessThan1~29_combout\,
	datad => \LessThan1~40_combout\,
	combout => \LessThan1~51_combout\);

-- Location: LCCOMB_X69_Y54_N8
\process_1~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~1_combout\ = (\process_1~0_combout\ & ((\LessThan1~15_combout\) # ((\LessThan1~53_combout\ & \LessThan1~51_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan1~15_combout\,
	datab => \LessThan1~53_combout\,
	datac => \process_1~0_combout\,
	datad => \LessThan1~51_combout\,
	combout => \process_1~1_combout\);

-- Location: IOIBUF_X0_Y55_N15
\NEG_OVF[28]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(28),
	o => \NEG_OVF[28]~input_o\);

-- Location: IOIBUF_X0_Y55_N22
\NEG_OVF[25]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(25),
	o => \NEG_OVF[25]~input_o\);

-- Location: LCCOMB_X67_Y55_N14
\LessThan0~41\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~41_combout\ = (\NEG_OVF[26]~input_o\ & ((\NEG_OVF[25]~input_o\ $ (sum_tmp_reg(25))) # (!sum_tmp_reg(26)))) # (!\NEG_OVF[26]~input_o\ & ((sum_tmp_reg(26)) # (\NEG_OVF[25]~input_o\ $ (sum_tmp_reg(25)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111110110111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[26]~input_o\,
	datab => \NEG_OVF[25]~input_o\,
	datac => sum_tmp_reg(25),
	datad => sum_tmp_reg(26),
	combout => \LessThan0~41_combout\);

-- Location: IOIBUF_X36_Y62_N8
\NEG_OVF[27]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(27),
	o => \NEG_OVF[27]~input_o\);

-- Location: LCCOMB_X67_Y55_N6
\LessThan0~48\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~48_combout\ = (\NEG_OVF[24]~input_o\ & (!sum_tmp_reg(24) & (\NEG_OVF[27]~input_o\ $ (!sum_tmp_reg(27)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[24]~input_o\,
	datab => \NEG_OVF[27]~input_o\,
	datac => sum_tmp_reg(27),
	datad => sum_tmp_reg(24),
	combout => \LessThan0~48_combout\);

-- Location: LCCOMB_X67_Y55_N24
\LessThan0~49\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~49_combout\ = (!\LessThan0~41_combout\ & (\LessThan0~48_combout\ & (sum_tmp_reg(28) $ (!\NEG_OVF[28]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(28),
	datab => \NEG_OVF[28]~input_o\,
	datac => \LessThan0~41_combout\,
	datad => \LessThan0~48_combout\,
	combout => \LessThan0~49_combout\);

-- Location: LCCOMB_X67_Y55_N20
\LessThan0~51\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~51_combout\ = (sum_tmp_reg(28) & (\NEG_OVF[28]~input_o\ & (\NEG_OVF[27]~input_o\ $ (!sum_tmp_reg(27))))) # (!sum_tmp_reg(28) & (!\NEG_OVF[28]~input_o\ & (\NEG_OVF[27]~input_o\ $ (!sum_tmp_reg(27)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(28),
	datab => \NEG_OVF[27]~input_o\,
	datac => sum_tmp_reg(27),
	datad => \NEG_OVF[28]~input_o\,
	combout => \LessThan0~51_combout\);

-- Location: LCCOMB_X67_Y55_N22
\LessThan0~52\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~52_combout\ = (\NEG_OVF[25]~input_o\ & !sum_tmp_reg(25))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \NEG_OVF[25]~input_o\,
	datac => sum_tmp_reg(25),
	combout => \LessThan0~52_combout\);

-- Location: LCCOMB_X67_Y55_N4
\LessThan0~53\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~53_combout\ = (\LessThan0~51_combout\ & ((\NEG_OVF[26]~input_o\ & ((\LessThan0~52_combout\) # (!sum_tmp_reg(26)))) # (!\NEG_OVF[26]~input_o\ & (\LessThan0~52_combout\ & !sum_tmp_reg(26)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000011001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[26]~input_o\,
	datab => \LessThan0~51_combout\,
	datac => \LessThan0~52_combout\,
	datad => sum_tmp_reg(26),
	combout => \LessThan0~53_combout\);

-- Location: IOIBUF_X73_Y62_N8
\NEG_OVF[22]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(22),
	o => \NEG_OVF[22]~input_o\);

-- Location: LCCOMB_X67_Y55_N10
\LessThan0~46\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~46_combout\ = (!sum_tmp_reg(22) & \NEG_OVF[22]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => sum_tmp_reg(22),
	datad => \NEG_OVF[22]~input_o\,
	combout => \LessThan0~46_combout\);

-- Location: LCCOMB_X67_Y55_N0
\LessThan0~42\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~42_combout\ = (\NEG_OVF[24]~input_o\ & ((\NEG_OVF[27]~input_o\ $ (sum_tmp_reg(27))) # (!sum_tmp_reg(24)))) # (!\NEG_OVF[24]~input_o\ & ((sum_tmp_reg(24)) # (\NEG_OVF[27]~input_o\ $ (sum_tmp_reg(27)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111110110111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[24]~input_o\,
	datab => \NEG_OVF[27]~input_o\,
	datac => sum_tmp_reg(27),
	datad => sum_tmp_reg(24),
	combout => \LessThan0~42_combout\);

-- Location: LCCOMB_X67_Y55_N18
\LessThan0~43\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~43_combout\ = (!\LessThan0~41_combout\ & (!\LessThan0~42_combout\ & (sum_tmp_reg(28) $ (!\NEG_OVF[28]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(28),
	datab => \NEG_OVF[28]~input_o\,
	datac => \LessThan0~41_combout\,
	datad => \LessThan0~42_combout\,
	combout => \LessThan0~43_combout\);

-- Location: LCCOMB_X67_Y55_N16
\LessThan0~47\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~47_combout\ = (\LessThan0~43_combout\ & ((\NEG_OVF[23]~input_o\ & ((\LessThan0~46_combout\) # (!sum_tmp_reg(23)))) # (!\NEG_OVF[23]~input_o\ & (\LessThan0~46_combout\ & !sum_tmp_reg(23)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000111000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[23]~input_o\,
	datab => \LessThan0~46_combout\,
	datac => sum_tmp_reg(23),
	datad => \LessThan0~43_combout\,
	combout => \LessThan0~47_combout\);

-- Location: LCCOMB_X67_Y55_N30
\LessThan0~54\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~54_combout\ = (\LessThan0~50_combout\) # ((\LessThan0~49_combout\) # ((\LessThan0~53_combout\) # (\LessThan0~47_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~50_combout\,
	datab => \LessThan0~49_combout\,
	datac => \LessThan0~53_combout\,
	datad => \LessThan0~47_combout\,
	combout => \LessThan0~54_combout\);

-- Location: IOIBUF_X94_Y18_N1
\NEG_OVF[29]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(29),
	o => \NEG_OVF[29]~input_o\);

-- Location: LCCOMB_X68_Y50_N22
\LessThan0~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~3_combout\ = \NEG_OVF[29]~input_o\ $ (sum_tmp_reg(29))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \NEG_OVF[29]~input_o\,
	datad => sum_tmp_reg(29),
	combout => \LessThan0~3_combout\);

-- Location: FF_X67_Y52_N15
\sum_tmp_reg[32]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[32]~98_combout\,
	asdata => \Add0~64_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(32));

-- Location: FF_X67_Y52_N13
\sum_tmp_reg[31]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \sum_tmp_reg[31]~96_combout\,
	asdata => \Add0~62_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	sload => \ALT_INV_state_reg.SUM_2~q\,
	ena => \state_reg.IDLE~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => sum_tmp_reg(31));

-- Location: LCCOMB_X68_Y50_N2
\LessThan0~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~2_combout\ = (\NEG_OVF[31]~input_o\ & (sum_tmp_reg(33) & (sum_tmp_reg(32) & sum_tmp_reg(31)))) # (!\NEG_OVF[31]~input_o\ & (!sum_tmp_reg(33) & (!sum_tmp_reg(32) & !sum_tmp_reg(31))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[31]~input_o\,
	datab => sum_tmp_reg(33),
	datac => sum_tmp_reg(32),
	datad => sum_tmp_reg(31),
	combout => \LessThan0~2_combout\);

-- Location: LCCOMB_X68_Y50_N16
\LessThan1~55\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~55_combout\ = (!\LessThan0~3_combout\ & (\LessThan0~2_combout\ & (\NEG_OVF[30]~input_o\ $ (!sum_tmp_reg(30)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[30]~input_o\,
	datab => sum_tmp_reg(30),
	datac => \LessThan0~3_combout\,
	datad => \LessThan0~2_combout\,
	combout => \LessThan1~55_combout\);

-- Location: LCCOMB_X67_Y55_N12
\LessThan0~44\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~44_combout\ = (\LessThan0~43_combout\ & (\NEG_OVF[23]~input_o\ $ (!sum_tmp_reg(23))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[23]~input_o\,
	datac => sum_tmp_reg(23),
	datad => \LessThan0~43_combout\,
	combout => \LessThan0~44_combout\);

-- Location: IOIBUF_X94_Y21_N22
\NEG_OVF[16]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(16),
	o => \NEG_OVF[16]~input_o\);

-- Location: IOIBUF_X94_Y19_N8
\NEG_OVF[21]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(21),
	o => \NEG_OVF[21]~input_o\);

-- Location: IOIBUF_X94_Y26_N22
\NEG_OVF[19]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(19),
	o => \NEG_OVF[19]~input_o\);

-- Location: LCCOMB_X70_Y53_N8
\LessThan0~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~5_combout\ = (\NEG_OVF[20]~input_o\ & ((\NEG_OVF[19]~input_o\ $ (sum_tmp_reg(19))) # (!sum_tmp_reg(20)))) # (!\NEG_OVF[20]~input_o\ & ((sum_tmp_reg(20)) # (\NEG_OVF[19]~input_o\ $ (sum_tmp_reg(19)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[20]~input_o\,
	datab => \NEG_OVF[19]~input_o\,
	datac => sum_tmp_reg(20),
	datad => sum_tmp_reg(19),
	combout => \LessThan0~5_combout\);

-- Location: IOIBUF_X94_Y8_N15
\NEG_OVF[18]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(18),
	o => \NEG_OVF[18]~input_o\);

-- Location: LCCOMB_X70_Y53_N10
\LessThan0~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~4_combout\ = (\NEG_OVF[17]~input_o\ & ((\NEG_OVF[18]~input_o\ $ (sum_tmp_reg(18))) # (!sum_tmp_reg(17)))) # (!\NEG_OVF[17]~input_o\ & ((sum_tmp_reg(17)) # (\NEG_OVF[18]~input_o\ $ (sum_tmp_reg(18)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[17]~input_o\,
	datab => \NEG_OVF[18]~input_o\,
	datac => sum_tmp_reg(17),
	datad => sum_tmp_reg(18),
	combout => \LessThan0~4_combout\);

-- Location: LCCOMB_X70_Y53_N6
\LessThan0~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~6_combout\ = (!\LessThan0~5_combout\ & (!\LessThan0~4_combout\ & (sum_tmp_reg(21) $ (!\NEG_OVF[21]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(21),
	datab => \NEG_OVF[21]~input_o\,
	datac => \LessThan0~5_combout\,
	datad => \LessThan0~4_combout\,
	combout => \LessThan0~6_combout\);

-- Location: LCCOMB_X70_Y53_N2
\LessThan0~18\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~18_combout\ = (!\LessThan0~17_combout\ & (\LessThan0~6_combout\ & (\NEG_OVF[16]~input_o\ $ (!sum_tmp_reg(16)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~17_combout\,
	datab => \NEG_OVF[16]~input_o\,
	datac => sum_tmp_reg(16),
	datad => \LessThan0~6_combout\,
	combout => \LessThan0~18_combout\);

-- Location: LCCOMB_X70_Y53_N20
\LessThan0~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~12_combout\ = (\NEG_OVF[21]~input_o\ & (((\NEG_OVF[20]~input_o\ & !sum_tmp_reg(20))) # (!sum_tmp_reg(21)))) # (!\NEG_OVF[21]~input_o\ & (\NEG_OVF[20]~input_o\ & (!sum_tmp_reg(20) & !sum_tmp_reg(21))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000011110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[20]~input_o\,
	datab => sum_tmp_reg(20),
	datac => \NEG_OVF[21]~input_o\,
	datad => sum_tmp_reg(21),
	combout => \LessThan0~12_combout\);

-- Location: IOIBUF_X94_Y21_N15
\NEG_OVF[17]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(17),
	o => \NEG_OVF[17]~input_o\);

-- Location: LCCOMB_X70_Y53_N0
\LessThan0~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~10_combout\ = (!sum_tmp_reg(17) & (\NEG_OVF[17]~input_o\ & (\NEG_OVF[20]~input_o\ $ (!sum_tmp_reg(20)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[20]~input_o\,
	datab => sum_tmp_reg(17),
	datac => sum_tmp_reg(20),
	datad => \NEG_OVF[17]~input_o\,
	combout => \LessThan0~10_combout\);

-- Location: LCCOMB_X70_Y53_N30
\LessThan0~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~11_combout\ = (!\LessThan0~9_combout\ & (\LessThan0~10_combout\ & (\NEG_OVF[21]~input_o\ $ (!sum_tmp_reg(21)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~9_combout\,
	datab => \NEG_OVF[21]~input_o\,
	datac => sum_tmp_reg(21),
	datad => \LessThan0~10_combout\,
	combout => \LessThan0~11_combout\);

-- Location: IOIBUF_X78_Y0_N1
\NEG_OVF[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(15),
	o => \NEG_OVF[15]~input_o\);

-- Location: LCCOMB_X70_Y54_N28
\LessThan0~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~7_combout\ = (\NEG_OVF[15]~input_o\ & !sum_tmp_reg(15))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \NEG_OVF[15]~input_o\,
	datad => sum_tmp_reg(15),
	combout => \LessThan0~7_combout\);

-- Location: LCCOMB_X70_Y53_N12
\LessThan0~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~8_combout\ = (\LessThan0~6_combout\ & ((\NEG_OVF[16]~input_o\ & ((\LessThan0~7_combout\) # (!sum_tmp_reg(16)))) # (!\NEG_OVF[16]~input_o\ & (!sum_tmp_reg(16) & \LessThan0~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000101000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~6_combout\,
	datab => \NEG_OVF[16]~input_o\,
	datac => sum_tmp_reg(16),
	datad => \LessThan0~7_combout\,
	combout => \LessThan0~8_combout\);

-- Location: LCCOMB_X70_Y53_N16
\LessThan0~16\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~16_combout\ = (\LessThan0~15_combout\) # ((\LessThan0~12_combout\) # ((\LessThan0~11_combout\) # (\LessThan0~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~15_combout\,
	datab => \LessThan0~12_combout\,
	datac => \LessThan0~11_combout\,
	datad => \LessThan0~8_combout\,
	combout => \LessThan0~16_combout\);

-- Location: IOIBUF_X69_Y0_N8
\NEG_OVF[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(14),
	o => \NEG_OVF[14]~input_o\);

-- Location: IOIBUF_X73_Y0_N15
\NEG_OVF[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(11),
	o => \NEG_OVF[11]~input_o\);

-- Location: LCCOMB_X69_Y53_N8
\LessThan0~25\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~25_combout\ = (\NEG_OVF[10]~input_o\ & ((\NEG_OVF[11]~input_o\ $ (sum_tmp_reg(11))) # (!sum_tmp_reg(10)))) # (!\NEG_OVF[10]~input_o\ & ((sum_tmp_reg(10)) # (\NEG_OVF[11]~input_o\ $ (sum_tmp_reg(11)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111110110111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[10]~input_o\,
	datab => \NEG_OVF[11]~input_o\,
	datac => sum_tmp_reg(11),
	datad => sum_tmp_reg(10),
	combout => \LessThan0~25_combout\);

-- Location: LCCOMB_X69_Y53_N0
\LessThan0~27\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~27_combout\ = (!\LessThan0~26_combout\ & (!\LessThan0~25_combout\ & (\NEG_OVF[14]~input_o\ $ (!sum_tmp_reg(14)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~26_combout\,
	datab => \NEG_OVF[14]~input_o\,
	datac => \LessThan0~25_combout\,
	datad => sum_tmp_reg(14),
	combout => \LessThan0~27_combout\);

-- Location: LCCOMB_X69_Y54_N22
\LessThan0~28\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~28_combout\ = (\LessThan0~27_combout\ & (\NEG_OVF[9]~input_o\ $ (!sum_tmp_reg(9))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001100100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[9]~input_o\,
	datab => sum_tmp_reg(9),
	datad => \LessThan0~27_combout\,
	combout => \LessThan0~28_combout\);

-- Location: IOIBUF_X45_Y62_N1
\NEG_OVF[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(7),
	o => \NEG_OVF[7]~input_o\);

-- Location: IOIBUF_X94_Y39_N15
\NEG_OVF[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(6),
	o => \NEG_OVF[6]~input_o\);

-- Location: IOIBUF_X25_Y62_N22
\NEG_OVF[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(5),
	o => \NEG_OVF[5]~input_o\);

-- Location: IOIBUF_X90_Y62_N8
\NEG_OVF[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(4),
	o => \NEG_OVF[4]~input_o\);

-- Location: IOIBUF_X45_Y62_N22
\NEG_OVF[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(3),
	o => \NEG_OVF[3]~input_o\);

-- Location: IOIBUF_X94_Y39_N22
\NEG_OVF[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(2),
	o => \NEG_OVF[2]~input_o\);

-- Location: IOIBUF_X36_Y62_N1
\NEG_OVF[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_NEG_OVF(1),
	o => \NEG_OVF[1]~input_o\);

-- Location: LCCOMB_X67_Y54_N8
\LessThan0~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~19_combout\ = (\NEG_OVF[1]~input_o\ & (((\NEG_OVF[0]~input_o\ & !sum_tmp_reg(0))) # (!sum_tmp_reg(1)))) # (!\NEG_OVF[1]~input_o\ & (\NEG_OVF[0]~input_o\ & (!sum_tmp_reg(0) & !sum_tmp_reg(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100011001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[0]~input_o\,
	datab => \NEG_OVF[1]~input_o\,
	datac => sum_tmp_reg(0),
	datad => sum_tmp_reg(1),
	combout => \LessThan0~19_combout\);

-- Location: LCCOMB_X68_Y54_N18
\LessThan0~20\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~20_combout\ = (sum_tmp_reg(2) & (\NEG_OVF[2]~input_o\ & \LessThan0~19_combout\)) # (!sum_tmp_reg(2) & ((\NEG_OVF[2]~input_o\) # (\LessThan0~19_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => sum_tmp_reg(2),
	datac => \NEG_OVF[2]~input_o\,
	datad => \LessThan0~19_combout\,
	combout => \LessThan0~20_combout\);

-- Location: LCCOMB_X68_Y54_N24
\LessThan0~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~21_combout\ = (sum_tmp_reg(3) & (\NEG_OVF[3]~input_o\ & \LessThan0~20_combout\)) # (!sum_tmp_reg(3) & ((\NEG_OVF[3]~input_o\) # (\LessThan0~20_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => sum_tmp_reg(3),
	datac => \NEG_OVF[3]~input_o\,
	datad => \LessThan0~20_combout\,
	combout => \LessThan0~21_combout\);

-- Location: LCCOMB_X68_Y54_N10
\LessThan0~55\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~55_combout\ = (sum_tmp_reg(4) & (\NEG_OVF[4]~input_o\ & \LessThan0~21_combout\)) # (!sum_tmp_reg(4) & ((\NEG_OVF[4]~input_o\) # (\LessThan0~21_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => sum_tmp_reg(4),
	datac => \NEG_OVF[4]~input_o\,
	datad => \LessThan0~21_combout\,
	combout => \LessThan0~55_combout\);

-- Location: LCCOMB_X68_Y54_N2
\LessThan0~22\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~22_combout\ = (sum_tmp_reg(5) & (\NEG_OVF[5]~input_o\ & \LessThan0~55_combout\)) # (!sum_tmp_reg(5) & ((\NEG_OVF[5]~input_o\) # (\LessThan0~55_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => sum_tmp_reg(5),
	datac => \NEG_OVF[5]~input_o\,
	datad => \LessThan0~55_combout\,
	combout => \LessThan0~22_combout\);

-- Location: LCCOMB_X68_Y54_N12
\LessThan0~23\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~23_combout\ = (\NEG_OVF[6]~input_o\ & ((\LessThan0~22_combout\) # (!sum_tmp_reg(6)))) # (!\NEG_OVF[6]~input_o\ & (!sum_tmp_reg(6) & \LessThan0~22_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111100001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \NEG_OVF[6]~input_o\,
	datac => sum_tmp_reg(6),
	datad => \LessThan0~22_combout\,
	combout => \LessThan0~23_combout\);

-- Location: LCCOMB_X68_Y54_N14
\LessThan0~24\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~24_combout\ = (sum_tmp_reg(7) & (\NEG_OVF[7]~input_o\ & \LessThan0~23_combout\)) # (!sum_tmp_reg(7) & ((\NEG_OVF[7]~input_o\) # (\LessThan0~23_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => sum_tmp_reg(7),
	datac => \NEG_OVF[7]~input_o\,
	datad => \LessThan0~23_combout\,
	combout => \LessThan0~24_combout\);

-- Location: LCCOMB_X69_Y54_N28
\LessThan0~29\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~29_combout\ = (\LessThan0~28_combout\ & (\LessThan0~24_combout\ & (\NEG_OVF[8]~input_o\ $ (!sum_tmp_reg(8)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \NEG_OVF[8]~input_o\,
	datab => sum_tmp_reg(8),
	datac => \LessThan0~28_combout\,
	datad => \LessThan0~24_combout\,
	combout => \LessThan0~29_combout\);

-- Location: LCCOMB_X69_Y54_N12
\LessThan0~40\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~40_combout\ = (\LessThan0~16_combout\) # ((\LessThan0~18_combout\ & ((\LessThan0~39_combout\) # (\LessThan0~29_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~39_combout\,
	datab => \LessThan0~18_combout\,
	datac => \LessThan0~16_combout\,
	datad => \LessThan0~29_combout\,
	combout => \LessThan0~40_combout\);

-- Location: LCCOMB_X69_Y54_N10
\LessThan0~45\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~45_combout\ = (\LessThan0~44_combout\ & (\LessThan0~40_combout\ & (sum_tmp_reg(22) $ (!\NEG_OVF[22]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => sum_tmp_reg(22),
	datab => \LessThan0~44_combout\,
	datac => \NEG_OVF[22]~input_o\,
	datad => \LessThan0~40_combout\,
	combout => \LessThan0~45_combout\);

-- Location: LCCOMB_X69_Y54_N20
\process_1~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_1~8_combout\ = (\process_1~7_combout\) # ((\LessThan1~55_combout\ & ((\LessThan0~54_combout\) # (\LessThan0~45_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \process_1~7_combout\,
	datab => \LessThan0~54_combout\,
	datac => \LessThan1~55_combout\,
	datad => \LessThan0~45_combout\,
	combout => \process_1~8_combout\);

-- Location: LCCOMB_X69_Y54_N16
\ovf_sign_next~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \ovf_sign_next~0_combout\ = (\state_reg.CHECK~q\ & ((\process_1~1_combout\) # (\process_1~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \state_reg.CHECK~q\,
	datac => \process_1~1_combout\,
	datad => \process_1~8_combout\,
	combout => \ovf_sign_next~0_combout\);

-- Location: FF_X69_Y54_N17
ovf_sign_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \sysclk~inputclkctrl_outclk\,
	d => \ovf_sign_next~0_combout\,
	clrn => \reset_n~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ovf_sign_reg~q\);

ww_val_o(0) <= \val_o[0]~output_o\;

ww_val_o(1) <= \val_o[1]~output_o\;

ww_val_o(2) <= \val_o[2]~output_o\;

ww_val_o(3) <= \val_o[3]~output_o\;

ww_val_o(4) <= \val_o[4]~output_o\;

ww_val_o(5) <= \val_o[5]~output_o\;

ww_val_o(6) <= \val_o[6]~output_o\;

ww_val_o(7) <= \val_o[7]~output_o\;

ww_val_o(8) <= \val_o[8]~output_o\;

ww_val_o(9) <= \val_o[9]~output_o\;

ww_val_o(10) <= \val_o[10]~output_o\;

ww_val_o(11) <= \val_o[11]~output_o\;

ww_val_o(12) <= \val_o[12]~output_o\;

ww_val_o(13) <= \val_o[13]~output_o\;

ww_val_o(14) <= \val_o[14]~output_o\;

ww_val_o(15) <= \val_o[15]~output_o\;

ww_val_o(16) <= \val_o[16]~output_o\;

ww_val_o(17) <= \val_o[17]~output_o\;

ww_val_o(18) <= \val_o[18]~output_o\;

ww_val_o(19) <= \val_o[19]~output_o\;

ww_val_o(20) <= \val_o[20]~output_o\;

ww_val_o(21) <= \val_o[21]~output_o\;

ww_val_o(22) <= \val_o[22]~output_o\;

ww_val_o(23) <= \val_o[23]~output_o\;

ww_val_o(24) <= \val_o[24]~output_o\;

ww_val_o(25) <= \val_o[25]~output_o\;

ww_val_o(26) <= \val_o[26]~output_o\;

ww_val_o(27) <= \val_o[27]~output_o\;

ww_val_o(28) <= \val_o[28]~output_o\;

ww_val_o(29) <= \val_o[29]~output_o\;

ww_val_o(30) <= \val_o[30]~output_o\;

ww_val_o(31) <= \val_o[31]~output_o\;

ww_done_o <= \done_o~output_o\;

ww_ovf_o <= \ovf_o~output_o\;
END structure;


