-------------------------------------------------------------------------------
-- Title      :
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : 
-- Author     : 
-- Company    : 
-- Created    : 2012-08-07
-- Last update: 2014-09-18
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



library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library UNISIM;
use UNISIM.VComponents.all;

entity first_sm_mono_color is
  
  port (
    clkaq										   : in	 std_logic;
    reset										   : in	 std_logic;
    s_has_new_o										   : out std_logic;
    sincout_o										   : out std_logic;
    clrsinc_o										   : out std_logic;
    clkb_o										   : out std_logic;
    clkbb_o										   : out std_logic;
    wena_o										   : out std_logic_vector(0 downto 0);
    wenab_o										   : out std_logic_vector(0 downto 0);
    wena2_o										   : out std_logic_vector(0 downto 0);
    wena2b_o										   : out std_logic_vector(0 downto 0);
    extevent_flag_o									   : out std_logic;
    s_bkgnd_mult_o									   : out std_logic;
    s_ma_we_o										   : out std_logic_vector(0 downto 0);
    s_ma2_we_o										   : out std_logic_vector(0 downto 0);
    s_mab_we_o										   : out std_logic_vector(0 downto 0);
    s_ma2b_we_o										   : out std_logic_vector(0 downto 0);
    s_extclr_bckgnd_gain_o								   : out std_logic;
    afeck2_o, afeck0_o									   : out std_logic;
    CCD_CLK1_o, CCD_CLK2_o, CCD_CLK3_o, CCD_CLK4_o					   : out std_logic;
    CCD_SI1_o, CCD_SI2_o, CCD_SI3_o, CCD_SI4_o						   : out std_logic;
    proc_o										   : out std_logic_vector(2 downto 0);
    multipmux_o										   : out std_logic;
    ledseq_o										   : out std_logic_vector(2 downto 0);
    led_counter_o									   : out std_logic_vector(1 downto 0);
    led_duration_o									   : out std_logic_vector(7 downto 0);
    ledout_o										   : out std_logic_vector(2 downto 0);
    pix_o										   : out std_logic_vector (7 downto 0);	 -- Pixel counter
    canincfifoline_o									   : out std_logic;
    s_bgnd_floor_o									   : out std_logic;
    s_illum_floor_o									   : out std_logic;
    wenaf_b_o, wenaf_r_o, wenaf_f_o, wenaffl_o						   : out std_logic_vector(0 downto 0);
    extclr_o										   : out std_logic;
    LED_duration_rear_i, LED_duration_bckgnd_i, LED_duration_front_i			   : in	 std_logic_vector(7 downto 0);
    sincin_i										   : in	 std_logic;
    s_bgnd_floor_int_i									   : in	 std_logic;
    s_bgnd_off_i									   : in	 std_logic;
    s_illum_floor_int_i									   : in	 std_logic;
    extpart_i										   : in	 std_logic_vector (1 downto 0);
    extevent_flag_i									   : in	 std_logic;
    exttype_i										   : in	 std_logic;
    extdataread_o									   : out std_logic_vector(15 downto 0);
    datab_i, datab2_i, databb_i, datab2b_i						   : in	 std_logic_vector(15 downto 0);
    s_bckgnd_mem_Sel_i									   : in	 std_logic_vector(1 downto 0);
    acc_o, accb_o, acc2_o, acc2b_o							   : out std_logic_vector (15 downto 0);  -- ACCumulator and register for ALU
    ccd1_o , ccd2_o , ccd3_o , ccd4_o , ccdt1_o, ccdt2_o				   : out std_logic_vector (15 downto 0);  -- pixel data for each camera
    ADC1_i, ADC2_i									   : in	 std_logic_vector (7 downto 0);
    fifoline_o , fifolinew_o , s_fifolinew_new_o , s_fifoline_last_o			   : out std_logic_vector (2 downto 0);	 -- points the previous line and current line being written on FIFO
    s_bkgnd_ma_gain_o, s_bkgnd_ma2_gain_o, s_bkgnd_mab_gain_o, s_bkgnd_ma2b_gain_o	   : out std_logic_vector(15 downto 0);
    s_ma_gain_mem_out_i, s_ma2_gain_mem_out_i, s_mab_gain_mem_out_i, s_ma2b_gain_mem_out_i : in	 std_logic_vector(15 downto 0);
    s_acc_in_o										   : out std_logic_vector (63 downto 0);  -- Mean Input
    s_is_transluc_o, s_is_reflect_o							   : out std_logic_vector (0 downto 0);
    mp_i, mpb_i, mp2_i, mp2b_i								   : in	 std_logic_vector (31 downto 0);  -- multiplier out
    extevent_req_i									   : in	 std_logic;
    a_o, ab_o, a2_o, a2b_o								   : out std_logic_vector (15 downto 0);
    s_extevent_bckgnd_gain_req_i							   : in	 std_logic

    );

end first_sm_mono_color;

architecture ARQ of first_sm_mono_color is

  signal s_has_new									: std_logic;
  signal sincout									: std_logic;
  signal clrsinc									: std_logic;
  signal clkb, clkbb									: std_logic;
  signal extclr										: std_logic;
  signal s_bkgnd_mult									: std_logic;
  signal wena, wenab, wena2, wena2b							: std_logic_vector(0 downto 0);
  signal s_ma_we, s_ma2_we, s_mab_we, s_ma2b_we						: std_logic_vector(0 downto 0);
  signal s_extclr_bckgnd_gain								: std_logic;
  signal s_extevent_bckgnd_gain_flag							: std_logic;
  signal afec										: std_logic_vector (15 downto 0);
  signal afeck2, afeck0									: std_logic;
  signal CCD_CLK1, CCD_CLK2, CCD_CLK3, CCD_CLK4						: std_logic;
  signal CCD_SI1, CCD_SI2, CCD_SI3, CCD_SI4						: std_logic;
  signal flag_si									: std_logic;
  signal proc										: std_logic_vector (2 downto 0);  -- scan line source for ALU process
  signal multipmux									: std_logic;
  signal ledseq										: std_logic_vector(2 downto 0);
  signal led_counter									: std_logic_vector(1 downto 0);
  signal led_duration									: std_logic_vector(led_duration_o'range);
  signal ledout										: std_logic_vector(ledout_o'range);
  signal pix										: std_logic_vector (pix_o'range);  -- Pixel counter
  signal canincfifoline									: std_logic;
  signal s_bgnd_floor									: std_logic;
  signal s_illum_floor									: std_logic;
  signal wenaf_b, wenaf_r, wenaf_f, wenaffl						: std_logic_vector(0 downto 0);
  signal LED_duration_rear								: std_logic_vector(LED_duration_rear_i'range);
  signal LED_duration_bckgnd								: std_logic_vector(LED_duration_bckgnd_i'range);
  signal LED_duration_front								: std_logic_vector(LED_duration_front_i'range);
  signal sincin										: std_logic;
  signal s_bgnd_floor_int								: std_logic;
  signal s_bgnd_off									: std_logic;
  signal s_illum_floor_int								: std_logic;
  signal extpart									: std_logic_vector (1 downto 0);
  signal extevent_flag									: std_logic;
  signal exttype									: std_logic;
  signal extdataread									: std_logic_vector(extdataread_o'range);
  signal datab, datab2, databb, datab2b							: std_logic_vector (datab_i'range);
  signal s_bckgnd_mem_Sel								: std_logic_vector(1 downto 0);
  signal acc, accb, acc2, acc2b								: std_logic_vector (15 downto 0);  -- ACCumulator and register for ALU
  signal ccd1, ccd2, ccd3, ccd4, ccdt1, ccdt2						: std_logic_vector (15 downto 0);  -- pixel data for each camera
  signal ADC1, ADC2									: std_logic_vector (7 downto 0);
  signal fifoline, fifolinew, s_fifolinew_new, s_fifoline_last				: std_logic_vector (2 downto 0);  -- points the previous line and current line being written on FIFO
  signal s_bkgnd_ma_gain, s_bkgnd_ma2_gain, s_bkgnd_mab_gain, s_bkgnd_ma2b_gain		: std_logic_vector(15 downto 0);
  signal s_ma_gain_mem_out, s_ma2_gain_mem_out, s_mab_gain_mem_out, s_ma2b_gain_mem_out : std_logic_vector(15 downto 0);
  signal s_acc_in									: std_logic_vector (63 downto 0);
  signal s_is_transluc, s_is_reflect							: std_logic_vector (0 downto 0);
  signal mp, mpb, mp2, mp2b								: std_logic_vector (31 downto 0);  -- multiplier out
  signal extevent_req									: std_logic;
  signal a, ab, a2, a2b									: std_logic_vector (15 downto 0);
  signal s_extevent_bckgnd_gain_req							: std_logic;


begin
  
  s_has_new_o		     <= s_has_new;
  sincout_o		     <= sincout;
  clrsinc_o		     <= clrsinc;
  clkb_o		     <= clkb;
  clkbb_o		     <= clkbb;
  wena_o		     <= wena;
  wenab_o		     <= wenab;
  wena2_o		     <= wena2;
  wena2b_o		     <= wena2b;
  extclr_o		     <= extclr;
  extevent_flag_o	     <= extevent_flag;
  s_bkgnd_mult_o	     <= s_bkgnd_mult;
  s_ma_we_o		     <= s_ma_we;
  s_ma2_we_o		     <= s_ma2_we;
  s_mab_we_o		     <= s_mab_we;
  s_ma2b_we_o		     <= s_ma2b_we;
  s_extclr_bckgnd_gain_o     <= s_extclr_bckgnd_gain;
  afeck2_o		     <= afeck2;
  afeck0_o		     <= afeck0;
  CCD_CLK1_o		     <= CCD_CLK1;
  CCD_CLK2_o		     <= CCD_CLK2;
  CCD_CLK3_o		     <= CCD_CLK3;
  CCD_CLK4_o		     <= CCD_CLK4;
  CCD_SI1_o		     <= CCD_SI1;
  CCD_SI2_o		     <= CCD_SI2;
  CCD_SI3_o		     <= CCD_SI3;
  CCD_SI4_o		     <= CCD_SI4;
  proc_o		     <= proc;
  multipmux_o		     <= multipmux;
  ledseq_o		     <= ledseq;
  led_counter_o		     <= led_counter;
  ledout_o		     <= ledout;
  pix_o			     <= pix;
  canincfifoline_o	     <= canincfifoline;
  fifoline_o		     <= fifoline;
  s_bgnd_floor_o	     <= s_bgnd_floor;
  s_illum_floor_o	     <= s_illum_floor;
  wenaf_b_o		     <= wenaf_b;
  wenaf_r_o		     <= wenaf_r;
  wenaf_f_o		     <= wenaf_f;
  wenaffl_o		     <= wenaffl;
  LED_duration_rear	     <= LED_duration_rear_i;
  sincin		     <= sincin_i;
  s_bgnd_floor_int	     <= s_bgnd_floor_int_i;
  LED_duration_bckgnd	     <= LED_duration_bckgnd_i;
  s_bgnd_off		     <= s_bgnd_off_i;
  s_illum_floor_int	     <= s_illum_floor_int_i;
  extpart		     <= extpart_i;
  extevent_flag		     <= extevent_flag_i;
  exttype		     <= exttype_i;
  extdataread_o		     <= extdataread;
  datab			     <= datab_i;
  datab2		     <= datab2_i;
  databb		     <= databb_i;
  datab2b		     <= datab2b_i;
  s_bckgnd_mem_Sel	     <= s_bckgnd_mem_Sel_i;
  acc_o			     <= acc;
  accb_o		     <= accb;
  acc2_o		     <= acc2;
  acc2b_o		     <= acc2b;
  ccd1_o		     <= ccd1;
  ccd2_o		     <= ccd2;
  ccd3_o		     <= ccd3;
  ccd4_o		     <= ccd4;
  ccdt1_o		     <= ccdt1;
  ccdt2_o		     <= ccdt2;
  ADC1			     <= ADC1_i;
  ADC2			     <= ADC2_i;
  fifoline_o		     <= fifoline;
  fifolinew_o		     <= fifolinew;
  s_fifolinew_new_o	     <= s_fifolinew_new;
  s_fifoline_last_o	     <= s_fifoline_last;
  s_bkgnd_ma_gain_o	     <= s_bkgnd_ma_gain;
  s_bkgnd_ma2_gain_o	     <= s_bkgnd_ma2_gain;
  s_bkgnd_mab_gain_o	     <= s_bkgnd_mab_gain;
  s_bkgnd_ma2b_gain_o	     <= s_bkgnd_ma2b_gain;
  s_ma_gain_mem_out	     <= s_ma_gain_mem_out_i;
  s_ma2_gain_mem_out	     <= s_ma2_gain_mem_out_i;
  s_mab_gain_mem_out	     <= s_mab_gain_mem_out_i;
  s_ma2b_gain_mem_out	     <= s_ma2b_gain_mem_out_i;
  s_acc_in_o		     <= s_acc_in;
  s_is_transluc_o	     <= s_is_transluc;
  s_is_reflect_o	     <= s_is_reflect;
  mp			     <= mp_i;
  mpb			     <= mpb_i;
  mp2			     <= mp2_i;
  mp2b			     <= mp2b_i;
  extevent_req		     <= extevent_req_i;
  a_o			     <= a;
  ab_o			     <= ab;
  a2_o			     <= a2;
  a2b_o			     <= a2b;
  s_extevent_bckgnd_gain_req <= s_extevent_bckgnd_gain_req_i;

  process(clkaq, reset)			-- 56.25MHz  
  begin
    if reset = '1' then
      -- Mean 16k
      s_has_new <= '0';
      sincout	<= '0';
      clrsinc	<= '0';
      clkb	<= '0';
      clkbb	<= '0';
      wena(0)	<= '0';
      wena2(0)	<= '0';
      wenab(0)	<= '0';
      wena2b(0) <= '0';

      extclr	    <= '0';
      extevent_flag <= '0';
      ----------------------------------
      -- multiplier input multiplexer -- 
      ----------------------------------

      s_bkgnd_mult		  <= '0';
      s_ma_we			  <= "0";
      s_ma2_we			  <= "0";
      s_mab_we			  <= "0";
      s_ma2b_we			  <= "0";
      s_extclr_bckgnd_gain	  <= '0';
      s_extevent_bckgnd_gain_flag <= '0';
      ----------------------------------

      afec	     <= "0000000000000001";
      afeck2	     <= '0';
      afeck0	     <= '0';
      CCD_CLK1	     <= '0';
      CCD_CLK2	     <= '0';
      CCD_CLK3	     <= '0';
      CCD_CLK4	     <= '0';
      CCD_SI1	     <= '0';		-- start integration - reseta o ccd
      CCD_SI2	     <= '0';
      CCD_SI3	     <= '0';
      CCD_SI4	     <= '0';
      flag_si	     <= '0';
      proc	     <= "111";	-- default addressing gain correctiondata
      multipmux	     <= '0';		-- multiplier source is memory
      ledseq	     <= "001";
      led_counter    <= "00";
      led_duration   <= X"F0";		--led_duration_rear;
      ledout	     <= "010";
      pix	     <= x"00";
      canincfifoline <= '0';
      fifoline	     <= "000";
      s_bgnd_floor   <= '0';  -- If there is a floor then store floor info for background
      s_illum_floor  <= '0';
      
    elsif rising_edge(clkaq) then
-- defaults	  
      extclr	<= '0';
      clkb	<= '0';
      clkbb	<= '0';
      wena(0)	<= '0';
      wena2(0)	<= '0';
      wenab(0)	<= '0';
      wena2b(0) <= '0';

      ----------------------------------
      -- multiplier input multiplexer -- 
      ----------------------------------
      s_ma_we	<= "0";
      s_ma2_we	<= "0";
      s_mab_we	<= "0";
      s_ma2b_we <= "0";

      s_extclr_bckgnd_gain <= '0';
      ----------------------------------

      wenaf_b(0) <= '0';
      wenaf_r(0) <= '0';
      wenaf_f(0) <= '0';

      proc <= "111";  -- default addressing gain correctiondata

      case afec is
-- 0 ----------------------------------------------------------- ---------------------------------------
	when "0000000000000001" => afec <= "0000000000000010";
				   -- AFE
				   -- analog front end clocks
				   -- afeck0 --> afeck - clock adc com atraso
				   -- afeck2 --> clock adc sem atraso
				   afeck2			 <= '1'; afeck0 <= '0';
				   -- CCD
				   CCD_CLK1			 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
				   -- flag_si: sinaliza final de scan CCD (256 pixels)
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;
				   -- ALU

				   ----------------------------------
				   -- multiplier input multiplexer -- 
				   ----------------------------------
				   s_bkgnd_mult <= '0';
				   ----------------------------------
				   -- qual iluminação está sendo processada - começa com a traseira
				   case led_counter is
				     when "00" => proc <= "100"; when "01" => proc <= "101"; when "10" => proc <= "110"; when others => proc<="111";
				   end case;
				   -- front end memory
				   wena(0)   <= '1';
				   wena2(0)  <= '1';
				   wenab(0)  <= '1';
				   wena2b(0) <= '1';

				   -- Line FIFO
				   case led_counter is
				     when "00"	 => wenaf_b(0) <= '1';
				     when "01"	 => wenaf_r(0) <= '1';
				     when "10"	 => wenaf_f(0) <= '1';
				     when others => wenaffl(0) <= '0';
				   end case;
				   -- board synch			
				   sincout <= '0';

-- 1 ----------------------------------------------------------- --------------------------------------
				   -- le a imagem (ja esta disponivel)
	when "0000000000000010" => afec <= "0000000000000100";
				   -- AFE
				   -- analog front end clocks
				   afeck2			 <= '0'; afeck0 <= '1';
				   -- CCD
				   CCD_CLK1			 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;
				   -- ALU
				   clkb				 <= '1';  -- read B side of memory (IMAGE)
				   clkbb			 <= '1';
				   case led_counter is
				     -- proc é uma parte do endereço sendo colocado na memoria
				     when "00" => proc <= "100"; when "01" => proc <= "101"; when "10" => proc <= "110"; when others => proc<="111";
				   end case;
				   -- Line FIFO

				   -- pode incrementar a linha da fifo?	 flag = '1' 
				   -- como funciona o incremento da fifo??
				   if canincfifoline = '1' then
				     s_fifoline_last <= fifoline;
				     fifoline	     <= fifoline + 1;
				     fifolinew	     <= fifoline + 2;
				     s_fifolinew_new <= fifoline + 3;
				   end if;

-- 2 ----------------------------------------------------------- -----------------------------
	when "0000000000000100" => afec <= "0000000000001000";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '1';
				   -- CCD
				   CCD_CLK1			 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;
				   -- ALU
				   -- testa led para ler floor de acordo com iluminação??
				   case led_counter is
				     when "00" => proc <= "000"; when "01" => proc <= "001"; when "10" => proc <= "010"; when others => proc<="111";
				   end case;
				   -- move Image to ACC

				   -- acc - imagem processada 
				   -- não é mais adicionado o offset
				   acc	 <= datab;  --+ X"04A0"; -- add offset to handle with negative signals after FLOOR correction
				   acc2	 <= datab2;   --+ X"04A0";
				   accb	 <= databb;   --+ X"04A0";
				   acc2b <= datab2b;  --+ X"04A0";

				   -- Line FIFO
				   if canincfifoline = '1' then
				     canincfifoline <= '0';  -- this will release the sorting state machine
				   end if;


				   -- Illumination
				   -- apaga leds ?? (decremento ocorre a cada 18*(nro estados) ns)		 
				   if LED_duration > X"00" then
				     LED_duration <= LED_duration-1;
				   else
				     LEDOUT <= "000";  -- turn OFF all lEDs
				   end if;

-- 3 ----------------------------------------------------------- --------------------------
	when "0000000000001000" => afec <= "0000000000010000";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '0';
				   -- CCD
				   CCD_CLK1			 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;
				   -- ALU
				   -- agora o conteudo da memoria é a informação de floor de acordo
				   -- com a iluminação sendo processada
				   clkb				 <= '1';  -- read B side of memory (FLOOR)
				   clkbb			 <= '1';
				   case led_counter is
				     when "00" => proc <= "000"; when "01" => proc <= "001"; when "10" => proc <= "010"; when others => proc<="111";
				   end case;

-- 4 ----------------------------------------------------------- ----------------------------------------
	when "0000000000010000" => afec <= "0000000000100000";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '0';
				   ccd1(13 downto 6)		 <= adc1;
				   ccd1(15 downto 14)		 <= "00";
				   ccd3(13 downto 6)		 <= adc2;
				   ccd3(15 downto 14)		 <= "00";
				   -- CCD
				   CCD_CLK1			 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;
				   -- ALU
				   -- select gain table according to illumination process
				   -- le ganho conforme iluminação sendo processada??
				   case led_counter is
				     when "00" =>
				       proc	    <= "111";
					----------------------------------									
					-- multiplier input multiplexer -- 
					----------------------------------
				       s_bkgnd_mult <= '1';
					----------------------------------
				       
				     when "01"	 => proc <= "011";
				     when "10"	 => proc <= "111";
				     when others => proc <= "111";
				   end case;

				   -- preparação do multiplexador
				   ----------------------------------
				   -- multiplier input multiplexer -- 
				   ----------------------------------
				   s_bkgnd_ma_gain   <= s_ma_gain_mem_out;
				   s_bkgnd_ma2_gain  <= s_ma2_gain_mem_out;
				   s_bkgnd_mab_gain  <= s_mab_gain_mem_out;
				   s_bkgnd_ma2b_gain <= s_ma2b_gain_mem_out;
				   ----------------------------------

				   -- subtract FLOOR from ACC
				   if (acc <= datab) then  -- Tests if the raw image value (acc) is lower than floor value (datab) to avoid "underflow"
				     acc <= (others => '0');  -- If the value is lower than floor value than set to 0
				   else
				     acc <= acc-datab;	-- Otherwise subtract floor value
				   end if;

				   if (acc2 <= datab2) then
				     acc2 <= (others => '0');
				   else
				     acc2 <= acc2-datab2;
				   end if;

				   if (accb <= databb) then
				     accb <= (others => '0');
				   else
				     accb <= accb-databb;
				   end if;

				   if (acc2b <= datab2b) then
				     acc2b <= (others => '0');
				   else
				     acc2b <= acc2b-datab2b;
				   end if;

				   -- insere os dados do ganho na netrada do mux??			
				   multipmux <= '0';  -- multiplier source is memory


-- 5 ----------------------------------------------------------- -----------------------
	when "0000000000100000" => afec <= "0000000001000000";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '1';
				   -- CCD
				   CCD_CLK1			 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;
				   -- ALU
				   -- select gain table according to illumination process
				   case led_counter is
				     when "00" =>
				       proc	    <= "111";
					----------------------------------
					-- multiplier input multiplexer -- 
					----------------------------------
				       s_bkgnd_mult <= '1';
					----------------------------------
				       
				     when "01"	 => proc <= "011";
				     when "10"	 => proc <= "111";
				     when others => proc <= "111";
				   end case;

				   clkb	 <= '1';  -- read B side of memory (GAIN) - le o ganho conforme iluminação sendo processada
				   clkbb <= '1';

-- 6 ----------------------------------------------------------- ------------------------
	when "0000000001000000" => afec <= "0000000010000000";
				   -- AFE
				   --??
				   afeck2			 <= '0'; afeck0 <= '1';
				   ccd1(5 downto 0)		 <= adc1(7 downto 2);
				   ccd3(5 downto 0)		 <= adc2(7 downto 2);
				   -- CCD
				   CCD_CLK1			 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;

				   -- entra no modulo de correção de ganho -
				   -- i_MEAN_16K : MEAN_16K
				   s_acc_in <= (acc & acc2 & accb & acc2b);

				   -- ALU
				   -- let the multiplication happen (latency)

-- 7 ----------------------------------------------------------- ---------------------
	when "0000000010000000" => afec <= "0000000100000000";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '0';
				   -- CCD
				   CCD_CLK1			 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;

				   -- verifica se iluminação é background, se for background ganho não é aplicado;
				   -- Mean 16k
				   if s_has_new = '1' then
				     s_is_transluc <= "0";
				     s_is_reflect  <= "0";
				   else
				     if led_counter = "01" then
				       s_is_transluc <= "1";
				       s_is_reflect  <= "0";
				     elsif led_counter = "10" then
				       s_is_transluc <= "0";
				       s_is_reflect  <= "1";
				     else
				       s_is_transluc <= "0";
				       s_is_reflect  <= "0";
				     end if;
				   end if;

				   -- ALU

				   ----------------------------------
				   -- multiplier input multiplexer -- 
				   ----------------------------------
				   s_bkgnd_mult <= '0';
				   ----------------------------------

				   -- store multiplier result
--				if led_counter/="00" then -- do not use result when reading background data (bckGnd is always multiplied by 1.0)

				   if mp(31 downto 24) /= "00000000" then  -- Tests if the multiplication resulted an overflow (any bit above 23rd is 1)
				     acc <= X"FFFF";  -- If there is an overflow set the value to FFFF
				   else
				     acc <= mp(23 downto 8);  -- Else gets the multiplication value
				   end if;

				   if mp2(31 downto 24) /= "00000000" then
				     acc2 <= X"FFFF";
				   else
				     acc2 <= mp2(23 downto 8);
				   end if;

				   if mpb(31 downto 24) /= "00000000" then
				     accb <= X"FFFF";
				   else
				     accb <= mpb(23 downto 8);
				   end if;

				   if mp2b(31 downto 24) /= "00000000" then
				     acc2b <= X"FFFF";
				   else
				     acc2b <= mp2b(23 downto 8);
				   end if;

				   -- ext access
				   if extevent_req = '1' then
				     extevent_flag <= '1';
				   end if;

				   ----------------------------------
				   -- multiplier input multiplexer -- 
				   ----------------------------------
				   if s_extevent_bckgnd_gain_req = '1' then
				     s_extevent_bckgnd_gain_flag <= '1';
				   end if;
				   ----------------------------------


				   multipmux <= '1';  -- next multiplier source is group_gain

-- 8 ----------------------------------------------------------- ----------------------
	when "0000000100000000" => afec <= "0000001000000000";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '0';
				   ccd2(13 downto 6)		 <= adc1;
				   ccd2(15 downto 14)		 <= "00";
				   ccd4(13 downto 6)		 <= adc2;
				   ccd4(15 downto 14)		 <= "00";
				   -- CCD
				   CCD_CLK1			 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;
				   -- ALU
				   -- let multiplication happen (latency)

-- 9 ----------------------------------------------------------- -------------------------
	when "0000001000000000" => afec <= "0000010000000000";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '1';
				   -- CCD
				   CCD_CLK1			 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;

				   -- MEAN
				   s_is_transluc <= "0";
				   s_is_reflect	 <= "0";

				   -- external access front-end
				   clkb	 <= '1';  -- read B side 
				   clkbb <= '1';

-- 10 ----------------------------------------------------------- -------------------------
	when "0000010000000000" => afec <= "0000100000000000";
				   -- AFE
				   --??
				   afeck2			 <= '0'; afeck0 <= '1';
				   ccd2(5 downto 0)		 <= adc1(7 downto 2);
				   ccd4(5 downto 0)		 <= adc2(7 downto 2);
				   -- CCD
				   CCD_CLK1			 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;

				   -- recebe a informação corrigida
				   a   <= mp(23 downto 8);
				   a2  <= mp2(23 downto 8);
				   ab  <= mpb(23 downto 8);
				   a2b <= mp2b(23 downto 8);

				   ----------------------------------
				   -- multiplier input multiplexer -- 
				   ----------------------------------
				   if (s_extevent_bckgnd_gain_flag = '1') then	-- read, muxes are already set
				     case s_bckgnd_mem_sel is
				       when "00"   => s_ma_we	<= "1";
				       when "01"   => s_ma2_we	<= "1";
				       when "10"   => s_mab_we	<= "1";
				       when "11"   => s_ma2b_we <= "1";
				       when others =>
				     end case;
				   else
				     -- ext access
				     if (extevent_flag = '1') and (exttype = '0') then	-- read, muxes are already set
				       case extpart is
					 when "00"   => extdataread <= datab;  -- datab;
					 when "01"   => extdataread <= datab2;	--datab2;
					 when "10"   => extdataread <= databb;
					 when "11"   => extdataread <= datab2b;
					 when others =>
				       end case;
				     end if;

				     if (extevent_flag = '1') and (exttype = '1') then	-- read, muxes are already set
				       case extpart is	-- write enable, muxes are already set
					 when "00"   => wena(0)	  <= '1';
					 when "01"   => wena2(0)  <= '1';
					 when "10"   => wenab(0)  <= '1';
					 when "11"   => wena2b(0) <= '1';
					 when others =>
				       end case;
				     end if;
				   end if;
				   ----------------------------------


				   -- front end memory & illumination
				   if flag_si = '1'then flag_si <= '0'; end if;	 -- finish CCD_SI pulse

--		   -- sinc generation
				   if pix = X"FF" then
				     case LEDSEQ is
				       when "100"  => sincout <= '1';
				       when others => sincout <= '0';
				     end case;
				   else
				     sincout <= '0';
				   end if;



-- 11 ----------------------------------------------------------- 
	when "0000100000000000" => afec <= "0000000000000001";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '0';
				   -- CCD
				   CCD_CLK1			 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;

				   -- ext access
				   if extevent_flag = '1' then
				     extevent_flag <= '0';
				     extclr	   <= '1';
				   end if;

				   ----------------------------------
				   -- multiplier input multiplexer -- 
				   ----------------------------------
				   if s_extevent_bckgnd_gain_flag = '1' then
				     s_extevent_bckgnd_gain_flag <= '0';
				     s_extclr_bckgnd_gain	 <= '1';
				   end if;
				   ----------------------------------

				   -- front end memory & illumination & FIFO

				   pix <= pix+1;

				   if pix = X"FF" then
				     
				     flag_si <= '1';  -- start CCD_SI pulse once every 256 pixels

				     case LEDSEQ is
				       when "001" => LEDSEQ <= "010";
						     LEDOUT	 <= "001";
						     led_counter <= "01";  -- illum front ON, store REAR

						     s_illum_floor <= s_illum_floor_int;  -- If there is a floor then store floor info for rear illumination
						     s_bgnd_floor  <= '0';

						     LED_duration <= LED_duration_front;
						     
				       when "010" => LEDSEQ <= "100";
						     led_counter <= "10";  -- illum bckgnd OFF, store FRONT

						     s_illum_floor <= s_illum_floor_int;  -- If there is a floor then store floor info for front illumination
						     s_bgnd_floor  <= '0';

						     if (s_bgnd_off = '1') then
						       LEDOUT <= "000";
						     else
						       LEDOUT <= "100";
						     end if;

						     LED_duration <= LED_duration_bckgnd;
				       when "100" => LEDSEQ <= "001";
						     LEDOUT <= "010";

						     led_counter <= "00";  -- illum rear ON, store BackGnd

						     s_bgnd_floor  <= s_bgnd_floor_int;	 -- If there is a floor then store floor info for background
						     s_illum_floor <= '0';

						     LED_duration <= LED_duration_rear;
						     sincout	  <= '1';

						     canincfifoline <= '1';

					-- Mean 16k
						     s_has_new <= (not(s_has_new));
						     
						     
				       when others => LEDOUT <= "000"; led_counter <= "00"; LEDSEQ <= "001";
				     end case;
				   else
				     sincout <= '0';
				   end if;


-- 12  -- phantom state for synch purposes ----------------------------------------------------------- 
	when "0001000000000000" => afec <= "0000000000000001";
				   -- AFE
				   afeck2			 <= '0'; afeck0 <= '0';
				   -- CCD
				   CCD_CLK1			 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
				   if flag_si = '1' then CCD_SI1 <= '1'; CCD_SI2 <= '1'; CCD_SI3 <= '1'; CCD_SI4 <= '1';
				   else CCD_SI1			 <= '0'; CCD_SI2 <= '0'; CCD_SI3 <= '0'; CCD_SI4 <= '0';
				   end if;

				   -- ext access
				   if extevent_flag = '1' then
				     extevent_flag <= '0';
				     extclr	   <= '1';
				   end if;

				   ----------------------------------
				   -- multiplier input multiplexer -- 
				   ----------------------------------
				   if s_extevent_bckgnd_gain_flag = '1' then
				     s_extevent_bckgnd_gain_flag <= '0';
				     s_extclr_bckgnd_gain	 <= '1';
				   end if;
				   ----------------------------------

				   -- synchronization -----------------------------	
				   flag_si <= '1';  -- start CCD_SI pulse once every 256 pixels

				   pix		<= X"00";
				   LEDSEQ	<= "001";
				   LEDOUT	<= "010";
				   led_counter	<= "00";  -- illum rear ON, store BackGnd
				   LED_duration <= LED_duration_rear;

				   s_bgnd_floor	 <= s_bgnd_floor_int;  -- If there is a floor then store floor info for background
				   s_illum_floor <= '0';

				   canincfifoline <= '1';

				   -- Mean 16k
				   s_has_new <= (not(s_has_new));
				   sincout   <= '0';


	when others => afec <= "0000000000000001";
      end case;

      -- board synch	 
      clrsinc <= '0';
      if sincin = '1' then
	afec	<= "0001000000000000";	-- synch phantom step
	clrsinc <= '1';
      end if;
      
    end if;
  end process;

end ARQ;

