----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:25:38 06/26/2012 
-- Design Name: 
-- Module Name:    SERIAL_RX - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SERIAL_RX is
    Port ( RX_i : in  STD_LOGIC;												-- RX serial input
           BAUD_CLK_i : in  STD_LOGIC;										-- Baud clock rate (38400)
           RST_i : in  STD_LOGIC;											
			  
			  FAIL_o : out STD_LOGIC;											-- Flag that indicates if there was not an end signal
           PACKET_READY_o : out  STD_LOGIC;								-- Flag that indicates if the receiving state machine is ended
           RX_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0));			-- RX received data (8 bits)
end SERIAL_RX;

architecture Behavioral of SERIAL_RX is
signal s_receive_state_machine : std_logic_vector(3 downto 0);
signal s_rx_data_buff : std_logic_vector(7 downto 0);

begin

	process(BAUD_CLK_i,RST_i)
	begin
	
	if rising_edge(BAUD_CLK_i) then													-- On the rising edge of Baud clock (38400 Hz)
	
		if (RST_i = '1') then															-- If there is a reset
		
			FAIL_o <= '0';																	-- Set fail output to 0 
			PACKET_READY_o <= '0';														-- Set the output that show that there is a received packet to '0'
			RX_DATA_o <= "00000000";													-- Set the output data to "00000000"
			s_receive_state_machine <= "0000";										-- Set the receive state machine to wait state
			
		else 																					-- If there is no reset
		
			case s_receive_state_machine is												
				when "0000" =>													
									if (RX_i = '0') then									-- If the input RX pin is 0 (Start bit)
										s_receive_state_machine <= "0001";			-- Go to next state (receive buffer bit 0)
										PACKET_READY_o <= '0';							-- Set packet ready flag to 0
									else														-- If the TX pin is 1 (idle)
										s_receive_state_machine <= "0000";			-- Wait until there is start bit
									end if;
									
				when "0001" =>
									s_rx_data_buff(0) <= RX_i;							-- Receiver buffer receives bit 0
									s_receive_state_machine <= "0010";
				when "0010" =>
									s_rx_data_buff(1) <= RX_i;							-- Receiver buffer receives bit 1
									s_receive_state_machine <= "0011";	
				when "0011" =>
									s_rx_data_buff(2) <= RX_i;							-- Receiver buffer receives bit 2
									s_receive_state_machine <= "0100";
				when "0100" =>
									s_rx_data_buff(3) <= RX_i;							-- Receiver buffer receives bit 3
									s_receive_state_machine <= "0101";
				when "0101" =>
									s_rx_data_buff(4) <= RX_i;							-- Receiver buffer receives bit 4
									s_receive_state_machine <= "0110";
				when "0110" =>	
									s_rx_data_buff(5) <= RX_i;							-- Receiver buffer receives bit 5
									s_receive_state_machine <= "0111";
				when "0111" =>
									s_rx_data_buff(6) <= RX_i;							-- Receiver buffer receives bit 6
									s_receive_state_machine <= "1000";
				when "1000" =>
									s_rx_data_buff(7) <= RX_i;							-- Receiver buffer receives bit 7
									s_receive_state_machine <= "1001";
				when "1001" =>
									s_receive_state_machine <= "0000";				-- Returns to wait state
									PACKET_READY_o <= '1';								-- Set packet ready flag to 1
									
									if (RX_i = '1') then									-- If there is an end flag
									
										RX_DATA_o <= s_rx_data_buff;					-- Set the output with the buffer
										FAIL_o <= '0';										-- Set the fail flag to 0 (there was an end flag)
										
									else														-- If there is not an end flag
									
										FAIL_o <= '1';										-- Set the fail flag to 1 (something went wrong - clock skew maybe)
										
									end if;
				
				when others =>
									PACKET_READY_o <= '0';
									s_receive_state_machine <= "0000";
									
			end case;
				
		end if;
	end if;
		
	end process;

end Behavioral;

