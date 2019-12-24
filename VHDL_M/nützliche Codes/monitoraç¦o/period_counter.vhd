

-- conta o periodo da forma de onda, registrando o periodo maximo e minimo
-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity period_counter is

  generic
    (
      D       : natural;
      MIN_PER : natural;
      MAX_PER : natural
      );

  port (

    sysclk       : in  std_logic;
    n_reset      : in  std_logic;
    start_stop   : in  std_logic;
    m_per        : out std_logic_vector(D-1 downto 0);
    max          : out std_logic_vector(D-1 downto 0);
    min          : out std_logic_vector(D-1 downto 0);
    count_errors : out std_logic_vector(D-1 downto 0);
    pps          : in  std_logic
    );

end period_counter;
------------------------------------------------------------------------------

architecture period_counter_RTL of period_counter is


  signal counter_reg, counter_next, m_reg, m_next : unsigned((D-1) downto 0);
  signal clear                                    : std_logic;
  signal max_next, min_next                       : unsigned(D-1 downto 0);
  signal max_reg, min_reg                         : unsigned(D-1 downto 0);
  signal count_pps_reg, count_pps_next            : natural;
  signal count_errors_next, count_errors_reg      : natural;
  signal clear_comp_next, clear_comp_reg          : std_logic;

  
  


begin

  count_errors <= std_logic_vector(to_unsigned(count_errors_reg, D));
  m_per        <= std_logic_vector(m_reg);

  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      count_errors_reg  <= 0;
      clear_comp_reg    <= '0';
      count_pps_reg     <= 0;
      m_reg             <= (others => '0');
      counter_reg       <= (others => '0');
      min_reg           <= (others => '1');
      max_reg           <= (others => '0');
  
    elsif rising_edge (sysclk) then
 
      count_errors_reg  <= count_errors_next;
      clear_comp_reg    <= clear_comp_next;
      count_pps_reg     <= count_pps_next;
      counter_reg       <= counter_next;
      m_reg             <= m_next;
      min_reg           <= min_next;
      max_reg           <= max_next;
    end if;
  end process;


  process (start_stop, m_reg, counter_reg, count_errors_reg)
  begin
    m_next <= m_reg;
    clear  <= '0';
    count_errors_next <= count_errors_reg;
    if start_stop = '1' then
      clear  <= '1';
      m_next <= counter_reg;
      if ((m_reg > MAX_PER) or (m_reg < MIN_PER)) then
        count_errors_next <= count_errors_reg + 1;
      end if;      
    end if;
  end process;


-- contador da frequencia
  counter_next <= (others => '0') when (clear = '1') else
                  counter_reg + 1;

  max <= std_logic_vector(max_reg);
  min <= std_logic_vector(min_reg);

-- contador de tempo
  sekunden_zahler : process (start_stop, count_pps_reg)
  begin
    count_pps_next  <= count_pps_reg;
    clear_comp_next <= '0';
    if start_stop = '1' then
      count_pps_next <= count_pps_reg + 1;
    elsif count_pps_reg = 10 then
      clear_comp_next <= '1';
      count_pps_next  <= 0;
    end if;

  end process;


-- comparador
  max_comp : process(
    clear_comp_reg,
    max_reg,
    min_reg,
    m_reg
    )

    
  begin
    min_next <= min_reg;
    max_next <= max_reg;
    if clear_comp_reg = '1' then
      min_next <= (others => '1');
      max_next <= (others => '0');
    else
      if m_reg < min_reg then
        min_next <= m_reg;
      elsif m_reg > max_reg then
        max_next <= m_reg;
      end if;
    end if;
  end process;

    
  end period_counter_RTL;


-- eof $id:$

