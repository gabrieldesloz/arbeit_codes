--=============================
-- 32 bits pseudo - random number generator
-- Fixed Initial Seed
-- Gabriel Lozano
--=============================


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity p_random_32 is
  port(
    clk, n_reset : in  std_logic;
    random_vect  : out std_logic_vector(31 downto 0);
    ena          : in  std_logic
    );
end p_random_32;

architecture p_rand_arch of p_random_32 is

  constant I_SEED : unsigned(31 downto 0) := "10101010101010101010101010101010";

  signal r_reg   : unsigned(31 downto 0);
  signal r_next  : unsigned(31 downto 0);
  signal bit_xor : std_logic;

  type   STATE_TYPE is (LOAD, WAIT_OP, OP);
  signal state_next : STATE_TYPE;
  signal state_reg  : STATE_TYPE;

begin

  process(clk, n_reset)
  begin
    if (n_reset = '0') then
      state_reg <= LOAD;
      r_reg     <= (others => '0');
    elsif rising_edge(clk) then
      if ena = '1' then
        state_reg <= state_next;
        r_reg     <= r_next;
      end if;
    end if;
  end process;



  process (bit_xor, r_reg, state_reg)

  begin  -- process

    -- default
    r_next     <= r_reg;
    state_next <= state_reg;

    case state_reg is
      
      when LOAD =>
        r_next     <= I_SEED;
        state_next <= OP;
        
      when WAIT_OP =>
        state_next <= OP;
        

      when OP =>
        r_next     <= ((r_reg(0) xor r_reg(1)) & r_reg(30 downto 0)) srl 1;
        state_next <= WAIT_OP;

      when others =>
        state_next <= LOAD;
    end case;
    
  end process;

  random_vect <= std_logic_vector(r_reg);



end architecture p_rand_arch;
