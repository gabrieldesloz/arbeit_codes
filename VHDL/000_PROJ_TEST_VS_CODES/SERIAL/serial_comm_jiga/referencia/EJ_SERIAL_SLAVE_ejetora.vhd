----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:	   14:26:47 03/24/2014 
-- Design Name: 
-- Module Name:	   EJ_SERIAL_SLAVE - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
  library UNISIM;
use UNISIM.VComponents.all;

entity EJ_SERIAL_SLAVE is
  port(DATA_RX_i   : in std_logic;
       SEND_DATA_i : in input_array;

       SYNC_CLK_i : in std_logic;
       RST_i	  : in std_logic;

       RECEIVED_DATA_o : out input_array;
       DATA_TX_o       : out std_logic
       );
end EJ_SERIAL_SLAVE;

architecture Behavioral of EJ_SERIAL_SLAVE is

  signal cx, rx, tx, reset	      : std_logic;
  signal cxc			      : std_logic;
  signal serst, serend		      : std_logic;
  signal command		      : std_logic_vector(2 downto 0);
  signal sys_status		      : std_logic_vector(34 downto 0);
  signal txs, rxs		      : std_logic_vector(35 downto 0);
  signal s_received_data, s_send_data : input_array;
  signal vdata			      : std_logic_vector(31 downto 0);
  signal rxpar			      : std_logic;

begin

  -- Associate input and output 
  RECEIVED_DATA_o(0) <= s_received_data(0);
  RECEIVED_DATA_o(1) <= s_received_data(1);
  RECEIVED_DATA_o(2) <= s_received_data(2);
  RECEIVED_DATA_o(3) <= s_received_data(3);
  RECEIVED_DATA_o(4) <= s_received_data(4);
  RECEIVED_DATA_o(5) <= s_received_data(5);
  RECEIVED_DATA_o(6) <= s_received_data(6);
  RECEIVED_DATA_o(7) <= s_received_data(7);

  s_send_data(0) <= SEND_DATA_i(0);
  s_send_data(1) <= SEND_DATA_i(1);
  s_send_data(2) <= SEND_DATA_i(2);
  s_send_data(3) <= SEND_DATA_i(3);
  s_send_data(4) <= SEND_DATA_i(4);
  s_send_data(5) <= SEND_DATA_i(5);
  s_send_data(6) <= SEND_DATA_i(6);
  s_send_data(7) <= SEND_DATA_i(7);

  -- Adequate signals to use the same state machine
  cx	<= SYNC_CLK_i;
  rx	<= DATA_RX_i;
  reset <= RST_i;

  DATA_TX_o <= tx;
  -------------------------------------------------

  BUFG_1sc : BUFG
    port map (O => cxc, I => cx);	-- local clock

  -- package detection	
  process (cx, rx, reset, serend,sys_status)
  begin
    if (reset = '1') or (serend = '1') then
      
      serst <= '0';
      
    elsif rising_edge(rx) and cx = '1' then
      
      serst <= '1';
      -- set the parity bit here
      txs <= not (sys_status(34) xor sys_status(33) xor sys_status(32) xor sys_status(31) xor sys_status(30) xor sys_status(29) xor sys_status(28) xor sys_status(27) xor sys_status(26) xor
		  sys_status(25) xor sys_status(24) xor sys_status(23) xor sys_status(22) xor sys_status(21) xor sys_status(20) xor sys_status(19) xor sys_status(18) xor sys_status(17) xor
		  sys_status(16) xor sys_status(15) xor sys_status(14) xor sys_status(13) xor sys_status(12) xor sys_status(11) xor sys_status(10) xor sys_status(9) xor sys_status(8) xor
		  sys_status(7) xor sys_status(6) xor sys_status(5) xor sys_status(4) xor sys_status(3) xor sys_status(2) xor sys_status(1) xor sys_status(0)) 
	     & sys_status;
      
    end if;
  end process;

  rxpar <= rxs(35) xor rxs(34) xor rxs(33) xor rxs(32) xor rxs(31) xor rxs(30) xor rxs(29) xor rxs(28) xor rxs(27) xor rxs(26) xor
	   rxs(25) xor rxs(24) xor rxs(23) xor rxs(22) xor rxs(21) xor rxs(20) xor rxs(19) xor rxs(18) xor rxs(17) xor rxs(16) xor
	   rxs(15) xor rxs(14) xor rxs(13) xor rxs(12) xor rxs(11) xor rxs(10) xor rxs(9) xor rxs(8) xor rxs(7) xor rxs(6) xor
	   rxs(5) xor rxs(4) xor rxs(3) xor rxs(2) xor rxs(1) xor rxs(0);

-- receiving machine
  process (cxc, serst, reset, rxpar, rxs)
    variable nrx : integer range 0 to 63;
  begin
    if (reset = '1') or (serst = '0') then
      
      nrx    := 0;
      serend <= '0';

      if rxpar = '1' then

	vdata	<= rxs(31 downto 0);
	command <= rxs(34 downto 32);	-- 3 bit command
	
      else

	command <= "000";		-- null command
	
      end if;
      
    elsif rising_edge(cxc) then
      
      if nrx = 36 then
	
	serend <= '1';
	
      else
	
	rxs <= rxs(34 downto 0) & rx;
	
      end if;

      nrx := nrx+1;
      
    end if;
  end process;

-- transmiting machine
  process (cxc, serst, reset)
    variable ti : integer range 0 to 63;
  begin
    
    if (reset = '1') or (serst = '0') then
      
      ti := 35;
      
    elsif falling_edge(cxc) then
      
      tx <= txs(ti);
	  if ti = 0 then 
		ti := 35;
	  else
		ti := ti-1;
      end if;
	  
    end if;
  end process;

-----------------------------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------------------------	
-- data validation
  process (serst, cxc, reset, s_send_data, command, vdata)  -- clock must be a little faster than SCLK

    variable sc : integer range 0 to 7;
    
  begin
    
    if (reset = '1') then
      
      sc := 0;

    elsif falling_edge(cxc) and serst = '0' then

	  -- simulation contruct (if else), because modelsim doesnt 
	  -- rotate the values
	  if sc = 7 then 
		sc := 0;
	  else
		sc := sc+1;
	  end if;
	  
      case sc is
	
	when 0	    => sys_status <= "000" & s_send_data(0);
	when 1	    => sys_status <= "001" & s_send_data(1);
	when 2	    => sys_status <= "010" & s_send_data(2);
	when 3	    => sys_status <= "011" & s_send_data(3);
	when 4	    => sys_status <= "100" & s_send_data(4);
	when 5	    => sys_status <= "101" & s_send_data(5);
	when 6	    => sys_status <= "110" & s_send_data(6);
	when 7	    => sys_status <= "111" & s_send_data(7);
	when others =>
	  
      end case;

      case command is

	when "000" => s_received_data(0) <= vdata;
	when "001" => s_received_data(1) <= vdata;
	when "010" => s_received_data(2) <= vdata;
	when "011" => s_received_data(3) <= vdata;
	when "100" => s_received_data(4) <= vdata;
	when "101" => s_received_data(5) <= vdata;
	when "110" => s_received_data(6) <= vdata;
	when "111" => s_received_data(7) <= vdata;

	when others =>
	  
      end case;

    end if;
  end process;

end Behavioral;
