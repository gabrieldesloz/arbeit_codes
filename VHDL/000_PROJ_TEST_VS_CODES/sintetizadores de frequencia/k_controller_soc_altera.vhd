-------------------------------------------------------------------------------
-- $Id: k_controller.vhd 5253 2010-07-23 10:59:48Z cls $
-- $URL: file:///tcn/dsv/priv/repos/svn/components/0085a-cboard_ii/k_controller.vhd $
-- Criado por Celso Luis de Souza on  07/2004
-- Copyright (C) 2005 Reason Tecnologia S.A. Todos os direitos reservados.
-------------------------------------------------------------------------------


-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use ieee.std_logic_textio.all;
use std.textio.all;


library work;
use work.sync_constants.all;


entity k_controller_soc is
  port(
    n_reset      : in  std_logic;
    sysclk       : in  std_logic;
    sync_soc     : in  std_logic;
    sync_pps     : in  std_logic;
    irig_ok      : in  std_logic;
    locked       : out std_logic;
    k_calculated : in  std_logic_vector ((N_BITS_NCO_SOC-1) downto 0);
    k_out        : out std_logic_vector ((N_BITS_NCO_SOC-1) downto 0);
    clear_dco    : out std_logic
    );
end entity k_controller_soc;
------------------------------------------------------------
architecture k_controller_RTL of k_controller_soc is

-- Type declarations

  type STATE_CONTROLLER_TYPE is (WAIT_SYNC_STATE,
                                 COUNT_TIME_STATE,
                                 UPDATE_K_STATE,
                                 LOCKED_STATE);  -- UPDATE_K_STATE_1, UPDATE_K_STATE_2,


  attribute ENUM_ENCODING                          : string;
  attribute ENUM_ENCODING of STATE_CONTROLLER_TYPE : type is "00 01 10 11";

-- Constant declarations


-- Local (internal to the model) signals declarations.

  signal state_controller          : STATE_CONTROLLER_TYPE;
  signal state_controller_next     : STATE_CONTROLLER_TYPE;
  signal time_counter              : natural range 0 to LIMIT_TIMER_SOC;
  signal time_counter_next         : natural range 0 to LIMIT_TIMER_SOC;
  signal freq_int                  : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal freq_next                 : std_logic_vector((N_BITS_NCO_SOC - 1) downto 0);
  signal clear_dco_flag_int        : std_logic;
  signal clear_dco_flag_next       : std_logic;
  signal add_sub_next, add_sub_reg : std_logic;
  signal b_next, b_reg             : std_logic_vector(N_BITS_NCO_SOC-1 downto 0);



-- Component declarations

begin
  k_out     <= freq_int;
  locked    <= clear_dco_flag_int;
  clear_dco <= sync_pps when (clear_dco_flag_int = '1') else '0';



  add_sub_1 : entity work.add_sub
    port map (
      add_sub => add_sub_reg,
      dataa   => k_calculated,
      datab   => b_reg,
      result  => freq_next);



  process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (n_reset = '0') then
        add_sub_reg        <= '1';
        b_reg              <= (others => '0');
        state_controller   <= WAIT_SYNC_STATE;
        time_counter       <= 0;
        freq_int           <= K_DEFAULT_STD_SOC;
        clear_dco_flag_int <= '0';
      else
        add_sub_reg <= add_sub_next;
        b_reg       <= b_next;
        if (irig_ok = '1') then
          state_controller   <= state_controller_next;
          time_counter       <= time_counter_next;
          freq_int           <= freq_next;
          clear_dco_flag_int <= clear_dco_flag_next;
        else
          state_controller   <= WAIT_SYNC_STATE;
          time_counter       <= 0;
          freq_int           <= k_calculated;
          clear_dco_flag_int <= '0';
        end if;
      end if;
    end if;
  end process;

  process (add_sub_reg, b_reg, clear_dco_flag_int, irig_ok, state_controller,
           sync_pps, sync_soc, time_counter) is
  begin  -- process
    add_sub_next          <= add_sub_reg;
    b_next                <= b_reg;
    state_controller_next <= state_controller;
    time_counter_next     <= time_counter;
    clear_dco_flag_next   <= clear_dco_flag_int;


    case state_controller is
      when WAIT_SYNC_STATE =>
        if ((sync_pps = '1') and (irig_ok = '1')) then
          time_counter_next     <= 0;
          state_controller_next <= COUNT_TIME_STATE;
        end if;
      when COUNT_TIME_STATE =>
        time_counter_next <= time_counter + 1;
        if (sync_soc = '1') then
          state_controller_next <= UPDATE_K_STATE;
        elsif (sync_pps = '1') then
          state_controller_next <= WAIT_SYNC_STATE;
        end if;

        
      when UPDATE_K_STATE =>
        state_controller_next <= WAIT_SYNC_STATE;
        clear_dco_flag_next   <= '1';
        b_next                <= (others => '0');
        if (time_counter < SOC_TIME_SOC/2 + 1) then
          if (time_counter > LIMIT_LO_SOC) then
            clear_dco_flag_next <= '0';
            --freq_next           <= k_hi_normal;
            --k_hi_normal <= k_calculated + STEP_NORMAL_SOC;
            add_sub_next        <= '1';
            b_next              <= conv_std_logic_vector((STEP_NORMAL_SOC), N_BITS_NCO_SOC);
          elsif (time_counter > LIMIT_LO_SOC_LOCKED) then
            clear_dco_flag_next <= '0';
            --freq_next           <= k_hi_low;
            --k_hi_low    <= k_calculated + STEP_LOW_SOC;
            add_sub_next        <= '1';
            b_next              <= conv_std_logic_vector((STEP_LOW_SOC), N_BITS_NCO_SOC);
          end if;
        else
          if (time_counter < LIMIT_HI_SOC) then
            --freq_next           <= k_lo_normal;
            --k_lo_normal <= k_calculated - STEP_NORMAL_SOC;
            add_sub_next        <= '0';  --subtração
            b_next              <= (conv_std_logic_vector((STEP_NORMAL_SOC), N_BITS_NCO_SOC));
            clear_dco_flag_next <= '0';
          elsif (time_counter < LIMIT_HI_SOC_LOCKED) then
            --freq_next           <= k_lo_low;
            --k_lo_low  <= k_calculated - STEP_LOW_SOC;
            add_sub_next        <= '0';  --subtração
            b_next              <= (conv_std_logic_vector((STEP_LOW_SOC), N_BITS_NCO_SOC));
            clear_dco_flag_next <= '0';
          end if;
        end if;
      when others =>
        state_controller_next <= WAIT_SYNC_STATE;
    end case;
  end process;


end k_controller_RTL;

-- eof $Id: k_controller.vhd 5253 2010-07-23 10:59:48Z cls $

