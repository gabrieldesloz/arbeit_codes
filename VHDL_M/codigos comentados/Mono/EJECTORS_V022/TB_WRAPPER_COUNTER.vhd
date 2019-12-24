--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:08:37 06/14/2012
-- Design Name:   
-- Module Name:   D:/Projetos/VHDL/L8/BENCH_EJECTORS/BENCH_EJECTORS_V00/TB_WRAPPER_COUNTER.vhd
-- Project Name:  BENCH_EJECTORS_V00
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: WRAPPER_COUNTER
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
 
ENTITY TB_WRAPPER_COUNTER IS
END TB_WRAPPER_COUNTER;
 
ARCHITECTURE behavior OF TB_WRAPPER_COUNTER IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT WRAPPER_COUNTER
    PORT(
         VALVE_STATE_i : IN  std_logic_vector(31 downto 0);
         C1MHZ_i : IN  std_logic;
         RST_i : IN  std_logic;
			PROTOTYPE_o : out STD_LOGIC_VECTOR(7 downto 0);
         VALVE_STATE_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal VALVE_STATE_i : std_logic_vector(31 downto 0) := (others => '0');
   signal C1MHZ_i : std_logic := '0';
   signal RST_i : std_logic := '0';

 	--Outputs
   signal VALVE_STATE_o : std_logic_vector(31 downto 0);
	signal PROTOTYPE_o : STD_LOGIC_VECTOR(7 downto 0);
	signal s_valve : std_logic;
	signal s_valve_sel : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant C1MHZ_i_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: WRAPPER_COUNTER PORT MAP (
          VALVE_STATE_i => VALVE_STATE_i,
          C1MHZ_i => C1MHZ_i,
          RST_i => RST_i,
			 PROTOTYPE_o => PROTOTYPE_o,
          VALVE_STATE_o => VALVE_STATE_o
        );

   -- Clock process definitions
   C1MHZ_i_process :process
   begin
		C1MHZ_i <= '0';
		wait for C1MHZ_i_period/2;
		C1MHZ_i <= '1';
		wait for C1MHZ_i_period/2;
   end process;
	
	valve_process : process
	begin
		wait for 2 ns;
		s_valve <= '1';
		wait for 50 ns;
		s_valve <= '0';
		wait for 1 ns;
		s_valve <= '1';
		wait for 6.5 ns; 
		s_valve <= '0';
		wait for 6.5 ns; 
		s_valve <= '1';
		wait for 6.5 ns; 
		s_valve <= '0';
		wait for 6.5 ns; 
		s_valve <= '1';
		wait for 6.5 ns; 
		s_valve <= '0';
		wait for 6.5 ns; 
		s_valve <= '1';
		wait for 6.5 ns;
		s_valve <= '0';
	end process;
	
	teste:
		for i in 0 to 31 generate
			begin
			VALVE_STATE_i(i) <= s_valve when (s_valve_sel(i) = '1') else '0';
		end generate;
	
--	p_loop : process(s_valve_sel)
--	begin
--		for i in 0 to 31 loop
--			VALVE_STATE_i(i) <= s_valve when (s_valve_sel(i) = '1') else '0';
--		end loop;
--	end process;

   -- Stimulus process
   stim_proc: process
   begin		
		s_valve_sel <= (others=>'0');
		RST_i <= '1';
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		RST_i <= '0';
		s_valve_sel(31) <= '1';
		s_valve_sel(30) <= '1';
		s_valve_sel(29) <= '1';
		s_valve_sel(28) <= '1';
		s_valve_sel(2) <= '1';
		s_valve_sel(1) <= '1';
		s_valve_sel(0) <= '1';
--		VALVE_STATE_i(30 downto 0) <= (others=>'0');
--		VALVE_STATE_i(31) <= '1';
		wait for 500 ns;
--		s_valve_sel(15) <= '1';
--		VALVE_STATE_i(30) <= '1';
		wait for 1500 ns;
--		VALVE_STATE_i <= (others=>'0');
		wait for 2500 ns;
--		VALVE_STATE_i(31 downto 16) <= (others=>'1');
--		VALVE_STATE_i(2 downto 0) <= (others=>'1');

      -- insert stimulus here 

      wait;
   end process;

END;
