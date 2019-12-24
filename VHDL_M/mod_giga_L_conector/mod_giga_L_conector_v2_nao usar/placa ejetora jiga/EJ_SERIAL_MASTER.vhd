----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:	   14:38:37 03/24/2014 
-- Design Name: 
-- Module Name:	   EJ_SERIAL_MASTER - Behavioral 
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

package my_types_pkg is	 -- Creates a type to use arrays in the entity declaration
  type input_array is array (7 downto 0) of std_logic_vector (31 downto 0);  -- The array type
end package; 
  
  library IEEE; 
	       use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library work;
use work.my_types_pkg.all;


entity EJ_SERIAL_MASTER is
  port(DATA_RX_i   : in std_logic;
       SEND_DATA_i : in input_array;

       CLK_i : in std_logic;
       RST_i : in std_logic;

       RECEIVED_DATA_o : out input_array;
       DATA_TX_o       : out std_logic;
       SYNC_CLK_o      : out std_logic
       );
end EJ_SERIAL_MASTER;

architecture Behavioral of EJ_SERIAL_MASTER is

  signal clkz, reset, eja_ck, eja_tx, eja_rx															: std_logic;
  signal rxpara																			: std_logic;
  signal s_packet																		: std_logic_vector(2 downto 0);
  signal s_received_data_0, s_received_data_1, s_received_data_2, s_received_data_3, s_received_data_4, s_received_data_5, s_received_data_6, s_received_data_7 : std_logic_vector(31 downto 0);
  signal s_send_data_0, s_send_data_1, s_send_data_2, s_send_data_3, s_send_data_4, s_send_data_5, s_send_data_6, s_send_data_7					: std_logic_vector(31 downto 0);
  signal ejapkt																			: std_logic_vector(34 downto 0);
  signal rxsa, txsa																		: std_logic_vector(35 downto 0);

begin

  -- Associate input and output 
  RECEIVED_DATA_o(0) <= s_received_data_0;
  RECEIVED_DATA_o(1) <= s_received_data_1;
  RECEIVED_DATA_o(2) <= s_received_data_2;
  RECEIVED_DATA_o(3) <= s_received_data_3;
  RECEIVED_DATA_o(4) <= s_received_data_4;
  RECEIVED_DATA_o(5) <= s_received_data_5;
  RECEIVED_DATA_o(6) <= s_received_data_6;
  RECEIVED_DATA_o(7) <= s_received_data_7;

  s_send_data_0 <= SEND_DATA_i(0);
  s_send_data_1 <= SEND_DATA_i(1);
  s_send_data_2 <= SEND_DATA_i(2);
  s_send_data_3 <= SEND_DATA_i(3);
  s_send_data_4 <= SEND_DATA_i(4);
  s_send_data_5 <= SEND_DATA_i(5);
  s_send_data_6 <= SEND_DATA_i(6);
  s_send_data_7 <= SEND_DATA_i(7);

  -- Adequate signals to use the same state machine
  eja_rx <= DATA_RX_i;
  clkz	 <= CLK_i;
  reset	 <= RST_i;

  DATA_TX_o  <= eja_tx;
  SYNC_CLK_o <= eja_ck;

					------------------------------------------------------------------------------------------------------
					-- Serial communication with Ejector Module

					-- serializer 
  process (clkz, reset)			-- 18.75MHz
    variable bc	 : integer range 0 to 63;
    variable ejs : integer range 0 to 15;
  begin
    if reset = '1' then
      
      ejs      := 0;
      s_packet <= "000";
      
    elsif falling_edge(clkz) then
      
      case ejs is
	
	when 0 => ejs := 1; eja_ck <= '0'; eja_tx <= '0'; bc := 0;

	when 1 => ejs := 2; eja_ck <= '0'; eja_tx <= '0';  -- idle

	when 2 => ejs := 3; eja_ck <= '1'; eja_tx <= '0';
		  
		  case s_packet is
		    
		    when "000"	=> ejapkt   <= s_packet & s_send_data_0;
		    when "001"	=> ejapkt   <= s_packet & s_send_data_1;
		    when "010"	=> ejapkt   <= s_packet & s_send_data_2;
		    when "011"	=> ejapkt   <= s_packet & s_send_data_3;
		    when "100"	=> ejapkt   <= s_packet & s_send_data_4;
		    when "101"	=> ejapkt   <= s_packet & s_send_data_5;
		    when "110"	=> ejapkt   <= s_packet & s_send_data_6;
		    when "111"	=> ejapkt   <= s_packet & s_send_data_7;
		    when others => s_packet <= "000";
				   
		  end case;
		  
	when 3 => ejs := 4; eja_ck <= '1'; eja_tx <= '1';  -- start
		  
		  txsa <= not
			  (ejapkt(34) xor ejapkt(33) xor ejapkt(32) xor ejapkt(31) xor ejapkt(30) xor ejapkt(29) xor ejapkt(28) xor ejapkt(27) xor ejapkt(26) xor
			   ejapkt(25) xor ejapkt(24) xor ejapkt(23) xor ejapkt(22) xor ejapkt(21) xor ejapkt(20) xor ejapkt(19) xor ejapkt(18) xor ejapkt(17) xor
			   ejapkt(16) xor ejapkt(15) xor ejapkt(14) xor ejapkt(13) xor ejapkt(12) xor ejapkt(11) xor ejapkt(10) xor ejapkt(9) xor ejapkt(8) xor
			   ejapkt(7) xor ejapkt(6) xor ejapkt(5) xor ejapkt(4) xor ejapkt(3) xor ejapkt(2) xor ejapkt(1) xor ejapkt(0)) 
			  & ejapkt;

	when 4 => ejs := 5; eja_ck <= '0'; eja_tx <= '0';

	when 5 => ejs := 6;
		  eja_ck <= '0';	-- tx/rx
		  eja_tx <= txsa(35);

	when 6 => ejs := 7;
		  eja_ck <= '1';	-- tx/rx
		  eja_tx <= txsa(35);

		  rxsa <= rxsa(34 downto 0) & eja_rx;

	when 7 => ejs := 8;
		  eja_ck <= '1';	-- tx/rx
		  eja_tx <= txsa(35);

		  txsa <= txsa(34 downto 0) & '0';
		  
	when 8 => ejs := 5;
		  eja_ck <= '0';	-- tx/rx
		  eja_tx <= txsa(35);
		  bc	 := bc+1;

		  if bc >= 36 then ejs := 9; end if;

		  rxpara <= rxsa(35) xor rxsa(34) xor rxsa(33) xor rxsa(32) xor rxsa(31) xor rxsa(30) xor rxsa(29) xor rxsa(28) xor rxsa(27) xor rxsa(26) xor
			    rxsa(25) xor rxsa(24) xor rxsa(23) xor rxsa(22) xor rxsa(21) xor rxsa(20) xor rxsa(19) xor rxsa(18) xor rxsa(17) xor rxsa(16) xor
			    rxsa(15) xor rxsa(14) xor rxsa(13) xor rxsa(12) xor rxsa(11) xor rxsa(10) xor rxsa(9) xor rxsa(8) xor rxsa(7) xor rxsa(6) xor
			    rxsa(5) xor rxsa(4) xor rxsa(3) xor rxsa(2) xor rxsa(1) xor rxsa(0);

	when 9 => ejs := 10;
		  eja_ck <= '0';	-- idle
		  eja_tx <= '0';

		  if (rxpara = '1') then
		    case (rxsa(34 downto 32)) is
		      
		      when "000"  => s_received_data_0 <= rxsa(31 downto 0);
		      when "001"  => s_received_data_1 <= rxsa(31 downto 0);
		      when "010"  => s_received_data_2 <= rxsa(31 downto 0);
		      when "011"  => s_received_data_3 <= rxsa(31 downto 0);
		      when "100"  => s_received_data_4 <= rxsa(31 downto 0);
		      when "101"  => s_received_data_5 <= rxsa(31 downto 0);
		      when "110"  => s_received_data_6 <= rxsa(31 downto 0);
		      when "111"  => s_received_data_7 <= rxsa(31 downto 0);
		      when others =>
			
		    end case;
		  end if;
		  
	when 10 => ejs := 11;
		   eja_ck <= '1';	-- idle
		   eja_tx <= '0';

	when 11 => ejs := 0;
		   eja_ck <= '1';	-- idle
		   eja_tx <= '0';
		   
		   
	when others =>
      end case;
    end if;
  end process;

end Behavioral;

