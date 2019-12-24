library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.rl131_constants.all;


entity shifter_altera is
  port
    (
      n_reset  : in  std_logic;
      clock    : in  std_logic;
      data     : in  std_logic_vector (N_BITS_NCO-1 downto 0);
      distance : in  std_logic_vector (5 downto 0);
      result   : out std_logic_vector (N_BITS_NCO-1 downto 0)
      );
end shifter_altera;

architecture SYN of shifter_altera is

  signal sub_wire0   : std_logic_vector (N_BITS_NCO-1 downto 0);
  signal sub_wire1   : std_logic;
  signal n_reset_int : std_logic;


  component lpm_clshift
    generic (
      lpm_pipeline  : natural;
      lpm_shifttype : string;
      lpm_type      : string;
      lpm_width     : natural;
      lpm_widthdist : natural
      );
    port (
      aclr      : in  std_logic;
      clock     : in  std_logic;
      data      : in  std_logic_vector (N_BITS_NCO-1 downto 0);
      direction : in  std_logic;
      distance  : in  std_logic_vector (5 downto 0);
      result    : out std_logic_vector (N_BITS_NCO-1 downto 0)
      );
  end component;

begin

  
  n_reset_int <= not n_reset;
  sub_wire1   <= '0';
  result      <= sub_wire0(N_BITS_NCO-1 downto 0);

  LPM_CLSHIFT_component : LPM_CLSHIFT
    generic map (
      lpm_pipeline  => 1,
      lpm_shifttype => "ARITHMETIC",
      lpm_type      => "LPM_CLSHIFT",
      lpm_width     => 36,
      lpm_widthdist => 6
      )
    port map (
      aclr      => n_reset_int,
      clock     => clock,
      data      => data,
      direction => sub_wire1,
      distance  => distance,
      result    => sub_wire0
      );

end SYN;
