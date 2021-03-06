-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality_insert.vhd
-- Author     : Lucas Groposo Silveira
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-07
-- Last update: 2014-02-18
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work;
use work.mu320_constants.all;

entity quality_insert is
  
  port (
    sysclk            : in  std_logic;
    reset_n           : in  std_logic;
    data_in           : in  std_logic_vector((2*N_BITS_ADC - 1) downto 0);
    data_in_available : in  std_logic;
    data_out_ready    : out std_logic;
    data_out          : out std_logic_vector((4*N_BITS_ADC - 1) downto 0);
    quality_fill_i    : in  std_logic_vector(31 downto 0)
    );

end quality_insert;

architecture quality_insert_rtl of quality_insert is

  type QUALITY_STATE_TYPE is (WAIT_READY, INSERT_VALUE, READY);

  attribute syn_encoding                       : string;
  attribute syn_encoding OF QUALITY_STATE_TYPE : TYPE IS "safe";
 
  signal quality_state           : QUALITY_STATE_TYPE;
  signal quality_state_next      : QUALITY_STATE_TYPE;
  signal data_in_reg             : std_logic_vector((2*N_BITS_ADC - 1) downto 0); 
  signal data_in_reg_next        : std_logic_vector((2*N_BITS_ADC - 1) downto 0);
  signal data_out_reg            : std_logic_vector((4*N_BITS_ADC - 1) downto 0);
  signal data_out_reg_next       : std_logic_vector((4*N_BITS_ADC - 1) downto 0);
  signal data_out_ready_reg_next : std_logic;
  signal data_out_ready_reg      : std_logic;
  
  
begin  -- quality_rtl

  data_out       <= data_out_reg;
  data_out_ready <= data_out_ready_reg;

  process (sysclk, reset_n)
  begin  -- process
    if reset_n = '0' then

      quality_state      <= WAIT_READY;
      data_in_reg        <= (others => '0');
      data_out_reg       <= (others => '0');
      data_out_ready_reg <= '0';
      
    elsif rising_edge(sysclk) then      

      quality_state      <= quality_state_next;
      data_in_reg        <= data_in_reg_next;
      data_out_reg       <= data_out_reg_next;
      data_out_ready_reg <= data_out_ready_reg_next;

    end if;
  end process;

  process (data_in, data_in_available, data_in_reg, data_out_ready_reg,
           data_out_reg, quality_fill_i, quality_state)

  begin  -- process

    quality_state_next      <= quality_state;
    data_in_reg_next        <= data_in_reg;
    data_out_reg_next       <= data_out_reg;
    data_out_ready_reg_next <= data_out_ready_reg;
  
    case quality_state is
      
      when WAIT_READY =>
        data_out_ready_reg_next <= '0';

        if data_in_available = '1' then
          data_in_reg_next   <= data_in;
          quality_state_next <= INSERT_VALUE;
        end if;

      when INSERT_VALUE =>
        -- inser��o dos bits da qualidade
        data_out_reg_next <= data_in_reg & quality_fill_i;
        quality_state_next <= READY;
        data_out_ready_reg_next <= '1';

      when READY =>
        quality_state_next <= WAIT_READY;
        
      when others =>
        quality_state_next <= WAIT_READY;
        
    end case;

  end process;


end quality_insert_rtl;
