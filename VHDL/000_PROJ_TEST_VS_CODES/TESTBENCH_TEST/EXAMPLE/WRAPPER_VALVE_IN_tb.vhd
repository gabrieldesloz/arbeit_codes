
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY WRAPPER_VALVE_IN_tb IS
END WRAPPER_VALVE_IN_tb;
 
ARCHITECTURE behavior OF WRAPPER_VALVE_IN_tb IS 
 
   

   --Inputs
   signal CLK_1_i : 		std_logic := '0';
   signal dirt_i: 		std_logic := '0';
   signal reset_i: 		std_logic := '0';	 
   signal clock10MHz:   std_logic := '0';	
 	--Outputs
	
	
	signal s_valve_tb: std_logic_vector(31 downto 0):= (others => '0');
	signal test_vector: std_logic_vector(31 downto 0):= (others => '0');
	signal s_valve_tb_valve_in_MSB: std_logic_vector(31 downto 0):= (others => '0');
	signal s_valve_tb_valve_in_LSB: std_logic_vector(31 downto 0):= (others => '0');

   -- Clock period definitions
   constant CLK_1_i_period : 		time := 27 ns; -- 37.5 MHz
   constant CLK_1_i_period_10MHz : 	time := 100 ns;

 
BEGIN
 

   -- Clock process definitions
   CLK_1_i_process :process
   begin
		CLK_1_i <= '0';
		wait for CLK_1_i_period/2;
		CLK_1_i <= '1';
		wait for CLK_1_i_period/2;
   end process;
   
   
   CLK_2_i_process :process
   begin
		clock10MHz <= '0';
		wait for CLK_1_i_period_10MHz/2;
		clock10MHz <= '1';
		wait for CLK_1_i_period_10MHz/2;
   end process;   
 
   stim_proc: process
   begin		
		s_valve_tb <= x"00000000";
		reset_i <= '1';	
		wait for 100 ns;
		reset_i <= '0';		
		s_valve_tb <= x"00000000";
		wait for 100 us;
		reset_i <= '0';		
		s_valve_tb <= x"80008001";
		wait for 6 us;
		reset_i <= '0';		
		s_valve_tb <= x"00000000";
		wait for 1 ms;
		reset_i <= '0';		
		s_valve_tb <= x"80008001";
		wait for 4 us;
		reset_i <= '0';		
		s_valve_tb <= x"00000000";	
		wait for 1 ms;		
		reset_i <= '0';		
		s_valve_tb <= x"80008001";
		wait for 5 us;
		reset_i <= '0';		
		s_valve_tb <= x"00000000";
		wait for 5 us;
		reset_i <= '0';		
		s_valve_tb <= x"80008001";
		wait for 4 ms;
		reset_i <= '0';		
		s_valve_tb <= x"00000000";
--		wait for 100 ns;	
--		dirt_i <= '0';
--		wait for 100 ns;
--		dirt_i <= '1';
--		wait for 12 us;
--		dirt_i <= '0';
--		wait for 1 us;
--		dirt_i <= '1';
--		wait for 10 us;
--		dirt_i <= '0';
--		wait for 3 us;
--		dirt_i <= '1';
--		wait for 2 ms;
--		dirt_i <= '0';
      wait;
   end process;

  
   



wvei1: entity work.WRAPPER_VALVE_IN(Behavioral) 
    port map (	
			CLK_i => CLK_1_i, 
			CLK_i_pulse => '1',
			RST_i => reset_i,
			VALVE_i(15 downto 0) => s_valve_tb(31 downto 16),
			VALVE_i(31 downto 16) =>  (others => '0'),
			VALVE_o => s_valve_tb_valve_in_MSB,			
			CLEAN_FLAG_o => open		
			);
			



es1:  entity work.WRAPPER_EJECT_SHAPER(Behavioral) 
    Port map (	
			CLK_i => CLK_1_i, 
			RST_i => reset_i,
			VALVE_CTRL_IHM_i => s_valve_tb_valve_in_MSB,
			VALVE_o => open		
			);
			


wvei2: entity work.WRAPPER_VALVE_IN(Behavioral) 
    port map (	
			CLK_i => CLK_1_i, 
			CLK_i_pulse => '1',
			RST_i => reset_i,
			VALVE_i(15 downto 0) => s_valve_tb(15 downto 0),
			VALVE_i(31 downto 16) => (others => '0'),
			VALVE_o => s_valve_tb_valve_in_LSB,			
			CLEAN_FLAG_o => open		
			);
			



es2:  entity work.WRAPPER_EJECT_SHAPER(Behavioral) 
    Port map (	
			CLK_i => CLK_1_i, 
			RST_i => reset_i,
			VALVE_CTRL_IHM_i => s_valve_tb_valve_in_LSB,
			VALVE_o => open		
			);
			
	
 test_vector <= s_valve_tb_valve_in_MSB(31 downto 16)& s_valve_tb_valve_in_LSB(15 downto 0);	

end architecture;	
	

