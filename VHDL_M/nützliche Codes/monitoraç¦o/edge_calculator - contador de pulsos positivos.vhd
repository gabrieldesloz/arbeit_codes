

library IEEE;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_1164.all;


entity edge_calculator is
  
  port (
    start_stop : in  std_logic;
    signal_in  : in  std_logic;
    neg_edges  : out std_logic_vector(31 downto 0);
    pos_edges  : out std_logic_vector(31 downto 0);
    sysclk     : in  std_logic;
    n_reset    : in  std_logic;
    edge_calc  : out std_logic
    );

end entity edge_calculator;


architecture edge_calculator_RTL of edge_calculator is


  type STATE_TYPE is (IDLE, OP, DONE, DUMMY);

  attribute ENUM_ENCODING               : string;
  attribute ENUM_ENCODING of STATE_TYPE : type is "00 01 10 11";


  signal state_reg, state_next          : STATE_TYPE;
  signal neg_edges_reg, pos_edges_reg   : std_logic_vector(31 downto 0);
  signal neg_edges_next, pos_edges_next : std_logic_vector(31 downto 0);
  signal neg_edge, pos_edge             : std_logic;
  signal edge_calc_reg, edge_calc_next  : std_logic;
  
begin  -- architecture edge_calculator_RTL


  neg_edge_mealy_1 : entity work.neg_edge_mealy
    port map (
      clock   => sysclk,
      n_reset => n_reset,
      level   => signal_in,
      tick    => neg_edge);


  pos_edge_mealy_1 : entity work.pos_edge_mealy
    port map (
      clock   => sysclk,
      n_reset => n_reset,
      level   => signal_in,
      tick    => pos_edge);

  
  process(n_reset, sysclk)
  begin
    if n_reset = '0' then

      neg_edges_reg <= (others => '0');
      pos_edges_reg <= (others => '0');
      state_reg     <= IDLE;
      edge_calc_reg <= '0';

    elsif rising_edge(sysclk) then
      state_reg     <= state_next;
      neg_edges_reg <= neg_edges_next;
      pos_edges_reg <= pos_edges_next;
      edge_calc_reg <= edge_calc_next;
      
    end if;
  end process;


  process(neg_edge, neg_edges_reg, pos_edge, pos_edges_reg, start_stop,
          state_reg)
  begin

    pos_edges_next <= pos_edges_reg;
    neg_edges_next <= neg_edges_reg;
    state_next     <= state_reg;
    edge_calc_next <= '0';

    case state_reg is
      when IDLE =>
        
        if start_stop = '1' then
          state_next <= OP;
        end if;
        
      when OP =>       

        if start_stop = '0' then

          -- periodo entre os pulsos do pps
          if pos_edge = '1' then
            pos_edges_next <= pos_edges_reg + 1;
          end if;

          if neg_edge = '1' then
            neg_edges_next <= neg_edges_reg + 1;
          end if;
          
        else
          -- quando o pps ocorre na transição
          if pos_edge = '1' then
            pos_edges_next <= pos_edges_reg + 1;
          end if;

          if neg_edge = '1' then
            neg_edges_next <= neg_edges_reg + 1;
          end if;

          state_next     <= DONE;
          edge_calc_next <= '1';
        end if;

      when DONE =>
        
        neg_edges_next <= (others => '0');
        pos_edges_next <= (others => '0');
        state_next     <= OP;
        

      when others =>
        state_next <= IDLE;        
        
    end case;
  end process;

  neg_edges <= neg_edges_reg;
  pos_edges <= pos_edges_reg;
  edge_calc <= edge_calc_reg;

end architecture edge_calculator_RTL;
