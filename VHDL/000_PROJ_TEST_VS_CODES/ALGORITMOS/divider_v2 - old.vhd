-------------------------------------------------------------------------------
-- $Id: divider.vhd 3646 2007-11-12 20:54:13Z cls $ 
-- $URL: file:///tcn/dsv/priv/repos/svn/components/0065a-rt4/divider.vhd $
-- Written by Celso Souza on 01/2007
-- Last update: 2013-05-15
-- Description: a sucessive subtraction divider
-- Copyright (C) 2007 Reason Tecnologia S.A. All rights reserved.
-------------------------------------------------------------------------------


-- Libraries and use clauses
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rl131_constants.all;


entity divider_v2 is

-- o divisor subtrai o denominador do numerador até que o numerador seja menor que o denominador
-- O numero de iteraçoes indica o quociente, que é passado para a entidade k_calculator
-- Definition of incoming and outgoing signals.

  
  port (
    sysclk  : in std_logic;
    n_reset : in std_logic;

    -- start of division
    start : in std_logic;

    -- numerator
    num  : in  std_logic_vector ((N-1) downto 0);
    -- denominator
    den  : in  std_logic_vector ((D-1) downto 0);
    -- quotient
    quo  : out std_logic_vector ((Q-1) downto 0);
    -- remainder
    rema : out std_logic_vector ((N-1) downto 0);

    -- ready
    ready : out std_logic
    );

end divider_v2;

------------------------------------------------------------------------------

architecture divider_RTL of divider_v2 is

-- Type declarations
  type STATE_DIV_TYPE is (IDLE_STATE, LOAD_STATE, ADD_SUB_STATE, ADD_SUB_STATE2, END_STATE);
  attribute ENUM_ENCODING                   : string;
  attribute ENUM_ENCODING of STATE_DIV_TYPE : type is "000 001 010 011 100";



-- Local (internal to the model) signals declarations.
  signal state_div      : STATE_DIV_TYPE;
  signal state_div_next : STATE_DIV_TYPE;
  signal rema_reg       : unsigned((N-1) downto 0);
  signal sum_quo_next   : unsigned((Q-1) downto 0);
  signal sum_quo_reg    : unsigned((Q-1) downto 0);
  signal den_int        : unsigned((N-1) downto 0);
  signal rema_next      : unsigned((N-1) downto 0);
  signal step_reg       : unsigned((Q-1) downto 0);
  signal step_next      : unsigned((Q-1) downto 0);
  signal sum_den2_reg   : unsigned((N-1) downto 0);
  signal sum_den2_next  : unsigned((N-1) downto 0);
  signal sum_den_reg    : unsigned((N-1) downto 0);
  signal sum_den_next   : unsigned((N-1) downto 0);

  -- Component declarations

begin

-- concurrent signal assignment statements

  den_int((N-1) downto D) <= (others => '0');
  den_int((D-1) downto 0) <= unsigned(den);
  quo                     <= std_logic_vector(sum_quo_reg);
  rema                    <= std_logic_vector(rema_reg);

-- Processes

-- division with repeated subtration
  -- state register
  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_div    <= IDLE_STATE;
      rema_reg     <= (others => '0');
      step_reg     <= (others => '0');
      sum_den2_reG <= (others => '0');
      sum_den_reg  <= (others => '0');
      step_reg     <= (others => '0');
      sum_quo_reg  <= (others => '0');
    elsif rising_edge (sysclk) then
      state_div    <= state_div_next;
      rema_reg     <= rema_next;
      step_reg     <= step_next;
      sum_den2_reg <= sum_den2_next;
      sum_den_reg  <= sum_den_next;
      step_reg     <= step_next;
      sum_quo_reg  <= sum_quo_next;
      
    end if;
  end process;

  -- next state logic and output logic   
  process (den, den_int, num, rema_reg, start, state_div, sum_quo_reg, 
           step_reg, sum_den_reg, sum_den2_reg, step_next)
  begin
    rema_next     <= rema_reg;
    sum_quo_next  <= sum_quo_reg;
    sum_den2_next <= sum_den2_reg;
    sum_den_next  <= sum_den_reg;
    step_next     <= step_reg;
    ready         <= '0';
    case (state_div) is
      
      when IDLE_STATE =>
        state_div_next <= IDLE_STATE;
        if (start = '1') then
          if (den = ZERO_STD) then
            state_div_next <= END_STATE;
          else
            state_div_next <= LOAD_STATE;
          end if;
        end if;

      when LOAD_STATE =>
        rema_next      <= unsigned(num);
        sum_quo_next   <= (others => '0');
        sum_den_next   <= den_int;
        sum_den2_next  <= den_int + den_int;
        state_div_next <= ADD_SUB_STATE;
        step_next      <= (0      => '1', others => '0');
        
      when ADD_SUB_STATE =>

        
        if sum_den2_reg < rema_reg then
          rema_next      <= rema_reg - sum_den2_reg;
          sum_den_next   <= sum_den2_reg + den_int;
          sum_den2_next  <= sum_den2_reg + sum_den2_reg;
          step_next      <= step_reg(q-2 downto 0) & '0';  -- shift - multiplica por dois;
          sum_quo_next   <= step_next + sum_quo_reg;
          state_div_next <= ADD_SUB_STATE;
        elsif sum_den_reg <= rema_reg then
          rema_next    <= rema_reg - sum_den_reg;
          sum_den_next <= sum_den_reg + den_int;
          step_next    <= step_reg + 1;
          sum_quo_next <= step_next + sum_quo_reg; 
        state_div_next <= ADD_SUB_STATE;
        else
          state_div_next <= ADD_SUB_STATE2;
        end if;
        
        
      when ADD_SUB_STATE2 =>


        if rema_reg > den_int then
          rema_next      <= rema_reg - den_int;
          step_next      <= step_reg + 1;
          sum_quo_next   <= sum_quo_reg + 1;
          --carrega os valores iniciais novamente nos registradores
          sum_den_next   <= den_int;
          sum_den2_next  <= den_int + den_int;
          step_next      <= (0 => '1', others => '0');
          state_div_next <= ADD_SUB_STATE;
        else
          state_div_next <= END_STATE;
        end if;
        
        
        
      when END_STATE =>
        ready          <= '1';
        state_div_next <= IDLE_STATE;

      when others =>
        state_div_next <= IDLE_STATE;

    end case;
  end process;

end divider_RTL;

-- eof $id:$
