
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

    -- comunication with serial
    DATA_RX_serial_i  : in std_logic;  
    SYNC_CLK_serial_i : in  std_logic;	-- IN GCLK
    DATA_TX_serial_o  : out std_logic;

    -- connector	
    EATX_i : in	 std_logic;     -- rx in serial
    EARX_o : out std_logic;		-- OUT CLK - ODDR -- serial clock out 
    EBRX_o : out std_logic;     -- serial DATA out - TX  
	
	clk_60MHz_o: out std_logic;
	debug_o: out std_logic_vector(3 downto 0)

    );


end comm_top;

-------------------------------------------------------------------------------

architecture ARQ of comm_top is

  signal SEND_DATA_i	   : input_array := (others => (others => '0'));
  signal SEND_DATA_i_slave : input_array := (others => (others => '0'));
  signal RECEIVED_DATA_o   : input_array := (others => (others => '0'));
  signal RECEIVED_DATA_at_master   : input_array := (others => (others => '0'));
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
  signal debug_o_mux: std_logic; 
  signal verify_ok1, verify_ok2: std_logic;
  
  


begin

--- 
--IBUF



-- OFDDRCPE_inst : OFDDRCPE
-- port map (
	-- Q => EARX_o, -- Data output (connect directly to top-level port)
	-- C0 => s_EARX_o, -- 0 degree clock input
	-- C1 => not_s_EARX_o, -- 180 degree clock input
	-- CE => '1', -- Clock enable input
	-- CLR => reset, -- Asynchronous reset input
	-- D0 => '1', -- Posedge data input
	-- D1 => '0', -- Negedge data input
	-- PRE => '0' -- Asynchronous preset input
-- ); 

--not_s_EARX_o <= not s_EARX_o;
-------------------------
debug_o <= mux_i & verify_ok2 & verify_ok2 & verify_ok2;
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

  mux_1 : entity work.mux
    port map (
      CLK_60MHZ_i => clk_60MHz_bufg,      
      reset	  => reset,


      EACK_i => '1',
      EATX_i => EATX_i,			-- from ejector board
      EARX_o => EARX_o,			-- to ejector board (clk)

      EBCK_i  => '1',
      EBRX_o  => EBRX_o,		-- to ejector board
      EBTX_i => '1',

      --uC
      EATXD_to_uC_o	=> open,
      EACK_to_uC_o	=> open,
      EBCK_to_uC_o	=> open,
      EBTXD_to_uC_o	=> open,
      ENABLE_EJECTORS_i => '1',
      mux_i		=> mux_i,

      -- serial
      EJ_DATA_RX_o => DATA_TX_o_slave,
      SCK_SERIAL_i => SYNC_CLK_o,
      EJ_DATA_TX_i => DATA_TX_o,

      SOP_i => SOP_master,
      EOP_i => EOP_master,
	  debug_o => debug_o_mux);		



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
      DATA_RX_i	      => DATA_TX_o_slave,  --
      SEND_DATA_i     => SEND_DATA_i,
      CLK_i	      => clk_60MHz_bufg,
      RST_i	      => reset,
      RECEIVED_DATA_o => RECEIVED_DATA_at_master,
      DATA_TX_o	      => DATA_TX_o,
      SYNC_CLK_o      => SYNC_CLK_o,
      SOP_o	      => SOP_master,
      EOP_o	      => EOP_master);	   


 -- master sender
  -- word_changer_0 : process(clk_60MHz_bufg, mux_i, reset)
    -- variable state_count  : integer range 0 to 14;
    -- variable time_counter : unsigned(31 downto 0);
  -- begin
    
    -- if reset = '1' then
      -- mux_i	   <= '0';
      -- state_count  := 0;
      -- SEND_DATA_i  <= (others => (others => '0'));
      -- time_counter := (others => '0');
    -- elsif rising_edge(clk_60MHz_bufg) then
      
      -- time_counter := time_counter;
      -- state_count  := state_count;
      

      -- case state_count is
	
	-- when 0 =>
	  -- mux_i	      <= '0';
	  -- SEND_DATA_i <= (others => (others => '0'));

	  -- time_counter := time_counter + 1;
	  -- if time_counter = 60_000 then	 --(1 ms)
	    -- state_count	 := state_count + 1;
	    -- time_counter := (others => '0');
	  -- end if;
	  
	-- when 1 =>
	  -- mux_i	      <= '1';		-- start mux pulse 
	  -- state_count := state_count + 1;
	  
	-- when 2 =>
	  -- SEND_DATA_i(0) <= x"AAAAAAAA";
	  -- SEND_DATA_i(1) <= x"BBBBBBBB";
	  -- SEND_DATA_i(2) <= x"CCCCCCCC";
	  -- SEND_DATA_i(3) <= x"DDDDDDDD";
	  -- SEND_DATA_i(4) <= x"EEEEEEEE";
	  -- SEND_DATA_i(5) <= x"FFFFFFFF";
	  -- SEND_DATA_i(6) <= x"F0F0F0F0";
	  -- SEND_DATA_i(7) <= x"00000000";

	  -- time_counter := time_counter + 1;
	  -- if time_counter = 480200 then	 --(4 ms + 200 clock)
	    -- state_count	 := state_count + 1;
	    -- time_counter := (others => '0');
	  -- end if;
	  -- mux_i	      <= '1';
	  
	-- when 3 =>
	  -- mux_i	      <= '0';		-- ok, end mux pulse
	  -- SEND_DATA_i <= (others => (others => '0'));

	  -- time_counter := time_counter + 1;
	  -- if time_counter = 60_000_000 then  -- one minute
	    -- state_count	 := 0;
	    -- time_counter := (others => '0');
	  -- end if;
	  
	-- when others =>
	  -- state_count := 0;
	  -- mux_i	      <= '0';
      -- end case;
    -- end if;
  -- end process;


  -- master sender
  word_changer_0 : process(clk_60MHz_bufg, reset)  
    variable time_counter : unsigned(31 downto 0);
  begin    
    if reset = '1' then
      mux_i	   <= '0';     
      time_counter := (others => '0');	  
    elsif rising_edge(clk_60MHz_bufg) then  
		time_counter := time_counter + 1;
		mux_i <= mux_i;	  
	 if time_counter = 400_000_000 then  
		time_counter := (others => '0');
		mux_i <= not mux_i;
	  end if;	
    end if;
  end process;
  
  
	SEND_DATA_i(0) <= x"AAAAAAAA";
	SEND_DATA_i(1) <= x"BBBBBBBB";
	SEND_DATA_i(2) <= x"CCCCCCCC";
	SEND_DATA_i(3) <= x"DDDDDDDD";
	SEND_DATA_i(4) <= x"EEEEEEEE";
	SEND_DATA_i(5) <= x"FFFFFFFF";
	SEND_DATA_i(6) <= x"F0F0F0F0";
	SEND_DATA_i(7) <= x"00000000";

	
	SEND_DATA_i_slave(0) <= x"F0F0F0F0";
	SEND_DATA_i_slave(1) <= x"00000000";
	SEND_DATA_i_slave(2) <= x"F0F0F0F0";
	SEND_DATA_i_slave(3) <= x"00000000";
	SEND_DATA_i_slave(4) <= x"F0F0F0F0";
	SEND_DATA_i_slave(5) <= x"00000000";
	SEND_DATA_i_slave(6) <= x"F0F0F0F0";
	SEND_DATA_i_slave(7) <= x"00000000";
	  
	
  --------------- RECEIVE ------------------------------

  EJ_SERIAL_SLAVE_1 : entity work.EJ_SERIAL_SLAVE
    port map (
      DATA_RX_i	      => DATA_RX_serial_i, -- ok
      SEND_DATA_i     => SEND_DATA_i_slave,
      SYNC_CLK_i      => SYNC_CLK_serial_i,
      RST_i	      		=> reset,
      RECEIVED_DATA_o => RECEIVED_DATA_o,
      DATA_TX_o	      => DATA_TX_serial_o);	  


	   
	  verify_ok1 <= '1' when
		((RECEIVED_DATA_o(0) =  x"AAAAAAAA") AND
		(RECEIVED_DATA_o(1) =  x"BBBBBBBB") AND
		(RECEIVED_DATA_o(2) =  x"CCCCCCCC") AND
		(RECEIVED_DATA_o(3) =  x"DDDDDDDD") AND
		(RECEIVED_DATA_o(4) =  x"EEEEEEEE") AND
		(RECEIVED_DATA_o(5) =  x"FFFFFFFF") AND
		(RECEIVED_DATA_o(6) =  x"F0F0F0F0") AND
		(RECEIVED_DATA_o(7) =  x"00000000")) else
		'0';
		
		
	  verify_ok2 <= '1' when
		((RECEIVED_DATA_at_master(0) =  x"F0F0F0F0") AND
		(RECEIVED_DATA_at_master(1) =  x"00000000") AND
		(RECEIVED_DATA_at_master(2) =  x"F0F0F0F0") AND
		(RECEIVED_DATA_at_master(3) =  x"00000000") AND
		(RECEIVED_DATA_at_master(4) =  x"F0F0F0F0") AND
		(RECEIVED_DATA_at_master(5) =  x"00000000") AND
		(RECEIVED_DATA_at_master(6) =  x"F0F0F0F0") AND
		(RECEIVED_DATA_at_master(7) =  x"00000000")) else
		'0';
	  
	  
	  

--slave sender
  -- word_changer_1 : process(clk_60MHz_bufg, reset, SEND_DATA_i_slave)
    -- variable state_count  : integer range 0 to 14;
    -- variable time_counter : unsigned(31 downto 0);
  -- begin
    
    -- if reset = '1' then
      -- state_count	:= 0;
      -- SEND_DATA_i_slave <= (others => (others => '0'));
      -- time_counter	:= (others => '0');
      
    -- elsif rising_edge(clk_60MHz_bufg) then
      
      -- time_counter	:= time_counter;
      -- state_count	:= state_count;
      -- SEND_DATA_i_slave <= SEND_DATA_i_slave;

      -- case state_count is
	
	-- when 0 =>
	  
	  -- SEND_DATA_i_slave <= (others => (others => '0'));

	  -- time_counter := time_counter + 1;
	  -- if time_counter = 180_000 then  --(3 ms)
	    -- state_count	 := state_count + 1;
	    -- time_counter := (others => '0');
	  -- end if;
	  
	-- when 1 =>
	  -- state_count := state_count + 1;
	  
	-- when 2 =>
	  -- SEND_DATA_i_slave(0) <= x"AAAAAAAA";
	  -- SEND_DATA_i_slave(1) <= x"BBBBBBBB";
	  -- SEND_DATA_i_slave(2) <= x"CCCCCCCC";
	  -- SEND_DATA_i_slave(3) <= x"DDDDDDDD";
	  -- SEND_DATA_i_slave(4) <= x"EEEEEEEE";
	  -- SEND_DATA_i_slave(5) <= x"FFFFFFFF";
	  -- SEND_DATA_i_slave(6) <= x"F0F0F0F0";
	  -- SEND_DATA_i_slave(7) <= x"00000000";

	  -- time_counter := time_counter + 1;
	  -- if time_counter = 200 then	--(200 clock)
	    -- state_count	 := state_count + 1;
	    -- time_counter := (others => '0');
	  -- end if;
	  
	-- when 3 =>
	  -- SEND_DATA_i_slave <= (others => (others => '0'));
	  -- time_counter	    := time_counter + 1;
	  -- if time_counter = 60_000_000 then  -- one minute
	    -- state_count	 := 0;
	    -- time_counter := (others => '0');
	  -- end if;
	  
	-- when others =>
	  -- state_count := 0;
      -- end case;
    -- end if;
  -- end process;
  
   
end ARQ;



