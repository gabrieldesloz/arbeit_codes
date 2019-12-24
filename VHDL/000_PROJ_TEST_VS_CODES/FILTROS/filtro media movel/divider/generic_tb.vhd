
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------

entity generic_tb is


end generic_tb;

-------------------------------------------------------------------------------

architecture generic_tb_rtl of generic_tb is


  -- component ports

  -- clock
  constant sys_clk_period : time      := 10 ns;
  constant N              : natural   := 32;
  constant D              : natural   := 20;
  constant SIGN           : std_logic := '1';




  constant numerador   : integer := -20;
  constant denominador : integer := -5;


-- uut signals

  signal sysclk  : std_logic                       := '0';
  signal n_reset : std_logic                       := '0';
  signal start   : std_logic                       := '0';
  signal num     : std_logic_vector (N-1 downto 0) := (others => '0');
  signal den     : std_logic_vector (D-1 downto 0) := (others => '0');
  signal quo     : std_logic_vector (N-1 downto 0) := (others => '0');
  signal rema    : std_logic_vector (N-1 downto 0) := (others => '0');
  signal ready   : std_logic;
  
begin


  -- clock generation
  sysclk <= not sysclk after sys_clk_period/2;



  divider_1 : entity work.divider
    generic map (
      SIGN => SIGN,
      N    => N,
      D    => D)
    port map (
      sysclk  => sysclk,
      n_reset => n_reset,
      start   => start,
      num     => num,
      den     => den,
      quo     => quo,
      rema    => rema,
      ready   => ready);



  
  WaveGen_Proc : process
  begin
    wait until n_reset = '1';
    start <= '0';
    num   <= std_logic_vector(to_signed(-20, N));
    den   <= std_logic_vector(to_signed(-6, D));
    wait for 20 ns;
    start <= '1';
    wait for 20 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    start <= '0';
    num   <= std_logic_vector(to_signed(20, N));
    den   <= std_logic_vector(to_signed(-6, D));
    wait for 20 ns;
    start <= '1';
    wait for 20 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    start <= '0';
    num   <= std_logic_vector(to_signed(-20, N));
    den   <= std_logic_vector(to_signed(6, D));
    wait for 20 ns;
    start <= '1';
    wait for 20 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    start <= '0';
    num   <= std_logic_vector(to_signed(20, N));
    den   <= std_logic_vector(to_signed(5, D));
    wait for 20 ns;
    start <= '1';
    wait for 20 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    start <= '0';
    num   <= "01111111111111111111111111111111";  -- maior numero positivo
    den   <= "11111111111111111111";              -- -1
    wait for 20 ns;
    start <= '1';
    wait for 20 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    start <= '0';
    wait for 1000 ns;
    start <= '0';
    num   <= "11111111111111111111111111111111";  -- -1
    den   <= "11111111111111111111";              -- -1
    wait for 20 ns;
    start <= '1';
    wait for 20 ns;
    num   <= (others => '0');
    den   <= (others => '0');
    start <= '0';
    wait for 1000 ns;

    
    
    
    
  end process;






-------------------------------------------------------------------------------
-- gerador de reset
-------------------------------------------------------------------------------
  reset_generator_1 : entity work.reset_generator
    generic map (
      MAX => 100)
    port map (
      clk     => sysclk,
      n_reset => n_reset
      );


end generic_tb_rtl;

-------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------
-- Testbench Clock Generation
-----------------------------------------------------------------------------------------------
--clk_gen : process
--begin
--   loop
--       clk<='0' ,
--           '1'  after HALF_CYCLE;
--       wait for HALF_CYCLE*2;
--   end loop;
--end process;


-----------------------------------------------------------------------------------------------
-- Output text file
-----------------------------------------------------------------------------------------------
--testbench_o : process(clk) 
--file sin_file                 : text open write_mode is "fsin_o_vhdl_nco_altera.txt";
--variable ls                   : line;
--variable sin_int      : integer ;

--  begin
--    if rising_edge(clk) then
--      if(reset_n='1' and out_valid='1') then
--        sin_int := conv_integer(sin_val);
--        write(ls,sin_int);
--        writeline(sin_file,ls);
--     end if;          
--      end if;         
--end process testbench_o;


configuration generic_tb_rms_tb_rtl_cfg of generic_tb is
  for generic_tb_rtl
  end for;
end generic_tb_rms_tb_rtl_cfg;
