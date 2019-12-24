-------------------------------------------------------------------------------
-- Title      :
-- Project    : MU320
-------------------------------------------------------------------------------
-- File       :
-- Author     : 
-- Company    : 
-- Created    : 2012-05-03
-- Last update: 2014-08-29
-- Last update: 2012-08-30
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description

-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mu320_constants.all;

entity mu320 is
  port
    (
-------------------------------------------------------------------------------
-- Miscellaneous Signals
-------------------------------------------------------------------------------

      -- Clock Signals
      clock_100mhz  : in std_logic;
      clock_in_cmos : in std_logic;

      factory_reset_n : in std_logic;
      test_n          : in std_logic;
      reset_n         : in std_logic;

      -- IRIG Signals
      optical_in : in std_logic;

      -- LED Signals
      led    : out std_logic_vector(3 downto 0);
      led_bp : out std_logic_vector(5 downto 0);

      -- PWM Out
      vc_in : out std_logic;

-------------------------------------------------------------------------------
-- EURO signals
-------------------------------------------------------------------------------

      -- Acquisition Signals
      mdat0  : in  std_logic_vector(7 downto 0);
      mdat1  : in  std_logic_vector(7 downto 0);
      mclkin : out std_logic;

      -- Trip Signals
      trip0 : out std_logic_vector(7 downto 0);
      trip1 : out std_logic_vector(7 downto 0);

      -- Digital Signals
      d_mux : out std_logic_vector(3 downto 0);
      din0  : in  std_logic;
      din1  : in  std_logic;

      -- I�C Signals
      scl : inout std_logic;
      sda : inout std_logic;

      scl2 : inout std_logic;
      sda2 : inout std_logic;

      -- Alarm Signal
      alarm_n : out std_logic;


-------------------------------------------------------------------------------
-- Memory Signals
-------------------------------------------------------------------------------

      -- DDR2 Signals
      mem_clk_p : inout std_logic;
      mem_clk_n : inout std_logic;
      mem_cke   : out   std_logic;
      mem_a     : out   std_logic_vector(12 downto 0);
      mem_dq    : inout std_logic_vector(15 downto 0);
      mem_dqs   : inout std_logic_vector(1 downto 0);
      mem_dm    : out   std_logic_vector(1 downto 0);
      mem_we_n  : out   std_logic;
      mem_ras_n : out   std_logic;
      mem_cas_n : out   std_logic;
      mem_odt   : out   std_logic;
      mem_cs_n  : out   std_logic;
      mem_ba    : out   std_logic_vector(2 downto 0);

      -- FLASH Signals
      flash_d     : inout std_logic_vector(7 downto 0)  := (others => 'X');
      flash_wr_n  : inout std_logic;
      flash_addr  : inout std_logic_vector(25 downto 0) := (others => 'X');
      flash_rd_n  : inout std_logic;
      flash_cs_n  : out   std_logic;
      reset_out_n : out   std_logic;

      -- EPCS Signals
      asdo  : out std_logic;
      data0 : in  std_logic;
      dclk  : out std_logic;
      ncso  : out std_logic;


-------------------------------------------------------------------------------
-- Ethernet Signals
-------------------------------------------------------------------------------      

      -- Shared Signals
      phy_clock : out std_logic;

      -- ETH0 Signals
      eth0_tx      : out   std_logic_vector(3 downto 0);
      eth0_tx_en   : out   std_logic;
      eth0_col     : in    std_logic;
      eth0_crs     : in    std_logic;
      eth0_rxd     : in    std_logic_vector(3 downto 0);
      eth0_rx_dv   : in    std_logic;
      eth0_rx_er   : in    std_logic;
      eth0_rx_clk  : in    std_logic;
      eth0_tx_clk  : in    std_logic;
      eth0_mdc     : out   std_logic;
      eth0_mdio    : inout std_logic;
      eth0_reset_n : out   std_logic;
      eth0_clk_out : in    std_logic;
      eth0_gpio_0  : out   std_logic;
      eth0_gpio_1  : in    std_logic;
      eth0_gpio_2  : in    std_logic;
      eth0_gpio_3  : in    std_logic;

      -- ETH1 Signals
      eth1_tx      : out   std_logic_vector(3 downto 0);
      eth1_tx_en   : out   std_logic;
      eth1_col     : in    std_logic;
      eth1_crs     : in    std_logic;
      eth1_rxd     : in    std_logic_vector(3 downto 0);
      eth1_rx_dv   : in    std_logic;
      eth1_rx_er   : in    std_logic;
      eth1_rx_clk  : in    std_logic;
      eth1_tx_clk  : in    std_logic;
      eth1_mdc     : out   std_logic;
      eth1_mdio    : inout std_logic;
      eth1_reset_n : out   std_logic;
      eth1_clk_out : in    std_logic;
      eth1_gpio_0  : out   std_logic;
      eth1_gpio_1  : in    std_logic;
      eth1_gpio_2  : in    std_logic;
      eth1_gpio_3  : in    std_logic

      );

end mu320;

architecture mu320_struct of mu320 is


  -- IRIG Decoder
  signal irig_ok     : std_logic;
  signal irig_signal : std_logic;
  signal t_mark      : std_logic;
  signal irq_irig    : std_logic;
  signal sync_irig   : std_logic_vector(7 downto 0);
  signal smp_sync    : std_logic_vector(1 downto 0);

  signal virtual_pps_4800 : std_logic;

  signal counter_reset    : natural range 0 to (ONE_SECOND - 1);
  signal counter_ready    : natural range 0 to (ONE_SECOND - 1);
  signal led_int          : std_logic;
  signal eth0_mdio_in     : std_logic;
  signal eth0_mdio_oen    : std_logic;
  signal eth0_mdio_out    : std_logic;
  signal eth0_gtx_clk_sig : std_logic;
  signal eth1_mdio_in     : std_logic;
  signal eth1_mdio_oen    : std_logic;
  signal eth1_mdio_out    : std_logic;
  signal eth1_gtx_clk_sig : std_logic;

  signal led_clk                       : std_logic;
  signal reset_n_sync                  : std_logic;
  signal reset_int_n                   : std_logic;
  signal n_reset                       : std_logic;
  signal trip_reg                      : std_logic;
  signal led_reg                       : std_logic;
  signal sysclk                        : std_logic;
  signal start_button_n_protection_int : std_logic;
  signal start_button_n_monitoring_int : std_logic;
  signal pps_int                       : std_logic;
  signal protection_clock              : std_logic;
  signal freq_mclk                     : std_logic;


  signal ready_cic         : std_logic;
  signal d_ana             : std_logic_vector((N_CHANNELS_ANA * N_BITS_ADC -1) downto 0);
  signal d_dig             : std_logic_vector((N_CHANNELS_DIG -1) downto 0);
  signal d_mon             : std_logic_vector((N_CHANNELS_MON -1) downto 0);
  signal d_goose           : std_logic_vector((N_GOOSE_INPUTS -1) downto 0);
  signal digital_available : std_logic;
  signal goose_available   : std_logic;
  signal ready_data        : std_logic;
  signal t_mark_edge       : std_logic;
  signal sync_soc          : std_logic;


  signal shuffler_out             : std_logic_vector(15 downto 0);
  signal calibrated_data_ready    : std_logic;
  signal calibrated_data          : std_logic_vector((N_CHANNELS_ANA * N_BITS_ADC - 1) downto 0);
  signal adjusted_data_available  : std_logic;
  signal adjusted_data            : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*2 - 1) downto 0);
  signal sample_quality_available : std_logic;
  signal sample_quality           : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC*4 - 1) downto 0);

  signal link_eth           : std_logic_vector(1 downto 0);
  signal backplane_leds_reg : std_logic_vector(5 downto 0);

  signal zero_packet_flag : std_logic;

  signal freq_80              : std_logic_vector(12 downto 0);
  signal step_low_80          : std_logic_vector(6 downto 0);
  signal step_normal_80       : std_logic_vector(13 downto 0);
  signal freq_default_std_80  : std_logic_vector(59 downto 0);
  signal k_default_std_80     : std_logic_vector(43 downto 0);
  signal freq_256             : std_logic_vector(13 downto 0);
  signal step_low_256         : std_logic_vector(1 downto 0);
  signal step_normal_256      : std_logic_vector(2 downto 0);
  signal freq_default_std_256 : std_logic_vector(59 downto 0);
  signal k_default_std_256    : std_logic_vector(43 downto 0);
  signal sync_reset_n         : std_logic;

  signal alarm_instrument_linux : std_logic;
  signal alarm_led_from_linux   : std_logic;
  signal alarm_n_int            : std_logic;

  signal phase_sum_data_io                     : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC)-1 downto 0);
  signal phase_sum_board1_data_io_board_input  : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC/2)-1 downto 0);
  signal phase_sum_board2_data_io_board_input  : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC/2)-1 downto 0);
  signal phase_sum_board1_data_io_board_output : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC/2)-1 downto 0);
  signal phase_sum_board2_data_io_board_output : std_logic_vector((N_CHANNELS_ANA*N_BITS_ADC/2)-1 downto 0);
  signal phase_sum_boards_data_ready           : std_logic;
  signal phase_sum_board1_data_ready           : std_logic;
  signal phase_sum_board2_data_ready           : std_logic;




  component mu320_cpu is
    port (
      c1_out_clk_out                                            : out   std_logic;  -- clk
      local_refresh_ack_from_the_ddr2_sdram                     : out   std_logic;  -- local_refresh_ack
      local_init_done_from_the_ddr2_sdram                       : out   std_logic;  -- local_init_done
      reset_phy_clk_n_from_the_ddr2_sdram                       : out   std_logic;  -- reset_phy_clk_n
      reset_n                                                   : in    std_logic                      := 'X';  -- reset_n
      areset_to_the_pll                                         : in    std_logic                      := 'X';  -- export
      protection_analog_data_input_to_the_sv_packet_processor_1 : in    std_logic_vector(511 downto 0) := (others => 'X');  -- protection_analog_data_input
      protection_analog_data_ready_to_the_sv_packet_processor_1 : in    std_logic                      := 'X';  -- protection_analog_data_ready
      monitoring_analog_data_input_to_the_sv_packet_processor_1 : in    std_logic_vector(511 downto 0) := (others => 'X');  -- monitoring_analog_data_input
      monitoring_analog_data_ready_to_the_sv_packet_processor_1 : in    std_logic                      := 'X';  -- monitoring_analog_data_ready
      monitoring_analog_new_data_from_the_sv_packet_processor_1 : out   std_logic;  -- monitoring_analog_new_data
      pps_to_the_sv_packet_processor_1                          : in    std_logic                      := 'X';  -- pps
      sysclk_to_the_sv_packet_processor_1                       : in    std_logic                      := 'X';  -- sysclk
      sv_packet_processor_1_conduit_end_irig_status             : in    std_logic_vector(7 downto 0)   := (others => 'X');  -- irig_status
      ddr2_sdram_aux_full_rate_clk_out                          : out   std_logic;  -- clk
      mem_odt_from_the_ddr2_sdram                               : out   std_logic_vector(0 downto 0);  -- mem_odt
      mem_clk_to_and_from_the_ddr2_sdram                        : inout std_logic_vector(0 downto 0)   := (others => 'X');  -- mem_clk
      mem_clk_n_to_and_from_the_ddr2_sdram                      : inout std_logic_vector(0 downto 0)   := (others => 'X');  -- mem_clk_n
      mem_cs_n_from_the_ddr2_sdram                              : out   std_logic_vector(0 downto 0);  -- mem_cs_n
      mem_cke_from_the_ddr2_sdram                               : out   std_logic_vector(0 downto 0);  -- mem_cke
      mem_addr_from_the_ddr2_sdram                              : out   std_logic_vector(12 downto 0);  -- mem_addr
      mem_ba_from_the_ddr2_sdram                                : out   std_logic_vector(2 downto 0);  -- mem_ba
      mem_ras_n_from_the_ddr2_sdram                             : out   std_logic;  -- mem_ras_n
      mem_cas_n_from_the_ddr2_sdram                             : out   std_logic;  -- mem_cas_n
      mem_we_n_from_the_ddr2_sdram                              : out   std_logic;  -- mem_we_n
      mem_dq_to_and_from_the_ddr2_sdram                         : inout std_logic_vector(15 downto 0)  := (others => 'X');  -- mem_dq
      mem_dqs_to_and_from_the_ddr2_sdram                        : inout std_logic_vector(1 downto 0)   := (others => 'X');  -- mem_dqs
      mem_dm_from_the_ddr2_sdram                                : out   std_logic_vector(1 downto 0);  -- mem_dm
      locked_from_the_pll                                       : out   std_logic;  -- export
      phasedone_from_the_pll                                    : out   std_logic;  -- export
      c0_out_clk_out                                            : out   std_logic;  -- clk
      clk_0                                                     : in    std_logic                      := 'X';  -- clk
      data_to_and_from_the_cfi_flash                            : inout std_logic_vector(7 downto 0)   := (others => 'X');  -- data_to_and_from_the_cfi_flash
      address_to_the_cfi_flash                                  : out   std_logic_vector(24 downto 0);  -- address_to_the_cfi_flash
      write_n_to_the_cfi_flash                                  : out   std_logic_vector(0 downto 0);  -- write_n_to_the_cfi_flash
      select_n_to_the_cfi_flash                                 : out   std_logic_vector(0 downto 0);  -- select_n_to_the_cfi_flash
      read_n_to_the_cfi_flash                                   : out   std_logic_vector(0 downto 0);  -- read_n_to_the_cfi_flash
      gm_rx_d_to_the_tse_mac                                    : in    std_logic_vector(7 downto 0)   := (others => 'X');  -- gm_rx_d
      gm_rx_dv_to_the_tse_mac                                   : in    std_logic                      := 'X';  -- gm_rx_dv
      gm_rx_err_to_the_tse_mac                                  : in    std_logic                      := 'X';  -- gm_rx_err
      gm_tx_d_from_the_tse_mac                                  : out   std_logic_vector(7 downto 0);  -- gm_tx_d
      gm_tx_en_from_the_tse_mac                                 : out   std_logic;  -- gm_tx_en
      gm_tx_err_from_the_tse_mac                                : out   std_logic;  -- gm_tx_err
      m_rx_d_to_the_tse_mac                                     : in    std_logic_vector(3 downto 0)   := (others => 'X');  -- m_rx_d
      m_rx_en_to_the_tse_mac                                    : in    std_logic                      := 'X';  -- m_rx_en
      m_rx_err_to_the_tse_mac                                   : in    std_logic                      := 'X';  -- m_rx_err
      m_tx_d_from_the_tse_mac                                   : out   std_logic_vector(3 downto 0);  -- m_tx_d
      m_tx_en_from_the_tse_mac                                  : out   std_logic;  -- m_tx_en
      m_tx_err_from_the_tse_mac                                 : out   std_logic;  -- m_tx_err
      m_rx_col_to_the_tse_mac                                   : in    std_logic                      := 'X';  -- m_rx_col
      m_rx_crs_to_the_tse_mac                                   : in    std_logic                      := 'X';  -- m_rx_crs
      tx_clk_to_the_tse_mac                                     : in    std_logic                      := 'X';  -- tx_clk
      rx_clk_to_the_tse_mac                                     : in    std_logic                      := 'X';  -- rx_clk
      set_10_to_the_tse_mac                                     : in    std_logic                      := 'X';  -- set_10
      set_1000_to_the_tse_mac                                   : in    std_logic                      := 'X';  -- set_1000
      ena_10_from_the_tse_mac                                   : out   std_logic;  -- ena_10
      eth_mode_from_the_tse_mac                                 : out   std_logic;  -- eth_mode
      mdio_out_from_the_tse_mac                                 : out   std_logic;  -- mdio_out
      mdio_oen_from_the_tse_mac                                 : out   std_logic;  -- mdio_oen
      mdio_in_to_the_tse_mac                                    : in    std_logic                      := 'X';  -- mdio_in
      mdc_from_the_tse_mac                                      : out   std_logic;  -- mdc
      protection_analog_data_input_to_the_sv_packet_processor_0 : in    std_logic_vector(511 downto 0) := (others => 'X');  -- protection_analog_data_input
      protection_analog_data_ready_to_the_sv_packet_processor_0 : in    std_logic                      := 'X';  -- protection_analog_data_ready
      monitoring_analog_data_input_to_the_sv_packet_processor_0 : in    std_logic_vector(511 downto 0) := (others => 'X');  -- monitoring_analog_data_input
      monitoring_analog_data_ready_to_the_sv_packet_processor_0 : in    std_logic                      := 'X';  -- monitoring_analog_data_ready
      monitoring_analog_new_data_from_the_sv_packet_processor_0 : out   std_logic;  -- monitoring_analog_new_data
      pps_to_the_sv_packet_processor_0                          : in    std_logic                      := 'X';  -- pps
      sysclk_to_the_sv_packet_processor_0                       : in    std_logic                      := 'X';  -- sysclk
      sv_packet_processor_0_conduit_end_irig_status             : in    std_logic_vector(7 downto 0)   := (others => 'X');  -- irig_status
      dclk_from_the_epcs                                        : out   std_logic;  -- dclk
      sce_from_the_epcs                                         : out   std_logic;  -- sce
      sdo_from_the_epcs                                         : out   std_logic;  -- sdo
      data0_to_the_epcs                                         : in    std_logic                      := 'X';  -- data0
      irig_decode_conduit_end_irig_ok                           : out   std_logic;  -- irig_ok
      irig_decode_conduit_end_irq                               : out   std_logic;  -- irq
      irig_decode_conduit_end_t_mark                            : out   std_logic;  -- t_mark
      irig_decode_conduit_end_sysclk                            : in    std_logic                      := 'X';  -- sysclk
      irig_decode_conduit_end_sync_irig                         : out   std_logic_vector(7 downto 0);  -- sync_irig
      irig_decode_conduit_end_irig                              : in    std_logic                      := 'X';  -- irig
      pps_external_connection_export                            : in    std_logic                      := 'X';  -- export
      opencores_i2c_0_export_0_scl_pad_io                       : inout std_logic                      := 'X';  -- scl_pad_io
      opencores_i2c_0_export_0_sda_pad_io                       : inout std_logic                      := 'X';  -- sda_pad_io
      gain_registers_0_conduit_end_sysclk                       : in    std_logic                      := 'X';  -- sysclk
      gain_registers_0_conduit_end_data_ready                   : out   std_logic;  -- data_ready
      gain_registers_0_conduit_end_data_output                  : out   std_logic_vector(255 downto 0);  -- data_output
      gain_registers_0_conduit_end_data_available               : in    std_logic                      := 'X';  -- data_available
      gain_registers_0_conduit_end_data_input                   : in    std_logic_vector(255 downto 0) := (others => 'X');  -- data_input
      shuffler_0_conduit_end_out                                : out   std_logic_vector(15 downto 0);  -- out
      shuffler_0_conduit_end_in                                 : in    std_logic_vector(15 downto 0)  := (others => 'X');  -- in
      sample_adjust_0_conduit_end_data_out                      : out   std_logic_vector(511 downto 0);  -- data_out
      sample_adjust_0_conduit_end_data_out_ready                : out   std_logic;  -- data_out_ready
      sample_adjust_0_conduit_end_data_in_available             : in    std_logic                      := 'X';  -- data_in_available
      sample_adjust_0_conduit_end_sysclk                        : in    std_logic                      := 'X';  -- sysclk
      sample_adjust_0_conduit_end_data_in                       : in    std_logic_vector(255 downto 0) := (others => 'X');  -- data_in
      tse_mac_linux_conduit_connection_gm_rx_d                  : in    std_logic_vector(7 downto 0)   := (others => 'X');  -- gm_rx_d
      tse_mac_linux_conduit_connection_gm_rx_dv                 : in    std_logic                      := 'X';  -- gm_rx_dv
      tse_mac_linux_conduit_connection_gm_rx_err                : in    std_logic                      := 'X';  -- gm_rx_err
      tse_mac_linux_conduit_connection_gm_tx_d                  : out   std_logic_vector(7 downto 0);  -- gm_tx_d
      tse_mac_linux_conduit_connection_gm_tx_en                 : out   std_logic;  -- gm_tx_en
      tse_mac_linux_conduit_connection_gm_tx_err                : out   std_logic;  -- gm_tx_err
      tse_mac_linux_conduit_connection_m_rx_d                   : in    std_logic_vector(3 downto 0)   := (others => 'X');  -- m_rx_d
      tse_mac_linux_conduit_connection_m_rx_en                  : in    std_logic                      := 'X';  -- m_rx_en
      tse_mac_linux_conduit_connection_m_rx_err                 : in    std_logic                      := 'X';  -- m_rx_err
      tse_mac_linux_conduit_connection_m_tx_d                   : out   std_logic_vector(3 downto 0);  -- m_tx_d
      tse_mac_linux_conduit_connection_m_tx_en                  : out   std_logic;  -- m_tx_en
      tse_mac_linux_conduit_connection_m_tx_err                 : out   std_logic;  -- m_tx_err
      tse_mac_linux_conduit_connection_m_rx_col                 : in    std_logic                      := 'X';  -- m_rx_col
      tse_mac_linux_conduit_connection_m_rx_crs                 : in    std_logic                      := 'X';  -- m_rx_crs
      tse_mac_linux_conduit_connection_tx_clk                   : in    std_logic                      := 'X';  -- tx_clk
      tse_mac_linux_conduit_connection_rx_clk                   : in    std_logic                      := 'X';  -- rx_clk
      tse_mac_linux_conduit_connection_set_10                   : in    std_logic                      := 'X';  -- set_10
      tse_mac_linux_conduit_connection_set_1000                 : in    std_logic                      := 'X';  -- set_1000
      tse_mac_linux_conduit_connection_ena_10                   : out   std_logic;  -- ena_10
      tse_mac_linux_conduit_connection_eth_mode                 : out   std_logic;  -- eth_mode
      tse_mac_linux_conduit_connection_mdio_out                 : out   std_logic;  -- mdio_out
      tse_mac_linux_conduit_connection_mdio_oen                 : out   std_logic;  -- mdio_oen
      tse_mac_linux_conduit_connection_mdio_in                  : in    std_logic                      := 'X';  -- mdio_in
      tse_mac_linux_conduit_connection_mdc                      : out   std_logic;  -- mdc
      link_eth_external_connection_export                       : out   std_logic_vector(1 downto 0);  -- export   
      analog_sample_register_conduit_end_data_available_i       : in    std_logic                      := 'X';  -- data_input_available
      analog_sample_register_conduit_end_data_i                 : in    std_logic_vector(511 downto 0) := (others => 'X');  -- data_input
      analog_sample_register_conduit_end_pps_edge_i             : in    std_logic                      := 'X';  -- pps_input
      analog_sample_register_conduit_end_clk                    : in    std_logic                      := 'X';  -- sysclk      
      digital_register_0_conduit_end_data_input_available       : in    std_logic                      := 'X';  -- data_input_available
      digital_register_0_conduit_end_sysclk                     : in    std_logic                      := 'X';  -- sysclk
      digital_register_0_conduit_end_data_input                 : in    std_logic_vector(31 downto 0)  := (others => 'X');  -- data_input
      digital_register_0_conduit_end_data_output                : out   std_logic_vector(15 downto 0);  -- data_output
      nom_freq_sel_0_conduit_end_freq_80_o                      : out   std_logic_vector(12 downto 0);  -- freq_80_o
      nom_freq_sel_0_conduit_end_step_low_80_o                  : out   std_logic_vector(6 downto 0);  -- step_low_80_o
      nom_freq_sel_0_conduit_end_step_normal_80_o               : out   std_logic_vector(13 downto 0);  -- step_normal_80_o
      nom_freq_sel_0_conduit_end_freq_default_std_80_o          : out   std_logic_vector(59 downto 0);  -- freq_default_std_80_o
      nom_freq_sel_0_conduit_end_k_default_std_80_o             : out   std_logic_vector(43 downto 0);  -- k_default_std_80_o
      nom_freq_sel_0_conduit_end_freq_256_o                     : out   std_logic_vector(13 downto 0);  -- freq_256_o
      nom_freq_sel_0_conduit_end_step_low_256_o                 : out   std_logic_vector(1 downto 0);  -- step_low_256_o
      nom_freq_sel_0_conduit_end_step_normal_256_o              : out   std_logic_vector(2 downto 0);  -- step_normal_256_o
      nom_freq_sel_0_conduit_end_freq_default_std_256_o         : out   std_logic_vector(59 downto 0);  -- freq_default_std_256_o
      nom_freq_sel_0_conduit_end_k_default_std_256_o            : out   std_logic_vector(43 downto 0);  -- k_default_std_256_o
      nom_freq_sel_0_conduit_end_sync_reset_o_n                 : out   std_logic;  -- sync_reset_o_n
      nom_freq_sel_0_conduit_end_sysclk                         : in    std_logic                      := 'X';  -- sysclk

      phase_sum_board1_data_io_board_input  : in  std_logic_vector(127 downto 0) := (others => 'X');  -- input
      phase_sum_board1_data_io_board_output : out std_logic_vector(127 downto 0);  -- output
      phase_sum_board2_data_io_board_input  : in  std_logic_vector(127 downto 0) := (others => 'X');  -- input
      phase_sum_board2_data_io_board_output : out std_logic_vector(127 downto 0);  -- output

      phase_sum_board1_data_ready_io_in  : in  std_logic := 'X';  -- in
      phase_sum_board1_data_ready_io_out : out std_logic;         -- out
      phase_sum_board2_data_ready_io_in  : in  std_logic := 'X';  -- in
      phase_sum_board2_data_ready_io_out : out std_logic;         -- out

      phase_sum_board1_sysclk_export : in std_logic := 'X';  -- export
      phase_sum_board2_sysclk_export : in std_logic := 'X';   -- export
      
      watchdog_instrument_0_coe_alarm_export                    : out   std_logic;  -- export
      alarm_led_from_linux_external_connection_export           : out   std_logic;  -- export
      relay_alarm_from_linux_external_connection_export         : out   std_logic  -- export
      );
  end component mu320_cpu;
  
begin

  eth0_mdio_in <= eth0_mdio;
  eth0_mdio    <= eth0_mdio_out when (eth0_mdio_oen = '0') else 'Z';
  eth1_mdio_in <= eth1_mdio;
  eth1_mdio    <= eth1_mdio_out when (eth1_mdio_oen = '0') else 'Z';

  reset_out_n <= reset_int_n;

  eth0_reset_n <= reset_int_n;
  eth1_reset_n <= reset_int_n;

  led(1) <= sync_soc;
  led(2) <= freq_mclk;
  mclkin <= freq_mclk;

  led_bp <= backplane_leds_reg;

  -- phy assignments
  eth0_gpio_0 <= t_mark;
  eth1_gpio_0 <= t_mark;


  u0 : component mu320_cpu
    port map(
      clk_0   => clock_100mhz,
      reset_n => reset_int_n,

      c0_out_clk_out => sysclk,
      c1_out_clk_out => phy_clock,

      -- EPCS
      dclk_from_the_epcs => dclk,
      sce_from_the_epcs  => ncso,
      sdo_from_the_epcs  => asdo,
      data0_to_the_epcs  => data0,

      address_to_the_cfi_flash       => flash_addr(24 downto 0),
      data_to_and_from_the_cfi_flash => flash_d,
      read_n_to_the_cfi_flash(0)     => flash_rd_n,
      select_n_to_the_cfi_flash(0)   => flash_cs_n,
      write_n_to_the_cfi_flash(0)    => flash_wr_n,

      -- DDR2 Memory
      mem_addr_from_the_ddr2_sdram            => mem_a,
      mem_ba_from_the_ddr2_sdram              => mem_ba,
      mem_cas_n_from_the_ddr2_sdram           => mem_cas_n,
      mem_cke_from_the_ddr2_sdram(0)          => mem_cke,
      mem_clk_n_to_and_from_the_ddr2_sdram(0) => mem_clk_n,
      mem_clk_to_and_from_the_ddr2_sdram(0)   => mem_clk_p,
      mem_cs_n_from_the_ddr2_sdram(0)         => mem_cs_n,
      mem_dm_from_the_ddr2_sdram              => mem_dm,
      mem_dq_to_and_from_the_ddr2_sdram       => mem_dq,
      mem_dqs_to_and_from_the_ddr2_sdram      => mem_dqs,
      mem_odt_from_the_ddr2_sdram(0)          => mem_odt,
      mem_ras_n_from_the_ddr2_sdram           => mem_ras_n,
      mem_we_n_from_the_ddr2_sdram            => mem_we_n,

      -- Ethernet 0
      m_tx_d_from_the_tse_mac   => eth1_tx,
      m_tx_en_from_the_tse_mac  => eth1_tx_en,
      mdc_from_the_tse_mac      => eth1_mdc,
      mdio_oen_from_the_tse_mac => eth1_mdio_oen,
      mdio_out_from_the_tse_mac => eth1_mdio_out,
      m_rx_col_to_the_tse_mac   => eth1_col,
      m_rx_crs_to_the_tse_mac   => eth1_crs,
      m_rx_d_to_the_tse_mac     => eth1_rxd,
      m_rx_en_to_the_tse_mac    => eth1_rx_dv,
      m_rx_err_to_the_tse_mac   => eth1_rx_er,
      mdio_in_to_the_tse_mac    => eth1_mdio_in,
      rx_clk_to_the_tse_mac     => eth1_rx_clk,
      set_1000_to_the_tse_mac   => '0',
      set_10_to_the_tse_mac     => '1',
      tx_clk_to_the_tse_mac     => eth1_tx_clk,

      gm_rx_d_to_the_tse_mac   => (others => '0'),
      gm_rx_dv_to_the_tse_mac  => '0',
      gm_rx_err_to_the_tse_mac => '0',

      protection_analog_data_input_to_the_sv_packet_processor_0 => sample_quality(511 downto 0),
      protection_analog_data_ready_to_the_sv_packet_processor_0 => not(sample_quality_available),
      monitoring_analog_data_input_to_the_sv_packet_processor_0 => x"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
      monitoring_analog_data_ready_to_the_sv_packet_processor_0 => '1',
      pps_to_the_sv_packet_processor_0                          => not(virtual_pps_4800),
      sysclk_to_the_sv_packet_processor_0                       => sysclk,
      sv_packet_processor_0_conduit_end_irig_status             => "000000" & smp_sync,
      protection_analog_data_input_to_the_sv_packet_processor_1 => sample_quality(1023 downto 512),
      protection_analog_data_ready_to_the_sv_packet_processor_1 => not(sample_quality_available),
      monitoring_analog_data_input_to_the_sv_packet_processor_1 => x"CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
      monitoring_analog_data_ready_to_the_sv_packet_processor_1 => '1',
      pps_to_the_sv_packet_processor_1                          => not(virtual_pps_4800),
      sysclk_to_the_sv_packet_processor_1                       => sysclk,
      sv_packet_processor_1_conduit_end_irig_status             => "000000" & smp_sync,

      irig_decode_conduit_end_irig_ok   => irig_ok,
      irig_decode_conduit_end_t_mark    => t_mark,
      irig_decode_conduit_end_irig      => optical_in,
      irig_decode_conduit_end_sync_irig => sync_irig,
      irig_decode_conduit_end_sysclk    => sysclk,

      pps_external_connection_export => t_mark,

      opencores_i2c_0_export_0_scl_pad_io => scl,
      opencores_i2c_0_export_0_sda_pad_io => sda,

      gain_registers_0_conduit_end_sysclk         => sysclk,
      gain_registers_0_conduit_end_data_ready     => calibrated_data_ready,
      gain_registers_0_conduit_end_data_output    => calibrated_data,
      gain_registers_0_conduit_end_data_available => ready_data,
      gain_registers_0_conduit_end_data_input     => d_ana,

      shuffler_0_conduit_end_out => shuffler_out,
      shuffler_0_conduit_end_in  => mdat1 & mdat0,

      sample_adjust_0_conduit_end_data_out          => adjusted_data,
      sample_adjust_0_conduit_end_data_out_ready    => adjusted_data_available,
      sample_adjust_0_conduit_end_data_in_available => phase_sum_boards_data_ready,
      sample_adjust_0_conduit_end_sysclk            => sysclk,
      sample_adjust_0_conduit_end_data_in           => phase_sum_data_io,

      link_eth_external_connection_export => link_eth,

      tse_mac_linux_conduit_connection_gm_rx_d   => (others => '0'),
      tse_mac_linux_conduit_connection_gm_rx_dv  => '0',
      tse_mac_linux_conduit_connection_gm_rx_err => '0',
      tse_mac_linux_conduit_connection_m_rx_d    => eth0_rxd,
      tse_mac_linux_conduit_connection_m_rx_en   => eth0_rx_dv,
      tse_mac_linux_conduit_connection_m_rx_err  => eth0_rx_er,
      tse_mac_linux_conduit_connection_m_tx_d    => eth0_tx,
      tse_mac_linux_conduit_connection_m_tx_en   => eth0_tx_en,
      tse_mac_linux_conduit_connection_m_rx_col  => eth0_col,
      tse_mac_linux_conduit_connection_m_rx_crs  => eth0_crs,
      tse_mac_linux_conduit_connection_tx_clk    => eth0_tx_clk,
      tse_mac_linux_conduit_connection_rx_clk    => eth0_rx_clk,
      tse_mac_linux_conduit_connection_set_10    => '1',
      tse_mac_linux_conduit_connection_set_1000  => '0',
      tse_mac_linux_conduit_connection_mdio_oen  => eth0_mdio_oen,
      tse_mac_linux_conduit_connection_mdio_out  => eth0_mdio_out,
      tse_mac_linux_conduit_connection_mdio_in   => eth0_mdio_in,
      tse_mac_linux_conduit_connection_mdc       => eth0_mdc,

      analog_sample_register_conduit_end_data_available_i => adjusted_data_available,
      analog_sample_register_conduit_end_data_i           => adjusted_data,
      analog_sample_register_conduit_end_pps_edge_i       => t_mark_edge,
      analog_sample_register_conduit_end_clk              => sysclk,

      digital_register_0_conduit_end_data_input_available     => digital_available,
      digital_register_0_conduit_end_sysclk                   => sysclk,
      digital_register_0_conduit_end_data_input               => "0000" & d_dig & d_mon,
      digital_register_0_conduit_end_data_output(7 downto 0)  => trip0,
      digital_register_0_conduit_end_data_output(15 downto 8) => trip1,

      nom_freq_sel_0_conduit_end_freq_80_o              => freq_80,
      nom_freq_sel_0_conduit_end_step_low_80_o          => step_low_80,
      nom_freq_sel_0_conduit_end_step_normal_80_o       => step_normal_80,
      nom_freq_sel_0_conduit_end_freq_default_std_80_o  => freq_default_std_80,
      nom_freq_sel_0_conduit_end_k_default_std_80_o     => k_default_std_80,
      nom_freq_sel_0_conduit_end_freq_256_o             => freq_256,
      nom_freq_sel_0_conduit_end_step_low_256_o         => step_low_256,
      nom_freq_sel_0_conduit_end_step_normal_256_o      => step_normal_256,
      nom_freq_sel_0_conduit_end_freq_default_std_256_o => freq_default_std_256,
      nom_freq_sel_0_conduit_end_k_default_std_256_o    => k_default_std_256,
      nom_freq_sel_0_conduit_end_sync_reset_o_n         => sync_reset_n,
      nom_freq_sel_0_conduit_end_sysclk                 => sysclk,

      phase_sum_board1_data_io_board_input  => phase_sum_board1_data_io_board_input,
      phase_sum_board1_data_io_board_output => phase_sum_board1_data_io_board_output,
      phase_sum_board2_data_io_board_input  => phase_sum_board2_data_io_board_input,
      phase_sum_board2_data_io_board_output => phase_sum_board2_data_io_board_output,
      phase_sum_board1_data_ready_io_in     => calibrated_data_ready,
      phase_sum_board1_data_ready_io_out    => phase_sum_board1_data_ready,
      phase_sum_board2_data_ready_io_in     => calibrated_data_ready,
      phase_sum_board2_data_ready_io_out    => phase_sum_board2_data_ready,
      phase_sum_board1_sysclk_export        => sysclk,
      phase_sum_board2_sysclk_export        => sysclk,

	  watchdog_instrument_0_coe_alarm_export            => alarm_instrument_linux,

	  alarm_led_from_linux_external_connection_export   => alarm_led_from_linux,
      relay_alarm_from_linux_external_connection_export => alarm_n_int      );


  phase_sum_board1_data_io_board_input <= calibrated_data(127 downto 0);
  phase_sum_board2_data_io_board_input <= calibrated_data(255 downto 128);
  phase_sum_data_io                    <= (phase_sum_board2_data_io_board_output & phase_sum_board1_data_io_board_output);
  phase_sum_boards_data_ready          <= (phase_sum_board1_data_ready and phase_sum_board2_data_ready);



  reset_generator_inst : entity work.reset_generator  -- generates reset
    port map(
      sysclk     => clock_100mhz,
      n_hw_reset => reset_n,
      n_reset    => reset_int_n
      );

  synchronization_2 : entity work.synchronization
    port map (
      pps            => t_mark,
      n_reset        => reset_int_n and sync_reset_n,
      sysclk         => sysclk,
      irig_ok        => irig_ok,
      freq_out_80    => sync_soc,
      virtual_pps_80 => virtual_pps_4800,
      enable_pps     => irig_ok,
      -- selecao de frequencia
      freq_in_80                   => freq_80,
      freq_in_256                  => freq_256,
      frequency_default_std_in_80  => freq_default_std_80,
      frequency_default_std_in_256 => freq_default_std_256,
      k_default_std_in_80          => k_default_std_80,
      k_default_std_in_256         => k_default_std_256,
      step_low_in_80               => step_low_80,
      step_low_in_256              => step_low_256,
      step_normal_in_80            => step_normal_80,
      step_normal_in_256           => step_normal_256

      );


  acquisition_inst_0 : entity work.acquisition
    port map (
      sysclk            => sysclk,
      n_reset           => reset_int_n,
      sync_soc          => sync_soc,
      mclk              => freq_mclk,
      mdat              => shuffler_out,
      qdi_demux         => d_mux,
      qdi_din           => din1 & din0,
      goose_in          => d_goose,
      en                => '1',
      d_ana             => d_ana,
      d_dig             => d_dig,
      d_mon             => d_mon,
      d_goose           => d_goose,
      digital_available => digital_available,
      goose_available   => goose_available,
      ready_data        => ready_data); 

  quality_inst_0 : entity work.quality
    port map (
      sysclk            => sysclk,
      reset_n           => reset_int_n,
      data_in           => adjusted_data,
      data_in_available => adjusted_data_available,
      data_out_ready    => sample_quality_available,
      data_out          => sample_quality);

  edge_detector_inst_0 : entity work.edge_detector
    port map (
      n_reset  => reset_int_n,
      sysclk   => sysclk,
      f_in     => t_mark,
      pos_edge => t_mark_edge);

  sync_verify_inst_0 : entity work.sync_verify
    port map (
      reset_n   => reset_int_n,
      sysclk    => sysclk,
      sync_irig => sync_irig,
      smp_sync  => smp_sync);

  backplane_leds_inst_0 : entity work.backplane_leds
    port map (
      reset_n                   => reset_int_n,
      sysclk                    => sysclk,
      link_eth_0                => link_eth(0),
      link_eth_1                => link_eth(1),
      sync_irig                 => smp_sync,
      backplane_leds_out        => backplane_leds_reg,
      watchdog_instrument_alarm => alarm_instrument_linux,
      alarm_led                 => alarm_led_from_linux
      );

  alarm_n <= (alarm_instrument_linux nor alarm_n_int);


  


  
end mu320_struct;
