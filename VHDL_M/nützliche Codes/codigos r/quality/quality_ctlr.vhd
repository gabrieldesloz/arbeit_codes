-------------------------------------------------------------------------------
-- Title      : Reason Tecnologia S.A. - Merging Unit - MU320
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       : quality.vhd
-- Author     : 
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
--              1.0              Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;


entity quality_ctlr is
  generic
    ( 
      VALUE1 : natural := 29458;        -- overflow
      VALUE2 : natural := 15469;        -- ceil(10938*sqrt(2))
      VALUE3 : natural := 6110;         -- ceil(4320*sqrt(2))
      BITS   : natural := 32;           -- vector size      
      Q_BITS : natural := 15            -- quality bits
      );
  
  port (
    sysclk  : in std_logic;
    reset_n : in std_logic;

    acq_data_in    : in std_logic_vector(N_BITS_ADC-1 downto 0);
    acq_data_ready : in std_logic;

    gain_register_data_in    : in std_logic_vector(N_BITS_ADC-1 downto 0);
    gain_register_data_ready : in std_logic;

    phase_sum_data_ready : in std_logic;
    phase_sum_ovf_i      : in std_logic;

    config_i         : in  std_logic_vector(1 downto 0);
    quality_o        : out std_logic_vector(Q_BITS-1 downto 0);
    q_vector_ready_o : out std_logic

    );

end quality_ctlr;

architecture rtl of quality_ctlr is


  type FSM_TYPE is (WAIT_ACQ, CHECK_1, CHECK_2, CHECK_3, WAIT_ST);
  attribute syn_encoding             : string;
  attribute syn_encoding of FSM_TYPE : type is "safe";
  signal state_next, state_reg       : FSM_TYPE;


  signal acq_data_in_reg            : std_logic_vector(acq_data_in'range);
  signal acq_data_in_next           : std_logic_vector(acq_data_in'range);
  signal gain_register_data_in_reg  : std_logic_vector(gain_register_data_in'range);
  signal gain_register_data_in_next : std_logic_vector(gain_register_data_in'range);

  signal acq_data_ready_reg                        : std_logic;
  signal acq_data_ready_next                       : std_logic;
  signal gain_register_data_ready_reg              : std_logic;
  signal gain_register_data_ready_next             : std_logic;
  signal phase_sum_data_ready_reg                  : std_logic;
  signal phase_sum_data_ready_next                 : std_logic;
  signal quality_next, quality_reg                 : std_logic_vector(quality_o'range);
  signal config_next, config_reg                   : std_logic_vector(config_i'range);
  signal phase_sum_ovf_i_reg, phase_sum_ovf_i_next : std_logic;
  signal q_vector_ready_reg, q_vector_ready_next   : std_logic;
  

begin

  
  process (sysclk, reset_n)
  begin
    if reset_n = '0' then
      state_reg                 <= WAIT_ACQ;
      gain_register_data_in_reg <= (others => '0');
      acq_data_in_reg           <= (others => '0');
      config_reg                <= (others => '0');
      phase_sum_ovf_i_reg       <= '0';
      quality_reg               <= (others => '0');     
      q_vector_ready_reg        <= '0';
      
      
    elsif rising_edge(sysclk) then
      state_reg                 <= state_next;
      gain_register_data_in_reg <= gain_register_data_in_next;
      acq_data_in_reg           <= acq_data_in_next;
      config_reg                <= config_next;
      phase_sum_ovf_i_reg       <= phase_sum_ovf_i_next;
      quality_reg               <= quality_next;   
      q_vector_ready_reg        <= q_vector_ready_next;
      
    end if;
  end process;


  gain_register_data_in_next <= gain_register_data_in;
  acq_data_in_next           <= acq_data_in;
  config_next                <= config_i;
  phase_sum_ovf_i_next       <= phase_sum_ovf_i;
  quality_o                  <= quality_reg;
  q_vector_ready_o           <= q_vector_ready_reg;


  fsm : process (acq_data_in_reg, acq_data_ready, config_reg,
               gain_register_data_in_reg, gain_register_data_ready,
               phase_sum_data_ready, phase_sum_ovf_i_reg, q_vector_ready_reg,
               quality_reg, state_reg)

  begin  -- process

    -- default
    state_next          <= state_reg;
    quality_next        <= quality_reg;
    q_vector_ready_next <= q_vector_ready_reg;

    case state_reg is
      when WAIT_ACQ =>
        -- zera vetor da qualidade
        quality_next        <= (others => '0');
        q_vector_ready_next <= '0';

        if acq_data_ready = '1' then
          state_next <= CHECK_1;
        end if;

      when CHECK_1 =>

        -- checagem do valor ap�s a aquisi��o
        if abs(signed(acq_data_in_reg)) > VALUE1 then
          quality_next(OVF_POS)     <= '1';
          quality_next(INVALID_POS) <= '1';
        end if;

        if gain_register_data_ready = '1' then
          state_next <= CHECK_2;
        end if;
        
      when CHECK_2 =>

        -- outOfRange, questionable
        -- verifica��o da tens�o
        if (config_reg(1) = '1' and (abs(signed(gain_register_data_in_reg)) > VALUE2)) then
          quality_next(QUESTIONABLE_POS) <= '1';
          quality_next(OUT_OF_RANGE_POS) <= '1';
        end if;

        -- outOfRange, questionable
        -- verifica��o da corrente
        if (config_reg(1) = '0' and (abs(signed(gain_register_data_in_reg)) > VALUE3)) then
          quality_next(QUESTIONABLE_POS) <= '1';
          quality_next(OUT_OF_RANGE_POS) <= '1';
        end if;

        if (phase_sum_data_ready = '1') then
          state_next <= CHECK_3;
        end if;

         -- verifica��o do overflow na soma de fase de neutro
        if config_reg(0) = '1' then
          quality_next(OVF_POS)     <= phase_sum_ovf_i_reg;
          quality_next(INVALID_POS) <= phase_sum_ovf_i_reg;
        end if;

      when CHECK_3 =>       

        q_vector_ready_next <= '1';
        state_next          <= WAIT_ST;


      when WAIT_ST =>
        state_next <= WAIT_ACQ;
        
        
      when others =>
        state_next <= WAIT_ACQ;
        
    end case;
  end process;
end rtl;
