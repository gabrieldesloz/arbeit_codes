-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : detects irig activity
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : irig_detector.vhd
-- Author     : Gabriel Lozano
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-11-03
-- Last update: 2013-10-01
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  detects irig activity
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-11-03   1.0      CLS     Created
-------------------------------------------------------------------------------



-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;


entity irig_detector_neu is
  generic (
    BIT_TIME_MAX    : natural := 2*1_000_000;
    PPS_MAX_COUNT   : natural := 2*100_000_000;
    ERRO_PPS        : natural := 5_000_000;  --5%-
    ERRO_PMARK_HIGH : natural := 200_000;    --20%+-
    ERRO_PMARK_LOW  : natural := 40_000;     --20%+-
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
end irig_detector_neu;
------------------------------------------------------------
architecture irig_detector_RTL of irig_detector_neu is


  type PPS_FSM_TYPE is (SYS_START_F, WAIT_1st_F, COUNT_PPS_ST_1, COUNT_PPS_ST_2);
  signal state_pps_reg, state_pps_next : PPS_FSM_TYPE;
  type PMARK_FSM_TYPE is (SYS_START, WAIT_1st_POS_EDGE, COUNT_HIGH, COUNT_LOW, COUNT_HIGH_2, COUNT_LOW_2);
  signal state_reg, state_next         : PMARK_FSM_TYPE;


  attribute syn_encoding                   : string;
  attribute syn_encoding of PPS_FSM_TYPE   : type is "safe";
  attribute syn_encoding of PMARK_FSM_TYPE : type is "safe";

  signal irig_reg, irig_next, p_p_pulse_reg, p_p_pulse_next, clear, count : std_logic;
  signal irig_neg_edge, irig_pos_edge                                     : std_logic;
  signal count_timer_reg, count_timer_next                                : integer range 0 to BIT_TIME_MAX;
  signal count_timer_pps_next, count_timer_pps_reg                        : integer range 0 to 2*PPS_MAX_COUNT;
  signal clear_pps, count_pps                                             : std_logic;
  signal irig_ok_next, irig_ok_reg                                        : std_logic;
  signal irig2_next, irig2_reg                                            : std_logic;


begin

  -- sinc sinal externo
  irig_next  <= irig_i;
  irig2_next <= irig_reg;
  irig_ok_o  <= irig_ok_reg;



  pos_edge_detector_inst : entity work.pos_edge_moore
    port map(
      sysclk  => sysclk,
      reset_n => reset_n,
      level_i => irig2_reg,
      tick_o  => irig_pos_edge
      );


  neg_edge_detector_inst : entity work.neg_edge_moore
    port map(
      sysclk  => sysclk,
      reset_n => reset_n,
      level_i => irig2_reg,
      tick_o  => irig_neg_edge
      );


  process(reset_n, sysclk)
  begin
    if (reset_n = '0') then
      state_reg           <= SYS_START;
      state_pps_reg       <= SYS_START_F;
      p_p_pulse_reg       <= '0';
      count_timer_reg     <= 0;
      irig_reg            <= '0';
      irig2_reg           <= '0';
      irig_ok_reg         <= '0';
      count_timer_pps_reg <= 0;

    elsif (rising_edge(sysclk)) then
      state_reg           <= state_next;
      state_pps_reg       <= state_pps_next;
      p_p_pulse_reg       <= p_p_pulse_next;
      count_timer_reg     <= count_timer_next;
      irig_reg            <= irig_next;
      irig_ok_reg         <= irig_ok_next;
      count_timer_pps_reg <= count_timer_pps_next;
      irig2_reg           <= irig2_next;
      
    end if;
  end process;



  fsm_pmark : process (state_reg, count_timer_reg, irig_neg_edge, irig_pos_edge) is
  begin

    count          <= '0';
    p_p_pulse_next <= '0';
    state_next     <= state_reg;
    clear          <= '0';


    case state_reg is

      when SYS_START =>
        state_next <= WAIT_1st_POS_EDGE;
        
      when WAIT_1st_POS_EDGE =>
        
        clear <= '1';

        if irig_pos_edge = '1' then
          state_next <= COUNT_HIGH;
        end if;

      when COUNT_HIGH =>

        if (irig_neg_edge = '1') and ((count_timer_reg >= (COUNT_TIME_HIGH - ERRO_PMARK_HIGH))
                                      and (count_timer_reg <= (COUNT_TIME_HIGH + ERRO_PMARK_HIGH))) then
          state_next <= COUNT_LOW;
          clear      <= '1';
        else
          count <= '1';
        end if;

        if count_timer_reg > (COUNT_TIME_HIGH + ERRO_PMARK_HIGH) then
          state_next <= WAIT_1st_POS_EDGE;
        end if;

        if (irig_neg_edge = '1') and (count_timer_reg < (COUNT_TIME_HIGH - ERRO_PMARK_HIGH)) then
          state_next <= WAIT_1st_POS_EDGE;
        end if;
        
        
      when COUNT_LOW =>
        

        if (irig_pos_edge = '1') and ((count_timer_reg >= (COUNT_TIME_LOW - ERRO_PMARK_LOW))
                                      and (count_timer_reg <= (COUNT_TIME_LOW + ERRO_PMARK_LOW))) then
          state_next <= COUNT_HIGH_2;
          clear      <= '1';
        else
          count <= '1';
        end if;


        if count_timer_reg > (COUNT_TIME_LOW + ERRO_PMARK_LOW) then
          state_next <= WAIT_1st_POS_EDGE;
        end if;

        if (irig_pos_edge = '1') and (count_timer_reg < (COUNT_TIME_LOW - ERRO_PMARK_LOW)) then
          state_next <= WAIT_1st_POS_EDGE;
        end if;
        
        


      when COUNT_HIGH_2 =>

        if (irig_neg_edge = '1') and ((count_timer_reg >= (COUNT_TIME_HIGH - ERRO_PMARK_HIGH))
                                      and (count_timer_reg <= (COUNT_TIME_HIGH + ERRO_PMARK_HIGH))) then
          state_next <= COUNT_LOW_2;
          clear      <= '1';
        else
          count <= '1';
        end if;


        if count_timer_reg > (COUNT_TIME_HIGH + ERRO_PMARK_HIGH) then
          state_next <= WAIT_1st_POS_EDGE;
        end if;

        if (irig_neg_edge = '1') and (count_timer_reg < (COUNT_TIME_HIGH - ERRO_PMARK_HIGH)) then
          state_next <= WAIT_1st_POS_EDGE;
        end if;


      when COUNT_LOW_2 =>
        if (irig_pos_edge = '1') and ((count_timer_reg >= (COUNT_TIME_LOW - ERRO_PMARK_LOW))
                                      and (count_timer_reg <= (COUNT_TIME_LOW + ERRO_PMARK_LOW))) then
          clear          <= '1';
          p_p_pulse_next <= '1';
          state_next     <= COUNT_HIGH;
        else
          count <= '1';
        end if;

        if count_timer_reg > (COUNT_TIME_LOW + ERRO_PMARK_LOW) then
          state_next <= WAIT_1st_POS_EDGE;
        end if;

        if (irig_pos_edge = '1') and (count_timer_reg < (COUNT_TIME_LOW - ERRO_PMARK_LOW)) then
          state_next <= WAIT_1st_POS_EDGE;
        end if;
        

      when others =>
        state_next <= COUNT_HIGH;

    end case;
  end process;





  contador : count_timer_next <= 0 when ((clear = '1') or (count_timer_reg = BIT_TIME_MAX-1)) else
                                 (count_timer_reg + 1) when (count = '1') else
                                 count_timer_reg;
  contador_pps : count_timer_pps_next <= 0 when ((clear_pps = '1') or (count_timer_pps_reg = 2*PPS_MAX_COUNT)) else
                                         (count_timer_pps_reg + 1) when (count_pps = '1') else
                                         count_timer_pps_reg;







  process(state_pps_reg, count_timer_pps_reg, irig_ok_reg, p_p_pulse_reg)
  begin


    irig_ok_next   <= irig_ok_reg;
    state_pps_next <= state_pps_reg;
    clear_pps      <= '0';
    count_pps      <= '0';

    case state_pps_reg is

      when SYS_START_F =>
        clear_pps      <= '1';
        state_pps_next <= WAIT_1st_F;
        

      when WAIT_1st_F =>
        clear_pps    <= '1';
        irig_ok_next <= '0';
        if p_p_pulse_reg = '1' then
          state_pps_next <= COUNT_PPS_ST_1;
          count_pps      <= '1';
        end if;


      when COUNT_PPS_ST_1 =>

        if (p_p_pulse_reg = '1') and ((count_timer_pps_reg >= (COUNT_TIME_PPS - ERRO_PPS))
                                      and (count_timer_pps_reg <= (COUNT_TIME_PPS + ERRO_PPS))) then
          clear_pps      <= '1';
          state_pps_next <= COUNT_PPS_ST_2;
        else
          count_pps <= '1';
        end if;


        if (count_timer_pps_reg > (PPS_TIMEOUT)) then
          state_pps_next <= WAIT_1st_F;
        end if;

        if (p_p_pulse_reg = '1') and (count_timer_pps_reg < (COUNT_TIME_PPS - ERRO_PPS)) then
          state_pps_next <= WAIT_1st_F;
        end if;
        


      when COUNT_PPS_ST_2 =>

        if (p_p_pulse_reg = '1') and ((count_timer_pps_reg >= (COUNT_TIME_PPS - ERRO_PPS))
                                      and (count_timer_pps_reg <= (COUNT_TIME_PPS + ERRO_PPS))) then
          irig_ok_next   <= '1';
          state_pps_next <= COUNT_PPS_ST_1;
          clear_pps      <= '1';
        else
          count_pps <= '1';
        end if;

        if (count_timer_pps_reg > (PPS_TIMEOUT)) then
          state_pps_next <= WAIT_1st_F;
        end if;

        if (p_p_pulse_reg = '1') and (count_timer_pps_reg < (COUNT_TIME_PPS - ERRO_PPS)) then
          state_pps_next <= WAIT_1st_F;
        end if;
        
        
        
      when others =>
        state_pps_next <= SYS_START_F;
    end case;

  end process;
  


end irig_detector_RTL;





