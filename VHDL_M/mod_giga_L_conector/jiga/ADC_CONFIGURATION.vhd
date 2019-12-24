----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:15 09/20/2013 
-- Design Name: 
-- Module Name:    ADC_CONFIGURATION - Behavioral 
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

library UNISIM;
use UNISIM.VComponents.all;

entity ADC_CONFIGURATION is
    Port ( PGA1_RED_i : 	in  STD_LOGIC_VECTOR (5 downto 0);	-- PGA data configuration for red input (CCD1 / CHUTE A FRONT CAM)
           PGA1_GREEN_i : 	in  STD_LOGIC_VECTOR (5 downto 0);	-- PGA data configuration for green input (CCD2 / CHUTE A REAR CAM)
           SEND_PGA_i : 	in  STD_LOGIC;								-- Sends new serial PGA data
           CLK_i : 			in  STD_LOGIC;								-- 1 MHz input clock
           RESET_i : 		in  STD_LOGIC;										
			  
           ADC_1_2_SDATA : out STD_LOGIC;								-- ADC 1 serial configuration data
			  ADC_SCLK : 		out STD_LOGIC;								-- ADC Serial clock
			  ADC_SLOAD : 		out STD_LOGIC);							-- ADC Serial write enable (Active low when writing)
end ADC_CONFIGURATION;

architecture Behavioral of ADC_CONFIGURATION is
type t_state is (st_IDLE, st_WRITE_BIT, st_ADDR, st_X_CARE_1, st_X_CARE_2, st_X_CARE_3, st_DATA, st_NEXT_DATA);
signal s_state : t_state;
signal s_send_pga, s_pga_sent : std_logic;
signal s_first_time : std_logic;
signal s_addr : std_logic_vector(2 downto 0);
signal s_cnt : std_logic_vector(3 downto 0);
signal s_data_1_3 : std_logic_vector(8 downto 0);
begin

ADC_SCLK <= CLK_i;

process(RESET_i, SEND_PGA_i, s_pga_sent)
begin
	if (RESET_i = '1') or (s_pga_sent = '1') then
		s_send_pga <= '0';
	else
		if rising_edge(SEND_PGA_i) then
			s_send_pga <= '1';
		end if;
	end if;
end process;

process(CLK_i,RESET_i)
begin 

		if (RESET_i = '1') then
		
			ADC_1_2_SDATA <= '0';
			ADC_SLOAD <= '1';
			s_addr <= "000";
			s_data_1_3 <= "001101000";
			s_cnt <= "0010";											-- Set send times counter to 2 (3 address bits)
			s_state <= st_WRITE_BIT;
			
		else
		
			if falling_edge(CLK_i) then
			
				s_pga_sent <= '0';
				
				case s_state is
				
					when st_IDLE =>																	-- Stay idle until new PGA data
										if (s_send_pga = '1') then									-- Tests if there is new PGA data to be sent or is the first time after reset
											s_state <= st_WRITE_BIT;								-- Next state will start write process
											s_data_1_3 <= "000" & PGA1_RED_i;
										end if;
										
					when st_WRITE_BIT =>																-- First data bit should be 0 to write
										ADC_1_2_SDATA <= '0';										-- Write bit
										ADC_SLOAD <= '0';												-- Write/read enable is 0
										s_state <= st_ADDR;											-- Next state will send out the address bits
										
					when st_ADDR =>																	-- Send out the address bits
										ADC_1_2_SDATA <= s_addr(CONV_INTEGER(s_cnt));		-- Send the bit related to the counter (2 - 0)
						
										if (s_cnt = "0000") then									-- If the counter reached 0 
											s_cnt <= "1000";											-- Set counter to 8 (9 data bits)
											s_state <= st_X_CARE_1;									-- Next state is the first don't care bit

										else																-- If counter didn't reach 0
											s_cnt <= s_cnt - 1;										-- Decrement counter
										end if;
					
					when st_X_CARE_1 =>																-- Don't care state (like a nop)
										s_state <= st_X_CARE_2;
					
					when st_X_CARE_2 =>																-- Don't care state (like a nop)
										s_state <= st_X_CARE_3;			
					
					when st_X_CARE_3 =>																-- Don't care state (like a nop)
										s_state <= st_DATA;		
										
					when st_DATA =>																	-- Send out data state
										ADC_1_2_SDATA <= s_data_1_3(CONV_INTEGER(s_cnt));	-- Send the bit related to the counter (8 - 0)

										if (s_cnt = "0000") then									-- If counter has reached 0
											--ADC_SLOAD <= '1';										-- Write/read enable to 1
											s_state <= st_NEXT_DATA;								-- Next state will choose which data send next
										else																-- If counter didn't reach 0
											s_cnt <= s_cnt - 1;										-- Decrement counter
										end if;
					
					when st_NEXT_DATA =>																-- Select which data will be sent next
										
										s_state <= st_WRITE_BIT;									-- By default send new data
										s_cnt <= "0010";												-- Set counter to 2 to send 3 address bits again
										ADC_SLOAD <= '1';
										
										case s_addr is													-- Checks which was the last address and preset new
										
											when "000" =>												-- Configuration address by default (Send red offset next)
												s_data_1_3 <= "000000000";							
												s_addr <= "101";										-- Red offset address
												
											when "010" =>												-- Red PGA address
												s_data_1_3 <= "000" & PGA1_GREEN_i;
												s_addr <= "011";										-- Green PGA address
											when "011" =>												-- Green PGA address ( Preset red PGA next )
												s_addr <= "010";										-- Red PGA Address
												s_pga_sent <= '1';									-- Clears PGA send flag
												ADC_SLOAD <= '1';
												s_state <= st_IDLE;									-- Go to IDLE state and wait for a new configuration flag
												
											when "101" =>												-- Red offset address (Send green offset next) 
												s_data_1_3 <= "000000000";
												s_addr <= "110";										-- Green offset address
												
											when "110" =>												-- Green offset address ( Send red PGA next )
												s_data_1_3 <= "000" & PGA1_RED_i;				
												s_addr <= "010";										-- Red PGA address
												
											when others =>
												
										end case;
												
				end case;
			
		end if;
		
	end if;

end process;

end Behavioral;