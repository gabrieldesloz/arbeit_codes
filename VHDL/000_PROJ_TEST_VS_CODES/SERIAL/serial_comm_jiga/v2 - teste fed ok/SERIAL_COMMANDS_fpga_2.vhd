----------------------------------------------------------------------------------
-- Company: 		
-- Engineer: 
-- 
-- Create Date:    10:09:16 06/11/2014 
-- Design Name: 
-- Module Name:    SERIAL_COMMANDS - Behavioral 
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

entity SERIAL_COMMANDS_fpga_2 is
    Port ( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i : in STD_LOGIC;
				EN_CLK_i : in STD_LOGIC;
				
				RESET_i : in STD_LOGIC;
				-------------------------------------------------------------------------
				------------------------- Serial block signals --------------------------
				-------------------------------------------------------------------------
				-- Serial data (from serial communication block)
				SERIAL_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);
				SERIAL_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);
				
				-- Control signals from Serial communication block 
				PACKET_SENT_i : in  STD_LOGIC;
				PACKET_FAIL_i : in  STD_LOGIC;
				PACKET_READY_i : in  STD_LOGIC;
				
				SEND_PACKET_o : out  STD_LOGIC;
				-------------------------------------------------------------------------
				---------------------- Sorting board test signals -----------------------
				-------------------------------------------------------------------------				
				-- Front Illumination signals
				FRONT_LED_A_i : in  STD_LOGIC;
				FRONT_LED_B_i : in  STD_LOGIC;
				FRONT_LED_C_i : in  STD_LOGIC;
				FRONT_LED_D_i : in  STD_LOGIC;
				
				-- Rear Illumination signals
				REAR_LED_A_i : in  STD_LOGIC;
				REAR_LED_B_i : in  STD_LOGIC;
				REAR_LED_C_i : in  STD_LOGIC;
				REAR_LED_D_i : in  STD_LOGIC;
				
				-- Background Illumination signals
				V_BCKGND_i : in  STD_LOGIC;
				
				-- R2R Digital-to-Analog outputs to Sorting board CCD inputs
				R2R1_o : out  STD_LOGIC_VECTOR (7 downto 0);
				R2R2_o : out  STD_LOGIC_VECTOR (7 downto 0);
				R2R3_o : out  STD_LOGIC_VECTOR (7 downto 0);
				R2R4_o : out  STD_LOGIC_VECTOR (7 downto 0);
				-------------------------------------------------------------------------
				---------------------- Sorting board test signals -----------------------
				-------------------------------------------------------------------------		
				-- Ejector board
				EJET_i : in  STD_LOGIC_VECTOR (31 downto 0);
				
				-- Ejector board communication test
				EJECTOR_COM_TEST_i : in  STD_LOGIC;
				EJECTOR_COM_TEST_o : out  STD_LOGIC;
				FSM_o: out std_logic_vector(3 downto 0)
			  );
end SERIAL_COMMANDS_fpga_2;

architecture Behavioral of SERIAL_COMMANDS_fpga_2 is
-------------------------------------------------------------------------
constant c_version : std_logic_vector (3 downto 0) := X"1"; -- Version 1
-------------------------------------------------------------------------
type t_state is (st_IDLE, st_WAIT_PKT, st_CMD_CONFIRM, st_WAIT_SEND_1, st_CMD_CHK, st_WAIT_SEND_2, st_WAIT_CONFIRMATION, st_FAIL_TEST);
signal s_state : t_state;

signal s_end_cmd : std_logic;
signal s_receiving : std_logic;
signal s_ej_com_out : std_logic;
signal s_illum_is, s_ejet_is : std_logic_vector(1 downto 0);
signal s_R2R_is : std_logic_vector(2 downto 0);
signal s_cmd : std_logic_vector(2 downto 0);

begin

	process(CLK_60MHZ_i, EN_CLK_i, RESET_i)
	begin
	
		if (RESET_i = '1') then
	
			s_state <= st_IDLE;							-- Set initial state to IDLE state
			s_receiving <= '0';							-- Flag that indicates the command is still in progress and should not receive new command
			s_end_cmd <= '0';								-- Flag that indicates the command has ended
			s_ej_com_out <= '0';							-- Register to invert the ejector communication test output every time the command is executed
			s_illum_is <= "00"; 							-- Set first illumination to be sent
			s_ejet_is <= "00";							-- Set first ejector part to be sent (1 - 8)
			s_R2R_is <= "000";							-- Set first R2R to be received
			
	
		else
			if rising_edge(CLK_60MHZ_i) then
			
				SEND_PACKET_o <= '0';											-- Assures that the SEND_PACKET is active only one cycle (on TX block there is a latch)
			
				if (EN_CLK_i = '1') then
				
					case s_state is
					
						-------------------------------------------------------------------------
						when st_IDLE =>											-- In this state waits until RX block receives a new packet
								if (PACKET_READY_i = '0') then				-- In case RX block is receiving a new byte
									s_state <= st_WAIT_PKT;						-- Go to WAIT_PKT state
								else													-- In case there is no new byte packet
									s_state <= st_IDLE;							-- Stay in this state and nothing happens
								end if;
						------------------------------------------------------------------------- 
						when st_WAIT_PKT =>										-- In case RX block is receiving a new packet
								if (PACKET_READY_i = '0') then				-- Tests if the new packet is not ready
									s_state <= st_WAIT_PKT;						-- Stay in this state
								else													-- If there is a ready new packet
									s_state <= st_CMD_CONFIRM;					-- Go to confimation state
								end if;
						-------------------------------------------------------------------------	
						when st_CMD_CONFIRM =>									-- In this state it will send back a confimation back in case the new packet is OK
								if (PACKET_FAIL_i = '1') then					-- Tests if the received command packet failed
									s_state <= st_IDLE;							-- Go to IDLE state and starts all again
										
									s_receiving <= '0';							-- Flag that indicates the command is still in progress and should not receive new command
									SERIAL_DATA_o <= "01000110"; 				-- Send back 0x46 - ASCII "F" for "F"ailed
									SEND_PACKET_o <= '1';						-- Activate TX send packet latch
									
									s_end_cmd <= '0';									-- Flag that indicates command has ended
								else													-- In case the received command did not failed
									s_state <= st_WAIT_SEND_1;					-- Go to first wait send state 
									
									if (s_receiving = '0') then				-- If there is no command being executed
										s_cmd <= SERIAL_DATA_i(2 downto 0);	-- Registers received command 
									end if;											-- Otherwise keep current command latch
									
									SERIAL_DATA_o <= "01001011"; 				-- Sends back 0x4B - ASCII "K" for O"K"
									SEND_PACKET_o <= '1';						-- Activate TX send packet latch
								end if;
						-------------------------------------------------------------------------
						when st_WAIT_SEND_1 =>									-- Wait until PACKET_SENT_i flag is set to 0 which indicates packet is being sent
								if (PACKET_SENT_i = '0') then					-- Wait until packet is being sent
									s_state <= st_CMD_CHK;						-- Go to check command state
								else													-- If packet is not being sent yet
									s_state <= st_WAIT_SEND_1;					-- Wait
								end if;
						-------------------------------------------------------------------------
						when st_CMD_CHK =>
								if (PACKET_SENT_i = '1') then
									
									case s_cmd is
									
										-------------------------------------------------------------------------
										-- Sends a pattern "1001" and the FPGA version
										when "000" =>--st_CMD_VERSION =>								
										
													SERIAL_DATA_o <= "1001" & c_version; 		-- Send back "1001" and FPGA test version
													SEND_PACKET_o <= '1';							-- Activate TX send packet latch
													
													s_end_cmd <= '1';									-- Flag that indicates command has ended
													
													s_state <= st_WAIT_SEND_2;						-- Go to second wait send state 
										-------------------------------------------------------------------------
										-- Sends illumination interface (first Front, then Rear and then Background)
										when "001" =>--st_CMD_RD_ILLUM =>
										
													s_illum_is <= s_illum_is + '1';							-- Increases register that indicates the illumination type
													case s_illum_is is
													
														when "00" =>
															SERIAL_DATA_o <= "0000" &  FRONT_LED_A_i & 	-- Send back "0000" and Front Illumination status
																								FRONT_LED_B_i &
																								FRONT_LED_C_i &
																								FRONT_LED_D_i; 	
														when "01" =>
															SERIAL_DATA_o <= "0000" &  REAR_LED_A_i & 	-- Send back "0000" and Rear Illumination status
																								REAR_LED_B_i &
																								REAR_LED_C_i &
																								REAR_LED_D_i; 	
														when "10" =>
															SERIAL_DATA_o <= "0000000" & V_BCKGND_i;		-- Send back "0000000" and Background Illumination status
															s_illum_is <= "00";									-- Set illumination type to "00"
															s_end_cmd <= '1';										-- Flag that indicates command has ended
															
														when others =>
														
													end case;
													SEND_PACKET_o <= '1';							-- Activate TX send packet latch
													
													s_state <= st_WAIT_SEND_2;						-- Go to second wait send state 
										-------------------------------------------------------------------------
										-- Receives the 4 R2R Digital to Analog values (4 bytes)
										when "010" =>--st_CMD_R2R =>
													
													s_state <= st_IDLE;								-- Go to IDLE state regardless of which R2R
													s_receiving <= '1';								-- Flag that indicates the command is still in progress and should not receive new command
																											-- and this is made so that the first states can be reused
													
													s_R2R_is <= s_R2R_is + '1';					-- Every cycle increases R2R index (1-4)
													case s_R2R_is is									-- In the first cycle receives only the command
																		
														when "001" =>
																		R2R1_o <= SERIAL_DATA_i;	-- R2R index 1 receives serial data
																		
														when "010" =>
																		R2R2_o <= SERIAL_DATA_i;	-- R2R index 2 receives serial data
																		
														when "011" =>
																		R2R3_o <= SERIAL_DATA_i;	-- R2R index 3 receives serial data
																		
														when "100" =>
																		R2R4_o <= SERIAL_DATA_i;	-- R2R index 4 receives serial data
																		s_R2R_is <= "000";			-- Reset to first cycle for the next time the command is executed
																		s_receiving <= '0';			-- Flag that indicates the command is still in progress and should not receive new command
																		
														when others =>
																		
													end case;
										-------------------------------------------------------------------------
										-- Activates two ejector communication output pins (EACK and EATXD) and read back one ejector comunication input pin (EARXD)
--										when "011" =>--st_CMD_EJ_SERIAL =>
--													
--													EJECTOR_COM_TEST_o <= not(s_ej_com_out);				-- Turn on and off the ejector communcation test signals (EACK and EATXD on ejector board)
--													SERIAL_DATA_o <= "0000000" & EJECTOR_COM_TEST_i;	-- Send back "0000000" and Ejector communication test signal status (EARXD on ejector board)
--													SEND_PACKET_o <= '1';										-- Activate TX send packet latch
--													s_end_cmd <= '1';												-- Flag that indicates command has ended
--													
--													s_state <= st_WAIT_SEND_2;									-- Go to second wait send state 
										-------------------------------------------------------------------------
										-- Send back 32 ejectors input status (8 at a time)
										when "100" =>--st_CMD_32_EJECT =>
										
													s_ejet_is <= s_ejet_is + '1';							-- Increases register that indicates the partial ejectors status
													case s_ejet_is is
													
														when "00" =>
															SERIAL_DATA_o <= EJET_i(7 downto 0);		-- First packet sends back first 8 ejectors
															
														when "01" =>
															SERIAL_DATA_o <= EJET_i(15 downto 8);		-- Second packet sends back first 8 ejectors
															
														when "10" =>
															SERIAL_DATA_o <= EJET_i(23 downto 16);		-- Third packet sends back first 8 ejectors
															
														when "11" =>
															SERIAL_DATA_o <= EJET_i(31 downto 24);		-- Fourth packet sends back first 8 ejectors
															s_ejet_is <= "00";								-- Set illumination type to "00"
															s_end_cmd <= '1';									-- Flag that indicates command has ended
														
														when others =>
														
													end case;
													SEND_PACKET_o <= '1';									-- Activate TX send packet latch
													
													s_state <= st_WAIT_SEND_2;								-- Go to second wait send state 
													
										-------------------------------------------------------------------------
										when others =>
													s_state <= st_IDLE;										-- Go to IDLE state and nothing happens
													s_end_cmd <= '0';											-- Flag that indicates command has ended
													s_receiving <= '0';										-- Flag that indicates the command is still in progress and should not receive new command
									
									end case;
									
								end if;
						-------------------------------------------------------------------------
						when st_WAIT_SEND_2 =>									-- Wait until PACKET_SENT_i flag is set to 0 which indicates packet is being sent
								if (PACKET_SENT_i = '0') then					-- Wait until packet is being sent
									s_state <= st_WAIT_CONFIRMATION;			-- Go to send confirmation package
								else													-- If packet is not being sent yet
									s_state <= st_WAIT_SEND_2;					-- Wait
								end if;
						-------------------------------------------------------------------------
						when st_WAIT_CONFIRMATION =>								-- In this state wait for confirmation package

								if (PACKET_SENT_i = '1') then						-- Wait first for the last TX serial packet to be sent
								
									if (PACKET_READY_i = '0') then				-- Tests if a new RX serial packet is being received
										s_state <= st_FAIL_TEST;					-- Stay in this state
									end if;
									
								end if;
						-------------------------------------------------------------------------
						when st_FAIL_TEST =>												-- In this state wait for confirmation package
							
								if (PACKET_READY_i = '1') then						-- Test if the received RX packet is ready
								
									if (PACKET_FAIL_i = '1') then						-- Tests if the received packet failed
										s_state <= st_IDLE;								-- Go to IDLE state and starts all again
										s_end_cmd <= '0';									-- Flag that indicates command has ended
										s_receiving <= '0';								-- Flag that indicates the command is still in progress and should not receive new command

									else														-- In case the received command did not failed
										if (SERIAL_DATA_i = "01001011") then 		-- If received confirmation package was 0x4B - ASCII "K" for O"K"
										
											if (s_end_cmd = '1') then					-- Tests if it was the last iteraction from command
												s_state <= st_IDLE;						-- Finish command go to IDLE state and wait for next command
												s_end_cmd <= '0';							-- Flag that indicates command has ended
											else												-- If it was not the last iteraction from command
												s_state <= st_CMD_CHK;					-- Go to next command iteraction
											end if;
											
										else													-- If the received package was anything else
											s_state <= st_IDLE;							-- Finish command go to IDLE state and wait for command retry
											s_end_cmd <= '0';								-- Flag that indicates command has ended
											s_receiving <= '0';							-- Flag that indicates the command is still in progress and should not receive new command
										
										end if;
										
									end if;
								end if;
						-------------------------------------------------------------------------
						when others =>
								s_state <= st_IDLE;									-- Go to IDLE state and wait for new command
								s_end_cmd <= '0';										-- Flag that indicates command has ended
								s_receiving <= '0';									-- Flag that indicates the command is still in progress and should not receive new command
								
					end case;
				
				end if;
			end if;
		end if;
	
	end process;	
	
	
debug_o: process(s_state)
		begin
			case s_state is
				when st_IDLE => FSM_o <= "0000";
				when st_WAIT_PKT => FSM_o <= "0001"; 
				when st_CMD_CONFIRM => FSM_o <= "0010";
				when st_WAIT_SEND_1 => FSM_o <= "0011";
				when st_CMD_CHK => FSM_o <= "0100";
				when st_WAIT_SEND_2 => FSM_o <= "0101";
				when st_WAIT_CONFIRMATION => FSM_o <= "0110";
				when st_FAIL_TEST => FSM_o <= "0111";
				when others => FSM_o <= "1111";
			end case;
	end process;		
				
	

end Behavioral;