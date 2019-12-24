library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_ovf is

  generic (
    N : natural := 32                   -- number of bits  
    );                

  port (
    sysclk       : in  std_logic;
    reset_n      : in  std_logic;
    start_calc_i : in  std_logic;
    val_1_i      : in  std_logic_vector(N-1 downto 0);
    val_2_i      : in  std_logic_vector(N-1 downto 0);
    val_3_i      : in  std_logic_vector(N-1 downto 0);
    val_o        : out std_logic_vector(N-1 downto 0);
    done_o       : out std_logic;
    ovf_o        : out std_logic
    );


end adder_ovf;

architecture arc_rtl of adder_ovf is

  type STATE_FSM_TYPE is (IDLE, SUM_1, SUM_2, CHECK);
  signal state_next, state_reg : STATE_FSM_TYPE;

  attribute syn_encoding                   : string;
  attribute syn_encoding of STATE_FSM_TYPE : type is "safe";
  signal val_1_reg, val_2_reg, val_3_reg   : std_logic_vector(N-1 downto 0);
  signal sum_tmp_next, sum_tmp_reg         : signed(N+1 downto 0);
  signal done_o_reg, done_o_next           : std_logic;
  signal ovf_sign_reg, ovf_sign_next       : std_logic;

  constant POS_OVF : std_logic_vector(N-1 downto 0)  := (N-1 => '0', others =>'1');
  constant NEG_OVF : std_logic_vector(N-1 downto 0)  := (N-1 => '1', others =>'0');  

  
begin

  process (sysclk, reset_n)
  begin
    if reset_n = '0' then
      val_1_reg    <= (others => '0');
      val_2_reg    <= (others => '0');
      val_3_reg    <= (others => '0');
      sum_tmp_reg  <= (others => '0');
      done_o_reg   <= '0';
      ovf_sign_reg <= '0';
      state_reg    <= IDLE;
    elsif rising_edge(sysclk) then      -- rising clock edge
      ovf_sign_reg <= ovf_sign_next;
      state_reg    <= state_next;
      val_1_reg    <= val_1_i;
      val_2_reg    <= val_2_i;
      val_3_reg    <= val_3_i;
      sum_tmp_reg  <= sum_tmp_next;
      done_o_reg   <= done_o_next;
    end if;

  end process;

  process (start_calc_i, state_reg, sum_tmp_reg, val_1_reg, val_2_reg,
           val_3_reg)
  begin  -- process

    -- default

    ovf_sign_next <= '0';
    done_o_next   <= '0';
    sum_tmp_next  <= sum_tmp_reg;
    state_next    <= state_reg;

    case state_reg is

      when IDLE =>
        if (start_calc_i = '1') then
          state_next <= SUM_1;
        end if;
        
      when SUM_1 =>
        sum_tmp_next <= resize(signed(val_1_reg), N+2) + resize(signed(val_2_reg), N+2);
        state_next   <= SUM_2;

      when SUM_2 =>
        sum_tmp_next <= sum_tmp_reg + resize(signed(val_3_reg), N+2);
        state_next   <= CHECK;

      when CHECK =>
        
        done_o_next <= '1';
        state_next  <= IDLE;
        
        -- overflow verification
        if ((sum_tmp_reg < signed(NEG_OVF)) or (sum_tmp_reg > signed(POS_OVF))) then
          ovf_sign_next <= '1';          
        end if;
        
    end case;

  end process;

  val_o  <= std_logic_vector(resize(sum_tmp_reg, N));
  done_o <= done_o_reg;
  ovf_o  <= ovf_sign_reg;

end arc_rtl;
