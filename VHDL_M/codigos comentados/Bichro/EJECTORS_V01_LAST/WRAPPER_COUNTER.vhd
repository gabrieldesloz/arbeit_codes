----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: Carlos E. Bertagnolli
-- 
-- Create Date:    08:11:38 06/14/2012 
-- Design Name: 	 Ejectors limiter counter
-- Module Name:    COUNT_PROTECTION - Behavioral 
-- Project Name: 	 EJECTORS_VXX
-- Target Devices: SPARTAN 3 XC3S200
-- Tool versions:  ISE 14.1
-- Description: 	 This module is responsible for wrapping together the memory controller 
--						 of the chopper counter and the chopper module that decodes the information
--						 coming from the memory module
--
-- Dependencies:   MAIN_VHDL.vhd
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--						 For information on how to calculate the input values (MAX_COUNT_i,
--						 MIN_COUNT_i, INC_VALUE_i, DEC_VALUE_i) please refer to the specification
--						 "Ejectors ejection limiter"
--						 The INC_VAL_i is calculated by taking the following:
--						 INC_VAL_i = n . DEC_VAL_i
--						 Where 'n' is the reason between the "heating" and "cooling" 
--						 i.e. The heating time is 5 seconds and the colling is 10, then
--						 the n value will be 2.
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

entity WRAPPER_COUNTER is
    Port ( VALVE_STATE_i : in  STD_LOGIC_VECTOR (31 downto 0);		-- 32 Valve state input
           C1MHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  PROTOTYPE_o : out STD_LOGIC_VECTOR(7 downto 0);
           VALVE_STATE_o : out  STD_LOGIC_VECTOR (31 downto 0));	-- 32 chopper output (If one of the choppers is 1 then should cool down the valve)
end WRAPPER_COUNTER;

architecture Behavioral of WRAPPER_COUNTER is
-------------------------------------------------
------- Wire Connection Between Modules ---------
-------------------------------------------------
signal s_max_flag_i, s_max_flag_o  : std_logic;
signal s_current_valve_i : std_logic_vector(4 downto 0);
signal s_count_i, s_count_o : std_logic_vector(19 downto 0);

-------------------------------------------------
------------- Counter Valve Handler -------------
-------------------------------------------------
component COUNT_CHOPPER is
    Port ( 
			  VALVE_STATE_i : in STD_LOGIC_VECTOR (31 downto 0);		-- 32 Valve state input
			  COUNT_i : in  STD_LOGIC_VECTOR (19 downto 0);				-- Memory output counter
           CURRENT_VALVE_i : in  STD_LOGIC_VECTOR (4 downto 0);	-- The current valve being read by the memory controller
			  MAX_FLAG_i : in  STD_LOGIC;										-- Flag that shows the counter reached maximum value (MAX_COUNT)
           C1MHZ_i : in  STD_LOGIC;											
           RST_i : in  STD_LOGIC;											
			  
			  MAX_FLAG_o : out  STD_LOGIC;									-- Flag that shows the counter reached maximum value (MAX_COUNT)
			  PROTOTYPE_o : out STD_LOGIC_VECTOR(7 downto 0);
           COUNT_o : out  STD_LOGIC_VECTOR (19 downto 0);			-- Memory input counter
			  VALVE_STATE_o : out STD_LOGIC_VECTOR (31 downto 0));	-- 32 chopper output (If one of the choppers is 1 then should cool down the valve)
end component;

-------------------------------------------------
----------- Counter Memory Controller -----------
-------------------------------------------------
component COUNT_MEM_CONTROL is
    Port ( COUNT_i : in  STD_LOGIC_VECTOR (19 downto 0);				-- Memory output counter
			  MAX_FLAG_i : in  STD_LOGIC;										-- Flag that shows the counter reached maximum value (MAX_COUNT)
           C1MHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  MAX_FLAG_o : out  STD_LOGIC;									-- Flag that shows the counter reached maximum value (MAX_COUNT)
			  CURRENT_VALVE_o : out  std_logic_vector (4 downto 0);	-- The current valve being read by the memory controller
           COUNT_o : out  STD_LOGIC_VECTOR (19 downto 0));			-- Memory output counter
end component;
-------------------------------------------------

begin

	i_COUNT_CHOPPER : COUNT_CHOPPER
   Port map( 
			  VALVE_STATE_i => VALVE_STATE_i,
			  COUNT_i => s_count_i,
           CURRENT_VALVE_i => s_current_valve_i,
			  MAX_FLAG_i => s_max_flag_i,
           C1MHZ_i => C1MHZ_i,
           RST_i => RST_i,
			  
			  MAX_FLAG_o => s_max_flag_o,
           COUNT_o => s_count_o,
			  PROTOTYPE_o => PROTOTYPE_o,
			  VALVE_STATE_o => VALVE_STATE_o
			  );
			  
	i_COUNT_MEM_CONTROL : COUNT_MEM_CONTROL 
	Port map ( COUNT_i => s_count_o,
				  MAX_FLAG_i => s_max_flag_o,
				  C1MHZ_i => C1MHZ_i,
				  RST_i => RST_i,
				  
				  MAX_FLAG_o => s_max_flag_i,
				  CURRENT_VALVE_o => s_current_valve_i,
				  COUNT_o => s_count_i
				  );

end Behavioral;

