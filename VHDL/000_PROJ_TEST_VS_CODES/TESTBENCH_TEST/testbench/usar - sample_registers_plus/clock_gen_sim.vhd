-- gerar um clock com periodo diferente 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_stim_gen is
  generic(
    JITTER           : time;
    SYS_CLK_PERIOD   : time;
    COUNT_CLK_NORMAL : natural;
    COUNT_CLK_JITTER : natural

    );

  port (
    clk_reference_in : in  std_logic;
    sysclk_out       : out std_logic;
    reset_n          : in  std_logic

    ); 
end entity clock_stim_gen;

architecture ARQ of clock_stim_gen is

  type STATE_TYPE is (START, CLOCK_NORMAL, CLOCK_JITTER_1);
  signal count_next, count_reg : unsigned(31 downto 0) := (others => '0');
  signal state_reg, state_next : STATE_TYPE;

  signal sysclk_normal : std_logic := '0';
  signal sysclk_jitter : std_logic := '0';
  signal JITTER_REG    : std_logic := '0';

  
  

begin  -- architecture ARQ

  process(clk_reference_in, reset_n)
  begin
    if reset_n = '0' then
      state_reg <= START;
      count_reg <= (others => '0');
    elsif rising_edge(clk_reference_in) then
      state_reg <= state_next;
      count_reg <= count_next;
    end if;
  end process;


  process(clk_reference_in, count_reg, state_reg)
  begin

    state_next <= state_reg;
    count_next <= count_reg;
    case state_reg is

      when START =>
        if rising_edge(clk_reference_in) then
          state_next <= CLOCK_NORMAL;
        end if;

      when CLOCK_NORMAL =>
        
        if rising_edge(clk_reference_in) then
          count_next <= count_reg + 1;
        elsif count_reg = COUNT_CLK_NORMAL then
          state_next <= CLOCK_JITTER_1;
          count_next <= (others => '0');
        end if;

      when CLOCK_JITTER_1 =>

        if rising_edge(clk_reference_in) then
          count_next <= count_reg + 1;
        elsif count_reg = COUNT_CLK_JITTER then
          state_next <= CLOCK_NORMAL;
          count_next <= (others => '0');
        end if;
    end case;

  end process;


  sysclk_jitter <= not sysclk_jitter after (SYS_CLK_PERIOD + JITTER);
  sysclk_normal <= not sysclk_normal after (SYS_CLK_PERIOD);
  sysclk_out    <= sysclk_jitter when JITTER_REG = '1' else sysclk_normal;

  
end architecture ARQ;


