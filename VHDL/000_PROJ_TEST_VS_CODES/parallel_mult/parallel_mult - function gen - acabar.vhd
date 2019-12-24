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
-- Last update: 2014-05-05
-- Platform   : 
-- Standard   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2011/2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-03   1.0      GDL     Revised 
-------------------------------------------------------------------------------


--verificar se N é multiplo da granularidade
-- senão, aumentar tamanho

-- efetuar multiplicação




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity parallel_mult is
  generic (
    N   : natural := 111;               -- multiplos de 18 
    LUT : natural := 18
    );

  port (
    sysclk  : in  std_logic;
    n_reset : in  std_logic;
    start   : in  std_logic;
    done    : out std_logic;
    ready   : out std_logic;
    a       : in  std_logic_vector(N-1 downto 0);
    b       : in  std_logic_vector(N-1 downto 0);
    c       : out std_logic_vector((2*N)-1 downto 0)
    );


end entity parallel_mult;

architecture rd_RTL of parallel_mult is


  

  
  type STATE_TYPE is (IDLE, ADD_PARC_1, ADD_PARC_2, ADD_PARC_3, DONE_ST);
  signal state_reg, state_next         : STATE_TYPE;
  attribute syn_encoding               : string;
  attribute syn_encoding of state_type : type is "safe";


  function make_z
    (
      constant N   : in natural;
      constant LUT : in natural
      ) return natural is

    variable z : natural;
  begin
    z := N;
    L1 : loop      
      exit L1 when (z mod LUT = 0);
      z := z+1;
    end loop;
    return z;
  end function;


  constant Z : natural := (make_z(N, LUT));
  constant M : natural := (Z/LUT);

  
  type M_ARRAY is array (integer range <>) of std_logic_vector(2*LUT-1 downto 0);
  signal multiply_array_next, multiply_array_reg: M_ARRAY (0 to (M*M)-1);

  
-- signal declarations

  
  signal teste                         : std_logic_vector(Z-1 downto 0);
  signal teste2                        : std_logic_vector(M-1 downto 0);
  signal div_p1_1_next, div_p1_1_reg   : unsigned(a'length-1 downto 0);
  signal div_p1_2_next, div_p1_2_reg   : unsigned(a'length-1 downto 0);
  signal div_p2_1_next, div_p2_1_reg   : unsigned(a'length-1 downto 0);
  signal div_p2_2_next, div_p2_2_reg   : unsigned(a'length-1 downto 0);
  signal add_p1_p1_next, add_p1_p1_reg : unsigned((a'length + a'length/2)-1 downto 0);
  signal add_p1_p2_next, add_p1_p2_reg : unsigned((a'length + a'length/2)-1 downto 0);
  signal add_p2_next, add_p2_reg       : unsigned((2*a'length)-1 downto 0);


-- atributos sintese - preservar registradores para a otimizacÃ£o de timing
--  attribute syn_keep: boolean;
--  attribute syn_keep of div_p1_1_reg: signal is true;
--  attribute syn_keep of div_p1_2_reg: signal is true;
--  attribute syn_keep of div_p2_1_reg: signal is true;
--  attribute syn_keep of div_p2_2_reg: signal is true;
--  attribute syn_keep of add_p1_p1_reg: signal is true; 
--  attribute syn_keep of add_p1_p2_reg: signal is true;
--  attribute syn_keep of add_p2_reg: signal is true;  



begin  -- architecture rd_RTL



  process (n_reset, sysclk)
  begin
    if (n_reset = '0') then
      state_reg <= IDLE;

      div_p1_1_reg  <= (others => '0');
      div_p1_2_reg  <= (others => '0');
      div_p2_1_reg  <= (others => '0');
      div_p2_2_reg  <= (others => '0');
      add_p1_p1_reg <= (others => '0');
      add_p1_p2_reg <= (others => '0');
      add_p2_reg    <= (others => '0');


    elsif rising_edge (sysclk) then


      div_p1_1_reg  <= div_p1_1_next;
      div_p1_2_reg  <= div_p1_2_next;
      div_p2_1_reg  <= div_p2_1_next;
      div_p2_2_reg  <= div_p2_2_next;
      add_p1_p1_reg <= add_p1_p1_next;
      add_p1_p2_reg <= add_p1_p2_next;
      add_p2_reg    <= add_p2_next;


      state_reg <= state_next;
    end if;
  end process;


  state_machine : process(a, add_p1_p1_reg, add_p1_p2_reg, add_p2_reg,
                          b, div_p1_1_reg, div_p1_2_reg, div_p2_1_reg,
                          div_p2_2_reg, state_reg, start) is
  begin  -- process state_machine


    done           <= '0';
    ready          <= '0';
    state_next     <= state_reg;
    div_p1_1_next  <= div_p1_1_reg;
    div_p1_2_next  <= div_p1_2_reg;
    div_p2_1_next  <= div_p2_1_reg;
    div_p2_2_next  <= div_p2_2_reg;
    add_p1_p1_next <= add_p1_p1_reg;
    add_p1_p2_next <= add_p1_p2_reg;
    add_p2_next    <= add_p2_reg;



    case state_reg is
      when IDLE =>

        if start = '1' then
          state_next <= ADD_PARC_1;
        end if;

        
      when ADD_PARC_1 =>
        
        div_p1_1_next <= resize(unsigned(a((a'length/2)-1 downto 0)) * unsigned(b((b'length/2)-1 downto 0)), a'length);
        div_p1_2_next <= resize(unsigned(a((a'length/2)-1 downto 0)) * unsigned(b(b'length-1 downto b'length/2)), a'length);
        div_p2_1_next <= resize(unsigned(a(a'length-1 downto a'length/2)) * unsigned(b((b'length/2)-1 downto 0)), a'length);
        div_p2_2_next <= resize(unsigned(a(a'length-1 downto a'length/2)) * unsigned(b(b'length-1 downto b'length/2)), a'length);
        state_next    <= ADD_PARC_2;
        
      when ADD_PARC_2 =>
        add_p1_p1_next <= resize(div_p1_1_reg, a'length + a'length/2) + (resize(div_p1_2_reg, a'length + a'length/2) sll a'length/2);
        add_p1_p2_next <= resize(div_p2_1_reg, a'length + a'length/2) + (resize(div_p2_2_reg, a'length + a'length/2) sll a'length/2);
        state_next     <= ADD_PARC_3;

      when ADD_PARC_3 =>
        add_p2_next <= resize(add_p1_p1_reg, 2*a'length) + (resize(add_p1_p2_reg, 2*a'length) sll a'length/2);
        state_next  <= DONE_ST;

      when DONE_ST =>
        done       <= '1';
        state_next <= IDLE;

      when others =>
        state_next <= IDLE;
        
    end case;
  end process state_machine;

  c <= std_logic_vector(add_p2_reg);

  --process()
  --begin
  --result_next(z) <= a_vect((i*LUT)+LUT-1 downto i*LUT)* b_vect((j*LUT)+LUT-1 downto j*LUT);    
  --end process;


  process()
    begin
      for i in 0 to M-1 loop
        for j in 0 to M-1 loop
          multiply_array_next(i+j) <= resize(signed(a_vect((i*LUT)+LUT-1 downto i*LUT))* signed(b_vect((j*LUT)+LUT-1 downto j*LUT)),2*LUT);           
        end loop;  -- j        
      end loop;  -- i in 0 to M-1
  
end architecture;

