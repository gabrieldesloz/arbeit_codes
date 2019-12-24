--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:09:51 08/06/2013
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L8/BENCH_FPGA/BENCH_FPGA_V00_35/TB_EJECTORS_DATA_SENDER.vhd
-- Project Name:  BENCH_FPGA_V00_35
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EJECTORS_DATA_SENDER
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--package my_types_pkg is		-- Creates a type to use arrays in the entity declaration
--	type input_array is array (7 downto 0) of std_logic_vector (31 downto 0);	-- The array type
--end package;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library work;
use work.my_types_pkg.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_EJECTORS_DATA_SENDER IS
END TB_EJECTORS_DATA_SENDER;
 
ARCHITECTURE behavior OF TB_EJECTORS_DATA_SENDER IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EJECTORS_DATA_SENDER
    PORT(
         EJ_PKT_i : IN  std_logic_vector(34 downto 0);
         TEJET_i : IN  std_logic_vector(31 downto 0);
         EJATXDATA_i : IN  std_logic_vector(31 downto 0);
         EJBTXDATA_i : IN  std_logic_vector(31 downto 0);
         DO_TESTEJETA_i : IN  std_logic;
         DO_TESTEJETB_i : IN  std_logic;
         ISPACA_i : IN  std_logic;
         ISPACB_i : IN  std_logic;
         EJ_RX_i : IN  std_logic;
         CLK_i : IN  std_logic;
         RST_i : IN  std_logic;
			  EJARXDATA_o : out input_array;									-- Output array		-- 000 - Fuse information
			  EJBRXDATA_o : out input_array;									-- Output array		-- 001 - Not used
         CLRPACA_o : OUT  std_logic;
         CLRPACB_o : OUT  std_logic;
         EJ_TX_o : OUT  std_logic;
         EJ_CLK_o : OUT  std_logic
        );
    END COMPONENT;
    
	type input_array_tst is array (7 downto 0) of std_logic_vector (31 downto 0);	-- The array type
	
   --Inputs
   signal EJ_PKT_i : std_logic_vector(34 downto 0) := (others => '0');
   signal TEJET_i : std_logic_vector(31 downto 0) := (others => '0');
   signal EJATXDATA_i : std_logic_vector(31 downto 0) := (others => '0');
   signal EJBTXDATA_i : std_logic_vector(31 downto 0) := (others => '0');
   signal DO_TESTEJETA_i : std_logic := '0';
   signal DO_TESTEJETB_i : std_logic := '0';
   signal ISPACA_i : std_logic := '0';
   signal ISPACB_i : std_logic := '0';
   signal EJ_RX_i : std_logic := '0';
   signal CLK_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal EJARXDATA_o : input_array_tst;
   signal EJBRXDATA_o : input_array_tst;
   signal CLRPACA_o : std_logic;
   signal CLRPACB_o : std_logic;
   signal EJ_TX_o : std_logic;
   signal EJ_CLK_o : std_logic;

   -- Clock period definitions
   constant CLK_i_period : time := 53 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EJECTORS_DATA_SENDER PORT MAP (
          EJ_PKT_i => EJ_PKT_i,
          TEJET_i => TEJET_i,
          EJATXDATA_i => EJATXDATA_i,
          EJBTXDATA_i => EJBTXDATA_i,
          DO_TESTEJETA_i => DO_TESTEJETA_i,
          DO_TESTEJETB_i => DO_TESTEJETB_i,
          ISPACA_i => ISPACA_i,
          ISPACB_i => ISPACB_i,
          EJ_RX_i => EJ_RX_i,
          CLK_i => CLK_i,
          RST_i => RST_i,
          EJARXDATA_o(0) => EJARXDATA_o(0),
			 EJARXDATA_o(1) => EJARXDATA_o(1),
			 EJARXDATA_o(2) => EJARXDATA_o(2),
			 EJARXDATA_o(3) => EJARXDATA_o(3),
			 EJARXDATA_o(4) => EJARXDATA_o(4),
			 EJARXDATA_o(5) => EJARXDATA_o(5),
			 EJARXDATA_o(6) => EJARXDATA_o(6),
			 EJARXDATA_o(7) => EJARXDATA_o(7),
			 
          EJBRXDATA_o(0) => EJBRXDATA_o(0),
			 EJBRXDATA_o(1) => EJBRXDATA_o(1),
			 EJBRXDATA_o(2) => EJBRXDATA_o(2),
			 EJBRXDATA_o(3) => EJBRXDATA_o(3),
			 EJBRXDATA_o(4) => EJBRXDATA_o(4),
			 EJBRXDATA_o(5) => EJBRXDATA_o(5),
			 EJBRXDATA_o(6) => EJBRXDATA_o(6),
			 EJBRXDATA_o(7) => EJBRXDATA_o(7),
          CLRPACA_o => CLRPACA_o,
          CLRPACB_o => CLRPACB_o,
          EJ_TX_o => EJ_TX_o,
          EJ_CLK_o => EJ_CLK_o
        );

   -- Clock process definitions
   CLK_i_process :process
   begin
		CLK_i <= '0';
		wait for CLK_i_period/2;
		CLK_i <= '1';
		wait for CLK_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RST_i <= '1';
		 EJ_PKT_i <= "01101010101010101010101010101010101";
		 TEJET_i <= "11001100110011001100110011001100";
		 EJATXDATA_i <= "00000000000000001111111111111111";
		 EJBTXDATA_i <= "11111111111111110000000000000000";
		 DO_TESTEJETA_i <= '0';
		 DO_TESTEJETB_i <= '0';
		 EJ_RX_i <= '1';
		 ISPACA_i <= '0';
		 ISPACB_i <= '0';
      wait for 100 ns;	
		RST_i <= '0';
		wait for 100 ns;

      wait for CLK_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
