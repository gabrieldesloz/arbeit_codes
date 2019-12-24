-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : 
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 
-- Last update: 2014-02-27
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0      lgs     Created
-- 2014-02-06  2.0      gdl     modified, name change
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mu320_constants.all;

entity quality_or is

  -- para 1 placa, faz o "or"  256 x 256
  
  port
    (
      sysclk           : in  std_logic;
      reset_n          : in  std_logic;
      quality_gate_in  : in  std_logic_vector((Q_BITS - 1) downto 0);
      quality_soft_in  : in  std_logic_vector((Q_BITS - 1) downto 0);
      quality_o        : out std_logic_vector((Q_BITS - 1) downto 0);
      data_available_i : in  std_logic;
      data_ready_o     : out std_logic

      );

end quality_or;

architecture quality_or_arq of quality_or is


  signal data_ready_o_reg : std_logic;
  signal out_register     : std_logic_vector(quality_o'range);
  
  
begin

  main_reg : process(reset_n, sysclk)
  begin
    if (reset_n = '0') then
      out_register     <= (others => '0');
      data_ready_o_reg <= '0';
    elsif (rising_edge(sysclk)) then
      data_ready_o_reg <= data_available_i;
      for j in 0 to (Q_BITS-1) loop
        out_register(j) <= (quality_gate_in(j) or quality_soft_in(j));  -- or 
      end loop;
    end if;
  end process;

  data_ready_o <= data_ready_o_reg;
  quality_o    <= out_register;
  
end quality_or_arq;
