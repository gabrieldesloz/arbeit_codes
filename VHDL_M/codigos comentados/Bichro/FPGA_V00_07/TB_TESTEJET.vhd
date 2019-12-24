--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:55:39 04/20/2012
-- Design Name:   
-- Module Name:   F:/Projetos/VHDL/L8/FPGA_Board/FPGA_V00_44_rev06/TB_TESTEJET.vhd
-- Project Name:  FPGA_V00_44_rev06
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TESTEJET
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
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_TESTEJET IS
END TB_TESTEJET;
 
ARCHITECTURE behavior OF TB_TESTEJET IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TESTEJET
    PORT(
         CLK_1_i : IN  std_logic;
         CLK_18_i : IN  std_logic;
         RESET_i : IN  std_logic;
         TEJET_CHUTE_i : IN  std_logic;
         TEJET_DWELL_i : IN  std_logic_vector(9 downto 0);
         TEJETBUFF_i : IN  std_logic_vector(31 downto 0);
         DO_TESTEJETA_o : OUT  std_logic;
         DO_TESTEJETB_o : OUT  std_logic;
         TJET_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_1_i : std_logic := '0';
   signal CLK_18_i : std_logic := '0';
   signal RESET_i : std_logic := '0';
   signal TEJET_CHUTE_i : std_logic := '0';
   signal TEJET_DWELL_i : std_logic_vector(9 downto 0) := (others => '0');
   signal TEJETBUFF_i : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal DO_TESTEJETA_o : std_logic;
   signal DO_TESTEJETB_o : std_logic;
   signal TJET_o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_1_i_period : time := 18 ns;
   constant CLK_18_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TESTEJET PORT MAP (
          CLK_1_i => CLK_1_i,
          CLK_18_i => CLK_18_i,
          RESET_i => RESET_i,
          TEJET_CHUTE_i => TEJET_CHUTE_i,
          TEJET_DWELL_i => TEJET_DWELL_i,
          TEJETBUFF_i => TEJETBUFF_i,
          DO_TESTEJETA_o => DO_TESTEJETA_o,
          DO_TESTEJETB_o => DO_TESTEJETB_o,
          TJET_o => TJET_o
        );

   -- Clock process definitions
   CLK_1_i_process :process
   begin
		CLK_1_i <= '0';
		wait for CLK_1_i_period/2;
		CLK_1_i <= '1';
		wait for CLK_1_i_period/2;
   end process;
 
   CLK_18_i_process :process
   begin
		CLK_18_i <= '0';
		wait for CLK_18_i_period/2;
		CLK_18_i <= '1';
		wait for CLK_18_i_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
		RESET_i <= '1';
		TEJET_DWELL_i <= "0000111011";
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		TEJETBUFF_i <= "10000000000000000000000000000000";
		RESET_i <= '0';

      wait for CLK_1_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
