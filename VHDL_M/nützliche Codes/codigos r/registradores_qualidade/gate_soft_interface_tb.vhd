
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;

-------------------------------------------------------------------------------

entity gate_soft_interface_tb is


end gate_soft_interface_tb;

-------------------------------------------------------------------------------

architecture gate_soft_interface_tb_rtl of gate_soft_interface_tb is


  -- component ports
  -- clock

  constant SYS_CLK_PERIOD    : time    := 10 ns;   -- 100 MHz
  constant SAMPLE_CLK_PERIOD : time    := 200 ns;  -- 
  constant NIOS_CLK_PERIOD   : time    := 40 ns;   -- 25 MHz
  constant D_WIDTH           : natural := 32;
  constant A_WIDTH           : natural := 4;



-- uut signals


  signal sysclk         : std_logic                                            := '0';
  signal clk            : std_logic                                            := '0';
  signal reset_n        : std_logic                                            := '0';
  signal avs_read       : std_logic                                            := '0';
  signal avs_address    : std_logic_vector(3 downto 0)                         := (others => '0');
  signal avs_writedata  : std_logic_vector(31 downto 0)                        := (others => '0');
  signal avs_readdata   : std_logic_vector(31 downto 0)                        := (others => '0');
  signal avs_write      : std_logic                                            := '0';
  signal avs_chipselect : std_logic                                            := '0';
  signal coe_sysclk     : std_logic                                            := '0';
  signal coe_write_gate : std_logic                                            := '0';
  signal coe_read_gate  : std_logic                                            := '0';
  signal quality_bus_o  : std_logic_vector((N_CHANNELS_ANA*BITS/2)-1 downto 0) := (others => '0');
  signal quality_bus_i  : std_logic_vector((N_CHANNELS_ANA*BITS/2)-1 downto 0) := (others => '0');



  signal sample_clk, sample_clk_sync, nios_clk, nios_clk_sync : std_logic                             := '0';
  signal data_input                                           : std_logic_vector(quality_bus_i'range) := (others => '0');
  signal data_input_2                                         : std_logic_vector(31 downto 0)         := (others => '0');
  signal data_input_available                                 : std_logic                             := '0';



-- procedures e functions


begin


  gate_soft_interface_1 : entity work.gate_soft_interface
    port map (
      clk            => nios_clk_sync,  --
      reset_n        => reset_n,
      avs_read       => avs_read,
      avs_address    => avs_address,
      avs_writedata  => avs_writedata,
      avs_readdata   => avs_readdata,
      avs_write      => avs_write,
      avs_chipselect => avs_chipselect,
      coe_sysclk     => sysclk,         --
      coe_write_gate => coe_write_gate,
      coe_read_gate  => coe_read_gate,
      quality_bus_o  => quality_bus_o,
      quality_bus_i  => quality_bus_i);




  -- clock generation
  sysclk <= not sysclk after SYS_CLK_PERIOD/2;

  sample_clk      <= not sample_clk       after SAMPLE_CLK_PERIOD/2;
  sample_clk_sync <= transport sample_clk after SYS_CLK_PERIOD/2;
  nios_clk        <= not nios_clk         after NIOS_CLK_PERIOD/2;
  nios_clk_sync   <= transport nios_clk   after SYS_CLK_PERIOD/2;


  -- geração das amostras 
  p_random_generic_1 : entity work.p_random_generic
    generic map (
      SEED => 666,
      N    => 256
      )
    port map (
      clk         => sample_clk_sync,
      n_reset     => reset_n,
      random_vect => data_input);


  -- geração das amostras 
  p_random_generic_21 : entity work.p_random_generic
    generic map (
      SEED => 666,
      N    => 32
      )
    port map (
      clk         => sample_clk_sync,
      n_reset     => reset_n,
      random_vect => data_input_2);






  -- gera um pulso de SYS_CLK_PERIOD quando ocorre uma mudança nas amostras
  stimuli : process
  begin
    wait until data_input'event;
    wait for SYS_CLK_PERIOD;
    data_input_available <= '1';
    wait for SYS_CLK_PERIOD;
    data_input_available <= '0';
  end process;




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
      avs_writedata <= data_input_2;
      avs_read      <= '0';
      if do = '1' then
        avs_write      <= '1';
        avs_chipselect <= '1';
      else
        avs_write      <= '0';
        avs_chipselect <= '0';
      end if;
    end procedure write_nios;


    procedure read_gate(do : in std_logic; address : in integer) is
    begin
      quality_bus_i <= (others => '0');
      coe_read_gate <= '0';
      if do = '1' then
        coe_read_gate <= '1';
      else
        coe_read_gate <= '0';
      end if;
    end procedure read_gate;


    procedure write_gate(do : in std_logic; address : in integer) is
    begin
      quality_bus_i <= data_input;
      coe_read_gate <= '0';
      if do = '1' then
        coe_write_gate <= '1';
      else
        coe_write_gate <= '0';
      end if;
    end procedure write_gate;



  begin

    wait until reset_n = '1';
    wait for 1 ms;

    wait until nios_clk_sync = '1';
    write_nios('1', 2);
    wait for 2*NIOS_CLK_PERIOD;
    write_nios('0', 2);
    wait for 2 ms;

    wait until sysclk = '1';
    read_gate('1', 2);
    wait for 2*SYS_CLK_PERIOD;
    read_gate('0', 2);
    wait for 1 ms;

  end process;



-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => sysclk,
      n_reset => reset_n
      );


end gate_soft_interface_tb_rtl;



