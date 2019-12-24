-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : acquisition module
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : acquisition.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-10-25
-- Last update: 2013-02-19
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:   A VHDL module that controls analog and digital acquisition
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-10-25   1.0      CLS     Created
-------------------------------------------------------------------------------



-- Library and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mu320_constants.all;

entity acquisition is

-- Definition of incoming and outgoing signals.  
  
  port (
    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    -- sampling frequency
    sync_soc          : in  std_logic;
    -- cic_filter is ready
    ready_cic         : out std_logic;  -- cic filter is ready
    -- delta sigma signals
    mclk              : out std_logic;
    mdat              : in  std_logic_vector((N_CHANNELS_ANA - 1) downto 0);  --delta sigma input   
    -- digital input signals
    qdi_demux         : out std_logic_vector(3 downto 0);  -- digital input mux
    qdi_din           : in  std_logic_vector(1 downto 0);  -- digital input
    -- goose input signals
    goose_in          : in  std_logic_vector((N_GOOSE_INPUTS - 1) downto 0);
    -- control signals
    en                : in  std_logic;  -- module enable 
    -- outputs
    -- string with analog outputs
    d_ana             : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
    -- string with digital
    d_dig             : out std_logic_vector((N_CHANNELS_DIG - 1) downto 0);
    -- string with monitor relay states
    d_mon             : out std_logic_vector((N_CHANNELS_MON - 1) downto 0);
    -- string with goose inputs
    d_goose           : out std_logic_vector((N_GOOSE_INPUTS - 1) downto 0);
    -- string with goose inputs
    digital_available : out std_logic;
    goose_available   : out std_logic;
    ready_data        : out std_logic

    );

end entity acquisition;
-----------------------------------------------------------------
architecture acquisition_rtl of acquisition is

  -- Constant declarations
  constant DIV_CLK_SAMPLE : natural := 6;

  -- Type declarations
  
  type READ_DIGITAL_MUX_STATE_TYPE is (READ_DATA_STATE,
                                       INC_COUNTER_STATE);
  type DIGITAL_AVA_TYPE is (INCREMENT, VERIFY);

  attribute ENUM_ENCODING                                : string;
  attribute ENUM_ENCODING of READ_DIGITAL_MUX_STATE_TYPE : type is "0 1";
  attribute ENUM_ENCODING of DIGITAL_AVA_TYPE            : type is "0 1";




  -- used to store ADC readings   
  type ADC_REGISTER_TYPE is array (integer range <>)
    of std_logic_vector ((N_BITS_ADC - 1) downto 0);


  type INDEX_TYPE is array (integer range <>)
    of integer range 0 to ((N_CHANNELS_ANA * N_BITS_ADC) - 1);


-- Local (internal to the model) signals declarations.  
  signal read_digital_mux_state      : READ_DIGITAL_MUX_STATE_TYPE;
  signal read_digital_mux_state_next : READ_DIGITAL_MUX_STATE_TYPE;
  signal adc_register                : ADC_REGISTER_TYPE ((N_CHANNELS_ANA - 1) downto 0);
  signal d_ana_reg                   : std_logic_vector(((N_CHANNELS_ANA * N_BITS_ADC) - 1) downto 0);
  signal d_cic_int                   : std_logic_vector(((N_CHANNELS_ANA * N_BITS_ADC) - 1) downto 0);
  signal d_mux0_reg                  : std_logic_vector((N_CHANNELS_MUX - 1) downto 0);
  signal d_mux0_next                 : std_logic_vector((N_CHANNELS_MUX - 1) downto 0);
  signal d_mux1_reg                  : std_logic_vector((N_CHANNELS_MUX - 1) downto 0);
  signal d_mux1_next                 : std_logic_vector((N_CHANNELS_MUX - 1) downto 0);


  signal counter_mux      : natural range 0 to (N_CHANNELS_MUX - 1);
  signal counter_mux_next : natural range 0 to (N_CHANNELS_MUX - 1);
  signal en_div_int       : std_logic;
  signal ready_cic_int    : std_logic;
  signal fir_ok_int       : std_logic;
  signal ready_fir_int    : std_logic;

  signal digital_ava_state      : DIGITAL_AVA_TYPE;
  signal digital_ava_state_next : DIGITAL_AVA_TYPE;
  signal digital_counter        : std_logic_vector(3 downto 0);
  signal digital_counter_next   : std_logic_vector(3 downto 0);

  signal reset                     : std_logic;
  signal counter_sample_clock      : natural range 0 to (DIV_CLK_SAMPLE - 1);
  signal counter_sample_clock_next : natural range 0 to (DIV_CLK_SAMPLE - 1);
  signal freq_sample               : std_logic;
  signal freq_sample_next          : std_logic;
  signal edge_sample_freq          : std_logic;
  

begin
  
  reset <= not(n_reset);

-- concurrent signal assignment statements
  qdi_demux <= conv_std_logic_vector(counter_mux, 4);
  ready_cic <= ready_cic_int;
  mclk      <= freq_sample;
  

--generates sample_clock
  process(n_reset, sysclk)
  begin
    if (n_reset = '0') then
      counter_sample_clock <= 0;
      freq_sample          <= '0';
    elsif (rising_edge(sysclk)) then
      counter_sample_clock <= counter_sample_clock_next;
      freq_sample          <= freq_sample_next;
    end if;
  end process;

  process (counter_sample_clock, freq_sample) is
  begin
    freq_sample_next <= freq_sample;
    if (counter_sample_clock < (DIV_CLK_SAMPLE - 1)) then
      counter_sample_clock_next <= counter_sample_clock + 1;
      if (counter_sample_clock = (DIV_CLK_SAMPLE/2 - 1)) then
        freq_sample_next <= '0';
      end if;
    else
      counter_sample_clock_next <= 0;
      freq_sample_next          <= '1';
    end if;
  end process;


-- Component instantiations

  edge_detector_inst1 : entity work.edge_detector
    port map (
      n_reset  => n_reset,
      sysclk   => sysclk,
      f_in     => freq_sample,
      pos_edge => edge_sample_freq);


  ad7401_controller_inst_0 : entity work.ad7401_controller
    port map (
      n_reset  => n_reset,
      sysclk   => sysclk,
      ds_clk   => edge_sample_freq,
      mdat     => mdat(N_CHANNELS_ANA - 1),
      adc_data => adc_register(N_CHANNELS_ANA - 1),
      ready    => ready_cic_int);


  GEN_CONTROLLER : for I in 1 to (N_CHANNELS_ANA - 1) generate
    ad7401_controller_inst : entity work.ad7401_controller
      port map (
        n_reset  => n_reset,
        sysclk   => sysclk,
        ds_clk   => edge_sample_freq,
        mdat     => mdat(N_CHANNELS_ANA - I - 1),
        adc_data => adc_register(N_CHANNELS_ANA - I - 1));
  end generate GEN_CONTROLLER;



  fir_ser_inst : entity work.firser
    generic map (
      CHANNEL           => CHANNEL,
      CHANNEL_SIZE      => CHANNEL_SIZE,
      FILTER_ORDER      => FILTER_ORDER,
      FILTER_ORDER_SIZE => FILTER_ORDER_SIZE,
      MEMORY_SIZE       => MEMORY_SIZE,
      COEFICIENT_WIDTH  => COEFICIENT_WIDTH,
      DATA_WIDTH        => DATA_WIDTH,
      ACCUMULATOR_WIDTH => ACCUMULATOR_WIDTH,
      RESULT_WIDTH      => RESULT_WIDTH,
      OUTPUT_WIDTH      => OUTPUT_WIDTH)
    port map (
      n_reset       => n_reset,
      Enable        => en,
      sysclk        => sysclk,
      SampleInArray => d_cic_int,
      SampleInValid => ready_cic_int,
      ClearData     => reset,
      FIROutArray   => d_ana_reg,
      FIROutValid   => fir_ok_int);


  
  edge_detector_inst2 : entity work.edge_detector
    port map (
      n_reset  => n_reset,
      sysclk   => sysclk,
      f_in     => fir_ok_int,
      pos_edge => ready_fir_int);


  clk_divider_demux_inst : entity work.clk_divider_demux
    port map(sysclk  => sysclk,
             n_reset => n_reset,
             en_div  => en_div_int);


-- Processes
  TRANSFER : process (adc_register)
  begin
    for i in 0 to (N_CHANNELS_ANA - 1) loop
      for j in 0 to (N_BITS_ADC - 1) loop
        if j < (N_BITS_ADC - 1) then
          d_cic_int (i*N_BITS_ADC + j) <= adc_register(i)(j);
        else
          d_cic_int (i*N_BITS_ADC + j) <= not adc_register(i)(j);  -- 2'complement
        end if;
      end loop;
    end loop;
  end process TRANSFER;



  -- reads multiplexed digital inputs
  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      counter_mux            <= 0;
      d_mux0_reg             <= (others => '0');
      d_mux1_reg             <= (others => '0');
      read_digital_mux_state <= READ_DATA_STATE;
    elsif rising_edge(sysclk) then
      counter_mux            <= counter_mux_next;
      d_mux0_reg             <= d_mux0_next;
      d_mux1_reg             <= d_mux1_next;
      read_digital_mux_state <= read_digital_mux_state_next;
    end if;
  end process;

  process (counter_mux, d_mux0_reg, d_mux1_reg, en_div_int, qdi_din,
           read_digital_mux_state) is
  begin
    counter_mux_next            <= counter_mux;
    d_mux0_next                 <= d_mux0_reg;
    d_mux1_next                 <= d_mux1_reg;
    read_digital_mux_state_next <= read_digital_mux_state;
    case read_digital_mux_state is
      when READ_DATA_STATE =>
        d_mux0_next(counter_mux) <= qdi_din(0);
        d_mux1_next(counter_mux) <= qdi_din(1);
        if (counter_mux = (N_CHANNELS_MUX - 1)) then
          counter_mux_next <= 0;
        else
          counter_mux_next <= counter_mux + 1;
        end if;
        read_digital_mux_state_next <= INC_COUNTER_STATE;

      when INC_COUNTER_STATE =>
        if (en_div_int = '1') then
          read_digital_mux_state_next <= READ_DATA_STATE;
        end if;

      when others => null;
    end case;
  end process;


  -- syncronizes goose and digital inputs
  process (n_reset, sysclk) is
  begin  -- process
    if (n_reset = '0') then
      d_dig   <= (others => '0');
      d_mon   <= (others => '0');
      d_goose <= (others => '0');
    elsif (rising_edge(sysclk)) then
      if (ready_fir_int = '1') then
        d_dig   <= d_mux1_reg((N_CHANNELS_DIG/2 - 1) downto 0) & d_mux0_reg((N_CHANNELS_DIG/2 - 1) downto 0);
        d_mon   <= d_mux1_reg((N_CHANNELS_MUX - 1) downto (N_CHANNELS_MUX - N_CHANNELS_MON/2)) & d_mux0_reg((N_CHANNELS_MUX - 1) downto (N_CHANNELS_MUX - N_CHANNELS_MON/2));
        d_goose <= goose_in;
        
      end if;
    end if;
  end process;

  process (n_reset, sysclk) is
  begin
    if n_reset = '0' then
      digital_ava_state <= INCREMENT;
      digital_counter   <= (others => '0');
    elsif rising_edge(sysclk) then
      digital_ava_state <= digital_ava_state_next;
      digital_counter   <= digital_counter_next;
    end if;
  end process;

  process (digital_ava_state, digital_counter, ready_fir_int)
  begin

    digital_ava_state_next <= digital_ava_state;
    digital_counter_next   <= digital_counter;

    case digital_ava_state is
      
      when INCREMENT =>
        digital_available <= '0';
        goose_available   <= '0';
        if ready_fir_int = '1' then
          digital_counter_next   <= digital_counter + '1';
          digital_ava_state_next <= VERIFY;
        end if;
        
      when VERIFY =>
        if digital_counter = "1111" then
          digital_available    <= '1';
          goose_available      <= '1';
          digital_counter_next <= (others => '0');
        end if;
        digital_ava_state_next <= INCREMENT;
        
      when others =>
        
    end case;

  end process;


  process (n_reset, sysclk) is
  begin
    if n_reset = '0' then
      d_ana <= (others => '0');
      ready_data <= '0';
    elsif rising_edge(sysclk) then
      ready_data <= sync_soc;
      if (sync_soc = '1') then
        d_ana <= d_ana_reg;
      end if;
    end if;
  end process;
  


end architecture acquisition_rtl;

--eof $Id: 


