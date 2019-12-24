----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:19:40 06/18/2012 
-- Design Name: 
-- Module Name:    VALVE_FAIL - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VALVE_FAIL is
    Port ( VALVE_i : in  STD_LOGIC_VECTOR(31 downto 0);					-- Valve state (1 is active)
           SENS_i : in  STD_LOGIC_VECTOR(31 downto 0);					-- Sens state (goes 0 with the electromotive effect just after the valve is disabled)
			VALVE_LIMITER_i : in  STD_LOGIC_VECTOR (31 downto 0);		-- Valve limiter information to clean the has activation flag in case on bit is active
			ACTIVATION_COUNT_i : in STD_LOGIC_VECTOR(12 downto 0);		-- Activation time counter input
			FEEDBACK_COUNT_i : in STD_LOGIC_VECTOR(14 downto 0);		-- Feedback counter input
			CURRENT_VALVE_i : in STD_LOGIC_VECTOR(4 downto 0);			-- Current valve being analyzed
			DEBOUNCE_i : in STD_LOGIC_VECTOR(1 downto 0);				-- Debounce input count to avoid fake alarms
			HAS_ACTIVATION_PULSE_i : in STD_LOGIC;						-- If there was a 500us valve activation pulse
			HAS_SENS_i : in STD_LOGIC;									-- If there was an electromotive effect
			C10MHZ_i : in  STD_LOGIC;									-- 6.25 MHz clock 
			RST_i : in  STD_LOGIC;									
			  
			DEBOUNCE_o : out STD_LOGIC_VECTOR(1 downto 0);				-- Debounce output count to avoid fake alarms
			PROBE_o : out STD_LOGIC_VECTOR(2 downto 0);
			ACTIVATION_COUNT_o : out STD_LOGIC_VECTOR(12 downto 0);		-- Activation time counter output
			FEEDBACK_COUNT_o : out STD_LOGIC_VECTOR(14 downto 0);		-- Feedback counter output
			HAS_SENS_o : out STD_LOGIC;									-- If there was an electromotive effect
			HAS_ACTIVATION_PULSE_o : out STD_LOGIC;						-- If there was a 500us valve activation pulse
			FUSE_o : out  STD_LOGIC_VECTOR(31 downto 0);
			clock2MHz_i: in std_logic);									-- "Fuse" state
end VALVE_FAIL;




architecture Behavioral of VALVE_FAIL is


constant ACTIVATION_COUNT: std_logic_vector(12 downto 0) := "0000011011100";  -- 220 x 3.2 us -> 704 us
constant FEEDBACK_COUNT: std_logic_vector(14 downto 0) :=  "000000000000110"; -- 6 x 3.2 us (18 us)

signal s_valid_valve : std_logic_vector(31 downto 0);
signal s_fail_test_state : std_logic_vector(1 downto 0);
signal s_has_sens_i, s_has_sens_o : std_logic;
-- probes 
signal is_valve_0 : std_logic;


  signal s_DEBOUNCE_o :  				STD_LOGIC_VECTOR(1 downto 0);		-- Debounce output count to avoid fake alarms
  signal s_ACTIVATION_COUNT_o :  		STD_LOGIC_VECTOR(12 downto 0);		-- Activation time counter output
  signal s_FEEDBACK_COUNT_o : 			STD_LOGIC_VECTOR(14 downto 0);		-- Feedback counter output
  signal s_HAS_ACTIVATION_PULSE_o :		STD_LOGIC;							-- If there was a 500us valve activation pulse
  signal s_FUSE_o : 					STD_LOGIC_VECTOR(31 downto 0);
  signal ss_HAS_SENS_o:					std_logic;	
  
begin

------------------------------------------------------------------------------------------------------

	chipscope_block: block  

		signal  CLK_c1: 	   	std_logic;		
		signal  CONTROL0: 		std_logic_vector(35 downto 0);			
		signal  DATA_1:  	   	std_logic_vector(38 downto 0);
		signal  TRIG0_1:        std_logic_vector(0 downto 0);
		
		
	begin
	
		
		--CLK_c1 		<= clock2MHz_i; 
		CLK_c1 		<= clock2MHz_i; 
		DATA_1 		<= is_valve_0 & s_FUSE_o(0) & s_fail_test_state & VALVE_i(0) & VALVE_LIMITER_i(0) 
						& SENS_i(0) & s_DEBOUNCE_o & s_ACTIVATION_COUNT_o & s_FEEDBACK_COUNT_o 
						& ss_HAS_SENS_o & s_HAS_ACTIVATION_PULSE_o;
		TRIG0_1(0) 	<= is_valve_0;
		

	c0: entity work.chipscope_icon 
	  port map(
		CONTROL0 => CONTROL0		
		);

	c1: entity  work.chipscope_ila 
	port map (
		CONTROL 	=> CONTROL0,
		CLK 		=> CLK_c1,
		DATA 		  => DATA_1,
		TRIG0 		=> TRIG0_1
		);
	
end block;	
-----------------------------------------------------------------------------------------------


	
	is_valve_0 <= '1' when (CURRENT_VALVE_i = "11111") else '0';

	PROBE_o <= SENS_i(0) & s_has_sens_o & is_valve_0; 

	HAS_SENS_o <= not(s_has_sens_o);															-- This is made because the initialization of the memory is default to 0, so	
	s_has_sens_i <= not(HAS_SENS_i);															-- the lazyness made me invert the logic so that the initialization of this HAS_SENS parameter
																								-- in the memory is not necessary ( So 0 means that there was a sens, and 1 means there was not )																							
	----- DEBUG
	ss_HAS_SENS_o  <=not(s_has_sens_o);
	-----																							
																								
	s_valid_valve <= VALVE_i and not(VALVE_LIMITER_i);
	
	s_fail_test_state <= s_valid_valve(CONV_INTEGER(CURRENT_VALVE_i)) & HAS_ACTIVATION_PULSE_i;

	process(C10MHZ_i, RST_i)
	begin
	
		if falling_edge(C10MHZ_i) then														-- 10 MHz Clock
		
			if (RST_i = '1') then															-- If reset signal is up

				s_has_sens_o <= '1';														-- Set the HAS_SENS output to '0'
				FUSE_o <= (others=>'1');													-- Set the fuses state to 1 (OK)			
				DEBOUNCE_o <= (others=>'0');												-- Set debounce to 0			
				ACTIVATION_COUNT_o <= (others=>'0');										-- Set the activation counter to 0ms				
				FEEDBACK_COUNT_o <= (others=>'0');											-- Set the sens counter to 0ms			
				HAS_ACTIVATION_PULSE_o <= '0';												-- Set has activation pulse flag to 0
				
				
				------ DEBUG
				s_FUSE_o <= (others=>'1');													-- Set the fuses state to 1 (OK)			
				s_DEBOUNCE_o <= (others=>'0');												-- Set debounce to 0			
				s_ACTIVATION_COUNT_o <= (others=>'0');										-- Set the activation counter to 0ms				
				s_FEEDBACK_COUNT_o <= (others=>'0');										-- Set the sens counter to 0ms			
				s_HAS_ACTIVATION_PULSE_o <= '0';											-- Set has activation pulse flag to 0
				-------
				
				
			else																						-- If reset signal is 0
			
				FEEDBACK_COUNT_o		 	<= FEEDBACK_COUNT_i;										-- Do nothing with the counters and flags by default			
				ACTIVATION_COUNT_o		 	<= ACTIVATION_COUNT_i;
				HAS_ACTIVATION_PULSE_o 		<= (HAS_ACTIVATION_PULSE_i and not(VALVE_LIMITER_i(CONV_INTEGER(CURRENT_VALVE_i))));			
				DEBOUNCE_o 					<= DEBOUNCE_i;				
				s_has_sens_o				<= s_has_sens_i;	

				----- DEBUG
				s_FEEDBACK_COUNT_o		 		<= FEEDBACK_COUNT_i;										
				s_ACTIVATION_COUNT_o		 	<= ACTIVATION_COUNT_i;
				s_HAS_ACTIVATION_PULSE_o 		<= (HAS_ACTIVATION_PULSE_i and not(VALVE_LIMITER_i(CONV_INTEGER(CURRENT_VALVE_i))));			
				s_DEBOUNCE_o 					<= DEBOUNCE_i;								
				------
			
	-----------------------------------------------------------------------------------------------------------------------------------
				case s_fail_test_state is
				
					when "00" =>

						ACTIVATION_COUNT_o 	<= ACTIVATION_COUNT;								-- Set the activation counter to 450us again (141 x 3.2us = 450us)				
						FEEDBACK_COUNT_o 	<= FEEDBACK_COUNT;									-- Set the feedback counter to 2ms again (625 x 3.2us = 2ms)
						
						--------
						s_ACTIVATION_COUNT_o 	<= ACTIVATION_COUNT;	---DEBUG							
						s_FEEDBACK_COUNT_o 		<= FEEDBACK_COUNT;		---DEBUG							
						-------
						
	-----------------------------------------------------------------------------------------------------------------------------------
					when "01" =>
					
						if (FEEDBACK_COUNT_i = "000000000000000") then															
							
							FUSE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= s_has_sens_i;																		
							HAS_ACTIVATION_PULSE_o <= '0';										
							
							-----
							s_HAS_ACTIVATION_PULSE_o <= '0';  --- DEBUG	
							s_FUSE_o(CONV_INTEGER(CURRENT_VALVE_i)) <= s_has_sens_i;	--- DEBUG												
							-----						
													
						else																				
						
							FEEDBACK_COUNT_o <= FEEDBACK_COUNT_i - '1';	

							-----
							s_FEEDBACK_COUNT_o <= FEEDBACK_COUNT_i - '1'; --- DEBUG
							-----							
		
						end if;						
			
						
						if (SENS_i(CONV_INTEGER(CURRENT_VALVE_i)) = '0') then				
								
								if (DEBOUNCE_i = "11") then
									s_has_sens_o 	<= '1';	
									DEBOUNCE_o 		<= (others =>'0');
									-----
									s_DEBOUNCE_o <= (others =>'0'); --- DEBUG
									-----
								else
									DEBOUNCE_o 		<= DEBOUNCE_i + '1';									
									s_has_sens_o 	<= has_sens_i; -- keep the value
									
									-----
									s_DEBOUNCE_o <= DEBOUNCE_i + '1';	--- DEBUG	
									-----	
									
								end if;													
						
						else																			
							DEBOUNCE_o <= (others => '0');										
							
							-----
							s_DEBOUNCE_o <= (others => '0'); --- DEBUG	
							-----		
						end if;
						
						
					
						
						
						
	-----------------------------------------------------------------------------------------------------------------------------------
					when "10" =>
					
						if (ACTIVATION_COUNT_i = "0000000000000") then						
							
							HAS_ACTIVATION_PULSE_o <= '1';								
							-------
							s_HAS_ACTIVATION_PULSE_o <= '1';   --- DEBUG								
							-------
													
						else																			
						
							ACTIVATION_COUNT_o <= ACTIVATION_COUNT_i - '1';		
							-------
							s_ACTIVATION_COUNT_o <= ACTIVATION_COUNT_i - '1';  --- DEBUG
 							--------
						end if;
					
						if (DEBOUNCE_i = "00") then					
							s_has_sens_o <= '0'; 
						else
							s_has_sens_o <= s_has_sens_i;
						end if;
						
	-----------------------------------------------------------------------------------------------------------------------------------
					when "11" =>
					
						FEEDBACK_COUNT_o <= FEEDBACK_COUNT;							
						-----------
						s_FEEDBACK_COUNT_o <= FEEDBACK_COUNT; -- DEBUG				
						-----------
					when others =>
					
				end case;
				
			end if;
		end if;
	
	end process;
	
end Behavioral;