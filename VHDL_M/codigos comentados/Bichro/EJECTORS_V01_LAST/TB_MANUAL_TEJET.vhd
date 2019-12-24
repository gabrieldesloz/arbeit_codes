--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:56:42 04/16/2012
-- Design Name:   
-- Module Name:   F:/Projetos/VHDL/L8/Ejector_Board/EJECTORS_V04/TB_MANUAL_TEJET.vhd
-- Project Name:  EJECTORS_V05
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MANUAL_TEJET
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
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_MANUAL_TEJET IS
END TB_MANUAL_TEJET;
 
ARCHITECTURE behavior OF TB_MANUAL_TEJET IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MANUAL_TEJET
    PORT(
         TEST_i : IN  std_logic;
         CLK_1K_i : IN  std_logic;
         C1US_i : IN  std_logic;
         RESET_i : IN  std_logic;
         MANUAL_TESTEJET_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal TEST_i : std_logic := '0';
   signal CLK_1K_i : std_logic := '0';
   signal C1US_i : std_logic := '0';
   signal RESET_i : std_logic := '0';

 	--Outputs
   signal MANUAL_TESTEJET_o : std_logic_vector(31 downto 0);

   -- Clock period definitions
	
	constant C1US_i_period : time := 1 ns;
   constant CLK_1K_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MANUAL_TEJET PORT MAP (
          TEST_i => TEST_i,
          CLK_1K_i => CLK_1K_i,
          C1US_i => C1US_i,
          RESET_i => RESET_i,
          MANUAL_TESTEJET_o => MANUAL_TESTEJET_o
        );

   -- Clock process definitions
   CLK_1K_i_process :process
   begin
		CLK_1K_i <= '0';
		wait for CLK_1K_i_period/2;
		CLK_1K_i <= '1';
		wait for CLK_1K_i_period/2;
   end process;
	
   C1US_i_process :process
   begin
		C1US_i <= '0';
		wait for C1US_i_period/2;
		C1US_i <= '1';
		wait for C1US_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RESET_i <= '1';
		TEST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RESET_i <= '0';
		wait for 500 ns;	
		TEST_i <= '0';
		wait for 11000 ns;
		TEST_i <= '1';
		wait for 110000 ns;
		TEST_i <= '0';
		wait for 21000 ns;
		TEST_i <= '1';
		wait for 11000 ns;
		TEST_i <= '0';
		wait for 1100 ns;
		TEST_i <= '1';
		wait for 11000 ns;
		TEST_i <= '0';
		wait for 1100 ns;
		TEST_i <= '1';
		wait for 11000 ns;
		TEST_i <= '0';
		wait for 1100 ns;
		TEST_i <= '1';
		wait for 11000 ns;
		TEST_i <= '0';
		wait for 1100 ns;
		TEST_i <= '1';
		wait for 11000 ns;
		TEST_i <= '0';
		wait for 31000 ns;
		TEST_i <= '1';
		wait for 21000 ns;
		TEST_i <= '0';
		wait for 21000 ns;
		TEST_i <= '1';
		
      wait for CLK_1K_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
