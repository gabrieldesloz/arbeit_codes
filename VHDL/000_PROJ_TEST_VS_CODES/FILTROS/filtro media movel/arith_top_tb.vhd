-------------------------------------------------------------------------------
-- Title      : Testbench for design "arith_top"
-- Project    :
-------------------------------------------------------------------------------
-- File       : arith_top_tb.vhd
-- Author     :   <gdl@IXION>
-- Company    :
-- Created    : 2013-09-05
-- Last update: 2013-09-05
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-09-05  1.0      gdl     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------

entity arith_top_tb is

end entity arith_top_tb;

-------------------------------------------------------------------------------

architecture RTL1 of arith_top_tb is



  -- clock
  constant sys_clk_period : time := 10 ns;

  -- component generics
  constant SAMPLE_SIZE     : natural := 46;
  constant ACC_BITS        : natural := 8;
  constant MEM_BUFFER_SIZE : natural := 256;
  constant MAX_VALUE       : natural := 40;
  constant SHIFT_DIV_BITS  : natural := 8;

  -- component ports
  signal sysclk               : std_logic                                := '0';
  signal reset_n              : std_logic                                := '0';
  signal sample_available_i   : std_logic                                := '0';
  signal ready_sample_n_o     : std_logic                                := '0';
  signal ready_sample_n_o_2   : std_logic 								 := '0'; 
  signal sample_n_i           : std_logic_vector(SAMPLE_SIZE-1 downto 0) := (others => '0');
  signal average_offset_n_o   : std_logic_vector(SAMPLE_SIZE-1 downto 0) := (others => '0');
  signal average_offset_n_o_2 : std_logic_vector(SAMPLE_SIZE-1 downto 0) := (others => '0');
  signal amostra              : std_logic_vector(SAMPLE_SIZE-1 downto 0) := (others => '0');

  signal average_offset_n_o_plus_offset: std_logic_vector((SAMPLE_SIZE)-1 downto 0);




begin  -- architecture RTL1


  sysclk <= not sysclk after sys_clk_period/2;


  process
  begin
    loop
      wait until sysclk = '1';
      sample_n_i         <= amostra;
      wait for SYS_CLK_PERIOD;
      sample_available_i <= '1';
      wait for SYS_CLK_PERIOD;
      sample_available_i <= '0';
      wait for 15 us;
      sample_n_i         <= (others => '0');
    end loop;
  end process;




-- component instantiation
  DUT : entity work.arith_top
    generic map (
      SAMPLE_SIZE     => SAMPLE_SIZE,
      ACC_BITS        => ACC_BITS,
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SHIFT_DIV_BITS  => SHIFT_DIV_BITS
      )
    port map (
      sysclk             => sysclk,
      reset_n            => reset_n,
      sample_n_i         => sample_n_i,
      sample_available_i => sample_available_i,
      ready_sample_n_o   => ready_sample_n_o,
      average_offset_n_o => average_offset_n_o);


average_offset_n_o_plus_offset <= std_logic_vector(unsigned(average_offset_n_o) + 10);

-- component instantiation
  DUT_2 : entity work.arith_top
    generic map (
      SAMPLE_SIZE     => SAMPLE_SIZE,
      ACC_BITS        => ACC_BITS,
      MEM_BUFFER_SIZE => MEM_BUFFER_SIZE,
      SHIFT_DIV_BITS  => SHIFT_DIV_BITS
      )
    port map (
      sysclk             => sysclk,
      reset_n            => reset_n,
      sample_n_i         => average_offset_n_o_plus_offset,
      sample_available_i => ready_sample_n_o,
      ready_sample_n_o   => ready_sample_n_o_2,
      average_offset_n_o => average_offset_n_o_2);



  estimulo : process(sysclk)
    constant COUNT_MAX : natural := (MAX_VALUE);
    variable counter   : integer := 0;
    variable sample    : natural := 0;
    variable operador  : integer := 0;

  begin
    if rising_edge(sysclk) then
      if sample_available_i = '1' then
        counter := counter + operador;
        if counter = COUNT_MAX then
          operador := -1;
        elsif counter = 0 then
          operador := 1;
        end if;
      end if;
      amostra <= std_logic_vector(to_unsigned(counter, SAMPLE_SIZE));
    end if;
  end process estimulo;



  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => sysclk,
      n_reset => reset_n
      );




end architecture RTL1;

-------------------------------------------------------------------------------

configuration arith_top_tb_RTL1_cfg of arith_top_tb is
  for RTL1
  end for;
end arith_top_tb_RTL1_cfg;

-------------------------------------------------------------------------------
