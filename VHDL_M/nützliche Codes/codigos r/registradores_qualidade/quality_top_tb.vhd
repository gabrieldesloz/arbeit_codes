
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;

-------------------------------------------------------------------------------

entity quality_top_tb is


end quality_top_tb;

-------------------------------------------------------------------------------

-- o número esperado na simulação, no  canal 7 da memória, após 7 ms, é 25   


architecture quality_top_rtl of quality_top_tb is


  -- component ports
  -- clock

  constant SYS_CLK_PERIOD  : time    := 10 ns;  -- 100 MHz 
  constant NIOS_CLK_PERIOD : time    := 40 ns;  -- 25 MHz
  constant D_WIDTH         : natural := 32;
  constant A_WIDTH         : natural := 3;



-- uut signals


  signal clk                   : std_logic                           := '0';
  signal reset_n               : std_logic                           := '0';
  signal avs_read              : std_logic                           := '0';
  signal avs_address           : std_logic_vector(2 downto 0)        := (others => '0');
  signal avs_writedata         : std_logic_vector(31 downto 0)       := (others => '0');
  signal avs_readdata          : std_logic_vector(31 downto 0)       := (others => '0');
  signal avs_write             : std_logic                           := '0';
  signal avs_chipselect        : std_logic                           := '0';
  signal sysclk                : std_logic                           := '0';
  signal coe_acq_bus_i         : std_logic_vector(ACQ_B-1 downto 0)  := (others => '0');
  signal coe_gain_bus_i        : std_logic_vector(GAIN_B-1 downto 0) := (others => '0');
  signal coe_ps_bus_i          : std_logic_vector(PS_B-1 downto 0)   := (others => '0');
  signal coe_phase_sum_ready_i : std_logic                           := '0';


  signal nios_clk, nios_clk_sync : std_logic := '0';



begin

  quality_top_1 : entity work.quality_top
    port map (
      clk            => nios_clk_sync,
      reset_n        => reset_n,
      avs_read       => avs_read,
      avs_address    => avs_address,
      avs_writedata  => avs_writedata,
      avs_readdata   => open,
      avs_write      => avs_write,
      avs_chipselect => avs_chipselect,
      coe_sysclk     => sysclk,

      coe_acq_bus_i         => coe_acq_bus_i,
      coe_gain_bus_i        => coe_gain_bus_i,
      coe_ps_bus_i          => coe_ps_bus_i,
      coe_phase_sum_ready_i => coe_phase_sum_ready_i,

      -- 256
      coe_sample_values_i => x"AAA0000000000000000000000000000000000000000000000000000000000000",
      -- 512
      coe_sample_values_o => open,
      coe_sv_ready_o => open

      );


  -- clock generation
  sysclk <= not sysclk after SYS_CLK_PERIOD/2;


  nios_clk      <= not nios_clk       after NIOS_CLK_PERIOD/2;
  nios_clk_sync <= transport nios_clk after SYS_CLK_PERIOD/2;



  -- estimulos nios clock domain -- 
  process

    procedure read_nios(do : in std_logic; address : in integer) is
    begin
      avs_address   <= std_logic_vector(to_unsigned(address, A_WIDTH));
      avs_writedata <= (others => '0');
      avs_write     <= '0';
      if do = '1' then
        avs_read       <= '1';
        avs_chipselect <= '1';
      else
        avs_read       <= '0';
        avs_chipselect <= '0';
      end if;
    end procedure read_nios;


    procedure write_nios(do : in std_logic; address : in integer) is
    begin
      avs_address   <= std_logic_vector(to_unsigned(address, A_WIDTH));
      avs_writedata <= std_logic_vector(to_unsigned(8, 32));  --set overflow
                                                              --through software
      avs_read      <= '0';
      if do = '1' then
        avs_write      <= '1';
        avs_chipselect <= '1';
      else
        avs_write      <= '0';
        avs_chipselect <= '0';
      end if;
    end procedure write_nios;


  begin


    -- testando o cal 7

    wait until reset_n = '1';
    wait for 1 ms;

    coe_phase_sum_ready_i <= '0';
    coe_acq_bus_i         <= "00000000";
    coe_gain_bus_i        <= "10000000";
    coe_ps_bus_i          <= "1000";    --set derived thorugh gateware


    --write
    wait until nios_clk_sync = '1';
    write_nios('1', N2_CHANNEL);
    wait for 2*NIOS_CLK_PERIOD;
    write_nios('0', N2_CHANNEL);
    wait for 2 ms;


    --check
    wait until nios_clk_sync = '1';
    read_nios('1', N2_CHANNEL);
    wait for 3*NIOS_CLK_PERIOD;
    read_nios('0', N2_CHANNEL);
    wait for 1 ms;

    --ok
    coe_phase_sum_ready_i <= '1';
    wait for 1*SYS_CLK_PERIOD;
    coe_phase_sum_ready_i <= '0';
    wait for 1 ms;
    
    
  end process;


  reset_n_proc : process
  begin
    reset_n <= '0';
    wait for 10*SYS_CLK_PERIOD;
    reset_n <= '1';
    wait for 50_000 ms;
  end process;
  
  
end quality_top_rtl;



