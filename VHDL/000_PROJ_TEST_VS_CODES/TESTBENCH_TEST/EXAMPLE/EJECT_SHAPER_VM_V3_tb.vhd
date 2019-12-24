
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY EJECT_SHAPER_VM_V3_tb IS
END EJECT_SHAPER_VM_V3_tb;
 
ARCHITECTURE behavior OF EJECT_SHAPER_VM_V3_tb IS 
 
   

   --Inputs
   signal CLK_1_i : 		std_logic := '0';
   signal dirt_i: 		std_logic := '0';
   signal reset_i: 		std_logic := '0';	 
   signal clock10MHz:   std_logic := '0';	
 	--Outputs


   -- Clock period definitions
   constant CLK_1_i_period : 		time := 6.6667 ns;
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
		dirt_i <= '0';
		reset_i <= '1';	
		wait for 100 ns;
		reset_i <= '0';		
		dirt_i 	<= '1';
		wait for 100 us;
		reset_i <= '0';		
		dirt_i 	<= '0';
		wait for 1.3 ms;
		reset_i <= '1';		
		dirt_i 	<= '1';
		wait for 2.3 ms;
		reset_i <= '0';		
		dirt_i 	<= '0';
		wait for 4.5 ms;
		reset_i <= '1';		
		dirt_i 	<= '1';
		wait for 50 us;
		reset_i <= '0';		
		dirt_i 	<= '0';
		wait for 5 ms;
		reset_i <= '1';		
		dirt_i 	<= '1';
		wait for 10 us;
		reset_i <= '0';		
		dirt_i 	<= '0';
		wait for 5 ms;
		reset_i <= '1';		
		dirt_i 	<= '1';
		wait for 20 us;
		reset_i <= '0';		
		dirt_i 	<= '0';
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

  
   
	
c0:  entity work.EJECT_SHAPER_VM_3 
  port map (
    CLK_i_150   	 	 => CLK_1_i,  -- 150 MHz 
    CLK_i_10_pulse    => clock10MHz,   -- 75 MHz CLK       
    RESET_i 	 		 => '0',
    VALVE_o		 		 => open, 
	PROTO_o      		 => open, 
	DIRT_i     			 => dirt_i
    );
	
	

end architecture;	
	

