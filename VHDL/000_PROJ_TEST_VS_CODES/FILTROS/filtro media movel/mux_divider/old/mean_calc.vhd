-- salvar as informaÃ¯Â¿Â½Ã¯Â¿Â½es em uma memoria
-- salvar conforme endereÃ¯Â¿Â½o passado
-- a cada save, sinalizar
-- sinalizar quado memoria estÃ¯Â¿Â½ cheia 



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mean_calc is
  generic (
    BUFFER_SIZE : natural := 1024
    );

  port (
    sysclk         : in  std_logic;
    n_reset        : in  std_logic;
    address        : in  std_logic_vector(9 downto 0);  --1024
    write_memory   : in  std_logic;
    read_memory    : in  std_logic;
    do_mean_calc   : in  std_logic;
    value_to_write : in  std_logic_vector(31 downto 0);
    value_to_read  : out std_logic_vector(31 downto 0);
    status_out     : out std_logic_vector(4 downto 0)

    );


end entity mean_calc;

architecture mean_calc_RTL of mean_calc is

  type mc_type is (IDLE, LOAD_WR, WAIT_WRITE, DONE_WRITE, LOAD_ADDR_MEM, RD_OK,
                   START_MEAN_CALC, DO_SUM_CALC, WAIT_1_CYCLE, START_DIV_ST, WAIT_RDY_DIV, MEAN_C_RDY);
  signal state_reg, state_next : mc_type;

  attribute syn_encoding            : string;
  attribute syn_encoding of mc_type : type is "safe";


  type BUFFER_TYPE is array (0 to BUFFER_SIZE-1) of std_logic_vector (31 downto 0);

  signal buffer_MEM                                                                      : BUFFER_TYPE;
  signal write_address_reg, write_address_next                                           : natural range 0 to BUFFER_SIZE-1;
  signal read_address_reg, read_address_next                                             : natural range 0 to BUFFER_SIZE-1;
  signal value_to_read_reg, value_to_read_next                                           : std_logic_vector(31 downto 0);
  signal value_to_write_reg, value_to_write_next                                         : std_logic_vector(31 downto 0);
  signal sum_reg, sum_next                                                               : unsigned(31+(BUFFER_SIZE/2) downto 0);
  signal mean_value_reg, mean_value_next                                                 : unsigned(31 downto 0);
  signal done_div, div_start, read_ok, done_wr, ok_to_go, mean_value_ready, buffer_write : std_logic;
  signal mean_value_tmp                                                                  : std_logic_vector(31 downto 0);
  --signal write_memory, read_memory, do_mean_calc                                         : std_logic;
  

  
  
begin

  -- output/input logic --

  status_out <= read_ok & done_wr & ok_to_go & div_start & mean_value_ready;
  --write_memory <= ctrl_in(0);
  --do_mean_calc <= ctrl_in(1);
  --read_memory  <= ctrl_in(2);

  -----------------


  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_reg          <= IDLE;
      write_address_reg  <= 0;
      read_address_reg   <= 0;
      value_to_write_reg <= (others => '0');
      sum_reg            <= (others => '0');
      mean_value_reg     <= (others => '0');
      value_to_read_reg  <= (others => '0');
      
      
    elsif rising_edge (sysclk) then

      state_reg          <= state_next;
      write_address_reg  <= write_address_next;
      value_to_write_reg <= value_to_write_next;
      value_to_read_reg  <= value_to_read_next;
      read_address_reg   <= read_address_next;
      sum_reg            <= sum_next;
      mean_value_reg     <= mean_value_next;
      
      
    end if;
  end process;



  
  state_machine : process(address, do_mean_calc, done_div, mean_value_reg,
                          mean_value_tmp, read_address_reg, read_memory,
                          state_reg, sum_reg, value_to_read_reg,
                          value_to_write, value_to_write_reg,
                          write_address_reg, write_memory) is

  begin  -- process state_machine

    -- status

    read_ok          <= '0';
    done_wr          <= '0';
    ok_to_go         <= '0';
    div_start        <= '0';
    mean_value_ready <= '0';
    buffer_write     <= '0';

    -- regs
    state_next          <= state_reg;
    write_address_next  <= write_address_reg;
    value_to_write_next <= value_to_write_reg;
    read_address_next   <= read_address_reg;
    value_to_read       <= (others => '0');
    sum_next            <= sum_reg;
    mean_value_next     <= mean_value_reg;




    case state_reg is

      when IDLE =>

        ok_to_go <= '1';

        if write_memory = '1' then
          state_next <= LOAD_WR;
        elsif read_memory = '1' then
          state_next <= LOAD_ADDR_MEM;
        elsif do_mean_calc <= '1' then
          state_next <= START_MEAN_CALC;
        end if;
        

      when LOAD_WR =>
        write_address_next  <= to_integer(unsigned(address));
        value_to_write_next <= value_to_write;
        state_next          <= WAIT_WRITE;

      when WAIT_WRITE =>
        buffer_write <= '1';
        state_next   <= DONE_WRITE;
        

      when DONE_WRITE =>

        done_wr    <= '1';
        state_next <= IDLE;

      when LOAD_ADDR_MEM =>
        read_address_next <= to_integer(unsigned(address));
        state_next        <= RD_OK;


      when RD_OK =>
        read_ok       <= '1';
        value_to_read <= value_to_read_reg;
        state_next    <= IDLE;


      when START_MEAN_CALC =>
        read_address_next <= BUFFER_SIZE-1;
        state_next        <= DO_SUM_CALC;

      when DO_SUM_CALC =>
        sum_next   <= sum_reg + resize(unsigned(value_to_read_reg), sum_reg'length);
        state_next <= WAIT_1_CYCLE;
        

      when WAIT_1_CYCLE =>
        if read_address_reg = 0 then
          state_next <= START_DIV_ST;
        else
          read_address_next <= read_address_reg - 1;
          state_next        <= DO_SUM_CALC;
        end if;

      when START_DIV_ST =>
        div_start  <= '1';
        state_next <= WAIT_RDY_DIV;

      when WAIT_RDY_DIV =>
        if done_div = '1' then
          mean_value_next <= unsigned(mean_value_tmp);
          state_next      <= MEAN_C_RDY;
        end if;

      when MEAN_C_RDY =>
        mean_value_ready <= '1';
        value_to_read    <= std_logic_vector(mean_value_reg);
        state_next       <= IDLE;


      when others =>
        state_next <= IDLE;

        
    end case;
  end process state_machine;



  divider_1 : entity work.divider
    generic map (
      N => (32+(BUFFER_SIZE/2)),
      D => 30
      )
    port map (
      sysclk           => sysclk,
      n_reset          => n_reset,
      start            => div_start,
      num              => std_logic_vector(sum_reg),
      den              => std_logic_vector(to_unsigned(BUFFER_SIZE, 30)),
      quo(31 downto 0) => mean_value_tmp,
      --quo((32+(BUFFER_SIZE/2))-1 downto 32) => open,
      rema             => open,
      ready            => open,
      done             => done_div);



  --* --------------------------------------------------------------------------------------------------------------------------------------
--* Dual-Port RAM generation
--* Generate the simple dual-port RAM
--* Input      : f_address_wr, f_address_rd, period_counter, f_write
--* Output     : d_out
--* Latency    : 1
--* Multicycle : NO
--* --------------------------------------------------------------------------------------------------------------------------------------

  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if (buffer_write = '1') then
        buffer_MEM(write_address_reg) <= value_to_write_reg;
      end if;
      value_to_read_next <= buffer_MEM(read_address_reg);
    end if;
  end process;


  

end architecture;

