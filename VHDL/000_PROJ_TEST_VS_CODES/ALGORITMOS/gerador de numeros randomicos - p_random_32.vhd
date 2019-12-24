--=============================
-- 32 bits pseudo - random number generator
-- Gabriel Lozano
--=============================


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity p_random_32 is
  generic(
    SEED : natural := 666
    );
  port(
    clk, n_reset : in  std_logic;
    random_vect  : out std_logic_vector(31 downto 0)
    );
end p_random_32;

architecture p_rand_arch of p_random_32 is

  signal r_reg   : unsigned(31 downto 0);
  signal r_next  : unsigned(31 downto 0);
  signal bit_xor : std_logic;

  type STATE_TYPE is (LOAD, OP);
  signal state_next : STATE_TYPE;
  signal state_reg  : STATE_TYPE;

  attribute syn_encoding               : string;
  attribute syn_encoding of state_type : type is "safe";
  

begin

  process(clk, n_reset)
  begin
    if (n_reset = '0') then
      state_reg <= LOAD;
      r_reg     <= (others => '0');
    elsif rising_edge(clk) then
      state_reg <= state_next;
      r_reg     <= r_next;
    end if;
  end process;



  process (bit_xor, r_reg, state_reg)

  begin  -- process

    -- default
    r_next     <= r_reg;
    bit_xor    <= '0';
    state_next <= state_reg;

    case state_reg is
      
      when LOAD =>
        r_next     <= to_unsigned(SEED, 32);
        state_next <= OP;
        

      when OP =>
        bit_xor <= r_reg(0) xor r_reg(1) xor r_reg(2);
        r_next  <= (bit_xor & r_reg(30 downto 0)) srl 1;
        
      when others =>
        state_next <= LOAD;
    end case;
    
  end process;

  random_vect <= std_logic_vector(r_reg);



end architecture p_rand_arch;
