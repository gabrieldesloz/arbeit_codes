----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:45 06/26/2012 
-- Design Name: 
-- Module Name:    SEND_SERIAL_DATA - Behavioral 
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

entity SEND_SERIAL_DATA is
    Port ( ADC1_DATA_i : in STD_LOGIC_VECTOR(9 downto 0);
			  ADC2_DATA_i : in STD_LOGIC_VECTOR(9 downto 0);
			  MAX_CURR_A : in STD_LOGIC_VECTOR(10 downto 0);
			  MAX_CURR_B : in STD_LOGIC_VECTOR(10 downto 0);
           PACKET_SENT_i : in  STD_LOGIC;
           CLK_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
           SEND_8BIT_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);
           SEND_o : out  STD_LOGIC);
end SEND_SERIAL_DATA;

architecture Behavioral of SEND_SERIAL_DATA is
signal s_send_interval_counter : integer range 0 to 131071;
signal s_send_state_machine : std_logic_vector(4 downto 0);
begin

	process(CLK_i, RST_i)
	begin
		if rising_edge(CLK_i) then
		
			if (RST_i = '1') then
			
				SEND_8BIT_DATA_o <= "00000000";
				SEND_o <= '0';
				s_send_state_machine <= "00000";
				s_send_interval_counter <= 0;
			
			else
			
				if (s_send_interval_counter = 131070) then
			
					case s_send_state_machine is
					
						when "00000" =>
											SEND_8BIT_DATA_o <= "000000" & ADC1_DATA_i(9 downto 8);
											SEND_o <= '1'; 
											s_send_state_machine <= "00001";
											
						when "00001" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_state_machine <= "00010";
											else
												s_send_state_machine <= "00001";
											end if;
											
						when "00010" =>
											SEND_8BIT_DATA_o <= ADC1_DATA_i(7 downto 0);
											SEND_o <= '1'; 
											s_send_state_machine <= "00011";
						
						when "00011" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_state_machine <= "00100";
											else
												s_send_state_machine <= "00011";
											end if;				
											
						when "00100" =>
											SEND_8BIT_DATA_o <= "000000" & ADC2_DATA_i(9 downto 8);
											SEND_o <= '1'; 
											s_send_state_machine <= "00101";
											
						when "00101" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_state_machine <= "00110";
											else
												s_send_state_machine <= "00101";
											end if;
						
						when "00110" =>
											SEND_8BIT_DATA_o <= ADC2_DATA_i(7 downto 0);
											SEND_o <= '1'; 
											s_send_state_machine <= "00111";
						
						when "00111" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_state_machine <= "01000";
											else
												s_send_state_machine <= "00111";
											end if;
											
						when "01000" =>
											SEND_8BIT_DATA_o <= "00000" & MAX_CURR_A(10 downto 8);
											SEND_o <= '1'; 
											s_send_state_machine <= "01001";

						when "01001" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_state_machine <= "01010";
											else
												s_send_state_machine <= "01001";
											end if;						
						
						when "01010" =>
											SEND_8BIT_DATA_o <= MAX_CURR_A(7 downto 0);
											SEND_o <= '1'; 
											s_send_state_machine <= "01011";
						
						when "01011" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_state_machine <= "01100";
											else
												s_send_state_machine <= "01011";
											end if;

						when "01100" =>
											SEND_8BIT_DATA_o <= "00000" & MAX_CURR_B(10 downto 8);
											SEND_o <= '1'; 
											s_send_state_machine <= "01101";
						
						when "01101" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_state_machine <= "01110";
											else
												s_send_state_machine <= "01101";
											end if;
						
						when "01110" =>
											SEND_8BIT_DATA_o <= MAX_CURR_B(7 downto 0);
											SEND_o <= '1'; 
											s_send_state_machine <= "01111";
						
						when "01111" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_state_machine <= "10000";
											else
												s_send_state_machine <= "01111";
											end if;

						when "10000" =>
											SEND_8BIT_DATA_o <= "11111111";
											SEND_o <= '1';
											s_send_state_machine <= "10001";
						
						when "10001" =>
											SEND_o <= '0';
											if (PACKET_SENT_i = '1') then
												s_send_interval_counter <= 0;
												s_send_state_machine <= "10001";
											else
												s_send_state_machine <= "10001";
											end if;
											
						when others =>
											s_send_interval_counter <= 0;
											SEND_o <= '0'; 
					
					end case;
					
				else
				
					SEND_o <= '0';
					s_send_state_machine <= "00000";
					SEND_8BIT_DATA_o <= "00000000";
					s_send_interval_counter <= s_send_interval_counter + 1;
					
				end if;
			
			end if;
			
		end if;
	end process;

end Behavioral;

