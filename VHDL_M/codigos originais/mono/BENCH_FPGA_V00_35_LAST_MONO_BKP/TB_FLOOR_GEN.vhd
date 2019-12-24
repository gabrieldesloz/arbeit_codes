--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:48:23 06/10/2013
-- Design Name:   
-- Module Name:   M:/Projetos/VHDL/L8/FPGA_Board/FPGA_V00_80_new/TB_FLOOR_GEN.vhd
-- Project Name:  FPGA_V00_80
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FLOOR_GEN
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
 
ENTITY TB_FLOOR_GEN IS
END TB_FLOOR_GEN;
 
ARCHITECTURE behavior OF TB_FLOOR_GEN IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FLOOR_GEN
    PORT(
         FLOORX_i : IN  std_logic;
         RSYNC_i : IN  std_logic;
         LED_SEQ_i_0 : IN  std_logic;
         RST_i : IN  std_logic;
         FLOOR_o : OUT  std_logic;
         BGND_OFF_o : OUT  std_logic;
         BGND_FLOOR_o : OUT  std_logic;
         ILLUM_FLOOR_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal FLOORX_i : std_logic := '0';
   signal RSYNC_i : std_logic := '0';
   signal LED_SEQ_i_0 : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal FLOOR_o : std_logic;
   signal BGND_OFF_o : std_logic;
   signal BGND_FLOOR_o : std_logic;
   signal ILLUM_FLOOR_o : std_logic;

   -- Clock period definitions
   constant LED_SEQ_i_0_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FLOOR_GEN PORT MAP (
          FLOORX_i => FLOORX_i,
          RSYNC_i => RSYNC_i,
          LED_SEQ_i_0 => LED_SEQ_i_0,
          RST_i => RST_i,
          FLOOR_o => FLOOR_o,
          BGND_OFF_o => BGND_OFF_o,
          BGND_FLOOR_o => BGND_FLOOR_o,
          ILLUM_FLOOR_o => ILLUM_FLOOR_o
        );

   -- Clock process definitions
   LED_SEQ_i_0_process :process
   begin
		LED_SEQ_i_0 <= '0';
		wait for LED_SEQ_i_0_period;
		LED_SEQ_i_0 <= '1';
		wait for LED_SEQ_i_0_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST_i <= '0';
		FLOORX_i <= '1';
		wait for 100 ns;	
		FLOORX_i <= '0';
		wait for 100 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		RSYNC_i <= '1';
		wait for 5 ns;
		RSYNC_i <= '0';
		wait for 5 ns;
		
		
      wait for LED_SEQ_i_0_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
