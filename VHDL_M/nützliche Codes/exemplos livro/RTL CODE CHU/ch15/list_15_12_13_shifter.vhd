--=============================
-- Listing 15.12 fixed-size shifter
--=============================
library ieee;
use ieee.std_logic_1164.all;
use work.util_pkg.all;
entity fixed_shifter is
   generic(
      WIDTH: natural;
      S_AMT: natural;
      S_MODE: natural
   );
   port(
      s_in: in std_logic_vector(WIDTH-1 downto 0);
      shft: in std_logic;
      s_out: out std_logic_vector(WIDTH-1 downto 0)
   );
end fixed_shifter;

architecture para_arch of fixed_shifter is
   constant L_SHIFT: natural :=0;
   constant R_SHIFT: natural :=1;
   constant L_ROTAT: natural :=2;
   constant R_ROTAT: natural :=3;
   signal sh_tmp, zero: std_logic_vector(WIDTH-1 downto 0);
begin
   zero <= (others=>'0');
   -- shift left
   l_sh_gen:
   if S_MODE=L_SHIFT generate
      sh_tmp <= s_in(WIDTH-S_AMT-1 downto 0) &
                zero(WIDTH-1 downto WIDTH-S_AMT);
   end generate;
   -- rotate left
   l_rt_gen:
   if S_MODE=L_ROTAT generate
      sh_tmp <= s_in(WIDTH-S_AMT-1 downto 0) &
                s_in(WIDTH-1 downto WIDTH-S_AMT);
   end generate;
   -- shift right
   r_sh_gen:
   if S_MODE=R_SHIFT generate
      sh_tmp <= zero(S_AMT-1 downto 0) &
                s_in(WIDTH-1 downto S_AMT);
   end generate;
   -- rotate right
   r_rt_gen:
   if S_MODE=R_ROTAT generate
      sh_tmp <= s_in(S_AMT-1 downto 0) &
                s_in(WIDTH-1 downto S_AMT);
   end generate;
   -- 2-to-1 multiplexer
   s_out <= sh_tmp when shft='1' else
            s_in;
end para_arch;


--=============================
-- Listing 15.13 barrel shifter
--=============================
library ieee;
use ieee.std_logic_1164.all;
use work.util_pkg.all;
entity barrel_shifter is
   generic(
      WIDTH: natural:=8;
      S_MODE: natural:=0
   );
   port(
      a: in std_logic_vector(WIDTH-1 downto 0);
      amt: in std_logic_vector(log2c(WIDTH)-1 downto 0);
      y: out std_logic_vector(WIDTH-1 downto 0)
   );
end barrel_shifter;

architecture para_arch of barrel_shifter is
   constant STAGE: natural:= log2c(WIDTH);
   type std_aoa_type is array(STAGE downto 0) of
      std_logic_vector(WIDTH-1 downto 0);
   signal p: std_aoa_type;
   component fixed_shifter is
      generic(
         WIDTH: natural;
         S_AMT: natural;
         S_MODE: natural
      );
      port(
         s_in: in std_logic_vector(WIDTH-1 downto 0);
         shft: in std_logic;
         s_out: out std_logic_vector(WIDTH-1 downto 0)
      );
   end component;
begin
   p(0) <= a;
   stage_gen:
   for s in 0 to (STAGE-1) generate
      shift_slice: fixed_shifter
         generic map(WIDTH=>WIDTH, S_MODE=>S_MODE,
                     S_AMT=>2**s)
         port map(s_in=>p(s), s_out=>p(s+1), shft=>amt(s));
   end generate;
   y <= p(STAGE);
end para_arch;