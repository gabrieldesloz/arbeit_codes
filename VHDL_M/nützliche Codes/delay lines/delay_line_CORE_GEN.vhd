library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- delay_ctrl_int: subtração: atrasa-se o sinal, soma, adianta-se o sinal
-------------------------------------------------------------------------------

library work;
use work.rl131_constants.all;

library lpm;
use lpm.lpm_components.all;


entity delay_line_CORE_GEN is
  port
    (

      clock      : in  std_logic;
      n_reset    : in  std_logic;
      serial_in  : in  std_logic;
      serial_out : out std_logic;
      delay_ctrl : in  std_logic_vector(DL_BITS-1 downto 0)

      );

end delay_line_CORE_GEN;

architecture delay_line_CORE_GEN_RTL of delay_line_CORE_GEN is
  
  signal delay_ctrl_int : natural range 0 to 2**DL_BITS-1;

  signal q_int          : std_logic_vector((2**DL_BITS)-1 downto 0);
  signal reset_int      : std_logic;
  signal serial_out_int : std_logic_vector(0 to 31);


  component lpm_shiftreg
    generic (
      lpm_direction : string;
      lpm_type      : string;
      lpm_width     : natural
      );
    port (
      aclr     : in  std_logic;
      clock    : in  std_logic;
      q        : out std_logic_vector (255 downto 0);
      shiftin  : in  std_logic;
      shiftout : out std_logic
      );
  end component;
  
begin

-------------------------------------------------------------------------------
-- Register
-------------------------------------------------------------------------------


  reset_int <= not n_reset;

  
  delay_ctrl_int <= to_integer(unsigned(delay_ctrl));

  gen : for i in 0 to 31 generate
    
    left : if i = 0 generate
      
      LPM_SHIFTREG_component : LPM_SHIFTREG
        generic map (
          lpm_direction => "LEFT",
          lpm_type      => "LPM_SHIFTREG",
          lpm_width     => 256
          )
        port map (
          aclr    => reset_int,
          clock   => clock,
          shiftin => serial_in,
          q       => q_int(255*(i+1) downto 256*i),

          shiftout => serial_out_int(i)
          );

    end generate left;


    right : if i > 0 and i <= 31 generate
      
      LPM_SHIFTREG_component : LPM_SHIFTREG
        generic map (
          lpm_direction => "LEFT",
          lpm_type      => "LPM_SHIFTREG",
          lpm_width     => 256
          )
        port map (
          aclr     => reset_int,
          clock    => clock,
          shiftin  => serial_out_int(i-1),
          q        => q_int((256*(i+1))-1 downto 256*i),
          shiftout => serial_out_int(i)
          );

    end generate right;

    
  end generate gen;


  serial_out <= q_int(delay_ctrl_int);

  

end delay_line_CORE_GEN_RTL;
