-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : 
-- Author     : 
-- Company    : 
-- Created    : 2012-08-07
-- Last update: 2014-09-03
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2012-08-07  1.0		Created
-------------------------------------------------------------------------------

library ieee, UNISIM;
use ieee.std_logic_1164.all;
use UNISIM.VComponents.all;

entity clock_gen is
  
  port (

    dcmrst_i   : in std_logic;
    CLK37mux_i : in std_logic;

    clkaq_o	: out std_logic;
    clk2x_o	: out std_logic;
    clkx_o	: out std_logic;
    clkz_o	: out std_logic;
    c1us_o	: out std_logic;
    adc1_sclk_o : out std_logic;
    adc2_sclk_o : out std_logic;
    clka_o	: out std_logic;
    clkab_o	: out std_logic


    );

end clock_gen;

architecture ARQ of clock_gen is

  signal CLKFX		      : std_logic;
  signal CLKFX180	      : std_logic;
  signal CLKFXDV	      : std_logic;
  signal dcmrst, CLK37mux     : std_logic;
  signal clkxx, clkxxx, ck1us : std_logic;
  signal clkaq		      : std_logic;
  signal clk2x		      : std_logic;
  signal clkx, clkz, c1us     : std_logic;

  signal afec : std_logic_vector (15 downto 0);


  --type clk_signals is record
  --  clkaq_test : std_logic;
  --end record clk_signals;

  --procedure not_clk (
  --  signal s_clk_signals : in clk_signals) is
  --begin
  --  s_clk_signals.clkaq_test <= not s_clk_signals.clkaq_test;
  --end procedure not_clk;



  
  
  
begin

  
  DCM_CLKGEN_inst : DCM_CLKGEN
    generic map (
      CLKFXDV_DIVIDE  => 2,   -- CLKFXDV divide value (2, 4, 8, 16, 32)
      CLKFX_DIVIDE    => 1,		-- Divide value - D - (1-256)
      CLKFX_MD_MAX    => 3.0,	-- Specify maximum M/D ratio for timing anlysis
      CLKFX_MULTIPLY  => 3,		-- Multiply value - M - (2-256)
      CLKIN_PERIOD    => 23.0,		-- Input clock period specified in nS
      SPREAD_SPECTRUM => "NONE",  -- Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD" or "CENTER_HIGH_SPREAD" 
      STARTUP_WAIT    => false	-- Delay config DONE until DCM LOCKED (TRUE/FALSE)
      )
    port map (
      CLKFX	=> CLKFX,		-- 1-bit Generated clock output
      CLKFX180	=> CLKFX180,  -- 1-bit Generated clock output 180 degree out of phase from CLKFX.
      CLKFXDV	=> CLKFXDV,		-- 1-bit Divided clock output
      LOCKED	=> open,		-- 1-bit Locked output
      PROGDONE	=> open,  -- 1-bit Active high output to indicate the successful re-programming
      STATUS	=> open,		-- 2-bit DCM status
      CLKIN	=> CLK37mux,		-- 1-bit Input clock
      FREEZEDCM => '0',	 -- 1-bit Prevents frequency adjustments to input clock
      PROGCLK	=> '0',	 -- 1-bit Clock input for M/D reconfiguration
      PROGDATA	=> '0',	 -- 1-bit Serial data input for M/D reconfiguration
      PROGEN	=> '0',			-- 1-bit Active high program enable
      RST	=> dcmrst		-- 1-bit Reset input pin
      );

  -- End of DCM_inst instantiation
  
  dcmrst   <= dcmrst_i;
  CLK37mux <= CLK37mux_i;
  clkaq_o  <= clkaq;
  clk2x_o  <= clk2x;
  clkx_o   <= clkx;
  clkz_o   <= clkz;
  c1us_o   <= c1us;

  adc2_sclk_o <= '1' when c1us = '1' else '0';
  adc1_sclk_o <= '1' when c1us = '1' else '0';

  clka_o  <= not clkaq;
  clkab_o <= not clkaq;

  -----------------------------------------------------------------------------------------

  process (clk2x, dcmrst)		-- clock generation with 112.5MHz
    variable dv1a, dv2, dv3, dv4 : integer range 0 to 15 := 0;
    variable dv1		 : integer range 0 to 63 := 0;
  begin
    if dcmrst = '1' then
      dv4    := 0; dv1 := 0; dv1a := 0; dv3 := 0;
      clkxx  <= '0';
      clkxxx <= '0';
      ck1us  <= '0';
      clkaq  <= '0';
    elsif rising_edge(clk2x) then
      
      dv1a					 := dv1a+1;
      if (dv1a = 3) and (clkxxx = '0') then dv1a := 0; clkxxx <= '1'; end if;  -- 18.75MHz
      if (dv1a = 3) and (clkxxx = '1') then dv1a := 0; clkxxx <= '0'; end if;  --

      dv3				      := dv3+1;
      if (dv3 = 6) and (clkxx = '0') then dv3 := 0; clkxx <= '1'; end if;  -- 9.375MHz
      if (dv3 = 6) and (clkxx = '1') then dv3 := 0; clkxx <= '0'; end if;  --

      dv1				       := dv1+1;
      if (dv1 = 55) and (ck1us = '0') then dv1 := 0; ck1us <= '1'; end if;  -- 1.0046MHz
      if (dv1 = 57) and (ck1us = '1') then dv1 := 0; ck1us <= '0'; end if;  --

      clkaq <= not clkaq;		-- 56.25MHz
   
      
    end if;
  end process;


  BUFG_inst : BUFG
    port map (O => clk2x, I => clkfx);	-- 3 * 37.5= 112.5MHz  
  BUFG_1u : BUFG
    port map (O => c1us, I => ck1us);	-- 1.0046MHz
  BUFG_1z : BUFG
    port map (O => clkz, I => clkxxx);	-- 18.75MHz
  BUFG_1x : BUFG
    port map (O => clkx, I => clkxx);	-- 9.375MHz



	
 clock_gen_fsm_1 : entity work.clock_gen_fsm
    port map (
      clkaq	 => clkaq,
      reset	 => dcmrst,
      sincin_i	 => '0',
      clrsinc_o	 => open,
      CCD_CLK1_o => open,
      CCD_CLK2_o => open,
      CCD_CLK3_o => open,
      CCD_CLK4_o => open,
      afeck2_o	 => open,
      afeck0_o	 => open);   



end ARQ;


-- configurations
