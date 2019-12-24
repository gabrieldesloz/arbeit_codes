----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:16:53 08/05/2013 
-- Design Name: 
-- Module Name:    EJECTORS_DATA_SENDER - Behavioral 
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

package my_types_pkg is		-- Creates a type to use arrays in the entity declaration
	type input_array is array (7 downto 0) of std_logic_vector (31 downto 0);	-- The array type
end package;

library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_1164.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.my_types_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity EJECTORS_DATA_SENDER is
    Port ( EJ_PKT_i : in  STD_LOGIC_VECTOR (34 downto 0);			-- Ejector Data input (upper 3 bits are the command)
           TEJET_i : in  STD_LOGIC_VECTOR (31 downto 0);				-- Testejet buffer
           EJATXDATA_i : in  STD_LOGIC_VECTOR (31 downto 0);		-- Normal ejectors signals SIDE A
           EJBTXDATA_i : in  STD_LOGIC_VECTOR (31 downto 0);		-- Normal ejectors signals SIDE B
           DO_TESTEJETA_i : in  STD_LOGIC;								-- Flag that indicates that a testejet should be done on SIDE A
           DO_TESTEJETB_i : in  STD_LOGIC;								-- Flag that indicates that a testejet should be done on SIDE B
           ISPACA_i : in  STD_LOGIC;										-- Flag that indicates that data should be sent to side A
           ISPACB_i : in  STD_LOGIC;										-- Flag that indicates that data should be sent to side B
           EJ_RX_i : in  STD_LOGIC;											-- Serial RX
			  
           CLK_i : in  STD_LOGIC;											-- 18MHz clock
           RST_i : in  STD_LOGIC;
			  
			  EJARXDATA_o : out input_array;									-- Output array		-- 000 - Fuse information
			  EJBRXDATA_o : out input_array;									-- Output array		-- 001 - Not used
																													-- 010 - FPGA Version & "F800" & venn
																													-- 011 - Valve limiter - not used
																													-- 100 - IBUS1 AD current
																													-- 101 - IBUS2 AD current
																													-- 110 - AD 12V
																													-- 111 - AD 34V
           CLRPACA_o : out  STD_LOGIC;										-- Clears flag that indicates that data should be sent to side A
           CLRPACB_o : out  STD_LOGIC;										-- Clears flag that indicates that data should be sent to side B
           EJ_TX_o : out  STD_LOGIC;										-- Serial TX
           EJ_CLK_o : out  STD_LOGIC);										-- Serial Clock
end EJECTORS_DATA_SENDER;

architecture Behavioral of EJECTORS_DATA_SENDER is



signal s_not_clk_i, s_oddr_clk : std_logic;

type state_type is (st_IDLE_1, st_IDLE_2, st_INIT_1, st_INIT_2, st_DATA);  --type of state machine.
signal current_s : state_type;  --current and next state declaration.
signal s_rx_checksum, s_tx_checksum : std_logic;
signal s_second_pkt : std_logic;
signal s_send_times : integer range 0 to 64;
signal s_tx_data_int : std_logic_vector(34 downto 0);
signal s_tx_data, s_rx_data : std_logic_vector(35 downto 0);

begin
-----------------------------------------------------------------------------
---------------------------- Clock Forwarding -------------------------------
-----------------------------------------------------------------------------
	s_not_clk_i <= not(CLK_i);

   ODDR2_inst : ODDR2
   generic map(
      DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
      INIT => '0', -- Sets initial state of the Q output to '0' or '1'
      SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
   port map (
      Q => s_oddr_clk, -- 1-bit output data
      C0 => CLK_i, -- 1-bit clock input
      C1 => s_not_clk_i, -- 1-bit clock input
      CE => '1',  -- 1-bit clock enable input
      D0 => '1',   -- 1-bit data input (associated with C0)
      D1 => '0',   -- 1-bit data input (associated with C1)
      R => '0',    -- 1-bit reset input
      S => '0'     -- 1-bit set input
   );
	
	aoclk_obuf : OBUF
	port map(
		I => s_oddr_clk,
		O => EJ_CLK_o
	);
-----------------------------------------------------------------------------


s_rx_checksum <= s_rx_data(35) xor s_rx_data(34) xor s_rx_data(33) xor s_rx_data(32) xor s_rx_data(31) xor s_rx_data(30)
					xor s_rx_data(29) xor s_rx_data(28) xor s_rx_data(27) xor s_rx_data(26) xor s_rx_data(25) xor s_rx_data(24) xor s_rx_data(23) 
					xor s_rx_data(22) xor s_rx_data(21) xor s_rx_data(20) xor s_rx_data(19) xor s_rx_data(18) xor s_rx_data(17) xor s_rx_data(16) 
					xor s_rx_data(15) xor s_rx_data(14) xor s_rx_data(13) xor s_rx_data(12) xor s_rx_data(11) xor s_rx_data(10) xor s_rx_data(9) 
					xor s_rx_data(8) xor s_rx_data(7) xor s_rx_data(6) xor s_rx_data(5) xor s_rx_data(4) xor s_rx_data(3) 
					xor s_rx_data(2) xor s_rx_data(1) xor s_rx_data(0);
					
s_tx_checksum <= s_tx_data_int(34) xor s_tx_data_int(33) xor s_tx_data_int(32) xor s_tx_data_int(31) xor s_tx_data_int(30) 
					xor s_tx_data_int(29) xor s_tx_data_int(28) xor s_tx_data_int(27) xor s_tx_data_int(26) xor s_tx_data_int(25) xor s_tx_data_int(24) xor s_tx_data_int(23) 
					xor s_tx_data_int(22) xor s_tx_data_int(21) xor s_tx_data_int(20) xor s_tx_data_int(19) xor s_tx_data_int(18) xor s_tx_data_int(17) xor s_tx_data_int(16) 
					xor s_tx_data_int(15) xor s_tx_data_int(14) xor s_tx_data_int(13) xor s_tx_data_int(12) xor s_tx_data_int(11) xor s_tx_data_int(10) xor s_tx_data_int(9) 
					xor s_tx_data_int(8) xor s_tx_data_int(7) xor s_tx_data_int(6) xor s_tx_data_int(5) xor s_tx_data_int(4) xor s_tx_data_int(3) xor s_tx_data_int(2) 
					xor s_tx_data_int(1) xor s_tx_data_int(0);

process (CLK_i,RST_i, current_s, EJATXDATA_i, EJBTXDATA_i, DO_TESTEJETA_i, DO_TESTEJETB_i, ISPACA_i, ISPACB_i)
begin
	if rising_edge(CLK_i) then
		if (RST_i = '1') then
			current_s <= st_IDLE_1;  								-- Default state on reset
			CLRPACA_o <= '0';											-- Set to 0
			CLRPACB_o <= '0';							
			EJ_TX_o <= '0';		
			s_second_pkt <= '0';										-- Will send the first packet on initialization
		else
			CLRPACA_o <= '0';
			CLRPACB_o <= '0';
		
			case current_s is
			
				when st_IDLE_1 =>										-- First state remains idle and outputs 0 
					EJ_TX_o <= '0';									-- Outputs 0
					s_send_times <= 35;								-- Number of serial bits to send
					
					if ((s_rx_checksum = '1') and (s_second_pkt = '1')) then									-- Tests if the checksum bit is 1 and which packet it is
						EJARXDATA_o(conv_integer(s_rx_data(34 downto 32))) <= s_rx_data(31 downto 0);	-- Set the ejector data output
					end if;
					
					if ((s_rx_checksum = '1') and (s_second_pkt = '0')) then									-- Tests if the checksum bit is 1 and which packet it is
						EJBRXDATA_o(conv_integer(s_rx_data(34 downto 32))) <= s_rx_data(31 downto 0);	-- Set the ejector data output
					end if;
				
					if (s_second_pkt = '1') then					-- Tests if it is the second serial packet

						if DO_TESTEJETB_i = '1' then 				-- Checks if there is testejet request
							s_tx_data_int <= "001" & TEJET_i;	-- Set the packet with the testejet data
						elsif ISPACB_i='1' then						-- Or if it is a serial packet with data to the ejector
							s_tx_data_int <= EJ_PKT_i;				-- Set with the input serial data
							CLRPACB_o <= '1';							-- Clear the serial data request
						else												-- If not any of the upper options
							s_tx_data_int <= "001" & EJBTXDATA_i; 	-- Send sorting normal data
						end if; 

						current_s <= st_IDLE_2;						-- Go to next idle state in case this was the second packet
						
					else
						
						if DO_TESTEJETA_i = '1' then 				-- Checks if there is testejet request
							s_tx_data_int <= "001" & TEJET_i;	-- Set the packet with the testejet data
						elsif ISPACA_i='1' then						-- Or if it is a serial packet with data to the ejector
							s_tx_data_int <= EJ_PKT_i;				-- Set with the input serial data
							CLRPACA_o <= '1';							-- Clear the serial data request
						else												-- If not any of the upper options
							s_tx_data_int <= "001" & EJATXDATA_i; 	-- Send sorting normal data
						end if; 
						
						current_s <= st_INIT_1;						-- Go to init state
							
					end if;
				
				when st_IDLE_2 =>										-- In this state simply outputs 0 as an idle state
					EJ_TX_o <= '0';
					--s_rx_data(36) <= EJ_RX_i;						-- Receives first bit from serial data B side
					s_tx_data <= s_tx_checksum & s_tx_data_int; -- Arrange the transmit buffer
					
					current_s <= st_DATA;							-- Go to "data send" state
				
				when st_INIT_1 => 									-- In this state send the init packet signal 
					EJ_TX_o <= '1';
					
					current_s <= st_INIT_2;							-- Go to "data send" state
					
				when st_INIT_2 => 									-- In this state send the init packet signal 
					EJ_TX_o <= '1';
					--s_rx_data(36) <= EJ_RX_i;						-- Receives first bit from serial data A side
					s_tx_data <= s_tx_checksum & s_tx_data_int; -- Arrange the transmit buffer
					
					current_s <= st_DATA;							-- Go to "data send" state
					
				when st_DATA =>										-- In this state send serial data
				
					EJ_TX_o <= s_tx_data(s_send_times);			-- Sends out the current serial bit
					
					s_rx_data(s_send_times) <= EJ_RX_i;			-- Receives bits from serial data
					
					if s_send_times = 0 then						-- If all 35 bits were sent
						s_second_pkt <= not(s_second_pkt);		-- Invert the second packet flag
						current_s <= st_IDLE_1;						-- Go to "data send" state
					else													-- Otherwise
						s_send_times <= s_send_times - 1;		-- Continue sending serial data
					end if;
						
			end case;
			
		end if;
	end if;
end process;

end Behavioral;