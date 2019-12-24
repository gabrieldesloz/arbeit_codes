library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity mux is

  port(


    CLK_60MHZ_i : in std_logic;
    reset	: in std_logic;

    EARX_o	      : out std_logic;
    EBRX_o	      : out std_logic;
    EJ_DATA_RX_o      : out std_logic;
    EATXD_to_uC_o     : out std_logic;
    EACK_to_uC_o      : out std_logic;
    EBCK_to_uC_o      : out std_logic;
    EBTXD_to_uC_o     : out std_logic;
    SCK_SERIAL_i      : in  std_logic;
    EJ_DATA_TX_i      : in  std_logic;
    ENABLE_EJECTORS_i : in  std_logic;
    EATX_i	      : in  std_logic;
    EACK_i	      : in  std_logic;
    EBCK_i	      : in  std_logic;
    EBTX_i	      : in  std_logic;
    mux_i	      : in  std_logic;

    EOP_i   : in  std_logic;
    SOP_i   : in  std_logic;
    debug_o : out std_logic


    );


end entity mux;

architecture ARQ of mux is

  signal EARX_o_reg, EARX_o_next	       : std_logic;
  signal EBRX_o_reg, EBRX_o_next	       : std_logic;
  signal EJ_DATA_RX_o_reg, EJ_DATA_RX_o_next   : std_logic;
  signal EATXD_to_uC_o_reg, EATXD_to_uC_o_next : std_logic;
  signal EACK_to_uC_o_reg, EACK_to_uC_o_next   : std_logic;
  signal EBCK_to_uC_o_reg, EBCK_to_uC_o_next   : std_logic;
  signal EBTXD_to_uC_o_reg, EBTXD_to_uC_o_next : std_logic;


  type	 FSM_TYPE is (ST_UC, ST_SERIAL);
  signal fsm_state_next, fsm_state_reg : FSM_TYPE;

  signal mux_i_reg_1, mux_i_reg_2 : std_logic;
  signal PACKET_SENT_reg	  : std_logic;
  signal debug_o_pd		  : std_logic;

begin

  debug_o <= debug_o_pd;

  registers0 : process (CLK_60MHZ_i, reset)
  begin
    if reset = '1' then
      fsm_state_reg <= ST_UC;
      mux_i_reg_1   <= '0';
      mux_i_reg_2   <= '0';
    elsif falling_edge(CLK_60MHZ_i) then
      fsm_state_reg <= fsm_state_next;
      mux_i_reg_1   <= mux_i;
      mux_i_reg_2   <= mux_i_reg_1;
    end if;
  end process registers0;


  -- "switch" fsm - switch beween serial comm and uC
  fsm : process(PACKET_SENT_reg, fsm_state_reg, mux_i_reg_2)
  begin
    fsm_state_next <= fsm_state_reg;
    case fsm_state_reg is
      when ST_UC =>
	if mux_i_reg_2 = '1' then
	  fsm_state_next <= ST_SERIAL;
	end if;
      when ST_SERIAL =>
	-- para terminar a conexao serial, espera terminar o envio de 1 pacote
	--  - sem checagem de erro (se pacote foi enviado com sucesso ou nao)
	if mux_i_reg_2 = '0' and (PACKET_SENT_reg = '1') then
	  fsm_state_next <= ST_UC;
	end if;
      when others =>
	fsm_state_next <= ST_UC;
    end case;
  end process fsm;


  -- uC controller an enable signal (high). When it ends (zero), this module will
  -- send a signal when one frame is sent
  packet_detect_1 : entity work.packet_detect
    port map (
      clk	  => CLK_60MHZ_i,	-- [std_logic]
      reset	  => reset,		-- [std_logic]
      EOP_i	  => EOP_i,		-- [std_logic]
      SOP_i	  => SOP_i,		-- [std_logic]
      START_i	  => mux_i_reg_2,  	-- [std_logic] -- start when mux = '0'
      PACKET_OK_o => PACKET_SENT_reg,
      debug_o	  => debug_o_pd);	-- [std_logic]

  

  EARX_o <= SCK_SERIAL_i when (fsm_state_reg = ST_SERIAL) else ENABLE_EJECTORS_i;
  EBRX_o <= EJ_DATA_TX_i when (fsm_state_reg = ST_SERIAL) else ENABLE_EJECTORS_i;


  EJ_DATA_RX_o	<= EATX_i;		-- input - data coming from ejector
  EATXD_to_uC_o <= EATX_i;
  EACK_to_uC_o	<= EACK_i;
  EBCK_to_uC_o	<= EBCK_i;
  EBTXD_to_uC_o <= EBTX_i;

  
  

end architecture ARQ;
