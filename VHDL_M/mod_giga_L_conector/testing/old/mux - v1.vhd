library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity mux is

  port(


    CLK_60MHZ_i : in std_logic;
    SYNC_CLK_i	: in std_logic;
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
    EBTXD_i	      : in  std_logic;
    mux_i	      : in  std_logic


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


begin


  process (CLK_60MHZ_i, reset)
  begin
    if reset = '1' then
	  fsm_state_reg <= ST_UC;
      EARX_o_reg	<= '0';
      EBRX_o_reg	<= '0';
      EJ_DATA_RX_o_reg	<= '0';
      EATXD_to_uC_o_reg <= '0';
      EACK_to_uC_o_reg	<= '0';
      EBCK_to_uC_o_reg	<= '0';
      EBTXD_to_uC_o_reg <= '0';
    elsif falling_edge(CLK_60MHZ_i) then
     
		fsm_state_reg <= fsm_state_next;
		EARX_o_reg	  <= EARX_o_next;
		EBRX_o_reg	  <= EBRX_o_next;
		EJ_DATA_RX_o_reg  <= EJ_DATA_RX_o_next;
		EATXD_to_uC_o_reg <= EATXD_to_uC_o_next;
		EACK_to_uC_o_reg  <= EACK_to_uC_o_next;
		EBCK_to_uC_o_reg  <= EBCK_to_uC_o_next;
		EBTXD_to_uC_o_reg <= EBTXD_to_uC_o_next;
  
    end if;
  end process;



  process(fsm_state_reg, mux_i)
  begin
    fsm_state_next <= fsm_state_reg;

    case fsm_state_reg is
      when ST_UC =>
	
	if mux_i = '1' then
	  fsm_state_next <= ST_SERIAL;
	end if;

      when ST_SERIAL =>


      when others =>
	fsm_state_next <= ST_UC;
    end case;
  end process;


  EARX_o	<= EARX_o_reg;
  EBRX_o	<= EBRX_o_reg;
  EJ_DATA_RX_o	<= EJ_DATA_RX_o_reg;
  EATXD_to_uC_o <= EATXD_to_uC_o_reg;
  EACK_to_uC_o	<= EACK_to_uC_o_reg;
  EBCK_to_uC_o	<= EBCK_to_uC_o_reg;
  EBTXD_to_uC_o <= EBTXD_to_uC_o_reg;

-------------------------------------------------
  EARX_o_next <= SCK_SERIAL_i when (fsm_state_reg = ST_SERIAL) else ENABLE_EJECTORS_i;
  EBRX_o_next <= EJ_DATA_TX_i when (fsm_state_reg = ST_SERIAL) else ENABLE_EJECTORS_i;

  EJ_DATA_RX_o_next  <= EATX_i;
  EATXD_to_uC_o_next <= EATX_i;
  EACK_to_uC_o_next  <= EACK_i;
  EBCK_to_uC_o_next  <= EBCK_i;
  EBTXD_to_uC_o_next <= EBTXD_i;


end architecture ARQ;
