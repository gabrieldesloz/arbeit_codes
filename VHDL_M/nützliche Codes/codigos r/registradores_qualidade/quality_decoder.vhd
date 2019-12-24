-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality_decoder.vhd
-- Author     : Gabriel Lozano
-- Company    : Reason Tecnologia S.A.
-- Created    : 2014-03-06
-- Last update: 2014-03-10
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: Decodes the information about the quality, and writes the
-- corresponding bits
-------------------------------------------------------------------------------
-- Copyright (c) 2012 Reason Tecnologia S.A.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
--             1.0              Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;



entity quality_decoder is
  
  port (
    sysclk          : in  std_logic;
    reset_n         : in  std_logic;
    quality_i       : in  std_logic_vector(Q_BITS-1 downto 0);
    quality_decod_o : out std_logic_vector(Q_BITS-1 downto 0);

    start_decod_i : in  std_logic;
    decod_ok_o    : out std_logic
    );       


end quality_decoder;

architecture quality_decoder_rtl of quality_decoder is
  
  
  type STATE_FSM_TYPE is (WAIT_OK, DECOD_1, WAIT_STATE, DECOD_2, DECOD_OK);
  attribute syn_encoding                   : string;
  attribute syn_encoding of STATE_FSM_TYPE : type is "safe";


  signal state_reg, state_next               : STATE_FSM_TYPE;
  signal qi_reg, qi_next                     : std_logic_vector(Q_BITS - 1 downto 0);
  signal questionable_reg, questionable_next : std_logic;
  signal invalid_reg, invalid_next           : std_logic;
  signal decod_reg, decod_next               : std_logic;
  signal decod_vect                          : std_logic_vector(1 downto 0);

 
  
begin


  decod_ok_o      <= decod_reg;
  quality_decod_o <= qi_reg;


  process (sysclk, reset_n)
  begin
    if reset_n = '0' then
      decod_reg        <= '0';
      state_reg        <= WAIT_OK;
      qi_reg           <= (others => '0');
      decod_reg        <= '0';
      questionable_reg <= '0';
      invalid_reg      <= '0';
    elsif rising_edge(sysclk) then
      decod_reg        <= decod_next;
      questionable_reg <= questionable_next;
      invalid_reg      <= invalid_next;
      state_reg        <= state_next;
      qi_reg           <= qi_next;
      decod_reg        <= decod_next;
    end if;
  end process;


  process (invalid_reg, qi_reg, questionable_reg, start_decod_i, state_reg, quality_i, decod_vect)
  begin  -- process

    -- default
    state_next        <= state_reg;
    invalid_next      <= invalid_reg;
    questionable_next <= questionable_reg;
    qi_next           <= qi_reg;
    decod_next        <= '0';

    case state_reg is

      when WAIT_OK =>
        qi_next  <= (others => '0');
        if (start_decod_i = '1') then
          state_next <= DECOD_1;
          qi_next    <= quality_i;
        end if;

      when DECOD_1 =>

        if qi_reg(FAIL_POS) = '1' then 
          invalid_next <= '1';
        end if;

        if qi_reg(BR_POS) = '1' then
          questionable_next <= '1';
        end if;

        if qi_reg(OVF_POS) = '1' then
          invalid_next <= '1';
        end if;

        if qi_reg(OOR_POS) = '1' then
          questionable_next <= '1';
        end if;

        state_next <= DECOD_2;

      when WAIT_STATE =>
        state_next <= DECOD_2;

      when DECOD_2 =>
    
        
        case decod_vect is
          -- invalid_reg & questionable_reg
          when "00"   => qi_next(V_MSB downto V_MSB-1) <= GOOD;  
          when "11"   => qi_next(V_MSB downto V_MSB-1) <= INVALID;  
          when "10"   => qi_next(V_MSB downto V_MSB-1) <= INVALID;  
          when "01"   => qi_next(V_MSB downto V_MSB-1) <= QUESTIONABLE;  
          when others => qi_next(V_MSB downto V_MSB-1) <= INVALID;  
        end case;
        
        decod_next <= '1';
        state_next <= DECOD_OK;

      when DECOD_OK =>
        state_next <= WAIT_OK;
        
      when others =>
        state_next <= WAIT_OK;
        
    end case;

  end process;


  decod_vect <= (invalid_reg & questionable_reg);

end quality_decoder_rtl;


