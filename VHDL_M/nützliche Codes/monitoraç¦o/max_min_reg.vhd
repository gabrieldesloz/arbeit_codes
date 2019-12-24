library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity max_min_reg is
  generic (
    ADC_BITS : natural := 8
    );

  port (
    wave_in : in  std_logic_vector(ADC_BITS-1 downto 0);
    n_reset : in  std_logic;
    sysclk  : in  std_logic;
    max     : out std_logic_vector(ADC_BITS-1 downto 0);
    min     : out std_logic_vector(ADC_BITS-1 downto 0)
    );


end entity max_min_reg;


architecture max_min_reg_ARQ of max_min_reg is

  signal max_next, min_next              : std_logic_vector(ADC_BITS-1 downto 0);
  signal max_reg, min_reg                : std_logic_vector(ADC_BITS-1 downto 0);
  signal counter_reg, counter_next       : unsigned(31 downto 0);
  signal clear_comp_reg, clear_comp_next : std_logic;
  signal present_value_reg               : std_logic_vector(ADC_BITS-1 downto 0);
  
begin

  max <= max_reg;
  min <= min_reg;

-------------------------------------------------------------------------------
-- Regs
-------------------------------------------------------------------------------
  process (n_reset, sysclk)
  begin
    if n_reset = '0' then
      clear_comp_reg    <= '1';
      counter_reg       <= (others => '0');
      present_value_reg <= (others => '0');
      min_reg           <= (others => '1');
      max_reg           <= (others => '0');
    elsif rising_edge (sysclk) then
      clear_comp_reg    <= clear_comp_next;
      counter_reg       <= counter_next;
      present_value_reg <= wave_in;
      min_reg           <= min_next;
      max_reg           <= max_next;
    end if;
  end process;


-------------------------------------------------------------------------------
-- time_out 
-------------------------------------------------------------------------------
  process(counter_reg)
  begin
    counter_next    <= counter_reg;
    clear_comp_next <= '0';
    if counter_reg = x"1DCD64FF" then   -- 5s p/clock 100 MHz
      counter_next    <= (others => '0');
      clear_comp_next <= '1';
    else
      counter_next <= counter_reg + 1;
    end if;
  end process;

-------------------------------------------------------------------------------
-- Compare
-------------------------------------------------------------------------------

  max_comp : process(clear_comp_reg, max_reg, min_reg, present_value_reg)
  begin
    min_next <= min_reg;
    max_next <= max_reg;
    if clear_comp_reg = '1' then
      min_next <= (others => '1');
      max_next <= (others => '0');
    else
      if present_value_reg < min_reg then
        min_next <= present_value_reg;
      elsif present_value_reg > max_reg then
        max_next <= present_value_reg;
      end if;
    end if;
  end process;


end architecture max_min_reg_ARQ;

