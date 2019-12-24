-------------------------------------------------------------------------------
-- Title      : Testbench for design "arith_ctrl"
-- Project    :
-------------------------------------------------------------------------------
-- File       : arith_ctrl_tb.vhd
-- Author     :   <gdl@IXION>
-- Company    :
-- Created    : 2013-08-27
-- Last update: 2013-09-05
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
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


entity arith_top_fsm is

  port (
    sysclk  : in std_logic;
    reset_n : in std_logic;

    sample_ok_reg_i : in std_logic;
    ready_arith_i   : in std_logic;

    save_arith_o     : out std_logic;
    save_div_o       : out std_logic;
    do_subtraction_o : out std_logic;
    ready_o          : out std_logic

    );

end entity arith_top_fsm;

-------------------------------------------------------------------------------

architecture RTL of arith_top_fsm is


  type STATE_TYPE is (IDLE, WAIT_ARITH, SAVE_ARITH, SAVE_DIV, DO_SUBT, READY);

  attribute syn_encoding               : string;
  attribute syn_encoding of STATE_TYPE : type is "safe";
  signal state_reg, state_next         : STATE_TYPE;

begin

  registers : process (reset_n, sysclk) is
  begin
    if (reset_n = '0') then
      state_reg <= IDLE;
    elsif rising_edge(sysclk) then
      state_reg <= state_next;
    end if;
  end process;



  main_fsm : process(ready_arith_i, sample_ok_reg_i, state_reg)
  begin

    save_arith_o     <= '0';
    save_div_o       <= '0';
    do_subtraction_o <= '0';
    ready_o          <= '0';
    state_next       <= state_reg;

    case state_reg is
      when IDLE =>

        if sample_ok_reg_i = '1' then
          state_next <= WAIT_ARITH;
        end if;

      when WAIT_ARITH =>
        if ready_arith_i = '1' then
          state_next <= SAVE_ARITH;
        end if;

      when SAVE_ARITH =>
        save_arith_o <= '1';
        state_next   <= SAVE_DIV;

      when SAVE_DIV =>
          save_div_o <= '1';
		  state_next <= DO_SUBT;

      when DO_SUBT =>
        do_subtraction_o <= '1';
        state_next       <= READY;

      when READY =>
        ready_o    <= '1';
        state_next <= IDLE;

    end case;
  end process;




end architecture RTL;
