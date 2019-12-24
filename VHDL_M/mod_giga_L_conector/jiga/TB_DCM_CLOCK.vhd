--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:36:47 05/08/2014
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L_Test_Rig/Test_Rig/FPGA_1/TEST_RIG_FPGA_1_V01/TB_DCM_CLOCK.vhd
-- Project Name:  TEST_RIG_FPGA_1_V01
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DCM_CLOCK
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
 
ENTITY TB_DCM_CLOCK IS
END TB_DCM_CLOCK;
 
ARCHITECTURE behavior OF TB_DCM_CLOCK IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DCM_CLOCK
    PORT(
         CLK_37MHZ_i : IN  std_logic;
         RST_i : IN  std_logic;
         CLK_60MHz_o : OUT  std_logic;
         EN_30MHz_o : OUT  std_logic;
         EN_1MHz_o : OUT  std_logic;
         EN_10MHz_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_37MHZ_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal CLK_60MHz_o : std_logic;
   signal EN_30MHz_o : std_logic;
   signal EN_1MHz_o : std_logic;
   signal EN_10MHz_o : std_logic;

   -- Clock period definitions
   constant CLK_37MHZ_i_period : time := 10 ns;
   constant CLK_60MHz_o_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DCM_CLOCK PORT MAP (
          CLK_37MHZ_i => CLK_37MHZ_i,
          RST_i => RST_i,
          CLK_60MHz_o => CLK_60MHz_o,
          EN_30MHz_o => EN_30MHz_o,
          EN_1MHz_o => EN_1MHz_o,
          EN_10MHz_o => EN_10MHz_o
        );

   -- Clock process definitions
   CLK_37MHZ_i_process :process
   begin
		CLK_37MHZ_i <= '0';
		wait for CLK_37MHZ_i_period/2;
		CLK_37MHZ_i <= '1';
		wait for CLK_37MHZ_i_period/2;
   end process;
 
   CLK_60MHz_o_process :process
   begin
		CLK_60MHz_o <= '0';
		wait for CLK_60MHz_o_period/2;
		CLK_60MHz_o <= '1';
		wait for CLK_60MHz_o_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST_i <= '0';
		
		
      wait for CLK_37MHZ_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
