library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity packet_detect is
  
  port (

    clk	  : in std_logic;
    reset : in std_logic;

    EOP_i : in std_logic;
    SOP_i : in std_logic;

    START_i	: in  std_logic;
    PACKET_OK_o : out std_logic

    );

end entity packet_detect;



architecture ARQ of packet_detect is

  type	 FSM_TYPE is (ST_SOP, ST_EOP);
  signal state_reg, state_next	       : FSM_TYPE;
  signal PACKET_OK_reg, PACKET_OK_next : std_logic;
  signal sop_reg1, sop_reg2	       : std_logic;
  signal eop_reg1, eop_reg2	       : std_logic;
  signal start_reg1, start_reg2	       : std_logic;

  signal start_reg2_pulse, not_reset : std_logic;
  

begin

--registers
  process(reset, clk)
  begin

    if reset = '1' then

      state_reg	    <= ST_SOP;
      PACKET_OK_reg <= '0';

      start_reg1 <= '0';
      start_reg2 <= '0';

      sop_reg1 <= '0';
      sop_reg2 <= '0';

      eop_reg1 <= '0';
      eop_reg2 <= '0';


    elsif falling_edge(clk) then

      state_reg	    <= state_next;
      PACKET_OK_reg <= PACKET_OK_next;

      start_reg1 <= START_i;
      start_reg2 <= start_reg1;
      -- external signals pass through 2 flip flops for synchronization
      sop_reg1 <= SOP_i;
      sop_reg2 <= sop_reg1;

      eop_reg1 <= EOP_i;
      eop_reg2 <= eop_reg1;

    end if;

  end process;

  PACKET_OK_o <= PACKET_OK_reg;

  -- packet detection state machine
  process(eop_reg2, sop_reg2, start_reg2_pulse, state_reg)
  begin

    state_next	   <= state_reg;
    PACKET_OK_next <= '0';

  
    case state_reg is

    when ST_SOP =>
	 -- wait for the start of the frame
	if sop_reg2 = '1' then
	  state_next <= ST_EOP;
	end if;

      when ST_EOP =>
	
	-- wait until the end of the frame
	if eop_reg2 = '1' then
	  state_next	 <= ST_SOP;
	  PACKET_OK_next <= '1';
	end if;

    end case;

    -- priority condition
    -- initiates frame detection when start signal (edge pulse) = '1'
    if start_reg2_pulse = '1' then
      state_next <= ST_SOP;
    end if;


  end process;


  -- pulse detector for the start signal
  pos_edge_moore_1 : entity work.pos_edge_moore
    port map (
      sysclk  => clk,		-- [std_logic]
      reset_n => not_reset,		-- [std_logic]
      level_i => start_reg2,		-- [std_logic]
      tick_o  => start_reg2_pulse);	-- [std_logic]

  not_reset <= reset;
  
end ARQ;
