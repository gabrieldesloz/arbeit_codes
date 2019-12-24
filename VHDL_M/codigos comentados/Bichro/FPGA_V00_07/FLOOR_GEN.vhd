----------------------------------------------------------------------------------
-- Company: 			Bühler Sanmak	 
-- Engineer: 			Carlos Eduardo Bertagnolli
-- 
-- Create Date:    	13:29:32 07/25/2012 
-- Design Name: 	 	FLOOR_GEN
-- Module Name:    	FLOOR_GEN - Behavioral 
-- Project Name: 	 	L8
-- Target Devices: 	SPARTAN 6 SLX25
-- Tool versions:  	ISE 14.1
-- Description: 		Module responsible for controlling the floor and the illumination
--							stages
--
-- Dependencies: 		MAIN.vhd
--
-- Revision: 
-- Revision 0.01 		- File Created
-- Additional Comments: 
--							This file was created after an offset remaining even after the
--							0x4A0 offset was taken out.
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

entity FLOOR_GEN is
    Port ( FLOORX_i : in  STD_LOGIC;				-- Floor command input signal (coming from the luminary interface)
           RSYNC_i : in  STD_LOGIC;					-- Synchrony signal (RSYNC2)				
           LED_SEQ_i_0 : in  STD_LOGIC;			-- Illummination signal (LEDSEQ has 3 bits, 1 for each illumination)
			  
           RST_i : in  STD_LOGIC;					-- Reset signal
			  
			  PROBE_o : out STD_LOGIC_VECTOR(7 downto 0);
			  FLOOR_o : out STD_LOGIC;					-- Floor flag (when in 1 floor is active)
			  BGND_OFF_o : out STD_LOGIC;			-- Active on the first stage of the floor (Should turn all illuminations off)
           BGND_FLOOR_o : out  STD_LOGIC;			-- When active the  for the background should be taken
           ILLUM_FLOOR_o : out  STD_LOGIC);		-- When active the floor data for the reflectancy and translucency should be taken
end FLOOR_GEN;

architecture Behavioral of FLOOR_GEN is
------------------------------------------------------------------------------
------------------------- External floor detector ----------------------------
------------------------------------------------------------------------------
signal xf2, s_extfloor, s_clean_xf2 : std_logic;
signal s_clean_xf2_count : integer range 0 to 3;
------------------------------------------------------------------------------
----------------------------- Floor via command ------------------------------
------------------------------------------------------------------------------
signal s_floor : std_logic;
------------------------------------------------------------------------------
--------------------------------- Cycle Adder --------------------------------
------------------------------------------------------------------------------
signal s_end_floor, s_reset_floor_state_machine : std_logic;
signal s_floor_state : std_logic_vector(4 downto 0);
------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------
------------------------- External floor detector ----------------------------
------------------------------------------------------------------------------

PROBE_o <= s_clean_xf2 & xf2 & s_extfloor & s_end_floor & s_reset_floor_state_machine & s_floor_state(0) & s_floor_state(4) & '0';

	process(RST_i,RSYNC_i,LED_SEQ_i_0)
	begin
		if ((RST_i = '1') or (RSYNC_i = '0')) then
			s_clean_xf2 <= '0';
			s_clean_xf2_count <= 0;
		else
			if rising_edge(LED_SEQ_i_0) then
				
				if s_clean_xf2_count = 2 then
					s_clean_xf2 <= '1';
				else
					s_clean_xf2_count <= s_clean_xf2_count + 1;
				end if;
				
			end if;
		end if;
	end process;
	
	-- External floor decoder
	process (RST_i,RSYNC_i,s_clean_xf2)
	variable flc1: integer range 0 to 7;
	begin
		if ((RST_i = '1') or (s_clean_xf2 = '1')) then								-- If clear counter flag is on
		 
			flc1:=0;																				-- Clear external floor counter
			xf2<='0';																			-- Clear external floor intermediate flag
			
		elsif rising_edge(RSYNC_i) then													-- On rising edge of sync signal
		 
			if flc1 = 7 then																	-- If there was 8 rising sync signals
				xf2<='1'; 																		-- Turn the external floor intermediate flag on
			else
				flc1:=flc1+1;																	-- Increase external floor counter
				xf2<='0';																		-- Keep external floor intermediate flag clean
			end if;
		end if;
	 
	end process;
	
	-- External floor flag
	process (RST_i,xf2,s_end_floor)
	begin
		if ((s_end_floor = '1') or (RST_i = '1')) then 								-- If the external floor counter cleaning flag is 
																									-- on or the floor process has ended
			 s_extfloor <= '0'; 																-- Clear the external floor signal
			 
		elsif rising_edge(xf2) then	 													-- On rising edge of external floor intermediate flag
		
			 s_extfloor <= '1';																-- Turn external floor flag on
			 
		end if;
	end process;
	
------------------------------------------------------------------------------
----------------------------- Floor via command ------------------------------
------------------------------------------------------------------------------

	-- floor synchronization
	process (FLOORX_i,RST_i, s_end_floor)
	begin -- illum front ON
		if ((s_end_floor = '1') or (RST_i = '1')) then								-- If there is a reset or the floor sequence reached final state
		
			s_floor <= '0';																	-- Clear floor flag
			
		elsif rising_edge(FLOORX_i) then													-- On rising edge of command coming from the floor 
		
			s_floor <= '1';																	-- Set floor flag
			
		end if;
	end process;
	
------------------------------------------------------------------------------
--------------------------------- Cycle Adder --------------------------------
------------------------------------------------------------------------------
	s_reset_floor_state_machine <= not(s_floor or s_extfloor);

	process (LED_SEQ_i_0, s_reset_floor_state_machine, RST_i,s_floor_state)
	begin
		if ((s_reset_floor_state_machine = '1') or (RST_i = '1')) then 		-- If it has no floor flag
		
			s_end_floor <= '0';																-- Reset flag that shows the floor has ended
			FLOOR_o <= '0';																	-- Reset floor output flag
			s_floor_state <= (others=>'0');												-- Reset floor generator state machine
			BGND_OFF_o <= '0';
			BGND_FLOOR_o <= '0';
			ILLUM_FLOOR_o <= '0';
			
		elsif rising_edge(LED_SEQ_i_0) then	 											-- On rising edge of LEDSEQ(0) (Rear Illumination on, process background illumination)
		
			s_floor_state <= s_floor_state + '1';										-- Increase floor generator state machine
			s_end_floor <= '0';																-- Set flag that resets the floor flags to '0'

			
			case s_floor_state is
			
				when "00000" =>																-- On start set output floor flag
									BGND_OFF_o <= '1';										-- Set flag that turns all illuminations off
									FLOOR_o <= '1';											-- Set output floor flag to 1
									
				when "01000" =>																-- On state 8
									BGND_FLOOR_o <= '1';										-- Set background floor enable
									
				when "01111" =>																-- On state 15
									BGND_OFF_o <= '0';										-- Turn illumination on again
													
				when "11000" =>																-- On state 24
									ILLUM_FLOOR_o <= '1';									-- Set other illuminations enable 
									
				when "11110" =>
--									s_end_floor <= '1';										-- Set flag that resets the floor flags
													
				when "11111" =>
									s_floor_state <= "11111";
									FLOOR_o <= '0';											-- Set output floor flag to 0
									s_end_floor <= '1';										-- Cleans flag that resets the floor flags

				when others =>
									ILLUM_FLOOR_o <= '0';
									BGND_FLOOR_o <= '0';
									s_end_floor <= '0';
				
			end case;
			
		end if;
	end process;
	
------------------------------------------------------------------------------

end Behavioral;