-------------------------------------------------------------------------------
-- Title      :
-- Project    : 
-------------------------------------------------------------------------------
-- File       : 
-- Author     : 
-- Company    : 
-- Created    : 2012-08-07
-- Last update: 2014-09-01
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0              Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;  
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity clock_gen_fsm is
  
  port (
    clkaq      : in  std_logic;
    reset      : in  std_logic;
    sincin_i   : in  std_logic;
    clrsinc_o  : out std_logic;
    CCD_CLK1_o : out std_logic;
    CCD_CLK2_o : out std_logic;
    CCD_CLK3_o : out std_logic;
    CCD_CLK4_o : out std_logic;
    afeck2_o   : out std_logic;
    afeck0_o   : out std_logic;
	CCD_SI1_o, CCD_SI2_o, CCD_SI3_o, CCD_SI4_o : out std_logic;
    pix_o			: out std_logic_vector (7 downto 0);  -- Pixel counter
	ledseq_o		: out STD_LOGIC_VECTOR(2 downto 0);
	led_counter_o	: out STD_LOGIC_VECTOR(1 downto 0);
	sincout_o		: out std_logic

    );

end clock_gen_fsm;

architecture ARQ of clock_gen_fsm is

  signal afec : std_logic_vector (15 downto 0);  -- state machine

 signal afeck2, afeck0                         : std_logic;
 signal CCD_CLK1, CCD_CLK2, CCD_CLK3, CCD_CLK4 : std_logic;
 signal clrsinc, sincin                        : std_logic;
 signal flag_si			    : std_logic;
 signal pix				    : std_logic_vector (pix_o'range);  -- Pixel counter 
 signal CCD_SI1, CCD_SI2, CCD_SI3, CCD_SI4 : std_logic;
 signal led_counter : std_logic_vector (1 downto 0);
 signal ledseq : STD_LOGIC_VECTOR (2 downto 0);
 signal sincout: std_logic; 
  signal CCD_SI, CCD_CLK: std_logic;
 
 type ADC1_IN is (NONE, LOAD_CCD1_HIGH, LOAD_CCD1_LOW, LOAD_CCD2_HIGH, LOAD_CCD2_LOW);
 type ADC2_IN is (NONE, LOAD_CCD3_HIGH, LOAD_CCD3_LOW, LOAD_CCD4_HIGH, LOAD_CCD4_LOW);
 signal s_ADC1_IN: ADC1_IN;
 signal s_ADC2_IN: ADC2_IN;
 
 
 
 

 
  
begin
  
  sincin     <= sincin_i;
  CCD_CLK1_o <= CCD_CLK1;
  CCD_CLK2_o <= CCD_CLK2;
  CCD_CLK3_o <= CCD_CLK3;
  CCD_CLK4_o <= CCD_CLK4;
  afeck2_o   <= afeck2;
  afeck0_o   <= afeck0;
  clrsinc_o  <= clrsinc;
  CCD_SI1_o  <= CCD_SI1;
  CCD_SI2_o  <= CCD_SI2;
  CCD_SI3_o  <= CCD_SI3;
  CCD_SI4_o  <= CCD_SI4;
  pix_o	     <= pix;
  led_counter_o <= led_counter;
  ledseq_o 		<= ledseq;
  sincout_o 	<= sincout; 

  process(clkaq, reset)                        -- 56.25MHz
  begin

    if reset = '1' then

      afec     <= "0000000000000001";
      afeck2   <= '0';
      afeck0   <= '0';
      CCD_CLK  <= '0';
	  flag_si  <= '0';
      pix      <= x"00";
	  -- input from CCDs ADCs 
	  s_ADC1_IN <= NONE;
	  s_ADC2_IN <= NONE;
	  --- illumination control
	  LEDSEQ <= "001";     
	  sincout <= '0';
	  clrsinc <= '0';
	  led_counter <= "00";
      
    elsif rising_edge(clkaq) then
	
	 -- default input from CCDs ADCs 
	  s_ADC1_IN <= s_ADC1_IN;
	  s_ADC2_IN <= s_ADC2_IN;
      
      case afec is
-- 0 ----------------------------------------------------------- ---------------------------------------
        when "0000000000000001" => afec <= "0000000000000010";
			afeck2   <= '1'; afeck0 <= '0';
			CCD_CLK <= '1';			
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if; -- flag_si: sinaliza final de scan CCD (256 pixels)				   
			  -- board synch			
			sincout<='0';	  

			s_ADC1_IN <= NONE;
			s_ADC2_IN <= NONE;  				  
-- 1 ----------------------------------------------------------- --------------------------------------
        when "0000000000000010" => afec <= "0000000000000100";
			afeck2   <= '0'; afeck0 <= '1';
            CCD_CLK <= '0';
 			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;
				   
-- 2 ----------------------------------------------------------- -----------------------------
        when "0000000000000100" => afec <= "0000000000001000";
			afeck2   <= '0'; afeck0 <= '1';
			CCD_CLK <= '0';							   
											

-- 3 ----------------------------------------------------------- --------------------------
        when "0000000000001000" => afec <= "0000000000010000";
			afeck2   <= '0'; afeck0 <= '0';
			CCD_CLK <= '0';
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;
-- 4 ----------------------------------------------------------- ----------------------------------------
        when "0000000000010000" => afec <= "0000000000100000";
			afeck2   <= '0'; afeck0 <= '0';
			CCD_CLK <= '0';
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;
			-- load data from CCDs ADCs
			s_ADC1_IN <= LOAD_CCD1_HIGH;
			s_ADC2_IN <= LOAD_CCD3_HIGH;
-- 5 ----------------------------------------------------------- -----------------------
        when "0000000000100000" => afec <= "0000000001000000";
            afeck2   <= '0'; afeck0 <= '1';
            CCD_CLK <= '0';
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;
-- 6 ----------------------------------------------------------- ------------------------
        when "0000000001000000" => afec <= "0000000010000000";
            afeck2   <= '0'; afeck0 <= '1';
            CCD_CLK <= '0';
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;
				   
		    -- load data from CCDs ADCs
			s_ADC1_IN <= LOAD_CCD1_LOW;
			s_ADC2_IN <= LOAD_CCD3_LOW;
			
-- 7 ----------------------------------------------------------- ---------------------
        when "0000000010000000" => afec <= "0000000100000000";
            afeck2   <= '0'; afeck0 <= '0';
            CCD_CLK <= '1';
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;

-- 8 ----------------------------------------------------------- ----------------------
        when "0000000100000000" => afec <= "0000001000000000";
            afeck2   <= '0'; afeck0 <= '0';
            CCD_CLK <= '1';
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;
				   
				  -- load data from CCDs ADCs
			s_ADC1_IN <= LOAD_CCD2_HIGH;
			s_ADC2_IN <= LOAD_CCD4_HIGH;  				   
		
-- 9 ----------------------------------------------------------- -------------------------
        when "0000001000000000" => afec <= "0000010000000000";
            afeck2   <= '0'; afeck0 <= '1';
            CCD_CLK <= '1';
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;


-- 10 ----------------------------------------------------------- -------------------------
        when "0000010000000000" => afec <= "0000100000000000";
            afeck2   <= '0'; afeck0 <= '1';
            CCD_CLK <= '1';
				   
			if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;				   
			if flag_si = '1' then flag_si  <= '0'; end if;  -- finish CCD_SI pulse
				   
				   
			   -- sinc generation
			if pix=X"FF" then
				case LEDSEQ is
				    when "100" => sincout<='1'; 
					when others => sincout<='0';
				end case;
			else
				sincout<='0';			  
			 end if;
			 
			    -- load data from CCDs ADCs
				s_ADC1_IN <= LOAD_CCD2_LOW;
				s_ADC2_IN <= LOAD_CCD4_LOW;  			  
			  
			  
-- 11 ----------------------------------------------------------- 
        when "0000100000000000" => afec <= "0000000000000001";
                   afeck2   <= '0'; afeck0 <= '0';
                   CCD_CLK <= '1';
 				   if flag_si = '1' then CCD_SI <= '1'; else CCD_SI <= '0';   end if;

				   pix <= pix+1;

					--- detecta ultimo pixel do ccd
					--- se sim, altera configurações de iluminação
				   if pix = X"FF" then
							flag_si <= '1';  -- start CCD_SI pulse once every 256 pixels
								 
							case LEDSEQ is							 
								when "001" => 
								      LEDSEQ<="010";  
									  led_counter<="01"; -- illum front ON, store REAR													  
									  			  
								when "010" => 
									  LEDSEQ<="100"; 
									  led_counter<="10"; -- illum bckgnd OFF, store FRONT													  
									
													  
								when "100" => 									
									  LEDSEQ<="001";
									  led_counter<="00"; -- illum rear ON, store BackGnd																					 
								      sincout<='1'; -- ultima iluminacao processada, amnda sinal sincronismo			  
													  
								 when others => 									
									  led_counter<="00"; 
									  LEDSEQ<="001";
							  
							  end case;
						else
							sincout<='0';
				   	end if;

-- 12  -- phantom state for synch purposes ----------------------------------------------------------- 
        when "0001000000000000" => afec <= "0000000000000001";
			afeck2   <= '0'; afeck0 <= '0';
            CCD_CLK <= '1';
								   
								   -- synchronization
								
								   led_counter<="00"; -- illum rear ON, store BackGnd
								   sincout <='0';
                                   
        when others => afec <= "0000000000000001";
                       
			   if flag_si = '1' then CCD_SI <= '1' else CCD_SI <= '0'; end if; 			  
			   flag_si <= '1';  -- start CCD_SI pulse once every 256 pixels
      
	  end case;

      clrsinc <= '0';
      if sincin = '1' then
        afec    <= "0001000000000000";  -- synch phantom step (step 12)
        clrsinc <= '1';
      end if;
      
    end if;
  end process;

  
  CCD_SI1 <=   CCD_SI; 
  CCD_SI2 <=   CCD_SI; 
  CCD_SI3 <=   CCD_SI; 
  CCD_SI4 <=   CCD_SI; 
  CCD_CLK1 <=  CCD_CLK;
  CCD_CLK2 <=  CCD_CLK;
  CCD_CLK3 <=  CCD_CLK;
  CCD_CLK4 <=  CCD_CLK;
  
 
  
  
end ARQ;

