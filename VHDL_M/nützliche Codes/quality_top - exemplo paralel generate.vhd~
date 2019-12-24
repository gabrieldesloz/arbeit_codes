-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality_top.vhd
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2014
-- Last update: 2014-03-10
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: Top level entity for the Quality Module
-------------------------------------------------------------------------------
-- Copyright (c) 2014 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014        1.0              Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

entity quality_top is

  
  port (

    clk     : in std_logic;
    reset_n : in std_logic;

    avs_read       : in  std_logic;
    avs_address    : in  std_logic_vector(2 downto 0);
    avs_writedata  : in  std_logic_vector(31 downto 0);
    avs_readdata   : out std_logic_vector(31 downto 0);
    avs_write      : in  std_logic;
    avs_chipselect : in  std_logic;

    coe_sysclk : in std_logic;

    coe_acq_bus_i  : in std_logic_vector(ACQ_B-1 downto 0);
    coe_gain_bus_i : in std_logic_vector(GAIN_B-1 downto 0);
    coe_ps_bus_i   : in std_logic_vector(PS_B-1 downto 0);

    coe_phase_sum_ready_i : in std_logic;

    -- 256
    coe_sample_values_i : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
    -- 512
    coe_sample_values_o : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);

    coe_sv_ready_o: out std_logic


    ); 


end quality_top;



architecture quality_top_rtl of quality_top is

  type Q_GATE_IN_TYPE is array (integer range <>) of std_logic_vector(Q_BITS-1 downto 0);
  signal quality_gate_in_tmp : Q_GATE_IN_TYPE (0 to (N_CHANNELS_ANA/2)-1);


  signal quality_bus_soft   : std_logic_vector((N_CHANNELS_ANA*BITS/2)-1 downto 0);
  signal quality_bus_gate_1 : std_logic_vector((N_CHANNELS_ANA*BITS/2)-1 downto 0);
  signal quality_bus_gate_2 : std_logic_vector((N_CHANNELS_ANA*BITS/2)-1 downto 0);

  signal coe_write_gate            : std_logic;
  signal coe_read_gate             : std_logic;
  signal do_mem_read, do_mem_write : std_logic;
  signal gate_ok                   : std_logic;


  signal coe_acq_bus_i_reg  : std_logic_vector(coe_acq_bus_i'range);
  signal coe_gain_bus_i_reg : std_logic_vector(coe_gain_bus_i'range);
  signal coe_ps_bus_i_reg   : std_logic_vector(coe_ps_bus_i'range);



  -- testing
  alias channel2_gate   : std_logic_vector(Q_BITS-1 downto 0) is quality_gate_in_tmp(N2_CHANNEL);
  alias channel2_soft   : std_logic_vector(BITS-1 downto 0) is quality_bus_soft(((N2_CHANNEL)* BITS)+(BITS-1) downto ((N2_CHANNEL)*BITS));
  alias channel2_to_mem : std_logic_vector(BITS-1 downto 0) is quality_bus_gate_2(((N2_CHANNEL)* BITS)+(BITS-1) downto ((N2_CHANNEL)*BITS));

  signal start_decod : std_logic;
  signal decod_ok    : std_logic_vector((N_CHANNELS_ANA/2)-1 downto 0);
  signal sv_ready    : std_logic_vector((N_CHANNELS_ANA/2)-1 downto 0);
  
begin
  
  process (coe_sysclk, reset_n)
  begin
    
    if reset_n = '0' then
      coe_acq_bus_i_reg  <= (others => '0');
      coe_gain_bus_i_reg <= (others => '0');
      coe_ps_bus_i_reg   <= (others => '0');
      
    elsif rising_edge(coe_sysclk) then
      
      coe_acq_bus_i_reg  <= coe_acq_bus_i;
      coe_gain_bus_i_reg <= coe_gain_bus_i;
      coe_ps_bus_i_reg   <= coe_ps_bus_i;
      
    end if;
  end process;



  gate_soft_interface_1 : entity work.gate_soft_interface
    port map (
      clk     => clk,
      reset_n => reset_n,

      avs_read       => avs_read,        --
      avs_address    => avs_address,     --
      avs_writedata  => avs_writedata,   -- 
      avs_readdata   => avs_readdata,    --
      avs_write      => avs_write,       -- 
      avs_chipselect => avs_chipselect,  --

      coe_sysclk     => coe_sysclk,     --
      coe_write_gate => do_mem_write,   -- 
      coe_read_gate  => do_mem_read,    --

      quality_bus_o => quality_bus_soft,    -- 256 bits
      quality_bus_i => quality_bus_gate_2,  -- 256 bits

      gate_ok_o => gate_ok
      );

  
  main_fsm_1 : entity work.main_fsm
    port map (
      sysclk         => coe_sysclk,     --
      reset_n        => reset_n,        --
      gate_ok_i      => gate_ok,        --
      ps_ready_i     => coe_phase_sum_ready_i,  -- 
      do_mem_read_o  => do_mem_read,    --
      do_mem_write_o => do_mem_write,   --
      start_decod_o  => start_decod,    --
      decod_ok_i     => decod_ok(4)     -- nro ciclos igual cada decoder
      );  

  
  
  GEN_REG : for I in 0 to (N_CHANNELS_ANA/2)-1 generate

    a : if ((I /= N2_CHANNEL) and (I /= N1_CHANNEL)) generate
      
      
      quality_or : entity work.quality_or
        port map (
          sysclk           => coe_sysclk,
          reset_n          => reset_n,
          quality_gate_in  => quality_gate_in_tmp(i),
          quality_soft_in  => quality_bus_soft((i+1)*BITS-1 downto i*BITS),
          quality_o        => quality_bus_gate_1((i+1)*BITS-1 downto i*BITS),
          data_available_i => '0',
          data_ready_o     => open);


      
      quality_gate_in_tmp(i) <= (OVF_POS => coe_acq_bus_i_reg(i),
                                 OOR_POS => coe_gain_bus_i_reg(i),
                                 others  => '0');


    end generate a;

    b : if (I = N1_CHANNEL) generate

      -- channel 1 neuter
      quality_or_neut1 : entity work.quality_or
        port map (
          sysclk           => coe_sysclk,
          reset_n          => reset_n,
          quality_gate_in  => quality_gate_in_tmp(i),
          quality_soft_in  => quality_bus_soft((i+1)*BITS-1 downto i*BITS),
          quality_o        => quality_bus_gate_1((i+1)*BITS-1 downto i*BITS),
          data_available_i => '0',
          data_ready_o     => open);

      quality_gate_in_tmp(i) <= (OVF_POS => coe_acq_bus_i_reg(i) or coe_ps_bus_i_reg(0),
                                 OOR_POS => coe_gain_bus_i_reg(i),
                                 D_POS   => coe_ps_bus_i_reg(1),
                                 others  => '0');

    end generate b;


    c : if (I = N2_CHANNEL) generate

      -- channel 2 neuter
      quality_or_neut2 : entity work.quality_or
        port map (
          sysclk           => coe_sysclk,
          reset_n          => reset_n,
          quality_gate_in  => quality_gate_in_tmp(i),
          quality_soft_in  => quality_bus_soft((i+1)*BITS-1 downto i*BITS),
          quality_o        => quality_bus_gate_1((i+1)*BITS-1 downto i*BITS),
          data_available_i => '0',
          data_ready_o     => open);

      quality_gate_in_tmp(i) <= (OVF_POS => coe_acq_bus_i_reg(i) or coe_ps_bus_i_reg(2),
                                 OOR_POS => coe_gain_bus_i_reg(i),
                                 D_POS   => coe_ps_bus_i_reg(3),
                                 others  => '0');

    end generate c;

  end generate GEN_REG;



  GEN_REG_2 : for I in 0 to (N_CHANNELS_ANA/2)-1 generate
    
    quality_decoder : entity work.quality_decoder
      port map
      (
        sysclk  => coe_sysclk,
        reset_n => reset_n,

        quality_i       => quality_bus_gate_1((i+1)*BITS-1 downto i*BITS),
        quality_decod_o => quality_bus_gate_2((i+1)*BITS-1 downto i*BITS),

        start_decod_i => start_decod,
        decod_ok_o    => decod_ok(i)
        );

  end generate GEN_REG_2;


  
  GEN_REG_3 : for I in 0 to (N_CHANNELS_ANA/2)-1 generate

    quality_insert_1 : entity work.quality_insert
      port map (
        sysclk            => coe_sysclk,                                           --
        reset_n           => reset_n,                                              --
        data_in           => coe_sample_values_i((i+1)*BITS-1 downto i*BITS),      --       
        data_in_available => decod_ok(i),                                          --
        data_out_ready    => sv_ready(i),                                          -- 
        data_out          => coe_sample_values_o(2*(i+1)*BITS-1 downto 2*i*BITS),  --  
        quality_fill_i    => quality_bus_gate_2((i+1)*BITS-1 downto i*BITS)        --
        );

  end generate GEN_REG_3;


  coe_sv_ready_o <= sv_ready(4);

  

end quality_top_rtl;




