-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : sync_verify.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-09-10
-- Last update: 2012-09-17
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-10  1.0      lgs     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.mu320_constants.all;

entity sync_verify is
  
  port (
    reset_n : in std_logic;
    sysclk  : in std_logic;

    sync_irig : in  std_logic_vector(7 downto 0);
    smp_sync  : out std_logic_vector(1 downto 0));
end sync_verify;


architecture sync_verify_struct of sync_verify is


begin  -- sync_verify_struct

  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then               -- asynchronous reset (active low)
      smp_sync <= "00";
    elsif rising_edge(sysclk) then      -- rising clock edge
      if sync_irig >= "01010101" then
        smp_sync <= "00";
      elsif sync_irig > "00000000" and sync_irig < "01010101" then
        smp_sync <= "01";
      elsif sync_irig = "00000000" then
        smp_sync <= "10";
      end if;
    end if;
  end process;

  
end sync_verify_struct;
