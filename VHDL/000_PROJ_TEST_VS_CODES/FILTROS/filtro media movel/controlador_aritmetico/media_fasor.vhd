library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.rl131_constants.all;

-- entity declaration
entity media_fasor is
  port(
    -- system signals
    sysclk  : in std_logic;
    reset_n : in std_logic;

    -- interface signals
    start_calc  : in  std_logic;
    finish_calc : out std_logic;
    mag_in      : in  std_logic_vector(31 downto 0);
    mag_out     : out std_logic_vector(31 downto 0)
    );
end media_fasor;


architecture rtl of media_fasor is
  -- Build an enumerated type for the state machine
  type STATE_TYPE_CORE is (WAIT_START_CALC, SUM_P1, SUM_P2, READY, DONE, D1, D2, D3);

  attribute ENUM_ENCODING                    : string;
  attribute ENUM_ENCODING of STATE_TYPE_CORE : type is "000 001 010 011 100 101 110 111";

  constant MEAN_SIZE : natural := 32;


  --type MEAN_MEMORY is array (MEAN_SIZE * (N_CHANNELS_ANA + 1) downto 0) of std_logic_vector (15 downto 0);
  type MEAN_MEMORY is array (MEAN_SIZE - 1 downto 0) of std_logic_vector (31 downto 0);
  
  signal memory_mean : MEAN_MEMORY;


  -- Registers to hold the current state
  signal state_core      : STATE_TYPE_CORE;
  signal state_core_next : STATE_TYPE_CORE;


  
  signal mean_reg      : std_logic_vector(36 downto 0);
  signal mean_reg_next : std_logic_vector(36 downto 0);

  signal contador_ph      : natural range 0 to 31;
  signal contador_ph_next : natural range 0 to 31;

  signal first_time_reg  : std_logic;
  signal first_time_next : std_logic;

  signal aux_a_reg  : std_logic_vector(36 downto 0);
  signal aux_a_next : std_logic_vector(36 downto 0);


  signal finish_calc_reg  : std_logic;
  signal finish_calc_next : std_logic;

  signal mag_out_reg  : std_logic_vector (31 downto 0);
  signal mag_out_next : std_logic_vector (31 downto 0);

  signal read_counter      : natural range 0 to 31;
  signal read_counter_next : natural range 0 to 31;


begin

  mag_out     <= mag_out_reg;
  finish_calc <= finish_calc_reg;

  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if (start_calc = '1') then
        memory_mean(contador_ph) <= mag_in;
      end if;
    end if;
  end process;

  process (reset_n, sysclk) is
  begin
    if reset_n = '0' then
      state_core      <= WAIT_START_CALC;
      mean_reg        <= (others => '0');
      first_time_reg  <= '1';
      aux_a_reg       <= (others => '0');
      contador_ph     <= 0;
      mag_out_reg     <= (others => '0');
      finish_calc_reg <= '0';
      read_counter    <= 0;
    elsif rising_edge(sysclk) then
      state_core      <= state_core_next;
      mean_reg        <= mean_reg_next;
      aux_a_reg       <= aux_a_next;
      first_time_reg  <= first_time_next;
      contador_ph     <= contador_ph_next;
      mag_out_reg     <= mag_out_next;
      finish_calc_reg <= finish_calc_next;
      read_counter    <= read_counter_next;
    end if;
  end process;

  process (aux_a_reg, contador_ph, finish_calc_reg, first_time_reg,
           mag_out_reg, mean_reg, memory_mean, read_counter, start_calc,
           state_core)
  begin
    state_core_next   <= state_core;
    mean_reg_next     <= mean_reg;
    first_time_next   <= first_time_reg;
    contador_ph_next  <= contador_ph;
    aux_a_next        <= aux_a_reg;
    mag_out_next      <= mag_out_reg;
    finish_calc_next  <= finish_calc_reg;
    read_counter_next <= read_counter;

    case state_core is
      
      when WAIT_START_CALC =>
        if start_calc = '1' then
          first_time_next <= '1';
          if contador_ph = MEAN_SIZE - 1 then
            contador_ph_next <= 0;
            state_core_next  <= READY;
          else
            contador_ph_next <= contador_ph + 1;
          end if;
        end if;
        
      when READY =>
        finish_calc_next <= '0';
        if first_time_reg = '1' then
          first_time_next <= '0';
          state_core_next <= SUM_P1;
        else
          first_time_next <= '0';
          if start_calc = '1' then
            if contador_ph = 31 then
              contador_ph_next <= 0;
            else
              contador_ph_next <= contador_ph + 1;
            end if;
            state_core_next <= SUM_P1;
          end if;
        end if;
        
      when SUM_P1 =>
        mean_reg_next   <= "00000" & memory_mean(read_counter);
        state_core_next <= SUM_P2;
        
      when SUM_P2 =>
        aux_a_next <= aux_a_reg + mean_reg;
        if read_counter = MEAN_SIZE - 1 then
          state_core_next <= DONE;
        else
          read_counter_next <= read_counter + 1;
          state_core_next   <= SUM_P1;
        end if;
        
        
      when DONE =>
        mag_out_next      <= aux_a_reg(36 downto 5);
        read_counter_next <= 0;
        finish_calc_next  <= '1';
        aux_a_next        <= (others => '0');
        state_core_next   <= READY;
        
        
      when others =>
        state_core_next <= WAIT_START_CALC;

    end case;
    
  end process;

end rtl;
