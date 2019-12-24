

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;



package avalon_definitions is


  type avs_type is record
    sample_address    : std_logic_vector(4 downto 0);
    sample_writedata  : std_logic_vector(31 downto 0);
    sample_read       : std_logic;
    sample_chipselect : std_logic;
    sample_write      : std_logic;
    sample_readdata   : std_logic_vector(31 downto 0);
  end record avs_type;


end package avalon_definitions;

package body avalon_definitions is

  procedure start_sync_5(signal avs : inout avs_type; do : in std_logic) is
  begin
    avs.sample_address   <= std_logic_vector(to_unsigned(0, 5));
    avs.sample_writedata <= x"0000000" & "0011";
    avs.sample_read     <= '0';
    if do = '1' then
      avs.sample_chipselect <= '1';
      avs.sample_write      <= '1';
    else
      avs.sample_chipselect <= '0';
      avs.sample_write      <= '0';
    end if;
  end procedure start_sync_5;




  -- inicia - amostragem 16 e com sincronia
  procedure start_sync_16(signal avs : inout avs_type; do : in std_logic) is
  begin
    avs.sample_address <= std_logic_vector(to_unsigned(0, 5));
    avs.sample_writedata   <= x"0000000" & "0111";
    if do = '1' then
      avs.sample_chipselect <= '1';
      avs.sample_write      <= '1';
    else
      avs.sample_chipselect <= '0';
      avs.sample_write      <= '0';
    end if;
  end procedure start_sync_16;


  -- inicia - limpa irq
  procedure limpa_irq(signal avs : inout avs_type; do : in std_logic) is
  begin
    avs.sample_address   <= std_logic_vector(to_unsigned(1, 5));
    avs.sample_writedata <= x"0000000" & "0010";
    avs.sample_read      <= '0';
    if do = '1' then
      avs.sample_chipselect <= '1';
      avs.sample_write      <= '1';
    else
      avs.sample_chipselect <= '0';
      avs.sample_write      <= '0';
    end if;
  end procedure limpa_irq;



  -- inicia - para execução
  procedure para(signal avs : inout avs_type; do : in std_logic) is
  begin
    avs.sample_address   <= std_logic_vector(to_unsigned(0, 5));
    avs.sample_writedata <= x"0000000" & "0000";
    avs.sample_read      <= '0';
    if do = '1' then
      avs.sample_chipselect <= '1';
      avs.sample_write      <= '1';
    else
      avs.sample_chipselect <= '0';
      avs.sample_write      <= '0';
    end if;
  end procedure para;



  -- inicia - para execução
  procedure start_nsync_5(signal avs : inout avs_type; do : in std_logic) is
  begin
    avs.sample_address  <= std_logic_vector(to_unsigned(0, 5));
    avs.sample_readdata <= x"0000000" & "0001";
    avs.sample_read     <= '0';
    if do = '1' then
      avs.sample_chipselect <= '1';
      avs.sample_write      <= '1';
    else
      avs.sample_chipselect <= '0';
      avs.sample_write      <= '0';
    end if;
  end procedure start_nsync_5;


    -- inicia - para execução
    procedure read_reg(signal avs : inout avs_type : do : in std_logic; address : in integer) is
    begin
      avs.sample_address   <= std_logic_vector(to_unsigned(address, 5));
      avs.sample_writedata <= x"00000000";
      avs.sample_write     <= '0';
      if do = '1' then
        avs.sample_chipselect <= '1';
        avs.sample_read       <= '1';
      else
        avs.sample_chipselect <= '0';
        avs.sample_read       <= '0';
      end if;
    end procedure read_reg;


end package body avalon_definitions;


