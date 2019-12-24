library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity pulse_divider is

  generic (
    D               : natural;
    PERIOD_FREQ_MIN : natural;
    PERIOD_FREQ_MAX : natural

    );
  port (
    CLK_FREQUENCY_STD : in  std_logic_vector(D-1 downto 0);
    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    real_pps_edge     : in  std_logic;
    div_pps_edge      : out std_logic
    );

end pulse_divider;
------------------------------------------------------------------------------

architecture ARQ of pulse_divider is

  signal counter, counter_next, m_reg, m_next : std_logic_vector(D-1 downto 0);
  signal counter_div, counter_div_next        : std_logic_vector(D-1 downto 0);
  
begin
  
  process (n_reset, sysclk,CLK_FREQUENCY_STD)
  begin
    if (n_reset = '0') then
      m_reg       <= CLK_FREQUENCY_STD;
      counter     <= (others => '0');
      counter_div <= (others => '0');
    elsif rising_edge (sysclk) then
      m_reg       <= m_next;
      counter     <= counter_next;
      counter_div <= counter_div_next;
    end if;
  end process;

  process (counter, counter_div, m_reg, real_pps_edge)
  begin
    div_pps_edge     <= '0';
    counter_next     <= counter + '1';
    counter_div_next <= counter_div + '1';
	 m_next 			   <= m_reg;
    if (real_pps_edge = '1') then
      m_next           <= counter + '1';
      counter_next     <= (others => '0');
      counter_div_next <= (others => '0');
      div_pps_edge     <= '1';
    else
      if counter_div = ("0" & m_reg(m_reg'high downto 1)) then
        div_pps_edge     <= '1';
        counter_div_next <= (others => '0');
      end if;
    end if;
  end process;

  
end ARQ;

-- eof $id:$

