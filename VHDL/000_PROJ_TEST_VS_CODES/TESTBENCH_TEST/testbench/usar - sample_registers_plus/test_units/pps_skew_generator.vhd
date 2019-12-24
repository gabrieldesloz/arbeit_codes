

-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pps_skew_generator is

  generic (
    D         : natural := 28;
    SKEW_LOW  : natural := 100;
    SKEW_HIGH : natural := 100

    );

  port (

    m_freq                : out std_logic_vector(D-1 downto 0);
    sysclk                : in  std_logic;
    n_reset               : in  std_logic;
    pps_pulse             : in  std_logic;
    pps_pulse_out         : out std_logic;
    m_freq_skew_high      : out std_logic_vector(D-1 downto 0);
    m_freq_skew_low       : out std_logic_vector(D-1 downto 0);
    skew_on_button_switch : in  std_logic


    );
end pps_skew_generator;
------------------------------------------------------------------------------

architecture pps_skew_generator_RTL of pps_skew_generator is



  type STATE_TYPE is (PPS_SYSTART, PPS_NORMAL, PPS_SKEW_LOW, PPS_WAIT, PPS_SKEW_HIGH);

  attribute SYN_ENCODING               : string;
  attribute SYN_ENCODING of STATE_TYPE : type is "safe";


  signal state_next, state_reg                     : STATE_TYPE;
  signal counter_reg, counter_next, m_reg, m_next  : unsigned((D-1) downto 0);
  signal counter_skew_reg, counter_skew_next       : unsigned((D-1) downto 0);
  signal m_freq_skew_high_int, m_freq_skew_low_int : unsigned(m_freq'range);
  signal clear                                     : std_logic;

begin

  m_freq <= std_logic_vector(m_reg);


  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_reg        <= PPS_SYSTART;
      m_reg            <= (others => '0');
      counter_reg      <= (others => '0');
      counter_skew_reg <= (others => '0');


    elsif rising_edge (sysclk) then
      state_reg        <= state_next;
      counter_reg      <= counter_next;
      m_reg            <= m_next;
      counter_skew_reg <= counter_skew_next;
    end if;
  end process;



  -- time_out generator state_machine
  process(clear, counter_reg, counter_skew_reg, m_freq_skew_high_int,
          m_freq_skew_low_int, m_reg, pps_pulse, state_reg, skew_on_button_switch)
  begin

    
    state_next    <= state_reg;
    pps_pulse_out <= '0';
    m_next        <= m_reg;
    clear         <= '0';

    case state_reg is

      when PPS_SYSTART =>

        pps_pulse_out <= '0';

        if pps_pulse = '1' then
          state_next <= PPS_NORMAL;
        end if;
        
        
      when PPS_NORMAL =>

        if pps_pulse = '1' then
          pps_pulse_out <= '1';
          clear         <= '1';
          m_next        <= counter_reg;
          if skew_on_button_switch = '1' then
            state_next <= PPS_SKEW_LOW;
          end if;
        end if;

        
      when PPS_SKEW_LOW =>

        if counter_skew_reg = m_freq_skew_low_int then
          pps_pulse_out <= '1';
        end if;

        if pps_pulse = '1' then
          state_next <= PPS_WAIT;
        end if;


      when PPS_WAIT =>
        if pps_pulse = '1' then
          clear      <= '1';
          state_next <= PPS_SKEW_HIGH;
        end if;
        
        
      when PPS_SKEW_HIGH =>

        if counter_skew_reg = m_freq_skew_high_int then
          pps_pulse_out <= '1';
          state_next    <= PPS_NORMAL;
        end if;

        
      when others =>
        state_next <= PPS_SYSTART;
    end case;

  end process;



-- skew
  m_freq_skew_low_int  <= m_reg - SKEW_LOW;
  m_freq_skew_high_int <= to_unsigned(SKEW_HIGH, D);

  m_freq_skew_low  <= std_logic_vector(m_freq_skew_low_int);
  m_freq_skew_high <= std_logic_vector(m_freq_skew_high_int);



-- contador da frequencia
  counter_next      <= (others => '0') when (pps_pulse = '1') else counter_reg + 1;
  counter_skew_next <= (others => '0') when (clear = '1')     else counter_skew_reg + 1;


end pps_skew_generator_RTL;

-- eof $id:$

