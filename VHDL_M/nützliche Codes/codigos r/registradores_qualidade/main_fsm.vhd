
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_fsm is
  
  port (
    sysclk  : in std_logic;
    reset_n : in std_logic;

    gate_ok_i  : in std_logic;
    ps_ready_i : in std_logic;

    do_mem_read_o  : out std_logic;
    do_mem_write_o : out std_logic;

    start_decod_o : out std_logic;

    decod_ok_i : in std_logic


    );

end main_fsm;


architecture main_fsm_rtl of main_fsm is

  type STATE_FSM_TYPE is (WAIT_NIOS, WAIT_READY, READ_MEM_SOFT, DO_OR, START_DECOD, WAIT_DECOD, WRITE_MEM);
  attribute syn_encoding                   : string;
  attribute syn_encoding of STATE_FSM_TYPE : type is "safe";
  signal state_reg, state_next             : STATE_FSM_TYPE;
  
begin
  
  
  process (sysclk, reset_n)
  begin
    if reset_n = '0' then
      state_reg <= WAIT_NIOS;
    elsif rising_edge(sysclk) then
      state_reg <= state_next;
    end if;
  end process;


  process (gate_ok_i, ps_ready_i, state_reg, decod_ok_i)
  begin  -- process

    -- default
    do_mem_read_o  <= '0';
    do_mem_write_o <= '0';
    state_next     <= state_reg;
    start_decod_o  <= '0';

    case state_reg is

      when WAIT_NIOS =>
        if (gate_ok_i = '1') then
          state_next <= WAIT_READY;
        end if;
        
      when WAIT_READY =>
        if ps_ready_i = '1' then
          state_next <= READ_MEM_SOFT;
        end if;

      when READ_MEM_SOFT =>
        do_mem_read_o <= '1';
        state_next    <= DO_OR;
        
      when DO_OR =>
        
        state_next <= START_DECOD;
        
      when START_DECOD =>
        start_decod_o <= '1';
        state_next    <= WAIT_DECOD;


      when WAIT_DECOD =>
        if decod_ok_i = '1' then
          do_mem_write_o <= '1';
          state_next     <= WRITE_MEM;
        end if;     

      when WRITE_MEM =>
        state_next <= WAIT_NIOS;
        
      when others =>
        state_next <= WAIT_NIOS;
        
    end case;

  end process;


  
end main_fsm_rtl;


