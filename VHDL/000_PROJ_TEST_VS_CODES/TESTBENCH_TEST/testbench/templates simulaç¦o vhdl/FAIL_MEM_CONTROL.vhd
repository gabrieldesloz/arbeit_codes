----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:57 06/25/2012 
-- Design Name: 
-- Module Name:    FAIL_MEM_CONTROL - Behavioral 
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

entity FAIL_MEM_CONTROL is
    Port ( ACTIVATION_COUNT_i : in STD_LOGIC_VECTOR(12 downto 0);		-- Activation time counter input
			  FEEDBACK_COUNT_i : in STD_LOGIC_VECTOR(14 downto 0);		-- Feedback counter input
			  DEBOUNCE_i : in STD_LOGIC_VECTOR(1 downto 0);					-- Debounce input count to avoid fake alarms
			  HAS_ACTIVATION_PULSE_i : in STD_LOGIC;							-- If there was a 500us valve activation pulse
			  HAS_SENS_i : in STD_LOGIC; 
           C10MHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  HAS_SENS_o : out STD_LOGIC;
			  HAS_ACTIVATION_PULSE_o : out STD_LOGIC;							-- If there was a 500us valve activation pulse
			  DEBOUNCE_o : out STD_LOGIC_VECTOR(1 downto 0);				-- Debounce output count to avoid fake alarms
			  CURRENT_VALVE_o : out  std_logic_vector (4 downto 0);		-- The current valve being read by the memory controller
			  ACTIVATION_COUNT_o : out STD_LOGIC_VECTOR(12 downto 0);	-- Activation time counter output
			  FEEDBACK_COUNT_o : out STD_LOGIC_VECTOR(14 downto 0));		-- Feedback counter output
end FAIL_MEM_CONTROL;

architecture Behavioral of FAIL_MEM_CONTROL is
signal s_mem_in, s_mem_out : std_logic_vector(31 downto 0);
signal s_valve, s_last_valve : std_logic_vector(4 downto 0);

-------------------------------------------------
------------ MEM_32x32 Counter Memory -----------
-------------------------------------------------
COMPONENT MEM_32x32
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-------------------------------------------------

begin

	CURRENT_VALVE_o <= s_valve;	-- Output receives memory address to address 64 bit valve vector (valverx)

	process(RST_i, C10MHZ_i)
	begin
		if rising_edge(C10MHZ_i) then				-- 1 MHz clock input rising edge
			if (RST_i = '1') then					-- If there is a reset signal
				s_valve <= (others => '0');		-- Reset memory address and valve index
				s_last_valve <= (others => '0');	-- Reset memory address and valve index
			else											-- If there is no reset
				s_valve <= s_valve + 1;				-- Increment memory address and valve index
				s_last_valve <= s_valve;			-- Write address is the last 
			end if;
		end if;
	end process;

-------------------------------------------------
-------------- 32x32 Counter Memory -------------
-------------------------------------------------
	s_mem_in <= HAS_SENS_i & FEEDBACK_COUNT_i & HAS_ACTIVATION_PULSE_i & DEBOUNCE_i & ACTIVATION_COUNT_i;
	
	HAS_SENS_o <= s_mem_out(31);
	FEEDBACK_COUNT_o <= s_mem_out(30 downto 16);
	HAS_ACTIVATION_PULSE_o <= s_mem_out(15);
	DEBOUNCE_o <= s_mem_out(14 downto 13);
	ACTIVATION_COUNT_o <= s_mem_out(12 downto 0);

	FAIL_MEM_32x32 : MEM_32x32
	  PORT MAP (	
		 clka => C10MHZ_i,							-- 1 MHz clock input
		 wea => "1",									-- Always enabled
		 addra => s_last_valve,						-- Write memory address using last valve index (to read the right address)
		 dina => s_mem_in,							-- Input is MAX_FLAG and the counter from COUNT_CHOPPER module
		 clkb => C10MHZ_i,							-- 1 MHz clock input
		 addrb => s_valve,							-- Read memory address using valve index
		 doutb => s_mem_out							-- Counter memory output
	  );
-------------------------------------------------

end Behavioral;