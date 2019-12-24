--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:22:10 04/25/2013
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L8+B/FPGA_Board/FPGA_V00_02/TB_ILLUM_STATE_MACHINE.vhd
-- Project Name:  FPGA_V00_02
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ILLUM_STATE_MACHINE
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
 
ENTITY TB_ILLUM_STATE_MACHINE IS
END TB_ILLUM_STATE_MACHINE;
 
ARCHITECTURE behavior OF TB_ILLUM_STATE_MACHINE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ILLUM_STATE_MACHINE
    PORT(
         clkaq : IN  std_logic;
         reset : IN  std_logic;
         floor : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clkaq : std_logic := '0';
   signal reset : std_logic := '0';
   signal floor : std_logic := '0';

   -- Clock period definitions
   constant clkaq_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ILLUM_STATE_MACHINE PORT MAP (
          clkaq => clkaq,
          reset => reset,
          floor => floor
        );

   -- Clock process definitions
   clkaq_process :process
   begin
		clkaq <= '0';
		wait for clkaq_period/2;
		clkaq <= '1';
		wait for clkaq_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		reset <= '0';

      wait for clkaq_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
