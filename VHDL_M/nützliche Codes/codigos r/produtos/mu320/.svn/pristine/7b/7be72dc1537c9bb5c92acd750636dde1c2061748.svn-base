-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : shuffler.vhd
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : shuffler.vhd
-- Author     : Andre Castelan Prado
-- Company    : Reason Tecnologia S.A.
-- Created    : 2011-09-29
-- Last update: 2012-09-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description:  Seleciona as entradas conforme o especificado pelo Linux
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-03-20  1.0      ACP     Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mu320_constants.all;

-- entity declaration
entity shuffler is
  port(
    -- avalon signals
    clk        : in std_logic;
    reset_n    : in std_logic;
    address    : in std_logic;
    byteenable : in std_logic_vector(3 downto 0);
    writedata  : in std_logic_vector(31 downto 0);
    write      : in std_logic;
    chipselect : in std_logic;

    -- interface signals
    ana_bits_in  : in  std_logic_vector((N_CHANNELS_ANA - 1) downto 0);
    ana_bits_out : out std_logic_vector((N_CHANNELS_ANA - 1) downto 0)
    );
end shuffler;


architecture rtl of shuffler is


  type   REGISTER_TYPE is array (integer range <>) of std_logic_vector (3 downto 0);
  signal write_register : std_logic;

  signal out_register : REGISTER_TYPE((N_CHANNELS_ANA - 1) downto 0);
  signal out_settings : std_logic_vector(63 downto 0);
  signal enable       : std_logic;


  
begin
  write_register <= '1' when ((chipselect = '1') and (write = '1') and (byteenable = "1111")) else '0';

  process (clk, reset_n)
  begin  -- process    
    if reset_n = '0' then
      out_settings <= x"FEDCBA9876543210";
    elsif rising_edge(clk) then
      out_settings <= out_settings;
      enable       <= '0';
      if (write_register = '1') then
        case address is
          when '0' =>
            out_settings(31 downto 0) <= writedata;
          when '1' =>
            out_settings(63 downto 32) <= writedata;
            enable                     <= '1';
          when others =>
            enable <= '0';
        end case;
      end if;
    end if;
  end process;

  process (enable, reset_n, out_settings, out_register) is
  begin
    out_register <= out_register;
    if enable = '1' then
      for i in 0 to (N_CHANNELS_ANA - 1) loop
        for j in 0 to 3 loop
          out_register(i)(j) <= out_settings(i*4 + j);
        end loop;
      end loop;
    end if;
  end process;

  process (ana_bits_in, out_register)
    variable index : integer range 0 to (N_CHANNELS_ANA - 1);

  begin
    for i in 0 to (N_CHANNELS_ANA - 1) loop
      index           := conv_integer(out_register (i)(3 downto 0));
      ana_bits_out(i) <= ana_bits_in(index);
    end loop;
  end process;

end rtl;
