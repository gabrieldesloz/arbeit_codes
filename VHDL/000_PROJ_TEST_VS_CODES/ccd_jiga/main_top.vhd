
-- buffer de entrada e saida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quality is
  
  port (
    sysclk            : in  std_logic;
    reset_n           : in  std_logic
    
end quality;

architecture quality_rtl of quality is

  -- type
  -- attribute
  -- constants
  -- signals
  -- procedures
  -- functions
  -- alias
    
  signal clkaq     : std_logic;
  signal reset     : std_logic;
  signal sincin  : std_logic;
  signal clrsinc : std_logic;
  signal CCD_CLK : std_logic;
  signal CCD_SI  : std_logic;
  signal DIS     : std_logic;
  signal pix     : std_logic_vector (7 downto 0);

  signal s_clk37: std_logic
  
begin  -- quality_rtl

  -- direct compoents instantiations
  -- registers
  -- sequential/parallel assignments
  -- output assignments


s_clk37 <= CLK37_i;
  
  
  

   -- End of DCM_inst instantiation
   BUFG_inst : BUFG
   port map ( O => clk2x,  I => clkfx); -- 3 * 37.5= 112.5MHz
  
  
  

  ccd_ctrl_fsm_1: entity work.ccd_ctrl_fsm
    port map (
      clkaq     => clkaq,
      reset     => reset,
      sincin_i  => '0',
      clrsinc_o => open,
      CCD_CLK_o => CCD_CLK,
      CCD_SI_o  => CCD_SI,
      DIS_o     => DIS_o,
      pix_o     => pix_o);
  
  

  process (sysclk, reset_n)
  begin  
    if reset_n = '0' then


    elsif rising_edge(sysclk) then      -- rising clock edge

    end if;

  end process;

  process ()
  begin  -- process

    -- default
    
    case x is
      when a =>
        
      when others =>
        quality_state_next <= WAIT_READY;
        
    end case;

  end process;




  -- lazy process - exemplo 

   word_sender_block : block is

    -- word constant
    constant test_word : std_logic_vector(31 downto 0) := x"700000AA"; -- bit de paridade vai ser preenchido
    
  begin	 -- block word_sender_block

    SEND_DATA : process(EJA_CK, reset)
      variable word_test_1    : std_logic_vector(test_word'range)	:= test_word;
      variable state_counter  : natural range 0 to 10			:= 0;
      variable letter_counter : natural range 1 to (word_test_1'length) := 1;
    begin
      
      if reset = '1' then
	start_send_a   <= '0';
	state_counter  := 0;
	letter_counter := 1;
	word_sender    <= '0';
	
      elsif rising_edge(EJA_CK) then
	-- default
	word_sender    <= word_test_1(word_test_1'high);
	start_send_a   <= start_send_a;
	state_counter  := state_counter;
	letter_counter := letter_counter;

	case state_counter is
	  when 0 =>			-- begin
	    start_send_a   <= '0';
	    letter_counter := 1;
	    state_counter  := state_counter + 1;

	  when 1 =>			-- load
	    
	    word_test_1	  := test_word;
	    state_counter := state_counter + 1;

	  when 2 =>			-- OP
	    --transmit and shift left
	    start_send_a   <= '1';
	    word_test_1	   := word_test_1(word_test_1'high-1 downto 0) & '0';
	    letter_counter := letter_counter + 1;
	    if letter_counter = word_test_1'length then
	      state_counter := state_counter + 1;
	    end if;

	  when 3 =>			-- END
	    
	    state_counter := 0;

	  when others => null;
			 
	end case;
      end if;
    end process SEND_DATA;

  end block word_sender_block;

  

end quality_rtl;


-- configurations







