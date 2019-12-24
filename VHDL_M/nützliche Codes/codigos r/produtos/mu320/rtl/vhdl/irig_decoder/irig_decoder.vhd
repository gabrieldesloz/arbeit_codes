-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : irig decoder
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : irig_decoder.vhd
-- Author     : Celso Souza
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-11-03
-- Last update: 2013-02-04
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:    decodes irig_b signal
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-11-03   1.0      CLS     Created
-------------------------------------------------------------------------------



-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


library work;
use work.mu320_constants.all;

entity irig_decoder is

-- Definition of incoming and outgoing signals.
  

  port (

    -- avalon signals
    clk        : in  std_logic;         -- avalon clock
    reset_n    : in  std_logic;
    address    : in  std_logic_vector(2 downto 0);
    byteenable : in  std_logic_vector(3 downto 0);
    readdata   : out std_logic_vector(31 downto 0);
    read       : in  std_logic;
    chipselect : in  std_logic;
    irq        : out std_logic;

    -- interface signals    
    sysclk    : in  std_logic;          -- system clock
    irig      : in  std_logic;          -- irig ttl input   
    irig_ok   : out std_logic;          -- signalizes that irig signal is present
    t_mark    : out std_logic;          -- one pulse per second
    sync_irig : out std_logic_vector(7 downto 0)
    );

end irig_decoder;

------------------------------------------------------------------------------

architecture irig_decoder_RTL of irig_decoder is

-- Type declarations

  type RAM is array (integer range <>) of std_logic_vector (31 downto 0);



-- constant declarations


-- Local (internal to the model) signals declarations.

  signal irig_ok_int    : std_logic;
  signal irig_store_reg : RAM(6 downto 0);
  signal irig_data      : std_logic_vector(223 downto 0);
  signal t_mark_int     : std_logic;
  signal rd_data        : std_logic;
  signal irig_ready     : std_logic;
  signal irig_sync1     : std_logic;
  signal irig_sync2     : std_logic;
  

begin

-- concurrent signal assignment statements
  irq     <= irig_ready;
  t_mark  <= t_mark_int;
  rd_data <= '1' when ((chipselect = '1') and (read = '1')) else '0';
  irig_ok <= irig_ok_int;

  sync_irig <= irig_data(149 downto 142) when (irig_ok_int = '1') else "11111111";

  get_irig_data_inst : entity work.get_irig_data
    port map(
      sysclk     => sysclk,
      n_reset    => reset_n,
      irig       => irig_sync2,
      t_mark     => t_mark_int,
      irig_ready => irig_ready,
      irig_data  => irig_data
      );

  irig_detector_inst : entity work.irig_detector
    port map(
      sysclk  => sysclk,
      n_reset => reset_n,
      irig    => irig_sync2,
      irig_ok => irig_ok_int
      );



-- reads irig data
  process (clk)
  begin  -- process    
    if rising_edge(clk) then
      if (rd_data = '1') then
        readdata <= irig_store_reg(CONV_INTEGER(address));
      end if;
    end if;
  end process;



  -- syncronize irig
  process(sysclk)
  begin
    if (rising_edge(sysclk)) then
      irig_sync1 <= irig;
      irig_sync2 <= irig_sync1;
    end if;
  end process;


-- transfer data from a vector to a record
  process (irig_data) is
  begin  -- process
    for i in 0 to 6 loop
      irig_store_reg(i) <= irig_data((i*32 + 31) downto i*32);
    end loop;
  end process;

end irig_decoder_RTL;

-- eof $Id: irig_decoder.vhd 4687 2009-07-29 12:27:03Z cls $

