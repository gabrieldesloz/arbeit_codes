
-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity drift_counter is
  generic (
    D                   : natural;
    N_BITS_NCO_SOC      : natural;
    LIMIT_TIMER_SOC     : natural;
    SOC_TIME_SOC        : natural;
    LIMIT_LO_SOC        : natural;
    STEP_NORMAL_SOC     : natural;
    LIMIT_LO_SOC_LOCKED : natural;
    STEP_LOW_SOC        : natural;
    LIMIT_HI_SOC        : natural;
    LIMIT_HI_SOC_LOCKED : natural
    );
  port(
    n_reset               : in  std_logic;
    sysclk                : in  std_logic;
    sync_soc              : in  std_logic;
    sync_pps              : in  std_logic;
    irig_ok               : in  std_logic;
    region_k_controller   : out std_logic_vector(2 downto 0);
    pps_drift_p_s         : out std_logic_vector(31 downto 0);
    soc_timer_d2_var      : in  std_logic_vector(D-1 downto 0);
    limit_high_var        : in  std_logic_vector(D-1 downto 0);
    limit_high_locked_var : in  std_logic_vector(D-1 downto 0)


    );
end entity drift_counter;
------------------------------------------------------------
architecture drift_counter_RTL of drift_counter is

-- Type declarations

  type STATE_CONTROLLER_TYPE is (WAIT_PPS,
                                 COUNT_TIME_STATE,
                                 CHECK_REGION
                                 );

  attribute SYN_ENCODING                          : string;
  attribute SYN_ENCODING of STATE_CONTROLLER_TYPE : type is "safe";



  signal state_controller      : STATE_CONTROLLER_TYPE;
  signal state_controller_next : STATE_CONTROLLER_TYPE;
  signal time_counter          : natural range 0 to LIMIT_TIMER_SOC;
  signal time_counter_next     : natural range 0 to LIMIT_TIMER_SOC;

  signal region_k_controller_next                             : std_logic_vector(2 downto 0);
  signal region_k_controller_reg                              : std_logic_vector(2 downto 0);
  signal sample1_reg, sample2_reg, sample1_next, sample2_next : natural range 0 to LIMIT_TIMER_SOC;
  signal pps_drift_p_s_reg, pps_drift_p_s_next                : unsigned(31 downto 0);


  function maximum (
    left, right : unsigned)           
    return unsigned is
  begin  -- function max
    if (left) > (right) then return left;
    else return right;
    end if;
  end function maximum;

  function minimum (
    left, right : unsigned)           
    return unsigned is
  begin  -- function minimum
    if (left) < (right) then return left;
    else return right;
    end if;
  end function minimum;


-- Component declarations

begin

  region_k_controller <= region_k_controller_reg;
  
  
  process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (n_reset = '0') then
        state_controller        <= WAIT_PPS;
        time_counter            <= 0;
        region_k_controller_reg <= "000";
        sample2_reg             <= 0;
        sample1_reg             <= 0;
        pps_drift_p_s_reg       <= (others => '0');
      else
        sample2_reg             <= sample2_next;
        sample1_reg             <= sample1_next;
        pps_drift_p_s_reg       <= pps_drift_p_s_next;
        region_k_controller_reg <= region_k_controller_next;     
        if (irig_ok = '1') then
          state_controller <= state_controller_next;
          time_counter     <= time_counter_next;
        else
          state_controller <= WAIT_PPS;
          time_counter     <= 0;
        end if;
      end if;
    end if;
  end process;

  process (
    irig_ok,
    region_k_controller_reg,
    state_controller,
    sync_pps,
    sync_soc,
    time_counter,
    soc_timer_d2_var,
    limit_high_var,
    limit_high_locked_var,
    sample1_reg,
    sample2_reg
    ) is


  begin 

    sample1_next             <= sample1_reg;
    sample2_next             <= sample2_reg;
    state_controller_next    <= state_controller;
    time_counter_next        <= time_counter;
    region_k_controller_next <= region_k_controller_reg;

    case state_controller is

      when WAIT_PPS =>

        if (sync_pps = '1') and (irig_ok = '1') then
          time_counter_next     <= 0;
          state_controller_next <= COUNT_TIME_STATE;
        end if;

      when COUNT_TIME_STATE =>
        time_counter_next <= time_counter + 1;
        if (sync_soc = '1') then
          sample1_next          <= time_counter;
          sample2_next          <= sample1_reg;
          state_controller_next <= CHECK_REGION;
        elsif (sync_pps = '1') then
          state_controller_next <= WAIT_PPS;
        end if;


      when CHECK_REGION =>
        state_controller_next <= WAIT_PPS;
        region_k_controller_next <= "100";
        if (time_counter < unsigned(soc_timer_d2_var)) then
          if (time_counter > LIMIT_LO_SOC) then
            region_k_controller_next <= "011";
          elsif (time_counter > LIMIT_LO_SOC_LOCKED) then
            region_k_controller_next <= "010";
          end if;
        else
          if (time_counter < unsigned(limit_high_var)) then
            region_k_controller_next <= "001";
          elsif (time_counter < unsigned(limit_high_locked_var)) then
            region_k_controller_next <= "000";
          end if;
        end if;
      when others =>
        state_controller_next <= WAIT_PPS;
    end case;
  end process;



-- drift measurement
  pps_drift_p_s_next <= maximum(to_unsigned(sample1_reg, 32), to_unsigned(sample2_reg, 32)) - minimum(to_unsigned(sample1_reg, 32), to_unsigned(sample2_reg, 32));
  pps_drift_p_s      <= std_logic_vector(pps_drift_p_s_reg);



end drift_counter_RTL;


