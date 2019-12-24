--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:58:59 04/17/2012
-- Design Name:   
-- Module Name:   F:/Projetos/VHDL/L8/FPGA_Board/FPGA_V00_44_rev06/TB_MAIN_RESET.vhd
-- Project Name:  FPGA_V00_44_rev06
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MAIN_RESET
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
 
ENTITY TB_MAIN_RESET IS
END TB_MAIN_RESET;
 
ARCHITECTURE behavior OF TB_MAIN_RESET IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MAIN_RESET
    PORT(
         CH1_i : IN  std_logic;
         CLKSEL_i : IN  std_logic;
         RSYNC2_i : IN  std_logic;
         C1US_i : IN  std_logic;
--         CLK37_i : IN  std_logic;
         RESET_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CH1_i : std_logic := '0';
   signal CLKSEL_i : std_logic := '0';
   signal RSYNC2_i : std_logic := '0';
   signal C1US_i : std_logic := '0';
--   signal CLK37_i : std_logic := '0';

 	--Outputs
   signal RESET_o : std_logic;

   -- Clock period definitions
   constant C1US_i_period : time := 1 ns;
--   constant CLK37_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MAIN_RESET PORT MAP (
          CH1_i => CH1_i,
          CLKSEL_i => CLKSEL_i,
          RSYNC2_i => RSYNC2_i,
          C1US_i => C1US_i,
--          CLK37_i => CLK37_i,
          RESET_o => RESET_o
        );

   -- Clock process definitions
   C1US_i_process :process
   begin
		C1US_i <= '0';
		wait for C1US_i_period/2;
		C1US_i <= '1';
		wait for C1US_i_period/2;
   end process;
 
--   CLK37_i_process :process
--   begin
--		CLK37_i <= '0';
--		wait for CLK37_i_period/2;
--		CLK37_i <= '1';
--		wait for CLK37_i_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		wait for 1050000 ns;
		CH1_i		<= '1';
		RSYNC2_i <= '0';
		CLKSEL_i <= '0';
      -- hold reset state for 100 ns.
      wait for 120000 ns;	
		CH1_i		<= '0';
		wait for 150000 ns;	
		CH1_i		<= '1';
		RSYNC2_i <= '1';
		wait for 150000 ns;	
		RSYNC2_i <= '0';
		CLKSEL_i <= '1';
      wait for 150000 ns;	
		CH1_i		<= '0';
		wait for 150000 ns;	
--		CH1_i		<= '1';
		RSYNC2_i <= '1';
		wait for 150000 ns;	
		RSYNC2_i <= '0';
		

      -- insert stimulus here 

      wait;
   end process;

END;
