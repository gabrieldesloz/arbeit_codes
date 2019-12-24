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
  -- synchronizer signals
  signal EATX_i_reg2, EATX_i_reg: std_logic ; -- phisical input
  signal EBRX_o_int_reg, EBRX_o_int_reg2: std_logic;

  type	 FSM_COUNT_TYPE is (ST_START_COUNT, ST_COUNT);
    -- counter reg -- max count 300_000 - 5 ms
  signal count_next, count_reg: std_logic_vector(18 downto 0); 
  signal fsm_counter_state_reg, fsm_counter_state_next: FSM_COUNT_TYPE;
  
  signal reset_fsm_reg, reset_fsm_next: std_logic;
  signal EBRX_o_int: std_logic;
  

begin


  registers0: process (CLK_60MHZ_i, reset)
  begin
    if reset = '1' then
	  fsm_state_reg <= ST_UC; 
	  fsm_counter_state_reg	<=  ST_START_COUNT;
	  EATX_i_reg <= '0';
	  EATX_i_reg2 <= '0';
	  EBRX_o_int_reg <= '0';		
	  EBRX_o_int_reg2 <= '0';
	  reset_fsm_reg <= '0';
	  count_reg <= (others => '0');
    elsif falling_edge(CLK_60MHZ_i) then     
		fsm_state_reg <= fsm_state_next; 
		fsm_counter_state_reg <= fsm_counter_state_next;	
		EATX_i_reg <= EATX_i;
		EATX_i_reg2 <= EATX_i_reg;	
		EBRX_o_int_reg	<=	EBRX_o_int;		
		EBRX_o_int_reg2 <= EBRX_o_int_reg;
		reset_fsm_reg <= reset_fsm_next;
		count_reg <= count_next;
    end if;
  end process registers0;

  
  
  fsm: process(fsm_state_reg, mux_i,reset_fsm_reg)
  begin
    fsm_state_next <= fsm_state_reg;
    case fsm_state_reg is      
	  when ST_UC =>	
		if mux_i = '1' then
		  fsm_state_next <= ST_SERIAL;
		end if;
      when ST_SERIAL =>	  
		  if reset_fsm_reg = '1' then 
			fsm_state_next <=  ST_UC;
		  end if;		
      when others =>
	fsm_state_next <= ST_UC;
    end case;
  end process fsm;

  
  
  counter_fsm: process(EATX_i_reg2, count_reg, fsm_counter_state_reg, mux_i, EBRX_o_int_reg2)  
  begin    
   reset_fsm_next   <= '0';
   count_next <= count_reg;
   fsm_counter_state_next <= fsm_counter_state_reg;   
   case fsm_counter_state_reg is		  
	  when ST_START_COUNT => 			 
		 count_next <= (OTHERS => '0'); 		
		if mux_i = '1' then
			  fsm_counter_state_next <= ST_COUNT;
		end if;
	  when ST_COUNT => 
		count_next <= count_reg + 1;
		if (count_reg = 300_000) then	
			reset_fsm_next <= '1';	
			fsm_counter_state_next <= ST_START_COUNT;
		end if;
		-- there is data coming from ejector or being transmited
		if  (EATX_i_reg2 = '1' ) or (EBRX_o_int_reg2 = '1' )	then 
			 count_next <= (others => '0'); -- reset the counter 
		end if;
		when others => 
			fsm_counter_state_next <= ST_START_COUNT;
	end case;
end process counter_fsm;		
		
  
  
  

  EARX_o <= SCK_SERIAL_i when (fsm_state_reg = ST_SERIAL) else ENABLE_EJECTORS_i;
  
  -- output from ejector --> synchronizer
  EBRX_o 	     <= EBRX_o_int;  
  EBRX_o_int 	 <= EJ_DATA_TX_i when (fsm_state_reg = ST_SERIAL) else ENABLE_EJECTORS_i;

  
  EJ_DATA_RX_o  <= EATX_i; -- input - data coming from ejector
  EATXD_to_uC_o <= EATX_i;
  EACK_to_uC_o  <= EACK_i;
  EBCK_to_uC_o  <= EBCK_i;
  EBTXD_to_uC_o <= EBTXD_i;


end architecture ARQ;
