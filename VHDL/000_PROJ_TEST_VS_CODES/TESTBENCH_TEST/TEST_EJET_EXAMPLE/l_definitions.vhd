library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



package l_definitions is

	--constant OVERUSAGE_MAX		: std_logic_vector(15 downto 0):= "0000011111010000"; -- 2000 ejections max -- mem_ctrl.vhd
	constant OVERUSAGE_MAX		: std_logic_vector(15 downto 0):= "0001001110001000"; -- 5000 ejections max -- mem_ctrl.vhd
	--constant c_ACIONA_EJ   		: STD_LOGIC_VECTOR(9 downto 0) := "0011111010";	-- 850us ejectors activation time - always change IHM when changing this constant -- see Calc_dwell.xlsx  -- CH_X_EJET_TIMER.vhd
	--constant c_ACIONA_EJ   		: STD_LOGIC_VECTOR(9 downto 0) := "0110111001";	-- 1.5ms ejectors activation time - always change IHM when changing this constant -- see Calc_dwell.xlsx  -- CH_X_EJET_TIMER.vhd
	--constant c_ACIONA_EJ   		: STD_LOGIC_VECTOR(9 downto 0) := "0100100110";	-- 1ms ejectors activation time - always change IHM when changing this constant -- see Calc_dwell.xlsx  -- CH_X_EJET_TIMER.vhd
	constant c_ACIONA_EJ   		: STD_LOGIC_VECTOR(9 downto 0) := "0001110101";	-- 400us ejectors activation time - always change IHM when changing this constant -- see Calc_dwell.xlsx  -- CH_X_EJET_TIMER.vhd
	constant DEFLUX_T   		: STD_LOGIC_VECTOR(9 downto 0) := "0011101010";	-- 800us DeFLUX Time
	constant MAX_ACTIVE_VALVES	: std_logic_vector(5 downto 0) := "001100"; -- 12 "simultaneously" active valves -- CH_X_EJET_TIMER.vhd

	-- constant TEJET_ACTIVE_TIME	: std_logic_vector(10 downto 0):= "01111101000"; -- 1000 - 1 ms
	constant TEJET_ACTIVE_TIME	: integer range 0 to 2047  := 2_000; -- 2 ms
	constant TEJET_PERIOD		: integer range 0 to 65535 := 10_000; -- 10 ms -- 100 Hz
	
	-- valve fail verification
    constant ACTIVATION_COUNT	: std_logic_vector(12 downto 0) :=	"0000011011100";  -- 220 x 3.2 us -> 704 us
	constant FEEDBACK_COUNT		: std_logic_vector(14 downto 0) :=  "000000000001000"; -- 8 x 3.2 us -> 26 us
	
end package;

	
	
	

