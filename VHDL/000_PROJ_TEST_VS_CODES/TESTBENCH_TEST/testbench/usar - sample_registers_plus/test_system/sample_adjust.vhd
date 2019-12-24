-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : sample_adjust.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-06
-- Last update: 2012-09-11
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-06  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

library work;
use work.mu320_constants.all;


entity sample_adjust is
  
  port (
    -- avalon signals
    clk        : in std_logic;
    reset_n    : in std_logic;
    address    : in std_logic_vector(3 downto 0);
    byteenable : in std_logic_vector(3 downto 0);
    writedata  : in std_logic_vector(31 downto 0);
    write      : in std_logic;
    chipselect : in std_logic;

    -- Module Signals
    sysclk            : in  std_logic;
    data_in           : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
    data_in_available : in  std_logic;
    data_out_ready    : out std_logic;
    data_out          : out std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0));

end sample_adjust;


architecture sample_adjust_rtl of sample_adjust is

  -- Type and enumeration declarations 
  type BUFFER_R is array (integer range <>) of std_logic_vector(31 downto 0);
  type SAMPLE_ADJUST_TYPE is (WAIT_READY, APPLY_GAIN,
                              APPLY_OFFSET,
                              INCREMENT);

  attribute ENUM_ENCODING                       : string;
  attribute ENUM_ENCODING of SAMPLE_ADJUST_TYPE : type is "00 01 10 11";

  signal sample_adjust_state      : SAMPLE_ADJUST_TYPE;
  signal sample_adjust_state_next : SAMPLE_ADJUST_TYPE;

  -- Internal signals
  signal gain_register             : BUFFER_R((N_CHANNELS_ANA - 1) downto 0);
  signal write_register            : std_logic;
  signal data_register             : std_logic_vector(255 downto 0);
  signal data_register_next        : std_logic_vector(255 downto 0);
  signal data_output_register      : std_logic_vector(511 downto 0);
  signal data_output_register_next : std_logic_vector(511 downto 0);
  signal counter                   : std_logic_vector(3 downto 0);
  signal counter_next              : std_logic_vector(3 downto 0);
  signal acc_reg                   : std_logic_vector(48 downto 0);
  signal acc_reg_next              : std_logic_vector(48 downto 0);
  signal data_ready_reg            : std_logic;
  signal data_ready_next           : std_logic;
  
begin

  data_out       <= data_output_register;
  data_out_ready <= data_ready_reg;
  write_register <= '1' when ((chipselect = '1') and (write = '1')) else '0';

  process (clk)
  begin  -- process    
    if rising_edge(clk) then
      if (reset_n = '0') then
        for i in 0 to N_CHANNELS_ANA - 1 loop
          gain_register(i) <= (others => '0');
        end loop;  -- i
      elsif (write_register = '1') then
        gain_register(CONV_INTEGER('0' & address)) <= writedata;
      end if;
    end if;
  end process;


  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      sample_adjust_state  <= WAIT_READY;
      data_register        <= (others => '0');
      data_output_register <= (others => '0');
      counter              <= (others => '0');
      acc_reg              <= (others => '0');
      data_ready_reg       <= '0';
    elsif rising_edge(sysclk) then  -- rising clock edge
      sample_adjust_state  <= sample_adjust_state_next;
      data_register        <= data_register_next;
      data_output_register <= data_output_register_next;
      counter              <= counter_next;
      acc_reg              <= acc_reg_next;
      data_ready_reg       <= data_ready_next;
    end if;
  end process;

  process (acc_reg, counter, data_in, data_in_available, data_ready_reg,
           data_register, gain_register, sample_adjust_state)
  begin  -- process
    sample_adjust_state_next  <= sample_adjust_state;
    data_register_next        <= data_register;
    data_output_register_next <= data_output_register;
    counter_next              <= counter;
    acc_reg_next              <= acc_reg;
    data_ready_next           <= data_ready_reg;

    case sample_adjust_state is
      when WAIT_READY =>
        data_ready_next <= '0';
        counter_next    <= (others => '0');
        if data_in_available = '1' then
          data_register_next       <= data_in;
          sample_adjust_state_next <= APPLY_GAIN;
        end if;
        
      when APPLY_GAIN =>
        acc_reg_next             <= data_register(((CONV_INTEGER('0' & counter)*16)+15) downto CONV_INTEGER('0' & counter)*16) *('0' & gain_register(CONV_INTEGER('0' & counter)));
        sample_adjust_state_next <= APPLY_OFFSET;
        
      when APPLY_OFFSET =>
        data_output_register_next(((CONV_INTEGER('0' & counter)*32)+31) downto CONV_INTEGER('0' & counter)*32) <= acc_reg_next(47 downto 16);
        sample_adjust_state_next                                                                               <= INCREMENT;
      when INCREMENT =>
        if ('0' & counter) < "01111" then
          counter_next             <= counter + '1';
          sample_adjust_state_next <= APPLY_GAIN;
        else
          --data_output            <= data_register;
          data_ready_next          <= '1';
          sample_adjust_state_next <= WAIT_READY;
        end if;
      when others =>
        sample_adjust_state_next <= WAIT_READY;
    end case;
    
  end process;
  
end sample_adjust_rtl;



