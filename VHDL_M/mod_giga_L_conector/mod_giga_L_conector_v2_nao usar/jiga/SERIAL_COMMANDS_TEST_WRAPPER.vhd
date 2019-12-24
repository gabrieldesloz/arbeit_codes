----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:55:32 07/22/2014 
-- Design Name: 
-- Module Name:    SERIAL_COMMANDS_TEST_WRAPPER - Behavioral 
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

entity SERIAL_COMMANDS_TEST_WRAPPER is
    Port ( 	CLK_60MHz_i : in STD_LOGIC;
				CLK_EN_1MHz_i : in STD_LOGIC;
				RESET_i : in STD_LOGIC;
				
				uC_REQUEST_i : in STD_LOGIC;
				uC_FPGA_SELECT_i : in STD_LOGIC;
				uC_COMMAND_i : in STD_LOGIC_VECTOR(7 downto 0);
				uC_DATA_i : in STD_LOGIC_VECTOR(31 downto 0);
				DATA_TO_uC_RECEIVED_i : in STD_LOGIC;

				DATA_TO_uC_READY_o : out STD_LOGIC
);
end SERIAL_COMMANDS_TEST_WRAPPER;

architecture Behavioral of SERIAL_COMMANDS_TEST_WRAPPER is
----------------------------------------------------------------------------------
component SERIAL_SLAVE_FPGA2_3
    Port ( 	RX_FPGA2_i : in STD_LOGIC;
				RX_FPGA3_i : in STD_LOGIC;

				CLK_60MHz_i : in STD_LOGIC;
				CLK_EN_1MHz_i : in STD_LOGIC;
				RESET_i : in STD_LOGIC;

				TX_FPGA2_i : out STD_LOGIC;
				TX_FPGA3_i : out STD_LOGIC
);
end component;
----------------------------------------------------------------------------------
component SERIAL_MASTER
    Port ( RX_FPGA2_i : in  STD_LOGIC;
			  RX_FPGA3_i : in  STD_LOGIC;
			  
			  uC_REQUEST_i : in STD_LOGIC;
			  uC_FPGA_SELECT_i : in STD_LOGIC;
			  uC_COMMAND_i : in STD_LOGIC_VECTOR(7 downto 0);
			  uC_DATA_i : in STD_LOGIC_VECTOR(31 downto 0);
			  DATA_TO_uC_RECEIVED_i : in STD_LOGIC;
			  
			  DATA_TO_uC_READY_o : out STD_LOGIC;
			  
			  CLK_60MHz_i : in  STD_LOGIC;
			  CLK_EN_1MHz_i : in  STD_LOGIC;
			  
			  RESET_i : in  STD_LOGIC;
			  
			  TX_FPGA2_o : out  STD_LOGIC;
			  TX_FPGA3_o : out  STD_LOGIC);
end component;
----------------------------------------------------------------------------------
signal s_tx_FPGA1_2, s_tx_FPGA1_3 : std_logic;
signal s_rx_FPGA1_2, s_rx_FPGA1_3 : std_logic;
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
i_SERIAL_SLAVE_FPGA2_3 : SERIAL_SLAVE_FPGA2_3
    Port map( 	
				RX_FPGA2_i => s_tx_FPGA1_2,
				RX_FPGA3_i => s_tx_FPGA1_3,

				CLK_60MHz_i => CLK_60MHz_i,
				CLK_EN_1MHz_i => CLK_EN_1MHz_i,
				RESET_i => RESET_i,

				TX_FPGA2_i => s_rx_FPGA1_2,
				TX_FPGA3_i => s_rx_FPGA1_3
);
----------------------------------------------------------------------------------
i_SERIAL_MASTER : SERIAL_MASTER
    Port map( 
				RX_FPGA2_i => s_rx_FPGA1_2,
				RX_FPGA3_i => s_rx_FPGA1_3,

				uC_REQUEST_i => uC_REQUEST_i,
				uC_FPGA_SELECT_i => uC_FPGA_SELECT_i,
				uC_COMMAND_i => uC_COMMAND_i,
				uC_DATA_i => uC_DATA_i,
				DATA_TO_uC_RECEIVED_i => DATA_TO_uC_RECEIVED_i,

				DATA_TO_uC_READY_o => DATA_TO_uC_READY_o,

				CLK_60MHz_i => CLK_60MHz_i,
				CLK_EN_1MHz_i => CLK_EN_1MHz_i,

				RESET_i => RESET_i,

				TX_FPGA2_o => s_tx_FPGA1_2,
				TX_FPGA3_o => s_tx_FPGA1_3
);
----------------------------------------------------------------------------------
end Behavioral;