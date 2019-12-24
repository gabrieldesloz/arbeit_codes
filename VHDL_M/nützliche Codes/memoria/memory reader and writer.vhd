library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity m_freq_emulator is
  
  generic (
    D               : natural;
    MEM_BUFFER_SIZE : natural := 32;
    MEM_BUFFER_BITS : natural := 5;
    FREQ_BITS       : natural := 4
    ); 

  port (
    CLK_FREQUENCY_STD : in  std_logic_vector(D-1 downto 0);
    m_freq_in         : in  std_logic_vector(D-1 downto 0);
    m_freq_out        : out std_logic_vector(D-1 downto 0);
    n_reset           : in  std_logic;
    sysclk            : in  std_logic;
    clear_dco         : in  std_logic;
    time_out          : in  std_logic;
    pps_edge          : in  std_logic
    );
end m_freq_emulator;


architecture m_freq_emulator_ARQ of m_freq_emulator is

  type STATE_TYPE_M_FREQ is (INIT_ZERO_1, INIT_ZERO_2, WRITE_MEM, READ_MEM); 
    attribute ENUM_ENCODING : string;
  attribute ENUM_ENCODING of STATE_TYPE_M_FREQ : type is "00 01 10 11";
  attribute syn_encoding                       : string;
  attribute syn_encoding of STATE_TYPE_M_FREQ  : type is "safe";
  signal state_reg, state_next                 : STATE_TYPE_M_FREQ;

  type FREQUENCY_BUFFER is array (MEM_BUFFER_BITS-1 downto 0) of std_logic_vector (FREQ_BITS-1 downto 0);
  signal m_freq_buffer : FREQUENCY_BUFFER;

  signal f_write_next, f_write_reg         : std_logic;
  signal mem_pointer_next, mem_pointer_reg : std_logic_vector(MEM_BUFFER_BITS-1 downto 0);
  signal m_freq_mem                        : std_logic_vector(FREQ_BITS-1 downto 0);
  signal m_freq_out_next, m_freq_out_reg   : std_logic_vector(D-1 downto 0);
  
begin
  
  process (n_reset, sysclk,CLK_FREQUENCY_STD) is
  begin
    if (n_reset = '0') then
      state_reg       <= INIT_ZERO_1;
      mem_pointer_reg <= (others => '0');
      f_write_reg     <= '0';
      m_freq_out_reg  <= CLK_FREQUENCY_STD;
    elsif rising_edge(sysclk) then
      m_freq_out_reg  <= m_freq_out_next;
      state_reg       <= state_next;
      mem_pointer_reg <= mem_pointer_next;
      f_write_reg     <= f_write_next;
    end if;
  end process;

  m_freq_out <= m_freq_out_reg;

  process(clear_dco, f_write_reg, m_freq_in, m_freq_mem, m_freq_out_reg,
          mem_pointer_reg, pps_edge, state_reg, time_out)
  begin
    mem_pointer_next <= mem_pointer_reg;
    f_write_next     <= f_write_reg;
    state_next       <= state_reg;
    m_freq_out_next  <= m_freq_out_reg;

    case state_reg is

      -- memory initialization states ---------------------------------------
      when INIT_ZERO_1 =>
        f_write_next     <= '1';
        mem_pointer_next <= (others => '0');
        state_next       <= INIT_ZERO_2;
      when INIT_ZERO_2 =>
        f_write_next <= '1';
        if (mem_pointer_reg = (MEM_BUFFER_SIZE - 1)) then
          state_next       <= WRITE_MEM;
          mem_pointer_next <= (others => '0');
        else
          mem_pointer_next <= mem_pointer_reg + 1;
          state_next       <= INIT_ZERO_2;
        end if;

        ------------------------------------------------------------------------         

      when WRITE_MEM =>
        m_freq_out_next <= m_freq_in;
        if time_out = '0' then
          if pps_edge = '1' then
            f_write_next <= '1';
            if (mem_pointer_reg = (MEM_BUFFER_SIZE - 1)) then
              mem_pointer_next <= (others => '0');
            else
              mem_pointer_next <= mem_pointer_reg + 1;
            end if;
          end if;
        else
          f_write_next     <= '0';
          mem_pointer_next <= (others => '0');
          state_next       <= READ_MEM;
        end if;
        
      when READ_MEM =>
        if time_out = '1' then
          if clear_dco = '1' then
            m_freq_out_next  <= m_freq_in(m_freq_in'high downto 4) & m_freq_mem;
            mem_pointer_next <= mem_pointer_reg + 1;
          elsif mem_pointer_reg = MEM_BUFFER_SIZE-1 then
            mem_pointer_next <= (others => '0');
          end if;
        else
          f_write_next     <= '1';
          mem_pointer_next <= (others => '0');
          state_next       <= WRITE_MEM;
        end if;

      when others =>
        state_next <= INIT_ZERO_1;
    end case;
  end process;

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
      if (f_write_reg = '1') then
        m_freq_buffer(CONV_INTEGER(mem_pointer_reg)) <= m_freq_in(FREQ_BITS-1 downto 0);
      end if;
      m_freq_mem <= m_freq_buffer(CONV_INTEGER(mem_pointer_reg));
    end if;
  end process;



end m_freq_emulator_ARQ;

