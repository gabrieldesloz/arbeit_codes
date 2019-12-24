-------------------------------------------------------------------------------
--
-- Title       : Decoder_dice
-- Design      : Hinweis
-- Author      : DesLoz
-- Company     : Desloz
--
-------------------------------------------------------------------------------
--
-- File        : c:\Forschung\Codes\forschung\Hinweis\src\proj_dice\Decoder_dice.vhd
-- Generated   : Mon Oct 17 10:21:50 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Decoder_dice} architecture {Decoder_dice}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Decoder_dice is
  port(

    reset_n : in  std_logic;
    clk     : in  std_logic;
    enable  : in  std_logic;
    one     : out std_logic;
    six     : out std_logic;
    g       : out std_logic;
    c_d     : out std_logic;
    b_e     : out std_logic;
    a_f     : out std_logic
    );
end Decoder_dice;

--}} End of automatically maintained section

architecture Decoder_dice of Decoder_dice is

  type state_type is (sleep_mode, st_1, st_2, st_3, st_4, st_5, st_6);
  signal mode_reg, mode_next : state_type;
  
begin
  --===================================
  -- registradores de estado e de dados
  -- variáveis
  --==================================
  
  registradores : process(clk, reset_n, enable)
  begin
    if reset_n = '0' then
      mode_reg <= sleep_mode;
    elsif rising_edge(clk) then
      if enable = '1' then
        mode_reg <= mode_next;
      end if;
    end if;
  end process registradores;


  --======================--
  -- logica de proximo estado   
  -- controlpath/fsm
  --======================--
  logica_prox_estado : process(mode_reg)  -- all -> vhdl 2008 -- lista de todos os 
  -- sinais que estão dentro do processo e que são modificados externamente
  begin
    -- valores default (impedem a inferencia de latches)
    one       <= '0';
    g         <= '0';
    a_f       <= '0';
    c_d       <= '0';
    b_e       <= '0';
    six       <= '0';
    mode_next <= mode_reg;              -- padrão voltar para o mesmo estado


    --mux 
    case mode_reg is
      when sleep_mode =>
        mode_next <= st_1;
      when st_1 =>
        one       <= '1';
        g         <= '1';
        mode_next <= st_2;
      when st_2 =>
        a_f       <= '1';
        mode_next <= st_3;
      when st_3 =>
        g         <= '1';
        a_f       <= '1';
        mode_next <= st_4;
      when st_4 =>
        c_d       <= '1';
        a_f       <= '1';
        mode_next <= st_5;
      when st_5 =>
        c_d       <= '1';
        a_f       <= '1';
        g         <= '1';
        mode_next <= st_6;
      when st_6 =>
        c_d       <= '1';
        a_f       <= '1';
        b_e       <= '1';
        six       <= '1';
        mode_next <= st_1;
    end case;
  end process logica_prox_estado;
  
end Decoder_dice;
