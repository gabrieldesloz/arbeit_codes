----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:	   14:29:24 03/17/2014 
-- Design Name: 
-- Module Name:	   SERIAL_COMMUNICATION - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
  library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.my_types_pkg.all;

entity SERIAL_COMMUNICATION is
  port (
    SEND_DATA_MASTER_i : in input_array;
    SEND_DATA_SLAVE_i  : in input_array;

    CLK_i : in std_logic;
    RST_i : in std_logic;


    RECEIVED_DATA_SLAVE_o  : out input_array;
    RECEIVED_DATA_MASTER_o : out input_array
    );
end SERIAL_COMMUNICATION;

architecture Behavioral of SERIAL_COMMUNICATION is
-----------------------------------------------
-------- Slave serial (EJECTOR SIDE) ----------
-----------------------------------------------
  component EJ_SERIAL_SLAVE is
    port(DATA_RX_i   : in std_logic;
	 SEND_DATA_i : in input_array;

	 SYNC_CLK_i : in std_logic;
	 RST_i	    : in std_logic;

	 RECEIVED_DATA_o : out input_array;
	 DATA_TX_o	 : out std_logic
	 );

  end component;
-----------------------------------------------
------ Master serial (FPGA BOARD SIDE) --------
-----------------------------------------------
  component EJ_SERIAL_MASTER is
    port(DATA_RX_i   : in std_logic;
	 SEND_DATA_i : in input_array;

	 CLK_i : in std_logic;
	 RST_i : in std_logic;

	 RECEIVED_DATA_o : out input_array;
	 DATA_TX_o	 : out std_logic;
	 SYNC_CLK_o	 : out std_logic
	 );
  end component;
-----------------------------------------------

  signal s_data_rx, s_data_tx, s_sync_clk : std_logic;
begin

-----------------------------------------------
-------- Slave serial (EJECTOR SIDE) ----------
-----------------------------------------------
  i_EJ_SERIAL_SLAVE : EJ_SERIAL_SLAVE
    port map(
      DATA_RX_i	  => s_data_tx,	 -- Data coming from Master block (TX from Master)
      SEND_DATA_i => SEND_DATA_SLAVE_i,

      SYNC_CLK_i => s_sync_clk,
      RST_i	 => RST_i,

      RECEIVED_DATA_o => RECEIVED_DATA_SLAVE_o,
      DATA_TX_o	      => s_data_rx  -- Data sent by Master block (RX from Master)
      );
-----------------------------------------------
------ Master serial (FPGA BOARD SIDE) --------
-----------------------------------------------
  i_EJ_SERIAL_MASTER : EJ_SERIAL_MASTER
    port map(
      DATA_RX_i	  => s_data_rx,
      SEND_DATA_i => SEND_DATA_MASTER_i,

      CLK_i => CLK_i,
      RST_i => RST_i,

      RECEIVED_DATA_o => RECEIVED_DATA_MASTER_o,
      DATA_TX_o	      => s_data_tx,
      SYNC_CLK_o      => s_sync_clk
      );
-----------------------------------------------

end Behavioral;
