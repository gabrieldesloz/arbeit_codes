
-- Adaptado do Livro Pong Chu - "FPGA Prototyping by VHDL Examples"
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity db_fsm is

  generic(
    MAX : natural := 100
    )
    port(
      clk     : in  std_logic;
      n_reset : in  std_logic;
      sw      : in  std_logic;
      db      : out std_logic
      );
end db_fsm;

architecture arch of db_fsm is

  signal q_reg, q_next : natural range 0 to MAX-1;
  signal m_tick        : std_logic;

  type eg_state_type is (zero, wait1_1, wait1_2, wait1_3, one, wait0_1, wait0_2, wait0_3);
  signal state_reg, state_next             : eg_state_type;
  attribute ENUM_ENCODING of eg_state_type : type is "0000 0001 0010 0011 0100 0101 0110 0111";

begin

  --===================================
  -- Register
  --=================================== 
  process(clk)
  begin
    if (n_reset = '0') then
      q_reg     <= (others => '0');
      state_reg <= zero;
    elsif rising_edge(clk) then
      state_reg <= state_next;
      q_reg     <= q_next;
    end if;
  end process;


  --===================================
  -- counter
  --===================================
  -- next-state logic
  q_next <= 0   when (q_reg = MAX-1) else q_reg + 1;
  --output tick
  m_tick <= '1' when (q_reg = 0)     else '0';



  --===================================
  -- FSM
  --===================================
  process(state_reg, sw, m_tick)
  begin
    state_next <= state_reg;
    db         <= '0';
    case state_reg is
      when zero =>
        if sw = '1' then
          state_next <= wait1_1;
        end if;
      when wait1_1 =>
        if sw = '0' then
          state_next <= zero;
        else
          if m_tick = '1' then
            state_next <= wait1_2;
          end if;
        end if;
      when wait1_2 =>
        if sw = '0' then
          state_next <= zero;
        else
          if m_tick = '1' then
            state_next <= wait1_3;
          end if;
        end if;
      when wait1_3 =>
        if sw = '0' then
          state_next <= zero;
        else
          if m_tick = '1' then
            state_next <= one;
          end if;
        end if;
      when one =>
        db <= '1';
        if sw = '0' then
          state_next <= wait0_1;
        end if;
      when wait0_1 =>
        db <= '1';
        if sw = '1' then
          state_next <= one;
        else
          if m_tick = '1' then
            state_next <= wait0_2;
          end if;
        end if;
      when wait0_2 =>
        db <= '1';
        if sw = '1' then
          state_next <= one;
        else
          if m_tick = '1' then
            state_next <= wait0_3;
          end if;
        end if;
      when wait0_3 =>
        db <= '1';
        if sw = '1' then
          state_next <= one;
        else
          if m_tick = '1' then
            state_next <= zero;
          end if;
        end if;
    end case;
  end process;
end arch;
