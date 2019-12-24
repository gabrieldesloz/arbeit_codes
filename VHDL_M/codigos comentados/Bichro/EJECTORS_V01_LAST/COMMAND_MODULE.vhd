----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:55:36 09/21/2012 
-- Design Name: 
-- Module Name:    COMMAND_MODULE - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COMMAND_MODULE is
    Port ( DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);			-- Serial data input packet
           FAIL_i : in  STD_LOGIC;										-- Serial packet fail
           PACKET_READY_i : in  STD_LOGIC;							-- Serial packet ready
           CLK_i : in  STD_LOGIC;										-- 1 MHz input clock
           RESET_i : in  STD_LOGIC;										-- Reset signal
			  
           CMD_o : out  STD_LOGIC_VECTOR (7 downto 0);			-- Current command output
           DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);			-- Command data output
			  NEW_DATA_o : out  STD_LOGIC;								-- Flag that indicates that there is new data 
			  ERROR_o : out STD_LOGIC;										-- Did not received the right check packet and generated an error
           CMD_END_o : out  STD_LOGIC);								-- Flag that indicates that the command has ended
end COMMAND_MODULE;

architecture Behavioral of COMMAND_MODULE is
signal s_has_packet, s_clear_has_packet : std_logic;
signal s_command_state_machine : std_logic_vector(2 downto 0);

begin

	process(CLK_i, RESET_i)
	begin
		if rising_edge(CLK_i) then															--	On rising edge of 1MHz clock	
			if (RESET_i = '1') then															-- If there is a reset signal
			
				s_command_state_machine <= "000";										-- Set initial state to 0
				s_clear_has_packet <= '0';													-- Clear has packet flag
				CMD_o <= (others=>'0');														-- Set command to 0 (not valid command)
				DATA_o <= (others=>'0');													-- Set data output to "00000000"
				NEW_DATA_o <= '0';															-- Set the new data flag to 0
				ERROR_o <= '0';																-- Set the error flag to 0
				CMD_END_o <= '1';																-- Set the command end flag to 1
				
			else
				
				s_clear_has_packet <= '0';													-- Set the clear flag to '0' to asure if will be active only 1 cycle
				NEW_DATA_o <= '0';															-- Set the new data flag on every clock cycle to asure
																									-- this will be active only 1 clock cycle
				case s_command_state_machine is
					
					when "000" =>																-- On the first state (Waiting for command)
										CMD_o <= (others=>'0');								
										
										if (s_has_packet = '1') then						-- If the module received a new packet
										
											s_clear_has_packet <= '1';						-- Clear the has packet flag
											
											if (DATA_i = "01101001") then					-- Check if there is a "Handshake" ("01101001")
												s_command_state_machine <= "001";		-- Go to next state
												CMD_END_o <= '0';								-- Set the command end flag to 0
												ERROR_o <= '0';								-- Set error flag to 0
											else													-- If the data is different from the "Handshake" pattern
												s_command_state_machine <= "000";		-- Stay here and wait for a new packet
												CMD_END_o <= '1';								-- Set the flag that indicates that the command has ended
												ERROR_o <= '1';								-- Set the error flag
											end if;
											
										else														-- If there is no packet
											s_command_state_machine <= "000";			-- Wait for a packet
										end if;
										
					when "001" =>																-- On the second state waits for the command
										if (s_has_packet = '1') then						-- If the module received a new packet
											s_command_state_machine <= "010";			-- Go to next state
											CMD_o <= DATA_i;									-- Set command to the received data
											s_clear_has_packet <= '1';						-- Clean the has packet flag
										else														-- If there is no packet
											s_command_state_machine <= "001";			-- Wait for a packet
										end if;
										
					when "010" =>																-- On the third state waits for the new data "Validation"
										if (s_has_packet = '1') then						-- If the module received a new packet
										
											s_clear_has_packet <= '1';						-- Clean the has packet flag
											if (DATA_i = "10010110") then					-- Check if there is "Validation" ("10010110")
												s_command_state_machine <= "011";		-- Go to next state
											else													-- If the data is different from the "Validation" pattern
												s_command_state_machine <= "000";		-- Go to state 0
												CMD_END_o <= '1';								-- Set the flag that indicates that the command has ended
												ERROR_o <= '1';								-- Generates an error
											end if;
											
										else														-- If there is no packet
											s_command_state_machine <= "010";			-- Wait for a packet
										end if;
										
					when "011" =>																-- On the fourth state receives new data
										if (s_has_packet = '1') then						-- If the module received a new packet
											
											s_command_state_machine <= "100";			-- Go to next state
											DATA_o <= DATA_i;									-- Set the data output with the received data
											NEW_DATA_o <= '1';								-- Set the has new data flag output
											s_clear_has_packet <= '1';						-- Clean the has packet flag
											
										else														-- If there is no packet
											s_command_state_machine <= "011";			-- Wait for a packet
										end if;
										
					when "100" =>																-- On the fifth state checks if there is a new data "Validation"
																									-- or if there is a command "Finalization"
										if (s_has_packet = '1') then						-- If the module received a new packet
										
											s_clear_has_packet <= '1';						-- Clean the has packet flag
											if (DATA_i = "10010110") then					-- Check if there is "Validation" ("10010110")
												s_command_state_machine <= "011";		-- Goes to the other stage and wait for a new valid data
											else													-- If the data is different from the "Validation" pattern
												s_command_state_machine <= "000";		-- Go to state 0
												CMD_END_o <= '1';								-- Set the flag that indicates that the command has ended
												
												if (DATA_i = "11000011") then				-- Checks if there is a "Finalization" data ("11000011")
													ERROR_o <= '0';							-- There is no error
												else												-- If there is no "Finalization" data
													ERROR_o <= '1';							-- There is an error
												end if;

											end if;
											
										else														-- If there is no packet
											s_command_state_machine <= "100";			-- Wait for a packet
										end if;
										
					when others => 
										s_command_state_machine <= "000";
										
				end case;
			end if;
		end if;
	end process;
	
	process(RESET_i, PACKET_READY_i, s_clear_has_packet)
	begin
		if ((RESET_i = '1') or (s_clear_has_packet = '1')) then	-- If there is a reset signal or a clear packet flag
		
			s_has_packet <= '0';												-- Clear the has packet signal
			
		else
			if rising_edge(PACKET_READY_i) then							-- On a rising edge of a Packet ready flag
				s_has_packet <= '1';											-- Set the has packet signal
			end if;			
		end if;
	
	end process;

end Behavioral;

