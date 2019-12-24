---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

-- serial communication output
comm_uart : block is
  constant N_WORDS : natural := 11;     ---number of bytes sent (words)

  signal s_sys_clock    : std_logic;
  signal s_uart_clk     : std_logic;
  signal s_TX           : std_logic;
  signal reset          : std_logic;
  signal DATA           : std_logic_vector((N_WORDS*8)-1 downto 0);
  signal s_send, s_SENT : std_logic;

  constant UU  : std_logic_vector(7 downto 0) := "01011111";  -- "_"
  constant DP  : std_logic_vector(7 downto 0) := "00111010";  -- ":"
  constant LF  : std_logic_vector(7 downto 0) := "00001010";  -- LINE FEED
  constant CR  : std_logic_vector(7 downto 0) := "00001101";  -- CARRIAGE RETURN
  constant SP  : std_logic_vector(7 downto 0) := "00100000";  -- SPACE
  constant NUL : std_logic_vector(7 downto 0) := "00000000";
  constant A   : std_logic_vector(7 downto 0) := "01000001";
  constant B   : std_logic_vector(7 downto 0) := "01000010";
  constant C   : std_logic_vector(7 downto 0) := "01000011";
  constant D   : std_logic_vector(7 downto 0) := "01000100";
  constant E   : std_logic_vector(7 downto 0) := "01000101";
  constant F   : std_logic_vector(7 downto 0) := "01000110";

  function SLV_TO_ASCII_HEX (
    SLV : in std_logic_vector
    ) return std_logic_vector is

    variable i                 : integer                      := 1;
    variable STR               : std_logic_vector((SLV'length*2)-1 downto 0);
    variable nibble            : std_logic_vector(3 downto 0) := "0000";
    variable full_nibble_count : natural                      := 0;

  begin
    full_nibble_count := SLV'length/4;
    for i in 1 to full_nibble_count loop
      nibble := SLV(((4*i) - 1) downto ((4*i) - 4));
      if (nibble = "0000") then
        STR((8*i)-1 downto (8*(i-1))) := "00110000";  -- 0
      elsif (nibble = "0001") then
        STR((8*i)-1 downto (8*(i-1))) := "00110001";  -- 1
      elsif (nibble = "0010") then
        STR((8*i)-1 downto (8*(i-1))) := "00110010";  -- 2
      elsif (nibble = "0011") then
        STR((8*i)-1 downto (8*(i-1))) := "00110011";  -- 3
      elsif (nibble = "0100") then
        STR((8*i)-1 downto (8*(i-1))) := "00110100";  -- 4
      elsif (nibble = "0101") then
        STR((8*i)-1 downto (8*(i-1))) := "00110101";  -- 5
      elsif (nibble = "0110") then
        STR((8*i)-1 downto (8*(i-1))) := "00110110";  -- 6
      elsif (nibble = "0111") then
        STR((8*i)-1 downto (8*(i-1))) := "00110111";  -- 7
      elsif (nibble = "1000") then
        STR((8*i)-1 downto (8*(i-1))) := "00111000";  -- 8
      elsif (nibble = "1001") then
        STR((8*i)-1 downto (8*(i-1))) := "00111001";  -- 9
      elsif (nibble = "1010") then
        STR((8*i)-1 downto (8*(i-1))) := "01000001";  -- A
      elsif (nibble = "1011") then
        STR((8*i)-1 downto (8*(i-1))) := "01000010";  -- B
      elsif (nibble = "1100") then
        STR((8*i)-1 downto (8*(i-1))) := "01000011";  -- C
      elsif (nibble = "1101") then
        STR((8*i)-1 downto (8*(i-1))) := "01000100";  -- D
      elsif (nibble = "1110") then
        STR((8*i)-1 downto (8*(i-1))) := "01000101";  -- E
      elsif (nibble = "1111") then
        STR((8*i)-1 downto (8*(i-1))) := "01000110";  -- F
      end if;
    end loop;
    return STR;
  end SLV_TO_ASCII_HEX;

begin

  --INPUT
  s_sys_clock <= s_clk_60MHz;
  reset       <= s_reset;
  s_send      <= '1';

  --OUTPUT
  TX_out <= s_TX;
  DATA   <= SLV_TO_ASCII_HEX(s_R_TEST_reg_from_master_reg) & SP & LF & CR;

  tx_controller : entity work.serial_tx_controller
    generic map(
      N_WORDS      => N_WORDS,
      DATA_i_WIDTH => N_WORDS*8)
    port map (
      START_i  => s_send,
      CLK_i    => s_sys_clock,
      CLK_EN_i => s_uart_clk, s
      RST_i    => reset,
      DATA_i   => DATA,
      TX_o     => s_TX,
      SENT_o   => s_SENT
      );

  clk_division : entity work.clock_div
    generic map(
      divider => 25000                  -- freq s_sys_clock/25000  = 2400
      )

    port map (
      clock => s_sys_clock,
      q     => open,
      carry => s_uart_clk,
      ena   => '1',
      reset => reset
      );

end block;
