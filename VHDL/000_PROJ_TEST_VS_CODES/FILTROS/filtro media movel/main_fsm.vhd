-------------------------------------------------------------------------------
-- Title      : FSM - TECO
-- Project    :
-------------------------------------------------------------------------------
-- File       : main_fsm.vhd
-- Author     :   <gdl@IXION>
-- Company    :
-- Created    : 2013-08-27
-- Last update: 2013-09-10
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Maquina de estados da entidade principal do projeto de
-- integracao MU - TECO
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-08-27  1.0      gdl     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity main_fsm is
  generic (
    WAIT_START_COUNT : natural := 256
    );  

  port (
    sysclk  : in std_logic;
    reset_n : in std_logic;

    save_result_subt_add       : out std_logic;
    save_input_from_smp_adjst  : out std_logic;
    save_first_div             : out std_logic;
    save_input_from_arith_ctrl : out std_logic;
    send_output_o              : out std_logic;
    start_first_div            : out std_logic;

    sample_ok_i_reg      : in std_logic;
    ready_divider_mux    : in std_logic;
    ready_arith_ctrl_reg : in std_logic_vector(3 downto 0);

    start_arith         : out std_logic;
    clear_out_reset_n_o : out std_logic;

    sample_offset_ok : out std_logic



    );

end entity main_fsm;

-------------------------------------------------------------------------------

architecture RTL of main_fsm is


  type STATE_TYPE is (RESET, IDLE, WAIT_SUBT, SAVE_INPUT_SMP_ADJST, START_DIV, WAIT_DIV_1, SAVE_DIV_1, DO_ARITH, SAVE_ARITH, OUTPUT, DONE);

  attribute syn_encoding                             : string;
  attribute syn_encoding of STATE_TYPE               : type is "safe";
  signal state_reg, state_next                       : STATE_TYPE;
  signal count_sample_next, count_sample_reg         : natural range 0 to WAIT_START_COUNT;
  signal sample_offset_ok_next, sample_offset_ok_reg : std_logic;

  
begin

  registers : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      state_reg            <= RESET;
      count_sample_reg     <= 0;
      sample_offset_ok_reg <= '0';
    elsif rising_edge(sysclk) then
      sample_offset_ok_reg <= sample_offset_ok_next;
      count_sample_reg     <= count_sample_next;
      state_reg            <= state_next;
    end if;
  end process;

  sample_offset_ok <= sample_offset_ok_reg;

  main_fsm : process(ready_arith_ctrl_reg, ready_divider_mux, sample_ok_i_reg,
                     state_reg, count_sample_reg)
  begin

    save_result_subt_add       <= '0';
    save_input_from_smp_adjst  <= '0';
    save_first_div             <= '0';
    save_input_from_arith_ctrl <= '0';
    start_arith                <= '0';
    send_output_o              <= '0';
    start_first_div            <= '0';
    count_sample_next          <= count_sample_reg;
    state_next                 <= state_reg;
    clear_out_reset_n_o        <= '1';
    sample_offset_ok_next      <= '0';



    case state_reg is

      when RESET =>
        clear_out_reset_n_o <= '0';
        count_sample_next   <= 0;
        state_next          <= IDLE;

      when IDLE =>

        if sample_ok_i_reg = '1' then
          state_next <= WAIT_SUBT;
        end if;

      when WAIT_SUBT =>
        save_result_subt_add <= '1';
        state_next           <= SAVE_INPUT_SMP_ADJST;

      when SAVE_INPUT_SMP_ADJST =>
        save_input_from_smp_adjst <= '1';
        state_next                <= START_DIV;

      when START_DIV =>
        start_first_div <= '1';
        state_next      <= WAIT_DIV_1;

      when WAIT_DIV_1 =>
        if ready_divider_mux = '1' then
          state_next <= SAVE_DIV_1;
        end if;

      when SAVE_DIV_1 =>
        save_first_div <= '1';
        state_next     <= DO_ARITH;

      when DO_ARITH =>
        start_arith <= '1';
        state_next  <= SAVE_ARITH;

      when SAVE_ARITH =>
        if ready_arith_ctrl_reg = "1111" then
          save_input_from_arith_ctrl <= '1';
          state_next                 <= OUTPUT;
        end if;
        
      when OUTPUT =>
        state_next <= IDLE;
        if count_sample_reg = WAIT_START_COUNT-1 then
          send_output_o <= '1';
          state_next    <= DONE;
        else
          send_output_o     <= '0';
          count_sample_next <= count_sample_reg + 1;
        end if;

      when DONE =>
        sample_offset_ok_next <= '1';
        state_next            <= IDLE;
        

      when others =>
        state_next <= RESET;

    end case;
  end process;

  




end architecture RTL;
