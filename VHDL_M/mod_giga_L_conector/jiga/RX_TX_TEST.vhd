----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:43:49 06/26/2012 
-- Design Name: 
-- Module Name:    RX_TX_TEST - Behavioral 
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

entity RX_TX_TEST is
    Port ( TX_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);
           SEND_i : in  STD_LOGIC;
           CLK_i : in  STD_LOGIC;										-- Baud clock (38400 Hz)
			  CLK_EN_i : in  STD_LOGIC;									-- Clock enable (in case it is needed)
           RST_i : in  STD_LOGIC;
			  
			  FAIL_o : out STD_LOGIC;											-- Flag that indicates if there was not an end signal
           PACKET_READY_o : out  STD_LOGIC;
           PACKET_SENT_o : out  STD_LOGIC;
			  RX_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0));
end RX_TX_TEST;

architecture Behavioral of RX_TX_TEST is
signal s_tx_o : std_logic;

-------------------------------------------
------------ Serial Receiver --------------
-------------------------------------------
component SERIAL_RX is
    Port ( RX_i : in  STD_LOGIC;
           CLK_i : in  STD_LOGIC;										-- Baud clock (38400 Hz)
			  CLK_EN_i : in  STD_LOGIC;									-- Clock enable (in case it is needed)
           RST_i : in  STD_LOGIC;
			  
			  FAIL_o : out STD_LOGIC;											-- Flag that indicates if there was not an end signal
           PACKET_READY_o : out  STD_LOGIC;
           RX_DATA_o : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

-------------------------------------------
----------- Serial Transmitter ------------
-------------------------------------------
component SERIAL_TX is
    Port ( TX_DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);		-- Transmission data
--           NOT_RX_i : in  STD_LOGIC;									-- Not Receiving flag (if '1' is free to transmit, else waits until the reception is finished)
           SEND_i : in  STD_LOGIC;										-- Send flag (On rising edge starts to send data)
           CLK_i : in  STD_LOGIC;										-- Baud clock (38400 Hz)
			  CLK_EN_i : in  STD_LOGIC;									-- Clock enable (in case it is needed)
           RST_i : in  STD_LOGIC;										
			  
			  PACKET_SENT_o: out STD_LOGIC;								-- Flag that shows the packet was sent
           TX_o : out  STD_LOGIC);										-- TX Serial Output
end component;
-------------------------------------------

begin
-------------------------------------------
----------- Serial Transmitter ------------
-------------------------------------------
	i_SERIAL_TX : SERIAL_TX 
    Port map( 
				TX_DATA_i => TX_DATA_i,
				SEND_i => SEND_i,
				CLK_i => CLK_i,
				CLK_EN_i => CLK_EN_i,
				RST_i => RST_i,
			  
				PACKET_SENT_o => PACKET_SENT_o,
				TX_o => s_tx_o
				);		

-------------------------------------------
------------ Serial Receiver --------------
-------------------------------------------
	i_SERIAL_RX : SERIAL_RX
    Port map ( 
				RX_i => s_tx_o,
				CLK_i => CLK_i,
				CLK_EN_i => CLK_EN_i,
				RST_i => RST_i,
			  
				FAIL_o => FAIL_o,
				PACKET_READY_o => PACKET_READY_o,
				RX_DATA_o => RX_DATA_o
				);
			  
end Behavioral;

