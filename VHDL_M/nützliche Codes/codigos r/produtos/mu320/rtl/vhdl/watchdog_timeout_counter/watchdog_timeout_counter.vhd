------------------------------------------------------------------------------
-- Title   : Watchdog Instrument
-- Project : MU_320
-------------------------------------------------------------------------------
-- File          : watchdog_instrument.vhd
-- Author        : Gabriel Lozano
-- Company       : Reason Tecnologia S.A.
-- Created       : 2013-06-18
-- Last update   : 2013-06-18
-- Target Device :
-- Standard      : VHDL'93
-------------------------------------------------------------------------------
-- Description   : Watchdog do Instrument
-------------------------------------------------------------------------------
-- Copyright (c) 2013
-------------------------------------------------------------------------------
-- Revisions     :
-- Date          Version Author Description
-- 2013-06-18    1.0     GDL    Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity watchdog_timeout_counter is


  generic (

    FREQ_MHZ : integer := 25

    );

  port (

    -- Avalon clock Interface
    clk     : in std_logic;
    -- Reset Sync
    reset_n :    std_logic;

    -- Avalon MM Slave - Interface
    avs_address    : in  std_logic;
    avs_chipselect : in  std_logic;
    avs_read       : in  std_logic;
    avs_readdata   : out std_logic_vector(31 downto 0);

    rsi_watchdog_n : in std_logic

    );


end entity;


architecture RTL of watchdog_timeout_counter is

  -- meio segundo
  constant HALF_SECOND : integer := FREQ_MHZ*500_000;



  type TIMEOUT_TYPE is (ST_TIMEOUT_COUNT, ST_TIMEOUT_WAIT);
  signal count_reg, count_next           : unsigned(31 downto 0);
  signal count_wait_reg, count_wait_next : unsigned(31 downto 0);
  signal state_reg, state_next           : TIMEOUT_TYPE;
  signal read_count                      : std_logic;
  signal pulse_from_d_e_detector         : std_logic;
  signal clear_reg, clear_next           : std_logic;


  attribute syn_encoding                 : string;
  attribute syn_encoding of TIMEOUT_TYPE : type is "safe";

  
  
begin


  neg_edge_moore_1 : entity work.neg_edge_moore
    port map (
      clock   => clk,
      reset_n => reset_n,
      level_i => rsi_watchdog_n,
      tick_o  => pulse_from_d_e_detector);



--=======================================================
-- Registers
--=======================================================
  
  regs_timeout : process (reset_n, clk)
  begin
    if (reset_n = '0') then
      state_reg      <= ST_TIMEOUT_COUNT;
      count_reg      <= (others => '0');
      count_wait_reg <= (others => '0');
      clear_reg      <= '0';

      
    elsif rising_edge(clk) then
      state_reg      <= state_next;
      count_reg      <= count_next;
      count_wait_reg <= count_wait_next;
      clear_reg      <= clear_next;
    end if;
  end process;

  --=======================================================
  -- write / read decoding logic
  --=======================================================
  read_count <= '1' when ((avs_read = '1') and (avs_chipselect = '1') and ((avs_address) = '0')) else '0';


  --=======================================================
  -- FSM - timeout
  --=======================================================
  
  fsm_timeout : process(

    count_reg,
    count_wait_reg,
    pulse_from_d_e_detector,
    read_count,
    state_reg,
    clear_reg
    )

  begin

    state_next      <= state_reg;
    count_next      <= count_reg;
    count_wait_next <= count_wait_reg;
    clear_next      <= clear_reg;

    if (read_count = '1') then
      avs_readdata <= std_logic_vector(count_reg);
      clear_next   <= '1';
    else
      avs_readdata <= (others => '0');
    end if;


    case state_reg is
      
      when ST_TIMEOUT_COUNT =>

        if (pulse_from_d_e_detector = '1') and (clear_reg = '0') then
          state_next <= ST_TIMEOUT_WAIT;
          count_next <= count_reg + 1;
        else
          if clear_reg = '1' then
            count_next <= (others => '0');
            clear_next <= '0';
          end if;
        end if;


      when ST_TIMEOUT_WAIT =>

        if (count_wait_reg = HALF_SECOND) then
          state_next      <= ST_TIMEOUT_COUNT;
          count_wait_next <= (others => '0');
        else
          count_wait_next <= count_wait_reg + 1;
        end if;
        
      when others =>
        state_next <= ST_TIMEOUT_COUNT;
    end case;
  end process;






  

end architecture;
