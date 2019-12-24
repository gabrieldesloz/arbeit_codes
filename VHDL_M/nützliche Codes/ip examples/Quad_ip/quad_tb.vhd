-- QUAD_TB.vhd
-- ----------------------------------------
--   Self testing Test Bench for QUAD
-- ----------------------------------------
-- (c) 2009 ALSE - Bertrand Cuzeau
-- See Application Note on our Website

  use STD.TEXTIO.all;
Library IEEE;
  use IEEE.std_logic_TEXTIO.all;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

Entity QUAD_TB is end;

Architecture TEST of QUAD_TB is

  constant Fclock : positive := 10E6; -- 10 MHz
  constant Period : time := 1 sec / Fclock;
  signal Done : boolean;
  signal Rst  : std_logic;  -- Asynchronous Reset
  signal Clk  : std_logic :='0';  -- System Clock
  signal A,B  : std_logic;  -- Quadrature inputs (resynch'ed internally)
  signal Cnt  : std_logic_vector(7 downto 0); -- (un)signed 8 bits position !
  signal Dir  : std_logic;  -- Clockwise information (of last step)

Begin -- Architecture

Rst <= '1', '0' after Period;
Clk <= '0' when Done else not Clk after Period / 2;

UUT: Entity work.QUAD port map (
     Rst => Rst, Clk => Clk, A => A, B => B, Cnt => Cnt, Dir => Dir  );

-- -- Simple process for A & B
-- process begin
--   A <= '0'; B <= '0'; wait for 20 * Period; -- wait & make sure BootDly has expired
--   B <= '1'; wait for 10 * Period;
--   A <= '1'; wait for 10 * Period;
--   B <= '0'; wait for 10 * Period;
--   A <= '0'; wait for 10 * Period;
--   A <= '1'; wait for 10 * Period;
--   B <= '1'; wait for 10 * Period;
--   A <= '0'; wait for 10 * Period;
--   B <= '0'; wait for 10 * Period;
--   Done <= true;
--   wait;
-- end process;

Process -- Encoder Model + Self-Testing Stimuli
  type Phase_t is array (0 to 3) of std_logic_vector(0 to 1);
  constant Phase_Table : Phase_t := ("00", "10", "11", "01");
  variable Phase : integer := 0;
  variable L : line;
  procedure Turn (N : integer) is
    variable J : integer := N;
  begin
    while J /= 0 loop
      if J < 0 then
        J := J+1;
        Phase := Phase - 1;
      else
        J := J-1;
        Phase := Phase + 1;
      end if;
      (A,B) <= Phase_Table(Phase mod 4);
      wait for 20 * Period;
      assert signed(Cnt)=Phase
        report "Cnt error, expected = "&integer'image (Phase)
        severity Error;
      assert (N<0 and Dir='0') or (N>0 and Dir='1') or N=0
        report "Error in Dir !"
        severity Error;
    end loop;
  end procedure Turn;
Begin -- process
  A <= '0'; B <= '0';
  wait for 20 * Period; -- wait & make sure BootDly has expired
  write(L,now);
  write (L, Ht&"Incrementing now Phase 4 times");
  writeline (output,L);
  Turn(4);
  write(L,now);
  write (L, HT&"Decrementing now Phase 8 times");
  writeline (output,L);
  Turn(-8);
  A <= '1'; B <= '1';
  write(L,now);
  write (L, HT&"Impossible phase skip"&HT);
  writeline (output,L);
  wait for 20 * Period;
  A <= '0'; B <= '0';
  write(L,now);
  write (L, HT&"Impossible phase skip"&HT);
  writeline (output,L);
  wait for 20 * Period;
  Turn(1);
  Turn(-1);
  write (L, "End of Simulation"&HT);
  writeline (output,L);
  Done <= true;
  wait;
end process;

End Architecture TEST;
