
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity divider_mux is
  generic (

    N_CHANNELS_ANA : natural := 4;
    N_BITS_ADC     : natural := 32

    );

  port (

    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    d_ana_i           : in  std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC - 1) downto 0);
    d_ana_proc_o      : out std_logic_vector(((N_CHANNELS_ANA/2)*N_BITS_ADC - 1) downto 0);
    ready_data_o      : out std_logic;
    start_div_i       : in  std_logic;
    one_division_done : out std_logic
    );


end entity divider_mux;

architecture rd_RTL of divider_mux is

  type STATE_TYPE is (IDLE, LOAD_DIV, WAIT_READY);

  attribute syn_encoding               : string;
  attribute syn_encoding of STATE_TYPE : type is "safe";

  signal state_reg, state_next : STATE_TYPE;


  type MEMORY is array (integer range <>) of std_logic_vector(N_BITS_ADC-1 downto 0);
  signal D_ANA_I_ARRAY : MEMORY(N_CHANNELS_ANA-1 downto 0);
  signal D_ANA_O_ARRAY : MEMORY((N_CHANNELS_ANA/2)-1 downto 0);


  signal quo_int                             : std_logic_vector(N_BITS_ADC-1 downto 0);
  signal num_addr_ptr_reg, num_addr_ptr_next : integer range 0 to N_CHANNELS_ANA-1;
  signal den_addr_ptr_reg, den_addr_ptr_next : integer range 0 to N_CHANNELS_ANA-1;
  signal quo_addr_ptr_reg, quo_addr_ptr_next : integer range 0 to N_CHANNELS_ANA-1;

  signal ready_div : std_logic;

  signal d_ana_i_array_den_int : std_logic_vector(N_BITS_ADC-1 downto 0);
  signal d_ana_i_array_num_int : std_logic_vector(N_BITS_ADC-1 downto 0);

  signal ready_data_o_reg, ready_data_o_next : std_logic;

  signal start_div_reg, start_div_next, done_reg, done_next : std_logic;

  
  
  
  
begin

  
  one_division_done <= done_reg;
  ready_data_o      <= ready_data_o_reg;
 
  registers : process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_reg <= IDLE;

      ready_data_o_reg <= '0';
      num_addr_ptr_reg <= 0;
      den_addr_ptr_reg <= 0;
      quo_addr_ptr_reg <= 0;
      start_div_reg    <= '0';
      done_reg         <= '0';



      for i in 0 to N_CHANNELS_ANA-1 loop
        for j in 0 to N_BITS_ADC-1 loop
          D_ANA_I_ARRAY(i)(j) <= '0';
        end loop;  -- j
      end loop;  -- i


      for k in 0 to ((N_CHANNELS_ANA/2)-1) loop
        for l in 0 to N_BITS_ADC-1 loop
          D_ANA_O_ARRAY(k)(l) <= '0';
        end loop;  -- j
      end loop;  -- i  
      
      
    elsif rising_edge (sysclk) then

      num_addr_ptr_reg <= num_addr_ptr_next;
      den_addr_ptr_reg <= den_addr_ptr_next;
      quo_addr_ptr_reg <= quo_addr_ptr_next;
      ready_data_o_reg <= ready_data_o_next;
      start_div_reg    <= start_div_next;
      done_reg         <= done_next;


      for i in 0 to N_CHANNELS_ANA-1 loop
        for j in 0 to N_BITS_ADC-1 loop
          D_ANA_I_ARRAY(i)(j) <= d_ana_i(((i)*N_BITS_ADC)+j);
        end loop;  -- j
      end loop;  -- i

      D_ANA_O_ARRAY(quo_addr_ptr_reg) <= quo_int;

      state_reg <= state_next;
    end if;
  end process;




  divider_1 : entity work.divider
    generic map (
      SIGN => '1',
      N    => N_BITS_ADC,
      D    => N_BITS_ADC)
    port map (
      sysclk  => sysclk,
      n_reset => n_reset,
      start   => start_div_reg,
      num     => d_ana_i_array_num_int,
      den     => d_ana_i_array_den_int,
      quo     => quo_int,
      rema    => open,
      ready   => ready_div,
      done    => done_next
      );


  d_ana_i_array_den_int <= D_ANA_I_ARRAY(den_addr_ptr_reg);
  d_ana_i_array_num_int <= D_ANA_I_ARRAY(num_addr_ptr_reg);


  main_state_machine :

  process(
    start_div_i,
    ready_div,
    state_reg,
    num_addr_ptr_reg,
    den_addr_ptr_reg,
    quo_addr_ptr_reg)

    is

  begin  -- process state_machine

    ready_data_o_next <= '0';
    state_next        <= state_reg;
    num_addr_ptr_next <= num_addr_ptr_reg;
    den_addr_ptr_next <= den_addr_ptr_reg;
    quo_addr_ptr_next <= quo_addr_ptr_reg;
    start_div_next    <= '0';

    case state_reg is

      when IDLE =>

        if start_div_i = '1' then
          state_next        <= LOAD_DIV;
          num_addr_ptr_next <= 1;
          den_addr_ptr_next <= 0;
          quo_addr_ptr_next <= 0;
          start_div_next    <= '1';
          
        end if;
        
      when LOAD_DIV =>
        state_next <= WAIT_READY;

      when WAIT_READY =>

        if (ready_div = '1') then
          if (quo_addr_ptr_reg = (N_CHANNELS_ANA/2)-1) then
            state_next        <= IDLE;
            ready_data_o_next <= '1';
          else
            start_div_next    <= '1';
            num_addr_ptr_next <= num_addr_ptr_reg + 2;
            den_addr_ptr_next <= den_addr_ptr_reg + 2;
            quo_addr_ptr_next <= quo_addr_ptr_reg + 1;
            state_next        <= LOAD_DIV;
          end if;
        end if;
        
      when others =>
        state_next <= IDLE;
    end case;
    
  end process main_state_machine;


  -- matriz --> vetor output
  output_process : process(D_ANA_O_ARRAY)
  begin
    for i in 0 to (N_CHANNELS_ANA/2)-1 loop
      for j in 0 to N_BITS_ADC-1 loop
        d_ana_proc_o(((i)*N_BITS_ADC)+j) <= D_ANA_O_ARRAY(i)(j);
      end loop;  -- j
    end loop;  -- i    
  end process;

  
end architecture;

