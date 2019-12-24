-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : burst filter
--            : acquisition system
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : bfilter.vhd
-- Author     : Celso Luis de Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-12-07
-- Last update: 2012-12-12
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-05-31  1.0      APR     Created
-------------------------------------------------------------------------------



-- Libraries and use clauses

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;


library work;
use work.rl131_constants.all;


entity bfilter is
  port (
    -- system signals
    sysclk  : in std_logic;
    reset_n : in std_logic;

    -- interface signals
    start     : in  std_logic;
    ready     : out std_logic;
    d_ana_in  : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
    d_ana_out : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0)

    );
end bfilter;
------------------------------------------------------------
architecture bfilter_rtl of bfilter is

  type DATA_TYPE is array ((N_CHANNELS_ANA - 1) downto 0) of std_logic_vector(((N_BITS_ADC) - 1) downto 0);
  

  type STATE_BFILTER_TYPE is (CLEAR_MEMORY_STATE_1, CLEAR_MEMORY_STATE_2,
                              CLEAR_MEMORY_STATE_3, WAIT_START_STATE,
                              FILTER_STATE, WRITE_MEMORY_STATE,
                              UPDATE_COUNTER_STATE, WAIT_MEMORY_STATE);



  attribute syn_encoding                       : string;
  attribute syn_encoding of STATE_BFILTER_TYPE : type is "safe";

  --attribute ENUM_ENCODING                       : string;
  --attribute ENUM_ENCODING of STATE_BFILTER_TYPE : type is "000 001 010 011 100 101 110 111";


  signal state_bfilter      : STATE_BFILTER_TYPE;
  signal state_bfilter_next : STATE_BFILTER_TYPE;

  signal d_ana_register_in       : DATA_TYPE;
  signal d_ana_register_out_next : DATA_TYPE;
  signal d_ana_register_out_reg  : DATA_TYPE;

  signal counter_reg, counter_next : natural range 0 to (N_CHANNELS_ANA - 1);

  signal bfilter_memory_address                          : std_logic_vector(3 downto 0);
  signal bfilter_data_write_reg, bfilter_data_write_next : std_logic;

  signal bfilter_data_reg, bfilter_data_next, bfilter_data_read : std_logic_vector((2*N_BITS_ADC - 1) downto 0);

  signal ready_reg, ready_next : std_logic;

  signal sample_new_read  : std_logic_vector((N_BITS_ADC - 1) downto 0);
  signal count_test_reset : std_logic;

  --teste
  signal d_ana_in_int      : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
  signal burst_ein         : std_logic := '0';
  signal counter_test_reg  : std_logic_vector(31 downto 0);
  signal counter_test_next : std_logic_vector(31 downto 0);
  signal period_samp_test  : std_logic := '0';

  ------------------------------------------------------------------------------

  alias sample0_reg  : std_logic_vector((N_BITS_ADC - 1) downto 0) is bfilter_data_reg((N_BITS_ADC - 1) downto 0);
  alias sample0_next : std_logic_vector((N_BITS_ADC - 1) downto 0) is bfilter_data_next((N_BITS_ADC - 1) downto 0);
  alias sample1_reg  : std_logic_vector((N_BITS_ADC - 1) downto 0) is bfilter_data_reg((2*N_BITS_ADC - 1) downto N_BITS_ADC);
  alias sample1_next : std_logic_vector((N_BITS_ADC - 1) downto 0) is bfilter_data_next((2*N_BITS_ADC - 1) downto N_BITS_ADC);
  alias sample0_read : std_logic_vector((N_BITS_ADC - 1) downto 0) is bfilter_data_read((N_BITS_ADC - 1) downto 0);
  alias sample1_read : std_logic_vector((N_BITS_ADC - 1) downto 0) is bfilter_data_read((2*N_BITS_ADC - 1) downto N_BITS_ADC);

--teste----
  alias channel_1_in_burst : std_logic_vector(8-1 downto 0) is d_ana_in_int(31 downto 32-8);
  alias channel_2_in_burst : std_logic_vector(8-1 downto 0) is d_ana_in_int(23 downto 24-8);
  alias channel_3_in_burst : std_logic_vector(8-1 downto 0) is d_ana_in_int(15 downto 16-8);
  alias channel_4_in_burst : std_logic_vector(8-1 downto 0) is d_ana_in_int(7 downto 0);

  alias channel_1_in : std_logic_vector(8-1 downto 0) is d_ana_in(31 downto 32-8);
  alias channel_2_in : std_logic_vector(8-1 downto 0) is d_ana_in(23 downto 24-8);
  alias channel_3_in : std_logic_vector(8-1 downto 0) is d_ana_in(15 downto 16-8);
  alias channel_4_in : std_logic_vector(8-1 downto 0) is d_ana_in(7 downto 0);

  alias channel_1_out : std_logic_vector(8-1 downto 0) is d_ana_out(31 downto 32-8);
  alias channel_2_out : std_logic_vector(8-1 downto 0) is d_ana_out(23 downto 24-8);
  alias channel_3_out : std_logic_vector(8-1 downto 0) is d_ana_out(15 downto 16-8);
  alias channel_4_out : std_logic_vector(8-1 downto 0) is d_ana_out(7 downto 0);
-------------------------------------------------------------------------------
  

begin

  ready           <= ready_reg;
  sample_new_read <= d_ana_register_in(counter_reg);

  --teste
  counter_test_next <= counter_test_reg + 1 when count_test_reset = '0'             else (others => '0');
  count_test_reset  <= '1'                  when (counter_test_reg = ((2**32) - 1)) else '0';

  --processo teste
  --process(counter_test_reg, d_ana_in)
  --begin
  --  if counter_test_reg >= 260 and counter_test_reg < 271 then
  --    burst_ein <= '1';
  --    if counter_test_reg = 260 then
  --      d_ana_in_int <= d_ana_in + 15177001;
  --    elsif counter_test_reg = 264 then
  --      d_ana_in_int <= d_ana_in + 35103501;
  --    elsif counter_test_reg = 268 then
  --      d_ana_in_int <= d_ana_in + 15103991;
  --    end if;
  --  else
  --    burst_ein    <= '0';
  --    d_ana_in_int <= d_ana_in;
  --  end if;
  --end process;


  --process(counter_test_reg, d_ana_in)
  --begin
  --  if counter_test_reg >= 260 and counter_test_reg < 276 then
  --    burst_ein <= '1';
  --    if counter_test_reg = 260 then
  --      d_ana_in_int <= d_ana_in + 15177001;
  --    elsif counter_test_reg = 264 then
  --      d_ana_in_int <= d_ana_in + 35103501;
  --    elsif counter_test_reg = 268 then
  --      d_ana_in_int <= d_ana_in + 15103991;
  --    elsif counter_test_reg = 272 then
  --      d_ana_in_int <= d_ana_in + 55122991;
  --    end if;
  --  else
  --    burst_ein    <= '0';
  --    d_ana_in_int <= d_ana_in;
  --  end if;
  --end process;


  process(counter_test_reg, d_ana_in)
  begin
    if counter_test_reg >= 260 and counter_test_reg < 290 then
      burst_ein <= '1';
      if counter_test_reg = 260 then
        d_ana_in_int <= d_ana_in + 15177001;
      elsif counter_test_reg = 264 then
        d_ana_in_int <= d_ana_in + 35103501;
      elsif counter_test_reg = 268 then
        d_ana_in_int <= d_ana_in + 15103991;
      elsif counter_test_reg = 272 then
        d_ana_in_int <= d_ana_in + 55122991;
      elsif counter_test_reg = 276 then
        d_ana_in_int <= d_ana_in + 11122991;
      elsif counter_test_reg = 278 then
        d_ana_in_int <= d_ana_in + 71120001;
       elsif counter_test_reg = 282 then
        d_ana_in_int <= d_ana_in + 88888888;  
      end if;
    else
      burst_ein    <= '0';
      d_ana_in_int <= d_ana_in;
    end if;
  end process;

-- memory instance

  bfilter_data_ram_inst_1 : entity work.bfilter_data_ram
    generic map (
      DATA_WIDTH => (N_BITS_ADC * 2))
    port map (
      sysclk       => sysclk,
      ReadAddress  => bfilter_memory_address,
      WriteAddress => bfilter_memory_address,
      write        => bfilter_data_write_reg,
      WriteData    => bfilter_data_reg,
      ReadData     => bfilter_data_read);

-- memory assignments
  bfilter_memory_address <= CONV_STD_LOGIC_VECTOR(counter_reg, 4);


-- converts from array to register
  process (d_ana_in_int) is
  begin
    for i in 0 to (N_CHANNELS_ANA - 1) loop
      d_ana_register_in(i) <= d_ana_in_int((N_BITS_ADC*(i+1) - 1) downto N_BITS_ADC*i);
    end loop;
  end process;



-- converts from register to array
  process (d_ana_register_out_reg) is
  begin
    for i in 0 to (N_CHANNELS_ANA - 1) loop
      d_ana_out((N_BITS_ADC*(i+1) - 1) downto N_BITS_ADC*i) <= d_ana_register_out_reg(i);
    end loop;
  end process;




-- process that scans all channels
  process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      counter_test_reg       <= (others => '0');
      state_bfilter          <= CLEAR_MEMORY_STATE_1;
      counter_reg            <= 0;
      bfilter_data_reg       <= (others => '0');
      bfilter_data_write_reg <= '0';
      ready_reg              <= '0';
      for i in 0 to (N_CHANNELS_ANA - 1) loop
        d_ana_register_out_reg(i) <= (others => '0');
      end loop;
    elsif rising_edge(sysclk) then
      counter_test_reg       <= counter_test_next;
      state_bfilter          <= state_bfilter_next;
      counter_reg            <= counter_next;
      bfilter_data_reg       <= bfilter_data_next;
      bfilter_data_write_reg <= bfilter_data_write_next;
      d_ana_register_out_reg <= d_ana_register_out_next;
      ready_reg              <= ready_next;
    end if;
  end process;




  process (bfilter_data_reg, counter_reg, sample_new_read,
           d_ana_register_out_reg, sample1_reg, start, state_bfilter, ready_reg) is
  begin
    state_bfilter_next      <= state_bfilter;
    ready_next              <= '0';
    counter_next            <= counter_reg;
    bfilter_data_next       <= bfilter_data_reg;
    bfilter_data_write_next <= '0';
    d_ana_register_out_next <= d_ana_register_out_reg;
    --teste
    period_samp_test        <= '0';
    case state_bfilter is

      when CLEAR_MEMORY_STATE_1 =>
        bfilter_data_next       <= (others => '0');
        bfilter_data_write_next <= '1';
        state_bfilter_next      <= CLEAR_MEMORY_STATE_2;

      when CLEAR_MEMORY_STATE_2 =>
        state_bfilter_next <= CLEAR_MEMORY_STATE_3;
        
      when CLEAR_MEMORY_STATE_3 =>
        if (counter_reg < (N_CHANNELS_ANA - 1)) then
          counter_next       <= counter_reg + 1;
          state_bfilter_next <= CLEAR_MEMORY_STATE_1;
        else
          state_bfilter_next <= WAIT_START_STATE;
          counter_next       <= 0;
        end if;

      when WAIT_START_STATE =>
        if (start = '1') then
          state_bfilter_next <= FILTER_STATE;
        end if;

      when FILTER_STATE =>
        period_samp_test <= '1';
        if (sample_new_read < sample0_read) then  -- sample_new_read < sample0_read here
          if (sample_new_read < sample1_read) then  --   sample_new_read < sample1_read     : sample_new_read the smallest
            if (sample0_read < sample1_read) then  --      sample0_read < sample1_read  : sample_new_read < sample0_read < sample1_read
              d_ana_register_out_next(counter_reg) <= sample0_read;
            else  --      sample1_read <= sample0_read : sample_new_read < sample1_read <= sample0_read
              d_ana_register_out_next(counter_reg) <= sample1_read;
            end if;
          else  --   sample_new_read >= sample1_read    : sample1_read <= sample_new_read < sample0_read
            d_ana_register_out_next(counter_reg) <= sample_new_read;
          end if;
        else                            -- sample0_read <= sample_new_read here
          if (sample0_read < sample1_read) then  --   sample0_read < sample1_read     : sample0_read the smallest
            if (sample_new_read < sample1_read) then  --     sample_new_read < sample1_read   : sample0_read <= sample_new_read < sample1_read
              d_ana_register_out_next(counter_reg) <= sample_new_read;
            else  --     sample_new_read >= sample1_read  : sample0_read < sample1_read <= sample_new_read
              d_ana_register_out_next(counter_reg) <= sample1_read;
            end if;
          else  --   sample1_read <= sample0_read    : sample1_read <= sample0_read <= sample_new_read
            d_ana_register_out_next(counter_reg) <= sample0_read;
          end if;
        end if;
        sample0_next            <= sample_new_read;
        sample1_next            <= sample0_read;
        bfilter_data_write_next <= '1';
        ready_next              <= '1';
        state_bfilter_next      <= WRITE_MEMORY_STATE;

      when WRITE_MEMORY_STATE =>
        state_bfilter_next <= UPDATE_COUNTER_STATE;

      when UPDATE_COUNTER_STATE =>
        if counter_reg < (N_CHANNELS_ANA - 1) then
          counter_next       <= counter_reg + 1;
          state_bfilter_next <= WAIT_MEMORY_STATE;
        else
          counter_next       <= 0;
          state_bfilter_next <= WAIT_START_STATE;
        end if;

      when WAIT_MEMORY_STATE =>
        state_bfilter_next <= FILTER_STATE;


      when others => null;
    end case;
  end process;




end bfilter_rtl;



