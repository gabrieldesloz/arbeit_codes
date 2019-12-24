-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : quality.vhd
-- Author     : 
-- Company    : 
-- Created    : 2012-08-07
-- Last update: 2014-08-21
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-08-07  1.0              Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quality is
  
  port (
    sysclk            : in  std_logic;
    reset_n           : in  std_logic
    
end quality;

architecture quality_rtl of quality is

  -- type
  -- attribute
  -- constants
  -- signals
  -- procedures
  -- functions  
  

  
begin  -- quality_rtl

  -- direct compoents instantiations
  -- registers
  -- sequential/parallel assignments
  -- output assignments


  
  
  process (sysclk, reset_n)
  begin  
    if reset_n = '0' then


    elsif rising_edge(sysclk) then      -- rising clock edge

    end if;

  end process;

  process ()
  begin  -- process

    -- default
    
    case x is
      when a =>
        
      when others =>
        quality_state_next <= WAIT_READY;
        
    end case;

  end process;



  
  quality_ctlr_1: entity work.quality_ctlr
    generic map (
      VALUE1 => VALUE1,
      VALUE2 => VALUE2,
      VALUE3 => VALUE3,
      BITS   => BITS)
    port map (
      sysclk                   => sysclk,
      reset_n                  => reset_n,
      acq_data_in              => acq_data_in,
      acq_data_ready           => acq_data_ready,
      gain_register_data_in    => gain_register_data_in,
      gain_register_data_ready => gain_register_data_ready,
      phase_sum_data_in        => phase_sum_data_in,
      phase_sum_data_ready     => phase_sum_data_ready,
      phase_sum_ovf_i          => phase_sum_ovf_i,
      config_i                 => config_i);

  
 

  dual_port_ram_dual_clock_1: entity work.dual_port_ram_dual_clock
    generic map (
      DATA_WIDTH => DATA_WIDTH_MEM_QUALITY,  -- 32
      ADDR_WIDTH => ADDR_WIDTH_MEM_QUALITY)  -- 8 
    port map (
      clk_a  => clk_a,
      clk_b  => clk_b,
      addr_a => addr_a,
      addr_b => addr_b,
      data_a => data_a,
      data_b => data_b,
      we_a   => we_a,
      we_b   => we_b,
      q_a    => q_a,
      q_b    => q_b);




  quality_mem_ctlr_1: entity work.quality_mem_ctlr
    port map (
      sysclk            => sysclk,
      reset_n           => reset_n,
      );
  
    

  quality_insertion_1: entity work.quality_insertion
    port map (
      sysclk            => sysclk,
      reset_n           => reset_n,
      data_in           => data_in,
      data_in_available => data_in_available,
      data_out_ready    => data_out_ready,
      data_out          => data_out);
  

end quality_rtl;
