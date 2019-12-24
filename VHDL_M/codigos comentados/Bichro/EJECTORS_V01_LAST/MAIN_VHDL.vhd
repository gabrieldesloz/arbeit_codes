----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:42:04 11/24/2010 
-- Design Name: 
-- Module Name:    MAIN_VHDL - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 12.4
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.0 - on 5/sept/2011 : version information included in the data reported to machine
--  08.07.2013 0.22 - Manual testejet 3x slower and incremental testejet added
--  06.11.2013 0.01 - L+B 24 ejectors version - Ejectors activation exchanged
--															 - Manual testeject valves exchanged
--															 - Fuse sequence exchanged
--
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity MAIN_VHDL is
    Port ( 
           resetin : in  STD_LOGIC; -- reset when zero
           clk37 : in  STD_LOGIC; --37.5MHz input
			  initin : in  STD_LOGIC; -- DCM reset using INIT pin
           test : in  STD_LOGIC; -- button input: zero=pressed
           led : inout  STD_LOGIC; -- front LED: zero=lit
			  
	        eval : out  STD_LOGIC_VECTOR (31 downto 0); -- valve enable: one=ON
           sens : in  STD_LOGIC_VECTOR (31 downto 0); -- valve sens: zero=activated (set PULL_UP)
			  
           ven : inout  STD_LOGIC; -- 34V relay: one=relay ON
           adin : out  STD_LOGIC; -- ADC interface
           adout : in  STD_LOGIC;
           adcs : out  STD_LOGIC;
           adck : out  STD_LOGIC;
			  
			  -- Test Pins
			  PROTOTYPE_o : inout  STD_LOGIC_VECTOR(7 downto 0);
			  
           RX : in  STD_LOGIC; -- communications interface
           TX : out  STD_LOGIC;
           CX : in  STD_LOGIC);
end MAIN_VHDL;

architecture Behavioral of MAIN_VHDL is

---------------------------------------------------------------------------------
------------------------------  FPGA version  ----------------------------------- 
---------------------------------------------------------------------------------
constant fpga_version : std_logic_vector (7 downto 0) := X"01"; -- Version 0.01
---------------------------------------------------------------------------------

-- clock/reset signals
signal clk,clk2x,iclk,reset : std_logic :='0';
signal ck1us,c1us : std_logic :='0';
signal clkx,clkxx : std_logic :='0';
signal cmi,cmit : std_logic;
signal c10MHz,clk12 : std_logic :='0';
signal c25MHz,clk2 : std_logic :='0';
signal c10k,cm100 : std_logic;
signal c3 : std_logic;
signal cxc : std_logic;

-- ADC signals
type adcdatareg is array (3 downto 0) of std_logic_vector (9 downto 0);
type adcdatareg2 is array (3 downto 0) of std_logic_vector (10 downto 0);
signal adcdata,adcdt,adcdt3 : adcdatareg;
signal adcdt2 : adcdatareg2;

-- relay signals
signal venbit, gooff, set34,need34,venn : std_logic;

-- main signals
signal valve : std_logic_vector (31 downto 0); -- translated valve numbers
signal s_fus, s_fus_int : std_logic_vector (31 downto 0); -- hold fuse fail xor 34V fail flags
signal command : std_logic_vector (2 downto 0); -- command received from camera

signal ontimerst : std_logic_vector(31 downto 0); -- 32 bits to avoid hardware flaw when using indexing
signal ontimeout : std_logic_vector(31 downto 0); -- ON time supervisory exit signals
signal on_time_top,on_time_bot,incval,decval : std_logic_vector(15 downto 0); 
signal currentlimit : integer range 0 to 65535;

-- communication signaling
signal valverx : std_logic_vector (31 downto 0); -- On/Off valve vector
signal vdata : std_logic_vector (31 downto 0); -- 30 bit field receiving buffer
signal sys_status : std_logic_vector (34 downto 0); -- 
signal rxs,txs: std_logic_vector (35 downto 0);
signal serend,serst : std_logic;

-------------------------------------------------
------------------ Components -------------------
-------------------------------------------------
-- Manual testejet
signal s_on_manual_tejet : std_logic;
signal s_manual_testejet, s_manual_testejet_int : std_logic_vector(31 downto 0);
signal s_valve_state : std_logic_vector(31 downto 0);

-------------------------------------------------
---------------- Valve limiter ------------------
-------------------------------------------------
signal s_valve_fail_in, s_valve_out, s_valve_limiter : std_logic_vector(31 downto 0);
-- probe
signal s_prototype : std_logic_vector(7 downto 0);

-------------------------------------------------
------------ Overcurrent protection -------------
-------------------------------------------------
signal s_ad_ibus1_sens_acc, s_ad_ibus2_sens_acc : std_logic_vector(13 downto 0);
signal s_ad_12vin_sens_acc, s_ad_34vin_sens_acc : std_logic_vector(13 downto 0);

signal s_ad_ibus1_sens, s_ad_ibus2_sens : std_logic_vector(9 downto 0);
signal s_ad_12vin_sens, s_ad_34vin_sens : std_logic_vector(9 downto 0);

signal s_ad_ibus1_sens_mean, s_ad_ibus2_sens_mean : std_logic_vector(9 downto 0);
signal s_ad_12vin_sens_mean, s_ad_34vin_sens_mean : std_logic_vector(9 downto 0);
signal s_acc_cycles : integer range 0 to 31;
signal s_downsample : integer range 0 to 255;

signal s_max_current : std_logic;
signal s_max_curr_stop : integer range 0 to 655350;

signal s_total_current : std_logic_vector(10 downto 0);

signal s_tune_debug : std_logic_vector(10 downto 0);

-------------------------------------------------
----------- Clock Generation Signals ------------
-------------------------------------------------
signal s_BAUD_CLK, s_BAUD_CLK_BUF : std_logic;	-- Baud Clock 38400 Hz
signal s_baud_clk_counter : integer range 0 to 255;

-------------------------------------------------
--------------- Serial receiver -----------------
-------------------------------------------------
signal s_rx, s_rx_fail, s_pkt_ready : std_logic;
signal s_new_data, s_error, s_cmd_end : std_logic;
signal s_rx_data : std_logic_vector(7 downto 0);

-------------------------------------------------
----------------- Tune Player -------------------
-------------------------------------------------
signal s_tune_frequency : std_logic;
signal s_cmd, s_data : std_logic_vector(7 downto 0);
signal s_tune_output : std_logic_vector(31 downto 0);

-- probes
signal s_probe : std_logic_vector(2 downto 0);
------------------------------------------------------------------------------------------------------	
--------------------------------------- Floor Generating Module --------------------------------------
------------------------------------------------------------------------------------------------------	
signal s_floor, s_illum_off, s_bgnd_floor, s_illum_floor : std_logic;
-------------------------------------------------

-- Components
-------------------------------------------------
------------ Valve Failure Detection ------------
-------------------------------------------------
component WRAPPER_VALVE_FAIL is
    Port ( VALVE_i : in  STD_LOGIC_VECTOR (31 downto 0);
			  VALVE_LIMITER_i : in  STD_LOGIC_VECTOR (31 downto 0);
           SENS_i : in  STD_LOGIC_VECTOR (31 downto 0);
           C10MHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  PROBE_o : out STD_LOGIC_VECTOR(2 downto 0);
           FUSE_o : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-------------------------------------------------
-------------- Serial RS232 signals -------------
-------------------------------------------------
signal s_cutoff_times : std_logic_vector(10 downto 0);
signal s_max_both_ibus : std_logic_vector (10 downto 0);

-------------------------------------------------
------------- Manual Testejet Module ------------
-------------------------------------------------
component MANUAL_TEJET is
    Port ( 
				TEST_i : in std_logic;
				CLK_1K_i : in std_logic;
				C1US_i : in std_logic;
				RESET_i : in std_logic;
				
				MANUAL_TEJET_ON_o : out std_logic;
				MANUAL_TESTEJET_o : out std_logic_vector(31 downto 0)
          );
end component;

-------------------------------------------------
------------------ LED Encoder ------------------
-------------------------------------------------
component LED_ENCODER is
    Port ( FUSE_i : in  STD_LOGIC_VECTOR(31 downto 0);
			  NO_34V_i : in  STD_LOGIC;
           MANUAL_TESTEJET_i : in  STD_LOGIC;
           SET_34_OFF_i : in  STD_LOGIC;
           CLK_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
           LED_o : out  STD_LOGIC);
end component;

-------------------------------------------------
---------- Periodic status data sender ----------
-------------------------------------------------
component STATUS_SENDER is
    Port ( ADC1_DATA_i : in STD_LOGIC_VECTOR(9 downto 0);
			  ADC2_DATA_i : in STD_LOGIC_VECTOR(9 downto 0);
			  MAX_CURR_A : in STD_LOGIC_VECTOR(10 downto 0);
			  MAX_CURR_B : in STD_LOGIC_VECTOR(10 downto 0);
           CLK_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  SEND_o : out STD_LOGIC;
           TX_o : out  STD_LOGIC);
end component;

-----------------------------------------------------
------- Deserializer and command interpreter --------
-----------------------------------------------------
component DESERIALIZER is
    Port ( RX_i : in  STD_LOGIC;										-- RX 232 input
			  CLK_i : in STD_LOGIC;										-- 1 MHz input clock
           BAUD_CLK_i : in  STD_LOGIC;								-- 38400 Hz
           RESET_i : in  STD_LOGIC;
			  
           CMD_o : out  STD_LOGIC_VECTOR (7 downto 0);		-- Deserialized command 
           DATA_o : out  STD_LOGIC_VECTOR (7 downto 0);		-- Deserialized data
           NEW_DATA_o : out  STD_LOGIC;							-- New available data signal
           ERROR_o : out  STD_LOGIC;								-- An unexpected or wrong data
           CMD_END_o : out  STD_LOGIC);							-- Command end flag 
end component;

-----------------------------------------------------
-------------------- Tune Player --------------------
-----------------------------------------------------
component TUNE_PLAYER is
    Port ( CMD_i : in  STD_LOGIC_VECTOR (7 downto 0);						-- Current command
           DATA_i : in  STD_LOGIC_VECTOR (7 downto 0);					-- Data comming from the deserializer module
           NEW_DATA_i : in  STD_LOGIC;											-- Has a new data
           ERROR_i : in  STD_LOGIC;												-- The deserializer received an invalid packet
           CMD_END_i : in  STD_LOGIC;											-- Indicates a command end
           CLK_i : in  STD_LOGIC;												
           RESET_i : in  STD_LOGIC;
			  
           FREQUENCY_o : out  STD_LOGIC);
end component;

-------------------------------------------------
---------------- Ejection Limiter ---------------
-------------------------------------------------
component WRAPPER_COUNTER is
    Port ( VALVE_STATE_i : in  STD_LOGIC_VECTOR (31 downto 0);		-- 32 Valve state input
           C1MHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  PROTOTYPE_o : out STD_LOGIC_VECTOR(7 downto 0);
           VALVE_STATE_o : out  STD_LOGIC_VECTOR (31 downto 0));	-- 32 chopper output (If one of the choppers is 1 then should cool down the valve)
end component;

-------------------------------------------------

begin
-- System clocks ------------------------------------------------------------------------------
   DCM_inst : DCM
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 xor 16.0
      CLKFX_DIVIDE => 1,   --  Can be any interger from 1 to 32
      CLKFX_MULTIPLY => 4, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 0.0,          --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of NONE, FIXED xor VARIABLE
      CLK_FEEDBACK => "1X",         --  Specify clock feedback of NONE, 1X xor 2X
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS xor
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE => "LOW",     --  HIGH xor LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE => "LOW",     --  HIGH xor LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE xor FALSE
      FACTORY_JF => X"C080",          --  FACTORY JF Values
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLK0 => iCLK,     -- 0 degree DCM CLK ouptput
      CLK180 => open, -- 180 degree DCM CLK output
      CLK270 => open, -- 270 degree DCM CLK output
      CLK2X => open,   -- 2X DCM CLK output
      CLK2X180 => open, -- 2X, 180 degree DCM CLK out
      CLK90 => open,   -- 90 degree DCM CLK output
      CLKDV => open,   -- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX => clk2x,   -- DCM CLK synthesis out (M/D)
      CLKFX180 => open, -- 180 degree CLK synthesis out
      LOCKED => open, -- DCM LOCK status output                          <OPEN ????>
      PSDONE => open, -- Dynamic phase adjust done output
      STATUS => open, -- 8-bit DCM status bits output
      CLKFB => CLK,   -- DCM clock feedback
      CLKIN => CLK37,   -- Clock input (from IBUFG, BUFG xor DCM)
      PSCLK => '0',   -- Dynamic phase adjust clock input
      PSEN => '0',     -- Dynamic phase adjust enable input
      PSINCDEC => '0', -- Dynamic phase adjust increment/decrement
      RST => not INITIN        -- DCM asynchronous reset input (INIT pin becomes 1 after configuration)
   );

   -- End of DCM_inst instantiation
   BUFG_inst : BUFG
   port map ( O => clk,  I => iclk); -- 37.5MHz


-----------------------------------------------------------------------------------------

   process (clk2x) -- clock generation with (150MHz)
	variable dv0,dv1,dv2,dv3: integer range 0 to 127 := 0;
	variable dv4: integer range 0 to 255 := 0;
	begin
	  if rising_edge(clk2x) then
		  dv0:=dv0+1; 
		  if (dv0>=12) and (clkxx='0') then dv0:=0; clkxx<='1'; end if;--
		  if (dv0>=12) and (clkxx='1') then dv0:=0; clkxx<='0'; end if;--

		  dv1:=dv1+1; 
		  if (dv1>=100) and (ck1us='0') then dv1:=0; ck1us<='1'; end if;--50
		  if (dv1>=50) and (ck1us='1') then dv1:=0; ck1us<='0'; end if;--25

		  dv2:=dv2+1; 
		  if (dv2>=7) and (clk12='0') then dv2:=0; clk12<='1'; end if;--
		  if (dv2>=8) and (clk12='1') then dv2:=0; clk12<='0'; end if;--

		  dv3:=dv3+1; 
		  if (dv3>=3) and (clk2='0') then dv3:=0; clk2<='1'; end if;--
		  if (dv3>=3) and (clk2='1') then dv3:=0; clk2<='0'; end if;--
		  
		  dv4:=dv4+1; 
		  if (dv4>=250) and (c3='0') then dv4:=0; c3<='1'; end if;--
		  if (dv4>=250) and (c3='1') then dv4:=0; c3<='0'; end if;--
	  end if;
	end process;
	

   BUFG_1u : BUFG
   port map ( O => c1us,  I => ck1us); -- 1MHz
   BUFG_1x : BUFG
   port map ( O => clkx,  I => clkxx); -- 150/24 = 6.25MHz
   BUFG_1z : BUFG
   port map ( O => c10MHz,  I => clk12); -- 150/15 = 10.MHz not 50/50 duty cycle

   BUFG_2z : BUFG
   port map ( O => c25MHz,  I => clk2); -- 150/6 = 25MHz

   reset <= not resetin;

   process (c1us)
	variable rm: integer range 0 to 511 := 0;
	variable rm1: integer range 0 to 63 := 0;
	begin
	  if rising_edge(c1us) then
	    rm:=rm+1;
	    if rm>499 then 
		  cmit<=not cmit;
 		  rm:=0;
		 end if;	 
		 
	    rm1:=rm1+1;
	    if rm1>49 then 
		  cm100<=not cm100;
 		  rm1:=0;
		 end if;	 
		 
	  end if;
	end process;
	
	process (c1us, reset)
	begin
		if rising_edge(c1us) then
		--------------------------------------
		-- Baud clock generation (38400 Hz) --
		--------------------------------------
			if (reset = '1') then

				s_BAUD_CLK_BUF <= '0';
				s_baud_clk_counter <= 0;

			else
			
				if (s_baud_clk_counter = 12) then
					s_baud_clk_counter <= 0;
					s_BAUD_CLK_BUF <= not(s_BAUD_CLK_BUF);
				else
					s_baud_clk_counter <= s_baud_clk_counter + 1;
				end if;
				
			end if;
		 end if;
		 
	end process;
	
   BUFG_BAUD_CLK : BUFG
   port map ( O => s_BAUD_CLK,  I => s_BAUD_CLK_BUF); -- 38400Hz
	
   BUFG_1m : BUFG
   port map ( O => cmi,  I => cmit); -- 1KHz
	
	BUFG_10k : BUFG
   port map ( O => c10k,  I => cm100); -- 10KHz (100us)
 
------------------------------------------------------------------------
------------------------ Manual Testejet Module ------------------------
------------------------------------------------------------------------
	i_MANUAL_TEJET : MANUAL_TEJET
	Port map ( 
					TEST_i => test,
					CLK_1K_i => cmi,
					C1US_i => c1us,
					RESET_i => reset,
					
					MANUAL_TEJET_ON_o => s_on_manual_tejet,
					MANUAL_TESTEJET_o => s_manual_testejet_int
				);
				
	s_manual_testejet(0) <= s_manual_testejet_int(0);
	s_manual_testejet(1) <= '0';
	s_manual_testejet(2) <= s_manual_testejet_int(2);
	s_manual_testejet(3) <= '0';
	s_manual_testejet(4) <= s_manual_testejet_int(4);
	s_manual_testejet(5) <= s_manual_testejet_int(1);
	s_manual_testejet(6) <= s_manual_testejet_int(6);
	s_manual_testejet(7) <= s_manual_testejet_int(3);
	s_manual_testejet(8) <= s_manual_testejet_int(8);
	s_manual_testejet(9) <= s_manual_testejet_int(5);
	s_manual_testejet(10) <= s_manual_testejet_int(10);
	s_manual_testejet(11) <= s_manual_testejet_int(7);
	s_manual_testejet(12) <= '0';
	s_manual_testejet(13) <= s_manual_testejet_int(9);
	s_manual_testejet(14) <= '0';
	s_manual_testejet(15) <= s_manual_testejet_int(11);
	s_manual_testejet(16) <= '0';
	s_manual_testejet(17) <= s_manual_testejet_int(13);
	s_manual_testejet(18) <= '0';
	s_manual_testejet(19) <= s_manual_testejet_int(15);
	s_manual_testejet(20) <= s_manual_testejet_int(12);
	s_manual_testejet(21) <= s_manual_testejet_int(17);
	s_manual_testejet(22) <= s_manual_testejet_int(14);
	s_manual_testejet(23) <= s_manual_testejet_int(19);
	s_manual_testejet(24) <= s_manual_testejet_int(16);
	s_manual_testejet(25) <= s_manual_testejet_int(21);
	s_manual_testejet(26) <= s_manual_testejet_int(18);
	s_manual_testejet(27) <= s_manual_testejet_int(23);
	s_manual_testejet(28) <= s_manual_testejet_int(20);
	s_manual_testejet(29) <= '0';
	s_manual_testejet(30) <= s_manual_testejet_int(22);
	s_manual_testejet(31) <= '0';

------------------------------------------------------------------------
------------------------- Valve Fail Detection -------------------------
------------------------------------------------------------------------
	s_valve_fail_in <= s_valve_state when (s_max_current = '0') else (others=>'0');

	i_VALVE_FAIL_WRAPPER : WRAPPER_VALVE_FAIL
	 Port map( 
				VALVE_i => s_valve_fail_in,						-- Valve state (1 is active)
				VALVE_LIMITER_i => s_valve_limiter,				-- Valve limiter information to clean the has activation flag in case on bit is active
				SENS_i => sens,										-- Sens state (goes 0 with the electromotive effect just after the valve is disabled)
				C10MHZ_i => c10MHz,                          -- 1 MHz clock 
				RST_i => reset,          
				
				PROBE_o => s_probe,
				FUSE_o => s_fus_int                          -- "Fuse" state(1 is OK, 0 is "void")
				);         
				
	s_fus(0) <= s_fus_int(0);
	s_fus(1) <= s_fus_int(5);
	s_fus(2) <= s_fus_int(2);
	s_fus(3) <= s_fus_int(7);
	s_fus(4) <= s_fus_int(4);
	s_fus(5) <= s_fus_int(9);
	s_fus(6) <= s_fus_int(6);
	s_fus(7) <= s_fus_int(11);
	s_fus(8) <= s_fus_int(8);
	s_fus(9) <= s_fus_int(13);
	s_fus(10) <= s_fus_int(10);
	s_fus(11) <= s_fus_int(15);
	s_fus(12) <= s_fus_int(20);
	s_fus(13) <= s_fus_int(17);
	s_fus(14) <= s_fus_int(22);
	s_fus(15) <= s_fus_int(19);
	s_fus(16) <= s_fus_int(24);
	s_fus(17) <= s_fus_int(21);
	s_fus(18) <= s_fus_int(26);
	s_fus(19) <= s_fus_int(23);
	s_fus(20) <= s_fus_int(28);
	s_fus(21) <= s_fus_int(25);
	s_fus(22) <= s_fus_int(30);
	s_fus(23) <= s_fus_int(27);
	s_fus(24) <= '0';
	s_fus(25) <= '0';
	s_fus(26) <= '0';
	s_fus(27) <= '0';
	s_fus(28) <= '0';
	s_fus(29) <= '0';
	s_fus(30) <= '0';
	s_fus(31) <= '0';
	
-------------------------------------------------
------------------ LED Encoder ------------------
-------------------------------------------------
	i_LED_ENCODER : LED_ENCODER
    Port map( 
				FUSE_i => s_fus,
				NO_34V_i => gooff,
				MANUAL_TESTEJET_i => s_on_manual_tejet,
				SET_34_OFF_i => '0',
				CLK_i => cmi,
				RST_i => reset,
				  
				LED_o => led
				);
				
------------------------------------------------------------------------
--------------------- Periodic status data sender ----------------------
------------------------------------------------------------------------
	i_STATUS_SENDER : STATUS_SENDER
    Port map( 
					ADC1_DATA_i => s_ad_ibus1_sens_mean,
					ADC2_DATA_i => s_ad_ibus2_sens_mean, 
					MAX_CURR_A => s_max_both_ibus,
					MAX_CURR_B => s_tune_debug, 
					CLK_i => s_BAUD_CLK,
					RST_i => reset,
					SEND_o => open, -- Teste !!!
					TX_o => open --PROTOTYPE_o(6)
				);

	s_tune_debug <= s_pkt_ready & s_error & s_rx & s_data;
------------------------------------------------------------------------
---------------------------- Tune Player -------------------------------
------------------------------------------------------------------------
	i_TUNE_PLAYER : TUNE_PLAYER
    Port map( 	CMD_i => s_cmd,
					DATA_i => s_data,
					NEW_DATA_i => s_new_data,
					ERROR_i => s_error,
					CMD_END_i => s_cmd_end,
					CLK_i => c1us,
					RESET_i => reset,
			  
					FREQUENCY_o => s_tune_frequency
					);
					
	s_tune_output(0) <= s_tune_frequency;
	s_tune_output(1) <= '0';
	s_tune_output(2) <= '0';
	s_tune_output(3) <= '0';
	s_tune_output(4) <= s_tune_frequency;
	s_tune_output(5) <= '0';
	s_tune_output(6) <= '0';
	s_tune_output(7) <= '0';
	s_tune_output(8) <= s_tune_frequency;
	s_tune_output(9) <= '0';
	s_tune_output(10) <= '0';
	s_tune_output(11) <= '0';
	s_tune_output(12) <= s_tune_frequency;
	s_tune_output(13) <= '0';
	s_tune_output(14) <= '0';
	s_tune_output(15) <= '0';
	s_tune_output(16) <= s_tune_frequency;
	s_tune_output(17) <= '0';
	s_tune_output(18) <= '0';
	s_tune_output(19) <= '0';
	s_tune_output(20) <= s_tune_frequency;
	s_tune_output(21) <= '0';
	s_tune_output(22) <= '0';
	s_tune_output(23) <= '0';
	s_tune_output(24) <= s_tune_frequency;
	s_tune_output(25) <= '0';
	s_tune_output(26) <= '0';
	s_tune_output(27) <= '0';
	s_tune_output(28) <= s_tune_frequency;	
	s_tune_output(29) <= '0';
	s_tune_output(30) <= '0';
	s_tune_output(31) <= '0';
					
------------------------------------------------------------------------
---------------- Deserializer and command interpreter ------------------
------------------------------------------------------------------------
	i_DESERIALIZER : DESERIALIZER 
    Port map( 	RX_i => s_rx,
					CLK_i => c1us,
					BAUD_CLK_i => s_BAUD_CLK,
					RESET_i => reset,
			  
					CMD_o => s_cmd,
					DATA_o => s_data,
					NEW_DATA_o => s_new_data,
					ERROR_o => s_error,
					CMD_END_o => s_cmd_end
					);
					
------------------------------------------------------------------------
--------------------------- Ejection Limiter ---------------------------
------------------------------------------------------------------------
	 i_LIMITER_WRAPPER : WRAPPER_COUNTER
    Port map ( 
				VALVE_STATE_i => s_valve_state,		-- 32 Valve state input
				C1MHZ_i => c1us,
				RST_i => reset,
				
				PROTOTYPE_o => s_prototype,
				VALVE_STATE_o => s_valve_limiter		-- 32 chopper output (If one of the choppers is 1 then should cool down the valve)
				);	
			  
------------------------------------------------------------------------
------------------------- Enable valve Output --------------------------
------------------------------------------------------------------------

	s_valve_state <= (valverx or s_manual_testejet or s_tune_output);
	s_valve_out <= (s_valve_state);
   eval <= s_valve_out;

------------------------------------------------------------------------
	
--	PROTOTYPE_o(0) <= s_tune_frequency;
--	PROTOTYPE_o(1) <= s_tune_frequency;
--	PROTOTYPE_o(2) <= s_tune_frequency;
--	PROTOTYPE_o(3) <= s_tune_frequency;
--	PROTOTYPE_o(4) <= s_tune_frequency;
--	PROTOTYPE_o(5) <= s_tune_frequency;
--	s_rx <= PROTOTYPE_o(7);

	PROTOTYPE_o <= c10MHz & valverx(0) & s_fus(0) & s_valve_limiter(0) & s_max_current & s_probe;--s_prototype(7 downto 1);

-- ADC reading
   process (reset,c10mhz)
	variable adt : integer range 0 to 63;
	variable ch : std_logic_vector (1 downto 0);
	variable chi : integer range 0 to 3;
	begin
	  if (reset='1') then
		
		s_acc_cycles <= 0;
		s_downsample <= 0;
		s_max_both_ibus <= (others => '0');
		
		s_cutoff_times <= (others => '0');
		
		s_max_current <= '0';
		s_max_curr_stop <= 0;
		s_total_current <= (others => '0');
	  
	   ch:="00";
		adt:=0;
		gooff<='0';
	  elsif rising_edge(c10mhz) then
	   chi:=CONV_INTEGER(ch) - 1; -- because address sent to ADC will be read in the next access
--		gooff<='0';
	   case adt is
		  when  0 =>  adcs<='1'; adck<='1'; adin<='0';
		  when  1 =>  adcs<='0'; adck<='1'; adin<='0';
		  when  2 =>  adcs<='0'; adck<='0'; adin<='0'; -- data in 7
		  when  3 =>  adcs<='0'; adck<='1'; adin<='0';
		  when  4 =>  adcs<='0'; adck<='0'; adin<='0'; -- data in 6
		  when  5 =>  adcs<='0'; adck<='1'; adin<='0';
		  when  6 =>  adcs<='0'; adck<='0'; adin<='0'; -- data in 5
		  when  7 =>  adcs<='0'; adck<='1'; adin<='0';
		  when  8 =>  adcs<='0'; adck<='0'; adin<=ch(1); -- data in 4 X
		  when  9 =>  adcs<='0'; adck<='1'; adin<=ch(1);
		  when 10 =>  adcs<='0'; adck<='0'; adin<=ch(0); -- data in 3 X
		  when 11 =>  adcs<='0'; adck<='1'; adin<=ch(0); adcdata(chi)(9)<=adout; -- read data 9
		  when 12 =>  adcs<='0'; adck<='0'; adin<='0'; -- data in 2
		  when 13 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(8)<=adout; -- read data 8
		  when 14 =>  adcs<='0'; adck<='0'; adin<='0'; -- data in 1
		  when 15 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(7)<=adout; -- read data 7
		  when 16 =>  adcs<='0'; adck<='0'; adin<='0'; -- data in 0
		  when 17 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(6)<=adout; -- read data 6
		  when 18 =>  adcs<='0'; adck<='0'; adin<='0'; 
		  when 19 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(5)<=adout; -- read data 5
		  when 20 =>  adcs<='0'; adck<='0'; adin<='0'; 
		  when 21 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(4)<=adout; -- read data 4
		  when 22 =>  adcs<='0'; adck<='0'; adin<='0'; 
		  when 23 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(3)<=adout; -- read data 3
		  when 24 =>  adcs<='0'; adck<='0'; adin<='0'; 
		  when 25 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(2)<=adout; -- read data 2
		  when 26 =>  adcs<='0'; adck<='0'; adin<='0'; 
		  when 27 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(1)<=adout; -- read data 1
		  when 28 =>  adcs<='0'; adck<='0'; adin<='0'; 
		  when 29 =>  adcs<='0'; adck<='1'; adin<='0'; adcdata(chi)(0)<=adout; -- read data 0
		  when 30 =>  adcs<='0'; adck<='0'; adin<='0'; 
							
							case ch is
						
								when "00" =>
												s_ad_ibus1_sens <= adcdata(0);
												
								when "01" =>
												s_ad_ibus2_sens <= adcdata(1);
												
								when "10" =>
												s_ad_12vin_sens <= adcdata(2);
												
								when "11" =>
												s_ad_34vin_sens <= adcdata(3);
												
								when others =>
												
							end case;
		  
		  when 31 =>  adcs<='0'; adck<='1'; adin<='0'; ch:=ch+1; 
		  
							if (s_downsample = 215) then
							
								if (s_acc_cycles = 16) then
								
									s_ad_ibus1_sens_mean <= s_ad_ibus1_sens_acc(13 downto 4);
									s_ad_ibus2_sens_mean <= s_ad_ibus2_sens_acc(13 downto 4);
									s_ad_12vin_sens_mean <= s_ad_12vin_sens_acc(13 downto 4);
									s_ad_34vin_sens_mean <= s_ad_34vin_sens_acc(13 downto 4);
									
									s_ad_ibus1_sens_acc <= (others => '0');
									s_ad_ibus2_sens_acc <= (others => '0');
									s_ad_12vin_sens_acc <= (others => '0');
									s_ad_34vin_sens_acc <= (others => '0');
									
									s_acc_cycles <= 0;
								
								else
									
--									case ch is
								
--										when "00" =>
														s_ad_ibus1_sens_acc <= s_ad_ibus1_sens_acc + ("0000" & s_ad_ibus1_sens);
														
--										when "01" =>
														s_ad_ibus2_sens_acc <= s_ad_ibus2_sens_acc + ("0000" & s_ad_ibus2_sens);
														
--										when "10" =>
														s_ad_12vin_sens_acc <= s_ad_12vin_sens_acc + ("0000" & s_ad_12vin_sens);
														
--										when "11" =>
														s_ad_34vin_sens_acc <= s_ad_34vin_sens_acc + ("0000" & s_ad_34vin_sens);
														s_acc_cycles <= s_acc_cycles + 1;							
														s_downsample <= 0;
														
--										when others =>
														
--									end case;
								end if;	
								
							else

								s_downsample <= s_downsample + 1;
									
							end if;
		  
		  when 32 =>  adcs<='0'; adck<='0'; adin<='0'; 
							
							s_total_current <= ( '0' & s_ad_ibus1_sens_mean ) + ( '0' & s_ad_ibus2_sens_mean );
							
		  when 33 =>  adcs<='0'; adck<='1'; adin<='0'; 
		  
							if (s_ad_34vin_sens_mean < "0001000000") then
								gooff <= '1';
							else
								gooff <= '0';
							end if;
							
							if ( s_total_current > "1101000000") then	-- 895
								s_max_current <= '1';
							else
								if (s_max_current = '1') then
									
									if ( s_max_curr_stop = 100 ) then
										s_max_current <= '0';
										s_max_curr_stop <= 0;
										s_cutoff_times <= s_cutoff_times + '1';
									else
										s_max_current <= '1';
										s_max_curr_stop <= s_max_curr_stop + 1;
									end if;
									
								else
									s_max_current <= '0';
								end if;
							end if;
							
							if (s_total_current > s_max_both_ibus) then
								s_max_both_ibus <= s_total_current;
							else
								s_max_both_ibus <= s_max_both_ibus;
							end if;

		  when 34 =>  adcs<='1'; adck<='1'; adin<='0'; 
		  when 35 =>  adcs<='1'; adck<='1'; adin<='0'; adt:=0;
		  when others => adcs<='1'; adck<='1'; adin<='0'; adt:=0;
		end case;
	   adt:=adt+1;
	  end if;
	end process;

ven <= not(s_max_current); --ven <= '1'; 

--led <= not ven;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- Status generation and processing


	
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- Serial communication with camera board
-- 
-- 36 bits string RX (from camera)
-- 1 bit even parity (1=all other 33 bits have an even number of bits in 1) (portuguese: EVEN=PAR)
-- 3 bit command: 001 - ejector signal
--                011 - clear valve usage accumulators (allows extended ON time)
--                110 - use 30 bit valve field to set system parameters (3 bit to choose the parameter)
--                      011 - TOP ON time (common to all valves) Default=5000 (50ms)
--                      100 - BOT ON time default=500
--                      101 - Decrement value for ON time counter Default=1
--                      110 - Increment value for ON time counter default=5
--                101 - 30 bit valve field is data for another application (not valid to turn any valve ON)
--                all other combinations are invalid
--
-- 36 bits string TX (to camera)
-- 1 bit even parity (1=all other 33 bits have an even number of bits in 1) (portuguese: EVEN=PAR)
-- 3 bit code: 000 - valve fuse status
--             001 - open valve status
--             010 - 
--             011 - valve excedded the max ON time
--             100 - 
--             101 - 
--             110 -
--             111 -
--


   BUFG_1sc : BUFG
   port map ( O => cxc,  I => cx); -- local clock
	
	-- package detection	
   process (cx,rx, reset, serend)
	begin
	    if (reset='1') or (serend='1') then
		    serst<='0';
	    elsif rising_edge(rx) and cx='1' then
		    serst<='1';
			 -- set the parity bit here
           txs <= not (sys_status(34) xor sys_status(33) xor sys_status(32) xor sys_status(31) xor sys_status(30) xor sys_status(29) xor sys_status(28) xor sys_status(27) xor sys_status(26) xor 
							       sys_status(25) xor sys_status(24) xor sys_status(23) xor sys_status(22) xor sys_status(21) xor sys_status(20) xor sys_status(19) xor sys_status(18) xor sys_status(17) xor 
									 sys_status(16) xor sys_status(15) xor sys_status(14) xor sys_status(13) xor sys_status(12) xor sys_status(11) xor sys_status(10) xor sys_status(9)  xor sys_status(8) xor 
									 sys_status(7)  xor sys_status(6)  xor sys_status(5)  xor sys_status(4)  xor sys_status(3)  xor sys_status(2)  xor sys_status(1)  xor sys_status(0)) 
					             & sys_status;
		 end if;
	end process;

-- receiving machine
   process (cxc,serst)
	variable nrx:integer range 0 to 63;
	variable rxpar : std_logic;
	begin
	  if (reset='1') or (serst='0') then
	     nrx:=0;
		  serend<='0';
		  rxpar:='0';
	  elsif rising_edge(cxc) then
		 rxs<=rxs(34 downto 0) & rx;
		 if nrx=36 then 
		    serend<='1'; 
		    rxpar := rxs(35) xor rxs(34) xor rxs(33) xor rxs(32) xor rxs(31) xor rxs(30) xor rxs(29) xor rxs(28) xor rxs(27) xor rxs(26) xor 
					    rxs(25) xor rxs(24) xor rxs(23) xor rxs(22) xor rxs(21) xor rxs(20) xor rxs(19) xor rxs(18) xor rxs(17) xor rxs(16) xor 
					    rxs(15) xor rxs(14) xor rxs(13) xor rxs(12) xor rxs(11) xor rxs(10) xor rxs(9)  xor rxs(8)  xor rxs(7)  xor rxs(6) xor 
		             rxs(5)  xor rxs(4)  xor rxs(3)  xor rxs(2)  xor rxs(1)  xor rxs(0); 						 
			 if rxpar='1' then
		       vdata <= rxs(31 downto 0);
		       command <= rxs(34 downto 32); -- 3 bit command
				 else
				 command <= "000"; -- null command
          end if;			 
		 end if;
		 nrx:=nrx+1;
	  end if;
	end process;

-- transmiting machine
   process (cxc,serst)
	variable ti : integer range 0 to 63;
	begin
	  if (reset='1') or (serst='0') then
	    ti:=35;
	  elsif falling_edge(cxc) then
	    tx<=txs(ti);
		 ti:=ti-1;
	  end if;
	end process;
	
-----------------------------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------------------------	
-- data validation
   process (serst,cxc,reset) -- clock must be a little faster than SCLK
	variable partype:std_logic_vector(2 downto 0);
	variable sc : integer range 0 to 7;
	begin
	  if (reset='1') then
	    on_time_top <= "0000000000001010"; -- Default max on = 5 seconds
	    on_time_bot <= "0000000000100000"; -- Default cooldown = 10 seconds
		 incval <= "0000000000000100"; 		-- Default Increase value = 4
		 decval <= "0000000000000010"; 		-- Default Decrease value = 2
       set34<='0';
		 currentlimit<=900; --880; --850;
		 sys_status <= "111" & "00000000000000000000000000000000";
		 
	  elsif falling_edge(cxc) and serst='0' then
	  
		 partype:=vdata(31 downto 29); -- get the 3 bits for parameter type to use in the CASE
       set34<='0';
		     sc:=sc+1;
			  case sc is
			   when 0 => sys_status <= "000" & not(s_fus);
			   when 1 => sys_status <= "001" & "00000000000000000000000000000000";
			   when 2 => sys_status <= "010" & fpga_version & "00001111" & "11111000" & "0000000" & venn; --s_cutoff_times(7 downto 0)
			   when 3 => sys_status <= "011" & s_valve_limiter; --ontimerst;
			   when 4 => sys_status <= "100" & "0000000000000000000000" & s_ad_ibus1_sens_mean;
			   when 5 => sys_status <= "101" & "0000000000000000000000" & s_ad_ibus2_sens_mean;
			   when 6 => sys_status <= "110" & "0000000000000000000000" & s_ad_12vin_sens_mean;
			   when 7 => sys_status <= "111" & "0000000000000000000000" & s_ad_34vin_sens_mean;
			   when others => sys_status <= "111" & "00000000000000000000000000000000";
			  end case;
	

		     case command is
			   when "001" => 	valverx(0) <= vdata(0);
									valverx(1) <= '0';
									valverx(2) <= vdata(2);
									valverx(3) <= '0';
									valverx(4) <= vdata(4);
									valverx(5) <= vdata(1);
									valverx(6) <= vdata(6);
									valverx(7) <= vdata(3);
									valverx(8) <= vdata(8);
									valverx(9) <= vdata(5);
									valverx(10) <= vdata(10);
									valverx(11) <= vdata(7);
									valverx(12) <= '0';
									valverx(13) <= vdata(9);
									valverx(14) <= '0';
									valverx(15) <= vdata(11);
									valverx(16) <= '0';
									valverx(17) <= vdata(13);
									valverx(18) <= '0';
									valverx(19) <= vdata(15);
									valverx(20) <= vdata(12);
									valverx(21) <= vdata(17);
									valverx(22) <= vdata(14);
									valverx(23) <= vdata(19);
									valverx(24) <= vdata(16);
									valverx(25) <= vdata(21);
									valverx(26) <= vdata(18);
									valverx(27) <= vdata(23);
									valverx(28) <= vdata(20);
									valverx(29) <= '0';
									valverx(30) <= vdata(22);
									valverx(31) <= '0';
				
				when "011" => --on_time_top <= vdata(31 downto 16); -- 16 bits 400ms max
				              --on_time_bot <= vdata(15 downto 0); -- 16 bits 
				when "100" => --decval <= vdata(31 downto 16);
				              --incval <= vdata(15 downto 0); -- 
				when "101" => currentlimit<=CONV_INTEGER(vdata(15 downto 0));
			   when "110" => -- parameter setup
				              case partype is
								   when "001" => set34<='1';
								   when "010" => venbit <= vdata(0);
								   when others =>
								  end case;
				when others =>
			  end case;

	  end if;
	end process;
	
end Behavioral;