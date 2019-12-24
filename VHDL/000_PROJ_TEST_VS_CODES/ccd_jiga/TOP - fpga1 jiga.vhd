----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:36 04/28/2014 
-- Design Name: 
-- Module Name:    TOP - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--                      Revision 0.04 - Added serial 1MHz transceiver
--                      Revision 0.05 - Added serial communication block between FPGA 1-2 and FPGA 1-3 controlled by Luminary requests
--                      Revision 0.06 - Added serial communication controller (Serial commands "MASTER_SERIAL_COMMANDS")
--                      Revision 0.07 - Added EJ_SERIAL_MASTER that controls serial communication between test rig and ejector board
--                                                                - Added uC-FPGA new commands for inter-FPGA serial data request
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.definitions.all;


library UNISIM;
use UNISIM.VComponents.all;

entity TOP is
  port (
    --------------------------------------------------------------------------------
    -------------------------------- System Signals --------------------------------
    --------------------------------------------------------------------------------
    -- Reset circuit input
    FPGA_RESET : in std_logic;          -- não utilizado???

    -- Free IO's output (open for general use)
    EX_IO_FPGA1 : inout std_logic_vector(7 downto 0);

    -- Clock input
    GCLK1 : in std_logic;  -- in 37,5 MHz                                                                               

    -- FPGA 2 and 3 serial interface
    FPGA_RX2     : out   std_logic;
    FPGA_TX2     : in    std_logic;
    FPGA_RX3     : out   std_logic;
    FPGA_TX3     : in    std_logic;
    --------------------------------------------------------------------------------
    ------------------ FPGA - uC Communication Interface (Test rig) ----------------
    --------------------------------------------------------------------------------
    -- Microcontroller - FPGA parallel communication interface
    UC_FPGA_DATA : inout std_logic_vector (15 downto 0);  -- LDATA
    UC_FPGA_ADDR : in    std_logic;                       -- LADDR(0)
    UC_FPGA_CLK  : in    std_logic;                       -- LCLKL
    UC_FPGA_WR   : in    std_logic;                       -- LWR
    UC_FPGA_RD   : in    std_logic;                       -- LRD

    UC_FPGA_IO1 : in  std_logic;        -- FPGA_RSTCOM
    UC_FPGA_IO2 : out std_logic;        -- FPGA_BUSYCOM
    --------------------------------------------------------------------------------
    ------------------------ Illumination Board (Not used?) ------------------------
    --------------------------------------------------------------------------------
    -- LED Control 
    LED_A       : out std_logic;  -- <= s_enable_LED_outputs <= uc_interface
    LED_B       : out std_logic;
    LED_C       : out std_logic;
    LED_D       : out std_logic;
    --------------------------------------------------------------------------------
    -------------------------- Sorting Board Test Signals --------------------------
    --------------------------------------------------------------------------------
    -- Ejector Serial Communication Interface
    -- cc7                      
    EACK        : in  std_logic;        -- => uc_interface
    EATXD       : in  std_logic;        -- => uc_interface
    EARXD       : out std_logic;        -- <= s_enable_ejectors <= uc_interface
    -- cc10

    EBCK  : in  std_logic;              -- mux
    EBTXD : in  std_logic;              -- mux
    EBRXD : out std_logic;              -- mux


    -- CCD 1-4 Control Signals
    CCD_DIS1 : in std_logic;            -- => uc_interface
    CCD_CLK1 : in std_logic;            -- => uc_interface
    CCD_SI1  : in std_logic;            -- => uc_interface

    CCD_DIS2 : in std_logic;            -- ...
    CCD_CLK2 : in std_logic;
    CCD_SI2  : in std_logic;

    CCD_DIS3 : in std_logic;
    CCD_CLK3 : in std_logic;
    CCD_SI3  : in std_logic;

    CCD_DIS4 : in std_logic;
    CCD_CLK4 : in std_logic;
    CCD_SI4  : in std_logic;

    -- Interboard communication
    RSYNC1 : out std_logic;             -- => uc_interface
    TSYNC1 : in  std_logic;             -- <= uc_interface

    RSYNC2      : out std_logic;        --...
    TSYNC2      : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------------------- IO Board Test Signals -----------------------------
    --------------------------------------------------------------------------------
    ALARME_TEST : in  std_logic;        -- => uc_interface
    LIMP1_TEST  : in  std_logic;        -- ...
    LIMP2_TEST  : in  std_logic;
    AQUEC_TEST  : in  std_logic;
    FREE_TEST_1 : in  std_logic;
    FREE_TEST_2 : in  std_logic;

    TEST_PRESS     : out std_logic;     -- <= s_enable_IO_test <= ucInterface
    TEST_PROD      : out std_logic_vector (5 downto 0);  -- ... <= s_enable_IO_test <= uc_interface
    TEST_FREE_ISO1 : out std_logic;
    TEST_FREE_ISO2 : out std_logic


    );
end TOP;

architecture Behavioral of TOP is

--------------------------------------------------------------------------------
------------------------- Serial communication block ---------------------------
--------------------------------------------------------------------------------
  component SERIAL_COMMUNICATION        -- comunicacao entre os FPGAs
    port (RX_i          : in std_logic;  -- Received data bit
          TX_DATA_i     : in std_logic_vector (7 downto 0);  -- Byte to be sent
          SEND_i        : in std_logic;  -- Flag to send byte (rising edge activated)
          CLK_60MHz_i   : in std_logic;  -- 60 MHz input system clock    
          CLK_EN_1MHz_i : in std_logic;  -- 1 MHz enable signal
          RST_i         : in std_logic;  -- Reset signal

          TX_o      : out std_logic;    -- Serial data out
          SENT_o    : out std_logic;  -- Flag that indicates the byte was sent
          FAIL_o    : out std_logic;  -- Indicates either parity is not correct or the end bit did not come
          READY_o   : out std_logic;  -- Indicates that a valid byte has been received
          RX_DATA_o : out std_logic_vector (7 downto 0));  -- Received serial byte
  end component;

--------------------------------------------------------------------------------
---------------------- Master serial commands controller -----------------------
--------------------------------------------------------------------------------
  component MASTER_SERIAL_COMMANDS  -- controle da comunicação ' entre os fpgas
    port (
      -------------------------------------------------------------------------
      ---------------------------- System signals -----------------------------
      -------------------------------------------------------------------------
      CLK_60MHZ_i      : in std_logic;  -- Input 60MHz system clock
      EN_CLK_i         : in std_logic;  -- Input 1MHz enable signal
      RESET_i          : in std_logic;  -- Input reset signal
      -------------------------------------------------------------------------
      --------------------- Communication control signals ---------------------
      -------------------------------------------------------------------------                         
      uC_REQUEST_i     : in std_logic;  -- Microntroller is requesting data from other FPGAs
      uC_FPGA_SELECT_i : in std_logic;  -- Select FPGA 2 ('0') or FPGA 3 ('1')

      uC_COMMAND_i : in std_logic_vector(7 downto 0);  -- Microntroller incoming command
      uC_DATA_i    : in std_logic_vector(31 downto 0);  -- Microntroller incoming data

      DATA_TO_uC_RECEIVED_i : in  std_logic;  -- Flag that indicates uC interface has registered the data
      DATA_TO_uC_READY_o    : out std_logic;  -- Indicates serial data is ready
      -------------------------------------------------------------------------
      --------------- Serial block signals between FPGA 1 and 2 ---------------
      -------------------------------------------------------------------------
      SERIAL_DATA_1_2_i     : in  std_logic_vector (7 downto 0);  -- Input serial data from FPGA 2
      SERIAL_DATA_1_2_o     : out std_logic_vector (7 downto 0);  -- Output serial data to FPGA 2

      PACKET_SENT_1_2_i  : in std_logic;  -- Indicates packet has been send to FPGA 2
      PACKET_FAIL_1_2_i  : in std_logic;  -- Indicates packet received FPGA 2 has failed
      PACKET_READY_1_2_i : in std_logic;  -- Indicates that packet received from FPGA 2 is ready

      SEND_PACKET_1_2_o : out std_logic;  -- Flag that iniciates serial data sending to FPGA 2
      -------------------------------------------------------------------------
      --------------- Serial block signals between FPGA 1 and 3 ---------------
      -------------------------------------------------------------------------
      SERIAL_DATA_1_3_i : in  std_logic_vector (7 downto 0);  -- Input serial data from FPGA 3
      SERIAL_DATA_1_3_o : out std_logic_vector (7 downto 0);  -- Output serial data to FPGA 3

      PACKET_SENT_1_3_i  : in std_logic;  -- Indicates packet has been send to FPGA 3
      PACKET_FAIL_1_3_i  : in std_logic;  -- Indicates packet received from FPGA 3 has failed
      PACKET_READY_1_3_i : in std_logic;  -- Indicates that packet received from FPGA 3 is ready

      SEND_PACKET_1_3_o : out std_logic;  -- Flag that iniciates serial data sending to FPGA 3
      -------------------------------------------------------------------------
      --------------------------- Serial Information --------------------------
      -------------------------------------------------------------------------
      FPGA_2_VERSION_o  : out std_logic_vector(7 downto 0);  -- FPGA 2 version (4 MSB should be "1001" for this information to be valid)
      FPGA_3_VERSION_o  : out std_logic_vector(7 downto 0);  -- FPGA 3 version (4 MSB should be "1001" for this information to be valid)
      -------------------------------------------------------------------------
      ---------------------------- uC Requested Data --------------------------
      -------------------------------------------------------------------------
      -- R2R Digital to analog converter
      R2R_i             : in  std_logic_vector(7 downto 0);
      -------------------------------------------------------------------------
      -- Illumination pins
      FRONT_LED_A_o     : out std_logic;
      FRONT_LED_B_o     : out std_logic;
      FRONT_LED_C_o     : out std_logic;
      FRONT_LED_D_o     : out std_logic;

      REAR_LED_A_o : out std_logic;
      REAR_LED_B_o : out std_logic;
      REAR_LED_C_o : out std_logic;
      REAR_LED_D_o : out std_logic;

      V_BCKGND_o     : out std_logic;
      -------------------------------------------------------------------------
      -- Ejector board output status
      EJET_o         : out std_logic_vector(31 downto 0);  -- Returns ejectors activation (if ejector board outputs are active)
      -------------------------------------------------------------------------
      -- 12 Feeders board
      TEST_FED_OUT_o : out std_logic_vector(11 downto 0);  -- 12 Feeders board vibrators feedback 
      -------------------------------------------------------------------------
      -- Resistor board test signals
      R_COMP_o       : out std_logic_vector(31 downto 0);  -- Resistor board feedback;

      -- 
      DEBUG_MSC_o : out std_logic_vector(3 downto 0));

    
  end component;

--------------------------------------------------------------------------------
---------------------- Multiplexing --------------------------------------------
--------------------------------------------------------------------------------

  component mux
    port (
      CLK_60MHZ_i       : in  std_logic;
      reset             : in  std_logic;
      EARX_o            : out std_logic;
      EBRX_o            : out std_logic;
      EJ_DATA_RX_o      : out std_logic;
      EATXD_to_uC_o     : out std_logic;
      EACK_to_uC_o      : out std_logic;
      EBCK_to_uC_o      : out std_logic;
      EBTXD_to_uC_o     : out std_logic;
      SCK_SERIAL_i      : in  std_logic;
      EJ_DATA_TX_i      : in  std_logic;
      ENABLE_EJECTORS_i : in  std_logic;
      EATX_i            : in  std_logic;
      EACK_i            : in  std_logic;
      EBCK_i            : in  std_logic;
      EBTX_i            : in  std_logic;
      mux_i             : in  std_logic;   -- Start '1'/ End '0' Multiplexing
      EOP_i             : in  std_logic;   -- End of Packet
      SOP_i             : in  std_logic;   -- Start of Packet
      debug_o           : out std_logic);  --Debug Output
  end component;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

  component EJ_SERIAL_MASTER
    port (
      DATA_RX_i       : in  std_logic;
      SEND_DATA_i     : in  input_array;
      CLK_i           : in  std_logic;
      RST_i           : in  std_logic;
      RECEIVED_DATA_o : out input_array;
      DATA_TX_o       : out std_logic;
      SYNC_CLK_o      : out std_logic;
      SOP_o           : out std_logic;
      EOP_o           : out std_logic);
  end component;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------------------------------------------------------------------- 

  component GENERATED_RESET
    port (
      CLK_37MHz_i : in  std_logic;
      RESET_o     : out std_logic);
  end component;

--------------------------------------------------------------------------------
------------------------------- Internal signals -------------------------------
--------------------------------------------------------------------------------
  signal s_reset                                                                   : std_logic;
-- Clock signals
  signal s_clk_60MHz                                                               : std_logic;
  signal s_en_30MHz, s_en_10MHz, s_en_1MHz                                         : std_logic;
-- Output control signals
  signal s_enable_LED_outputs, s_enable_IO_test, s_enable_rsync, s_enable_ejectors : std_logic;
  signal s_enable_AUX_LED_outputs: std_logic;
  -- Serial communication signals
  signal s_FPGA_TX2, s_FPGA_TX3                                                    : std_logic;
  signal s_send_FPGA2, s_send_FPGA3                                                : std_logic;
  signal s_sent_FPGA2, s_sent_FPGA3                                                : std_logic;
  signal s_ready_FPGA2, s_ready_FPGA3                                              : std_logic;
  signal s_fail_FPGA2, s_fail_FPGA3                                                : std_logic;
  signal s_tx_data_FPGA2, s_tx_data_FPGA3                                          : std_logic_vector(7 downto 0);
  signal s_rx_data_FPGA2, s_rx_data_FPGA3                                          : std_logic_vector(7 downto 0);
--------------------------------------------------------------------------------
-- FPGA serial commands controller
  signal s_uc_request, s_fpga_select                                               : std_logic;
  signal s_data_to_uc_received, s_data_to_uc_ready                                 : std_logic;
  signal s_uc_command                                                              : std_logic_vector(7 downto 0);
  signal s_uc_data                                                                 : std_logic_vector(31 downto 0);
-- Serial exchanged data
  signal s_v_bckgnd                                                                : std_logic;
  signal s_front_led_A, s_front_led_B, s_front_led_C, s_front_led_D                : std_logic;
  signal s_rear_led_A, s_rear_led_B, s_rear_led_C, s_rear_led_D                    : std_logic;
  signal s_FPGA_2_VERSION, s_FPGA_3_VERSION                                        : std_logic_vector(7 downto 0);
  signal s_r2r                                                                     : std_logic_vector(7 downto 0);
  signal s_test_fed_out                                                            : std_logic_vector(11 downto 0);
  signal s_ejet, s_r_comp                                                          : std_logic_vector(31 downto 0);
  signal s_ejet_serial_tst                                                         : std_logic_vector(31 downto 0);

  signal s_EATXD_to_uC, s_EBTXD_to_uC, s_EACK_to_uC, s_EBCK_to_uC : std_logic;
  signal s_sck_serial, s_ej_data_rx, s_ej_data_tx                 : std_logic;
  signal mux_start                                                : std_logic;
  signal SOP_master, EOP_master                                   : std_logic;
  signal EJET_info_serial                                         : std_logic_vector(31 downto 0);
  signal SEND_DATA_i                                              : input_array := (others => (others => '0'));
  signal RECEIVED_DATA_serial                                     : input_array := (others => (others => '0'));

-- Debug

  signal s_FSM_debug_uC                           : std_logic_vector(2 downto 0);
  signal UC_FPGA_IO2_int                          : std_logic;
  signal debug_o                                  : std_logic;
  signal debug_uC                                 : std_logic_vector(4 downto 0);
  signal s_clk_60MHz_div_100, s_clk_60MHz_div_200 : std_logic;
  signal RSYNC1_int, RSYNC2_int                   : std_logic;
  signal FPGA_RX3_int                             : std_logic;
  signal DEBUG_MSC                                : std_logic_vector(3 downto 0);

  signal s_en_100kHz : std_logic;
  signal s_en_io_from_uC: std_logic_vector(5 downto 0);

  -- new communication - provisory
  -- fpga3   
  signal command_from_FPGA3                                    : std_logic_vector(7 downto 0);
  signal data_from_FPGA3                                       : std_logic_vector(31 downto 0);
  signal command_from_uC                                       : std_logic_vector(7 downto 0);
  signal data_from_uC                                          : std_logic_vector(31 downto 0);
  signal data_from_FPGA3_OK_reg, data_from_FPGA3_OK_next       : std_logic;
  signal command_from_FPGA3_OK_reg, command_from_FPGA3_OK_next : std_logic;
  
  signal TEST_PROD_int: std_logic_vector(TEST_PROD'range);
  signal TEST_PRESS_int: std_logic; 
  signal s_CLK_56_25MHz_o: std_logic
  
  
begin


------------------------------------------------------------------------------------------------------------


  FPGA_RX2 <= '0';

  -- communication block between FPGA 1 and 3
  comm_master : block is
    signal SEND_DATA_i_master                   : input_array;
    signal RECEIVED_DATA_from_slave             : input_array;
    signal TX_slave, TX_master, SYNC_CLK_master : std_logic;
 
  begin
    
    EJ_SERIAL_MASTER_1 : entity work.EJ_SERIAL_MASTER
      port map (
        DATA_RX_i       => TX_slave,         -- 
        SEND_DATA_i     => SEND_DATA_i_master,
        CLK_i           => s_en_10MHz,       -- 10 MHz
        RST_i           => s_reset,
        RECEIVED_DATA_o => RECEIVED_DATA_from_slave,
        DATA_TX_o       => TX_master,        -- 
        SYNC_CLK_o      => SYNC_CLK_master,  -- 
        SOP_o           => open,
        EOP_o           => open);               

  
	
    ----------------------- 
	---- comm output / input  -----
	EX_IO_FPGA1(0)          <= TX_master; -- external (Wires)
    TX_slave                <= EX_IO_FPGA1(1);	-- external (Wires)
    FPGA_RX3                <= SYNC_CLK_master; -- internal (PCB)
	---------------------

    send_reg_master : process(s_clk_60MHz, s_reset)
    begin
      if s_reset = '1' then
        SEND_DATA_i_master(0) <= (others => '0');
        SEND_DATA_i_master(1) <= (others => '0');
        SEND_DATA_i_master(2) <= (others => '0');
        SEND_DATA_i_master(3) <= (others => '0');
        SEND_DATA_i_master(4) <= (others => '0');
        SEND_DATA_i_master(5) <= (others => '0');
        SEND_DATA_i_master(6) <= (others => '0');
        SEND_DATA_i_master(7) <= (others => '0');
      elsif rising_edge(s_clk_60MHz) then
        SEND_DATA_i_master(0) <= x"000000" & s_uc_command; --sends redundant information
        SEND_DATA_i_master(1) <= s_uc_data;
        SEND_DATA_i_master(2) <= x"000000" & s_uc_command;
        SEND_DATA_i_master(3) <= s_uc_data;
        SEND_DATA_i_master(4) <= x"000000" & s_uc_command;
        SEND_DATA_i_master(5) <= s_uc_data;
        SEND_DATA_i_master(6) <= (others => '0');
        SEND_DATA_i_master(7) <= (others => '0');	
      end if; 
    end process;

    fail_command_detect_master :
    process(RECEIVED_DATA_from_slave)
    begin
      if ((RECEIVED_DATA_from_slave(0) = RECEIVED_DATA_from_slave(2))
          and (RECEIVED_DATA_from_slave(2) = RECEIVED_DATA_from_slave(4))) then
        command_from_FPGA3_OK_next <= '1';
      else
        command_from_FPGA3_OK_next <= '0';
      end if;
    end process;

    fail_data_detect_master :
    process(RECEIVED_DATA_from_slave)
    begin
      if ((RECEIVED_DATA_from_slave(1) = RECEIVED_DATA_from_slave(3))
          and (RECEIVED_DATA_from_slave(3) = RECEIVED_DATA_from_slave(5))) then
        data_from_FPGA3_OK_next <= '1';
      else
        data_from_FPGA3_OK_next <= '0';
      end if;
    end process;

    ok_regs_master :
    process(s_clk_60MHz, s_reset)
    begin
      if s_reset = '1' then
        data_from_FPGA3_OK_reg    <= '0';
        command_from_FPGA3_OK_reg <= '0';
      elsif rising_edge(s_clk_60MHz) then
        data_from_FPGA3_OK_reg    <= data_from_FPGA3_OK_next;
        command_from_FPGA3_OK_reg <= command_from_FPGA3_OK_next;
      end if;
    end process;

    data_in_from_slave_reg :
    process(s_clk_60MHz, s_reset)
    begin
      if s_reset = '1' then
        data_from_FPGA3 <= (others => '0');
      elsif rising_edge(s_clk_60MHz) then
        if data_from_FPGA3_OK_reg = '1' then
          data_from_FPGA3 <= RECEIVED_DATA_from_slave(1);
        end if;
      end if;
    end process;

    command_in_from_slave_reg :
    process(s_clk_60MHz, s_reset)
    begin
      if s_reset = '1' then
        command_from_FPGA3 <= (others => '0');
      elsif rising_edge(s_clk_60MHz) then
        if command_from_FPGA3_OK_reg = '1' then
          command_from_FPGA3 <= RECEIVED_DATA_from_slave(0)(7 downto 0);
        end if;
      end if;
    end process;

  end block;

  

  
-- ccd control block
  ccd_test:  : block is
  
  signal s_PIX: std_logic_vector(7 downto 0);
  signal s_CCD_CLK, s_CCD_SI, s_DIS: std_logic;
  
  begin 
  
    ccd_ctrl_fsm_1: entity work.ccd_ctrl_fsm
    port map (
      clkaq     => s_CLK_56_25MHz_o,
      reset     => s_reset,
      sincin_i  => '0',
      clrsinc_o => open,
      CCD_CLK_o => s_CCD_CLK,
      CCD_SI_o  => s_CCD_SI,
      DIS_o     => s_DIS,
      pix_o     => s_pix);  
   
  end block. 
  
 	-- debug output for CCD Control Block---- 
	EX_IO_FPGA1(7) <= s_CLK_56_25MHz_o; -- logic analyzer clock sync
    EX_IO_FPGA1(6 downto 2) <= '0' & s_CCD_CLK & s_CCD_SI & s_DIS & '0';
  
  
  
----------------------------------------------------

  UC_FPGA_IO2 <= UC_FPGA_IO2_int;

  RSYNC1_int <= s_enable_rsync;
  RSYNC2_int <= s_enable_rsync;

  RSYNC1 <= RSYNC1_int;
  RSYNC2 <= RSYNC2_int;


--------------------------------------------------------------------------------
------------------------- DCM to generate clock enables ------------------------
--------------------------------------------------------------------------------
  i_DCM_CLOCK : entity work.DCM_CLOCK
    port map (
      CLK_37MHZ_i => GCLK1,
      RST_i       => s_reset,
      CLK_60MHz_o => s_clk_60MHz,
      EN_30MHz_o  => s_en_30MHz,
      EN_10MHz_o  => s_en_10MHz,
      EN_1MHz_o   => s_en_1MHz,
      EN_100kHz_o => s_en_100kHz,
	  EN_10kHz_o  => s_en_10kHz,
	  CLK_56_25MHz_o => s_CLK_56_25MHz_o
      );

--------------------------------------------------------------------------------
-------------------------- Internal generated reset ----------------------------
--------------------------------------------------------------------------------
  i_GENERATED_RESET : GENERATED_RESET
    port map(
      CLK_37MHz_i => GCLK1,
      RESET_o     => s_reset
      );

--------------------------------------------------------------------------------
------------------------------ uC-FPGA Interface -------------------------------
--------------------------------------------------------------------------------
  i_UC_INTERFACE : entity work.UC_INTERFACE
    port map(
      LDATA       => UC_FPGA_DATA,
      LADDR       => UC_FPGA_ADDR,
      LCLKL       => UC_FPGA_CLK,
      LFRAME      => '0',
      LWR         => UC_FPGA_WR,
      LRD         => UC_FPGA_RD,
      FPGA_RSTCOM => UC_FPGA_IO1,

      RST_i       => s_reset,
      CLK_10MHz_i => s_en_10MHz,
      CLK_60MHz_i => s_clk_60MHz,

      FPGA_BUSYCOM => UC_FPGA_IO2_int,
--------------------------------------------------------------------------------
      EACK_i       => s_EACK_to_uC,
      EATXD_i      => s_EATXD_to_uC,
      EBCK_i       => s_EBCK_to_uC,
      EBTXD_i      => s_EBTXD_to_uC,

      ENABLE_EJECTORS_o => s_enable_ejectors,
--------------------------------------------------------------------------------
      CCD_DIS1_i        => CCD_DIS1,
      CCD_CLK1_i        => CCD_CLK1,
      CCD_SI1_i         => CCD_SI1,

      CCD_DIS2_i => CCD_DIS2,
      CCD_CLK2_i => CCD_CLK2,
      CCD_SI2_i  => CCD_SI2,

      CCD_DIS3_i => CCD_DIS3,
      CCD_CLK3_i => CCD_CLK3,
      CCD_SI3_i  => CCD_SI3,

      CCD_DIS4_i => CCD_DIS4,
      CCD_CLK4_i => CCD_CLK4,
      CCD_SI4_i  => CCD_SI4,
-------------------------------------------------------------------------------
      TSYNC1_i   => TSYNC1,
      TSYNC2_i   => TSYNC2,

      RSYNC_o       => s_enable_rsync,
--------------------------------------------------------------------------------
      ALARME_TEST_i => ALARME_TEST,
      LIMP1_TEST_i  => LIMP1_TEST,
      LIMP2_TEST_i  => LIMP2_TEST,
      AQUEC_TEST_i  => AQUEC_TEST,
      FREE_TEST_1_i => FREE_TEST_1,
      FREE_TEST_2_i => FREE_TEST_2,

      IO_TEST_o        => s_enable_IO_test,
--------------------------------------------------------------------------------
      LED_OUTPUTS_o    => s_enable_LED_outputs,
-------------------------------------------------------------------------
------------------------------ Serial commands --------------------------
-------------------------------------------------------------------------
-- Serial controller signals
      uC_REQUEST_o     => s_uc_request,
      uC_FPGA_SELECT_o => s_fpga_select,

      uC_COMMAND_o => s_uc_command,
      uC_DATA_o    => s_uc_data,

      DATA_TO_uC_RECEIVED_o => s_data_to_uc_received,
      DATA_TO_uC_READY_i    => s_data_to_uc_ready,

      -- new communication 
      COMMAND_FROM_FPGA3_i => command_from_FPGA3,
      DATA_FROM_FPGA3_i    => data_from_FPGA3,
      COMMAND_FPGA3_ok     => command_from_FPGA3_OK_reg,
      DATA_FPGA_3_OK       => data_from_FPGA3_OK_reg,


-------------------------------------------------------------------------
-- FPGA 2 and 3 versions
      FPGA_2_VERSION_i => s_FPGA_2_VERSION,
      FPGA_3_VERSION_i => s_FPGA_3_VERSION,
-------------------------------------------------------------------------
-- R2R Digital to analog converter
      R2R_o            => s_r2r,
-------------------------------------------------------------------------
-- Illumination pins
      FRONT_LED_A_i    => s_front_led_A,
      FRONT_LED_B_i    => s_front_led_B,
      FRONT_LED_C_i    => s_front_led_C,
      FRONT_LED_D_i    => s_front_led_D,

      REAR_LED_A_i => s_rear_led_A,
      REAR_LED_B_i => s_rear_led_B,
      REAR_LED_C_i => s_rear_led_C,
      REAR_LED_D_i => s_rear_led_D,

      V_BCKGND_i     => s_v_bckgnd,
-------------------------------------------------------------------------
-- Ejector board output status
      -- EJET_i         => s_ejet,
-------------------------------------------------------------------------
-- 12 Feeders board
      TEST_FED_OUT_i => s_test_fed_out,
-------------------------------------------------------------------------
-- Resistor board test signals
      R_COMP_i       => s_r_comp,

-------------------------------------------------------------------------                                       
-- Ejector Serial Activation
      EJET_SERIAL_TST_o => s_ejet_serial_tst,

-- Ejector Multiplexing 
      MUX_START_O => mux_start,

-- Ejector serial input
      EJET_info_serial_i => EJET_info_serial,

--  FSM_o -- Debug State Machine

      FSM_o => s_FSM_debug_uC,

-- Debug  

      debug_o => debug_uC,
-- AUX LEDs
	  EN_AUX_LEDS_o => s_enable_AUX_LED_outputs 


      );

  
  LED_A <= s_enable_LED_outputs;
  LED_B <= s_enable_LED_outputs;
  LED_C <= s_enable_LED_outputs;
  LED_D <= s_enable_LED_outputs;



  TEST_FREE_ISO1 <= s_enable_IO_test;
  TEST_FREE_ISO2 <= s_enable_IO_test;

  TEST_PROD_int   <= "000000" when (s_enable_IO_test = '0') else "111111";
  TEST_PROD <= TEST_PROD_int;
  
    
  TEST_PRESS_int   <=  s_enable_IO_test;
  TEST_PRESS <= TEST_PRESS_int;
  
  
--------------------------------------------------------------------------------
---------------------- Ejector board serial controller -------------------------
--------------------------------------------------------------------------------                        
  i_EJ_SERIAL_MASTER : EJ_SERIAL_MASTER
    port map(
      DATA_RX_i => s_ej_data_rx,

      SYNC_CLK_o => s_sck_serial,

      CLK_i       => s_clk_60MHz,
      RST_i       => s_reset,
      SEND_DATA_i => SEND_DATA_i,

      RECEIVED_DATA_o => RECEIVED_DATA_serial,
      DATA_TX_o       => s_ej_data_tx,

      SOP_o => SOP_master,
      EOP_o => EOP_master
      );        

  -------- data sent to serial -------
  SEND_DATA_i(0) <= (others => '0');
  SEND_DATA_i(1) <= s_ejet_serial_tst;
  SEND_DATA_i(2) <= (others => '0');
  SEND_DATA_i(3) <= (others => '0');
  SEND_DATA_i(4) <= (others => '0');
  SEND_DATA_i(5) <= (others => '0');
  SEND_DATA_i(6) <= (others => '0');
  SEND_DATA_i(7) <= (others => '0');

  EJET_info_serial <= RECEIVED_DATA_serial(1);  -- *** testando o recebimento (loop com o que foi enviado)


---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

  i_OUT_MUX : MUX
    port map(
      CLK_60MHZ_i => s_clk_60MHz,
      reset       => s_reset,

      -- i/o from hardware
      EACK_i => EACK,
      EATX_i => EATXD,                  -- data coming from ejector board 
      EARX_o => EARXD,                  -- to ejector board (clk)

      EBCK_i => EBCK,                   -- conector
      EBTX_i => EBTXD,                  -- conector
      EBRX_o => EBRXD,                  -- to ejector board

      -- inputs from gateware
      EATXD_to_uC_o     => s_EATXD_to_uC,
      EACK_to_uC_o      => s_EACK_to_uC,
      EBCK_to_uC_o      => s_EBCK_to_uC,
      EBTXD_to_uC_o     => s_EBTXD_to_uC,
      ENABLE_EJECTORS_i => s_enable_ejectors,

      -- io from Serial Master
      EJ_DATA_RX_o => s_ej_data_rx,
      SCK_SERIAL_i => s_sck_serial,
      EJ_DATA_TX_i => s_ej_data_tx,

      SOP_i => SOP_master,
      EOP_i => EOP_master,

      debug_o => open,
      mux_i   => mux_start
      );





--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



end Behavioral;

