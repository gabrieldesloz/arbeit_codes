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
           BGND_FLOOR_o : out  STD_LOGIC;			-- When active the floor data for the background should be taken
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
	a: process (RST_i,RSYNC_i,s_clean_xf2)
	variable flc1: integer range 0 to 7;
	begin
		-- If clear counter flag is on
		if ((RST_i = '1') or (s_clean_xf2 = '1')) then								
		-- Clear external floor counter	
			flc1:=0;
		-- Clear external floor intermediate flag	
			xf2<='0';																			
		-- On rising edge of sync signal	
		elsif rising_edge(RSYNC_i) then													
		 -- If there was 8 rising sync signals
			if flc1 = 7 then
         -- Turn the external floor intermediate flag on
				xf2<='1'; 																		
			else
		 -- Increase external floor counter	
				flc1:=flc1+1;	
         -- Keep external floor intermediate flag clean				
				xf2<='0';																		
			end if;
		end if;
	 
	end process;
	
	-- External floor flag
	process (RST_i,xf2,s_end_floor)
	begin
		-- If the external floor counter cleaning flag is
		-- on or the floor process has ended	
		if ((s_end_floor = '1') or (RST_i = '1')) then 								 
        -- Clear the external floor signal    		
			 s_extfloor <= '0'; 																
		-- On rising edge of external floor intermediate flag	 
		elsif rising_edge(xf2) then	 													
			-- Turn external floor flag on
			 s_extfloor <= '1';	
		end if;
	end process;
	
------------------------------------------------------------------------------
----------------------------- Floor via command ------------------------------
------------------------------------------------------------------------------
	-- floor synchronization
	process (FLOORX_i,RST_i, s_end_floor)
	begin -- illum front ON
		-- If there is a reset or the floor sequence reached final state
		if ((s_end_floor = '1') or (RST_i = '1')) then								
			-- Clear floor flag
			s_floor <= '0';																
		-- On rising edge of command coming from the floor 
		elsif rising_edge(FLOORX_i) then													
		-- Set floor flag
			s_floor <= '1';	
		end if;
	end process;
	
------------------------------------------------------------------------------
--------------------------------- Cycle Adder --------------------------------
------------------------------------------------------------------------------
	s_reset_floor_state_machine <= not(s_floor or s_extfloor);

	process (LED_SEQ_i_0, s_reset_floor_state_machine, RST_i,s_floor_state)
	begin
		-- If it has no floor flag
		if ((s_reset_floor_state_machine = '1') or (RST_i = '1')) then 	
			-- Reset flag that shows the floor has ended
			s_end_floor <= '0';																
			-- Reset floor output flag
			FLOOR_o <= '0';																	
			-- Reset floor generator state machine
			s_floor_state <= (others=>'0');												
			BGND_OFF_o <= '0';
			BGND_FLOOR_o <= '0';
			ILLUM_FLOOR_o <= '0';
		
		-- On rising edge of LEDSEQ(0) (Rear Illumination on, process background illumination)		
		elsif rising_edge(LED_SEQ_i_0) then	 											
		-- Increase floor generator state machine
			s_floor_state <= s_floor_state + '1';
		-- Set flag that resets the floor flags to '0'		
			s_end_floor <= '0';	
			
			case s_floor_state is
				when "00000" =>																
									-- On start set output floor flag
									-- Set flag that turns all illuminations off
									BGND_OFF_o <= '1';										
									-- Set output floor flag to 1
									FLOOR_o <= '1';											
									
				when "01000" =>		-- On state 8
									-- Set background floor enable
									BGND_FLOOR_o <= '1';										
									
				when "01111" =>																
									-- On state 15
									-- Turn illumination on again
									BGND_OFF_o <= '0';
				when "11000" =>		
									-- On state 24
									-- Set other illuminations enable
									ILLUM_FLOOR_o <= '1';									 								

													
				when "11111" =>
									s_floor_state <= "11111";
									-- Set output floor flag to 0
									FLOOR_o <= '0';											
									-- Cleans flag that resets the floor flags
									s_end_floor <= '1';										

				when others =>
									ILLUM_FLOOR_o <= '0';
									BGND_FLOOR_o <= '0';
									s_end_floor <= '0';
				
			end case;
			
		end if;
	end process;
	
------------------------------------------------------------------------------

end Behavioral;