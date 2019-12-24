library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity variable_adjust is
  
  generic (
    D                   : natural;
    N_BITS_NCO_SOC      : natural;
    SOC_TIME_SOC        : natural;
    DELTA_LIMIT_LOCKED  : natural;
    DELTA_LIMIT         : natural;
    LIMIT_HI_SOC        : natural;
    LIMIT_HI_SOC_LOCKED : natural

    );

  port
    (
      pps_pulse : in std_logic;
      n_reset   : in std_logic;
      sysclk    : in std_logic;
      m_freq    : in std_logic_vector(D-1 downto 0);

      soc_timer_d2_var      : out std_logic_vector(D-1 downto 0);
      limit_high_var        : out std_logic_vector(D-1 downto 0);
      limit_high_locked_var : out std_logic_vector(D-1 downto 0)

      );

end entity variable_adjust;

architecture variable_adjust_RTL of variable_adjust is


  type state_type is (STARTUP, OP, INIT_OP_1, WAIT_1, SAVE_RSLT_1, INIT_OP_2, WAIT_2, SAVE_RSLT_2);


  attribute syn_encoding               : string;
  attribute syn_encoding of state_type : type is "safe";


  signal state_next, state_reg                                 : state_type;
  signal soc_timer_d2_var_reg, soc_timer_d2_var_next           : unsigned(D-1 downto 0);
  signal limit_high_var_next, limit_high_var_reg               : unsigned(D-1 downto 0);
  signal limit_high_locked_var_reg, limit_high_locked_var_next : unsigned(D-1 downto 0);
  signal temp_rslt_next, temp_rslt_reg                         : unsigned(D-1 downto 0);
  signal b_reg, b_next                                         : unsigned(D-1 downto 0);
  signal m_freq_int                                            : unsigned(m_freq'range);
  
begin

  soc_timer_d2_var      <= std_logic_vector(soc_timer_d2_var_reg);
  limit_high_var        <= std_logic_vector(limit_high_var_reg);
  limit_high_locked_var <= std_logic_vector(limit_high_locked_var_reg);



  process(n_reset, sysclk)

  begin

    if n_reset = '0' then
      b_reg                     <= (others => '0');
      temp_rslt_reg             <= (others => '0');
      state_reg                 <= STARTUP;
      soc_timer_d2_var_reg      <= (others => '0');
      limit_high_var_reg        <= (others => '0');
      limit_high_locked_var_reg <= (others => '0');
      
    elsif rising_edge(sysclk) then
      b_reg                     <= b_next;
      temp_rslt_reg             <= temp_rslt_next;
      state_reg                 <= state_next;
      limit_high_locked_var_reg <= limit_high_locked_var_next;
      soc_timer_d2_var_reg      <= soc_timer_d2_var_next;
      limit_high_var_reg        <= limit_high_var_next;
      
    end if;
  end process;

  m_freq_int     <= unsigned(m_freq);
  temp_rslt_next <= m_freq_int - b_reg;
  


  process(limit_high_locked_var_reg,
          limit_high_var_reg,
          soc_timer_d2_var_reg,
          state_reg,
          temp_rslt_reg,
          m_freq_int,
          pps_pulse,
          b_reg)

  begin
    --default  
    state_next                 <= state_reg;
    b_next                     <= b_reg;
    soc_timer_d2_var_next      <= soc_timer_d2_var_reg;
    limit_high_var_next        <= limit_high_var_reg;
    limit_high_locked_var_next <= limit_high_locked_var_reg;

    case state_reg is
      
      when STARTUP =>
        
        soc_timer_d2_var_next      <= to_unsigned((SOC_TIME_SOC/2) + 1, D);
        limit_high_var_next        <= to_unsigned(LIMIT_HI_SOC, D);
        limit_high_locked_var_next <= to_unsigned(LIMIT_HI_SOC_LOCKED, D);
        state_next                 <= OP;
        
      when OP =>
        
        if pps_pulse = '1' then
          soc_timer_d2_var_next <= ('0' & m_freq_int(m_freq_int'high downto 1)) + 1;
          state_next            <= INIT_OP_1;
        end if;
        
      when INIT_OP_1 =>
        
        b_next     <= to_unsigned(DELTA_LIMIT/2, D);
        state_next <= WAIT_1;

      when WAIT_1 =>
        state_next <= SAVE_RSLT_1;
        
      when SAVE_RSLT_1 =>
        
        limit_high_var_next <= temp_rslt_reg;
        state_next          <= INIT_OP_2;
        
      when INIT_OP_2 =>
        
        b_next     <= to_unsigned(DELTA_LIMIT_LOCKED/2, D);
        state_next <= WAIT_2;
        

      when WAIT_2 =>
        state_next <= SAVE_RSLT_2;
        
      when SAVE_RSLT_2 =>
        
        limit_high_locked_var_next <= temp_rslt_reg;
        state_next                 <= OP;


      when others =>
        state_next <= STARTUP;
        
    end case;
    
  end process;




--       if pps = '1' then
--          if region_k_controller = 1 or region_k_controller = 3 then
--                      if drift_p_s > 10_000 + 100 then
--                       step_normal_var_next <= step_normal_var_reg - ("00" & step_normal_var_reg(m_freq'high downto 2));
--                      elsif drift_p_s < 10_000 - 100 then
--                      step_normal_var_next <= step_normal_var_reg + ("00" & step_normal_var_reg(m_freq'high downto 2));
--                      else
--                      step_normal_var_next <= step_normal_var_reg;
--            end if;
--         end if;
  
  
  
  
  
  
  
end architecture;



