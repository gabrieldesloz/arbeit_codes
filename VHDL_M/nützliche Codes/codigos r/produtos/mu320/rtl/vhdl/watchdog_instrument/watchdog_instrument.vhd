-------------------------------------------------------------------------------
-- Title   : Watchdog Instrument
-- Project : MU_320
-------------------------------------------------------------------------------
-- File          : watchdog_instrument.vhd
-- Author        : Gabriel Lozano
-- Company       : Reason Tecnologia S.A.
-- Created       : 2013-06-18
-- Last update   : 2013-06-18
-- Target Device :
-- Standard      : VHDL'93
-------------------------------------------------------------------------------
-- Description   : Watchdog do Instrument
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-------------------------------------------------------------------------------
-- Revisions     :
-- Date          Version Author Description
-- 2013-06-18    1.0     GDL    Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity watchdog_instrument is


  generic (

    FREQ_MHZ : integer := 25

    );

  port (

    -- Avalon clock Interface
    sysclk  : in std_logic;
    -- Reset Sync
    reset_n :    std_logic;

    -- Avalon MM Slave - Interface
    avs_read       : in  std_logic;
    avs_address    : in  std_logic_vector(1 downto 0);
    avs_chipselect : in  std_logic;
    avs_write      : in  std_logic;
    avs_writedata  : in  std_logic_vector(31 downto 0);
    avs_readdata   : out std_logic_vector(31 downto 0);

    -- Conduit Interface

    coe_alarm : out std_logic

    );


end entity;


architecture RTL of watchdog_instrument is

  -- 4 segundos
  constant INSTRUMENT_TIMEOUT : integer := FREQ_MHZ*4*1_000_000;
  
  
  
  type TIMEOUT_TYPE is (ST_TIMEOUT_COUNT, ST_TIMEOUT_TIMEOUT);
  signal count_reg, count_next : unsigned(31 downto 0);
  signal state_reg, state_next : TIMEOUT_TYPE;
  signal clear_count           : std_logic;

  attribute syn_encoding : string;
  attribute syn_encoding of TIMEOUT_TYPE: TYPE is "safe";

  
  
begin

--=======================================================
-- Registers
--=======================================================
  
  regs_wtd_timeout : process (reset_n, sysclk)
  begin
    if (reset_n = '0') then
      state_reg <= ST_TIMEOUT_TIMEOUT;
      count_reg <= (others => '0');

    elsif rising_edge(sysclk) then
      state_reg <= state_next;
      count_reg <= count_next;
      
    end if;
  end process;

  --=======================================================
  -- write / read decoding logic
  --=======================================================
  clear_count <= '1' when ((avs_write = '1') and (avs_chipselect = '1')) else '0';


  --=======================================================
  -- FSM - timeout
  --=======================================================
  
  fsm_wtd_timeout : process(avs_writedata, clear_count, count_reg, state_reg)

  begin

    state_next <= state_reg;
    count_next <= count_reg;
    

    case state_reg is
      
      when ST_TIMEOUT_COUNT =>

        coe_alarm <= '0';
        if clear_count = '1' then
          count_next <= unsigned(avs_writedata);
        elsif (count_reg = INSTRUMENT_TIMEOUT) then
          state_next <= ST_TIMEOUT_TIMEOUT;
        else
          count_next <= count_reg + 1;
        end if;


      when ST_TIMEOUT_TIMEOUT =>

        coe_alarm <= '1';

        if clear_count = '1' then
          count_next <= unsigned(avs_writedata);
          state_next <= ST_TIMEOUT_COUNT;
        end if;
        
      when others =>
        state_next <= ST_TIMEOUT_COUNT;
    end case;
  end process;

  
  

end architecture;
