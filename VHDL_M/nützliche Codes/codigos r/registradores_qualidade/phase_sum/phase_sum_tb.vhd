
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity phase_sum_tb is

end phase_sum_tb;

-------------------------------------------------------------------------------

architecture phase_sum_tb_rtl of phase_sum_tb is

  component phase_sum
    generic (
      N_CHANNELS_ANA_BOARD : natural;
      COE_IN_OUT_BITS      : natural;
      N_BITS               : natural);
    port (
      clk                : in  std_logic;
      reset_n            :     std_logic;
      avs_address        : in  std_logic;
      avs_chipselect     : in  std_logic;
      avs_write          : in  std_logic;
      avs_writedata      : in  std_logic_vector(31 downto 0);
      coe_sysclk         : in  std_logic;
      coe_data_input     : in  std_logic_vector(COE_IN_OUT_BITS-1 downto 0);
      coe_data_output    : out std_logic_vector(COE_IN_OUT_BITS-1 downto 0);
      coe_data_ready_in  : in  std_logic;
      coe_data_ready_out : out std_logic);
  end component;

  -- component generics
  constant N_CHANNELS_ANA_BOARD : natural := 8;
  constant COE_IN_OUT_BITS      : natural := 256;
  constant N_BITS               : natural := 32;

  -- component ports
  signal clk                : std_logic := '1';
  signal reset_n            : std_logic;
  signal avs_address        : std_logic;
  signal avs_chipselect     : std_logic;
  signal avs_write          : std_logic;
  signal avs_writedata      : std_logic_vector(31 downto 0);
  signal coe_sysclk         : std_logic := '1';
  signal coe_data_input     : std_logic_vector(COE_IN_OUT_BITS-1 downto 0);
  signal coe_data_output    : std_logic_vector(COE_IN_OUT_BITS-1 downto 0);
  signal coe_data_ready_in  : std_logic := '0';
  signal coe_data_ready_out : std_logic;


begin  -- phase_sum_tb_rtl

  -- component instantiation
  DUT : phase_sum
    generic map (
      N_CHANNELS_ANA_BOARD => N_CHANNELS_ANA_BOARD,
      COE_IN_OUT_BITS      => COE_IN_OUT_BITS,
      N_BITS               => N_BITS)
    port map (
      clk                => clk,
      reset_n            => reset_n,
      avs_address        => avs_address,
      avs_chipselect     => avs_chipselect,
      avs_write          => avs_write,
      avs_writedata      => avs_writedata,
      coe_sysclk         => coe_sysclk,
      coe_data_input     => coe_data_input,
      coe_data_output    => coe_data_output,
      coe_data_ready_in  => coe_data_ready_in,
      coe_data_ready_out => coe_data_ready_out);

  clk <= not clk after 20 ns;
  coe_sysclk <= not coe_sysclk after 5 ns;

  process
  begin
    reset_n <= '0';
    wait for 300 ns;
    reset_n <= '1';
    wait;
  end process;

  process
    begin
      avs_address <= '0';
      avs_chipselect <= '0';
      avs_write <= '0';
      avs_writedata <= (others => '0');
      wait for 10 us;
      avs_address <= '0';
      avs_chipselect <= '1';
      avs_write <= '1';
      avs_writedata <= x"00000003";
      wait for 40 ns;
      avs_chipselect <= '0';
      avs_write <= '0';

      wait;
    end process;

  process
    begin
      coe_data_input <= x"0000AAAA00000123000001230000012300005555000003210000032100000321";

      wait;
    end process;

      process
    begin
      wait for 208 us;
      coe_data_ready_in <= '1';
      wait for 10 ns;
      coe_data_ready_in <= '0';      

      wait;
    end process;

    
end phase_sum_tb_rtl;

-------------------------------------------------------------------------------

configuration phase_sum_tb_phase_sum_tb_rtl_cfg of phase_sum_tb is
  for phase_sum_tb_rtl
  end for;
end phase_sum_tb_phase_sum_tb_rtl_cfg;

-------------------------------------------------------------------------------
