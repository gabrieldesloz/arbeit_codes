----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:33:34 09/25/2012 
-- Design Name: 
-- Module Name:    INT_TUNE_PLAYER - Behavioral 
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

entity INT_TUNE_PLAYER is
    Port ( CMD_i : in  STD_LOGIC_VECTOR (7 downto 0);						-- Current command
           DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);					-- Data comming from the deserializer module
           NEW_DATA_i : in  STD_LOGIC;											-- Has a new data
           ERROR_i : in  STD_LOGIC;												-- The deserializer received an invalid packet
           CMD_END_i : in  STD_LOGIC;											-- Indicates a command end
           CLK_i : in  STD_LOGIC;												
           RESET_i : in  STD_LOGIC;
			  
           PLAY_o : out  STD_LOGIC;												-- Play tune
           STOP_o : out  STD_LOGIC;												-- Stop tune
           REC_o : out  STD_LOGIC;												-- Record a new tune part
           REC_ADDR_o : out  STD_LOGIC_VECTOR (8 downto 0);				-- Increases as soon as the last tune part was recorded
           PERIOD_o : out  STD_LOGIC_VECTOR (23 downto 0);				-- The tune period (1/freq) in us steps
           NOTE_LENGTH_o : out  STD_LOGIC_VECTOR (39 downto 0);		-- The duration of the tune perior in us steps
           LIVE_o : out  STD_LOGIC);											-- Live flag (the period generates an output frequency)
end INT_TUNE_PLAYER;

architecture Behavioral of INT_TUNE_PLAYER is
signal s_live, s_max_wait, s_inside_command : std_logic;
signal s_was_on_state, s_cmd_state, s_pkt_nbr : std_logic_vector(2 downto 0);
signal s_rec_addr : std_logic_vector(8 downto 0);

type s_part_array is array(7 downto 0) of std_logic_vector(7 downto 0);
signal s_part : s_part_array;
begin

	REC_ADDR_o <= s_rec_addr;

	process(CLK_i, RESET_i)
	begin
		if rising_edge(CLK_i) then																		-- On rising edge of 1MHz clock
			if (RESET_i = '1') then
				
				s_inside_command <= '0';
				s_live <= '0';																				-- Live flag is '0'
				PLAY_o <= '0';																				
				STOP_o <= '0';
				REC_o <= '0';
				LIVE_o <= '0';
				s_was_on_state <= (others=>'0');
				s_cmd_state <= (others=>'0');
				s_pkt_nbr <= (others=>'0');
				s_rec_addr <= (others=>'0');
				
			else
			
				-- Review this first and add to the cmd reset part
--				if (s_inside_command = '1') then														-- If there is an active command
--					if (s_max_count = 5000000) then													-- Checks if the maximum counter reached maximum time
--						s_max_wait <= '1';																	-- Have reached maximum wait time (5 sec)
--						s_max_count <= 0;																	-- Set maximum counter to 0
--					else																						
--						s_max_count <= s_max_count + 1;												-- If did not reached maximum time keep counting
--					end if;
--				else																							-- If there is not an active command
--					s_max_count <= 0;
--				end if;
			
				if ((CMD_END_i = '1') or (ERROR_i = '1')) then									-- Checks if there is an error on received packet
																												--	or command has ended or maximum wait time has being
																												-- reached (5 seconds)
					s_cmd_state <= "000";																-- Then goes to state 0
					s_inside_command <= '0';															-- Set flag that indicates that is not anymore inside a command
				else	
					s_cmd_state <= s_cmd_state;														-- Keep doing what it was doing
				end if;
			
				REC_o <= '0';																				-- Make sure REC flag will be active only 1 clock cycle
			
				case s_cmd_state is
					
					when "000" =>	-- Command 0x01 is Play/Stop/Live command and 0x02 is REC command
										s_rec_addr <= (others=>'0');									-- Set record address to 0
										s_pkt_nbr <= (others=>'0');									-- Set packet number to 0
										PLAY_o <= '0';														-- Set Play to 0
										if (CMD_i = "00000001") then									-- If it is Play/Stop or Live command
											s_cmd_state <= "001";										-- Go to first state
											s_inside_command <= '1';
										else
											if (CMD_i = "00000010") then								-- If it is the REC command
												s_cmd_state <= "111";									-- Go to receive 64 bit data buffer state
												s_was_on_state <= "100";
												s_inside_command <= '1';
											else																-- If the command is neither one
												s_cmd_state <= "000";									-- Wait here until a valid command is received
												s_inside_command <= '0';
											end if;
										end if;
										
----------------------------------------------------------------------------------------------------------
---------------------------- Live or Memory Tune Command Interpretation ----------------------------------
----------------------------------------------------------------------------------------------------------									
									
					when "001" =>	-- Data(0) receives Play/Stop data and Data(7) receives Live or Memory Tune
										if (NEW_DATA_i = '1') then										-- Checks if there is new data
										
											if (DATA_i(7) = '1') then									-- If Live is on
												s_cmd_state <= "111";									-- Go to receive 64 bit data buffer state
												s_was_on_state <= "010";								-- Next state after receiving 64 bit packet
											else
												LIVE_o <= '0';
												s_cmd_state <= "011";									-- Go to state 3
											end if;
										end if;
					
					when "010" => -- Live state
										LIVE_o <= '1';													-- LIVE_o receives bit 7
										PERIOD_o <= s_part(2) & s_part(1) & s_part(0);			-- Receives the packets 
										--s_cmd_state <= "000";											-- Go to state 0 and wait for new command
											
					when "011" =>	-- Play/Stop command
										--s_cmd_state <= "000";											-- Go to state 0 and wait for new command 
										if (DATA_i(0) = '1') then										-- Gets the Play/Stop data (Bit 0)
											PLAY_o <= '1';													-- Set play flag to 1
											STOP_o <= '0';													-- Set stop flag to 0
										else																	-- If there is not a play command
											PLAY_o <= '0';													-- Set play flag to 0
											STOP_o <= '1';													-- Set stop flag to 0
										end if;
					
----------------------------------------------------------------------------------------------------------
-------------------------------------------- Record tune -------------------------------------------------
----------------------------------------------------------------------------------------------------------

					when "100" =>
										REC_o <= '1';														-- Set record flag to '1' (memory WR_EN)
										PERIOD_o <= s_part(2) & s_part(1) & s_part(0);			-- Receives the packets (lower 3)
										NOTE_LENGTH_o <= s_part(7) & s_part(6) & s_part(5) &	-- Higher 5
																s_part(4) & s_part(3);
										s_was_on_state <= "100";										-- Next state after receiving 64 bit packet
										s_cmd_state <= "101";											-- Go to next state
	
					when "101" =>
										s_rec_addr <= s_rec_addr + '1';								-- Go to next tune address
										s_cmd_state <= "111";											-- Go to next state
	
					when "111" =>
										if (NEW_DATA_i = '1') then										-- Checks if there is new data
										
											s_part(CONV_INTEGER(s_pkt_nbr)) <= DATA_i;			-- Buffers all the input data to get a 64 bit packet
											if (s_pkt_nbr = "111") then								-- Checks if all 8 packets have been received
												s_pkt_nbr <= "000";										-- Set packet index to 0
												s_cmd_state <= s_was_on_state;						-- Go to state 0
											else																-- If the did not received the whole 64 bit packet
												s_pkt_nbr <= s_pkt_nbr + 1;							--	Get the next packet
											end if;
										end if;
					
					when others =>
										s_cmd_state <= "000";
										
				end case;
			end if;
		end if;
	end process;

end Behavioral;

