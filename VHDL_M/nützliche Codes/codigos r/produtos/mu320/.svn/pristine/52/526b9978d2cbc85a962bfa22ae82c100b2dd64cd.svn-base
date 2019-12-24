-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : Synchronization Module
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : 
-- Author     : 
-- Company    : Reason Tecnologia S.A.
-- Created    : 
-- Last update: 2013-06-12
-- Platform   :
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: A vhdl module to filter improper pps input
-------------------------------------------------------------------------------
-- Copyright (c)
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-06      1.0      GDL     Created

-------------------------------------------------------------------------------





-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pps_cleaner is

  generic (
    D                : natural;
    PERIOD_FREQ_MIN  : natural;
    PERIOD_FREQ_MAX  : natural;
    FM_MAX_DEVIATION : natural
    );
  port (
    CLK_FREQUENCY_STD : in  std_logic_vector(D-1 downto 0);
    sysclk            : in  std_logic;
    n_reset           : in  std_logic;
    sync_pps_delayed  : in  std_logic;
    pps_pulse         : in  std_logic;
    clean_pps         : out std_logic
    );
end pps_cleaner;
------------------------------------------------------------------------------

architecture pps_cleaner_RTL of pps_cleaner is

-- Local (internal to the model) signals declarations.



  constant FREQ_STABLE_TIME : natural := 10;

  -- funcoes maximo, minimo
  
  function maximum (
    left, right : unsigned)           
    return unsigned is
  begin  -- function max
    if (left) > (right) then return left;
    else return right;
    end if;
  end function maximum;

  function minimum (
    left, right : unsigned)           
    return unsigned is
  begin  -- function minimum
    if (left) < (right) then return left;
    else return right;
    end if;
  end function minimum;


  type STATE_TYPE is (SYS_START,
                      OP,
                      FILTER_LARGE,
                      FILTER_JITTER);

  attribute SYN_ENCODING               : string;
  attribute SYN_ENCODING of STATE_TYPE : type is "safe";

  signal save_meas_fsm_reg, save_meas_fsm_next           : STATE_TYPE;
  signal counter_reg, counter_next                       : unsigned((D-1) downto 0);
  signal counter_timeout_reg, counter_timeout_next       : unsigned((D-1) downto 0);
  signal meas_pps_value_reg, meas_pps_value_next         : unsigned((D-1) downto 0);
  signal old_meas_pps_value_next, old_meas_pps_value_reg : unsigned((D-1) downto 0);
  signal filter_jitter_condition_test                    : unsigned((D-1) downto 0);
  signal clear                                           : std_logic;
  signal count_ok_reg, count_ok_next                     : natural range 0 to FREQ_STABLE_TIME;
  signal clean_pps_int                                   : std_logic;


 
  
begin
  
  clean_pps <= clean_pps_int;

  -- registradores, reset assincrono
  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then

      save_meas_fsm_reg      <= SYS_START;
      counter_reg            <= (others => '0');
      counter_timeout_reg    <= (others => '0');
      meas_pps_value_reg     <= (others => '0');
      old_meas_pps_value_reg <= (others => '0');
      count_ok_reg           <= 0;  

    elsif rising_edge (sysclk) then
      save_meas_fsm_reg      <= save_meas_fsm_next;    
      counter_reg            <= counter_next;
      counter_timeout_reg    <= counter_timeout_next;
      meas_pps_value_reg     <= meas_pps_value_next;
      old_meas_pps_value_reg <= old_meas_pps_value_next;
      count_ok_reg           <= count_ok_next;
 

    end if;
  end process;




-- contador da frequencia
  counter_next <= (others => '0') when (clear = '1') else
                  counter_reg + 1;

-- contador timeout

  counter_timeout_next <= (others => '0') when (clean_pps_int = '1') else
                          counter_timeout_reg + 1;



-------------------------------------------------------------------------------
-- FSM -  valores de pps medidos e filtro-- 
-------------------------------------------------------------------------------
  
  
  pps_filter_fsm : process(
    CLK_FREQUENCY_STD,
    counter_reg,  
    meas_pps_value_reg,
    old_meas_pps_value_reg,
    save_meas_fsm_reg,
    pps_pulse,
    count_ok_reg
    )
  begin

    -- padrao
    meas_pps_value_next     <= meas_pps_value_reg;
    old_meas_pps_value_next <= old_meas_pps_value_reg;
    save_meas_fsm_next      <= save_meas_fsm_reg;  
    clear                   <= '0';
    count_ok_next           <= count_ok_reg;
    clean_pps_int           <= '0';
    --

    case save_meas_fsm_reg is

      when SYS_START =>
        --carrega os valores default estabelecidos no arquivo de constante 
        meas_pps_value_next     <= unsigned(CLK_FREQUENCY_STD);
        old_meas_pps_value_next <= unsigned(CLK_FREQUENCY_STD);    
        save_meas_fsm_next      <= OP;
        count_ok_next           <= 0;
        
      when OP =>

        --espera pelo pulso de pps
        if pps_pulse = '1' then
          clear                   <= '1';
          -- salva valor atual
          meas_pps_value_next     <= counter_reg;
          -- salva valor anterior
          old_meas_pps_value_next <= meas_pps_value_reg;
          save_meas_fsm_next      <= FILTER_LARGE;
        else
          -- mantem mesmos valores
          meas_pps_value_next     <= meas_pps_value_reg;
          old_meas_pps_value_next <= old_meas_pps_value_reg;
        end if;
        
        
      when FILTER_LARGE =>
        -- filtra quando o periodo medido eh muito maior que o range estabelecido 
        if (meas_pps_value_reg > PERIOD_FREQ_MIN) and (meas_pps_value_reg < PERIOD_FREQ_MAX) then
          save_meas_fsm_next <= FILTER_JITTER;
        else
          save_meas_fsm_next <= OP;
          count_ok_next      <= 0;
        end if;
        

      when FILTER_JITTER =>
        
        save_meas_fsm_next <= OP;

        -- filtra conforme jitter maximo 
        if ((maximum(meas_pps_value_reg, old_meas_pps_value_reg) - minimum(meas_pps_value_reg, old_meas_pps_value_reg)) <= FM_MAX_DEVIATION) then
          -- contador freq estavel
          count_ok_next <= count_ok_reg + 1;
          if count_ok_reg = FREQ_STABLE_TIME-1 then        
            -- mantem o mesmo valor caso frequencia estavel
            count_ok_next <= FREQ_STABLE_TIME-1;
            -- output PPS            
            clean_pps_int <= '1';
          end if;
        else
          count_ok_next <= 0;
        end if;
        
    end case;
  end process;



-- modelsim test
  filter_jitter_condition_test <= (maximum(meas_pps_value_reg, old_meas_pps_value_reg) - minimum(meas_pps_value_reg, old_meas_pps_value_reg));


end pps_cleaner_RTL;

-- eof $id:$

