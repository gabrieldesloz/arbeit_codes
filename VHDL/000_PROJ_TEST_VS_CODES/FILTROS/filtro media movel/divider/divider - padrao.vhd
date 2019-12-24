-------------------------------------------------------------------------------
-- $Id:
-- $URL:
-- Title      : Synchronization Module  
-- Project    : protective relay
-------------------------------------------------------------------------------
-- File       : divider.vhd
-- Author     : Gabriel Deschamps Lozano
-- Company    : Reason Tecnologia S.A.
-- Created    : 2012-08-01
-- Last update: 2013-08-16
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Binary divider based on the restoring divider algorithm
-------------------------------------------------------------------------------
-- Copyright (c) 2011/2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-03   1.0      GDL     Revised 
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity divider is
  generic (  
    N    : natural;
    D    : natural);

  port (
    sysclk  : in  std_logic;
    n_reset : in  std_logic;
    start   : in  std_logic;
    num     : in  std_logic_vector ((N-1) downto 0);
    den     : in  std_logic_vector ((D-1) downto 0);
    quo     : out std_logic_vector ((N-1) downto 0);
    rema    : out std_logic_vector ((N-1) downto 0);
    ready   : out std_logic;
    done    : out std_logic
    );


end entity divider;

architecture rd_RTL of divider is

  type STATE_TYPE is (IDLE, MULT, SUBT, CHECK, DONE_ST);

  attribute syn_encoding               : string;
  attribute syn_encoding of STATE_TYPE : type is "safe";


  signal state_reg, state_next                                    : STATE_TYPE;
  signal shift_vector_next, shift_vector_reg                      : unsigned((D+N) downto 0);
  signal b_next, b_reg                                            : unsigned(D-1 downto 0);
  signal i_count_next, i_count_reg                                : natural range 0 to N;
  signal den_sign_reg, den_sign_next, num_sign_reg, num_sign_next : std_logic;
  signal signal_fix_reg, signal_fix_next                          : std_logic;
  constant ZERO_STD                                               : std_logic_vector((D-1) downto 0) := (others => '0');




begin  -- architecture rd_RTL


  rema <= std_logic_vector(resize(shift_vector_reg(D+N downto N),N));
  quo  <= std_logic_vector(shift_vector_reg(N-1 downto 0));




  registers : process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      shift_vector_reg <= (others => '0');
      B_reg            <= (others => '0');
      i_count_reg      <= 0;
      state_reg        <= IDLE;
    elsif rising_edge (sysclk) then
      i_count_reg      <= i_count_next;
      state_reg        <= state_next;
      shift_vector_reg <= shift_vector_next;
      B_reg            <= B_next;
    end if;
  end process;


  main_state_machine :
  process(
    B_reg,
    i_count_reg,
    num,
    shift_vector_reg,
    start,
    state_reg,
    den
    ) is

  begin  -- process state_machine
    
    done              <= '0';
    ready             <= '0';
    i_count_next      <= i_count_reg;
    shift_vector_next <= shift_vector_reg;
    B_next            <= B_reg;
    state_next        <= state_reg;

    case state_reg is

      when IDLE =>
        ready <= '1';

        if start = '1' then
          if (den = ZERO_STD) then
            state_next <= DONE_ST;
          else
            shift_vector_next(N-1 downto 0) <= unsigned(num);
            B_next                          <= unsigned(den);
            state_next                      <= mult;
            i_count_next                    <= 0;           
          end if;
        end if;   
        
      when MULT =>
        
        if i_count_reg = N then
          state_next <= DONE_ST;
        else
          shift_vector_next(D+N downto 1) <= shift_vector_reg(D+N-1 downto 0);
          state_next                      <= CHECK;
        end if;


      when CHECK =>
        if shift_vector_reg((D+N) downto N) >= (B_reg) then
          state_next <= SUBT;
        else
          i_count_next         <= i_count_reg + 1;
          shift_vector_next(0) <= '0';
          state_next           <= MULT;
        end if;


      when SUBT =>
        shift_vector_next(D+N downto N) <= shift_vector_reg(D+N downto N) - (B_reg);
        shift_vector_next(0)            <= '1';
        i_count_next                    <= i_count_reg + 1;
        state_next                      <= MULT;

      when DONE_ST =>
        done       <= '1';
        state_next <= IDLE;

      when others =>
        state_next <= IDLE;

        
    end case;
  end process main_state_machine;






end architecture;

