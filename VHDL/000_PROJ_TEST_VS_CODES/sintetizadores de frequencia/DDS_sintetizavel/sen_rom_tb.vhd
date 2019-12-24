library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity sen_rom_tb is
  generic
    (
      DATA_WIDTH  : natural := 10;
      arq_escrita : string  := "full_sin.txt"
      );
end sen_rom_tb;

architecture stimuli of sen_rom_tb is
  constant clock_period : time := 20 ns;
  signal clk            : std_logic;
  signal addr           : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal q              : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal q_reg          : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
  
  uut : entity work.sen_rom(full_sin_proc_virg)
    -- full_sin_read -> le arquivo seno (onda completa)
    -- full_sin_proc -> cria arquivo com valores seno (onda completa)
    
    generic map (DATA_WIDTH, arq_escrita)
    port map (clk, addr, q, q_reg);

  -- estimulo clock
  relogio : process
  begin
    clk <= '0';
    wait for clock_period/2;
    clk <= '1';
    wait for clock_period/2;
  end process relogio;


  count : process
    variable i : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');
  begin
    addr <= std_logic_vector(i);
    i    := i + 200 + 1;
    wait for 5*clock_period;
  end process count;
end stimuli;
