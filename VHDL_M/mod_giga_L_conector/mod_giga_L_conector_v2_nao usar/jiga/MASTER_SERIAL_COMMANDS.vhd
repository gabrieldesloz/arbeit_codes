----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:44:41 06/30/2014 
-- Design Name: 
-- Module Name:    MASTER_SERIAL_COMMANDS - Behavioral 
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

entity MASTER_SERIAL_COMMANDS is
    Port ( 
				-------------------------------------------------------------------------
				---------------------------- System signals -----------------------------
				-------------------------------------------------------------------------
				CLK_60MHZ_i : in  STD_LOGIC;								-- Input 60MHz system clock
				EN_CLK_i : in  STD_LOGIC;									-- Input 1MHz enable signal
				RESET_i : in  STD_LOGIC;									-- Input reset signal
				-------------------------------------------------------------------------
				--------------------- Communication control signals ---------------------
				-------------------------------------------------------------------------				
				uC_REQUEST_i : in STD_LOGIC;								-- Microntroller is requesting data from other FPGAs
				uC_FPGA_SELECT_i : in STD_LOGIC;							-- Select FPGA 2 ('0') or FPGA 3 ('1')
				
				uC_COMMAND_i : in STD_LOGIC_VECTOR(7 downto 0);		-- Microntroller incoming command
				uC_DATA_i : in STD_LOGIC_VECTOR(31 downto 0);		-- Microntroller incoming data
				
				DATA_TO_uC_RECEIVED_i : in STD_LOGIC;					-- Flag that indicates uC interface has registered the data
				DATA_TO_uC_READY_o : out STD_LOGIC;						-- Indicates serial data is ready
				-------------------------------------------------------------------------
				--------------- Serial block signals between FPGA 1 and 2 ---------------
				-------------------------------------------------------------------------
				SERIAL_DATA_1_2_i : in  STD_LOGIC_VECTOR (7 downto 0);	-- Input serial data from FPGA 2
				SERIAL_DATA_1_2_o : out  STD_LOGIC_VECTOR (7 downto 0);	-- Output serial data to FPGA 2

				PACKET_SENT_1_2_i : in  STD_LOGIC;								-- Indicates packet has been send to FPGA 2
				PACKET_FAIL_1_2_i : in  STD_LOGIC;								-- Indicates packet received FPGA 2 has failed
				PACKET_READY_1_2_i : in  STD_LOGIC;								-- Indicates that packet received from FPGA 2 is ready

				SEND_PACKET_1_2_o : out  STD_LOGIC;								-- Flag that iniciates serial data sending to FPGA 2
				-------------------------------------------------------------------------
				--------------- Serial block signals between FPGA 1 and 3 ---------------
				-------------------------------------------------------------------------
				SERIAL_DATA_1_3_i : in  STD_LOGIC_VECTOR (7 downto 0); 	-- Input serial data from FPGA 3
				SERIAL_DATA_1_3_o : out  STD_LOGIC_VECTOR (7 downto 0);  -- Output serial data to FPGA 3
                                                                     
				PACKET_SENT_1_3_i : in  STD_LOGIC;                       -- Indicates packet has been send to FPGA 3
				PACKET_FAIL_1_3_i : in  STD_LOGIC;                       -- Indicates packet received from FPGA 3 has failed
				PACKET_READY_1_3_i : in  STD_LOGIC;                      -- Indicates that packet received from FPGA 3 is ready
                                                                     
				SEND_PACKET_1_3_o : out  STD_LOGIC;                      -- Flag that iniciates serial data sending to FPGA 3
				-------------------------------------------------------------------------
				--------------------------- Serial Information --------------------------
				-------------------------------------------------------------------------
				FPGA_2_VERSION_o : out STD_LOGIC_VECTOR(7 downto 0);		-- FPGA 2 version (4 MSB should be "1001" for this information to be valid)
				FPGA_3_VERSION_o : out STD_LOGIC_VECTOR(7 downto 0);		-- FPGA 3 version (4 MSB should be "1001" for this information to be valid)
				-------------------------------------------------------------------------
				---------------------------- uC Requested Data --------------------------
				-------------------------------------------------------------------------
				-- R2R Digital to analog converter
				R2R_i : in STD_LOGIC_VECTOR(7 downto 0);
				-------------------------------------------------------------------------
				-- Illumination pins
				FRONT_LED_A_o : out STD_LOGIC;
				FRONT_LED_B_o : out STD_LOGIC;
				FRONT_LED_C_o : out STD_LOGIC;
				FRONT_LED_D_o : out STD_LOGIC;
				
				REAR_LED_A_o : out STD_LOGIC;
				REAR_LED_B_o : out STD_LOGIC;
				REAR_LED_C_o : out STD_LOGIC;
				REAR_LED_D_o : out STD_LOGIC;
				
				V_BCKGND_o : out STD_LOGIC;	
				-------------------------------------------------------------------------
				-- Ejector board output status
				EJET_o : out STD_LOGIC_VECTOR(31 downto 0);				-- Returns ejectors activation (if ejector board outputs are active)
				-------------------------------------------------------------------------
				-- 12 Feeders board
				TEST_FED_OUT_o : out STD_LOGIC_VECTOR(11 downto 0);	-- 12 Feeders board vibrators feedback 
				-------------------------------------------------------------------------
				-- Resistor board test signals
				R_COMP_o : out STD_LOGIC_VECTOR(31 downto 0) -- Resistor board feedback 
				
				-------------------------------------------------------------------------
				-------------------------------------------------------------------------
				-------------------------------------------------------------------------				
			  
			);
end MASTER_SERIAL_COMMANDS;

architecture Behavioral of MASTER_SERIAL_COMMANDS is
-- State machine states
type t_state is (st_IDLE, st_SEND_CMD, st_WAIT_SEND_1, st_WAIT_RECEIVE_1, st_WAIT_CONFIRMATION, st_FAIL_TEST, 
st_SEND_CMD_DATA, st_WAIT_RECEIVE_2, st_WAIT_PKT, st_DATA_CONFIRM, st_WAIT_SEND_2, 
st_SENT_CONFIRM, st_UC_DATA_OK);

signal s_state : t_state;
-------------------------------------------------------------------------
-- Microntroller request latch control signals
signal s_uc_request, s_clear_request : std_logic := '0'; -- uC request latch

-- Communication block general signals
signal s_end_cmd : std_logic := '0'; -- Flag that indicates the command has ended
signal s_serial_data_in : std_logic_vector(7 downto 0); -- Selects between the two input data

-- 12 Feeders board
signal s_vib_is : std_logic := '0'; -- Feeders board feedback index

-- R2R digital to analog
signal s_R2R_is : std_logic_vector(1 downto 0) := "00";	-- R2R send index

-- Sorting board data
signal s_illum_is : std_logic_vector(1 downto 0) := "00";	-- Illumination index

-- Ejectors board
signal s_ejet_is: std_logic_vector(1 downto 0) := "00";	-- Ejectors status index

-- Resistor board
signal s_R_COMP_is : std_logic_vector(1 downto 0) := "00"; -- R COMP resistor board feedback index

begin


--=== MUX ===----
	-- Selects input data depending on which FPGA is receiving
	s_serial_data_in <= SERIAL_DATA_1_3_i when (uC_FPGA_SELECT_i = '1') else SERIAL_DATA_1_2_i;
--============---
	
	process(CLK_60MHZ_i, RESET_i, s_uc_request)
	begin

		if (RESET_i = '1') then
		
			s_state <= st_IDLE;							-- Initial state is st_IDLE
		
		else
		
			if rising_edge(CLK_60MHZ_i) then
			
				if (EN_CLK_i = '1') then
				
					SEND_PACKET_1_2_o <= '0';		-- Assures the flag will be active only one cycle
					SEND_PACKET_1_3_o <= '0';		-- Assures the flag will be active only one cycle
				
					case s_state is
					
						-------------------------------------------------------------------------
						-- Idle state waits for a microcontroller request
						when st_IDLE =>			
								if (s_uc_request = '1') then				--	If there is a microcontroller request the latch will be active
									s_clear_request <= '1';					-- Clears the microcontroller request latch
									s_state <= st_SEND_CMD;					-- Goes to state that selects which FPGA to send and sends serial command
								end if;
						-------------------------------------------------------------------------
						--	State selects which FPGA to send and sends serial command
						when st_SEND_CMD =>									
						
								SERIAL_DATA_1_2_o <= uC_COMMAND_i;					-- Assign requested command to FPGA 2
								SERIAL_DATA_1_3_o <= uC_COMMAND_i;					-- Assign requested command to FPGA 3
								
								SEND_PACKET_1_2_o <= not(uC_FPGA_SELECT_i);		-- Send serial command to FPGA 2
								SEND_PACKET_1_3_o <= uC_FPGA_SELECT_i;				-- Send serial command to FPGA 3
								
								s_clear_request <= '0';									-- Set clear latch request to 0
								s_state <= st_WAIT_SEND_1;								-- Next state waits the serial communication block to start the sending process
						-------------------------------------------------------------------------
						-- Waits the serial communication block to start the sending process
						when st_WAIT_SEND_1 =>		
						        -- espera a interface serial "dizer" que o pacote está sendo enviado  (packet_sent = '0')
								if (uC_FPGA_SELECT_i = '0') and (PACKET_SENT_1_2_i = '0') then	-- If FPGA selected is FPGA 2 and the packet is being sent
									s_state <= st_WAIT_RECEIVE_1;					              		-- Go to next state that waits for packet to be sent and starts receiving confimation packet
								end if;
								
								if (uC_FPGA_SELECT_i = '1') and (PACKET_SENT_1_3_i = '0') then	-- If FPGA selected is FPGA 3 and the packet is being sent
									s_state <= st_WAIT_RECEIVE_1;											-- Go to next state that waits for packet to be sent and starts receiving confimation packet
								end if;
						-------------------------------------------------------------------------
						-- Waits for the serial data to be completely sent and confirmation packet to be received 
						when st_WAIT_RECEIVE_1 =>
								-- se terminou de enviar e ainda está recebendo...
								if (PACKET_SENT_1_2_i = '1') and (PACKET_SENT_1_3_i = '1') then		-- If both packets are ready (only one is being used at a time)
									if (PACKET_READY_1_2_i = '0') or (PACKET_READY_1_3_i = '0') then	-- If any of the two serial controllers is receiving a serial packet
										s_state <= st_WAIT_CONFIRMATION;					            		-- Go to next state that waits for packet to be received and tests confirmation
									end if;
								end if;
						
						-------------------------------------------------------------------------
						-- Waits for the serial data packet to complete and receives for the confirmation packet
						when st_WAIT_CONFIRMATION =>
						        -- se terminou de receber, teste se tudo ok, senão, volta ao início
								if (PACKET_READY_1_2_i = '1') and (PACKET_READY_1_3_i = '1') then	-- If any of the two serial controllers is receiving a serial packet
									if ((uC_FPGA_SELECT_i = '0') and (PACKET_FAIL_1_2_i = '1')) or 
									((uC_FPGA_SELECT_i = '1') and (PACKET_FAIL_1_3_i = '1')) then	-- Test FPGA selected and if the packet failed
										s_state <= st_IDLE;														-- Go to IDLE state and starts all again
										s_end_cmd <= '0';															-- Flag that indicates command has ended
									
									else																				-- In case the received command did not failed
									
										s_state <= st_FAIL_TEST;												-- Go to first wait send state
									
									end if;
								
								end if;
								
						-------------------------------------------------------------------------
						-- In this state verifies if received data is the serial confirmation data
						when st_FAIL_TEST =>
						
								if (s_serial_data_in = "01001011") then									-- If received serial data is 0x4B - ASCII "K" for O"K"
									
									if s_end_cmd = '1' then														-- If a send command has ended
										s_end_cmd <= '0';															-- Flag that indicates command has ended
										s_state <= st_IDLE;														-- Go to IDLE state and waits for new command request
									else																				
										s_state <= st_SEND_CMD_DATA;											-- Go to next state and start to handle the command
									end if;
									
								else																					-- If the received serial data is different from 0x4B
								
									s_end_cmd <= '0';																-- Flag that indicates command has ended
									s_state <= st_IDLE;															-- Go to IDLE state and starts all again
								
								end if;
						-------------------------------------------------------------------------
						-- In this state do the actions depending on which command is being processed
						when st_SEND_CMD_DATA =>
						
								case (uC_FPGA_SELECT_i & uC_COMMAND_i(2 downto 0)) is
								
									-------------------------------------------------------------------------
									-- Serial commands to FPGA 2
									-------------------------------------------------------------------------
									when "0010" =>
									-- Sends 4 R2R values (R2R1 to R2R4)
									
										SEND_PACKET_1_2_o <= not(uC_FPGA_SELECT_i);		-- Send serial command to FPGA 2
										SEND_PACKET_1_3_o <= uC_FPGA_SELECT_i;				-- Send serial command to FPGA 3
									
										SERIAL_DATA_1_2_o <= R2R_i;					-- Assign R2R data to FPGA 2
										SERIAL_DATA_1_3_o <= R2R_i;					-- Assign R2R data to FPGA 3
										
										s_state <= st_WAIT_SEND_1;						-- Goes back to state WAIT SEND and waits until the data starts to be send
										
										s_R2R_is <= s_R2R_is + '1';					-- Increase R2R index until all 4 R2Rs are sent
										case s_R2R_is is
											
											when "11" =>
												s_end_cmd <= '1';							-- Flag that indicates command has ended
											
											when others =>
										
										end case;
									-------------------------------------------------------------------------
									-- Serial commands to FPGA 3
									-------------------------------------------------------------------------
									when "1010" =>
									-- Executing this command inverts R_TEST outputs (32 outputs that goes to the Resistor board)
										s_state <= st_IDLE;
									-------------------------------------------------------------------------
									when others =>
										s_state <= st_WAIT_RECEIVE_2;
								
								end case;
						-------------------------------------------------------------------------
						------------------ From here on only receiving commands -----------------
						-------------------------------------------------------------------------
						-- Wait until a new packet starts to be received
						when st_WAIT_RECEIVE_2 =>
								if (PACKET_READY_1_2_i = '0') or (PACKET_READY_1_3_i = '0') then	-- If any of the two serial controllers is receiving a serial packet
									s_state <= st_WAIT_PKT;					            					-- Go to next state that waits for packet to be received and tests confirmation
								end if;
						
						-------------------------------------------------------------------------
						-- In this state waits for packet to be received and tests if the packet failed
						when st_WAIT_PKT =>
								if (PACKET_READY_1_2_i = '1') and (PACKET_READY_1_3_i = '1') then	-- If the serial controllers received the serial packet 
									if ((uC_FPGA_SELECT_i = '0') and (PACKET_FAIL_1_2_i = '1')) or 
									((uC_FPGA_SELECT_i = '1') and (PACKET_FAIL_1_3_i = '1')) then	-- Test FPGA selected and if the packet failed
										s_state <= st_IDLE;														-- Go to IDLE state and starts all again
									
									else																				-- In case the received command did not failed
										
										SERIAL_DATA_1_2_o <= "01001011";										-- Send confirmation package 0x4B - ASCII "K" for O"K"
										SERIAL_DATA_1_3_o <= "01001011";										-- Send confirmation package 0x4B - ASCII "K" for O"K"
										
										SEND_PACKET_1_2_o <= not(uC_FPGA_SELECT_i);						-- Send serial command to FPGA 2
										SEND_PACKET_1_3_o <= uC_FPGA_SELECT_i;								-- Send serial command to FPGA 3
										
										s_state <= st_DATA_CONFIRM;											-- Go to next state and 
									
									end if;
								
								end if;
								
						-------------------------------------------------------------------------
						-- In this state the received serial data is treated
						when st_DATA_CONFIRM => 
						
									s_state <= st_WAIT_SEND_2; 													-- Go to next state and wait to send back confirmation packet
						
									case (uC_FPGA_SELECT_i & uC_COMMAND_i(2 downto 0)) is
										-------------------------------------------------------------------------
										-- Serial commands to FPGA 2
										-------------------------------------------------------------------------
										when "0000" =>
										-- Receives "1001" & FPGA 2 Version
										FPGA_2_VERSION_o <= SERIAL_DATA_1_2_i;									-- Receives FPGA 2 version (4 MSB should be "1001")
										s_end_cmd <= '1';																-- Flag that indicates command has ended
										
										when "0001" =>
										-- Receives illumination interface pin status
											s_illum_is <= s_illum_is + '1';										-- Increase received illumination index 
											
											case s_illum_is is														-- Checks which illumination is being received
											
												when "00" =>															-- Front illumination pin status
														FRONT_LED_A_o <= SERIAL_DATA_1_2_i(3);
														FRONT_LED_B_o <= SERIAL_DATA_1_2_i(2);
														FRONT_LED_C_o <= SERIAL_DATA_1_2_i(1);
														FRONT_LED_D_o <= SERIAL_DATA_1_2_i(0);
												
												when "01" =>															-- Rear illumination pin status
														REAR_LED_A_o <= SERIAL_DATA_1_2_i(3);
														REAR_LED_B_o <= SERIAL_DATA_1_2_i(2);
														REAR_LED_C_o <= SERIAL_DATA_1_2_i(1);
														REAR_LED_D_o <= SERIAL_DATA_1_2_i(0);
														
												when "10" =>															-- Background illumination pin status
														V_BCKGND_o <= SERIAL_DATA_1_2_i(0);
														s_end_cmd <= '1';												-- Flag that indicates command has ended
														s_illum_is <= "00";											-- Set illumination to 0 again (Front)
												
												when others =>
											
											end case;
																				
										when "0100" =>
										-- Receives 32 ejector status (8 bit at a time starting from LSB)
											s_ejet_is <= s_ejet_is + '1';											-- Increase received ejector index 
											
											case s_ejet_is is															-- Checks which ejector part is being received
											
												when "00" =>															-- 7 first ejectors
														EJET_o(7 downto 0) <= SERIAL_DATA_1_2_i;	
												
												when "01" =>															-- 7 next ejectors
														EJET_o(15 downto 8) <= SERIAL_DATA_1_2_i;
														
												when "10" =>															-- 7 next ejectors
														EJET_o(23 downto 16) <= SERIAL_DATA_1_2_i;
														
												when "11" =>															-- Last 7 ejectors
														EJET_o(31 downto 24) <= SERIAL_DATA_1_2_i;
														s_end_cmd <= '1';												-- Flag that indicates command has ended
												
												when others =>
											
											end case;

										-------------------------------------------------------------------------
										-- Serial commands to FPGA 3
										-------------------------------------------------------------------------
										when "1000" =>
										-- Receives "1001" & FPGA 3 Version
											FPGA_3_VERSION_o <= SERIAL_DATA_1_3_i;
											s_end_cmd <= '1';																	-- Flag that indicates command has ended
											
										when "1001" =>
										-- Receives vibrator feedback
											if (s_vib_is = '1') then														-- If the vibrator flag is 1
												TEST_FED_OUT_o(11 downto 8) <= SERIAL_DATA_1_3_i(3 downto 0);	-- Second packet sends back "0000" and last 4 feeders feedback
												s_vib_is <= '0';																-- Set vibrator packet flag to '0'
												s_end_cmd <= '1';																-- Flag that indicates command has ended
											else
												TEST_FED_OUT_o(7 downto 0) <= SERIAL_DATA_1_3_i;					-- First packet sends back first 8 feeders feedback
												s_vib_is <= '1';																-- Set vibrator packet flag to '1'
											end if;
											
										when "1011" =>
										-- Receives 32 R_COMP bits (Resistor board feedback)
											s_R_COMP_is <= s_R_COMP_is + '1';											-- Increases index register that indicates the partial resistors packet
											case s_R_COMP_is is
											
												when "00" =>
													R_COMP_o(7 downto 0) <= SERIAL_DATA_1_3_i;						-- First packet receives back first 8 resistors outputs
													
												when "01" =>
													R_COMP_o(15 downto 8) <= SERIAL_DATA_1_3_i;						-- Second packet receives back second 8 resistors outputs
													
												when "10" =>
													R_COMP_o(23 downto 16) <= SERIAL_DATA_1_3_i;						-- Third packet receives back third 8 resistors outputs
													
												when "11" =>
													R_COMP_o(31 downto 24) <= SERIAL_DATA_1_3_i;						-- Fourth packet receives back fourth 8 resistors outputs
													s_R_COMP_is <= "00";														-- Set index register to "00"
													s_end_cmd <= '1';															-- Flag that indicates command has ended
												
												when others =>
												
											end case;
										
										
										-------------------------------------------------------------------------
										
										when others => 
										
									end case;
						-------------------------------------------------------------------------
						-- In this state wait until the confirmation packet is sent and checks if the command has ended
						when st_WAIT_SEND_2 =>
						
								if ((uC_FPGA_SELECT_i = '0') and (PACKET_SENT_1_2_i = '0')) or 
									((uC_FPGA_SELECT_i = '1') and (PACKET_SENT_1_3_i = '0')) then		-- Test FPGA selected and if the packet is being sent
									
									s_state <= st_SENT_CONFIRM;													-- Go to SENT CONFIRM state and wait until confirmation packet is sent completelly
									
								end if;
										
						-------------------------------------------------------------------------
						-- Waits for the serial data to be completely sent and confirmation packet to be received 
						when st_SENT_CONFIRM =>
								
								if (PACKET_SENT_1_2_i = '1') and (PACKET_SENT_1_3_i = '1') then		-- If both packets are ready (only one is being used at a time)
									
									if (s_end_cmd = '1') then														-- If command has ended
										s_state <= st_UC_DATA_OK;													-- Go to UC data OK state and clear flag when uc has read the data
										DATA_TO_uC_READY_o <= '1';													-- Flag that indicates data is ready to be read for uC
										s_end_cmd <= '0';																-- Set end command flag to 0
									else
										s_state <= st_WAIT_RECEIVE_2;												-- Go to WAIT RECEIVE 2 state and receive next packet
									end if;
									
								end if;
						-------------------------------------------------------------------------
						-- State to assure the uC will receive the data and clear the flag
						when st_UC_DATA_OK =>
						
								if DATA_TO_uC_RECEIVED_i = '1' then												-- Flag that indicates uC has read the data and should now clear flag
									DATA_TO_uC_READY_o <= '0';														-- Clear the flag
									s_state <= st_IDLE;																-- Go to IDLE state and wait for new command
								end if;
						-------------------------------------------------------------------------
						when others =>
						
					end case;
					
				end if;
			end if;
		end if;

	end process;
	
-------------------------------------------------------------------------
------------------------- uC Command Request ----------------------------
-------------------------------------------------------------------------
	process(RESET_i, uC_REQUEST_i, s_clear_request)
	begin
		
		if (RESET_i = '1') or (s_clear_request = '1') then		-- If there is a reset signal or clear signal request
			
			s_uc_request <= '0';											-- Reset latch that indicates there is a microcontroller data request
		
		else
			if rising_edge(uC_REQUEST_i) then						-- If the microtroller has sent a data request
		
				s_uc_request <= '1';										-- Set latch that indicates there is a microcontroller data request
		
			end if;
		end if;
		
	end process;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------

end Behavioral;