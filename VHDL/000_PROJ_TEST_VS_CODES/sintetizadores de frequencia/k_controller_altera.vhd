-------------------------------------------------------------------------------
-- $Id: k_controller.vhd 7 2006-05-26 15:08:51Z mrd $
-- $URL: file:///tcn/dsv/priv/repos/svn/components/releases/0001a-cboard-v03/cboard/k_controller.vhd $
-- Criado por Celso Luis de Souza on  07/2004
-- Copyright (C) 2005 Reason Tecnologia S.A. Todos os direitos reservados.
-------------------------------------------------------------------------------



-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work;
use work.sync_constants.all;


entity k_controller is
  port(
    n_reset       : in  std_logic;
    sysclk        : in  std_logic;
    sync_soc      : in  std_logic;
    ready_cic     : in  std_logic;
    locked        : out std_logic;
    k_calculated  : in  std_logic_vector ((N_BITS_NCO-1) downto 0);
    k_out         : out std_logic_vector ((N_BITS_NCO-1) downto 0);
    k_default_std : in  std_logic_vector ((N_BITS_NCO-1) downto 0)
    );
end entity k_controller;
------------------------------------------------------------
architecture k_controller_RTL of k_controller is

-- Type declarations

  type STATE_CONTROLLER_TYPE is (WAIT_SYNC_STATE,
                                 COUNT_TIME_STATE,
                                 UPDATE_K_STATE,
                                 LOCKED_STATE);
  attribute ENUM_ENCODING                          : string;
  attribute ENUM_ENCODING of STATE_CONTROLLER_TYPE : type is "00 01 10 11";

-- Constant declarations


-- Local (internal to the model) signals declarations.

  signal state_controller      : STATE_CONTROLLER_TYPE;
  signal state_controller_next : STATE_CONTROLLER_TYPE;
  signal time_counter          : natural range 0 to LIMIT_TIMER_SOC;
  signal time_counter_next     : natural range 0 to LIMIT_TIMER_SOC;
  signal freq_int              : std_logic_vector((N_BITS_NCO - 1) downto 0);
  signal freq_next             : std_logic_vector((N_BITS_NCO - 1) downto 0);
  signal locked_int            : std_logic;
  signal locked_next           : std_logic;
  signal b_next, b_reg         : std_logic_vector(N_BITS_NCO-1 downto 0);


-- Component declarations

begin

  k_out     <= freq_int;
  locked    <= locked_int;
  freq_next <= k_calculated + b_reg;


  process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (n_reset = '0') then
        state_controller <= WAIT_SYNC_STATE;
        time_counter     <= 0;
        freq_int         <= k_default_std;
        locked_int       <= '0';
        b_reg            <= (others => '0');
      else
        b_reg            <= b_next;
        state_controller <= state_controller_next;
        time_counter     <= time_counter_next;
        freq_int         <= freq_next;
        locked_int       <= locked_next;
      end if;
    end if;
  end process;

  process (b_reg, locked_int, ready_cic, state_controller,
           sync_soc, time_counter) is
  begin  -- process
    
    b_next                <= b_reg;
    state_controller_next <= state_controller;
    time_counter_next     <= time_counter;
    locked_next           <= locked_int;


    case state_controller is
      when WAIT_SYNC_STATE =>
        if (sync_soc = '1') then
          time_counter_next     <= 0;
          state_controller_next <= COUNT_TIME_STATE;
        end if;
      when COUNT_TIME_STATE =>
        time_counter_next <= time_counter + 1;
        if (ready_cic = '1') then
          state_controller_next <= UPDATE_K_STATE;
        elsif (sync_soc = '1') then
          state_controller_next <= WAIT_SYNC_STATE;
        end if;
        
      when UPDATE_K_STATE =>
        state_controller_next <= WAIT_SYNC_STATE;
        if (time_counter < SOC_DISTANCE_LOCKED_HI) and (time_counter > SOC_DISTANCE_LOCKED_LOW) then
          locked_next <= '1';
          if (time_counter < SOC_DISTANCE_LOW) then
            --freq_next <= k_lo_low;
            --k_lo_low    <= k_calculated - STEP_LOW;
            --a_next <= k_calculated;
            b_next <= ((not conv_std_logic_vector((STEP_LOW), N_BITS_NCO)) + 1);
          elsif (time_counter > SOC_DISTANCE_HI) then
            --freq_next <= k_hi_low;
            --k_hi_low    <= k_calculated + STEP_LOW;
            --a_next <= k_calculated;
            b_next <= conv_std_logic_vector((STEP_LOW), N_BITS_NCO);
          else
            --freq_next <= k_calculated;
            --a_next <= k_calculated;
            b_next <= (others => '0');
          end if;
        else
          locked_next <= '0';
          if (time_counter < SOC_DISTANCE_LOCKED_LOW) then
            --freq_next <= k_lo_normal;
            --k_lo_normal <= k_calculated - STEP_NORMAL;
            --a_next <= k_calculated;
            b_next <= ((not conv_std_logic_vector((STEP_NORMAL), N_BITS_NCO)) + 1);
          elsif (time_counter > SOC_DISTANCE_LOCKED_HI) then
            --freq_next <= k_hi_normal; 
            --k_hi_normal <= k_calculated + STEP_NORMAL;
            --a_next <= k_calculated;
            b_next <= conv_std_logic_vector((STEP_NORMAL), N_BITS_NCO);
          end if;
        end if;


      when others =>
        state_controller_next <= WAIT_SYNC_STATE;
    end case;
  end process;
  

end k_controller_RTL;

-- eof $Id: k_controller.vhd 7 2006-05-26 15:08:51Z mrd $

