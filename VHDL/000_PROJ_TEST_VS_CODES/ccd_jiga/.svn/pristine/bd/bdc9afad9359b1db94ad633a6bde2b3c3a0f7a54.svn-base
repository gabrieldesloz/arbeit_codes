
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-------------------------------------------------------------------------------

entity tb_ccd_ctrl is


end tb_ccd_ctrl;

-------------------------------------------------------------------------------

architecture generic_tb_rtl of tb_ccd_ctrl is


  -- component ports
  -- clock -- 56.25MHz
  constant CLK_AQ_PERIOD : time := 18 ns;

-- uut signals

  signal clkaq					    : std_logic			    := '0';
  signal reset					    : std_logic			    := '0';
  signal sincin_i				    : std_logic			    := '0';
  signal clrsinc_o				    : std_logic			    := '0';
  signal CCD_CLK1_o				    : std_logic			    := '0';
  signal CCD_CLK2_o				    : std_logic			    := '0';
  signal CCD_CLK3_o				    : std_logic			    := '0';
  signal CCD_CLK4_o				    : std_logic			    := '0';
  signal CCD_SI1_o, CCD_SI2_o, CCD_SI3_o, CCD_SI4_o : std_logic			    := '0';
  signal pix_o					    : std_logic_vector (7 downto 0) := (others => '0');

  signal reset_start, reset_int : std_logic := '0';
  signal s_r : time:= 1 ms;  
  signal s_sincin: time:= 1 us;
  signal clkaq_jitter: std_logic := '0';
  signal d : time := 0 ns;
  signal clock : std_logic := '0';	

  
begin

  -- uut

  ccd_ctrl_fsm_1 : entity work.ccd_ctrl_fsm
    port map (
      clkaq	 => clkaq,		-- [std_logic]
      reset	 => reset,		-- [std_logic]
      sincin_i	 => sincin_i,		-- [std_logic]
      clrsinc_o	 => clrsinc_o,		-- [std_logic]
      CCD_CLK1_o => CCD_CLK1_o,		-- [std_logic]
      CCD_CLK2_o => CCD_CLK2_o,		-- [std_logic]
      CCD_CLK3_o => CCD_CLK3_o,		-- [std_logic]
      CCD_CLK4_o => CCD_CLK4_o,		-- [std_logic]
      CCD_SI1_o	 => CCD_SI1_o,		-- [std_logic]
      CCD_SI2_o	 => CCD_SI2_o,		-- [std_logic]
      CCD_SI3_o	 => CCD_SI3_o,		-- [std_logic]
      CCD_SI4_o	 => CCD_SI4_o,		-- [std_logic]
      pix_o	 => pix_o);		-- [std_logic_vector (7 downto 0)]

 
 
 
-------------------------------------------------------------------------------
-- clock com jitter
------------------------------------------------------------------------------- 
	
	sys_clk_process:  process
		variable seed5, seed6 : positive;
		variable r : real;
		variable int_rand : integer;
	begin
		int_rand := integer(trunc(r*3.0));
		uniform(seed5, seed6, r);
		d <= int_rand * 1 ns;
		wait for CLK_AQ_PERIOD/2;
		clock <= '0';
		wait for CLK_AQ_PERIOD/2;
		clock <= '1'; 
	end process sys_clk_process;
	
	clkaq_jitter <=  transport (not clock) after d;	 


	  
	  
-------------------------------------------------------------------------------
-- random time stimulus - reset
-------------------------------------------------------------------------------
  random_p : process
    variable seed1, seed2 	: positive;
    variable r		  		: real;
    variable int_rand	  	: integer;
    variable s_r_var 		: integer := 0; 
  begin
    uniform(seed1, seed2, r);
    s_r_var := integer(trunc(10.0*r));
    s_r <= s_r_var * 1 ms;
	wait until clkaq = '1';	
  end process;
 
  
  -- continuous and random reset generation
  reset_int_p : process
  begin
    wait until clkaq = '1';
    reset_int <= '0';
    wait for s_r;
    reset_int <= '1';
    wait for (2*CLK_AQ_PERIOD);
  end process;
  
    
  -- reset
  reset <= reset_int or reset_start;

  -- clock generation  
  clkaq <= not clkaq after CLK_AQ_PERIOD/2;

  -- initial reset generation
  reset_n_proc : process
  begin
    reset_start <= '1';
    wait for 10*CLK_AQ_PERIOD;
    reset_start <= '0';
    wait for 50_000 ms;
  end process;
  
-------------------------------------------------------------------------------
-- random time stimulus - sincin
-------------------------------------------------------------------------------
  random_s : process
    variable seed3, seed4 : positive;
    variable r		  	: real;
    variable int_rand	  : integer;
    variable s_r_var : integer := 0; 
  begin
    uniform(seed3, seed4, r);
    s_r_var := integer(trunc(1000.0*r));
    s_sincin <= s_r_var * 1 us;
	wait until clkaq = '1';	
  end process;  
  
-- sincin stimulus
  sincin_stim : process
  begin
    wait until clkaq = '1';
    sincin_i <= '0';
    wait for s_sincin;
    sincin_i <= '1';
    wait for 1*CLK_AQ_PERIOD;
    sincin_i <= '0';  
  end process;

  

end generic_tb_rtl;


