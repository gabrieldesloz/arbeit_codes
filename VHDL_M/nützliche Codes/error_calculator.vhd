library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library lpm;
use lpm.lpm_components.all;

library work;
use work.rl131_constants.all;



entity phase_diff_register is

  port (
    t_info      : out std_logic_vector(1 downto 0);
    ext_edge    : in std_logic;
    wave_edge   : in std_logic;
    n_reset     : in std_logic;
    sysclk      : in std_logic;
    erro        : out std_logic_vector(DL_BITS-1 downto 0)
    );
  

end entity phase_diff_register;


architecture phase_diff_register_RTL of phase_diff_register is

 signal max, min                                : std_logic_vector(ERROR_BITS-1 downto 0);
 signal present_phase_reg, present_phase_next   : std_logic_vector(ERROR_BITS-1 downto 0);
 signal previous_phase_next, previous_phase_reg : std_logic_vector(ERROR_BITS-1 downto 0);
 signal t_counter                               : std_logic_vector(DL_BITS-1 downto 0);
 constant phase_info                            : std_logic_vector(DL_BITS-1 downto 0)  := "00001000";

 
begin  -- architecture phase_diff_reg_RTL


-------------------------------------------------------------------------------
-- Registrador
-------------------------------------------------------------------------------
 process (sysclk, n_reset)
  begin
    if n_reset = '0' then
      present_phase_reg         <= (others => '0');
      previous_phase_reg        <= (others => '0');
    elsif rising_edge (sysclk) then
      present_phase_reg         <= present_phase_next;
      previous_phase_reg        <= previous_phase_next;
    end if;
  end process;
  
-------------------------------------------------------------------------------
-- Contador do periodo interno da forma de onda
-------------------------------------------------------------------------------

  period_counter_1: entity work.period_counter
    port map (
      sysclk    => sysclk,
      n_reset   => n_reset,
      wave_edge => wave_edge,
      t_counter => t_counter,
      t_calc    => open
      );

  -----------------------------------------------------------------------------
  -- Salva a posição do pulso em relação as bordas de subida
  -----------------------------------------------------------------------------
  save_period_1: process(ext_edge, present_phase_reg, previous_phase_reg,
                         t_counter)
  begin
  present_phase_next    <= present_phase_reg;
  previous_phase_next   <= previous_phase_reg;
  if ext_edge = '1' then
    present_phase_next  <= t_counter;
    previous_phase_next <= present_phase_reg;
  end if;  
 end process;
  

-------------------------------------------------------------------------------
-- compara e ordena as fases armazenadas -- erro relativo a um valor anterior
-- problema - meta - estabilidade
-------------------------------------------------------------------------------  


        --bordas_comp : process(previous_phase_next, present_phase_next)
        --begin
        --  if previous_phase_next < present_phase_next then
        --    MAX    <= present_phase_next;
        --    min    <= previous_phase_next;
        --    t_info <= "10";             -- deslocamento do sinal 2 para a
        --                                -- esquerda em relação ao sinal 1 (adiantamento)
            
          
            
        --  elsif previous_phase_next > present_phase_next then
        --    MAX    <= previous_phase_next;
        --    min    <= present_phase_next;
        --    t_info <= "01";             -- deslocamento do sinal 2 para a
        --                                -- direita em relação ao sinal 1 

        --  else
        --    MAX    <= (others => '0');
        --    min    <= (others => '0');
        --    t_info <= "00";             -- em fase
            
        --  end if;
        --end process;



-------------------------------------------------------------------------------
-- compara e ordena as fases armazenadas
-------------------------------------------------------------------------------  


        bordas_comp : process(present_phase_next)
        begin
          if phase_info < present_phase_next then
            MAX    <= present_phase_next;
            min    <= phase_info;
            t_info <= "10";             -- deslocamento do sinal 2 para a
                                        -- esquerda em relação ao sinal 1 (adiantamento)
            
          
            
          elsif phase_info > present_phase_next then
            MAX    <= phase_info;
            min    <= present_phase_next;
            t_info <= "01";             -- deslocamento do sinal 2 para a
                                        -- direita em relação ao sinal 1 

          else
            MAX    <= (others => '0');
            min    <= (others => '0');
            t_info <= "00";             -- em fase
            
          end if;
        end process;





 
--------------------------------------------------------------------
---- subtrai as fases, mostrando a diferença entre elas 
--------------------------------------------------------------------    
calc_erro : erro <= std_logic_vector (MAX-min);




 
end architecture phase_diff_register_RTL;
