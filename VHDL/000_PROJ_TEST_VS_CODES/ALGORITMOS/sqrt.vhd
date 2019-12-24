library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sqrt is
  generic (
    N : natural := 32);
  port (
    done_o    : out std_logic;
    ready     : out std_logic;
    start     : in  std_logic;
    sysclk    : in  std_logic;
    n_reset   : in  std_logic;
    radical   : in  std_logic_vector(N-1 downto 0);
    remainder : out std_logic_vector(N-1 downto 0);
    q         : out std_logic_vector((N/2)-1 downto 0)
    );


end entity sqrt;

architecture sqrt_RTL of sqrt is

  type STATE_TYPE is (IDLE, LOAD, COPY_VALUE, COMP, SUBT, ATRIB_TRUE, ATRIB_FALSE, DONE);
  attribute ENUM_ENCODING               : string;
  attribute ENUM_ENCODING of STATE_TYPE : type is "000 001 010 011 100 101 110 111";
  signal state_reg, state_next          : STATE_TYPE;
  signal comp_vect_reg, comp_vect_next  : unsigned(N-1 downto 0);
  signal radicand_reg, radicand_next    : unsigned(2*N-1 downto 0);
  signal j_reg, j_next                  : natural range 0 to N+1;
  signal q_int_next, q_int_reg          : unsigned((N/2)-1 downto 0);

  
begin  -- architecture rd_RTL

  
  remainder <= std_logic_vector(radicand_reg(2*N-1 downto N));
  q         <= std_logic_vector(q_int_reg);


  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      comp_vect_reg <= (others => '0');
      radicand_reg  <= (others => '0');
      j_reg         <= 0;
      state_reg     <= IDLE;
      q_int_reg     <= (others => '0');
    elsif rising_edge (sysclk) then
      comp_vect_reg <= comp_vect_next;
      radicand_reg  <= radicand_next;
      j_reg         <= j_next;
      q_int_reg     <= q_int_next;
      state_reg     <= state_next;
    end if;
  end process;


  state_machine : process(comp_vect_reg, j_reg, radical,
                          radicand_reg, state_reg, start, q_int_reg) is

  begin  -- process state_machine

    done_o         <= '0';
    ready          <= '0';
    q_int_next     <= q_int_reg;
    comp_vect_next <= comp_vect_reg;
    radicand_next  <= radicand_reg;
    state_next     <= state_reg;
    j_next         <= j_reg;
    state_next     <= state_reg;

    case state_reg is

      when IDLE =>
        ready <= '1';
        if start = '1' then
          state_next <= LOAD;
        end if;

      when LOAD =>
        
        radicand_next(N-1 downto 0)   <= unsigned(radical);
        radicand_next(2*N-1 downto N) <= (others => '0');
        comp_vect_next(N-1 downto 1)  <= (others => '0');
        comp_vect_next(0)             <= '1';
        j_next                        <= N/2;
        state_next                    <= COPY_VALUE;
        q_int_next                    <= (others => '0');


      when COPY_VALUE =>
        if j_reg = 0 then
          state_next <= DONE;
        else
          -- desloca 2 casas       
          radicand_next((2*N-1) downto 2) <= radicand_reg((2*N-3) downto 0);
          state_next                      <= COMP;
        end if;
        

      when COMP =>
        
        if radicand_reg(2*N-1 downto N) >= comp_vect_reg then
          -- atrib
          q_int_next(j_reg-1) <= '1';
          -- jump state
          state_next          <= SUBT;
        else
          q_int_next(j_reg-1)            <= '0';
          -- shift
          comp_vect_next((N-1) downto 3) <= comp_vect_reg((N-2) downto 2);
          state_next                     <= ATRIB_FALSE;
        end if;


      when SUBT =>
        --subt
        radicand_next(2*N-1 downto N)  <= radicand_reg(2*N-1 downto N) - comp_vect_reg;
        -- shift  comp_vect    
        comp_vect_next((N-1) downto 3) <= comp_vect_reg((N-2) downto 2);
        state_next                     <= ATRIB_TRUE;


      when ATRIB_TRUE =>
        -- atrib 
        comp_vect_next(2) <= '1';
        j_next            <= j_reg - 1;
        state_next        <= COPY_VALUE;

      when ATRIB_FALSE =>
        -- atrib 
        comp_vect_next(2) <= '0';
        j_next            <= j_reg - 1;
        state_next        <= COPY_VALUE;

      when DONE =>
        done_o     <= '1';
        state_next <= IDLE;

      when others =>
        state_next <= IDLE;

        
    end case;
  end process state_machine;




end architecture;

