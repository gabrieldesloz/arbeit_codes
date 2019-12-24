library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;


entity auto_in_mux_out is
  generic (
    A_PERIOD              : natural   := 10;
    B_PERIOD              : natural   := 20;
	 C_PERIOD              : natural   := 10;
    D_PERIOD              : natural   := 20;
	 E_PERIOD              : natural   := 10;
    DEF_EMU_INIT_STATE_ON : integer   := 1;
    SIZE                  : natural   := 32

    );

  port(
    ext_edge       : in  std_logic;
    clock, n_reset : in  std_logic;
    a_i            : in  std_logic_vector(SIZE-1 downto 0);
    b_i            : in  std_logic_vector(SIZE-1 downto 0);
    c_i            : in  std_logic_vector(SIZE-1 downto 0);
    d_i            : in  std_logic_vector(SIZE-1 downto 0);
    e_i            : in  std_logic_vector(SIZE-1 downto 0);
    f_o            : out std_logic_vector(SIZE-1 downto 0)
    );
end auto_in_mux_out;


architecture auto_in_mux_out_arq of auto_in_mux_out is

  type FSMD_STATE_TYPE is (IN_A, IN_B, IN_C, IN_D, IN_E);
  signal state_reg, state_next : fsmd_state_type;
  signal c_reg, c_next : unsigned(31 downto 0);
  
  
  
begin
  
  process(clock, n_reset)
  begin
    if (n_reset = '0') then

      case DEF_EMU_INIT_STATE_ON is
        when 1      => state_reg <= IN_A;
        when 2      => state_reg <= IN_B;
        when 3      => state_reg <= IN_C;
        when 4      => state_reg <= IN_D;
        when 5      => state_reg <= IN_E;
        when others => state_reg <= IN_A;
      end case;
      c_reg <= (others => '0');
      
    elsif (clock'event and clock = '1') then
      state_reg <= state_next;
      c_reg <= c_next;
    end if;
  end process;


  process(a_i, b_i, c_i, c_reg, d_i, e_i, ext_edge, state_reg)
  begin

    c_next    <= c_reg;
    
    state_next <= state_reg;

    case state_reg is

      when IN_A =>
        f_o <= a_i;
        if (ext_edge = '1') then
          c_next <= c_reg + 1;
        elsif c_reg = A_PERIOD-1 then
          state_next <= IN_B;
          c_next    <= (others => '0');
        end if;

      when IN_B =>
        f_o <= b_i;
        if ext_edge = '1' then
          c_next <= c_reg + 1;
        elsif (c_reg = B_PERIOD) then
          state_next <= IN_C;
          c_next    <= (others => '0');
        end if;


      when IN_C =>
        f_o <= c_i;
        if ext_edge = '1' then
          c_next <= c_reg + 1;
        elsif (c_reg = C_PERIOD) then
          state_next <= IN_D;
          c_next    <= (others => '0');
        end if;


      when IN_D =>
        f_o <= d_i;
        
        if ext_edge = '1' then
          c_next <= c_reg + 1;
        elsif (c_reg = D_PERIOD) then
          state_next <= IN_E;
          c_next    <= (others => '0');
        end if;


        when IN_E =>
        f_o <= e_i;        
        if ext_edge = '1' then
          c_next <= c_reg + 1;
        elsif (c_reg = E_PERIOD) then
          state_next <= IN_A;
          c_next    <= (others => '0');
        end if;      


      
    end case;
  end process;


end auto_in_mux_out_arq;
