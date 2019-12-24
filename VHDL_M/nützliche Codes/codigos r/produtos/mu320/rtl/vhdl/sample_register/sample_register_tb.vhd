------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sample_register_tb.vhd
-- Author     : Gabriel Deschamps Lozano
-- Company    : Reason Tecnologia S.A.
-- Created    : 2013-02-04
-- Last update: 2013-07-18
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-07-18  1.0      gdl     Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;

-- test packages
--use work.RandomBasePkg.all;
--use work.RandomPkg.all;
--use work.CoveragePkg.all;
--use ieee.math_real.all;

-------------------------------------------------------------------------------

entity sample_register_tb is


end sample_register_tb;

-------------------------------------------------------------------------------

architecture sample_register_tb_rtl of sample_register_tb is


  -- component ports
  -- clock
  constant PERIOD_CLK_PPS    : time := 2 ms;     --  "1 s "
  constant SYS_CLK_PERIOD    : time := 10 ns;    -- 100 MHz
  constant SAMPLE_CLK_PERIOD : time := 65.1 us;  -- 15360 Hz
  constant NIOS_CLK_PERIOD   : time := 40 ns;    -- 25 MHz



-- uut signals

  signal reset_n              : std_logic                                                    := '0';
  signal data_input_available : std_logic                                                    := '0';
  signal data_input           : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0) := (others => '0');
  signal pps_input            : std_logic                                                    := '0';
  signal sample_address       : std_logic_vector(4 downto 0)                                 := (others => '0');
  signal sample_readdata      : std_logic_vector(31 downto 0)                                := (others => '0');
  signal sample_read          : std_logic                                                    := '0';
  signal sample_chipselect    : std_logic                                                    := '0';
  signal sample_writedata     : std_logic_vector(31 downto 0)                                := (others => '0');
  signal sample_write         : std_logic                                                    := '0';
  signal sample_irq           : std_logic                                                    := '0';

  signal clock_pps       : std_logic := '0';
  signal sysclk          : std_logic := '0';
  signal sample_clk      : std_logic := '0';
  signal sample_clk_sync : std_logic := '0';
  signal nios_clk        : std_logic := '0';
  signal nios_clk_sync   : std_logic := '0';
  signal clock_pps_sync  : std_logic := '0';



-- procedures e functions

  
begin


  -- clock generation
  sample_clk      <= not sample_clk       after SAMPLE_CLK_PERIOD/2;
  sample_clk_sync <= transport sample_clk after SYS_CLK_PERIOD/2;
  sysclk          <= not sysclk           after SYS_CLK_PERIOD/2;
  nios_clk        <= not nios_clk         after NIOS_CLK_PERIOD/2;
  nios_clk_sync   <= transport nios_clk   after SYS_CLK_PERIOD/2;
  clock_pps_sync  <= transport clock_pps  after SYS_CLK_PERIOD/2;


  -- geração do clock do pps
  clock_pps_gen : process
  begin
    clock_pps <= '0';
    wait for (PERIOD_CLK_PPS-SYS_CLK_PERIOD);
    clock_pps <= '1';
    wait for (SYS_CLK_PERIOD);
  end process;

  -- geração das amostras 
  p_random_generic_1 : entity work.p_random_generic
    generic map (
      SEED => 666,
      N    => (N_CHANNELS_ANA*N_BITS_ADC*2)
      )
    port map (
      clk         => sample_clk_sync,
      n_reset     => reset_n,
      random_vect => data_input);


  -- gera um pulso de SYS_CLK_PERIOD quando ocorre uma mudança nas amostras
  stimuli : process
  begin
    wait until data_input'event;
    wait for SYS_CLK_PERIOD;
    data_input_available <= '1';
    wait for SYS_CLK_PERIOD;
    data_input_available <= '0';
  end process;



  WaveGen_Proc : process

    -- inicia - amostragem 5 e com sincronia
    procedure start_sync_5(do : in std_logic) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(0, 5));
      sample_writedata <= x"0000000" & "0011";
      sample_read      <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure start_sync_5;


    -- inicia - amostragem 16 e com sincronia
    procedure start_sync_16(do : in std_logic) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(0, 5));
      sample_writedata <= x"0000000" & "0111";
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure start_sync_16;


    -- inicia - limpa irq
    procedure limpa_irq(do : in std_logic) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(1, 5));
      sample_writedata <= x"0000000" & "0010";
      sample_read      <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure limpa_irq;



    -- inicia - para execução
    procedure para(do : in std_logic) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(0, 5));
      sample_writedata <= x"0000000" & "0000";
      sample_read      <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure para;



    -- inicia - para execução
    procedure start_nsync_5(do : in std_logic) is
    begin
      sample_address  <= std_logic_vector(to_unsigned(0, 5));
      sample_readdata <= x"0000000" & "0001";
      sample_read     <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_write      <= '1';
      else
        sample_chipselect <= '0';
        sample_write      <= '0';
      end if;
    end procedure start_nsync_5;


    -- inicia - para execução
    procedure read_reg(do : in std_logic; address : in integer) is
    begin
      sample_address   <= std_logic_vector(to_unsigned(address, 5));
      sample_writedata <= x"00000000";
      sample_write     <= '0';
      if do = '1' then
        sample_chipselect <= '1';
        sample_read       <= '1';
      else
        sample_chipselect <= '0';
        sample_read       <= '0';
      end if;
    end procedure read_reg;

    
    
  begin
    
    wait until reset_n = '1';
    wait for 3 ms;
    wait until sample_clk_sync = '1';
    start_sync_16('1');
    --requisição com 1 periodos de clk
    wait for 2*SAMPLE_CLK_PERIOD;
    start_sync_16('0');
    wait for 3 ms;
    wait until sample_clk_sync = '1';
    read_reg('1', 19);
    wait for 2*SAMPLE_CLK_PERIOD;
    read_reg('0', 19);
    wait for 1 ms;
    wait until sample_clk_sync = '1';
    limpa_irq('1');
    wait for 2*SAMPLE_CLK_PERIOD;
    limpa_irq('0');
    wait for 3 ms;
    wait until sample_clk_sync = '1';
    para('1');
    wait for 2*SAMPLE_CLK_PERIOD;
    para('0');
    wait for 1 ms;
    wait until sample_clk_sync = '1';
    start_nsync_5('1');
    wait for 2*SAMPLE_CLK_PERIOD;
    start_nsync_5('0');
    wait for 1 ms;
    wait until sample_clk_sync = '1';
    limpa_irq('1');
    wait for 2*SAMPLE_CLK_PERIOD;
    limpa_irq('0');
    wait for 1 ms;
    wait until sample_clk_sync = '1';
    para('1');
    report "PARA" severity note;
    wait for 2*SAMPLE_CLK_PERIOD;
    para('0');
    wait for 1 ms;
    
    
  end process;



  sample_register_1 : entity work.sample_register
    generic map (
      SAMPLE_MEMORY_SIZE => 20)
    port map
    (
      reset_n              => reset_n,
      csi_clk              => sysclk,
      coe_data_available_i => data_input_available,
      coe_data_i           => data_input,
      coe_pps_edge_i       => clock_pps_sync,


      clk            => nios_clk_sync,  -- clock do nios
      avs_address    => sample_address,
      avs_read       => sample_read,
      avs_readdata   => open,
      ins_irq        => open,
      avs_chipselect => sample_chipselect,
      avs_writedata  => sample_writedata,
      avs_write      => sample_write
      );


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


end sample_register_tb_rtl;
