library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reset_generator is
  
  generic (
    MAX : natural := 32
    );
  port(
    clk     : in  std_logic;
    n_reset : out std_logic
    );

end entity reset_generator;


architecture rtl of reset_generator is

  type STATE_TYPE is (START_STATE, WAIT_STATE, DONE_STATE, D1);
  signal state_reg, state_next : STATE_TYPE;
  signal count_next, count_reg : natural range 0 to (MAX - 1);
  
begin
  -- registradores de estado e de dados
  process(clk)
  begin
    if rising_edge(clk) then
      state_reg <= state_next;
      count_reg <= count_next;
    end if;
  end process;


  -- logica proximo estado + unidades funcionais
  logica_prox_estado : process(count_reg, state_reg)
  begin
    n_reset    <= '0';
    state_next <= state_reg;
    count_next <= count_reg;
    --mux 
    case state_reg is
      when START_STATE =>
        state_next <= WAIT_STATE;
        count_next <= MAX - 1;
        
      when WAIT_STATE =>
        if count_reg = 0 then
          state_next <= DONE_STATE;
        else
          count_next <= count_reg - 1;
        end if;
        
      when DONE_STATE =>
        n_reset <= '1';
        
      when others =>
        state_next <= START_STATE;
        
    end case;

  end process logica_prox_estado;

  
end architecture rtl;



