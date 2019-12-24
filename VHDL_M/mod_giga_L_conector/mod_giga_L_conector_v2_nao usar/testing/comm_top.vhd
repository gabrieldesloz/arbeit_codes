
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;
use work.my_types_pkg.all;


-------------------------------------------------------------------------------

entity comm_top is

  port(

    CLK_i : in std_logic;		-- IN GCLK

 
    EATX_i : in	 std_logic;
    EARX_o : out std_logic;		-- OUT CLK - ODDR
    EBRX_o : out std_logic;
	
	clk_60MHz_o: out std_logic;
	debug_o: out std_logic

    );


end comm_top;

-------------------------------------------------------------------------------

architecture ARQ of comm_top is

  signal SEND_DATA_i	   : input_array := (others => (others => '0'));
  signal SEND_DATA_i_slave : input_array := (others => (others => '0'));
  signal RECEIVED_DATA_o   : input_array := (others => (others => '0'));
  signal DATA_TX_o	   : std_logic	 := '0';
  signal SYNC_CLK_o	   : std_logic	 := '0';

  -- other signals
  signal reset						   : std_logic := '0';
  signal n_reset					   : std_logic := '0';
  signal mux_i						   : std_logic := '0';
  signal SOP_master, EOP_master				   : std_logic := '0';
  signal DATA_TX_o_slave				   : std_logic := '0';
  signal s_clk_fb_buf, s_clk_fb, clk_60MHz, clk_60MHz_bufg : std_logic;  
  signal s_EARX_o: std_logic;
  signal not_s_EARX_o, not_clk_60MHz_bufg: std_logic;

  
  


begin




-------------------------
debug_o <= reset;
-------------------------

OFDDRCPE2_inst : OFDDRCPE
port map (
	Q => clk_60MHz_o, -- Data output (connect directly to top-level port)
	C0 => clk_60MHz_bufg, -- 0 degree clock input
	C1 => not_clk_60MHz_bufg, -- 180 degree clock input
	CE => '1', -- Clock enable input
	CLR => '0', -- Asynchronous reset input
	D0 => '1', -- Posedge data input
	D1 => '0', -- Negedge data input
	PRE => '0' -- Asynchronous preset input
); 

not_clk_60MHz_bufg <= not clk_60MHz_bufg;

  
  -- clock generation

  -- DCM Instantiation multiply input (37,5MHZ) by 8 (300MHZ) and divide by 5 (60 MHz)
  DCM_inst : DCM
    generic map (
      CLKDV_DIVIDE	    => 8.0,  --	 Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
      --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE	    => 5,	--  Can be any interger from 1 to 32
      CLKFX_MULTIPLY	    => 8,	--  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2	    => false,  --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD	    => 26.666,	--  Specify period of input clock
      CLKOUT_PHASE_SHIFT    => "NONE",	--  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK	    => "1X",  --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST	    => "SYSTEM_SYNCHRONOUS",  --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
					--     an integer from 0 to 15
      DFS_FREQUENCY_MODE    => "LOW",  --  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE    => "LOW",	--  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION => true,  --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF	    => X"C080",		      --  FACTORY JF Values
      PHASE_SHIFT	    => 0,  --  Amount of fixed phase shift from -255 to 255
      SIM_MODE		    => "SAFE",	-- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation
      -- Design Guide" for details
      STARTUP_WAIT	    => false)  --  Delay configuration DONE until DCM LOCK, TRUE/FALSE
    port map (
      CLK0     => s_clk_fb,		-- 0 degree DCM CLK ouptput
      CLK180   => open,			-- 180 degree DCM CLK output
      CLK270   => open,			-- 270 degree DCM CLK output
      CLK2X    => open,			-- 2X DCM CLK output
      CLK2X180 => open,			-- 2X, 180 degree DCM CLK out
      CLK90    => open,			-- 90 degree DCM CLK output
      CLKDV    => open,			-- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX    => clk_60MHz,		-- DCM CLK synthesis out (M/D)
      CLKFX180 => open,			-- 180 degree CLK synthesis out
      LOCKED   => open,			-- DCM LOCK status output
      PSDONE   => open,			-- Dynamic phase adjust done output
      STATUS   => open,			-- 8-bit DCM status bits output
      CLKFB    => s_clk_fb_buf,		-- DCM clock feedback
      CLKIN    => CLK_i,  -- Clock input (from IBUFG, BUFG or DCM) -- 37.5 MHz
      PSCLK    => '0',			-- Dynamic phase adjust clock input
      PSEN     => '0',			-- Dynamic phase adjust enable input
      PSINCDEC => '0',		   -- Dynamic phase adjust increment/decrement
      RST      => '0'			-- DCM asynchronous reset input
      );


  
 
   dcm_feedback_buffer : BUFG
    port map (O => s_clk_fb_buf, I => s_clk_fb);
  
  
  BUFG_inst : BUFG
    port map (O => clk_60MHz_bufg, I => clk_60MHz);


  -- reset generation
  
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)		
    port map (
      clk     => clk_60MHz_bufg,
      n_reset => n_reset);

  reset <= not n_reset;

--------------- SEND ------------------------------

  EJ_SERIAL_MASTER_1 : entity work.EJ_SERIAL_MASTER
    port map (
      SEND_DATA_i     => SEND_DATA_i,
     
      CLK_i	      => clk_60MHz_bufg,
      RST_i	      => reset,
      RECEIVED_DATA_o => open,

      DATA_RX_i	      => EATX_i,  
      DATA_TX_o	      => EBRX_o,
      SYNC_CLK_o      => EARX_o,
     
	   SOP_o	      => open,
      EOP_o	      => open);	   


	  
	  SEND_DATA_i(0) <= x"AAAAAAAA";
	  SEND_DATA_i(1) <= x"BBBBBBBB";
	  SEND_DATA_i(2) <= x"CCCCCCCC";
	  SEND_DATA_i(3) <= x"DDDDDDDD";
	  SEND_DATA_i(4) <= x"EEEEEEEE";
	  SEND_DATA_i(5) <= x"FFFFFFFF";
	  SEND_DATA_i(6) <= x"F0F0F0F0";
	  SEND_DATA_i(7) <= x"00000000";
	  
	  
    
end ARQ;



