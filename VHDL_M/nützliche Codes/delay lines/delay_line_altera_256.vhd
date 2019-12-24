library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;


library lpm;
use lpm.lpm_components.all;


entity delay_line_altera is



  generic(
    DL_SIZE : natural := 256
    )

    port
    (
      clock      : in  std_logic;
      n_reset    : in  std_logic;
      serial_in  : in  std_logic;
      serial_out : out std_logic;
      delay_ctrl : in  std_logic_vector(DL_BITS-1 downto 0)

      );

end delay_line_altera;

architecture delay_line_v2_RTL of delay_line_altera is
  
  signal delay_ctrl_int : natural range 0 to DL_SIZE-1;
  signal q_int          : std_logic_vector(DL_SIZE-1 downto 0);
  signal reset_int      : std_logic;

  component lpm_shiftreg
    generic (
      lpm_direction : string;
      lpm_type      : string;
      lpm_width     : natural
      );
    port (
      aclr    : in  std_logic;
      clock   : in  std_logic;
      q       : out std_logic_vector (DL_SIZE-1 downto 0);
      shiftin : in  std_logic
      );
  end component;
  
begin
  
  delay_ctrl_int <= to_integer(unsigned(delay_ctrl));
  reset_int      <= not n_reset;

  LPM_SHIFTREG_component : LPM_SHIFTREG
    generic map (
      lpm_direction => "LEFT",
      lpm_type      => "LPM_SHIFTREG",
      lpm_width     => DL_SIZE
      )
    port map (
      aclr    => reset_int,
      clock   => clock,
      shiftin => serial_in,
      q       => q_int
      );

  serial_out <= q_int(delay_ctrl_int);


end delay_line_v2_RTL;
