
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------

entity divider_mux_tb is


  port (
    reset_n           : in  std_logic;
    sysclk            : in  std_logic;
    d_ana_proc_o      : out std_logic_vector((2*32)-1 downto 0);
    one_division_done : out std_logic;
    ready             : out std_logic;
    start_o           : out std_logic
    );     


end divider_mux_tb;

-------------------------------------------------------------------------------

architecture divider_mux_tb_rtl of divider_mux_tb is


  constant SIGN : std_logic := '1';

  constant N : natural := 32;
  constant D : natural := 32;


-- uut signals


  signal start : std_logic                       := '0';
  signal num   : std_logic_vector (N-1 downto 0) := (others => '0');
  signal den   : std_logic_vector (D-1 downto 0) := (others => '0');
  signal num2  : std_logic_vector (N-1 downto 0) := (others => '0');
  signal den2  : std_logic_vector (D-1 downto 0) := (others => '0');

  signal d_ana_i : std_logic_vector((4*32)-1 downto 0);

  alias canal1_i_tb : std_logic_vector(31 downto 0) is d_ana_i(1*32-1 downto 0);
  alias canal2_i_tb : std_logic_vector(31 downto 0) is d_ana_i(2*32-1 downto 1*32);
  alias canal3_i_tb : std_logic_vector(31 downto 0) is d_ana_i(3*32-1 downto 2*32);
  alias canal4_i_tb : std_logic_vector(31 downto 0) is d_ana_i(4*32-1 downto 3*32);


  alias canal1_o_tb : std_logic_vector(31 downto 0) is d_ana_proc_o(1*32-1 downto 0);
  alias canal2_o_tb : std_logic_vector(31 downto 0) is d_ana_proc_o(2*32-1 downto 1*32);

  
  
  
begin


  start_o <= start;


  divider_mux_1 : entity work.divider_mux
    generic map (
      N_CHANNELS_ANA => 4,
      N_BITS_ADC     => 32)
    port map (
      sysclk            => sysclk,
      n_reset           => reset_n,
      d_ana_i           => d_ana_i,
      d_ana_proc_o      => d_ana_proc_o,
      ready_data_o      => ready,
      start_div_i       => start,
      one_division_done => one_division_done);


  d_ana_i <= num & den & num2 & den2;


  WaveGen_Proc : process
  begin
    
    wait until reset_n = '1';
    start <= '0';
    num   <= std_logic_vector(to_signed(-20, N));
    den   <= std_logic_vector(to_signed(-6, D));
    num2  <= std_logic_vector(to_signed(40, N));
    den2  <= std_logic_vector(to_signed(-5, D));
    wait for 10 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 1500 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    num2  <= (others => '0');
    den2  <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    wait until sysclk = '1';
    num   <= std_logic_vector(to_signed(-10, N));
    den   <= std_logic_vector(to_signed(-2, D));
    num2  <= std_logic_vector(to_signed(-30, N));
    den2  <= std_logic_vector(to_signed(5, D));
    wait for 10 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 1500 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    num2  <= (others => '0');
    den2  <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    wait until sysclk = '1';
    num   <= std_logic_vector(to_signed(-14, N));
    den   <= std_logic_vector(to_signed(-4, D));
    num2  <= std_logic_vector(to_signed(-20, N));
    den2  <= std_logic_vector(to_signed(7, D));
    wait for 10 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 1500 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    num2  <= (others => '0');
    den2  <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    wait until sysclk = '1';
    num   <= std_logic_vector(to_signed(10, N));
    den   <= std_logic_vector(to_signed(-2, D));
    num2  <= std_logic_vector(to_signed(-35, N));
    den2  <= std_logic_vector(to_signed(2, D));
    wait for 10 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 1500 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    num2  <= (others => '0');
    den2  <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    wait until sysclk = '1';
    num   <= std_logic_vector(to_signed(133, N));
    den   <= std_logic_vector(to_signed(-2, D));
    num2  <= std_logic_vector(to_signed(-135, N));
    den2  <= std_logic_vector(to_signed(2, D));
    wait for 10 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 1500 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    num2  <= (others => '0');
    den2  <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    
  end process;



end divider_mux_tb_rtl;

