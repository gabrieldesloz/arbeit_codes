
-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity two_pulse_dist_counter is
  generic (
    ERROR_BITS     : natural;
    M_BITS         : natural;
    TIME_COUNT_MAX : natural;
    VALUE_TO_CHECK : natural
    );    
  port(
    n_reset           : in  std_logic;
    sysclk            : in  std_logic;
    sync_soc          : in  std_logic;
    sync_pps          : in  std_logic;
    measured_distance : out std_logic_vector(M_BITS-1 downto 0);
    count_errors      : out std_logic_vector(ERROR_BITS-1 downto 0)
    );
end two_pulse_dist_counter;
------------------------------------------------------------
architecture two_pulse_distance_counter_RTL of two_pulse_dist_counter is

-- Type declarations

  type STATE_CONTROLLER_TYPE is (WAIT_SYNC_STATE, COUNT_TIME_STATE);

  attribute SYN_ENCODING                          : string;
  attribute SYN_ENCODING of STATE_CONTROLLER_TYPE : type is "safe";


  signal state_controller                    : STATE_CONTROLLER_TYPE;
  signal state_controller_next               : STATE_CONTROLLER_TYPE;
  signal time_counter                        : natural range 0 to TIME_COUNT_MAX;
  signal time_counter_next                   : natural range 0 to TIME_COUNT_MAX;
  signal m_dist_reg, m_dist_next             : unsigned(M_BITS-1 downto 0);
  signal count_errors_reg, count_errors_next : unsigned(ERROR_BITS-1 downto 0);
  
  
begin

  process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (n_reset = '0') then
        state_controller <= WAIT_SYNC_STATE;
        m_dist_reg       <= (others => '0');
        time_counter     <= 0;
        count_errors_reg <= (others => '0');
      else
        count_errors_reg <= count_errors_next;
        time_counter     <= time_counter_next;
        m_dist_reg       <= m_dist_next;
        state_controller <= state_controller_next;
      end if;
    end if;
    
  end process;


  
  process (

    state_controller,
    m_dist_reg,
    time_counter,
    sync_pps,
    sync_soc,
    count_errors_reg

    ) is

    
  begin  -- process
    
    state_controller_next <= state_controller;
    time_counter_next     <= time_counter;
    m_dist_next           <= m_dist_reg;
    count_errors_next     <= count_errors_reg;



    case state_controller is
      
      when WAIT_SYNC_STATE =>
        if (sync_pps = '1') then
          time_counter_next     <= 0;
          state_controller_next <= COUNT_TIME_STATE;
        end if;
        
      when COUNT_TIME_STATE =>
        time_counter_next <= time_counter + 1;
        if (sync_soc = '1') then
          m_dist_next           <= to_unsigned(time_counter, M_BITS);
          state_controller_next <= WAIT_SYNC_STATE;

          -- error count
          if time_counter /= VALUE_TO_CHECK then
            count_errors_next <= count_errors_reg + 1;
          end if;
          
        elsif sync_pps = '1' then
          m_dist_next           <= to_unsigned(time_counter, M_BITS);
          state_controller_next <= WAIT_SYNC_STATE;
          -- error count
          count_errors_next     <= count_errors_reg + 1;
        end if;

    end case;
  end process;

  measured_distance <= std_logic_vector(m_dist_reg);
  count_errors      <= std_logic_vector(count_errors_reg);




  
end two_pulse_distance_counter_RTL;


