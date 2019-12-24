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
    afeck0_o   : out std_logic
    );

end clock_gen_fsm;

architecture ARQ of clock_gen_fsm is

  signal afec : std_logic_vector (15 downto 0);  -- state machine

  signal afeck2, afeck0                         : std_logic;
  signal CCD_CLK1, CCD_CLK2, CCD_CLK3, CCD_CLK4 : std_logic;
  signal clrsinc, sincin                        : std_logic;
  
begin
  
  sincin     <= sincin_i;
  CCD_CLK1_o <= CCD_CLK1;
  CCD_CLK2_o <= CCD_CLK2;
  CCD_CLK3_o <= CCD_CLK3;
  CCD_CLK4_o <= CCD_CLK4;
  afeck2_o   <= afeck2;
  afeck0_o   <= afeck0;
  clrsinc_o  <= clrsinc;

  process(clkaq, reset)                        -- 56.25MHz
  begin

    if reset = '1' then

      afec     <= "0000000000000001";
      afeck2   <= '0';
      afeck0   <= '0';
      CCD_CLK1 <= '0';
      CCD_CLK2 <= '0';
      CCD_CLK3 <= '0';
      CCD_CLK4 <= '0';
      
      
    elsif rising_edge(clkaq) then
      
      case afec is
-- 0 ----------------------------------------------------------- ---------------------------------------
        when "0000000000000001" => afec <= "0000000000000010";
                                   afeck2   <= '1'; afeck0 <= '0';
                                   CCD_CLK1 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
-- 1 ----------------------------------------------------------- --------------------------------------
        when "0000000000000010" => afec <= "0000000000000100";
                                   afeck2   <= '0'; afeck0 <= '1';
                                   CCD_CLK1 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';
-- 2 ----------------------------------------------------------- -----------------------------
        when "0000000000000100" => afec <= "0000000000001000";
                                   afeck2   <= '0'; afeck0 <= '1';
                                   CCD_CLK1 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';

-- 3 ----------------------------------------------------------- --------------------------
        when "0000000000001000" => afec <= "0000000000010000";
                                   afeck2   <= '0'; afeck0 <= '0';
                                   CCD_CLK1 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';
-- 4 ----------------------------------------------------------- ----------------------------------------
        when "0000000000010000" => afec <= "0000000000100000";
                                   afeck2   <= '0'; afeck0 <= '0';
                                   CCD_CLK1 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';

-- 5 ----------------------------------------------------------- -----------------------
        when "0000000000100000" => afec <= "0000000001000000";
                                   afeck2   <= '0'; afeck0 <= '1';
                                   CCD_CLK1 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';

-- 6 ----------------------------------------------------------- ------------------------
        when "0000000001000000" => afec <= "0000000010000000";
                                   afeck2   <= '0'; afeck0 <= '1';
                                   CCD_CLK1 <= '0'; CCD_CLK2 <= '0'; CCD_CLK3 <= '0'; CCD_CLK4 <= '0';

-- 7 ----------------------------------------------------------- ---------------------
        when "0000000010000000" => afec <= "0000000100000000";
                                   afeck2   <= '0'; afeck0 <= '0';
                                   CCD_CLK1 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';

-- 8 ----------------------------------------------------------- ----------------------
        when "0000000100000000" => afec <= "0000001000000000";
                                   afeck2   <= '0'; afeck0 <= '0';
                                   CCD_CLK1 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';

-- 9 ----------------------------------------------------------- -------------------------
        when "0000001000000000" => afec <= "0000010000000000";
                                   afeck2   <= '0'; afeck0 <= '1';
                                   CCD_CLK1 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';


-- 10 ----------------------------------------------------------- -------------------------
        when "0000010000000000" => afec <= "0000100000000000";
                                   afeck2   <= '0'; afeck0 <= '1';
                                   CCD_CLK1 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';

-- 11 ----------------------------------------------------------- 
        when "0000100000000000" => afec <= "0000000000000001";
                                   afeck2   <= '0'; afeck0 <= '0';
                                   CCD_CLK1 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';

-- 12  -- phantom state for synch purposes ----------------------------------------------------------- 
        when "0001000000000000" => afec <= "0000000000000001";
                                   afeck2   <= '0'; afeck0 <= '0';
                                   CCD_CLK1 <= '1'; CCD_CLK2 <= '1'; CCD_CLK3 <= '1'; CCD_CLK4 <= '1';
                                   
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

