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

entity SERIAL_COMMANDS_fpga_3 is
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
				--------------------------------------------------------------------------------
				---------------------------- Feeder board output test --------------------------
				--------------------------------------------------------------------------------
				-- Vibrator driver board feeder output
				TEST_FED_OUT_i : in  STD_LOGIC_VECTOR(11 downto 0);	
				--------------------------------------------------------------------------------
				------------------------------- Resistor board test ----------------------------
				--------------------------------------------------------------------------------
				-- Resistor board test output
				R_TEST_o : out STD_LOGIC_VECTOR(31 downto 0);			
				-- Resistor board test input feedback
				R_COMP_i : in STD_LOGIC_VECTOR(31 downto 0)			
			  );
end SERIAL_COMMANDS_fpga_3;

architecture Behavioral of SERIAL_COMMANDS_fpga_3 is
-------------------------------------------------------------------------
constant c_version : std_logic_vector (3 downto 0) := X"2"; -- Version 1   *** teste modificar depois
-------------------------------------------------------------------------
type t_state is (st_IDLE, st_WAIT_PKT, st_CMD_CONFIRM, st_WAIT_SEND_1, st_CMD_CHK, st_WAIT_SEND_2, st_WAIT_CONFIRMATION, st_FAIL_TEST);
signal s_state : t_state;

signal s_end_cmd : std_logic;
signal s_vib_is : std_logic;
signal s_activate_R_TEST : std_logic;
signal s_R_COMP_is : std_logic_vector(1 downto 0);
signal s_cmd : std_logic_vector(1 downto 0);

begin

	R_TEST_o <= (others => '1') when (s_activate_R_TEST = '1') else (others => '0');

	process(CLK_60MHZ_i, EN_CLK_i, RESET_i)
	begin
	
		if (RESET_i = '1') then
	
			s_state <= st_IDLE;							-- Set initial state to IDLE state
			s_vib_is <= '0';								-- Set the vibrator board feeder serial packet indexer to 0
			s_end_cmd <= '0';								-- Flag that indicates the command has ended			
			s_activate_R_TEST <= '0';					-- inits R TEST output with '0'
			s_R_COMP_is <= "00";							-- Set resistor board input R_COMP packet index to "00"
	
		else
			if rising_edge(CLK_60MHZ_i) then
			
				if (EN_CLK_i = '1') then
				
					SEND_PACKET_o <= '0';											-- Assures that the SEND_PACKET is active only one cycle (on TX block there is a latch)
				
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
										
									SERIAL_DATA_o <= "01000110"; 				-- Send back 0x46 - ASCII "F" for "F"ailed
									SEND_PACKET_o <= '1';						-- Activate TX send packet latch
									
									s_end_cmd <= '0';									-- Flag that indicates command has ended
								else													-- In case the received command did not failed
									s_state <= st_WAIT_SEND_1;					-- Go to first wait send state 
									
									s_cmd <= SERIAL_DATA_i(1 downto 0);	-- Registers received command 
									
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
								
									s_state <= st_WAIT_SEND_2;						-- Go to second wait send state 
									
									case s_cmd is
									
										-------------------------------------------------------------------------
										-- Sends a pattern "1001" and the FPGA version
										when "00" =>--st_CMD_VERSION =>								
										
													SERIAL_DATA_o <= "1001" & c_version; 		-- Send back "1001" and FPGA test version
													SEND_PACKET_o <= '1';							-- Activate TX send packet latch
													
													s_end_cmd <= '1';									-- Flag that indicates command has ended
										-------------------------------------------------------------------------
										-- Sends back feedback from vibrator driver board feeder output 
										when "01" =>
													
													if (s_vib_is = '1') then												-- If the vibrator flag is 1
													
														SERIAL_DATA_o <= "0000" & TEST_FED_OUT_i(11 downto 8);	-- Second packet sends back "0000" and last 4 feeders feedback
														s_vib_is <= '0';														-- Set vibrator packet flag to '0'
														s_end_cmd <= '1';														-- Flag that indicates command has ended
														
													else
													
														SERIAL_DATA_o <= TEST_FED_OUT_i(7 downto 0);					-- First packet sends back first 8 feeders feedback
														s_vib_is <= '1';														-- Set vibrator packet flag to '1'
													
													end if;
													
													SEND_PACKET_o <= '1';													-- Activate TX send packet latch										
										-------------------------------------------------------------------------
										-- Inverts flag that activates resistor board R_TEST output 
										when "10" =>--st_CMD_R2R =>
													
													s_activate_R_TEST <= not(s_activate_R_TEST);	-- Inverts the flag that activates R_TEST outputs
													s_state <= st_IDLE;									-- Go to IDLE state
													
										-------------------------------------------------------------------------
										-- Send back 32 resistor board R_COMP signals
										when "11" =>
										
													s_R_COMP_is <= s_R_COMP_is + '1';					-- Increases index register that indicates the partial resistors packet
													case s_R_COMP_is is
													
														when "00" =>
															SERIAL_DATA_o <= R_COMP_i(7 downto 0);		-- First packet sends back first 8 resistors outputs
															
														when "01" =>
															SERIAL_DATA_o <= R_COMP_i(15 downto 8);		-- Second packet sends back second 8 resistors outputs
															
														when "10" =>
															SERIAL_DATA_o <= R_COMP_i(23 downto 16);		-- Third packet sends back third 8 resistors outputs
															
														when "11" =>
															SERIAL_DATA_o <= R_COMP_i(31 downto 24);		-- Fourth packet sends back fourth 8 resistors outputs
															s_R_COMP_is <= "00";									-- Set index register to "00"
															s_end_cmd <= '1';										-- Flag that indicates command has ended
														
														when others =>
														
													end case;
													SEND_PACKET_o <= '1';									-- Activate TX send packet latch
													
										-------------------------------------------------------------------------
										when others =>
													s_state <= st_IDLE;										-- Go to IDLE state and nothing happens
													s_end_cmd <= '0';											-- Flag that indicates command has ended
									
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

									else														-- In case the received command did not failed
									
										s_end_cmd <= '0';									-- Flag that indicates command has ended
										
										if (SERIAL_DATA_i = "01001011") then 		-- If received confirmation package was 0x4B - ASCII "K" for O"K"
										
											if (s_end_cmd = '1') then					-- Tests if it was the last iteraction from command
												s_state <= st_IDLE;						-- Finish command go to IDLE state and wait for next command
												
											else												-- If it was not the last iteraction from command
												s_state <= st_CMD_CHK;					-- Go to next command iteraction
											end if;
											
										else													-- If the received package was anything else
											s_state <= st_IDLE;							-- Finish command go to IDLE state and wait for command retry
											
										end if;
										
									end if;
								end if;
						-------------------------------------------------------------------------
						when others =>
								s_state <= st_IDLE;									-- Go to IDLE state and wait for new command
								s_end_cmd <= '0';										-- Flag that indicates command has ended
								
					end case;
				
				end if;
			end if;
		end if;
	
	end process;

end Behavioral;