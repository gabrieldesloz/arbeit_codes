----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:37:02 06/26/2012 
-- Design Name: 
-- Module Name:    SERIAL_TX - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity SERIAL_TX is
  port (TX_DATA_i : in std_logic_vector (7 downto 0);  -- Transmission data
        SEND_i    : in std_logic;  		-- Send flag (On rising edge starts to send data)
        CLK_i     : in std_logic;       -- Baud clock (38400 Hz)
        CLK_EN_i  : in std_logic;       -- Clock enable (in case it is needed)
        RST_i     : in std_logic;

        PACKET_SENT_o : out std_logic;   -- Flag that shows the packet was sent
        TX_o          : out std_logic);  -- TX Serial Output
end SERIAL_TX;

architecture Behavioral of SERIAL_TX is
  signal s_finish_packet, s_send_packet : std_logic;
  signal s_send_state_machine           : std_logic_vector(3 downto 0);

begin

  ------------------------------------------------------------------------------------------------------------------------
  process(SEND_i, s_finish_packet, RST_i)
  begin
    
    if ((s_finish_packet = '1') or (RST_i = '1')) then  -- If the packet has been sent or there is a reset
      s_send_packet <= '0';  -- Lower the flag that says that the packet shoud be sended
      PACKET_SENT_o <= '1';  -- Set the output flag that shows that is not transmitting
    else
      if rising_edge(SEND_i) then       -- If there is send request
        s_send_packet <= '1';  -- Set the flag that shows that there is a transmission
        PACKET_SENT_o <= '0';  -- Set the output flag that shows that it is transmitting
      end if;
    end if;
    
  end process;
  ------------------------------------------------------------------------------------------------------------------------

  process(CLK_i, CLK_EN_i, RST_i)
  begin
    
    if (RST_i = '1') then               -- If there is a reset
      
      TX_o                 <= '1';      -- Set the TX output to 1 (Idle)
      s_send_state_machine <= "0000";  -- Set the transmitting state machine to 0
      s_finish_packet      <= '0';  -- Set the flag that shows that the packet is finished to 0 (This reset the sending latch)
      
    else
      
      if rising_edge(CLK_i) then        -- System clock
        if (CLK_EN_i = '1') then
          
          if (s_send_packet = '1') then  -- If there is a send request

            s_send_state_machine <= s_send_state_machine + '1';  -- This increments the state machine each baud clock
            case s_send_state_machine is
              when "0000" =>
                TX_o <= '0';            -- Sends the start bit
              when "0001" =>
                TX_o <= TX_DATA_i(0);   -- Sends the bit 0
              when "0010" =>
                TX_o <= TX_DATA_i(1);   -- Sends the bit 1
              when "0011" =>
                TX_o <= TX_DATA_i(2);   -- Sends the bit 2
              when "0100" =>
                TX_o <= TX_DATA_i(3);   -- Sends the bit 3
              when "0101" =>
                TX_o <= TX_DATA_i(4);   -- Sends the bit 4
              when "0110" =>
                TX_o <= TX_DATA_i(5);   -- Sends the bit 5
              when "0111" =>
                TX_o <= TX_DATA_i(6);   -- Sends the bit 6
              when "1000" =>
                TX_o <= TX_DATA_i(7);   -- Sends the bit 7
              when "1001" =>
                                        -- Sends parity bit
                TX_o <= not(TX_DATA_i(7) xor TX_DATA_i(6) xor TX_DATA_i(5) xor TX_DATA_i(4) xor TX_DATA_i(3) xor TX_DATA_i(2) xor TX_DATA_i(1) xor TX_DATA_i(0));
              when "1010" =>
                TX_o            <= '1';  -- Sends the end bit (1st stop bit)
                s_finish_packet <= '1';  -- Reset the s_send_packet latch 
              when others =>
                TX_o <= '1';            -- In case it is other keep idle
            end case;
            
          else                          -- If the TX module is no transmitting
            
            TX_o                 <= '1';     -- Keep the output in '1' (Idle)
            s_send_state_machine <= "0000";  -- Set the sending state machine to 0
            s_finish_packet      <= '0';     -- and latch reset in 0
            
          end if;
          
        end if;
      end if;
    end if;
  end process;

end Behavioral;

