
library IEEE;
use IEEE.numeric_std.all;
use ieee.std_logic_1164.all;


entity sv_counter is

  generic(
    FREQ_BITS     : natural;
    EDGE_TO_CHECK : natural;
    EDGE_TO_RESET : natural
    );

  
  port (
    signal_in        : in  std_logic;
    sysclk           : in  std_logic;
    n_reset          : in  std_logic;
    resync_pulse     : out std_logic;
    clear_sv_counter : in  std_logic;
    sv_count         : out std_logic_vector(FREQ_BITS-1 downto 0)
    );

end entity sv_counter;


architecture sv_counter_RTL of sv_counter is


  signal pos_edges_next                              : unsigned(FREQ_BITS-1 downto 0);
  signal pos_edges_reg                               : unsigned(FREQ_BITS-1 downto 0);
  signal clear_sv_counter_reg, clear_sv_counter_next : std_logic;
  signal signal_in_reg, signal_in_next               : std_logic;

  
begin

  registers : process(n_reset, sysclk)
  begin
    if n_reset = '0' then
      clear_sv_counter_reg <= '0';
      pos_edges_reg        <= (others => '0');
      signal_in_reg        <= '0';
    elsif rising_edge(sysclk) then
      pos_edges_reg        <= pos_edges_next;
      clear_sv_counter_reg <= clear_sv_counter_next;
      signal_in_reg        <= signal_in_next;
    end if;
  end process;


  sv_count              <= std_logic_vector(pos_edges_reg);
  signal_in_next        <= signal_in;
  clear_sv_counter_next <= clear_sv_counter;


  wrap_around_process : process
    (
      pos_edges_reg,
      signal_in_reg,
      clear_sv_counter_reg
      )

  begin
    
    pos_edges_next <= pos_edges_reg;
    if pos_edges_reg = EDGE_TO_RESET or (clear_sv_counter_reg = '1') then
      pos_edges_next <= (others => '0');
    else
      if signal_in_reg = '1' then
        pos_edges_next <= pos_edges_reg + 1;
      end if;
    end if;
  end process;


  resync_output : process
    (pos_edges_reg, signal_in_reg)
  begin
    resync_pulse <= '0';
    if ((pos_edges_reg = EDGE_TO_CHECK-1) and (signal_in_reg = '1')) then
      resync_pulse <= '1';
    end if;
  end process;

  
  

end architecture sv_counter_RTL;
