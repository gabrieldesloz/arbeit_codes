-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : Synchronization Module
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : frequency_meter.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2013-06-26
-- Platform   :
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: A vhdl module for an ADPLL (All Digital Phase Locked Loop)
-- A frequency meter module based on the periodicity of the PPS start/stop
-- signal - one pulse per second
-------------------------------------------------------------------------------
-- Copyright (c) 2011/2012
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007-01      1.0      CLS     Created
-- 2012-09-03   2.0      GDL     Revised and Optimized
-------------------------------------------------------------------------------





-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pps_cleaner_experimental is

  generic (
    D                 : natural;
    PERIOD_FREQ_MIN   : natural;
    PERIOD_FREQ_MAX   : natural;
    STABLE_FREQ_COUNT : natural;
    FM_MAX_DEVIATION  : natural;
    RECOVERY_COUNT    : natural

    );
  port (
    CLK_FREQUENCY_STD : in  std_logic_vector(D-1 downto 0);
    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    pps_pulse_i       : in  std_logic;
    pps_pulse_o       : out std_logic
    );
end pps_cleaner_experimental;
------------------------------------------------------------------------------

architecture pps_cleaner_experimental_RTL of pps_cleaner_experimental is

-- Local (internal to the model) signals declarations.


  type STATE_TYPE is (START, RESYNC);

  attribute SYN_ENCODING               : string;
  attribute SYN_ENCODING of STATE_TYPE : type is "safe";


  signal state_next, state_reg                       : STATE_TYPE;
  signal m_next, m_reg                               : unsigned(D-1 downto 0);
  signal MIN_FREQ_next, MIN_FREQ_reg                 : unsigned(D-1 downto 0);
  signal MAX_FREQ_next, MAX_FREQ_reg                 : unsigned(D-1 downto 0);
  signal freq_ok_next, freq_ok_reg                   : unsigned(4 downto 0);
  signal recovery_counter_next, recovery_counter_reg : unsigned(D-1 downto 0);
  signal switch_window_counter, clear_mreg_counter   : std_logic;
  signal window_counter                              : std_logic_vector(D-1 downto 0);
  signal pps_out_next, pps_out_reg                   : std_logic;
  signal m_reg_counter, m_reg_counter_next           : unsigned(D-1 downto 0);
  signal m_reg_clear_next, m_reg_clear_reg           : std_logic;
  

  
begin

  -- registradores, reset assincrono
  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_reg            <= START;
      m_reg                <= (others => '0');
      MIN_FREQ_reg         <= (others => '0');
      MAX_FREQ_reg         <= (others => '0');
      freq_ok_reg          <= (others => '0');
      recovery_counter_reg <= (others => '0');
      m_reg_counter        <= (others => '0');
      pps_out_reg          <= '0';
      m_reg_clear_reg      <= '0';

    elsif rising_edge (sysclk) then
      state_reg            <= state_next;
      m_reg                <= m_next;
      MIN_FREQ_reg         <= MIN_FREQ_next;
      MAX_FREQ_reg         <= MAX_FREQ_next;
      freq_ok_reg          <= freq_ok_next;
      recovery_counter_reg <= recovery_counter_next;
      m_reg_counter        <= m_reg_counter_next;
      pps_out_reg          <= pps_out_next;
      m_reg_clear_reg      <= m_reg_clear_next;

    end if;
  end process;


-------------------------------------------------------------------------------
-- FSM --   
-------------------------------------------------------------------------------

  pps_filter_fsm : process
    (CLK_FREQUENCY_STD, MAX_FREQ_reg, MIN_FREQ_reg, freq_ok_reg, m_reg,
     m_reg_counter, pps_pulse_i, recovery_counter_reg, state_reg,
     window_counter, m_reg_clear_reg)

  begin

    -- padrao
    pps_out_next          <= '0';
    switch_window_counter <= '0';
    clear_mreg_counter    <= '0';
    m_next                <= m_reg;
    MIN_FREQ_next         <= MIN_FREQ_reg;
    MAX_FREQ_next         <= MAX_FREQ_reg;
    state_next            <= state_reg;
    freq_ok_next          <= freq_ok_reg;
    recovery_counter_next <= recovery_counter_reg;
    m_reg_clear_next      <= m_reg_clear_reg;


    --

    case state_reg is

      when START =>
        --carrega os valores default estabelecidos no arquivo de constante
        -- recovery state

        m_next        <= unsigned(CLK_FREQUENCY_STD);
        MIN_FREQ_next <= (unsigned(CLK_FREQUENCY_STD) - PERIOD_FREQ_MIN);
        MAX_FREQ_next <= (PERIOD_FREQ_MAX - unsigned(CLK_FREQUENCY_STD));

        state_next <= RESYNC;

        -- inicia os contadores
        switch_window_counter <= '1';
        clear_mreg_counter    <= '1';

        


      when RESYNC =>

        if unsigned(m_reg_counter) = m_reg then
          --centraliza a janela em torno de m_reg por padrao
          switch_window_counter <= '1';
        end if;

        -- janela ou intervalo deslizante, verifica se o pps ocorre neste
        -- intervalo, se n�o, vai para a condi��o de recupera��o. Se sim
        -- atualiza a posi��o da janela
        if (unsigned(window_counter) > (m_reg - MIN_FREQ_reg)) and (unsigned(window_counter) < (m_reg + MAX_FREQ_reg)) then
          if pps_pulse_i = '1' then
            m_reg_clear_next      <= '0';
            switch_window_counter <= '1';
            clear_mreg_counter    <= '1';
            recovery_counter_next <= (others => '0');
            if freq_ok_reg = STABLE_FREQ_COUNT then
              m_next        <= unsigned(m_reg_counter);
              pps_out_next  <= '1';
              MIN_FREQ_next <= to_unsigned(FM_MAX_DEVIATION/2, MIN_FREQ_next'length);
              MAX_FREQ_next <= to_unsigned(FM_MAX_DEVIATION/2, MIN_FREQ_next'length);
            else
              freq_ok_next <= freq_ok_reg + 1;
            end if;
          end if;
        else
          if pps_pulse_i = '1' then
            m_reg_clear_next <= '1';
            freq_ok_next     <= (others => '0');
            if recovery_counter_reg = RECOVERY_COUNT then
              state_next <= START;
            else
              recovery_counter_next <= recovery_counter_reg + 1;
            end if;
          end if;
        end if;


      when others =>
        state_next <= START;

    end case;

  end process;

  -- contador da janela deslizante
  m_reg_counter_next <= (others => '0') when ((clear_mreg_counter = '1') or ((m_reg_counter = m_reg) and (m_reg_clear_reg = '1'))) else (m_reg_counter + 1);


  window_counters : entity work.counter_mux
    generic map (
      D => D)
    port map (
      clock       => sysclk,
      n_reset     => n_reset,
      switch      => switch_window_counter,
      out_counter => window_counter,
      m_reg       => std_logic_vector(m_reg));


  
  pps_pulse_o <= pps_out_reg;

end pps_cleaner_experimental_RTL;


-- eof $id:$

