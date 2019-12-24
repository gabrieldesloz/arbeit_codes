----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:33:12 06/25/2012 
-- Design Name: 
-- Module Name:    WRAPPER_VALVE_FAIL - Behavioral 
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

entity WRAPPER_VALVE_FAIL is
    Port ( VALVE_i : in  STD_LOGIC_VECTOR (31 downto 0);
			  VALVE_LIMITER_i : in  STD_LOGIC_VECTOR (31 downto 0);
           SENS_i : in  STD_LOGIC_VECTOR (31 downto 0);
           C10MHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  PROBE_o : out STD_LOGIC_VECTOR(2 downto 0);
           FUSE_o : out  STD_LOGIC_VECTOR (31 downto 0));
end WRAPPER_VALVE_FAIL;

architecture Behavioral of WRAPPER_VALVE_FAIL is
-------------------------------------------------
------- Wire Connection Between Modules ---------
-------------------------------------------------
signal s_has_activation_pulse_i, s_has_activation_pulse_o : std_logic;
signal s_has_sens_i, s_has_sens_o : std_logic;
signal s_feedback_count_i, s_feedback_count_o : std_logic_vector(14 downto 0);
signal s_activation_count_i, s_activation_count_o : std_logic_vector(12 downto 0);
signal s_current_valve_i : std_logic_vector(4 downto 0);
signal s_debounce_i, s_debounce_o : std_logic_vector(1 downto 0);

-------------------------------------------------
-------------- Valve Fail Handler ---------------
-------------------------------------------------
component VALVE_FAIL is
    Port ( VALVE_i : in  STD_LOGIC_VECTOR(31 downto 0);					-- Valve state (1 is active)
           SENS_i : in  STD_LOGIC_VECTOR(31 downto 0);					-- Sens state (goes 0 with the electromotive effect just after the valve is disabled)
			  VALVE_LIMITER_i : in  STD_LOGIC_VECTOR (31 downto 0);		-- Valve limiter information to clean the has activation flag in case on bit is active
			  ACTIVATION_COUNT_i : in STD_LOGIC_VECTOR(12 downto 0);		-- Activation time counter input
			  FEEDBACK_COUNT_i : in STD_LOGIC_VECTOR(14 downto 0);		-- Feedback counter input
			  CURRENT_VALVE_i : in STD_LOGIC_VECTOR(4 downto 0);			-- Current valve being analyzed
			  DEBOUNCE_i : in STD_LOGIC_VECTOR(1 downto 0);					-- Debounce input count to avoid fake alarms
			  HAS_ACTIVATION_PULSE_i : in STD_LOGIC;							-- If there was a 500us valve activation pulse
			  HAS_SENS_i : in STD_LOGIC;											-- If there was an electromotive effect
           C10MHZ_i : in  STD_LOGIC;											-- 6.25 MHz clock 
           RST_i : in  STD_LOGIC;									
			  
			  DEBOUNCE_o : out STD_LOGIC_VECTOR(1 downto 0);					-- Debounce output count to avoid fake alarms
			  PROBE_o : out STD_LOGIC_VECTOR(2 downto 0);
			  ACTIVATION_COUNT_o : out STD_LOGIC_VECTOR(12 downto 0);	-- Activation time counter output
			  FEEDBACK_COUNT_o : out STD_LOGIC_VECTOR(14 downto 0);		-- Feedback counter output
			  HAS_SENS_o : out STD_LOGIC;											-- If there was an electromotive effect
			  HAS_ACTIVATION_PULSE_o : out STD_LOGIC;							-- If there was a 500us valve activation pulse
           FUSE_o : out  STD_LOGIC_VECTOR(31 downto 0));					-- "Fuse" state
end component;
-------------------------------------------------
--------- Valve Fail Memory Controller ----------
-------------------------------------------------
component FAIL_MEM_CONTROL is
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
end component;
-------------------------------------------------
begin

-------------------------------------------------
-------------- Valve Fail Handler ---------------
-------------------------------------------------			  
	i_VALVE_FAIL : VALVE_FAIL 
		 Port map( VALVE_i => VALVE_i,
					  VALVE_LIMITER_i => VALVE_LIMITER_i,
					  SENS_i => SENS_i,
					  ACTIVATION_COUNT_i => s_activation_count_i,
					  FEEDBACK_COUNT_i => s_feedback_count_i,
					  HAS_ACTIVATION_PULSE_i => s_has_activation_pulse_i,
					  DEBOUNCE_i => s_debounce_i,
					  HAS_SENS_i => s_has_sens_i,
					  CURRENT_VALVE_i => s_current_valve_i,
					  C10MHZ_i => C10MHZ_i,
					  RST_i => RST_i,
					  
					  PROBE_o => PROBE_o,
					  DEBOUNCE_o => s_debounce_o,
					  ACTIVATION_COUNT_o => s_activation_count_o,
					  FEEDBACK_COUNT_o => s_feedback_count_o,
					  HAS_ACTIVATION_PULSE_o => s_has_activation_pulse_o,
					  HAS_SENS_o => s_has_sens_o,
					  FUSE_o => FUSE_o
				  );					
				  
-------------------------------------------------
--------- Valve Fail Memory Controller ----------
-------------------------------------------------
	i_FAIL_MEM_CONTROL : FAIL_MEM_CONTROL
		 Port map( ACTIVATION_COUNT_i => s_activation_count_o,
					  FEEDBACK_COUNT_i => s_feedback_count_o,
					  HAS_ACTIVATION_PULSE_i => s_has_activation_pulse_o,
					  HAS_SENS_i => s_has_sens_o,
					  DEBOUNCE_i => s_debounce_o,
					  C10MHZ_i => C10MHZ_i,
					  RST_i => RST_i,
					  
					  DEBOUNCE_o => s_debounce_i,
					  ACTIVATION_COUNT_o => s_activation_count_i,
					  FEEDBACK_COUNT_o => s_feedback_count_i,
					  HAS_ACTIVATION_PULSE_o => s_has_activation_pulse_i,
					  HAS_SENS_o => s_has_sens_i,
					  CURRENT_VALVE_o => s_current_valve_i
				  );

end Behavioral;
