--Gabriel Lozano
--PWM genérico com saída registrada/não registrada, inicia/para









library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity pwm is
  
  generic (
    r : natural := 16
    ); 
  port (
    start       : in  std_logic;
    stop        : in  std_logic;
    reset       : in  std_logic;
    clk         : in  std_logic;
    d           : in  std_logic_vector(r-1 downto 0);
    pwm_out     : out std_logic;
    pwm_reg_out : out std_logic
    );
end pwm;

architecture PWM_arq of pwm is
  
  signal cont_next  : unsigned(r-1 downto 0) := (others => '0');
  signal cont_reg   : unsigned(r-1 downto 0) := (others => '0');
  signal d_int      : unsigned(r-1 downto 0) := (others => '0');
  signal pwm_next   : std_logic              := '0';
  signal pwm_reg    : std_logic              := '0';
  signal pwm        : std_logic              := '0';
  type state_type is (idle, op);
  signal state_reg  : state_type;
  signal state_next : state_type;
  
begin
  regs : process(clk, reset)
  begin
    if rising_edge(clk) then
      state_reg <= state_next;
      pwm_reg   <= pwm_next;
      cont_reg  <= cont_next;
    elsif reset = '1' then
      state_reg <= idle;
      cont_reg  <= (others => '0');
      pwm_reg   <= '0';
    end if;
  end process regs;

  next_state : process(cont_reg, state_reg, start, stop)  -- registradores alterados              
  begin
    --condição inicial
    state_next <= state_reg;
    cont_next  <= cont_reg;
    pwm_next   <= pwm_reg;
    pwm        <= '0';
    case state_reg is
      when idle =>
        if start = '1' then
          state_next <= op;
        end if;
      when op =>
        -- somador datapath
        cont_next <= cont_reg + 1;
        --------------------------
        if cont_next >= d_int then
          pwm <= '0';
        else
          pwm <= '1';
        end if;
        pwm_next <= pwm;
        if stop = '1' then
                                        --zerar todos os registradores/sinais
          state_next <= idle;
          cont_next  <= (others => '0');
          pwm_next   <= '0';
          pwm        <= '0';
        end if;
        
    end case;
    
  end process next_state;

  pwm_reg_out <= pwm_reg;
  pwm_out     <= pwm;
  d_int       <= unsigned(d);
  
end pwm_arq;


