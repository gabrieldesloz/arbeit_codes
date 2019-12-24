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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SERIAL_RX_fpga_3 is
  port (RX_i      : in std_logic;       -- RX serial input
         CLK_i    : in std_logic;       -- Baud clock (38400 Hz)
         CLK_EN_i : in std_logic;       -- Clock enable (in case it is needed)
         RST_i    : in std_logic;

         FAIL_o         : out std_logic;  -- Flag that indicates if there was not an end signal
         PACKET_READY_o : out std_logic;  -- Flag that indicates if the receiving state machine is ended
         RX_DATA_o      : out std_logic_vector (7 downto 0));  -- RX received data (8 bits)
end SERIAL_RX_fpga_3;

architecture Behavioral of SERIAL_RX_fpga_3 is
  signal s_parity                     : std_logic;
  signal s_packet_ready, s_new_packet : std_logic;
  signal s_receive_state_machine      : std_logic_vector(3 downto 0);
  signal s_rx_data_buff               : std_logic_vector(7 downto 0);

begin

  ------------------------------------------------------------------------------------------------------------------------
  process(RX_i, s_packet_ready, RST_i)
  begin
    
    if ((s_packet_ready = '1') or (RST_i = '1')) then  -- If the packet has been received or there is a reset
      s_new_packet <= '0';  -- Unset the flag that shows there is a new packet detected
    else
      if falling_edge(RX_i) then        -- If there is new packet
        s_new_packet <= '1';  -- Set the flag that shows there is a new packet detected
      end if;
    end if;
    
  end process;
  ------------------------------------------------------------------------------------------------------------------------


  process(CLK_i, CLK_EN_i, RST_i)
  begin
    
    if (RST_i = '1') then               -- If there is a reset
      
      FAIL_o                  <= '0';   -- Set fail output to 0 
      s_packet_ready          <= '0';  -- Set the flag that show that there is a received packet to '0'
      PACKET_READY_o          <= '0';  -- Set the output that show that there is a received packet to '0'
      RX_DATA_o               <= "00000000";  -- Set the output data to "00000000"
      s_receive_state_machine <= "0000";  -- Set the receive state machine to wait state
      
    else
      
      if rising_edge(CLK_i) then  -- On the rising edge of Baud clock (38400 Hz)
        if (CLK_EN_i = '1') then        -- 

--                      if (RST_i = '1') then                                                                                                                   -- If there is a reset
--                      
--                              FAIL_o <= '0';                                                                                                                                  -- Set fail output to 0 
--                              PACKET_READY_o <= '0';                                                                                                          -- Set the output that show that there is a received packet to '1'
--                              RX_DATA_o <= "00000000";                                                                                                        -- Set the output data to "00000000"
--                              s_receive_state_machine <= "0000";                                                                              -- Set the receive state machine to wait state
--                              
--                      else                                                                                                                                                                    -- If there is no reset
          
          s_receive_state_machine <= s_receive_state_machine + '1';

          case s_receive_state_machine is
            when "0000" =>  -- 0x00                                         
              s_packet_ready <= '0';    -- Set packet ready flag to 0
              if (s_new_packet = '1') then  -- If the input RX pin is 0 (Start bit)
                s_receive_state_machine <= "0001";  -- Go to next state (receive buffer bit 0)
                PACKET_READY_o          <= '0';  -- Set the output that show that there is a received packet to '0'
              else                      -- If the TX pin is 1 (idle)
                s_receive_state_machine <= "0000";  -- Wait until there is start bit
              end if;
              
            when "0001" =>              -- 0x01
              s_rx_data_buff(0) <= RX_i;  -- Receiver buffer receives bit 0
            when "0010" =>              -- 0x02
              s_rx_data_buff(1) <= RX_i;  -- Receiver buffer receives bit 1
            when "0011" =>              -- 0x03
              s_rx_data_buff(2) <= RX_i;  -- Receiver buffer receives bit 2
            when "0100" =>              -- 0x04
              s_rx_data_buff(3) <= RX_i;  -- Receiver buffer receives bit 3
            when "0101" =>              -- 0x05
              s_rx_data_buff(4) <= RX_i;  -- Receiver buffer receives bit 4
            when "0110" =>              -- 0x06
              s_rx_data_buff(5) <= RX_i;  -- Receiver buffer receives bit 5
            when "0111" =>              -- 0x07
              s_rx_data_buff(6) <= RX_i;  -- Receiver buffer receives bit 6
            when "1000" =>              -- 0x08
              s_rx_data_buff(7) <= RX_i;  -- Receiver buffer receives bit 7
            when "1001" =>              -- 0x09
                                        -- Receives parity bit
              s_parity <= RX_i xor s_rx_data_buff(7) xor s_rx_data_buff(6) xor s_rx_data_buff(5) xor s_rx_data_buff(4) xor
                          s_rx_data_buff(3) xor s_rx_data_buff(2) xor s_rx_data_buff(1) xor s_rx_data_buff(0);
            when "1010" =>              -- 0x0A
              s_packet_ready <= '1';    -- Set packet ready flag to 1
              PACKET_READY_o <= '1';  -- Set the output that show that there is a received packet to '1'

              if ((RX_i = '1') and (s_parity = '1')) then  -- If there is an end flag
                
                RX_DATA_o <= s_rx_data_buff;  -- Set the output with the buffer
                FAIL_o    <= '0';  -- Set the fail flag to 0 (there was an end flag)
                
              else                      -- If there is not an end flag
                
                FAIL_o <= '1';  -- Set the fail flag to 1 (something went wrong - clock skew maybe)
                
              end if;
              
            when others =>
              s_receive_state_machine <= "0000";
              
          end case;
          
        end if;
      end if;
    end if;
    
  end process;

end Behavioral;
