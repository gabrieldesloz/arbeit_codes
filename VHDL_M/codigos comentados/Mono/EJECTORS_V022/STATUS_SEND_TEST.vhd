----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:50 06/26/2012 
-- Design Name: 
-- Module Name:    STATUS_SENDER - Behavioral 
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

entity STATUS_SENDER is
    Port ( ADC1_DATA_i : in STD_LOGIC_VECTOR(9 downto 0);
			  ADC2_DATA_i : in STD_LOGIC_VECTOR(9 downto 0);
			  MAX_CURR_A : in STD_LOGIC_VECTOR(10 downto 0);
			  MAX_CURR_B : in STD_LOGIC_VECTOR(10 downto 0);
           CLK_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  SEND_o : out STD_LOGIC;
           TX_o : out  STD_LOGIC);
end STATUS_SENDER;

architecture Behavioral of STATUS_SENDER is
-------------------------------------------
----------- Serial Transmitter ------------
-------------------------------------------
component SERIAL_TX is
    Port ( TX_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);		-- Transmission data
--           NOT_RX_i : in  STD_LOGIC;									-- Not Receiving flag (if '1' is free to transmit, else waits until the reception is finished)
           SEND_i : in  STD_LOGIC;										-- Send flag (On rising edge starts to send data)
           BAUD_CLK_i : in  STD_LOGIC;									-- Baud clock (38400 Hz)
           RST_i : in  STD_LOGIC;										
			  
			  PACKET_SENT_o: out STD_LOGIC;								-- Flag that shows the packet was sent
           TX_o : out  STD_LOGIC);										-- TX Serial Output
end component;

-------------------------------------------
------------- Periodic Sender  ------------
-------------------------------------------
component SEND_SERIAL_DATA is
    Port ( ADC1_DATA_i : in STD_LOGIC_VECTOR(9 downto 0);
			  ADC2_DATA_i : in STD_LOGIC_VECTOR(9 downto 0);
			  MAX_CURR_A : in STD_LOGIC_VECTOR(10 downto 0);
			  MAX_CURR_B : in STD_LOGIC_VECTOR(10 downto 0);
           PACKET_SENT_i : in  STD_LOGIC;
           CLK_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
           SEND_8BIT_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);
           SEND_o : out  STD_LOGIC);
end component;
-------------------------------------------
---------- Wire Interconnections ----------
-------------------------------------------
signal s_packet_sent_i : std_logic;
signal s_send_o : std_logic;
signal s_send_data_o : std_logic_vector(7 downto 0);

begin
	SEND_o <= s_send_o;

	i_SERIAL_TX : SERIAL_TX 
    Port map( 
					TX_DATA_i => s_send_data_o,
					SEND_i => s_send_o,
					BAUD_CLK_i => CLK_i,
					RST_i => RST_i,
				  
					PACKET_SENT_o => s_packet_sent_i,
					TX_o => TX_o
				);
			  
	i_SEND_SERIAL_DATA : SEND_SERIAL_DATA
    Port map( 
					ADC1_DATA_i => ADC1_DATA_i,
					ADC2_DATA_i => ADC2_DATA_i,
					MAX_CURR_A => MAX_CURR_A,
					MAX_CURR_B => MAX_CURR_B,
					PACKET_SENT_i => s_packet_sent_i,
					CLK_i => CLK_i,
					RST_i => RST_i,
					
					SEND_8BIT_DATA_o => s_send_data_o,
					SEND_o => s_send_o
				);

end Behavioral;

