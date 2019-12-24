-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality.vhd
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-04-25
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0              Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slicer is

  generic(
    N  : natural := 32;
    LI : natural := 32;
    HI : natural := 32
    );

  port (

    sysclk    : in  std_logic;
    reset_n   : in  std_logic;
    input_i   : in  std_logic_vector(N-1 downto 0);
    output_o  : out std_logic_vector(N-1 downto 0);
    low_index : in  std_logic_vector(LI-1 downto 0);
    hi_index  : in  std_logic_vector(HI-1 downto 0)
    );    

end slicer;

architecture slicer_rtl of slicer is


begin  -- quality_rtl
  
  
  process (sysclk, reset_n)
    variable out_var : std_logic_vector(output_o'range);
    variable j : natural range 0 to N-1;
  begin
    if reset_n = '0' then
      out_var := (others => '0');
    elsif rising_edge(sysclk) then      -- rising clock edge
      j := 0;
      for i in 0 to input_i'high loop
        out_var(i) <= '0';
        if (i >= unsigned(low_index)) and (i <= unsigned(hi_index)) then
          out_var(j) := input_i(i);
          j          := j + 1;
        end if;
      end loop;  -- i
      output_o <= out_var;
    end if;

  end process;
  
end slicer_rtl;

-- 2 contadores
-- registrador limite superior



-- configurations
