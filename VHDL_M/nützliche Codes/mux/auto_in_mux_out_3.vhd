library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;


entity auto_in_mux_out is
  generic (
    A_PERIOD  : natural   := 10;
    B_PERIOD  : natural   := 20;
    DEF_EMU_INIT_STATE_ON : std_logic := '1'

    );

  port(
    ext_edge       : in  std_logic;
    clock, n_reset : in  std_logic;
    a_i            : in  std_logic;
    b_i            : in  std_logic;
    c_o            : out std_logic

    );
end auto_in_mux_out;


architecture auto_in_mux_out_arq of auto_in_mux_out is

  type FSMD_STATE_TYPE is (IN_A, IN_B);
  signal state_reg, state_next : fsmd_state_type;

  signal c1_reg, c1_next : unsigned(31 downto 0);
  signal c2_reg, c2_next : unsigned(31 downto 0);

   
  
begin
  
  process(clock, n_reset)
  begin
    if (n_reset = '0') then
      if DEF_EMU_INIT_STATE_ON = '1' then
        state_reg <= IN_A;
      else
        state_reg <= IN_B;
      end if;

      c1_reg <= (others => '0');
      c2_reg <= (others => '0');
    elsif (clock'event and clock = '1') then
      state_reg <= state_next;

      c1_reg <= c1_next;
      c2_reg <= c2_next;
    end if;
  end process;


  process(c1_reg, c2_reg, ext_edge, a_i, b_i, state_reg)
  begin

    c1_next    <= c1_reg;
    c2_next    <= c2_reg;
    state_next <= state_reg;

    case state_reg is

      when IN_A =>
        c_o <= a_i;
        if (ext_edge = '1') then
          c1_next <= c1_reg + 1;
        elsif c1_reg = A_PERIOD then
          state_next <= IN_B;
          c2_next    <= (others => '0');
        end if;

      when IN_B =>
        c_o <= b_i;
        if ext_edge = '1' then
          c2_next <= c2_reg + 1;
        elsif (c2_reg = B_PERIOD) then
          state_next <= IN_A;
          c1_next    <= (others => '0');
        end if;
    end case;
  end process;


end auto_in_mux_out_arq;
