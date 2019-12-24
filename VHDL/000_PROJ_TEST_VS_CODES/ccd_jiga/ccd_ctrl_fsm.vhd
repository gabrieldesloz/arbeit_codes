-------------------------------------------------------------------------------
-- Title      :
-- Project    : 
-------------------------------------------------------------------------------
-- File       : 
-- Author     : 
-- Company    : 
-- Created    : 2012-08-07
-- Last update: 2015-02-11
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



library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ccd_ctrl_fsm is
  
  port (
    clkaq     : in  std_logic;
    reset     : in  std_logic;
    sincin_i  : in  std_logic;
    clrsinc_o : out std_logic;
    CCD_CLK_o : out std_logic;
    CCD_SI_o  : out std_logic;
    DIS_o     : out std_logic;
    pix_o     : out std_logic_vector (7 downto 0)  -- Pixel counter

    );

end ccd_ctrl_fsm;

architecture ARQ of ccd_ctrl_fsm is

  signal afec : std_logic_vector (15 downto 0);  -- state machine

  signal CCD_CLK:  std_logic;
  signal clrsinc, sincin                        : std_logic;

  signal CCD_SI  : std_logic;
  signal flag_si : std_logic;
  signal pix     : std_logic_vector (pix_o'range);  -- Pixel counter 
  
begin
  
  sincin     <= sincin_i;
  CCD_CLK1_o <= CCD_CLK;
  clrsinc_o  <= clrsinc;
  CCD_SI_o   <= CCD_SI;
  pix_o      <= pix;


  -- electronic shutter disabled
  DIS_o : '0';

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------

  process(clkaq, reset)                 -- 56.25MHz
  begin

    if reset = '1' then

      afec    <= "0000000000000001";
      CCD_CLK <= '0';
      flag_si <= '0';
      pix     <= x"00";
      
      
    elsif rising_edge(clkaq) then
      
      case afec is
-- 0 ----------------------------------------------------------- ---------------------------------------
        when "0000000000000001" => afec <= "0000000000000010";
                                   
                                   CCD_CLK <= '1';

                                   -- flag_si: sinaliza final de scan CCD (256 pixels)
                                   if flag_si = '1' then CCD_SI1 <= '1';
                                   else CCD_SI                   <= '0';
                                   end if;

-- 1 ----------------------------------------------------------- --------------------------------------
        when "0000000000000010" => afec <= "0000000000000100";
                                   
                                   CCD_CLK <= '0';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;
-- 2 ----------------------------------------------------------- -----------------------------
        when "0000000000000100" => afec <= "0000000000001000";
                                   
                                   CCD_CLK1 <= '0';

                                   if flag_si = '1' then CCD_SI1 <= '1';
                                   else CCD_SI                   <= '0';
                                   end if;

-- 3 ----------------------------------------------------------- --------------------------
        when "0000000000001000" => afec <= "0000000000010000";
                                   
                                   CCD_CLK <= '0'; CCD_CLK

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;
-- 4 ----------------------------------------------------------- ----------------------------------------
        when "0000000000010000" => afec <= "0000000000100000";
                                   
                                   CCD_CLK <= '0';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;

-- 5 ----------------------------------------------------------- -----------------------
        when "0000000000100000" => afec <= "0000000001000000";
                                   
                                   CCD_CLK <= '0';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;
-- 6 ----------------------------------------------------------- ------------------------
        when "0000000001000000" => afec <= "0000000010000000";
                                   
                                   CCD_CLK <= '0';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;

-- 7 ----------------------------------------------------------- ---------------------
        when "0000000010000000" => afec <= "0000000100000000";
                                   
                                   CCD_CLK <= '1';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;

-- 8 ----------------------------------------------------------- ----------------------
        when "0000000100000000" => afec <= "0000001000000000";
                                   
                                   CCD_CLK <= '1';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;

-- 9 ----------------------------------------------------------- -------------------------
        when "0000001000000000" => afec <= "0000010000000000";
                                   
                                   CCD_CLK <= '1';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;


-- 10 ----------------------------------------------------------- -------------------------
        when "0000010000000000" => afec <= "0000100000000000";
                                   
                                   CCD_CLK <= '1';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;
                                   if flag_si = '1'then flag_si <= '0'; end if;  -- finish CCD_SI pulse

-- 11 ----------------------------------------------------------- 
        when "0000100000000000" => afec <= "0000000000000001";
                                   
                                   CCD_CLK <= '1';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;

                                   pix <= pix+1;

                                   if pix = X"FF" then
                                     flag_si <= '1';  -- start CCD_SI pulse once every 256 pixels       
                                   end if;



-- 12  -- phantom state for synch purposes ----------------------------------------------------------- 
        when "0001000000000000" => afec <= "0000000000000001";
                                   
                                   CCD_CLK <= '1';

                                   if flag_si = '1' then CCD_SI <= '1';
                                   else CCD_SI                  <= '0';
                                   end if;


                                   flag_si <= '1';  -- start CCD_SI pulse once every 256 pixels
                                   
        when others => afec <= "0000000000000001";
                       
      end case;

      clrsinc <= '0';
      if sincin = '1' then
        afec    <= "0001000000000000";  -- synch phantom step
        clrsinc <= '1';
      end if;
      
    end if;
  end process;

end ARQ;

