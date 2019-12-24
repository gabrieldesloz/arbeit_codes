-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : inter_eth.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-05-18
-- Last update: 2012-06-19
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-05-18  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--library work;
--use work.mu320_constants.all;

entity inter_eth is
  generic (
    SYMBOLS_PER_BEAT : natural := 4;
    BITS_PER_SYMBOL  : natural := 8;
    READY_LATENCY    : natural := 0;
    ERROR_LENGTH     : natural := 1);

  port (
    reset_n : in std_logic;
    sysclk  : in std_logic;

    sink_dma_ready : out std_logic;
    sink_dma_valid : in  std_logic;
    sink_dma_data  : in  std_logic_vector(31 downto 0);
    sink_dma_empty : in  std_logic_vector(1 downto 0);
    sink_dma_sop   : in  std_logic;
    sink_dma_eop   : in  std_logic;
    sink_dma_err   : in  std_logic_vector((ERROR_LENGTH - 1) downto 0);

    sink_analog_ready : out std_logic;
    sink_analog_valid : in  std_logic;
    sink_analog_data  : in  std_logic_vector(31 downto 0);
    sink_analog_empty : in  std_logic_vector(1 downto 0);
    sink_analog_sop   : in  std_logic;
    sink_analog_eop   : in  std_logic;
    sink_analog_err   : in  std_logic_vector((ERROR_LENGTH - 1) downto 0);

    source_ready : in  std_logic;
    source_valid : out std_logic;
    source_data  : out std_logic_vector(31 downto 0);
    source_empty : out std_logic_vector(1 downto 0);
    source_sop   : out std_logic;
    source_eop   : out std_logic;
    source_err   : out std_logic_vector((ERROR_LENGTH - 1) downto 0);

    hold_counter : in std_logic_vector(3 downto 0)
    );


end inter_eth;

architecture inter_eth_struct of inter_eth is

  type INTER_ETH_TYPE is (VERIFY_SOP_DMA, VERIFY_EOP_DMA, VERIFY_SOP_ANALOG, VERIFY_EOP_ANALOG);

  attribute ENUM_ENCODING                   : string;
  attribute ENUM_ENCODING of INTER_ETH_TYPE : type is "00 01 10 11";


  signal register_machine_state      : INTER_ETH_TYPE;
  signal register_machine_state_next : INTER_ETH_TYPE;

  signal arbiter      : std_logic_vector(1 downto 0);
  signal arbiter_next : std_logic_vector(1 downto 0);
  signal owner        : std_logic;
  signal owner_next   : std_logic;
  signal counter      : std_logic_vector(3 downto 0);
  signal counter_next : std_logic_vector(3 downto 0);

  signal data_input        : std_logic_vector(31 downto 0);
  signal data_input_next   : std_logic_vector(31 downto 0);
  signal ready_output      : std_logic;
  signal ready_output_next : std_logic;
  signal sop_input         : std_logic;
  signal sop_input_next    : std_logic;
  signal eop_input         : std_logic;
  signal eop_input_next    : std_logic;
  signal error_input       : std_logic;
  signal error_input_next  : std_logic;
  signal empty_input       : std_logic_vector(1 downto 0);
  signal empty_input_next  : std_logic_vector(1 downto 0);

  signal data_output       : std_logic_vector(31 downto 0);
  signal data_output_next  : std_logic_vector(31 downto 0);
  signal valid_output      : std_logic;
  signal valid_output_next : std_logic;
  signal sop_output        : std_logic;
  signal sop_output_next   : std_logic;
  signal eop_output        : std_logic;
  signal eop_output_next   : std_logic;
  signal error_output      : std_logic;
  signal error_output_next : std_logic;
  signal empty_output      : std_logic_vector(1 downto 0);
  signal empty_output_next : std_logic_vector(1 downto 0);

begin  -- mu320_struct  

  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      arbiter                <= "00";
      owner                  <= '0';
      counter                <= (others => '0');
      register_machine_state <= VERIFY_SOP_DMA;
    elsif rising_edge(sysclk) then      -- rising clock edge
      arbiter                <= arbiter_next;
      owner                  <= owner_next;
      counter                <= counter_next;
      register_machine_state <= register_machine_state_next;
    end if;
  end process;

  process (arbiter, counter, owner, register_machine_state, sink_analog_data,
           sink_analog_empty, sink_analog_eop, sink_analog_err,
           sink_analog_sop, sink_analog_valid, sink_dma_data, sink_dma_empty,
           sink_dma_eop, sink_dma_err, sink_dma_sop, sink_dma_valid,
           source_ready)

    
  begin  -- process

    if arbiter = "00" then
      source_valid      <= sink_dma_valid;
      source_data       <= sink_dma_data;
      source_empty      <= sink_dma_empty;
      source_sop        <= sink_dma_sop;
      source_eop        <= sink_dma_eop;
      source_err        <= sink_dma_err;
      sink_dma_ready    <= source_ready;
      sink_analog_ready <= '0';
    elsif arbiter = "01" then
      source_valid      <= sink_analog_valid;
      source_data       <= sink_analog_data;
      source_empty      <= sink_analog_empty;
      source_sop        <= sink_analog_sop;
      source_eop        <= sink_analog_eop;
      source_err        <= sink_analog_err;
      --sink_analog_ready   <= '0';
      sink_dma_ready    <= '0';
      sink_analog_ready <= source_ready;
    elsif arbiter = "10" then
      sink_dma_ready <= '1';
      --sink_analog_ready <= '0';
    elsif arbiter = "11" then
      --sink_analog_ready <= '1';
      sink_dma_ready <= '0';
    end if;

    register_machine_state_next <= register_machine_state;
    arbiter_next                <= arbiter;
    owner_next                  <= owner;
    counter_next                <= counter;


    case register_machine_state is
      when VERIFY_SOP_DMA =>
        if sink_dma_sop = '1' then
          arbiter_next                <= "00";
          owner_next                  <= '1';
          register_machine_state_next <= VERIFY_EOP_DMA;
        else          
          if counter < hold_counter then
            counter_next <= counter + '1';
          else
            if owner = '0' and sink_dma_sop = '0' then
              arbiter_next                <= "01";
              counter_next                <= (others => '0');
              register_machine_state_next <= VERIFY_SOP_ANALOG;
            end if;
          end if;
        end if;

      when VERIFY_EOP_DMA =>
        if sink_dma_eop = '1' then
          arbiter_next                <= "01";
          owner_next                  <= '0';
          counter_next                <= (others => '0');
          register_machine_state_next <= VERIFY_SOP_ANALOG;
        end if;
        
      when VERIFY_SOP_ANALOG =>
        if sink_analog_sop = '1' then
          arbiter_next                <= "01";
          owner_next                  <= '1';
          register_machine_state_next <= VERIFY_EOP_ANALOG;
        else          
          if counter < hold_counter then
            counter_next <= counter + '1';
          else
            if owner = '0' and sink_analog_sop = '0' then
              arbiter_next                <= "00";
              counter_next                <= (others => '0');
              register_machine_state_next <= VERIFY_SOP_DMA;
            end if;
          end if;
        end if;

      when VERIFY_EOP_ANALOG =>
        if sink_analog_eop = '1' then
          arbiter_next                <= "00";
          owner_next                  <= '0';
          counter_next                <= (others => '0');
          register_machine_state_next <= VERIFY_SOP_DMA;
        end if;
        
      when others =>
        register_machine_state_next <= VERIFY_SOP_DMA;
        
    end case;
  end process;


end inter_eth_struct;




