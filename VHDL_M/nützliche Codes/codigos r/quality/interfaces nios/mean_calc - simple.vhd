

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mean_calc is
  --generic (
  --  V_BUFFER_SIZE : natural := 4
  --  );

  port (
    sysclk         : in  std_logic;
    n_reset        : in  std_logic;
    write_sum      : in  std_logic;
    value_to_write : in  std_logic_vector (31 downto 0);
    value_to_read  : out std_logic_vector (31 downto 0);
    write_ok       : out std_logic;
    mean_value     : out std_logic
    );


end entity mean_calc;

architecture mean_calc_RTL of mean_calc is

  constant V_BUFFER_SIZE : natural := 4;

  type mc_type is (SYS_START, WAIT_NEXT_WRITE, WAIT_1_CYCLE);
  signal state_reg, state_next : mc_type;

  attribute syn_encoding            : string;
  attribute syn_encoding of mc_type : type is "safe";


  signal v_address_wr_reg, v_address_wr_next : natural range 1 to V_BUFFER_SIZE;
  signal v_address_rd_reg, v_address_rd_next : natural range 1 to V_BUFFER_SIZE;
  signal v_write_reg, v_write_next           : std_logic;
  signal sum_reg, sum_next                   : unsigned(31+(V_BUFFER_SIZE/2) downto 0);
  signal write_ok_reg, write_ok_next         : std_logic;
  signal mean_value_int                      : std_logic;

  
  
begin

  -- output logic --

  write_ok <= write_ok_reg;

  -----------------


  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_reg        <= SYS_START;
      v_address_wr_reg <= V_BUFFER_SIZE;
      v_write_reg      <= '0';
      sum_reg          <= (others => '0');
      write_ok_reg     <= '0';
    elsif rising_edge (sysclk) then
      state_reg        <= state_next;
      v_address_wr_reg <= v_address_wr_next;
      v_write_reg      <= v_write_next;
      sum_reg          <= sum_next;
      write_ok_reg     <= write_ok_next;
      
    end if;
  end process;


  state_machine : process(state_reg, sum_reg, v_address_wr_reg, v_write_reg,
                          value_to_write, write_ok_reg, write_sum) is

  begin  -- process state_machine

    -- status
    mean_value_int <= '0';

    -- regs
    state_next        <= state_reg;
    v_address_wr_next <= v_address_wr_reg;
    v_write_next      <= v_write_reg;
    sum_next          <= sum_reg;
    write_ok_next     <= write_ok_reg;


    case state_reg is

      when SYS_START =>

        v_address_wr_next <= V_BUFFER_SIZE;
        state_next        <= WAIT_NEXT_WRITE;

      when WAIT_NEXT_WRITE =>

        if write_sum = '1' then
          write_ok_next <= '0';
          v_write_next  <= '1';
          sum_next      <= sum_reg + resize(unsigned(value_to_write), sum_reg'length);
          state_next    <= WAIT_1_CYCLE;
        end if;
        

      when WAIT_1_CYCLE =>

        v_write_next  <= '0';
        write_ok_next <= '1';
        state_next    <= WAIT_NEXT_WRITE;

        if v_address_wr_reg = 1 then
          v_address_wr_next <= V_BUFFER_SIZE;
          sum_next          <= (others => '0');
          mean_value_int    <= '1';
        else
          v_address_wr_next <= v_address_wr_reg - 1;
        end if;


        
      when others =>
        state_next <= SYS_START;

        
    end case;
  end process state_machine;


  value_to_read <= std_logic_vector(sum_reg(31+(V_BUFFER_SIZE/2) downto 2)) when mean_value_int = '1' else (others => '0');
  mean_value    <= mean_value_int;

  
  

end architecture;

