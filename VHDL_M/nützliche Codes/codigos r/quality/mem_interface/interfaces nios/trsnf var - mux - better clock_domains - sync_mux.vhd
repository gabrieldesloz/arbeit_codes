-------------------------------------------------------------------------------
-- Title   :
-- Project : MU_320
-------------------------------------------------------------------------------
-- File          : 
-- Author        : Gabriel Lozano
-- Company       : Reason Tecnologia S.A.
-- Created       : 2013-06-
-- Last update   : 2013-06-
-- Target Device :
-- Standard      : VHDL'93
-------------------------------------------------------------------------------
-- Description   :
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-------------------------------------------------------------------------------
-- Revisions     :
-- Date          Version Author Description
-- 2013-06-18    1.0     GDL    Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mu320_constants.all;

entity sync_mux is
  
  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    reset_n :    std_logic;

    -- Avalon MM Slave - Interface
    avs_address    : in std_logic_vector(1 downto 0);
    avs_chipselect : in std_logic;
    avs_write      : in std_logic;
    avs_writedata  : in std_logic_vector(31 downto 0);



    -- Conduit Interface
    coe_locked0_in       : in  std_logic;
    coe_locked0_out      : out std_logic;
    coe_locked1_in       : in  std_logic;
    coe_locked1_out      : out std_logic;
    coe_sysclk           : in  std_logic;
    coe_virtual_pps0_in  : in  std_logic;
    coe_virtual_pps1_in  : in  std_logic;
    coe_virtual_pps0_out : out std_logic;
    coe_virtual_pps1_out : out std_logic;
    coe_freq0_in         : in  std_logic;
    coe_freq1_in         : in  std_logic;
    coe_freq0_out        : out std_logic;
    coe_freq1_out        : out std_logic

    );

end sync_mux;

architecture rtl of sync_mux is


  type FSM_SS0_STATE_TYPE is (ST_FSM_SS0_SV0, ST_FSM_SS0_SV1);
  type FSM_SS1_STATE_TYPE is (ST_FSM_SS1_SV1, ST_FSM_SS1_SV0);

  attribute syn_encoding                       : string;
  attribute syn_encoding of FSM_SS0_STATE_TYPE : type is "safe";
  attribute syn_encoding of FSM_SS1_STATE_TYPE : type is "safe";

  signal fsm_state_syncsys0_next, fsm_state_syncsys0_reg : FSM_SS0_STATE_TYPE;
  signal fsm_state_syncsys1_next, fsm_state_syncsys1_reg : FSM_SS1_STATE_TYPE;

-- sinais de controle

  signal control_reg, control_next                           : std_logic_vector(1 downto 0);
  signal write_ok                                            : std_logic;
  signal chg_ss0, chg_ss1                                    : std_logic;
  signal coe_virtual_pps0_out_next, coe_virtual_pps0_out_reg : std_logic;
  signal coe_virtual_pps1_out_next, coe_virtual_pps1_out_reg : std_logic;
  signal coe_freq0_out_next, coe_freq0_out_reg               : std_logic;
  signal coe_freq1_out_next, coe_freq1_out_reg               : std_logic;
  signal coe_locked0_next, coe_locked0_reg                   : std_logic;
  signal coe_locked1_next, coe_locked1_reg                   : std_logic;
  
  
  
begin

  -- controle nios

  chg_ss0 <= control_reg(0);
  chg_ss1 <= control_reg(1);

  control_next <= avs_writedata(1 downto 0) when (write_ok = '1' and (unsigned(avs_address) = 0)) else control_reg;
  write_ok     <= '1'                       when (avs_write = '1' and avs_chipselect = '1')       else '0';




  -- SS0  -----------------------------------
  process(chg_ss0, fsm_state_syncsys0_reg)
  begin
    fsm_state_syncsys0_next <= fsm_state_syncsys0_reg;

    case fsm_state_syncsys0_reg is
      when ST_FSM_SS0_SV0 =>
        
        if chg_ss0 = '1' then
          fsm_state_syncsys0_next <= ST_FSM_SS0_SV1;
        end if;

      when ST_FSM_SS0_SV1 =>
        if chg_ss0 = '0' then
          fsm_state_syncsys0_next <= ST_FSM_SS0_SV0;
        end if;
        
      when others =>
        fsm_state_syncsys0_next <= ST_FSM_SS0_SV0;
    end case;
  end process;
  -----------------------------------------------



  -- SS1  -----------------------------------
  process(chg_ss1, fsm_state_syncsys1_reg)
  begin
    fsm_state_syncsys1_next <= fsm_state_syncsys1_reg;

    case fsm_state_syncsys1_reg is
      when ST_FSM_SS1_SV1 =>
        
        if chg_ss1 = '0' then
          fsm_state_syncsys1_next <= ST_FSM_SS1_SV0;
        end if;

      when ST_FSM_SS1_SV0 =>
        if chg_ss1 = '1' then
          fsm_state_syncsys1_next <= ST_FSM_SS1_SV1;
        end if;
        
      when others =>
        fsm_state_syncsys1_next <= ST_FSM_SS1_SV1;
    end case;
  end process;
  -----------------------------------------------


  -- registradores modulo - dominio de relogio do fpga
  process(coe_sysclk, reset_n)
  begin
    if reset_n = '0' then
      control_reg              <= "10";
      coe_freq0_out_reg        <= '0';
      coe_freq1_out_reg        <= '0';
      coe_virtual_pps0_out_reg <= '0';
      coe_virtual_pps1_out_reg <= '0';
      coe_locked0_reg          <= '0';
      coe_locked1_reg          <= '0';
      fsm_state_syncsys0_reg   <= ST_FSM_SS0_SV0;
      fsm_state_syncsys1_reg   <= ST_FSM_SS1_SV1;
      
    elsif rising_edge(coe_sysclk) then
      
      control_reg              <= control_next;
      coe_freq0_out_reg        <= coe_freq0_out_next;
      coe_freq1_out_reg        <= coe_freq1_out_next;
      coe_virtual_pps0_out_reg <= coe_virtual_pps0_out_next;
      coe_virtual_pps1_out_reg <= coe_virtual_pps1_out_next;
      coe_locked0_reg          <= coe_locked0_next;
      coe_locked1_reg          <= coe_locked1_next;
      fsm_state_syncsys0_reg   <= fsm_state_syncsys0_next;
      fsm_state_syncsys1_reg   <= fsm_state_syncsys1_next;
      
    end if;
  end process;
 
-- atribuicao dos canais --

  coe_freq0_out_next        <= coe_freq1_in        when (fsm_state_syncsys0_reg = ST_FSM_SS0_SV1) else coe_freq0_in;
  coe_virtual_pps0_out_next <= coe_virtual_pps1_in when (fsm_state_syncsys0_reg = ST_FSM_SS0_SV1) else coe_virtual_pps0_in;
  coe_locked0_next          <= coe_locked1_in      when (fsm_state_syncsys0_reg = ST_FSM_SS0_SV1) else coe_locked0_in;

  coe_freq1_out_next        <= coe_freq0_in        when (fsm_state_syncsys1_reg = ST_FSM_SS1_SV0) else coe_freq1_in;
  coe_virtual_pps1_out_next <= coe_virtual_pps0_in when (fsm_state_syncsys1_reg = ST_FSM_SS1_SV0) else coe_virtual_pps1_in;
  coe_locked1_next          <= coe_locked0_in      when (fsm_state_syncsys1_reg = ST_FSM_SS1_SV0) else coe_locked1_in;


  coe_freq0_out <= coe_freq0_out_reg;
  coe_freq1_out <= coe_freq1_out_reg;

  coe_virtual_pps0_out <= coe_virtual_pps0_out_reg;
  coe_virtual_pps1_out <= coe_virtual_pps1_out_reg;

  coe_locked0_out <= coe_locked0_reg;
  coe_locked1_out <= coe_locked1_reg;
  


end rtl;
