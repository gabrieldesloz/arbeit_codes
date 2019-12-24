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
    Port ( PACK_8BIT_0 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_1 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_2 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_3 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_4 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_5 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_6 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_7 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_8 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_9 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_10 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_11 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_12 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_13 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_14 : in  STD_LOGIC_VECTOR(7 downto 0);
			  
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
    Port ( PACK_8BIT_0 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_1 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_2 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_3 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_4 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_5 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_6 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_7 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_8 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_9 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_10 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_11 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_12 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_13 : in  STD_LOGIC_VECTOR(7 downto 0);
			  PACK_8BIT_14 : in  STD_LOGIC_VECTOR(7 downto 0);
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
					PACK_8BIT_0 => PACK_8BIT_0,
					PACK_8BIT_1 => PACK_8BIT_1,
					PACK_8BIT_2 => PACK_8BIT_2,
					PACK_8BIT_3 => PACK_8BIT_3,
					PACK_8BIT_4 => PACK_8BIT_4,
					PACK_8BIT_5 => PACK_8BIT_5,
					PACK_8BIT_6 => PACK_8BIT_6,
					PACK_8BIT_7 => PACK_8BIT_7,
					PACK_8BIT_8 => PACK_8BIT_8,
					PACK_8BIT_9 => PACK_8BIT_9,
					PACK_8BIT_10 => PACK_8BIT_10,
					PACK_8BIT_11 => PACK_8BIT_11,
					PACK_8BIT_12 => PACK_8BIT_12,
					PACK_8BIT_13 => PACK_8BIT_13,
					PACK_8BIT_14 => PACK_8BIT_14,
					
					PACKET_SENT_i => s_packet_sent_i,
					CLK_i => CLK_i,
					RST_i => RST_i,
					
					SEND_8BIT_DATA_o => s_send_data_o,
					SEND_o => s_send_o
				);

end Behavioral;

