-------------------------------------------------------------------------------
-- Title      : Irig Detector
-- Project    : Merging Unit
-------------------------------------------------------------------------------
-- File       : irig_detector.vhd
-- Author     : Celso Luis de Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-11-03
-- Last update: 2013-10-01
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: Detects Irig Activity
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-11-03  1.0      CLS     Created
-- 2013-10-01  2.0      GDL     More robust detection                           
-------------------------------------------------------------------------------

-- Libraries and use clauses



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity irig_detector is
  generic (
    BIT_TIME_MAX    : natural := 2*1_000_000;
    PPS_MAX_COUNT   : natural := 2*100_000_000;
    ERRO_PPS        : natural := 5_000_000;      --5%-
    ERRO_PMARK_HIGH : natural := 200_000;        --20%+-
    ERRO_PMARK_LOW  : natural := 40_000;         --20%+-
    COUNT_TIME_HIGH : natural := 800_000;
    COUNT_TIME_LOW  : natural := 200_000;
    COUNT_TIME_PPS  : natural := 100_000_000;
    PPS_TIMEOUT     : natural := 13*100_000_000  -- 13s

    );
  port (
    sysclk    : in  std_logic;
    reset_n   : in  std_logic;
    irig_i    : in  std_logic;
    irig_ok_o : out std_logic
    );
end irig_detector;
------------------------------------------------------------
architecture irig_detector_RTL of irig_detector is


  type PPS_ST_TYPE is (ST_PPS_START, ST_PPS_WAIT_1ST,
                       ST_PPS_COUNT_1, ST_PPS_COUNT_2);

  type PMARK_ST_TYPE is (ST_PMARK_START, ST_PMARK_WAIT_1ST_POS_EDGE,
                         ST_PMARK_COUNT_HIGH_1, ST_PMARK_COUNT_LOW_1,
                         ST_PMARK_COUNT_HIGH_2, ST_PMARK_COUNT_LOW_2);

  attribute syn_encoding                  : string;
  attribute syn_encoding of PPS_ST_TYPE   : type is "safe";
  attribute syn_encoding of PMARK_ST_TYPE : type is "safe";

  signal pps_st_reg, pps_st_next                   : PPS_ST_TYPE;
  signal pmark_st_reg, pmark_st_next               : PMARK_ST_TYPE;
  signal irig_reg, irig_next                       : std_logic;
  signal p_p_pulse_reg, p_p_pulse_next             : std_logic;
  signal irig_neg_edge, irig_pos_edge              : std_logic;
  signal count_irig_reg, count_irig_next         : integer range 0 to BIT_TIME_MAX;
  signal count_pps_next, count_pps_reg : integer range 0 to 2*PPS_MAX_COUNT;
  signal clear_pps, count_pps                      : std_logic;
  signal irig_ok_next, irig_ok_reg                 : std_logic;
  signal irig_sync1, irig_sync2                    : std_logic;


begin

  -- external signal assignment
  irig_ok_o <= irig_ok_reg;

  -- sinc external irig
  process (reset_n, sysclk)
  begin
    if (reset_n = '0') then
      irig_sync1 <= '0';
      irig_sync2 <= '0';
    elsif rising_edge(sysclk) then
      irig_sync1 <= irig_i;
      irig_sync2 <= irig_sync1;
    end if;
  end process;

  -- detects positive edge    
  pos_edge_detector_inst : entity work.pos_edge_moore
    port map(
      sysclk  => sysclk,
      reset_n => reset_n,
      level_i => irig_sync2,
      tick_o  => irig_pos_edge
      );

  -- detects negative_edge    
  neg_edge_detector_inst : entity work.neg_edge_moore
    port map(
      sysclk  => sysclk,
      reset_n => reset_n,
      level_i => irig_sync2,
      tick_o  => irig_neg_edge
      );

  -- pmark state machine - detects 2 consecutive pmarks  
  process(reset_n, sysclk)
  begin
    if (reset_n = '0') then
      pmark_st_reg    <= ST_PMARK_START;
      p_p_pulse_reg   <= '0';
      count_irig_reg <= 0;
    elsif (rising_edge(sysclk)) then
      pmark_st_reg    <= pmark_st_next;
      p_p_pulse_reg   <= p_p_pulse_next;
      count_irig_reg <= count_irig_next;
    end if;
  end process;


  process (count_irig_reg, irig_neg_edge, irig_pos_edge, pmark_st_reg) is
  begin
    p_p_pulse_next   <= '0';
    pmark_st_next    <= pmark_st_reg;
    count_irig_next <= count_irig_reg;

    case pmark_st_reg is

      when ST_PMARK_START =>
        pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        
      when ST_PMARK_WAIT_1ST_POS_EDGE =>
        count_irig_next <= 0;
        if (irig_pos_edge = '1') then
          pmark_st_next <= ST_PMARK_COUNT_HIGH_1;
        end if;

      when ST_PMARK_COUNT_HIGH_1 =>
        if (irig_neg_edge = '1') and ((count_irig_reg >= (COUNT_TIME_HIGH - ERRO_PMARK_HIGH))
                                      and (count_irig_reg <= (COUNT_TIME_HIGH + ERRO_PMARK_HIGH))) then
          pmark_st_next      <= ST_PMARK_COUNT_LOW_1;
          count_irig_next <= 0;
        else
          count_irig_next <= count_irig_reg + 1;
        end if;
        if count_irig_reg > (COUNT_TIME_HIGH + ERRO_PMARK_HIGH) then
          pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        end if;
        if (irig_neg_edge = '1') and (count_irig_reg < (COUNT_TIME_HIGH - ERRO_PMARK_HIGH)) then
          pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        end if;
        
        
      when ST_PMARK_COUNT_LOW_1 =>
        if (irig_pos_edge = '1') and ((count_irig_reg >= (COUNT_TIME_LOW - ERRO_PMARK_LOW))
                                      and (count_irig_reg <= (COUNT_TIME_LOW + ERRO_PMARK_LOW))) then
          pmark_st_next      <= ST_PMARK_COUNT_HIGH_2;
          count_irig_next <= 0;
        else
          count_irig_next <= count_irig_reg + 1;
        end if;
        if count_irig_reg > (COUNT_TIME_LOW + ERRO_PMARK_LOW) then
          pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        end if;
        if (irig_pos_edge = '1') and (count_irig_reg < (COUNT_TIME_LOW - ERRO_PMARK_LOW)) then
          pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        end if;
        

      when ST_PMARK_COUNT_HIGH_2 =>
        if (irig_neg_edge = '1') and ((count_irig_reg >= (COUNT_TIME_HIGH - ERRO_PMARK_HIGH))
                                      and (count_irig_reg <= (COUNT_TIME_HIGH + ERRO_PMARK_HIGH))) then
          pmark_st_next      <= ST_PMARK_COUNT_LOW_2;
          count_irig_next <= 0;
        else
          count_irig_next <= count_irig_reg + 1;
        end if;
        if count_irig_reg > (COUNT_TIME_HIGH + ERRO_PMARK_HIGH) then
          pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        end if;
        if (irig_neg_edge = '1') and (count_irig_reg < (COUNT_TIME_HIGH - ERRO_PMARK_HIGH)) then
          pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        end if;


      when ST_PMARK_COUNT_LOW_2 =>
        if (irig_pos_edge = '1') and ((count_irig_reg >= (COUNT_TIME_LOW - ERRO_PMARK_LOW))
                                      and (count_irig_reg <= (COUNT_TIME_LOW + ERRO_PMARK_LOW))) then
          count_irig_next <= 0;
          p_p_pulse_next     <= '1';
          pmark_st_next      <= ST_PMARK_COUNT_HIGH_1;
        else
          count_irig_next <= count_irig_reg + 1;
        end if;
        if count_irig_reg > (COUNT_TIME_LOW + ERRO_PMARK_LOW) then
          pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        end if;
        if (irig_pos_edge = '1') and (count_irig_reg < (COUNT_TIME_LOW - ERRO_PMARK_LOW)) then
          pmark_st_next <= ST_PMARK_WAIT_1ST_POS_EDGE;
        end if;

      when others =>
        pmark_st_next <= ST_PMARK_START;

    end case;
  end process;


  -- pps state machine -
  process(reset_n, sysclk)
  begin
    if (reset_n = '0') then
      pps_st_reg          <= ST_PPS_START;
      irig_ok_reg         <= '0';
      count_pps_reg <= 0;
    elsif (rising_edge(sysclk)) then      
      pps_st_reg          <= pps_st_next;
		irig_ok_reg         <= irig_ok_next;
      count_pps_reg <= count_pps_next;
    end if;
  end process;


  process(count_pps_reg, irig_ok_reg, p_p_pulse_reg, pps_st_reg)
  begin

    irig_ok_next         <= irig_ok_reg;
    pps_st_next          <= pps_st_reg;
    count_pps_next <= count_pps_reg;

    case pps_st_reg is

      when ST_PPS_START =>
        count_pps_next <= 0;
        pps_st_next          <= ST_PPS_WAIT_1ST;
        

      when ST_PPS_WAIT_1ST =>
        count_pps_next <= 0;
        irig_ok_next         <= '0';
        if (p_p_pulse_reg = '1') then
          pps_st_next          <= ST_PPS_COUNT_1;
          count_pps_next <= count_pps_reg + 1;
        end if;


      when ST_PPS_COUNT_1 =>
        if (p_p_pulse_reg = '1') and ((count_pps_reg >= (COUNT_TIME_PPS - ERRO_PPS))
                                      and (count_pps_reg <= (COUNT_TIME_PPS + ERRO_PPS))) then
          count_pps_next <= 0;
          pps_st_next     <= ST_PPS_COUNT_2;
        else
          count_pps_next <= count_pps_reg + 1;
        end if;
        if (count_pps_reg > (PPS_TIMEOUT)) then
          pps_st_next <= ST_PPS_WAIT_1ST;
        end if;
        if (p_p_pulse_reg = '1') and (count_pps_reg < (COUNT_TIME_PPS - ERRO_PPS)) then
          pps_st_next <= ST_PPS_WAIT_1ST;
        end if;
        


      when ST_PPS_COUNT_2 =>
        if (p_p_pulse_reg = '1') and ((count_pps_reg >= (COUNT_TIME_PPS - ERRO_PPS))
                                      and (count_pps_reg <= (COUNT_TIME_PPS + ERRO_PPS))) then
          irig_ok_next         <= '1';
          pps_st_next          <= ST_PPS_COUNT_1;
          count_pps_next <= 0;
        else
          count_pps_next <= count_pps_reg + 1;
        end if;
        if (count_pps_reg > (PPS_TIMEOUT)) then
          pps_st_next <= ST_PPS_WAIT_1ST;
        end if;
        if (p_p_pulse_reg = '1') and (count_pps_reg < (COUNT_TIME_PPS - ERRO_PPS)) then
          pps_st_next <= ST_PPS_WAIT_1ST;
        end if;
        
        
      when others =>
        pps_st_next <= ST_PPS_START;
    end case;

  end process;
  


end irig_detector_RTL;





