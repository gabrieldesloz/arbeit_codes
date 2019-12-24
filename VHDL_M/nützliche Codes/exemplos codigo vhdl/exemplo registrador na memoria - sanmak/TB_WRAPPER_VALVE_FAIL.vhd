--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:32:36 10/24/2012
-- Design Name:   
-- Module Name:   D:/Projetos/VHDL/L8/Ejector_Board/EJECTORS_V016/TB_WRAPPER_VALVE_FAIL.vhd
-- Project Name:  EJECTORS_V016
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: WRAPPER_VALVE_FAIL
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
 
ENTITY TB_WRAPPER_VALVE_FAIL IS
END TB_WRAPPER_VALVE_FAIL;
 
ARCHITECTURE behavior OF TB_WRAPPER_VALVE_FAIL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT WRAPPER_VALVE_FAIL
    PORT(
         VALVE_i : IN  std_logic_vector(31 downto 0);
         SENS_i : IN  std_logic_vector(31 downto 0);
         C10MHZ_i : IN  std_logic;
         RST_i : IN  std_logic;
         PROBE_o : OUT  std_logic_vector(2 downto 0);
         FUSE_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal VALVE_i : std_logic_vector(31 downto 0) := (others => '0');
   signal SENS_i : std_logic_vector(31 downto 0) := (others => '1');
   signal C10MHZ_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal PROBE_o : std_logic_vector(2 downto 0);
   signal FUSE_o : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant C10MHZ_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: WRAPPER_VALVE_FAIL PORT MAP (
          VALVE_i => VALVE_i,
          SENS_i => SENS_i,
          C10MHZ_i => C10MHZ_i,
          RST_i => RST_i,
          PROBE_o => PROBE_o,
          FUSE_o => FUSE_o
        );

   -- Clock process definitions
   C10MHZ_i_process :process
   begin
		C10MHZ_i <= '0';
		wait for C10MHZ_i_period/2;
		C10MHZ_i <= '1';
		wait for C10MHZ_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST_i <= '0';
		wait for 1000 ns;	
		VALVE_i(31) <= '1';
		wait for 400 ns;	
		VALVE_i(31) <= '0';
		wait for 40 ns;	
		VALVE_i(31) <= '1';
		wait for 40 ns;	
		VALVE_i(31) <= '0';
		wait for 40 ns;	
		VALVE_i(31) <= '1';
		wait for 40 ns;	
		VALVE_i(31) <= '0';
		wait for 40 ns;	
		SENS_i(31) <= '0';
		wait for 40 ns;	
		SENS_i(31) <= '1';
		
      wait for 3000 ns;	
		VALVE_i(31) <= '1';
		wait for 15000 ns;	
		VALVE_i(31) <= '0';
		wait for 40 ns;	
		VALVE_i(31) <= '1';
		wait for 40 ns;	
		VALVE_i(31) <= '0';
		wait for 40 ns;	
		VALVE_i(31) <= '1';
		wait for 40 ns;	
		VALVE_i(31) <= '0';
		wait for 40 ns;	
		SENS_i(31) <= '0';
		wait for 40 ns;	
		SENS_i(31) <= '1';
		
      wait for C10MHZ_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
