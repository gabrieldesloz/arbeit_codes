-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;


entity pps_delay is
  generic (
    MAX_DELAY : natural := 300);

  port (
    sysclk           : in  std_logic;
    n_reset          : in  std_logic;
    sync_pps         : in  std_logic;
    sync_pps_delayed : out std_logic
    );


end pps_delay;

architecture pps_delay_RTL of pps_delay is
  type STATE_TYPE is (IDLE, DELAY);
  attribute ENUM_ENCODING                            : string;
  attribute ENUM_ENCODING of STATE_TYPE              : type is "00 01";
  signal state_reg, state_next                       : state_type;
  signal count_next, count_reg                       : natural range 0 to MAX_DELAY;
  signal sync_pps_delayed_next, sync_pps_delayed_reg : std_logic;
  
begin  -- architecture pps_delay_RTL


  process(sysclk, n_reset)
  begin
    if (n_reset = '0') then
      count_reg            <= 0;
      state_reg            <= IDLE;
      sync_pps_delayed_reg <= '0';
    elsif rising_edge(sysclk) then
      count_reg            <= count_next;
      state_reg            <= state_next;
      sync_pps_delayed_reg <= sync_pps_delayed_next;
    end if;
  end process;

  process(count_reg, state_reg, sync_pps)
  begin
    sync_pps_delayed_next <= '0';
    state_next            <= state_reg;
    count_next            <= 0;
    case state_reg is
      when IDLE =>
        if sync_pps = '1' then
          state_next <= DELAY;
        end if;
      when DELAY =>
        if (count_reg = MAX_DELAY-1) then
          sync_pps_delayed_next <= '1';
          state_next            <= IDLE;
        else
          count_next <= count_reg + 1;
        end if;
      when others =>
        state_next <= IDLE;
    end case;
  end process;


  sync_pps_delayed <= sync_pps_delayed_reg;

end architecture pps_delay_RTL;

