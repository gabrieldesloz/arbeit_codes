----------------------------------------------------------------------------------
-- Company: Buhler-SANMAK
-- Engineer: A.Einsfeldt
--				 C.E.Bertagnolli
--
-- Create Date:    14:04:46 07/21/2010 
-- Design Name: 
-- Module Name:    MAIN - Behavioral 
-- Project Name: 
-- Target Devices: SP6 XC6SLX16
-- Tool versions: 
-- Description: CCD camera control board
--
-- Dependencies: 
--
-- Revision: 
--  23/Fev/2011 0.01 - Same version as version L8 mono 00.79 	- 	reflecta   = reflecta_color1
--																						reflectar  = reflectar_color2
--																						transluca  = reflecta_color2
--																						translucar = reflectar_color1
--  23/Fev/2011 0.02 - Read out from memories correct data (Transluscency and reflectancy from rear 
--																				camera are exchanged)
--							  Flags extra(2) and extra(3) doesn't exist anymore
--  06.11.2013  0.03 - Ejectors Alarm information exchanged
--  18.11.2013  0.04 - Main board detector reactivated
--							- Lowered cuttof ejections from 3000 to 900 (Higher dwell time for coffee means 
--							  less ejections per minute)
--							- X and Y cloud gains sequence corrected
--  18.11.2013  0.05 - Only valid pixel to generate the mean
--  27.02.2014  0.06 - Corrected problems with overusage flags that were not correctly used
--  02.06.2014  0.07 - Second delay signal for ellipsis 7
--
-- Additional Comments: 
--    1) much of this project comes from first version of CC machine using XC3S200 device
--    2) this board control 4 cameras and two chutes: each chute has one front and one rear camera
--    3) chute in the left is side A handled by ADC1, CCD1 front, CCD2 rear.
--    4) chute in the right is side B handled by ADC2, CCD3 front, CCD4 rear
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity MAIN is
    Port ( 
	 -- AD9822 interface
	        ADC1 : in  STD_LOGIC_VECTOR (7 downto 0);
           ADC1_OEB : out  STD_LOGIC;
           ADC1_CLK1 : out  STD_LOGIC;
           ADC1_CLK2 : out  STD_LOGIC;
           ADC1_CLK : out  STD_LOGIC;
		   ADC1_SDATA : inout std_logic;
		   ADC1_SCLK : inout std_logic;
		   ADC1_SLOAD : inout std_logic;
			  
           ADC2 : in  STD_LOGIC_VECTOR (7 downto 0);
           ADC2_OEB : out  STD_LOGIC;
           ADC2_CLK1 : out  STD_LOGIC;
           ADC2_CLK2 : out  STD_LOGIC;
           ADC2_CLK : out  STD_LOGIC;
			  ADC2_SDATA : inout std_logic;
			  ADC2_SCLK : inout std_logic;
			  ADC2_SLOAD : inout std_logic;
	 -- CCD interface
           CCD_DIS1,CCD_DIS2,CCD_DIS3,CCD_DIS4 : out std_logic; -- DIS <= reset
           CCD_CLK1,CCD_CLK2,CCD_CLK3,CCD_CLK4 : out std_logic; -- processo 1
		   CCD_SI1,CCD_SI2,CCD_SI3,CCD_SI4 : out std_logic; -- flag_si,   -- if pix=X"FF" then flag_si<='1';
	 -- Illumination interface	 
           FLEDA : out std_logic; -- Side A, Frontal, LED A -- ledout
           FLEDB : out std_logic; -- Side A, Frontal, LED B 
           FLEDc : out std_logic; -- Side B, Frontal, LED A 
           FLEDD : out std_logic; -- Side B, Frontal, LED B 
           RLEDA : out std_logic; -- Side A, Rear, LED A 
           RLEDB : out std_logic; -- Side A, Rear, LED B 
           RLEDC : out std_logic; -- Side B, Rear, LED A 
           RLEDD : out std_logic; -- Side B, Rear, LED B 
			  EN_BACK : out std_logic; -- Enable background LEDs (ON when '1')
	 -- Ejector interface
           EJA_CK, EJA_TX : inout std_logic; -- clock and data out for Ejector group A	 
			  EJA_RX : in std_logic;
           EJB_CK, EJB_TX : out std_logic; -- clock and data out for Ejector group B	 
			  EJB_RX : in std_logic;
	 -- sincronization interface
           TSINC1,TSINC2 :	out std_logic; -- inter board sinchronization outputs
           RSINC1,RSINC2 :	in std_logic; -- inter board sinchronization inputs
	 -- user inteface and debug
           LED1,LED2	:	inout std_logic; --
			  CH1 : in std_logic;
			  CONF : inout STD_LOGIC_VECTOR (7 downto 0); -- configuration jumpers (zero when inserted)
			  TEST: inout STD_LOGIC_VECTOR (15 downto 0);
	 -- system
           CLK37 : in std_logic; -- 37.5MHz input
           LED_RESET : in std_logic; -- signals the LED Enable buffer is on RESET state (disabled)			  
    -- microcontroler interface
	        LDATA : inout STD_LOGIC_VECTOR (15 downto 0);
			  LADDR : in STD_LOGIC_VECTOR (4 downto 0);
			  LCLKL : in std_logic;
			  LFRAME : in std_logic;
			  LWR : in std_logic;
			  LRD : in std_logic;
			  
			  FPGA_RSTCOM : in std_logic;
			  FPGA_BUSYCOM : out std_logic;
			  
			  L_RX : out std_logic; -- serial output to Luminary
			  L_TX : in std_logic; -- serial input from Luminary
			  L_IO : inout std_logic_vector (1 downto 0);
			  
	 -- SRAM interface		  
	        MDATA : inout STD_LOGIC_VECTOR (15 downto 0);
			  MADDR : out STD_LOGIC_VECTOR (17 downto 0);
			  MOE : out std_logic;
			  MCS : out std_logic;
			  MWR : out std_logic;
	 -- FLASH interface (also used for FPGA configuration)
           F_Q : inout std_logic;
           F_C : inout std_logic; 
           F_D : inout std_logic; 
           F_S : inout std_logic
			);
end MAIN;

architecture Behavioral of MAIN is

-- **************************************************************************************************************
-- **************************************************************************************************************
-- system constants
constant FPGA_version : std_logic_vector (15 downto 0) := X"0007"; -- 00.07
-- **************************************************************************************************************
-- **************************************************************************************************************

-- system signals ---------------------------------------------------
signal reset,clk,clkfx,clkfx180,clkfxdv : std_logic;
signal clkx,clkz,clkxxx,clkxx,clk2x : std_logic :='0';
signal ck1us,ckaa ,clkaq,c20us,chopvalve,c1us: std_logic;
signal clk37mux,clksel : std_logic;
signal lreset,monoreset,dcmrst: std_logic;

SIGNAL resetext,xf1,xf2 : std_logic;

-- synchronization between boards

signal sincin, sincout,clrsinc : std_logic;

-- project signals --------------------------------------------------

-- ejector driver interface & data
signal ejapkt,ejbpkt : std_logic_vector (34 downto 0);
signal ejatxdata,ejbtxdata : std_logic_vector (31 downto 0); -- working sorting vector
signal txsa,txsb,rxsa,rxsb : std_logic_vector (35 downto 0);
signal rxpara, rxparb : std_logic;

type ejtype is array (7 downto 0) of std_logic_vector (31 downto 0);
signal ejdt0,ejdt1 : ejtype;
signal rteja,rtejb : integer range 0 to 7;

signal qejet : integer range 0 to 31;
signal do_testejeta,do_testejetb : std_logic; -- ejside select which chute it will make TestEject
signal tjet : std_logic_vector (31 downto 0); -- test

signal wcom : std_logic_vector (2 downto 0);
signal wejt : std_logic_vector (31 downto 0); 

signal ispaca,ispacb,rqpaca,rqpacb,clrpaca,clrpacb : std_logic;

-- synch circuit
signal sincperiodb,sincperiod: std_logic_vector (8 downto 0);
signal sincperiod_el_7,sincperiodb_el_7: std_logic_vector (8 downto 0);

-- Analog Front End 
signal afec : std_logic_vector (15 downto 0);
signal afedata : std_logic_vector (8 downto 0);
signal afeaddr : std_logic_vector (2 downto 0);
signal afen : std_logic;
signal sendafe, afesent : std_logic;
signal afeck, afeck0, afeck2 : std_logic;			  
Signal ccd1,ccd2,ccd3,ccd4,ccdt1,ccdt2 : std_logic_vector (15 downto 0); -- pixel data for each camera

-- Front End state machine
signal extevent_req,extevent_flag,extevent,extclr,exttype : std_logic;
signal extevent_reqf,extevent_flagf,exteventf,extclrf : std_logic; -- FIFO related
signal extpart : std_logic_vector (1 downto 0); -- 00:cam_A front, 01: cam_A rear, 10:cam_B front, 11:cam_B rear
signal extpartf : std_logic_vector (2 downto 0); -- to read the FIFO by MMI
signal extaddr : std_logic_vector (10 downto 0);
signal extaddrd : std_logic_vector (10 downto 0);
signal extaddrw : std_logic_vector (10 downto 0);
signal extaddre : std_logic_vector (10 downto 0);
signal extaddrf : std_logic_vector (10 downto 0);
signal extdata,extdataread,extdatareadf,extdatareadot : std_logic_vector (15 downto 0);
signal addr_fifo_a,addr_fifo_b: std_logic_vector (10 downto 0);
signal mpix,pix : std_logic_vector (7 downto 0);-- Pixel counter
signal bmpix,apix : std_logic_vector (7 downto 0);-- Pixel counter
signal dmpix,cpix : std_logic_vector (7 downto 0);-- Pixel counter
signal rled_counter, led_counter : std_logic_vector (1 downto 0);
signal floor,extfloor,floorx : std_logic;
signal ad1,ad2 : std_logic_vector (1 downto 0);
signal ad3,ad4,dt1,dt2,dt3,dt4 : std_logic;
signal proc : std_logic_vector (2 downto 0); -- scan line source for ALU process
signal acc,accb,acc2,acc2b,racc,raccb,racc2,racc2b : std_logic_vector (15 downto 0); -- ACCumulator and register for ALU
signal ma,mab,ma2,ma2b : std_logic_vector (15 downto 0); -- multiplier input
signal mp,mpb,mp2,mp2b : std_logic_vector (31 downto 0); -- multiplier out
signal multipmux : std_logic; 

signal ggain_bckA,ggain_imageA,ggain_imageB : std_logic_vector (15 downto 0); -- multiplier factor
signal ggain_bckB: std_logic_vector (15 downto 0); -- multiplier factor

signal fifoline,fifolinew,s_fifolinew_new,s_fifoline_last : std_logic_vector (2 downto 0); -- points the previous line and current line being written on FIFO

signal a,ab,a2,a2b : std_logic_vector (15 downto 0);

-- data memory interface
signal CLKA,clkb : STD_LOGIC;
signal CLKAb,clkbb : STD_LOGIC;
signal wena,wenab,wena2,wena2b :std_logic_VECTOR(0 downto 0);
signal DATAA,datab : STD_LOGIC_VECTOR (15 downto 0);
signal DATAA2,datab2 : STD_LOGIC_VECTOR (15 downto 0);
signal DATAAb,databb : STD_LOGIC_VECTOR (15 downto 0);
signal DATAA2b,datab2b : STD_LOGIC_VECTOR (15 downto 0);
signal ADDRA,addrb : STD_LOGIC_VECTOR (10 downto 0);
signal rADDRA,raddrab : STD_LOGIC_VECTOR (10 downto 0);
signal ADDRAb,addrbb : STD_LOGIC_VECTOR (10 downto 0);

-- FIFO memory interface
signal addrfifo, addrfifo_bgnd_front, addrfifo_bgnd_rear, addrfifo_camrear : std_logic_vector (10 downto 0); -- FIFO write address
signal addrbfA,addrbfB : std_logic_vector (10 downto 0); -- FIFO read address both chutes
signal data_raf,data_raf_camrear,data_rar,data_rab,data_rab_rear,data_rbf,data_rbf_camrear,data_rbr,data_rbb,data_rbb_rear : std_logic_vector (15 downto 0); -- FIFO read data
signal data_af,data_bf : std_logic_vector (15 downto 0); -- FIFO write data
signal clkbf : std_logic; -- FIFO read clock
signal wenaf_f,wenaf_r,wenaf_b, wenaffl : std_logic_VECTOR(0 downto 0); -- FIFO write clock enable
signal canincfifoline : std_logic;

-- DOT memory interface
signal clkbd : std_logic;
signal addrdotwa,addrdotwb,addrdotr : std_logic_vector (10 downto 0); 
signal wendota,wendotb: std_logic_VECTOR(0 downto 0);
signal data_dra,data_drb,data_dwa,data_dwb : std_logic_vector (15 downto 0);
signal extevent_reqd,extevent_flagd,exteventd,extclrd : std_logic; -- external access
signal dottriggb,dottrigga : std_logic_vector (7 downto 0);
signal dottriggb2,dottrigga2 : std_logic_vector (7 downto 0);
signal dotconta,dotcontb : std_logic_vector (7 downto 0);
signal dotfla,dotflb : std_logic;

-- sorting process
type tabejet is array (255 downto 0) of std_logic_VECTOR(4 downto 0); 
type tabdef is array (7 downto 0) of std_logic_VECTOR(7 downto 0); 
type sorttype is array (31 downto 0) of std_logic_VECTOR(2 downto 0); 
type flagtype is array (31 downto 0) of std_logic; 

signal sorta,sortb  : sorttype; -- ejector signals before sych memory
signal shot_1a,shot_2a,shot_3a,shot_4a,shot_5a,shot_6a,shot_7a : std_logic_vector (2 downto 0);
signal shot_1b,shot_2b,shot_3b,shot_4b,shot_5b,shot_6b,shot_7b : std_logic_vector (2 downto 0);
signal pixstarta,pixstartb,pixenda,pixendb : std_logic_vector (7 downto 0);
signal npox,pox : std_logic_vector (7 downto 0); -- pixel scan on FIFO reading

signal sortst : std_logic_vector (27 downto 0);
signal reflecta_color1,reflectb_color1,reflectar_color1,reflectbr_color1 : std_logic_vector (7 downto 0);
signal reflecta_color2,reflectb_color2,reflectar_color2,reflectbr_color2 : std_logic_vector (7 downto 0);
signal bkgndfa,bkgndfb,bkgndfar,bkgndfbr : std_logic_vector (7 downto 0);
signal inx,inxg,inxgb: std_logic_vector (2 downto 0);
signal nejeta,nejetb,ejeta,ejetb: std_logic_vector (4 downto 0);
signal defcont_addra,defcont_addrb : std_logic_vector (7 downto 0);
signal wconta,rconta,wcontb,rcontb : std_logic_vector (7 downto 0);
signal flagea,flageb : flagtype;
signal flagxa,flagxb : flagtype; -- test for defect found in the channel
signal oldflagxa, oldflagxb : std_logic;
signal tabejeta,tabejetb : tabejet; -- table to convert pixel to ejector
signal seteja,setejb : tabdef; -- table of number of defects per ellipse

signal ellip_addra,ellip_addrb : std_logic_vector (10 downto 0);
signal ellip_addrar,ellip_addrbr : std_logic_vector (10 downto 0);
signal ellipa,ellipb : std_logic_vector (15 downto 0); -- ellipse values read from ellipse memory
signal ellipar,ellipbr : std_logic_vector (15 downto 0); -- ellipse values read from ellipse memory
signal wenellipa,wenellipb : std_logic_VECTOR(0 downto 0);
signal clkbellip : std_logic;

signal trigga,triggb : std_logic;
signal triggar,triggbr : std_logic;
signal trigmema,trigmemb : std_logic_VECTOR(31 downto 0);  -- store if a trigger has happened during an ejector range
signal wdefena,wdefenb : std_logic;

signal extellipeva,clrellia,extellia : std_logic;
signal extellipevb,clrellib,extellib : std_logic;

signal ellipay1,ellipay2: std_logic_vector (7 downto 0);
signal ellipby1,ellipby2: std_logic_vector (7 downto 0);
signal ellipay1r,ellipay2r: std_logic_vector (7 downto 0);
signal ellipby1r,ellipby2r: std_logic_vector (7 downto 0);
signal setejav,setejbv : std_logic_vector (7 downto 0);

signal adwell1,adwell2,adwell3,adwell4,adwell5,adwell6,adwell7 : std_logic_vector (7 downto 0);
signal bdwell1,bdwell2,bdwell3,bdwell4,bdwell5,bdwell6,bdwell7 : std_logic_vector (7 downto 0);

signal ellclka,ellclkb : std_logic;
signal entriga,entrigb : std_logic;
signal entrigar,entrigbr : std_logic;

signal dotflra,dotflrb : std_logic;
signal dotcontra,dotcontrb : std_logic_vector (7 downto 0);

signal graline : std_logic_vector (6 downto 0);
signal graddrx : std_logic_vector (16 downto 0);
signal grabbed,grabdata : std_logic_vector (15 downto 0);
signal s_grabdata_out : std_logic_vector(15 downto 0);
signal wasgrabbed,gograb,askgrab,cangrab,grabend,setaskgrab,setgograb,mselect,askans : std_logic;

signal sort_case_a  : std_logic_vector (6 downto 0);
signal sort_case_b  : std_logic_vector (6 downto 0);
signal rcont_bg_set_A,set_eq_0_A,inside_ellip_A,inside_ellip_r_A : std_logic;
signal rcont_bg_set_B,set_eq_0_B,inside_ellip_B,inside_ellip_r_B : std_logic;



-- illumination interface
signal LED_duration,LED_duration_bckgnd,LED_duration_front,LED_duration_rear : STD_LOGIC_VECTOR (7 downto 0);
signal led_duration_a, led_duration_b,led_duration_C, led_duration_D : STD_LOGIC_VECTOR (7 downto 0);
signal ilum : STD_LOGIC_VECTOR (11 downto 0);
signal ledout,ledseq : STD_LOGIC_VECTOR (2 downto 0);
signal trledf,trledr,tfledf,tfledr : std_logic_vector (2 downto 0);

---------------------------------------------------------------------
--------------------- SRAM interface controller ---------------------
---------------------------------------------------------------------
signal s_release_line_inc_counter : std_logic;
signal s_writing_sram, s_sram_written, s_writing_sram_active, s_writing_sram_int : std_logic;
signal s_reading_sram, s_sram_read, s_reading_sram_active, s_reading_sram_int : std_logic;
signal s_sram_sector, s_grab_sector : std_logic_vector(2 downto 0);
signal s_sram_line, s_grabline : std_logic_vector(6 downto 0);
signal s_last_pox : std_logic_vector(7 downto 0);
signal s_sram_input_data, s_sram_output_data : std_logic_vector(15 downto 0);
signal s_ramdata_0, s_ramdata_1, s_ramdata_2, s_ramdata_3, s_ramdata_4, s_ramdata_5, s_ramdata_6, s_ramdata_7 : std_logic_vector(15 downto 0);
signal s_sram_wr_addr, s_sram_rd_addr : std_logic_vector(17 downto 0);
signal s_sram_int_rd_addr : std_logic_vector(17 downto 0);
signal s_grab_a_or_b, s_debug_or_normal : std_logic;
---------------------------------------------------------------------

-- debug/interfacing data
signal debdeb, debdebb ,debadd,debug002 : std_logic;

signal ndump,andump,rqdumparea,arqdumparea,ndumpf, s_grabpix : std_logic_vector(7 downto 0);
signal extra: std_logic_vector(7 downto 0); -- bit 0:clear Dot A, bit 1:clear Dot B, bit 6:Enable sorting A, bit 7:en sort B
signal debugsel: std_logic_vector (3 downto 0);

signal deb_trans,deb_refle,deb_reflec,deb_y1,deb_y2 : std_logic_vector(7 downto 0);
signal deb_transb,deb_refleb,deb_reflecb,deb_y1b,deb_y2b : std_logic_vector(7 downto 0);
signal is_there_a_hit, is_there_b_hit : std_logic;
signal debug000 : std_logic;

signal got_dwell, got_delayb, got_delay : std_logic_vector(7 downto 0);

signal inside_ellip_r_Am, inside_ellip_r_Bm, inside_ellip_Am, inside_ellip_Bm, rcont_bg_set_Am, rcont_bg_set_Bm: std_logic;


-- microcontroller interface specific signals
signal microden,busy_flag,busy_clr,read_clr,halfrd,halfclr,busy_flag_pre: std_logic;
signal status_reg,cmd_reg,data_wr,data_rd : std_logic_vector (15 downto 0);
signal comrst,clr_cmd,comrstrq : std_logic;
signal datasel : std_logic_vector(1 downto 0);
signal rasc1com : std_logic_vector(2 downto 0);
signal rascl,rasch : std_logic_vector(15 downto 0);
signal rsc1chute : std_logic;
signal ext3bf : std_logic_vector(2 downto 0);
signal lckk,lclk : std_logic;
signal delayshoot : std_logic_vector(7 downto 0);
signal lumstp,lumstpd : std_logic_vector(11 downto 0);

-- Flags indicating if the FPGA configurations are not default anymore
signal s_already_conf_flag : std_logic_vector(14 downto 0); 
signal s_AFE_confirm_A, s_AFE_confirm_B : std_logic_vector(1 downto 0);
signal s_FE_confirm_A, s_FE_confirm_B : std_logic_vector(3 downto 0);
signal s_sinc_confirm_A, s_sinc_confirm_B : std_logic;
signal s_trip_confirm_A, s_trip_confirm_B : std_logic;
signal s_boundaries_start_confirmation_A, s_boundaries_start_confirmation_B : std_logic;
signal s_boundaries_end_confirmation_A, s_boundaries_end_confirmation_B : std_logic;
signal s_tab_confirm_A, s_tab_confirm_B : std_logic;
signal s_def_confirm_A, s_def_confirm_B : std_logic_vector(6 downto 0);
signal s_ellip_confirm_A, s_ellip_confirm_B : std_logic_vector(6 downto 0);
signal s_image_gain_confirmation_A, s_image_gain_confirmation_B : std_logic;
signal s_static_bgnd_confirmation_A, s_static_bgnd_confirmation_B : std_logic;
signal s_bgnd_confirm_A, s_bgnd_confirm_B : std_logic_vector(1 downto 0);

-- statistics
signal ndumpdsm, ndumpsm : std_logic_vector(5 downto 0); --Picture insertion
signal s_EJ_CNT_o : std_logic_vector(15 downto 0);

-- product peak detector
signal s_triggenda,s_triggendb : std_logic;

-- New Test ejet 
signal s_tejet_chute : std_logic;
signal s_istestejet : std_logic;
signal s_tejet_dwell : std_logic_vector (9 downto 0);
signal s_tejetbuff : std_logic_vector (31 downto 0);

-- External Access
signal exteventag, exteventag_req : std_logic;
signal extclrag : std_logic;
signal extpartag : std_logic;
signal s_extcam : std_logic;
signal s_ref_or_trans : std_logic;

-- Mean 16k 
signal s_has_new, s_cansum : std_logic;
signal s_is_transluc, s_is_reflect : std_logic_vector (0 downto 0);
signal s_acc_in : std_logic_vector (63 downto 0);
signal s_CLR_MEAN_A, s_CLR_MEAN_B, s_CLR_MEAN_COMMAND_A, s_CLR_MEAN_COMMAND_B, s_CLR_MEAN_OFF : std_logic;
signal exteventag_flag : std_logic;
signal extdatareadag : std_logic_vector(15 downto 0);
signal s_illum_a, s_illum_b : std_logic_vector (63 downto 0);
signal s_acc_valid, s_accb_valid, s_acc2_valid, s_acc2b_valid : std_logic_vector (255 downto 0);

signal s_ext_mux : std_logic_vector (2 downto 0);

-- Pseudo-random
signal s_ch_in00_i, s_ch_in01_i, s_ch_in02_i, s_ch_in03_i, s_ch_in04_i, s_ch_in05_i, s_ch_in06_i, s_ch_in07_i : std_logic_vector (2 downto 0);
signal s_ch_in08_i, s_ch_in09_i, s_ch_in10_i, s_ch_in11_i, s_ch_in12_i, s_ch_in13_i, s_ch_in14_i, s_ch_in15_i : std_logic_vector (2 downto 0);
signal s_ch_in16_i, s_ch_in17_i, s_ch_in18_i, s_ch_in19_i, s_ch_in20_i, s_ch_in21_i, s_ch_in22_i, s_ch_in23_i : std_logic_vector (2 downto 0);
signal s_ch_in24_i, s_ch_in25_i, s_ch_in26_i, s_ch_in27_i, s_ch_in28_i, s_ch_in29_i, s_ch_in30_i, s_ch_in31_i : std_logic_vector (2 downto 0);

signal s_ch_in32_i, s_ch_in33_i, s_ch_in34_i, s_ch_in35_i, s_ch_in36_i, s_ch_in37_i, s_ch_in38_i, s_ch_in39_i : std_logic_vector (2 downto 0);
signal s_ch_in40_i, s_ch_in41_i, s_ch_in42_i, s_ch_in43_i, s_ch_in44_i, s_ch_in45_i, s_ch_in46_i, s_ch_in47_i : std_logic_vector (2 downto 0);
signal s_ch_in48_i, s_ch_in49_i, s_ch_in50_i, s_ch_in51_i, s_ch_in52_i, s_ch_in53_i, s_ch_in54_i, s_ch_in55_i : std_logic_vector (2 downto 0);
signal s_ch_in56_i, s_ch_in57_i, s_ch_in58_i, s_ch_in59_i, s_ch_in60_i, s_ch_in61_i, s_ch_in62_i, s_ch_in63_i : std_logic_vector (2 downto 0);

signal s_adwell1, s_bdwell1 : std_logic_vector (9 downto 0);
signal s_ejet : std_logic_vector (31 downto 0);

-- Sort case block
signal s_SHOT_X_A, s_SHOT_X_b : std_logic_vector (2 downto 0);
signal s_WCONTA, s_WCONTB : std_logic_vector (7 downto 0);

----------------------------------
-- multiplier input multiplexer -- 
----------------------------------
-- Multiplexer signals
signal s_bkgnd_mult : std_logic;
signal s_ma_mux, s_ma2_mux, s_mab_mux, s_ma2b_mux : std_logic_vector(15 downto 0);
signal s_bkgnd_ma_gain, s_bkgnd_ma2_gain, s_bkgnd_mab_gain, s_bkgnd_ma2b_gain : std_logic_vector(15 downto 0);

-- Memory signals
signal s_ma_we, s_ma2_we, s_mab_we, s_ma2b_we : std_logic_vector(0 downto 0);
signal s_bckgnd_gain_wr_addr : std_logic_vector(7 downto 0);
signal s_bckgnd_gain_data_in : std_logic_vector(15 downto 0);
signal s_ma_gain_mem_out, s_ma2_gain_mem_out, s_mab_gain_mem_out, s_ma2b_gain_mem_out : std_logic_vector(15 downto 0);

-- Interface signals
signal s_extevent_bckgnd_gain, s_extevent_bckgnd_gain_req, s_extclr_bckgnd_gain, s_extevent_bckgnd_gain_flag : std_logic;
signal s_bckgnd_mem_Sel : std_logic_vector(1 downto 0);

-- Select chute bit
signal s_capture_chute : std_logic;
----------------------------------
------ Luminary bench debug ------
----------------------------------
signal s_cmd_last, s_cmd_last_1, s_cmd_last_2, s_cmd_last_3, s_cmd_last_4 : std_logic_vector(7 downto 0);
signal s_lumcmd_last, s_lumcmd_last_1, s_lumcmd_last_2, s_lumcmd_last_3, s_lumcmd_last_4 : std_logic_vector(7 downto 0);

signal s_cmd_others, s_cmd_others_1, s_cmd_others_2 : std_logic_vector(7 downto 0);
signal s_lumstp_last : std_logic_vector(11 downto 0);

signal s_max_active_counter : std_logic_vector(15 downto 0);

----------------------------------
------ Overusage clear flag ------
----------------------------------
signal s_overusage_clr_a, s_overusage_clr_b : std_logic;
signal s_overusage_a, s_overusage_b : std_logic_vector(31 downto 0);
--probe
signal s_probe : std_logic_vector(15 downto 0);

signal s_en_ej_a, s_en_ej_b, s_has_overusage_a, s_has_overusage_b, s_overusage_int_a, s_overusage_int_b, s_has_overusage_clr: std_logic;

-- Only for coffee
signal s_overusage_a_coffee_int, s_overusage_b_coffee_int : std_logic;
signal s_overusage_a_coffee, s_overusage_b_coffee : std_logic_vector(11 downto 0);

----------------------------------
-------- Periodic sender ---------
----------------------------------
signal s_conf_word : std_logic_vector(15 downto 0);
----------------------------------

-- Multiple ejections supressor --
signal s_was_trigmema, s_was_trigmemb : std_logic;
signal s_has_grain_A, s_has_grain_B : std_logic_vector(31 downto 0);
----------------------------------
-- Main board detector
signal s_main_board : std_logic;
----------------------------------
signal s_fleda, s_rleda, s_en_back : std_logic;
signal s_afec : std_logic_vector(3 downto 0);
signal flag_si : std_logic;

-- components -------------------------------------------------------
component memdef is
    Port ( defcont_addr : in  STD_LOGIC_VECTOR (7 downto 0);
           wcont : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           wdefen : in  STD_LOGIC;
           rcont : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

-- 2Kx16 bit BlockRam, write into A, read from B
component M2Kx16
	port (
	clka: IN std_logic;
	wea: IN std_logic_VECTOR(0 downto 0);
	addra: IN std_logic_VECTOR(10 downto 0);
	dina: IN std_logic_VECTOR(15 downto 0);
	clkb: IN std_logic;
	addrb: IN std_logic_VECTOR(10 downto 0);
	doutb: OUT std_logic_VECTOR(15 downto 0));
end component;

-- multiply two 16 bit numbers
component mult16
	port (
	clk: IN std_logic;
	a: IN std_logic_VECTOR(15 downto 0);
	b: IN std_logic_VECTOR(15 downto 0);
	ce: IN std_logic;
	p: OUT std_logic_VECTOR(31 downto 0));
end component;

-- pulse shaper - ejetoras???
component WRAPPER_TOP is
    Port (CH_IN00_i : in STD_LOGIC_VECTOR (2 downto 0);
		      CH_IN01_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN02_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN03_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN04_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN05_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN06_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN07_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN08_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN09_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN10_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN11_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN12_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN13_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN14_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN15_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN16_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN17_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN18_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN19_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN20_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN21_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN22_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN23_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN24_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN25_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN26_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN27_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN28_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN29_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN30_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN31_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN32_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN33_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN34_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN35_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN36_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN37_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN38_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN39_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN40_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN41_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN42_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN43_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN44_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN45_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN46_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN47_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN48_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN49_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN50_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN51_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN52_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN53_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN54_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN55_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN56_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN57_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN58_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN59_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN60_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN61_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN62_i : in STD_LOGIC_VECTOR (2 downto 0);
			  CH_IN63_i : in STD_LOGIC_VECTOR (2 downto 0);
			  
           SYNC1_i : in  STD_LOGIC_VECTOR (8 downto 0);
			  SYNC1_EL_7_i : in STD_LOGIC_VECTOR(8 downto 0);
           SYNC2_i : in  STD_LOGIC_VECTOR (8 downto 0);
			  SYNC2_EL_7_i : in STD_LOGIC_VECTOR(8 downto 0);
			  
			  RETRIGGER_ON_i : in std_logic;
			  				
				TEMPO_ESTATISTICA_i : in std_logic_vector(2 downto 0); --Tempo da estatistica de ejecoes (3 - 10seg)
				HAS_GRAIN_i : in STD_LOGIC_VECTOR(63 downto 0);
				INT_CH_REQ_i : in std_logic_vector (5 downto 0); --CH que a interface deseja ler
			  
				A_ELIPSE1_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE2_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE3_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE4_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE5_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE6_i : in STD_LOGIC_VECTOR (9 downto 0);
				A_ELIPSE7_i : in STD_LOGIC_VECTOR (9 downto 0);
				
				B_ELIPSE1_i : in STD_LOGIC_VECTOR (9 downto 0); 
				B_ELIPSE2_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE3_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE4_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE5_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE6_i : in STD_LOGIC_VECTOR (9 downto 0);
				B_ELIPSE7_i : in STD_LOGIC_VECTOR (9 downto 0);
				
			  OVERUSAGE_CLR_A_i : in STD_LOGIC;
			  OVERUSAGE_CLR_B_i : in STD_LOGIC;
				
           C20US_i : in  STD_LOGIC;
			  C56MHz_i : in STD_LOGIC;
           C18MHZ_i : in  STD_LOGIC;
           C3KHZ_i : in  STD_LOGIC;
           RST_i : in  STD_LOGIC;
			  
			  PROBE_o : out STD_LOGIC_VECTOR(15 downto 0);
			  EJ_CNT_o : out  STD_LOGIC_VECTOR (15 downto 0); --Estatistica do canal (Depende de CH_NUM_o)
			  MAX_ACTIVE_COUNTER_o : out  STD_LOGIC_VECTOR (15 downto 0); 
			  OVERUSAGE_o : out std_logic_vector(63 downto 0);
           CH_EJ_o : out  STD_LOGIC_VECTOR (63 downto 0));
end component;

-------------------------------------------
-- Auto-Gain Table
component MEAN_16K is
    Port ( ACC_IN : in STD_LOGIC_VECTOR(63 downto 0);
			  PIX_i : in STD_LOGIC_VECTOR (7 downto 0);
			  POX_i : in  STD_LOGIC_VECTOR (7 downto 0);
			  CANSUM_i : in STD_LOGIC;
			  IS_TRANSLUC_i : in STD_LOGIC_VECTOR(0 downto 0);
			  IS_REFLECT_i : in STD_LOGIC_VECTOR(0 downto 0);
			  CLR_MEAN_A_i : in std_logic;
			  CLR_MEAN_B_i : in std_logic;
			  NDUMPF_i : in STD_LOGIC_VECTOR(7 downto 0);
			  EXTEVENT_FLAGF_i : in std_logic;
			  EXTEVENTAG_FLAG_i : in std_logic;
			  READ_MEAN_i : in std_logic;
			  RST_i : in  STD_LOGIC;
			  CLK_i : in  STD_LOGIC;
			  CLK_INV_i : in STD_LOGIC;
			  CLR_MEAN_OFF_o : out std_logic;
			  ILLUM_A_o : out  STD_LOGIC_VECTOR (63 downto 0);
			  ILLUM_B_o : out  STD_LOGIC_VECTOR (63 downto 0));
end component;

COMPONENT MEM_256x64
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );

END COMPONENT;

COMPONENT PSEUDO_RANDOM_TEST
	Port (	ENABLE_TST_i : IN std_logic; 	--Conf jumper that enables the test
				RST_i : IN std_logic;	
				CLK_i : IN std_logic;
				
				EJET_o : OUT std_logic_vector (31 downto 0)	--32bit Pseudo-random Output signal 
			);
END COMPONENT;
-------------------------------------------
-- Sorting case
COMPONENT SORT_CASE
	Port ( 
			SORT_CASE_i : IN std_logic_vector (6 downto 0);
			RCONT_i : IN std_logic_vector (7 downto 0);
			INX_i : IN std_logic_vector (2 downto 0);
			CLK_i : IN std_logic;
			RESET_i : IN std_logic;
			
			SHOT_X_o : OUT std_logic_vector (2 downto 0);
			WCONT_o : OUT std_logic_vector (7 downto 0)
			);
END COMPONENT;
-------------------------------------------
-- Testejet signal generator
component TESTEJET is
    Port ( 	
				CLK_1_i : IN std_logic;
				CLK_18_i : IN std_logic;
				RESET_i : IN std_logic;
				TEJET_CHUTE_i : IN std_logic;
				TEJET_DWELL_i : IN std_logic_vector(9 downto 0);
				TEJETBUFF_i : IN std_logic_vector (31 downto 0);
				
--				TEJET_ACTIVE_TIME_i : in std_logic;
				
				DO_TESTEJETA_o : out std_logic;
				DO_TESTEJETB_o : out std_logic;
				TJET_o : out std_logic_vector (31 downto 0)
				);
end component;
-------------------------------------------
-- Main Reset (ch1 button reset)
component MAIN_RESET is
    Port ( 	CH1_i : in  STD_LOGIC;			-- Button input (0 when pressed "Pull-down")
				CLKSEL_i : in STD_LOGIC;		-- Jumper that sets if this is the main board or not
				RSYNC2_i : in STD_LOGIC;		-- Sync input
				C1US_i : in  STD_LOGIC;			-- 1us clock input
				RESET_o : out  STD_LOGIC);	-- Reset output
end component;
-------------------------------------------
-- Main board detector (replacement to conf(0) jumper)
component MAIN_BOARD_DETECTION is
    Port ( SYNC_IN_i : in  STD_LOGIC;					-- Synchrony signal input
           ILLUM_CYCLE_i : in  STD_LOGIC;				-- Illumination cycle
           RST_i : in  STD_LOGIC;					
           MAIN_BOARD_o : out  STD_LOGIC);			-- Output flag (replaces jumper)
end component;
-------------------------------------------

----------------------------------
-- multiplier input multiplexer -- 
----------------------------------
COMPONENT MEM_256x16
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

-------------------------------------------------
---------- Periodic status data sender ----------
-------------------------------------------------
--component STATUS_SENDER is
--    Port ( PACK_8BIT_0 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_1 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_2 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_3 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_4 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_5 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_6 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_7 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_8 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_9 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_10 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_11 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_12 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_13 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  PACK_8BIT_14 : in  STD_LOGIC_VECTOR(7 downto 0);
--			  
--           CLK_i : in  STD_LOGIC;
--           RST_i : in  STD_LOGIC;
--			  SEND_o : out STD_LOGIC;
--           TX_o : out  STD_LOGIC);
--end component;

-------------------------------------------------
---------------- Floor Module -------------------
-------------------------------------------------
component FLOOR_GEN is
    Port ( FLOORX_i : in  STD_LOGIC;				-- Floor command input signal (coming from the luminary interface)
           RSYNC_i : in  STD_LOGIC;					-- Synchrony signal (RSYNC2)				
           LED_SEQ_i_0 : in  STD_LOGIC;			-- Illummination signal (LEDSEQ has 3 bits, 1 for each illumination)
			  
           RST_i : in  STD_LOGIC;					-- Reset signal
			  
			  PROBE_o : out STD_LOGIC_VECTOR(7 downto 0);
			  FLOOR_o : out STD_LOGIC;					-- Floor flag (when in 1 floor is active)
			  BGND_OFF_o : out STD_LOGIC;			-- Active on the first stage of the floor (Should turn all illuminations off)
           BGND_FLOOR_o : out  STD_LOGIC;			-- When active the  for the background should be taken
           ILLUM_FLOOR_o : out  STD_LOGIC);		-- When active the floor data for the reflectancy and translucency should be taken
end component;

signal s_floor, s_bgnd_off : std_logic;
signal s_bgnd_floor_int, s_bgnd_floor : std_logic;
signal s_illum_floor_int, s_illum_floor : std_logic;
-------------------------------------------------
----------- Clock Generation Signals ------------
-------------------------------------------------
signal s_BAUD_CLK, s_BAUD_CLK_BUF, s_tx : std_logic;	-- Baud Clock 38400 Hz
signal s_baud_clk_counter : integer range 0 to 255;

-------------------------------------------------
begin
   -- pra extinguir o jumper da 1 placa, se a placa recebe sincronismo, não é a primeira placa
	i_MAIN_BOARD_DETECTION : MAIN_BOARD_DETECTION 
	 Port map( 	SYNC_IN_i => sincin,					-- Synchrony signal input
					ILLUM_CYCLE_i => LEDSEQ(0),		-- Illumination cycle
					RST_i => reset,					
					MAIN_BOARD_o => s_main_board);	-- Output flag (replaces jumper)
					
	LED2 <= s_main_board;

	 -- sincronization interface
	 clksel <= s_main_board; -- jumper inserted means first board
	 tsinc2 <= rsinc2 when clksel='1' else not(s_floor and c1us);

	------------------------------------------------------------------------------------------------------
	-- reset signal generated after FPGA becomes alive ---------------------------------------------------
	
	i_MAIN_RESET : MAIN_RESET
    Port map( 	CH1_i 	=> '0',			-- Button input (0 when pressed "Pull-down")
					CLKSEL_i => clksel,		-- Jumper that sets if this is the main board or not
					RSYNC2_i => rsinc2,		-- Sync input
					C1US_i 	=> c1us,			-- 1us clock input
					RESET_o 	=> reset);		-- Reset output

	------------------------------------------------------------------------------------------------------	
	i_FLOOR_GEN : FLOOR_GEN 
		Port map( 	FLOORX_i => floorx,
						RSYNC_i => rsinc2,
						LED_SEQ_i_0 => ledseq(0),
				  
						RST_i => reset,
				  
						PROBE_o => s_probe(7 downto 0),
						FLOOR_o => s_floor,
						BGND_OFF_o => s_bgnd_off,
						BGND_FLOOR_o => s_bgnd_floor_int,
						ILLUM_FLOOR_o => s_illum_floor_int);
	
	TEST(0) <= clkaq;
	TEST(1) <= floorx;
	TEST(2) <= rsinc2;
	TEST(3) <= ledseq(0);
	TEST(4) <= reset;
	TEST(5) <= s_floor;
	TEST(6) <= s_bgnd_off;
	TEST(7) <= s_bgnd_floor_int;
	TEST(8) <= s_illum_floor_int;
	TEST(9) <= s_probe(7);
	TEST(10) <= s_probe(6);
	TEST(11) <= s_probe(5);
	TEST(12) <= s_probe(4);
	TEST(13) <= s_probe(3);
	TEST(14) <= s_probe(2);
	TEST(15) <= s_probe(1);

-- clock management -------------------------------------------------------------------
	
	clk37mux <= clk37;
	tsinc1 <= rsinc1 and (not sincout);
	
	process (clkaq,clrsinc)
	begin
	  if clrsinc='1' then
	    sincin <= '0';
	  elsif falling_edge(clkaq) then
	    sincin <= not rsinc1;
	  end if;
	end process;

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

   -- DCM_CLKGEN: Frequency Aligned Digital Clock Manager
   --             Spartan-6
   -- Xilinx HDL Language Template, version 12.1

   DCM_CLKGEN_inst : DCM_CLKGEN
   generic map (
      CLKFXDV_DIVIDE => 2,       -- CLKFXDV divide value (2, 4, 8, 16, 32)
      CLKFX_DIVIDE => 1,         -- Divide value - D - (1-256)
      CLKFX_MD_MAX => 3.0,       -- Specify maximum M/D ratio for timing anlysis
      CLKFX_MULTIPLY => 3,       -- Multiply value - M - (2-256)
      CLKIN_PERIOD => 23.0,       -- Input clock period specified in nS
      SPREAD_SPECTRUM => "NONE", -- Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD" or "CENTER_HIGH_SPREAD" 
      STARTUP_WAIT => FALSE      -- Delay config DONE until DCM LOCKED (TRUE/FALSE)
   )
   port map (
      CLKFX => CLKFX,         -- 1-bit Generated clock output
      CLKFX180 => CLKFX180,   -- 1-bit Generated clock output 180 degree out of phase from CLKFX.
      CLKFXDV => CLKFXDV,     -- 1-bit Divided clock output
      LOCKED => open, --test(1),      -- 1-bit Locked output
      PROGDONE => open,		   -- 1-bit Active high output to indicate the successful re-programming
      STATUS => open,  		   -- 2-bit DCM status
      CLKIN => CLK37mux,         -- 1-bit Input clock
      FREEZEDCM => '0', 			-- 1-bit Prevents frequency adjustments to input clock
      PROGCLK => '0', 				-- 1-bit Clock input for M/D reconfiguration
      PROGDATA => '0', 				-- 1-bit Serial data input for M/D reconfiguration
      PROGEN => '0', 				-- 1-bit Active high program enable
      RST => dcmrst 					-- 1-bit Reset input pin
   );

   -- End of DCM_inst instantiation
   BUFG_inst : BUFG
   port map ( O => clk2x,  I => clkfx); -- 3 * 37.5= 112.5MHz
-----------------------------------------------------------------------------------------
   process (clk2x,dcmrst) -- clock generation with 112.5MHz
	variable dv1a,dv2,dv3,dv4: integer range 0 to 15 := 0;
	variable dv1: integer range 0 to 63 := 0;
	begin
	  if dcmrst='1' then
	     dv4:=0; dv1:=0; dv1a:=0; dv3:=0;
		  clkxx<='0';
		  clkxxx<='0';
		  ck1us<='0';
	  elsif rising_edge(clk2x) then
	  
		  dv1a:=dv1a+1; 
		  if (dv1a=3) and (clkxxx='0') then dv1a:=0; clkxxx<='1'; end if;-- 18.75MHz
		  if (dv1a=3) and (clkxxx='1') then dv1a:=0; clkxxx<='0'; end if;--

		  dv3:=dv3+1; 
		  if (dv3=6) and (clkxx='0') then dv3:=0; clkxx<='1'; end if;-- 9.375MHz
		  if (dv3=6) and (clkxx='1') then dv3:=0; clkxx<='0'; end if;--

		  dv1:=dv1+1; 
		  if (dv1=55) and (ck1us='0') then dv1:=0; ck1us<='1'; end if;-- 1.0046MHz
		  if (dv1=57) and (ck1us='1') then dv1:=0; ck1us<='0'; end if;--

		  clkaq<=not clkaq; -- 56.25MHz
		  
	  end if;
	end process;

   BUFG_1u : BUFG
   port map ( O => c1us,  I => ck1us); -- 1.0046MHz
   BUFG_1z : BUFG
   port map ( O => clkz,  I => clkxxx); -- 18.75MHz
   BUFG_1x : BUFG
   port map ( O => clkx,  I => clkxx); -- 9.375MHz
--   BUFG_A : BUFG
--   port map ( O => clkaq,  I => ckaa); -- 56.25MHz

   dcmrst<= not led_reset;
	
-----------------------------------------------------------------------------------------
-- valve clock enable process
   process (c1us)
	variable ddv20: integer range 0 to 31 := 0;
	begin
	  if rising_edge(c1us) then
	     ddv20:=ddv20+1;
		  if ddv20=20 then
		    c20us<='1'; ddv20:=0;
			else
          c20us<='0';			
		  end if;
	  end if;
	end process;
	
-- valve PWM gate signal (around 7KHz)
   process (c1us)
	variable ddv2: integer range 0 to 127 := 0;
	begin
	  if rising_edge(c1us) then
	     ddv2:=ddv2+1;
		  if (ddv2=70) and (chopvalve='0') then ddv2:=0; chopvalve<='1'; end if;
		  if (ddv2=70) and (chopvalve='1') then ddv2:=0; chopvalve<='0'; end if;
		  
	  end if;
	end process;
	
------------------------------------------------------------------------------------------------------
	adc2_sclk <= '1' when c1us='1' else '0';
	adc1_sclk <= '1' when c1us='1' else '0';

   process (c1us,sendafe,afesent)
	variable afes: integer range 0 to 31 := 0;
	begin
	  if sendafe='0' then
	     afes:=0;
		  afesent<='0';
		  ADC1_SDATA <= 'Z'; ADC2_SDATA <= 'Z';
		  ADC1_SLOAD <= '1'; ADC2_SLOAD <= '1';
	  elsif falling_edge(c1us) and afesent='0' then
	    afes:=afes+1;
       ADC1_SLOAD <= '1'; 
		 ADC2_SLOAD <= '1';
		 case afes is
		   when 0 => ADC1_SDATA <= '0'; ADC2_SDATA <= '0'; -- idle
		   when 1 => ADC1_SDATA <= '0'; ADC2_SDATA <= '0'; -- idle
		   when 2 => ADC1_SDATA <= '0'; ADC2_SDATA <= '0'; -- R/W=0 
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 3 => ADC1_SDATA <= afeaddr(2); ADC2_SDATA <= afeaddr(2); -- address
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 4 => ADC1_SDATA <= afeaddr(1); ADC2_SDATA <= afeaddr(1);
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 5 => ADC1_SDATA <= afeaddr(0); ADC2_SDATA <= afeaddr(0);
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 6 => ADC1_SDATA <= afeaddr(0); ADC2_SDATA <= afeaddr(0); -- don't care bit
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 7 => ADC1_SDATA <= afeaddr(0); ADC2_SDATA <= afeaddr(0); -- don't care bit
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 8 => ADC1_SDATA <= afeaddr(0); ADC2_SDATA <= afeaddr(0); -- don't care bit
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 9 => ADC1_SDATA <= afedata(8); ADC2_SDATA <= afedata(8); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 10=> ADC1_SDATA <= afedata(7); ADC2_SDATA <= afedata(7); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 11=> ADC1_SDATA <= afedata(6); ADC2_SDATA <= afedata(6); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 12=> ADC1_SDATA <= afedata(5); ADC2_SDATA <= afedata(5); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 13=> ADC1_SDATA <= afedata(4); ADC2_SDATA <= afedata(4); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 14=> ADC1_SDATA <= afedata(3); ADC2_SDATA <= afedata(3); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 15=> ADC1_SDATA <= afedata(2); ADC2_SDATA <= afedata(2); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 16=> ADC1_SDATA <= afedata(1); ADC2_SDATA <= afedata(1); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
		   when 17=> ADC1_SDATA <= afedata(0); ADC2_SDATA <= afedata(0); -- data
			          if afen='0' then ADC1_SLOAD <= '0'; else ADC2_SLOAD <= '0'; end if;
						 
		   when 18=> ADC1_SDATA <= 'Z'; ADC2_SDATA <= 'Z'; -- idle
			          afesent<='1';
						 
		   when others =>	afes:=0;		 
		 end case;
	  end if;
	end process;
---------------------------------------------------------------------------------------
-- Analog Front End Clocks ------------------------------------------------------------
           
		   -- pq zero???
		   ADC1_OEB <= '0';
           ADC1_CLK1 <= '0';
           ADC2_OEB <= '0';
           ADC2_CLK1 <= '0';

           ADC1_CLK2 <= afeck2;
           ADC1_CLK <= afeck;
           ADC2_CLK2 <= afeck2;
           ADC2_CLK <= afeck;
			  
	 -- CCD interface
           CCD_DIS1 <= reset;
			  CCD_DIS2 <= reset;
			  CCD_DIS3 <= reset;
			  CCD_DIS4 <= reset;
----------------------------------------------------------------------------------------
	 -- Illumination interface
		
	TRLEDF <= ilum(11 downto 9);
	TRLEDR <= ilum(8 downto 6);
	TFLEDF <= ilum(5 downto 3);
	TFLEDR <= ilum(2 downto 0);   

   process (clkaq)
   begin
	  if falling_edge(clkaq) then
	    EN_BACK<= '0';
		 FLEDA<='0';FLEDB<='0'; FLEDC<='0'; FLEDD<='0';              
		 RLEDA<='0';RLEDB<='0'; RLEDC<='0'; RLEDD<='0';
		 
	    case ledout is
		    when "001" => -- Front
			  case tfledf is
			    when "000"=>   FLEDA<='1';FLEDB<='0'; FLEDC<='0'; FLEDD<='0'; LED_duration_front<=LED_duration_A;              
			    when "001"=>   FLEDA<='0';FLEDB<='1'; FLEDC<='0'; FLEDD<='0'; LED_duration_front<=LED_duration_B;             
			    when "010"=>   FLEDA<='0';FLEDB<='0'; FLEDC<='1'; FLEDD<='0'; LED_duration_front<=LED_duration_C;             
			    when "011"=>   FLEDA<='0';FLEDB<='0'; FLEDC<='0'; FLEDD<='1'; LED_duration_front<=LED_duration_D;             
			    when others => FLEDA<='0';FLEDB<='0'; FLEDC<='0'; FLEDD<='0';              
			  end case;
			  
			  case tfledR is
			    when "000"=>   RLEDA<='1';RLEDB<='0'; RLEDC<='0'; RLEDD<='0'; LED_duration_front<=LED_duration_A;             
			    when "001"=>   RLEDA<='0';RLEDB<='1'; RLEDC<='0'; RLEDD<='0'; LED_duration_front<=LED_duration_B;             
			    when "010"=>   RLEDA<='0';RLEDB<='0'; RLEDC<='1'; RLEDD<='0'; LED_duration_front<=LED_duration_C;             
			    when "011"=>   RLEDA<='0';RLEDB<='0'; RLEDC<='0'; RLEDD<='1'; LED_duration_front<=LED_duration_D;             
			    when others => RLEDA<='0';RLEDB<='0'; RLEDC<='0'; RLEDD<='0'; 
			  end case;

			  
		    when "010" => -- Rear
			  case trledf is
			    when "000"=>   FLEDA<='1';FLEDB<='0'; FLEDC<='0'; FLEDD<='0'; LED_duration_rear<=LED_duration_A;
			    when "001"=>   FLEDA<='0';FLEDB<='1'; FLEDC<='0'; FLEDD<='0'; LED_duration_rear<=LED_duration_B;             
			    when "010"=>   FLEDA<='0';FLEDB<='0'; FLEDC<='1'; FLEDD<='0'; LED_duration_rear<=LED_duration_C;             
			    when "011"=>   FLEDA<='0';FLEDB<='0'; FLEDC<='0'; FLEDD<='1'; LED_duration_rear<=LED_duration_D;             
			    when others => FLEDA<='0';FLEDB<='0'; FLEDC<='0'; FLEDD<='0';              
			  end case;
			  
			  case trledr is
			    when "000"=>   RLEDA<='1';RLEDB<='0'; RLEDC<='0'; RLEDD<='0'; LED_duration_rear<=LED_duration_A;             
			    when "001"=>   RLEDA<='0';RLEDB<='1'; RLEDC<='0'; RLEDD<='0'; LED_duration_rear<=LED_duration_B;             
			    when "010"=>   RLEDA<='0';RLEDB<='0'; RLEDC<='1'; RLEDD<='0'; LED_duration_rear<=LED_duration_C;             
			    when "011"=>   RLEDA<='0';RLEDB<='0'; RLEDC<='0'; RLEDD<='1'; LED_duration_rear<=LED_duration_D;             
			    when others => RLEDA<='0';RLEDB<='0'; RLEDC<='0'; RLEDD<='0'; 
			  end case;

			  
		    when "100" => -- bckgnd
           EN_BACK<= '1';
			  
			 when others =>
		 end case;
	  end if;
   end process;	

----------------------------------------------------------------------------------------			  
-- Front End Memory instantiation
----------------------------------------------------------------------------------------			  
-- chute A
CAM_A_front : M2Kx16 port map (clka => clka, wea => wena, addra => addra, dina => dataa,
			                      clkb => clkb,	addrb => addrb, doutb => datab);
CAM_A_rear  : M2Kx16 port map (clka => clka, wea => wena2, addra => raddra, dina => dataa2,
			                      clkb => clkb,	addrb => addrb, doutb => datab2);
-- chute B
CAM_B_front : M2Kx16 port map (clka => clkab, wea => wenab, addra => addrab, dina => dataab,
			                      clkb => clkbb, addrb => addrbb, doutb => databb);
CAM_B_rear  : M2Kx16 port map (clka => clkab, wea => wena2b, addra => raddrab, dina => dataa2b,
			                      clkb => clkbb, addrb => addrbb, doutb => datab2b);

-- front end memory CLOCK (write)

   clka <= not clkaq;   
   clkab <= not clkaq;   

----------------------------------------------------------------------------------------			  
-- External Event Request for Front End Memory
-- main camera sequencer shall recognize it and set ExtEvent_Flag
----------------------------------------------------------------------------------------			  
   process (extevent,extclr)
	begin
	  if extclr='1' then
	     extevent_req<='0';
	  elsif rising_edge(extevent) then 
	     extevent_req<='1';
	  end if;
	end process;
	
----------------------------------
-- multiplier input multiplexer -- 
----------------------------------
   process (s_extevent_bckgnd_gain, s_extclr_bckgnd_gain)
	begin
	  if s_extclr_bckgnd_gain = '1' then
	     s_extevent_bckgnd_gain_req <='0';
	  elsif rising_edge(s_extevent_bckgnd_gain) then 
	     s_extevent_bckgnd_gain_req <= '1';
	  end if;
	end process;
----------------------------------
 
    
	 mpix <= X"FF" xor pix; -- used for Rear cameras
	 rled_counter(0)<=led_counter(1); -- rear cameras store image in the opposite illumination area
	 rled_counter(1)<=led_counter(0);

-- horizontal offset	adjustmen is made over the WRITE address only
	 apix <= pix; 
	 bmpix <= mpix; 
	 cpix <= pix; 
	 dmpix <= mpix; 
	 
-- address muxes
   with ad1 select -- front chute A
	addra <= '1' & led_counter & apix when "00",
	         '0' & led_counter & apix when "01",
				            "011" & apix when "10",
								    extaddrw when others;

   with ad1 select -- rear chute A
	raddra <= '1' & rled_counter & bmpix when "00",
	          '0' & rled_counter & bmpix when "01",
				             "011" & bmpix when "10",
								    extaddrw when others;

   with ad2 select -- front chute B
	addrab <= '1' & led_counter & cpix when "00",
	          '0' & led_counter & cpix when "01",
			 	             "011" & cpix when "10",
								     extaddrw when others;

   with ad2 select -- rear chute B
	raddrab <= '1' & rled_counter & dmpix when "00",
	           '0' & rled_counter & dmpix when "01",
		 	 	              "011" & dmpix when "10",
								     extaddrw when others;
									  
   addrb <= proc & pix when ad3='0' else extaddr;									  
   addrbb <= proc & pix when ad4='0' else extaddr;									  
-- data muxes
   dataa <= CCDt1 when dt1='0' else extdata;									  
   dataa2 <= ccdt2 when dt2='0' else extdata;									  
   dataab <= CCD3 when dt3='0' else extdata;									  
   dataa2b <= CCD4 when dt4='0' else extdata;									  
									 
					
   ccdt1 <= ccd1;					
	ccdt2 <= ccd2;	

-- front end memory mux process -----------------
   process (extevent_flag,exttype,extpart,s_bgnd_floor, s_illum_floor,extfloor)
	begin
		  if extevent_flag='0' then
			     if (s_bgnd_floor='1') or (s_illum_floor='1') then
				     ad1<="01"; ad2<="01"; ad3<='0'; ad4<='0'; dt1<='0'; dt2<='0'; dt3<='0'; dt4<='0'; 
				  else
				     ad1<="00"; ad2<="00"; ad3<='0'; ad4<='0'; dt1<='0'; dt2<='0'; dt3<='0'; dt4<='0'; 
				  end if;
	     else
			     if exttype='0' then
				     ad1<="00"; ad2<="00"; dt1<='0'; dt2<='0'; dt3<='0'; dt4<='0'; 
					  if extpart(1)='0' then ad3<='1'; ad4<='0'; else ad3<='0'; ad4<='1'; end if;
				  else
				     ad3<='0'; ad4<='0';
					  if extpart(1)='0' then
					     ad1<="11"; ad2<="00";
						  if extpart(0)='0' then 
						     dt1<='1'; dt2<='0'; dt3<='0'; dt4<='0'; 
						  else
						     dt1<='0'; dt2<='1'; dt3<='0'; dt4<='0'; 
						  end if;
					  else
					     ad1<="00"; ad2<="11";
						  if extpart(0)='0' then
						     dt1<='0'; dt2<='0'; dt3<='1'; dt4<='0'; 
						  else
						     dt1<='0'; dt2<='0'; dt3<='0'; dt4<='1'; 
						  end if;
					  end if;
				  end if;
		  end if;
	end process;

----------------------------------------------------------------------------------------			  
-- FIFO Memory instantiation regarding the illumination type
-- Front is reflectance
-- Rear is translucence
-- each memory has 8 bit data of each camera (front and rear), 8 image lines per memory
----------------------------------------------------------------------------------------			  
-- chute A
A_F1I_R2I_camfront	: M2Kx16 port map (clka,wenaf_f,addrfifo,data_af,clkbf,addrbfA,data_raf);
A_F1I_R2I_camrear  	: M2Kx16 port map (clka,wenaf_f,addrfifo_camrear,data_af,clkbf,addrbfA,data_raf_camrear);

A_F2I_R1I   			: M2Kx16 port map (clka,wenaf_r,addrfifo,data_af,clkbf,addrbfA,data_rar);

A_bckgnd_camfront 	: M2Kx16 port map (clka,wenaf_b,addrfifo_bgnd_front,data_af,clkbf,addrbfA,data_rab);
A_bckgnd_camrear  	: M2Kx16 port map (clka,wenaf_b,addrfifo_bgnd_rear,data_af,clkbf,addrbfA,data_rab_rear);

-- chute B
B_F1I_R2I_camfront  	: M2Kx16 port map (clka,wenaf_f,addrfifo,data_bf,clkbf,addrbfB,data_rbf);
B_F1I_R2I_camrear  	: M2Kx16 port map (clka,wenaf_f,addrfifo_camrear,data_bf,clkbf,addrbfB,data_rbf_camrear);

B_F2I_R1I	   		: M2Kx16 port map (clka,wenaf_r,addrfifo,data_bf,clkbf,addrbfB,data_rbr);

B_bckgnd_camfront 	: M2Kx16 port map (clka,wenaf_b,addrfifo_bgnd_front,data_bf,clkbf,addrbfB,data_rbb);
B_bckgnd_camrear  	: M2Kx16 port map (clka,wenaf_b,addrfifo_bgnd_rear,data_bf,clkbf,addrbfB,data_rbb_rear);

addrfifo<= (fifolinew & pix);
addrfifo_bgnd_front <= (fifoline & pix);
addrfifo_bgnd_rear <= (fifoline & pix) when (pix < X"81") else (fifolinew & pix);
addrfifo_camrear <= (s_fifolinew_new & pix);

-- address mux
addrbfA <= extaddrf when (extpartf(2)='0' and extevent_flagf='1') else addr_fifo_A;
addrbfB <= extaddrf when (extpartf(2)='1' and extevent_flagf='1') else addr_fifo_B;

addr_fifo_a<=s_fifoline_last & pox;
addr_fifo_b<=s_fifoline_last & pox;

   process (exteventf,extclrf)
	begin
	
	if (a(15 downto 12) /= "0000") then				-- Tests if any of the upper bits are 1 to avoid overflow
		data_af(15 downto 8) <= X"FF";				-- Set value to "FF"
	else
		data_af(15 downto 8) <= a(11 downto 4);	-- Else receive real value
	end if;
	
	if (a2(15 downto 12) /= "0000") then
		data_af(7 downto 0) <= X"FF";
	else
		data_af(7 downto 0) <= a2(11 downto 4);
	end if;
	
	if (ab(15 downto 12) /= "0000") then
		data_bf(15 downto 8) <= X"FF";
	else
		data_bf(15 downto 8) <= ab(11 downto 4);
	end if;
	
	if (a2b(15 downto 12) /= "0000") then
		data_bf(7 downto 0) <= X"FF";
	else
		data_bf(7 downto 0) <= a2b(11 downto 4);
	end if;

	end process;
	
----------------------------------------------------------------------------------------			  
-- External Event Request for FIFO
-- main camera sequencer shall recognize it and set ExtEvent_FlagF
----------------------------------------------------------------------------------------			  
   process (exteventf,extclrf)
	begin
	  if extclrf='1' then
	     extevent_reqf<='0';
	  elsif rising_edge(exteventf) then
	     extevent_reqf<='1';
	  end if;
	end process;
	
	-- Async Auto-Gain external access control
   process (exteventag,extclrag)
	begin
	  if extclrag='1' then
	     exteventag_req<='0';
	  elsif rising_edge(exteventag) then
	     exteventag_req<='1';
	  end if;
	end process;
----------------------------------------------------------------------------------------			  
----------------------------------------------------------------------------------------			  
-- delay for ADC clk --- pq tem delay???
   process (clkaq)
   begin
	if falling_edge(clkaq) then
	   afeck<=afeck0;
	end if;
   end process;	

----------------------------------
-- multiplier input multiplexer -- 
----------------------------------
i_MA_BKGND_GAIN : MEM_256x16
  PORT MAP (
    clka => clka,
    wea => s_ma_we,
    addra => s_bckgnd_gain_wr_addr,
    dina => s_bckgnd_gain_data_in,
    clkb => clka,
    addrb => pix,
    doutb => s_ma_gain_mem_out
  );

i_MA2_BKGND_GAIN : MEM_256x16
  PORT MAP (
    clka => clka,
    wea => s_ma2_we,
    addra => s_bckgnd_gain_wr_addr,
    dina => s_bckgnd_gain_data_in,
    clkb => clka,
    addrb => pix,
    doutb => s_ma2_gain_mem_out
  );

i_MAB_BKGND_GAIN : MEM_256x16
  PORT MAP (
    clka => clka,
    wea => s_mab_we,
    addra => s_bckgnd_gain_wr_addr,
    dina => s_bckgnd_gain_data_in,
    clkb => clka,
    addrb => pix,
    doutb => s_mab_gain_mem_out
  );

i_MA2B_BKGND_GAIN : MEM_256x16
  PORT MAP (
    clka => clka,
    wea => s_ma2b_we,
    addra => s_bckgnd_gain_wr_addr,
    dina => s_bckgnd_gain_data_in,
    clkb => clka,
    addrb => pix,
    doutb => s_ma2b_gain_mem_out
  );  
----------------------------------------------------------------------------------------			  
-- multiplier instantiation, RACC, mux
----------------------------------------------------------------------------------------		
-- chute A
multidata   : mult16 port map (clk2x,s_ma_mux,racc,'1',mp);
multidata2  : mult16 port map (clk2x,s_ma2_mux,racc2,'1',mp2);
-- chute B
multidatab  : mult16 port map (clk2x,s_mab_mux,raccb,'1',mpb);
multidata2b : mult16 port map (clk2x,s_ma2b_mux,racc2b,'1',mp2b);

----------------------------------
-- multiplier input multiplexer -- 
----------------------------------
s_ma_mux <= s_bkgnd_ma_gain when (s_bkgnd_mult = '1') else ma;
s_ma2_mux <= s_bkgnd_ma2_gain when (s_bkgnd_mult = '1') else ma2;
s_mab_mux <= s_bkgnd_mab_gain when (s_bkgnd_mult = '1') else mab;
s_ma2b_mux <= s_bkgnd_ma2b_gain when (s_bkgnd_mult = '1') else ma2b;

----------------------------------

   process (clkaq)
   begin
	if falling_edge(clkaq) then
	   racc<=acc;
	   racc2<=acc2;
		
	   raccb<=accb;
	   racc2b<=acc2b;
	end if;
   end process;	

   -- group_gain and gain_correction mux
   process (multipmux,led_counter,datab,databb,datab2,datab2b,ggain_bckA,ggain_imageA,ggain_bckB,ggain_imageB)
	variable lsl : std_logic_vector (2 downto 0);
	begin
	 lsl := multipmux & led_counter;
	 case lsl is
	   when "000" => ma<=datab; mab<=databb; ma2<=datab2; ma2b<=datab2b;
	   when "001" => ma<=datab; mab<=databb; ma2<=datab2; ma2b<=datab2b; -- trasnlucency
	   when "010" => ma<=datab; mab<=databb; ma2<=datab2; ma2b<=datab2b; -- reflectancy
	   when "011" => ma<=datab; mab<=databb; ma2<=datab2; ma2b<=datab2b; -- never happens
		
	   when "100" => ma<=X"0040"; mab<=X"0040"; ma2<=X"0040"; ma2b<=X"0040"; -- 
		when "101" =>  -- X Axis (Color 1)
							ma<=ggain_bckA; 		-- before reflecta now reflect_color1_f
							mab<=ggain_bckB;   	-- before reflectb now reflectb_color1_f
							ma2<=ggain_imageA; 	-- before reflectar now reflectr_color1_r
							ma2b<=ggain_imageB; 	-- before reflectbr now reflectbr_color1_r
							
	   when "110" => 	-- Y Axis (Color 2)
							ma<=ggain_imageA; 	-- before transluca now reflect_color2_f
							mab<=ggain_imageB; 	-- before translucb now reflect_color2_f
							ma2<=ggain_bckA; 		-- before translucar now reflect_color2_r
							ma2b<=ggain_bckB; 	-- before translucbr now reflect_color2_r
							
	   when "111" => ma<=X"0040"; mab<=ggain_bckB; ma2<=ggain_bckA; ma2b<=ggain_bckB; -- never happens
		
	   when others => 
	 end case;
	end process;

 
----------------------------------------------------------------------------------------			  
-- main camera sequencer for CCD cameras, AFE, memory, ALU and illumination			  
----------------------------------------------------------------------------------------			
   process (s_CLR_MEAN_OFF,reset,s_CLR_MEAN_COMMAND_A)	-- Clear mean command
	begin
	  if (reset='1' or s_CLR_MEAN_OFF='1') then
			s_CLR_MEAN_A<='0';
	  elsif rising_edge(s_CLR_MEAN_COMMAND_A) then
			s_CLR_MEAN_A<='1';
	  end if;
	end process;
	
   process (s_CLR_MEAN_OFF,reset,s_CLR_MEAN_COMMAND_B)	-- Clear mean command
	begin
	  if (reset='1' or s_CLR_MEAN_OFF='1') then
			s_CLR_MEAN_B<='0';
	  elsif rising_edge(s_CLR_MEAN_COMMAND_B) then
			s_CLR_MEAN_B<='1';
	  end if;
	end process;

	i_MEAN_16K : MEAN_16K
    Port map (
			  ACC_IN => s_acc_in,
			  PIX_i => pix,
			  POX_i => pox,
			  CANSUM_i => s_cansum,
			  IS_TRANSLUC_i => s_is_transluc,
			  IS_REFLECT_i => s_is_reflect,
			  CLR_MEAN_A_i =>  s_CLR_MEAN_A,
			  CLR_MEAN_B_i =>  s_CLR_MEAN_B,
			  NDUMPF_i => ndumpf,
			  EXTEVENT_FLAGF_i => extevent_flagf,
			  EXTEVENTAG_FLAG_i => exteventag_flag,
			  READ_MEAN_i => '1',
			  RST_i => reset,
			  CLK_i => clkaq,
			  CLK_INV_i => clka,
			  CLR_MEAN_OFF_o => s_CLR_MEAN_OFF,
			  ILLUM_A_o => s_illum_a,
			  ILLUM_B_o => s_illum_b
	);

   process(clkaq,reset,led_duration_rear) -- 56.25MHz
--	variable flag_si : std_logic;
   begin
	  if reset='1' then
	  
		 -- Mean 16k
			s_has_new <= '0';
						
		 sincout <= '0';	
	    clrsinc<='0';
		 
	    clkb<='0';
	    clkbb<='0';
		 wena(0)<='0';
		 wena2(0)<='0';
		 wenab(0)<='0';
		 wena2b(0)<='0';
	    extclr<='0';
		 extevent_flag<='0';
		 ----------------------------------
		 -- multiplier input multiplexer -- 
		 ----------------------------------
		 s_bkgnd_mult <= '0';
		 
		 s_ma_we <= "0";
		 s_ma2_we <= "0";
		 s_mab_we <= "0";
		 s_ma2b_we <= "0";
		 s_extclr_bckgnd_gain <= '0';
		 s_extevent_bckgnd_gain_flag <= '0';
		 ----------------------------------
	    afec <= "0000000000000001";
		 afeck2<='0';
		 afeck0<='0';
           CCD_CLK1<= '0';
			  CCD_CLK2<= '0';
			  CCD_CLK3<= '0';
			  CCD_CLK4<= '0';
			  CCD_SI1<= '0';
			  CCD_SI2<= '0';
			  CCD_SI3<= '0';
			  CCD_SI4<= '0';
		 flag_si<='0';	  
		 proc<="111"; -- default addressing gain correctiondata
		 multipmux<='0'; -- multiplier source is memory
		 ledseq<="001";
		 led_counter<="00";
		 led_duration<=X"F0"; --led_duration_rear;
		 ledout<="010";
		 pix<=x"00";
	    canincfifoline<='0';
		 fifoline <= "000";
--		 fifolinew <= "001";
		 
		s_bgnd_floor <= '0'; -- If there is a floor then store floor info for background
		s_illum_floor <= '0';
		
	  elsif rising_edge(clkaq) then 
-- defaults	  
	    extclr<='0';
	    clkb<='0';
	    clkbb<='0';
		 wena(0)<='0';
		 wena2(0)<='0';
		 wenab(0)<='0';
		 wena2b(0)<='0';

		----------------------------------
		-- multiplier input multiplexer -- 
		----------------------------------
		s_ma_we <= "0";
		s_ma2_we <= "0";
		s_mab_we <= "0";
		s_ma2b_we <= "0";
		
		s_extclr_bckgnd_gain <= '0';
		----------------------------------

		 wenaf_b(0)<='0';
		 wenaf_r(0)<='0';
		 wenaf_f(0)<='0';
		 
		 proc<="111"; -- default addressing gain correctiondata
		 
	    case afec is
-- 0 ----------------------------------------------------------- ---------------------------------------
		   when "0000000000000001" => afec <= "0000000000000010";
			-- AFE
			   afeck2<='1'; afeck0 <='0';  -- ADC1_CLK1,ADC2_CLK2 <= afeck2;  -- if falling_edge(clkaq),  afeck<=afeck0; ADC1_CLK <= afeck, ADC2_CLK <= afeck
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
				
				----------------------------------
				-- multiplier input multiplexer -- 
				----------------------------------
				s_bkgnd_mult <= '0';
				----------------------------------
			
			  case led_counter is
			    when "00" => proc<="100"; when "01" => proc<="101"; when "10" => proc<="110"; when others => proc<="111";
			  end case;	 
         -- front end memory
		     wena(0)<='1';
		     wena2(0)<='1';
		     wenab(0)<='1';
		     wena2b(0)<='1';

         -- Line FIFO
			  case led_counter is
			    when "00" => wenaf_b(0)<='1'; 
			    when "01" => wenaf_r(0)<='1'; 
			    when "10" => wenaf_f(0)<='1'; 
				 when others =>  wenaffl(0)<='0'; 
			  end case;	 
         -- board synch			
			  sincout<='0';

-- 1 ----------------------------------------------------------- --------------------------------------
		   when "0000000000000010" => afec <= "0000000000000100";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			  clkb<='1';  -- read B side of memory (IMAGE)
			  clkbb<='1';
			  case led_counter is
			    when "00" => proc<="100"; when "01" => proc<="101"; when "10" => proc<="110"; when others => proc<="111";
			  end case;	 
         -- Line FIFO
			if canincfifoline='1' then
			  s_fifoline_last <= fifoline;
 			  fifoline <= fifoline + 1;
			  fifolinew <= fifoline + 2;
			  s_fifolinew_new <= fifoline + 3;
			end if;  
				
-- 2 ----------------------------------------------------------- -----------------------------
		   when "0000000000000100" => afec <= "0000000000001000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			  case led_counter is
			    when "00" => proc<="000"; when "01" => proc<="001"; when "10" => proc<="010"; when others => proc<="111";
			  end case;	 
			  -- move Image to ACC
			  acc<=datab; --+ X"04A0"; -- add offset to handle with negative signals after FLOOR correction
			  acc2<=datab2; --+ X"04A0";
			  accb<=databb; --+ X"04A0";
			  acc2b<=datab2b; --+ X"04A0";

			-- Line FIFO
			if canincfifoline='1' then
			  canincfifoline<='0'; -- this will release the sorting state machine
			end if;  
			  
         -- Illumination	
			   if LED_duration>X"00" then
               LED_duration<=LED_duration-1;		
				else
					LEDOUT <= "000"; -- turn OFF all lEDs
				end if;
				
-- 3 ----------------------------------------------------------- --------------------------
		   when "0000000000001000" => afec <= "0000000000010000";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			  clkb<='1';  -- read B side of memory (FLOOR)
			  clkbb<='1';
			  case led_counter is
			    when "00" => proc<="000"; when "01" => proc<="001"; when "10" => proc<="010"; when others => proc<="111";
			  end case;	 

-- 4 ----------------------------------------------------------- ----------------------------------------
		   when "0000000000010000" => afec <= "0000000000100000";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			   ccd1(13 downto 6)<=adc1; -- recebe conteudo do adc1 
			   ccd1(15 downto 14)<="00";
			   ccd3(13 downto 6)<=adc2; 
		       ccd3(15 downto 14)<="00";
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			  -- select gain table according to illumination process
			  case led_counter is
			    when "00" => 
									proc<="111"; 
									
									----------------------------------
									-- multiplier input multiplexer -- 
									----------------------------------
									s_bkgnd_mult <= '1';
									----------------------------------
									
				 when "01" => proc<="011"; 
				 when "10" => proc<="111"; 
				 when others => proc<="111";
			  end case;	 
			  
				----------------------------------
				-- multiplier input multiplexer -- 
				----------------------------------
				s_bkgnd_ma_gain <= s_ma_gain_mem_out;
				s_bkgnd_ma2_gain <= s_ma2_gain_mem_out;
				s_bkgnd_mab_gain <= s_mab_gain_mem_out;
				s_bkgnd_ma2b_gain <= s_ma2b_gain_mem_out;
				----------------------------------
			
			  -- subtract FLOOR from ACC
				if (acc <= datab) then 	-- Tests if the raw image value (acc) is lower than floor value (datab) to avoid "underflow"
					acc<=(others=>'0');	-- If the value is lower than floor value than set to 0
				else
					acc<=acc-datab;		-- Otherwise subtract floor value
				end if;
				
				if (acc2 <= datab2) then
					acc2<=(others=>'0');
				else
					acc2<=acc2-datab2;
				end if;
				
				if (accb <= databb) then
					accb<=(others=>'0');
				else
					accb<=accb-databb;
				end if;
				
				if (acc2b <= datab2b) then
					acc2b<=(others=>'0');
				else
					acc2b<=acc2b-datab2b;
				end if;
				
			  multipmux<='0'; -- multiplier source is memory

			  
-- 5 ----------------------------------------------------------- -----------------------
		   when "0000000000100000" => afec <= "0000000001000000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			  -- select gain table according to illumination process
			  case led_counter is
			    when "00" => 
									proc<="111"; 
									
									----------------------------------
									-- multiplier input multiplexer -- 
									----------------------------------
									s_bkgnd_mult <= '1';
									----------------------------------
									
				 when "01" => proc<="011"; 
				 when "10" => proc<="111"; 
				 when others => proc<="111";
			  end case;

			  clkb<='1';  -- read B side of memory (GAIN)
			  clkbb<='1';

-- 6 ----------------------------------------------------------- ------------------------
		   when "0000000001000000" => afec <= "0000000010000000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			   ccd1(5 downto 0)<=adc1(7 downto 2); 
				ccd3(5 downto 0)<=adc2(7 downto 2); 
			-- CCD
           CCD_CLK1<= '0'; CCD_CLK2<= '0'; CCD_CLK3<= '0'; CCD_CLK4<= '0';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
			  
			
			s_acc_in <= (acc & acc2 & accb & acc2b);
			  			  
         -- ALU
			   -- let the multiplication happen (latency)

-- 7 ----------------------------------------------------------- ---------------------
		   when "0000000010000000" => afec <= "0000000100000000";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
			  
			-- Mean 16k
				if s_has_new = '1' then
					s_is_transluc <= "0";
					s_is_reflect <= "0";
				else
					if led_counter = "01" then
						s_is_transluc <= "1";
						s_is_reflect <= "0";
					elsif led_counter = "10" then
						s_is_transluc <= "0";
						s_is_reflect <= "1";
					else
						s_is_transluc <= "0";
						s_is_reflect <= "0";
					end if;
				end if;
							  
         -- ALU

				----------------------------------
				-- multiplier input multiplexer -- 
				----------------------------------
				s_bkgnd_mult <= '0';
				----------------------------------
			
			   -- store multiplier result
--				if led_counter/="00" then -- do not use result when reading background data (bckGnd is always multiplied by 1.0)
				
					if mp(31 downto 24) /= "00000000" then	-- Tests if the multiplication resulted an overflow (any bit above 23rd is 1)
						acc <= X"FFFF";							-- If there is an overflow set the value to FFFF
					else
						acc<=mp(23 downto 8);					-- Else gets the multiplication value
					end if;
					
					if mp2(31 downto 24) /= "00000000" then
						acc2 <= X"FFFF";
					else
						acc2<=mp2(23 downto 8);
					end if;
					
					if mpb(31 downto 24) /= "00000000" then
						accb <= X"FFFF";
					else
						accb<=mpb(23 downto 8);
					end if;
					
					if mp2b(31 downto 24) /= "00000000" then
						acc2b <= X"FFFF";
					else
						acc2b<=mp2b(23 downto 8);
					end if;
					
--				else	-- If it is the background illumination
--					
--					if (acc < ("00" & dottrigga & "000000")) then	-- If acc value is higher than shifted trip line
--						s_acc_valid(CONV_INTEGER(pix)) <= '1';			-- Mark as valid pixel intensity
--					else															-- If acc value is lower 
--						s_acc_valid(CONV_INTEGER(pix)) <= '0';			-- Mark as unvalid pixel intensity
--					end if;
--					
--					if (acc2 < ("00" & dottrigga & "000000")) then							
--						s_acc2_valid(CONV_INTEGER(pix)) <= '1';	
--					else														
--						s_acc2_valid(CONV_INTEGER(pix)) <= '0';	
--					end if;
--					
--					if (accb < ("00" & dottriggb & "000000")) then							
--						s_accb_valid(CONV_INTEGER(pix)) <= '1';	
--					else														
--						s_accb_valid(CONV_INTEGER(pix)) <= '0';	
--					end if;
--					
--					if (acc2b < ("00" & dottriggb & "000000")) then							
--						s_acc2b_valid(CONV_INTEGER(pix)) <= '1';	
--					else														
--						s_acc2b_valid(CONV_INTEGER(pix)) <= '0';	
--					end if;
					
--				end if;
				
         -- ext access
			  if extevent_req='1' then
			     extevent_flag<='1';
			  end if;
			  
			 ----------------------------------
			 -- multiplier input multiplexer -- 
			 ----------------------------------
			  if s_extevent_bckgnd_gain_req='1' then
			     s_extevent_bckgnd_gain_flag<='1';
			  end if;
			 ----------------------------------
				
				
				multipmux<='1'; -- next multiplier source is group_gain

-- 8 ----------------------------------------------------------- ----------------------
		   when "0000000100000000" => afec <= "0000001000000000";
			-- AFE
			   afeck2<='0'; afeck0 <='0';
			   ccd2(13 downto 6)<=adc1; 
				ccd2(15 downto 14)<="00";
				ccd4(13 downto 6)<=adc2; 
				ccd4(15 downto 14)<="00";
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
         -- ALU
			   -- let multiplication happen (latency)

-- 9 ----------------------------------------------------------- -------------------------
		   when "0000001000000000" => afec <= "0000010000000000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
			  
			-- MEAN
				s_is_transluc <= "0";
				s_is_reflect <= "0";
			  
         -- external access front-end
			  clkb<='1';  -- read B side 
			  clkbb<='1';
		
-- 10 ----------------------------------------------------------- -------------------------
		   when "0000010000000000" => afec <= "0000100000000000";
			-- AFE
			   afeck2<='0'; afeck0 <='1'; 
			   ccd2(5 downto 0)<=adc1(7 downto 2); 
				ccd4(5 downto 0)<=adc2(7 downto 2); 
			-- CCD
            CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			   if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				               else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			   end if;
 
				    a   <=mp(23 downto 8); 
					a2  <=mp2(23 downto 8);
					ab  <=mpb(23 downto 8);
					a2b <=mp2b(23 downto 8);
								  
			 ----------------------------------
			 -- multiplier input multiplexer -- 
			 ----------------------------------
			  if (s_extevent_bckgnd_gain_flag='1') then -- read, muxes are already set
				     case s_bckgnd_mem_sel is
					    when "00" => s_ma_we<="1";
					    when "01" => s_ma2_we<="1";
					    when "10" => s_mab_we<="1";
					    when "11" => s_ma2b_we<="1";
					    when others => 
					  end case;
			  else
				-- ext access
				  if (extevent_flag='1') and (exttype='0') then -- read, muxes are already set
						  case extpart is
							 when "00" => extdataread <= datab; 
							 when "01" => extdataread <= datab2; 
							 when "10" => extdataread <= databb;
							 when "11" => extdataread <= datab2b; 
							 when others => 
						  end case;
				  end if;
				  
				  if (extevent_flag='1') and (exttype='1') then -- read, muxes are already set
						  case extpart is -- write enable, muxes are already set
							 when "00" => wena(0)<='1';
							 when "01" => wena2(0)<='1';
							 when "10" => wenab(0)<='1';
							 when "11" => wena2b(0)<='1';
							 when others => 
						  end case;
				  end if;
			  end if;
			 ----------------------------------
					

         -- front end memory & illumination
			  if flag_si='1'then flag_si<='0'; end if; -- finish CCD_SI pulse
       
--		   -- sinc generation
			  if pix=X"FF" then
             case LEDSEQ is
	            when "100" => sincout<='1'; 
	 	         when others => sincout<='0';
	          end case;
			  else
             sincout<='0';			  
			  end if;
			
			  

-- 11 ----------------------------------------------------------- 
		   when "0000100000000000" => afec <= "0000000000000001";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
			  
         -- ext access
			  if extevent_flag='1' then
			     extevent_flag<='0';
				  extclr<='1';
			  end if;
			  
			 ----------------------------------
			 -- multiplier input multiplexer -- 
			 ----------------------------------
			  if s_extevent_bckgnd_gain_flag = '1' then
			     s_extevent_bckgnd_gain_flag <= '0';
				  s_extclr_bckgnd_gain <= '1';
			  end if;
			 ----------------------------------
			  
         -- front end memory & illumination & FIFO
								
			  pix<=pix+1;

			  if pix=X"FF" then
			  
				flag_si<='1'; -- start CCD_SI pulse once every 256 pixels
				 
             case LEDSEQ is
	            when "001" => LEDSEQ<="010"; 
					              LEDOUT <= "001"; 
									  led_counter<="01"; -- illum front ON, store REAR
									  
									  s_illum_floor <= s_illum_floor_int; -- If there is a floor then store floor info for rear illumination
									  s_bgnd_floor <= '0';
									  
									  LED_duration<=LED_duration_front;
									  
	            when "010" => LEDSEQ<="100"; 
									  led_counter<="10"; -- illum bckgnd OFF, store FRONT
									  
									  s_illum_floor <= s_illum_floor_int; -- If there is a floor then store floor info for front illumination
									  s_bgnd_floor <= '0';
									  
					              if (s_bgnd_off = '1') then
										LEDOUT <= "000"; 
									  else
										LEDOUT <= "100"; 
									  end if;
									  
									  LED_duration<=LED_duration_bckgnd;
	            when "100" => LEDSEQ<="001"; 
					              LEDOUT <= "010"; 
									  
									  led_counter<="00"; -- illum rear ON, store BackGnd
									  
									  s_bgnd_floor <= s_bgnd_floor_int; -- If there is a floor then store floor info for background
									  s_illum_floor <= '0';
									  
									  LED_duration<=LED_duration_rear;
									  sincout<='1';

                             canincfifoline<='1';
									  
									 -- Mean 16k
									  s_has_new <= (not(s_has_new));
									  
									  
	 	         when others => LEDOUT <= "000"; led_counter<="00"; LEDSEQ<="001";
	          end case;
			  else
             sincout<='0';			  
			  end if;


-- 12  -- phantom state for synch purposes ----------------------------------------------------------- 
		   when "0001000000000000" => afec <= "0000000000000001";
			-- AFE
			   afeck2<='0'; afeck0 <='0'; 
			-- CCD
           CCD_CLK1<= '1'; CCD_CLK2<= '1'; CCD_CLK3<= '1'; CCD_CLK4<= '1';
			  if flag_si='1' then CCD_SI1<='1'; CCD_SI2<='1'; CCD_SI3<='1'; CCD_SI4<='1';
				              else CCD_SI1<='0'; CCD_SI2<='0'; CCD_SI3<='0'; CCD_SI4<='0';
			  end if;
			  
         -- ext access
			  if extevent_flag='1' then
			     extevent_flag<='0';
				  extclr<='1';
			  end if;
			  
			 ----------------------------------
			 -- multiplier input multiplexer -- 
			 ----------------------------------
			  if s_extevent_bckgnd_gain_flag = '1' then
			     s_extevent_bckgnd_gain_flag <= '0';
				  s_extclr_bckgnd_gain <= '1';
			  end if;
			 ----------------------------------
			  
         -- front end memory & illumination
--			  if flag_si='1'then flag_si:='0'; end if; -- finish CCD_SI pulse
								
				-- synchronization -----------------------------	
			   flag_si<='1'; -- start CCD_SI pulse once every 256 pixels
								
				pix<=X"00";
	         LEDSEQ<="001"; 
				LEDOUT <= "010"; 
				led_counter<="00"; -- illum rear ON, store BackGnd
				LED_duration<=LED_duration_rear;

				s_bgnd_floor <= s_bgnd_floor_int; -- If there is a floor then store floor info for background
				s_illum_floor <= '0';

            canincfifoline<='1';
									  
				-- Mean 16k
				s_has_new <= (not(s_has_new));
            sincout<='0';


		   when others => afec <= "0000000000000001";
		 end case;
		 
	-- board synch	 
		 clrsinc<='0';
		 if sincin='1' then
		  afec <= "0001000000000000"; -- synch phantom step
		  clrsinc<='1';
		 end if;
		 
     end if;	  
   end process;	


--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------			  
-- ELLIPSE memory for both chutes
----------------------------------------------------------------------------------------			  
ellipmemA : M2Kx16 port map (ellclka,wenellipa,extaddre,extdata,clkbellip,ellip_addra,ellipa);
ellipmemB : M2Kx16 port map (ellclkb,wenellipb,extaddre,extdata,clkbellip,ellip_addrb,ellipb);
ellipmemAr : M2Kx16 port map (ellclka,wenellipa,extaddre,extdata,clkbellip,ellip_addrar,ellipar);
ellipmemBr : M2Kx16 port map (ellclkb,wenellipb,extaddre,extdata,clkbellip,ellip_addrbr,ellipbr);

   wenellipa(0)<='1';
	wenellipb(0)<='1';
	
-- handle the external write over the ellipse memories
   process (extellipeva,clrellia)
	begin
	  if clrellia='1' then extellia<='0';
	  elsif rising_edge(extellipeva) then extellia<='1';
	  end if;
	end process;

   process (extellipevb,clrellib)
	begin
	  if clrellib='1' then extellib<='0';
	  elsif rising_edge(extellipevb) then extellib<='1';
	  end if;
	end process;

----------------------------------------------------------------------------------------			  
-- DOT memory for both chutes
----------------------------------------------------------------------------------------			  
dotmemA : M2Kx16 port map (clka,wendota,addrdotwa,data_dwa,clkbd,addrdotr,data_dra);
dotmemB : M2Kx16 port map (clka,wendotb,addrdotwb,data_dwb,clkbd,addrdotr,data_drb);

----------------------------------------------------------------------------------------			  
-- External Event Request for DOT
-- main camera sequencer shall recognize it and set ExtEvent_FlagD
----------------------------------------------------------------------------------------			  
   process (exteventd,extclrd)
	begin
	  if extclrd='1' then 
			extevent_reqd<='0';
	  elsif rising_edge(exteventd) then 
			extevent_reqd<='1';
	  end if;
	end process;

   addrdotr <= extaddrd;
----------------------------------------------------------------------------------------			  
----------------------------------------------------------------------------------------			  
----------------------------------------------------------------------------------------			  
-- defect counter memory
----------------------------------------------------------------------------------------			  
 defect_a : memdef port map (defcont_addra,wconta,clka,wdefena,rconta);
 defect_b : memdef port map (defcont_addrb,wcontb,clka,wdefenb,rcontb);
	

--	Extra config enable summing all ellipsys' defects in one counter

	defcont_addra <= inx & ejeta; -- mount defect counter address
	defcont_addrb <= inx & ejetb; -- mount defect counter address
	npox <= pox + 1; -- next pixel to calculate next ejector
	s_last_pox <= pox - 1;

-- Chute A
   ellip_addra <= inx & reflecta_color1; -- mount ellipse memory address
	ellipay1 <= ellipa(7 downto 0);
   ellipay2 <= ellipa(15 downto 8);
	
	setejav <= seteja(CONV_INTEGER(inx));
	
-- Chute B
   ellip_addrb <= inx & reflectb_color1; -- mount ellipse memory address
	ellipby1 <= ellipb(7 downto 0);
   ellipby2 <= ellipb(15 downto 8);
  
	setejbv <= setejb(CONV_INTEGER(inx));

-- Chute Ar
   ellip_addrar <= inx & reflectar_color1; -- mount ellipse memory address
	ellipay1r <= ellipar(7 downto 0);
   ellipay2r <= ellipar(15 downto 8);

-- Chute Br
   ellip_addrbr <= inx & reflectbr_color1; -- mount ellipse memory address
	ellipby1r <= ellipbr(7 downto 0);
   ellipby2r <= ellipbr(15 downto 8);

   s_triggenda <= '1' when (pox>=pixstarta) and (pox<=pixenda) else '0';
   s_triggendb <= '1' when (pox>=pixstartb) and (pox<=pixendb) else '0';
	
	process (bkgndfa,s_triggenda,s_triggendb,bkgndfb,bkgndfar,bkgndfbr,dottrigga,dottriggb)
	begin
	   if (bkgndfa<dottrigga) and (s_triggenda='1') then trigga<='1'; else trigga<='0'; end if;
	   if (bkgndfb<dottriggb) and (s_triggendb='1') then triggb<='1'; else triggb<='0'; end if;
		if (bkgndfar<dottrigga) and (s_triggenda='1') then triggar<='1'; else triggar<='0'; end if;
		if (bkgndfbr<dottriggb) and (s_triggendb='1') then triggbr<='1'; else triggbr<='0'; end if;
	end process;
							
	is_there_a_hit <= sorta(CONV_INTEGER(ejeta))(0) or sorta(CONV_INTEGER(ejeta))(1) or sorta(CONV_INTEGER(ejeta))(2);
	is_there_b_hit <= sortb(CONV_INTEGER(ejetb))(0) or sortb(CONV_INTEGER(ejetb))(1) or sortb(CONV_INTEGER(ejetb))(2);
	
---------------------------------------------------------------------
-- sorting tree signal makeup for CASE ???
---------------------------------------------------------------------

     rcont_bg_set_A  <= '1' when rconta>setejav else '0';
	  inside_ellip_A   <= '1' when ((reflecta_color2 > ellipay1) and (reflecta_color2 < ellipay2)) and (trigga='1') else '0';
	  set_eq_0_A       <= '1' when setejav=0 else '0';
	  inside_ellip_r_A <= '1' when ((reflectar_color2 > ellipay1r) and (reflectar_color2 < ellipay2r)) and (triggar='1') else '0';
     sort_case_a <=  entrigar & entriga & rcont_bg_set_A & inside_ellip_r_A & inside_ellip_A & set_eq_0_A  & flagea(CONV_INTEGER(ejeta));
	  
     rcont_bg_set_B  <= '1' when rcontb>setejbv else '0';
	  inside_ellip_B   <= '1' when ((reflectb_color2 > ellipby1) and (reflectb_color2 < ellipby2)) and (triggb='1') else '0';
	  set_eq_0_B       <= '1' when setejbv=0 else '0';
	  inside_ellip_r_B <= '1' when ((reflectbr_color2 > ellipby1r) and (reflectbr_color2 < ellipby2r)) and (triggbr='1') else '0';
     sort_case_b <=  entrigbr & entrigb & rcont_bg_set_B & inside_ellip_r_B & inside_ellip_B & set_eq_0_B  & flageb(CONV_INTEGER(ejetb));
	  
---------------------------------------------------------------------
--------------------- SRAM interface controller ---------------------
---------------------------------------------------------------------
	
	-- SRAM interface		  
	MDATA <= s_sram_input_data when (s_writing_sram = '1') else "ZZZZZZZZZZZZZZZZ";	-- Receive write data when flag is high, otherwise tristate
	MADDR <= s_sram_wr_addr when (s_writing_sram = '1') else s_sram_rd_addr;			-- Receive write address when flag is high, otherwise read address
	s_sram_wr_addr <= s_sram_sector & s_sram_line & s_last_pox;								-- Set writing address
																												--	(8 Sectors + 128 Lines + 256 16 bit pixel information)
																			
	process(reset, s_reading_sram_int, s_sram_read)
	begin
		if (reset = '1') or (s_sram_read = '1') then												-- On a reset or in case already read the SRAM data
			s_reading_sram <= '0';																		-- Set reading flag to '0'
		else
			if rising_edge(s_reading_sram_int) then												-- If flag coming from interface is set to '1'
				s_reading_sram <= '1';																	-- Set reading flag to '1'
			end if;
		end if;
	end process;
	
	process(reset, s_writing_sram_int, s_sram_written)
	begin
		if (reset = '1') or (s_sram_written = '1') then											-- On a reset or if SRAM already recorded
			s_writing_sram <= '0';																		-- Set writing flag to '0'
		else
			if rising_edge(s_writing_sram_int) then												-- If flag coming from interface is '1'
				s_writing_sram <= '1';																	-- Set writing flat to '1'
			end if;
		end if;
	end process;

----------------------------------------------------------------------------------------			  
---------------------------- SORT_CASE MODULE INSTANTIATION ----------------------------		  
----------------------------------------------------------------------------------------	
--SORT_CASE Chute A
	SORT_CASE_SIDEA : SORT_CASE
	Port map ( 
				SORT_CASE_i => sort_case_a, 	-- = entrigar & entriga & rcont_bg_set_A & inside_ellip_r_A & inside_ellip_A & set_eq_0_A  & flagea(CONV_INTEGER(ejeta));
				RCONT_i => rconta,				-- Memory defect counter
				INX_i =>	INX,						-- Current ellipsis
				CLK_i => clkaq,					-- 56 MHz clock
				RESET_i => reset or canincfifoline,		
				
				SHOT_X_o => s_SHOT_X_A,			-- 3 bit Shooting output decision
				WCONT_o => s_WCONTA				-- Updated defect counter
			);
--SORT_CASE Chute B
	SORT_CASE_SIDEB : SORT_CASE
	Port map ( 
				SORT_CASE_i => sort_case_b,
				RCONT_i => rcontb,
				INX_i => INX,
				CLK_i => clkaq,
				RESET_i => reset or canincfifoline,
				
				SHOT_X_o => s_SHOT_X_B,
				WCONT_o => s_WCONTB
			);
----------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------	

	s_ext_mux <= extpartag & s_extcam & s_ref_or_trans;
	
	-- Chutes A and B are in the same s_overusage_a (s_overusage_b is not used)
	s_overusage_a_coffee_int <= s_overusage_a(0) or s_overusage_a(1);
	s_overusage_a_coffee <= s_overusage_a_coffee_int & s_overusage_a(12 downto 2);
	
	s_overusage_b_coffee_int <= s_overusage_a(12) or s_overusage_a(13);
	s_overusage_b_coffee <= s_overusage_b_coffee_int & s_overusage_a(24 downto 14);
	
	s_overusage_int_a <= s_overusage_a_coffee(0) or s_overusage_a_coffee(1) or s_overusage_a_coffee(2) or s_overusage_a_coffee(3) or s_overusage_a_coffee(4) or 
								s_overusage_a_coffee(5) or s_overusage_a_coffee(6) or s_overusage_a_coffee(7) or s_overusage_a_coffee(8) or s_overusage_a_coffee(9) or 
								s_overusage_a_coffee(10) or s_overusage_a_coffee(11);
	
								
	s_overusage_int_b <= s_overusage_b_coffee(0) or s_overusage_b_coffee(1) or s_overusage_b_coffee(2) or s_overusage_b_coffee(3) or s_overusage_b_coffee(4) or 
								s_overusage_b_coffee(5) or s_overusage_b_coffee(6) or s_overusage_b_coffee(7) or s_overusage_b_coffee(8) or s_overusage_b_coffee(9) or 
								s_overusage_b_coffee(10) or s_overusage_b_coffee(11);
								
	process(reset, s_has_overusage_clr, s_overusage_int_a)
	begin
		if (reset = '1') or (s_has_overusage_clr = '1') then
			s_has_overusage_a <= '0';
		else
			if rising_edge(s_overusage_int_a) then
				s_has_overusage_a <= '1';
			end if;
		end if;
	
	end process;
	
	process(reset, s_has_overusage_clr, s_overusage_int_b)
	begin
		if (reset = '1') or (s_has_overusage_clr = '1') then
			s_has_overusage_b <= '0';
		else
			if rising_edge(s_overusage_int_b) then
				s_has_overusage_b <= '1';
			end if;
		end if;
	
	end process;
	
	s_en_ej_a <= extra(6) and not(s_has_overusage_a);
	s_en_ej_b <= extra(7) and not(s_has_overusage_b);
	
   process(clkaq,reset,canincfifoline,s_triggenda,s_triggendb, s_ext_mux) -- 56.25MHz
   begin
	  if (reset='1') or (canincfifoline='1') then
	    sortst<="0000000000000000000000000001";
	    flagea<=X"00000000";
	    flageb<=X"00000000";
	    flagxa<=X"00000000";
	    flagxb<=X"00000000";			

		 pox<=(others=>'0');
		 clkbd<='0';
	    extclrd<='0';
	    clrellia<='0';
	    clrellib<='0';
		 ellclka<='0';
		 ellclkb<='0';
       clkbellip<='0';
	    inx<="000";
	    extclrf<='0';
		 extclrag <= '0';
       extevent_flagf<='0';
		 wdefena<='0';
		 wdefenb<='0';
		 ejeta<="00000";
		 nejeta<="00000";
		 ejetb<="00000";
		 nejetb<="00000";
		 clkbf<='0';
		 trigmema<=X"00000000";
		 trigmemb<=X"00000000";

		---------------------------------------------------------------------
		--------------------- SRAM interface controller ---------------------
		---------------------------------------------------------------------
		if reset = '1' then
			s_reading_sram_active <= '0';
			s_sram_read <= '0';
			s_sram_written <= '0';
			s_writing_sram_active <= '0';
			s_sram_line <= (others => '0');
			s_release_line_inc_counter <= '0';

		---------------------------------------------------------------------
		-------------------- Multiple ejection supressor --------------------
		---------------------------------------------------------------------
		  s_has_grain_A <= (others=>'0');
		  s_has_grain_B <= (others=>'0');
		  s_was_trigmema <= '0';
		  s_was_trigmemb <= '0';
		  
		---------------------------------------------------------------------
		end if;

		shot_1a<="000";
		shot_2a<="000";
		shot_3a<="000";
		shot_4a<="000";
		shot_5a<="000";
		shot_6a<="000";
		shot_7a<="000";
		shot_1b<="000";
		shot_2b<="000";
		shot_3b<="000";
		shot_4b<="000";
		shot_5b<="000";
		shot_6b<="000";
		shot_7b<="000";
		
      inside_ellip_r_Am<='0';
		inside_ellip_r_Bm<='0';
		inside_ellip_Am<='0';
		inside_ellip_Bm<='0';
		rcont_bg_set_Am<='0';
		rcont_bg_set_Bm<='0';
		
		 
-- Auto-Grab Table

		s_cansum <= '0';
		
	  elsif rising_edge(clkaq) then -- this will run for 256*12*3 clock cycles
-- defaults	  
			
	    extclrd<='0';
        wendota(0)<='0';
       wendotb(0)<='0';
	    clrellia<='0';
	    clrellib<='0';
		 ellclka<='0';
		 ellclkb<='0';
       clkbellip<='0';
	    extclrf<='0';
		 extclrag <= '0';
		 wdefena<='0';
		 wdefenb<='0';
		 clkbf<='0';
		 clkbd<='0';
		 debadd<='0'; 
		 
		---------------------------------------------------------------------
		--------------------- SRAM interface controller ---------------------
		---------------------------------------------------------------------
		s_sram_read <= '0'; 		-- Assures this flag will be active for only 1 cycle
		s_sram_written <= '0';
		
--		LED2 <= not(s_writing_sram);
		---------------------------------------------------------------------
		 
-- the CASE -----------------------------		 
      case sortst is
--  1 ----------------------------------------------------------------------------------------	step 3 at main machine		  
		  when "0000000000000000000000000001" => sortst<="0000000000000000000000000010";
			  if (trigga='1') or (triggar='1') then 
					trigmema(CONV_INTEGER(ejeta))<='1'; 
			  end if;
			  
			  if (triggb='1') or (triggbr='1') then 
					trigmemb(CONV_INTEGER(ejetb))<='1'; 
			  end if;

            oldflagxa <= flagxa(CONV_INTEGER(ejeta));
            oldflagxb <= flagxb(CONV_INTEGER(ejetb));
				
		      inx<="001";
         	ejeta <= tabejeta(CONV_INTEGER(pox)); -- get ejector number according to pixel
				nejeta <= tabejeta(CONV_INTEGER(npox));
				ejetb <= tabejetb(CONV_INTEGER(pox)); -- get ejector number according to pixel
				nejetb <= tabejetb(CONV_INTEGER(npox));
				
         -- Line FIFO sorting read
			   clkbf<='1';  -- read B side of FIFO
				
			-- Async Auto-Gain external access control
			  if exteventag_req='1' then exteventag_flag<='1'; end if;
			  
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram = '1' then													-- If writing on the SRAM memory
				MWR <= '0';																		-- Set write to '0' (NOT logic)
				MCS <= '0';																		-- Wake memory
				MOE <= '1';  																	-- Disable outputs ('Z')
				s_sram_sector <= "000";														-- Set first sector to be recorded
				s_sram_input_data <= s_ramdata_0;										-- Set first word to be written on the memory
				if pox = "00000000" then													-- Only if the current pixel is pixel 0
					s_writing_sram_active <= '1';											-- Flag to assure the FPGA will set all the flags and start the writing
				end if;
																									-- process here
			else
				MOE <= '0';  																	-- Enable outputs ('Z')
				MWR <= '1';																		-- Set write to '0' (NOT logic)
				s_sram_rd_addr <= s_sram_int_rd_addr;									--	Get reading address from X"F1" command
				if s_reading_sram = '1' then												-- If interface is reading
					MCS <= '0';																	-- Set Output enable to '0', memory enabled (NOT logic)
					s_reading_sram_active <= '1';											-- Flag to assure the FPGA will set all the flags and start the reading
																									-- process here
				else																				-- If not reading or writing
					MCS <= '1';																	-- Set Output enable to '1', memory disabled (NOT logic)
				end if;
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
								
--  2 ---------------------------------------------------------------------------------------- read POX indexed data			  
		  when "0000000000000000000000000010" => sortst<="0000000000000000000000000100";

            reflecta_color1 <= data_raf(15 downto 8); -- Front CCD, reflectance (Front illumination) CHUTE A (rear camera is 7 downto 0)
	         reflecta_color2 <= data_rar(15 downto 8); -- Front CCD, translucence (Rear illumination)
            reflectb_color1 <= data_rbf(15 downto 8); -- Front CCD, reflectance (Front illumination) CHUTE B
	         reflectb_color2 <= data_rbr(15 downto 8); -- Front CCD, translucence (Rear illumination)
				
            reflectar_color2 <= data_raf_camrear(7 downto 0); -- Front CCD, reflectance (Front illumination) CHUTE A (rear camera is 7 downto 0)
	         reflectar_color1 <= data_rar(7 downto 0); -- Front CCD, translucence (Rear illumination)
            reflectbr_color2 <= data_rbf_camrear(7 downto 0); -- Front CCD, reflectance (Front illumination) CHUTE B
	         reflectbr_color1 <= data_rbr(7 downto 0); -- Front CCD, translucence (Rear illumination)

				if conf(6) = '1' then
					bkgndfa<=data_rab(15 downto 8); -- front ccd 
					bkgndfar<=data_rab_rear(7 downto 0); -- front ccd 
				else
					bkgndfa<=X"7F";
					bkgndfar<=X"7F";
				end if;
				
				if conf(7) = '1' then
					bkgndfb<=data_rbb(15 downto 8); -- front ccd
					bkgndfbr<=data_rbb_rear(7 downto 0); -- front ccd
				else
					bkgndfb<=X"7F";
					bkgndfbr<=X"7F";
				end if;
				
--  3 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000000000000100" => sortst<="0000000000000000000000001000";
		  
			---------------------------------------------------------------------
			-------------------- Multiple ejection supressor --------------------
			---------------------------------------------------------------------
			  if (trigga='1') or (triggar='1') then 
					s_has_grain_A(CONV_INTEGER(ejeta)) <= '1';
			  end if;
			  
			  if (triggb='1') or (triggbr='1') then 
					s_has_grain_B(CONV_INTEGER(ejetb)) <= '1';
			  end if;
			---------------------------------------------------------------------
		  
			-- Async Auto-Gain external access control
			if exteventag_flag='1' then
				case s_ext_mux is
				
				-- Gain
					when "000" => extdatareadag <= s_illum_a(63 downto 48);	-- Side A, Front Cam, Reflectance Color 1 ACC 
					when "001" => extdatareadag <= s_illum_a(31 downto 16);	-- Side A, Front Cam, Reflectance Color 2 ACC
					when "010" => extdatareadag <= s_illum_a(15 downto 0);	-- Side A, Rear Cam, Reflectance Color 1 ACC2
					when "011" => extdatareadag <= s_illum_a(47 downto 32);	-- Side A, Rear Cam, Reflectance Color 2 ACC2
					when "100" => extdatareadag <= s_illum_b(63 downto 48);	-- Side B, Front Cam, Reflectance Color 1 ACCB
					when "101" => extdatareadag <= s_illum_b(31 downto 16);	-- Side B, Front Cam, Reflectance Color 2 ACCB
					when "110" => extdatareadag <= s_illum_b(15 downto 0);	-- Side B, Rear Cam, Reflectance Color 1 ACC2B
					when "111" => extdatareadag <= s_illum_b(47 downto 32); 	-- Side B, Rear Cam, Reflectance Color 2 ACC2B

					when others =>
				end case;
			end if;
				
        entriga <= (trigga or (trigmema(CONV_INTEGER(ejeta)))) and s_en_ej_a and (not s_floor);
	     entrigb <= (triggb or (trigmemb(CONV_INTEGER(ejetb)))) and s_en_ej_b and (not s_floor);
		  
        entrigar <= (triggar or (trigmema(CONV_INTEGER(ejeta)))) and s_en_ej_a and (not s_floor);
	     entrigbr <= (triggbr or (trigmemb(CONV_INTEGER(ejetb)))) and s_en_ej_b and (not s_floor);
				
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then					-- If writing on the SRAM memory
				s_sram_sector <= "001";								-- Set second sector to be recorded
				if (((trigga = '1') or (triggar = '1')) and (s_grab_a_or_b = '0')) or 
					(((triggb = '1') or (triggbr = '1')) and (s_grab_a_or_b = '1')) then -- If there is a presence detected
					s_release_line_inc_counter <= '1';			-- Release line incrementation
				end if;
			else
				if s_reading_sram_active = '1' then				-- Flag that assures the FPGA is reading everything correct	
					s_sram_output_data <= MDATA;					-- Read memory output data
					s_sram_read <= '1';								-- Clear s_reading_sram flag (command X"F1")
					s_reading_sram_active <= '0';					-- Set reading active flag to '0'
				end if;
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
				
--  4 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000000000001000" => sortst<="0000000000000000000000010000";
           clkbd<='0';
			  
			 -- Mean 16K
			  s_cansum <= s_has_new;
				
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_input_data <= s_ramdata_1;		-- Set second word to be written on the memory
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			  
----------------------------------------------------------------------------------------------
--  5 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000000000010000" => sortst<="0000000000000000000000100000";
         -- handle clearing of defect counter structure at last pixel of current ejector
			
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			s_was_trigmema <= trigmema(CONV_INTEGER(ejeta)) or trigga or triggar;
			s_was_trigmemb <= trigmemb(CONV_INTEGER(ejetb)) or triggb or triggbr;
			---------------------------------------------------------------------

			  if (((ejeta/=nejeta) and (s_triggenda='1')) or (pox = pixenda)) then --pox>pixstarta) then --and (pox<pixenda) then -- means it is the last pixel of the current ejector
				  
				  trigmema(CONV_INTEGER(ejeta))<='0';	-- is the last pixel of the channel so reset trigger memory
			     if (trigmema(CONV_INTEGER(ejeta))='0' and (entriga='0' and entrigar='0')) or (oldflagxa='0' and entriga='0') or (oldflagxa='0' and entrigar='0') then 
				     flagea(CONV_INTEGER(ejeta))<='1'; -- must clear the defect counter
				  else
					  flagea(CONV_INTEGER(ejeta))<='0'; -- still have a trigger so keep counter counting
				  end if;	  
			  end if;
			  
			  if (((ejetb/=nejetb) and (s_triggendb='1')) or (pox = pixendb)) then --(pox>pixstartb) then -- and (pox<pixendb) then -- means it is the last pixel of the current ejector
			  
				  trigmemb(CONV_INTEGER(ejetb))<='0';	-- is the last pixel of the channel so reset trigger memory
			     if (trigmemb(CONV_INTEGER(ejetb))='0') or (oldflagxb='0' and entrigb='0') or (oldflagxb='0' and entrigbr='0') then 
				     flageb(CONV_INTEGER(ejetb))<='1'; -- must clear the defect counter
				  else
					  flageb(CONV_INTEGER(ejetb))<='0'; -- still have a trigger so keep counter counting
				  end if;	  
			  end if;
				
--------------
           clkbellip<='1'; -- read ellipse with INX 
				
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_sector <= "010";						-- Set third sector to be recorded
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
				
--  6 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000000000100000" => sortst<="0000000000000000000001000000";
         -- sorting tree -------------------------------------------------------------------------------------------		
			
		  if (sort_case_a(6 downto 5)/="00") and (sort_case_a(4)='0') and (sort_case_a(3 downto 2)/="00") then flagxa(CONV_INTEGER(ejeta))<='1'; end if;
		  if (sort_case_b(6 downto 5)/="00") and (sort_case_b(4)='0') and (sort_case_b(3 downto 2)/="00") then flagxb(CONV_INTEGER(ejetb))<='1'; end if;

		  shot_1a <= s_SHOT_X_A;
		  wconta <= s_WCONTA;

        shot_1b <= s_SHOT_X_B;
		  wcontb <= s_WCONTB;
		  
			  
		     wdefena<='1'; wdefenb<='1';
			  
			 -- Mean 16K
			  s_cansum <= '0';
			  
			-- ellipse memory ext access
			  if extellia='1' then ellclka<='1'; clrellia<='1'; end if;
			  if extellib='1' then ellclkb<='1'; clrellib<='1'; end if;
--			-- dot memory
           clkbd<='0';
				
-- debug	information -----------------------------------------------		  
			  deb_trans<=rconta;
			  deb_refle<= flagea(CONV_INTEGER(ejeta)) & "00" & ejeta;
			  deb_reflec<=reflecta_color1;
			  deb_y1<=ellipay1;
			  deb_y2<=ellipay2;
			  inside_ellip_r_Am<=inside_ellip_r_A;
			  inside_ellip_r_Bm<=inside_ellip_r_B;
			  inside_ellip_Am<=inside_ellip_A;
			  inside_ellip_Bm<=inside_ellip_B;
			  rcont_bg_set_Am <= rcont_bg_set_A;
			  rcont_bg_set_Bm <= rcont_bg_set_B;
			  
			  deb_transb<=rcontb;
			  deb_refleb<= flageb(CONV_INTEGER(ejetb)) & "00" & ejetb;
			  deb_reflecb<=reflectb_color1;
			  deb_y1b<=ellipby1;
			  deb_y2b<=ellipby2;
				
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_input_data <= s_ramdata_2;		-- Set third word to be written on the memory
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			
--  7 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000000001000000" => sortst<="0000000000000000000010000000";
			  inx<="010";
				
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_sector <= "011";						-- Set fourth sector to be recorded
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			
----------------------------------------------------------------------------------------------
--  8 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000000010000000" => sortst<="0000000000000000000100000000";
           clkbellip<='1'; -- read ellipse with INX (combinatorial logic is now comparing values)
			  
			  -- dot trigger
			  if trigga='1'   then dotfla<='1';  dotconta<=dotconta+1; else dotfla<='0'; end if;
			  if triggb='1'   then dotflb<='1';  dotcontb<=dotcontb+1; else dotflb<='0'; end if;
			  if triggar='1'  then dotflra<='1';  dotcontra<=dotcontra+1; else dotflra<='0'; end if;
			  if triggbr='1'  then dotflrb<='1';  dotcontrb<=dotcontrb+1; else dotflrb<='0'; end if;
			  if extra(0)='1' then dotfla<='1'; dotconta<=dotconta+1; end if; -- force write to clear the dot memory
			  if extra(0)='1' then dotflra<='1'; dotcontra<=dotcontra+1; end if; -- force write to clear the dot memory
			  if extra(1)='1' then dotflb<='1'; dotcontb<=dotcontb+1; end if;
			  if extra(1)='1' then dotflrb<='1'; dotcontrb<=dotcontrb+1; end if;

			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_input_data <= s_ramdata_3;		-- Set fourth word to be written on the memory
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------

--  9 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000000100000000" => sortst<="0000000000000000001000000000";
         -- sorting tree -------------------------------------------------------------------------------------------		  
		  if (sort_case_a(6 downto 5)/="00") and (sort_case_a(4)='0') and (sort_case_a(3 downto 2)/="00") then flagxa(CONV_INTEGER(ejeta))<='1'; end if;
		  if (sort_case_b(6 downto 5)/="00") and (sort_case_b(4)='0') and (sort_case_b(3 downto 2)/="00") then flagxb(CONV_INTEGER(ejetb))<='1'; end if;

		  shot_2a <= s_SHOT_X_A;
		  wconta <= s_WCONTA;

        shot_2b <= s_SHOT_X_B;
		  wcontb <= s_WCONTB;
			  
		     wdefena<='1'; wdefenb<='1';
			-- DOT memory rear
			  addrdotwa<="000"&dotcontra;
			  addrdotwb<="000"&dotcontrb; 
			  if extra(0)='1' then  data_dwa<=X"FFFE"; else data_dwa <= reflectar_color2 & reflectar_color1; end if;
			  if extra(1)='1' then  data_dwb<=X"FFFE"; else data_dwb <= reflectbr_color2 & reflectbr_color1; end if;
			-- ellipse memory ext access
			  if extellia='1' then ellclka<='1'; clrellia<='1'; end if;
			  if extellib='1' then ellclkb<='1'; clrellib<='1'; end if;
			  
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_sector <= "100";						-- Set fifth sector to be recorded
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------

-- 10 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000001000000000" => sortst<="0000000000000000010000000000";
			  inx<="011";
			-- DOT memory
			  if dotflra='1' then wendota(0)<='1'; end if;
			  if dotflrb='1' then wendotb(0)<='1'; end if;
				
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_input_data <= s_ramdata_4;		-- Set fifth word to be written on the memory
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
				
----------------------------------------------------------------------------------------------
-- 11 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000010000000000" => sortst<="0000000000000000100000000000";
           clkbellip<='1'; -- read ellipse with INX (combinatorial logic is now comparing values)
			-- DOT memory front
			  addrdotwa<="001"&dotconta;
			  addrdotwb<="001"&dotcontb;
			  if extra(0)='1' then  data_dwa<=X"FFFE"; else data_dwa<=reflecta_color2 & reflecta_color1; end if;
			  if extra(1)='1' then  data_dwb<=X"FFFE"; else data_dwb<=reflectb_color2 & reflectb_color1; end if;

			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_sector <= "101";						-- Set sixth sector to be recorded
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------

-- 12 ----------------------------------------------------------------------------------------			  
		  when "0000000000000000100000000000" => sortst<="0000000000000001000000000000";
         -- sorting tree -------------------------------------------------------------------------------------------		  
		  if (sort_case_a(6 downto 5)/="00") and (sort_case_a(4)='0') and (sort_case_a(3 downto 2)/="00") then flagxa(CONV_INTEGER(ejeta))<='1'; end if;
		  if (sort_case_b(6 downto 5)/="00") and (sort_case_b(4)='0') and (sort_case_b(3 downto 2)/="00") then flagxb(CONV_INTEGER(ejetb))<='1'; end if;

		  shot_3a <= s_SHOT_X_A;
		  wconta <= s_WCONTA;

        shot_3b <= s_SHOT_X_B;
		  wcontb <= s_WCONTB;
			  
		     wdefena<='1'; wdefenb<='1';
			-- DOT memory
			  if dotfla='1' then wendota(0)<='1'; end if;
			  if dotflb='1' then wendotb(0)<='1'; end if;
			-- ellipse memory ext access
			  if extellia='1' then ellclka<='1'; clrellia<='1'; end if;
			  if extellib='1' then ellclkb<='1'; clrellib<='1'; end if;	
			  
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_input_data <= s_ramdata_5;		-- Set sixth word to be written on the memory
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------

-- 13 ----------------------------------------------------------------------------------------			  
		  when "0000000000000001000000000000" => sortst<="0000000000000010000000000000";
			  inx<="100";

-- debug
			   
			  if extra(0)='1' then addrdotwa<="010"& pox; else addrdotwa<="010"&deb_reflec; end if;
			  if extra(0)='1' then data_dwa<=X"0000"; else data_dwa<=deb_y1 & deb_y2; end if;

			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_sector <= "110";						-- Set seventh sector to be recorded
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------

----------------------------------------------------------------------------------------------
-- 14 ----------------------------------------------------------------------------------------			  
		  when "0000000000000010000000000000" => sortst<="0000000000000100000000000000";
           clkbellip<='1'; -- read ellipse with INX (combinatorial logic is now comparing values)
-- debug
			  if dotfla='1' then wendota(0)<='1'; end if;
			  
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_input_data <= s_ramdata_6;		-- Set seventh word to be written on the memory
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			  
-- 15 ----------------------------------------------------------------------------------------			  
		  when "0000000000000100000000000000" => sortst<="0000000000001000000000000000";
         -- sorting tree -------------------------------------------------------------------------------------------		  
		  if (sort_case_a(6 downto 5)/="00") and (sort_case_a(4)='0') and (sort_case_a(3 downto 2)/="00") then flagxa(CONV_INTEGER(ejeta))<='1'; end if;
		  if (sort_case_b(6 downto 5)/="00") and (sort_case_b(4)='0') and (sort_case_b(3 downto 2)/="00") then flagxb(CONV_INTEGER(ejetb))<='1'; end if;

		  shot_4a <= s_SHOT_X_A;
		  wconta <= s_WCONTA;

        shot_4b <= s_SHOT_X_B;
		  wcontb <= s_WCONTB;
		  
		     wdefena<='1'; wdefenb<='1';
			  
-- debug
			  if extra(0)='1' then addrdotwa<="011"& pox; else addrdotwa<="011"&dotconta; end if;
			  if extra(0)='1' then data_dwa<=X"0000"; else data_dwa<=deb_trans & deb_refle; end if;

			-- ellipse memory ext access
			  if extellia='1' then ellclka<='1'; clrellia<='1'; end if;
			  if extellib='1' then ellclkb<='1'; clrellib<='1'; end if;
			  
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_sector <= "111";						-- Set eighth sector to be recorded
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			  
-- 16 ----------------------------------------------------------------------------------------			  
		  when "0000000000001000000000000000" => sortst<="0000000000010000000000000000";
			  inx<="101";
			  
-- debug
			  if dotfla='1' then wendota(0)<='1'; end if;
				
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if s_writing_sram_active = '1' then			-- If writing on the SRAM memory
				s_sram_input_data <= s_ramdata_7;		-- Set eighth word to be written on the memory
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
				
----------------------------------------------------------------------------------------------
-- 17 ----------------------------------------------------------------------------------------			  
		  when "0000000000010000000000000000" => sortst<="0000000000100000000000000000";
           clkbellip<='1'; -- read ellipse with INX (combinatorial logic is now comparing values)
				
-- debug
			   
			  if extra(0)='1' then addrdotwa<="110"& pox; else addrdotwa<="110"&deb_reflecb; end if; -- save side B data on DOT_A area for debug
			  if extra(0)='1' then data_dwa<=X"0000"; else data_dwa<=deb_y1b & deb_y2b; end if;

								
-- 18 ----------------------------------------------------------------------------------------			  
		  when "0000000000100000000000000000" => sortst<="0000000001000000000000000000";
-- debug
			  if dotflb='1' then wendota(0)<='1'; end if;
         -- sorting tree -------------------------------------------------------------------------------------------		  
		  if (sort_case_a(6 downto 5)/="00") and (sort_case_a(4)='0') and (sort_case_a(3 downto 2)/="00") then flagxa(CONV_INTEGER(ejeta))<='1'; end if;
		  if (sort_case_b(6 downto 5)/="00") and (sort_case_b(4)='0') and (sort_case_b(3 downto 2)/="00") then flagxb(CONV_INTEGER(ejetb))<='1'; end if;

		  shot_5a <= s_SHOT_X_A;
		  wconta <= s_WCONTA;

        shot_5b <= s_SHOT_X_B;
		  wcontb <= s_WCONTB;

		     wdefena<='1'; wdefenb<='1';

			-- ellipse memory ext access
			  if extellia='1' then ellclka<='1'; clrellia<='1'; end if;
			  if extellib='1' then ellclkb<='1'; clrellib<='1'; end if;

-- 19 ----------------------------------------------------------------------------------------			  
		  when "0000000001000000000000000000" => sortst<="0000000010000000000000000000";
			  inx<="110";
-- debug
			  if extra(0)='1' then addrdotwa<="111"& pox; else addrdotwa<="111"&dotcontb; end if; -- save side B data on DOT_A area for debug
			  if extra(0)='1' then data_dwa<=X"0000"; else data_dwa<=deb_transb & deb_refleb; end if;

----------------------------------------------------------------------------------------------
-- 20 ----------------------------------------------------------------------------------------			  
		  when "0000000010000000000000000000" => sortst<="0000000100000000000000000000";
           clkbellip<='1'; -- read ellipse with INX (combinatorial logic is now comparing values)
-- debug
			  if dotflb='1' then wendota(0)<='1'; end if;

-- 21 ----------------------------------------------------------------------------------------			  
		  when "0000000100000000000000000000" => sortst<="0000001000000000000000000000";
         -- sorting tree -------------------------------------------------------------------------------------------		  
		  if (sort_case_a(6 downto 5)/="00") and (sort_case_a(4)='0') and (sort_case_a(3 downto 2)/="00") then flagxa(CONV_INTEGER(ejeta))<='1'; end if;
		  if (sort_case_b(6 downto 5)/="00") and (sort_case_b(4)='0') and (sort_case_b(3 downto 2)/="00") then flagxb(CONV_INTEGER(ejetb))<='1'; end if;

		  shot_6a <= s_SHOT_X_A;
		  wconta <= s_WCONTA;

        shot_6b <= s_SHOT_X_B;
		  wcontb <= s_WCONTB;

		     wdefena<='1'; wdefenb<='1';
			  
			-- ellipse memory ext access
			  if extellia='1' then ellclka<='1'; clrellia<='1'; end if;
			  if extellib='1' then ellclkb<='1'; clrellib<='1'; end if;
				
-- 22 ----------------------------------------------------------------------------------------			  
		  when "0000001000000000000000000000" => sortst<="0000010000000000000000000000";
			  inx<="111";
			  
         -- FIFO ext access -- peak v2
			  if extevent_reqf='1' then extevent_flagf<='1'; end if; -- peak v2
			  
         -- DOT memory				
			  if extevent_reqd='1' then extevent_flagd<='1'; end if; -- this flag is tested at main machine
			  
----------------------------------------------------------------------------------------------
-- 23 ----------------------------------------------------------------------------------------			  
		  when "0000010000000000000000000000" => sortst<="0000100000000000000000000000";
           clkbellip<='1'; -- read ellipse with INX (combinatorial logic is now comparing values)

-- 24 ----------------------------------------------------------------------------------------			  
		  when "0000100000000000000000000000" => sortst<="0001000000000000000000000000";
         -- sorting tree -------------------------------------------------------------------------------------------		  
		  if (sort_case_a(6 downto 5)/="00") and (sort_case_a(4)='0') and (sort_case_a(3 downto 2)/="00") then flagxa(CONV_INTEGER(ejeta))<='1'; end if;
		  if (sort_case_b(6 downto 5)/="00") and (sort_case_b(4)='0') and (sort_case_b(3 downto 2)/="00") then flagxb(CONV_INTEGER(ejetb))<='1'; end if;

		  shot_7a <= s_SHOT_X_A;
		  wconta <= s_WCONTA;

        shot_7b <= s_SHOT_X_B;
		  wcontb <= s_WCONTB;

		     wdefena<='1'; wdefenb<='1';
			  
         -- Line FIFO ext access read -- peak v2
			  clkbf<='1';  -- read B side of FIFO 
			  
			-- DOT memory
			  clkbd<='1';
			  
			-- ellipse memory ext access
			  if extellia='1' then ellclka<='1'; clrellia<='1'; end if;
			  if extellib='1' then ellclkb<='1'; clrellib<='1'; end if;
			  
-- 25 ----------------------------------------------------------------------------------------			  
		  when "0001000000000000000000000000" => sortst<="0010000000000000000000000000";
			  inx<="000";
			  
			  sorta(CONV_INTEGER(ejeta))<= shot_1a or shot_2a or shot_3a or shot_4a or shot_5a or shot_6a or shot_7a;
			  sortb(CONV_INTEGER(ejetb))<= shot_1b or shot_2b or shot_3b or shot_4b or shot_5b or shot_6b or shot_7b;
				
         -- FIFO ext access -- peak v2
			  if extevent_flagf='1' then
				  case extpartf is
					 when "000" => extdatareadf <= data_rab(15 downto 8) & data_rab_rear(7 downto 0); -- background chute A
					 when "001" => extdatareadf <= data_rar(15 downto 8) & data_raf_camrear(7 downto 0); -- rear chute A
					 when "010" => extdatareadf <= data_raf(15 downto 8) & data_rar(7 downto 0); -- front chute A
					 when "011" => extdatareadf <= X"0505"; -- never accessed.. just in case it reads this cosntant 
					 when "100" => extdatareadf <= data_rbb(15 downto 8) & data_rbb_rear(7 downto 0); -- background chute B
					 when "101" => extdatareadf <= data_rbr(15 downto 8) & data_rbf_camrear(7 downto 0); -- rear chute B
					 when "110" => extdatareadf <= data_rbf(15 downto 8) & data_rbr(7 downto 0); -- front chute B
					 when "111" => extdatareadf <= X"1234"; -- never accessed.. just in case it reads this cosntant 
					 when others => 
				  end case;
			  end if;
			  
			-- DOT memory
			  if extevent_flagd='1' then
			     if extpart(0)='0' then
						extdatareadot <= data_dra;
				  else 
						extdatareadot <= data_drb;
				  end if;
			  end if;
			  
			---------------------------------------------------------------------
			--------------------- SRAM interface controller ---------------------
			---------------------------------------------------------------------
			if (s_debug_or_normal = '0') then
				if (s_grab_a_or_b = '0') then
				
				  s_ramdata_0 <= bkgndfa & bkgndfar;--triggar & trigga & s_probe(2 downto 1) & ejatxdata(0) & s_was_trigmema &
	--			  s_has_grain_A(CONV_INTEGER(ejeta)) & ((trigga or (trigmema(CONV_INTEGER(ejeta)))) and s_en_ej_a and (not floor) AND (not extfloor));
				  s_ramdata_1 <= reflecta_color1 & reflectar_color1;--ejeta & rcont_bg_set_Am & inside_ellip_Am & inside_ellip_r_Am;
				  s_ramdata_2 <= reflecta_color2 & reflectar_color2;--is_there_a_hit & deb_trans(4 downto 0) & flagea(CONV_INTEGER(ejeta)) & flagxa(CONV_INTEGER(ejeta));
				  s_ramdata_3 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_4 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_5 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_6 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_7 <= s_last_pox & '0' & s_sram_line;
				  
				else
				
				  s_ramdata_0 <= bkgndfb & bkgndfbr;--triggbr & triggb & s_probe(4 downto 3) & ejbtxdata(0) & s_was_trigmemb &
	--			  s_has_grain_B(CONV_INTEGER(ejetb)) & ((triggb or (trigmemb(CONV_INTEGER(ejetb)))) and s_en_ej_b and (not floor) AND (not extfloor));
				  s_ramdata_1 <= reflectb_color1 & reflectbr_color1;--ejeta & rcont_bg_set_Am & inside_ellip_Am & inside_ellip_r_Am;
				  s_ramdata_2 <= reflectb_color2 & reflectbr_color2;--is_there_a_hit & deb_trans(4 downto 0) & flagea(CONV_INTEGER(ejeta)) & flagxa(CONV_INTEGER(ejeta));
				  s_ramdata_3 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_4 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_5 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_6 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_7 <= s_last_pox & '0' & s_sram_line;
				  
				end if;
			else
			
				if (s_grab_a_or_b = '0') then
				
				  s_ramdata_0 <= bkgndfa & triggar & trigga & s_probe(2 downto 1) & ejatxdata(0) & s_was_trigmema &
				  s_has_grain_A(CONV_INTEGER(ejeta)) & ((trigga or (trigmema(CONV_INTEGER(ejeta)))) and s_en_ej_a and (not floor) AND (not extfloor));
				  s_ramdata_1 <= reflecta_color1 & ejeta & rcont_bg_set_Am & inside_ellip_Am & inside_ellip_r_Am;
				  s_ramdata_2 <= reflecta_color2 & is_there_a_hit & deb_trans(4 downto 0) & flagea(CONV_INTEGER(ejeta)) & flagxa(CONV_INTEGER(ejeta));
				  s_ramdata_3 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_4 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_5 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_6 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_7 <= s_last_pox & '0' & s_sram_line;
				  
				else
				
				  s_ramdata_0 <= bkgndfbr & triggbr & triggb & s_probe(4 downto 3) & ejbtxdata(0) & s_was_trigmemb &
				  s_has_grain_B(CONV_INTEGER(ejetb)) & ((triggb or (trigmemb(CONV_INTEGER(ejetb)))) and s_en_ej_b and (not floor) AND (not extfloor));
				  s_ramdata_1 <= reflectbr_color1 & ejeta & rcont_bg_set_Am & inside_ellip_Am & inside_ellip_r_Am;
				  s_ramdata_2 <= reflectbr_color2 & is_there_a_hit & deb_trans(4 downto 0) & flagea(CONV_INTEGER(ejeta)) & flagxa(CONV_INTEGER(ejeta));
				  s_ramdata_3 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_4 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_5 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_6 <= s_last_pox & '0' & s_sram_line;
				  s_ramdata_7 <= s_last_pox & '0' & s_sram_line;
				  
				end if;
			
			end if;
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			---------------------------------------------------------------------
			  
----------------------------------------------------------------------------------------------
-- 26 ----------------------------------------------------------------------------------------			  
		  when "0010000000000000000000000000" => sortst<="0100000000000000000000000000";
						
			if pox=X"FE" then 
				sortst<="1000000000000000000000000000"; 
						
				---------------------------------------------------------------------
				--------------------- SRAM interface controller ---------------------
				---------------------------------------------------------------------
				if s_writing_sram_active = '1' then					-- If writing on the SRAM memory
					if s_sram_line = "1111111" then					-- Test if all 128 lines were written
						s_sram_line <= "0000000";						-- Set line to 0 again
						s_writing_sram_active <= '0';					-- Set writing flag to 0
						s_sram_written <= '1';							-- Clear latch
						MOE <= '0';  										-- Enable outputs
						MWR <= '1';											-- Set write to '0' (NOT logic)
						MCS <= '1';											-- Set Output enable to '0', memory disabled (NOT logic)
						s_release_line_inc_counter <= '0';			-- Set flag that indicates if there was a presence to '0'
					else														-- If did not reach all 128 lines written
						if s_release_line_inc_counter = '1' then	-- If flag indicating there was a presence is active
							s_sram_line <= s_sram_line + '1';		-- Increase line being written
						end if;
					end if;
				end if;
				---------------------------------------------------------------------
				---------------------------------------------------------------------
				---------------------------------------------------------------------
						
			  end if; 
				

-- 27 ----------------------------------------------------------------------------------------			  
		  when "0100000000000000000000000000" => sortst<="0000000000000000000000000001";
		     pox <= pox+1;
			  -- do this now because next loop ejet=nejet
			  
			  if ((ejeta/=nejeta) or (pox = pixenda)) then 
					flagea(CONV_INTEGER(ejeta))<='0'; 
					flagxa(CONV_INTEGER(ejeta))<='0'; 
					sorta(CONV_INTEGER(ejeta))<="000"; 
					
				---------------------------------------------------------------------
				-------------------- Multiple ejection supressor --------------------
				---------------------------------------------------------------------
					s_has_grain_A(CONV_INTEGER(ejeta)) <= s_was_trigmema;
				---------------------------------------------------------------------
					
			  end if;
			  
			  if ((ejetb/=nejetb) or (pox = pixendb)) then 
					flageb(CONV_INTEGER(ejetb))<='0'; 
					flagxb(CONV_INTEGER(ejetb))<='0'; 
					sortb(CONV_INTEGER(ejetb))<="000"; 
					
				---------------------------------------------------------------------
				-------------------- Multiple ejection supressor --------------------
				---------------------------------------------------------------------
					s_has_grain_B(CONV_INTEGER(ejetb)) <= s_was_trigmemb;
				---------------------------------------------------------------------
					
			  end if;
			  
			  if s_triggenda='0' then sorta(CONV_INTEGER(ejeta))<="000"; end if;
			  if s_triggendb='0' then sortb(CONV_INTEGER(ejetb))<="000"; end if;
		  			  
			-- Async Auto-Gain external access control
			  if exteventag_flag='1' then exteventag_flag<='0'; extclrag<='1'; end if;
					  
         -- FIFO ext access -- peak v2
			  if extevent_flagf='1' then extevent_flagf<='0'; extclrf<='1'; end if;
			  
			-- DOT memory
			  if extevent_flagd='1' then extevent_flagd<='0'; extclrd<='1'; end if;
			  
-- 28 ----------------------------------------------------------------------------------------			  
		  when "1000000000000000000000000000" => sortst<="1000000000000000000000000000";
		  pox<=(others=>'0');
		  
		  -- stays here nicelly till new life begins
		  
		  when others => sortst<="0000000000000000000000000001";
	   end case;
     end if;
	end process;  
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--	test(0) <= sorta(CONV_INTEGER(ejeta))(0);
--   test(2) <= rx232;		 
--	test(3) <= ejatxdata(0); --gotxd; -- debug002;
--   test(4) <= led_reset and clkx; -- lwr;			 
--	test(6) <= sortb(CONV_INTEGER(ejetb))(0); --dtrd; -- lumstpd(5);--exttype; --laddr(0);
--   test(7) <= ejbtxdata(0); --rxrdy; -- lumstpd(4);--extevent_req;--Led_reset and lclk;
--   test(8) <= busy_flag; -- lumstpd(3);--extevent;
--	test(9) <= busy_clr;
--   test(10)<= led_reset and clkaq;
--	test(11) <= microden;



--	test(0) <= '0';
--	test(6) <= s_overusage_a(0);
--	test(2) <= s_overusage_clr_a;
--	test(3) <= reset;
--	test(4) <= clkz;
--	test(11 downto 7) <= s_probe(7 downto 3);

--	test(13 downto 0) <= "000000000" & s_probe(2 downto 1) & ejatxdata(0) & s_was_trigmema & s_has_grain_A(CONV_INTEGER(ejeta)); --s_probe(15 downto 7) & s_probe(4 downto 0);

--------------------------------------------------------------------------------------------------------
-- microcontroller interface -----------------------------------------------------------
-- see Texas Instruments' LUMINARY LM3S9B96 data sheet

-- synchronization of external LCLK
	process (clka,reset)
	begin
	  if reset='1' then
	    lckk<='0';
	  elsif falling_edge(clka) then
	    lckk<=lclkl;
	  end if;
	end process;
	
   BUFG_lck : BUFG
   port map ( O => lclk,  I => lckk); 

   datasel <= microden & laddr(0);
	
	process (clka,reset)
	begin
	  if reset='1' then
	    ldata <= "ZZZZZZZZZZZZZZZZ";
	  elsif falling_edge(clka) then
	  case datasel is
	    when "11"  => ldata<= status_reg;
		 when "10"  => ldata<=data_rd;
	    when others => ldata <= "ZZZZZZZZZZZZZZZZ";
	  end case;
	  end if;
	end process;
				
	status_reg <= "0000000000000000" when busy_flag='0' else "1111111111111111";
	
-- write process
   process (lclk,reset,lwr,laddr,clr_cmd,comrst,ldata)
	begin
	  if (reset='1') or (clr_cmd='1') or (comrst='1') then
	     cmd_reg<=X"0000";
	     data_wr<=X"0000";
	  elsif rising_edge(lclk) and lwr='1' then
		     if laddr(0)='0' then 
			    data_wr<=ldata;
           else 
			    cmd_reg<=ldata;
           end if;			  
	  end if;
	end process;
	
	comrstrq <= FPGA_RSTCOM;
	FPGA_BUSYCOM <= busy_flag;
			  
-- busy flag
   process (lclk,reset,lwr,busy_clr,comrst,microden)
	begin
	  if (reset='1') or (busy_clr='1') or (comrst='1') then
	     busy_flag_pre<='0';
	  elsif rising_edge(lclk) then
	     if (lwr='1') or ((microden='1') and (laddr(0)='0') and (cmd_reg/=X"0000")) then
	       busy_flag_pre<='1';
		  end if;
	  end if;
	end process;
	
   process (clka,reset)
	begin
	  if (reset='1') then
	     busy_flag<='0';
	  elsif rising_edge(clka) then
	     busy_flag<=busy_flag_pre;
	  end if;
	end process;
	
-- read process
   process (lclk,reset,read_clr,lrd)
	begin
	  if (reset='1') or (read_clr='1') then
	     halfrd<='0';
	  elsif rising_edge(lclk) then
	     halfrd<=lrd;
	  end if;
	end process;
	
   process (lclk,reset,read_clr,halfrd)
	begin
	  if (reset='1') or (read_clr='1') then
	     microden<='0';
		  read_clr<='0';
	  elsif falling_edge(lclk) then
	     microden<=halfrd;
		  read_clr<=halfclr;
	  end if;
	end process;

   process (lclk,reset,microden)
	begin
	  if reset='1' then
	     halfclr<='0';
	  elsif rising_edge(lclk) then
	     halfclr<=microden;
	  end if;
	end process;
	
------------------------------------------------------------------------------------------------------
-- UART and RS232 communication for debug purposes ONLY
-- RS232 receiving machine

	L_RX <= '0';--test(15);
--	test(14) <= L_TX;--s_tx when conf(5) = '1' else L_TX; --s_tx when conf(5) = '1' else L_TX; --tx232 when conf(5) = '1' else L_TX;
	
------------------------------------------------------------------------
--------------------- Periodic status data sender ----------------------
------------------------------------------------------------------------
	process (c1us, reset)
	begin
		if rising_edge(c1us) then
		--------------------------------------
		-- Baud clock generation (38400 Hz) --
		--------------------------------------
			if (reset = '1') then

				s_BAUD_CLK_BUF <= '0';
				s_baud_clk_counter <= 0;

			else
			
				if (s_baud_clk_counter = 12) then
					s_baud_clk_counter <= 0;
					s_BAUD_CLK_BUF <= not(s_BAUD_CLK_BUF);
				else
					s_baud_clk_counter <= s_baud_clk_counter + 1;
				end if;
				
			end if;
		 end if;
		 
	end process;
	
   BUFG_BAUD_CLK : BUFG
   port map ( O => s_BAUD_CLK,  I => s_BAUD_CLK_BUF); -- 38400Hz

	s_conf_word <= s_CLR_MEAN_COMMAND_B & s_CLR_MEAN_COMMAND_A & extra(7) & extra(6) & "000" &
						extra(3 downto 0) & '0' & floorx & "001";

--	i_STATUS_SENDER : STATUS_SENDER
--    Port map( 
--					PACK_8BIT_0 => s_cmd_last,
--					PACK_8BIT_1 => s_cmd_last_1,
--					PACK_8BIT_2 => s_cmd_last_2,
--					PACK_8BIT_3 => s_cmd_last_3,
--					PACK_8BIT_4 => s_cmd_last_4,
--					PACK_8BIT_5 => s_lumstp_last(11 downto 4),
--					PACK_8BIT_6 => s_lumstp_last(3 downto 0) & "0000",
--					PACK_8BIT_7 => s_cmd_others,
--					PACK_8BIT_8 => s_conf_word(15 downto 8), --s_cmd_others_1,
--					PACK_8BIT_9 => s_conf_word(7 downto 0),
--					PACK_8BIT_10 => s_lumcmd_last,
--					PACK_8BIT_11 => s_lumcmd_last_1,
--					PACK_8BIT_12 => s_lumcmd_last_2,
--					PACK_8BIT_13 => s_lumcmd_last_3,
--					PACK_8BIT_14 => s_lumcmd_last_4,					
--					
--					CLK_i => s_BAUD_CLK,
--					RST_i => reset,
--					SEND_o => open, -- Teste !!!
--					TX_o => s_tx
--				);
			  
------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- state machine for handling serial port debug & microcontroller interface state machine

	------------------------------
	-- Already configured flags --
	------------------------------
	s_already_conf_flag(0) <= s_AFE_confirm_A(0) and s_AFE_confirm_A(1) and s_AFE_confirm_B(0) and s_AFE_confirm_B(1);
	s_already_conf_flag(3) <= s_FE_confirm_A(0) and s_FE_confirm_A(1) and s_FE_confirm_A(2) and s_FE_confirm_A(3) and 
										s_FE_confirm_B(0) and s_FE_confirm_B(1) and s_FE_confirm_B(2) and s_FE_confirm_B(3);
	s_already_conf_flag(4) <= s_sinc_confirm_A and s_sinc_confirm_B;
	s_already_conf_flag(5) <= s_trip_confirm_A and s_trip_confirm_B;
	s_already_conf_flag(6) <= s_boundaries_start_confirmation_A and s_boundaries_end_confirmation_A and
										s_boundaries_start_confirmation_B and s_boundaries_end_confirmation_B;
	s_already_conf_flag(7) <= s_tab_confirm_A and s_tab_confirm_B;
	s_already_conf_flag(8) <= s_def_confirm_A(0) and s_def_confirm_A(1) and s_def_confirm_A(2) and s_def_confirm_A(3) and
										s_def_confirm_A(4) and s_def_confirm_A(5) and s_def_confirm_A(6) and s_def_confirm_B(0) and
										s_def_confirm_B(1) and s_def_confirm_B(2) and s_def_confirm_B(3) and s_def_confirm_B(4) and
										s_def_confirm_B(5) and s_def_confirm_B(6);
	s_already_conf_flag(10) <= s_ellip_confirm_A(0) and s_ellip_confirm_A(1) and s_ellip_confirm_A(2) and s_ellip_confirm_A(3) and 
										s_ellip_confirm_A(4) and s_ellip_confirm_A(5) and s_ellip_confirm_A(6) and s_ellip_confirm_B(0) and 
										s_ellip_confirm_B(1) and s_ellip_confirm_B(2) and s_ellip_confirm_B(3) and s_ellip_confirm_B(4) and 
										s_ellip_confirm_B(5) and s_ellip_confirm_B(6);
	s_already_conf_flag(12) <= s_image_gain_confirmation_A and s_image_gain_confirmation_B;
	s_already_conf_flag(13) <= s_static_bgnd_confirmation_A and s_static_bgnd_confirmation_B;
	s_already_conf_flag(14) <= s_bgnd_confirm_A(0) and s_bgnd_confirm_A(1) and
										s_bgnd_confirm_B(0) and s_bgnd_confirm_B(1);

	process (clkx,reset) -- 9MHz
	variable lts : integer range 0 to 10000005;
	variable ltc,lct,debcnt : integer range 0 to 127;
	begin
	  if reset='1' then
		------------------------------
		-- Already configured flags --
		------------------------------
		s_already_conf_flag(2 downto 1) <= (others => '0');
		s_already_conf_flag(9) <= '0';
		s_already_conf_flag(11) <= '0';

		s_AFE_confirm_A <= (others => '0');
		s_AFE_confirm_B <= (others => '0');
		s_FE_confirm_A <= (others => '0');
		s_FE_confirm_B <= (others => '0');
		s_def_confirm_A(6 downto 0) <= (others=>'0');
		s_def_confirm_B(6 downto 0) <= (others=>'0');
		s_ellip_confirm_A(6 downto 0) <= (others=>'0');
		s_ellip_confirm_B(6 downto 0) <= (others=>'0');
		s_bgnd_confirm_A(1 downto 0) <= (others=>'0');
		s_bgnd_confirm_B(1 downto 0) <= (others=>'0');
		s_sinc_confirm_A <= '0';
		s_sinc_confirm_B <= '0';
		s_trip_confirm_A <= '0';
		s_trip_confirm_B <= '0';
		s_boundaries_start_confirmation_A <= '0';
		s_boundaries_start_confirmation_B <= '0';
		s_boundaries_end_confirmation_A <= '0';
		s_boundaries_end_confirmation_B <= '0';
		s_tab_confirm_A <= '0';
		s_tab_confirm_B <= '0';
		s_image_gain_confirmation_A <= '0';
		s_image_gain_confirmation_B <= '0';
		s_static_bgnd_confirmation_A <= '0';
		s_static_bgnd_confirmation_B <= '0';
		------------------------------
		 s_cmd_others <= (others=>'1');
		 s_cmd_others_1 <= (others=>'1');
		 s_cmd_others_2 <= (others=>'1');
		 s_capture_chute <= '0';
       sendafe<='0';
		 dottrigga<=X"FF";
		 dottriggb<=X"FF";
		 
		 floorx <= '0';
		 		 
       ilum<=X"E07";
		 led_duration_bckgnd<=X"B0"; -- 
		 led_duration_A<=x"30";
		 led_duration_B<=x"30";
		 led_duration_C<=x"30";
		 led_duration_D<=x"30";
		 
		 lts:=0;
		 ltc:=0;
		 debcnt:=0;
		 
		 rqpaca<='0';
		 rqpacb<='0';

       wejt<=X"00000000";
		 wcom<="000";
		 
		 exteventd<='0';
		 exteventf<='0';
		 extevent<='0';
		 exteventag<='0';
  		 ----------------------------------
		 -- multiplier input multiplexer -- 
		 ----------------------------------
		 s_extevent_bckgnd_gain <= '0'; 
		 
		 s_bckgnd_gain_wr_addr <= (others=>'0'); 
		 s_bckgnd_mem_sel <= "00"; --Chute & camera
		 ----------------------------------
		 
		 extra <="00000000";
		 extellipeva<='0';
		 extellipevb<='0';

		 lumstp<="000000000000";
		 lct:=0;
       clr_cmd<='0';
		 busy_clr<='0';

       ggain_bckA<=X"0040";		  
		 ggain_imageA<=X"0040";
       ggain_bckb<=X"0040";		  
		 ggain_imageb<=X"0040";
		 
		 seteja(0)<=X"FF";
		 seteja(1)<=X"FF";
		 seteja(2)<=X"FF";
		 seteja(3)<=X"FF";
		 seteja(4)<=X"FF";
		 seteja(5)<=X"FF";
		 seteja(6)<=X"FF";
		 seteja(7)<=X"FF";
		 setejb(0)<=X"FF";
		 setejb(1)<=X"FF";
		 setejb(2)<=X"FF";
		 setejb(3)<=X"FF";
		 setejb(4)<=X"FF";
		 setejb(5)<=X"FF";
		 setejb(6)<=X"FF";
		 setejb(7)<=X"FF";

       adwell1<=X"39"; --800us
       adwell2<=X"39"; --800us
       adwell3<=X"39"; --800us
       adwell4<=X"39"; --800us
       adwell5<=X"39"; --800us
       adwell6<=X"39"; --800us
       adwell7<=X"39"; --800us
       bdwell1<=X"39"; --800us
       bdwell2<=X"39"; --800us
       bdwell3<=X"39"; --800us
       bdwell4<=X"39"; --800us
       bdwell5<=X"39"; --800us
       bdwell6<=X"39"; --800us
       bdwell7<=X"39"; --800us
		
		 extpart<="00";
		 exttype<='0';
		 ext3bf<="000";
		 extaddr<="00000000000";
		 extaddre<="00000000000";
		 data_rd <=X"0000";

       sincperiod<="100010110";
		 sincperiod_el_7 <= "100010110";
       sincperiodb<="100010110";
		 sincperiodb_el_7 <= "100010110";
		 
		 pixenda <= X"FF";
		 pixendb <= X"FF";
		 pixstarta <=X"00";
		 pixstartb <=X"00";
	
		s_tejetbuff <= (others=>'0');
		
  		 ----------------------------------
		 ------ Overusage clear flag ------
		 ----------------------------------
		 s_overusage_clr_a <= '0';
		 s_overusage_clr_b <= '0';
		 
		 s_has_overusage_clr <= '0';
		 ----------------------------------
		 
	  elsif rising_edge(clkx) then -- 9.375MHz
-- defaults	  

		 exteventd<='0';
		 exteventf<='0';
		 extevent<='0';
		 exteventag<='0';
  		 ----------------------------------
		 -- multiplier input multiplexer -- 
		 ----------------------------------
		 s_extevent_bckgnd_gain <= '0';
		 ----------------------------------
		 rqpaca<='0';
		 rqpacb<='0';
		 extellipeva<='0';
		 extellipevb<='0';

		 s_writing_sram_int <= '0';
       s_reading_sram_int <= '0';	
		 
  		 ----------------------------------
		 ------ Overusage clear flag ------
		 ----------------------------------
		 s_overusage_clr_a <= '0';
		 s_overusage_clr_b <= '0';
		 
		 s_has_overusage_clr <= '0';
		 ----------------------------------

   -- microcontroller defaults	  
       clr_cmd<='0';

	-- microcontroller communication reset management
	    comrst<='0';
       if comrstrq='1' then 
		    comrst<='1'; 
			 lumstp<="000000000000";
			 lct:=0;
		 end if;
		 
-------------------------------------------------------------------------------------------------------------------
-------------- Luminary interface ***********************************************************************************

   -- decode the command from LUMINARY microcontroller
			lumstpd<=lumstp;
			s_lumstp_last <= lumstp;

        case lumstp is
		    when "000000000000" => clr_cmd<='1'; lumstp<="000000000001"; busy_clr<='0';
		    when "000000000001" => if busy_flag='1' then lumstp<="000000000010"; busy_clr<='1'; lct:=0; end if;
          ------------------------------------------------------------------------------------------------
		    when "000000000010" => lumstp<="000000000100";
			                        busy_clr<='0';

			                        case cmd_reg(7 downto 0) is
											  -- read FPGA version
			                          when X"03"  => data_rd <= FPGA_version; 
																	s_cmd_last <= cmd_reg(7 downto 0);
																	s_cmd_last_1 <= s_cmd_last;
																	s_cmd_last_2 <= s_cmd_last_1;
																	s_cmd_last_3 <= s_cmd_last_2;
																	s_cmd_last_4 <= s_cmd_last_3;

																	LED1 <= not(LED1);
																	--LED2 <= not(LED2);
											  -- read last command executed
--			                          when X"04"  => data_rd<=X"0000"; lumstp<="100000000000";
--																	s_cmd_last <= cmd_reg(7 downto 0);
--																	s_cmd_last_1 <= s_cmd_last;
--																	s_cmd_last_2 <= s_cmd_last_1;
--																	s_cmd_last_3 <= s_cmd_last_2;
--																	s_cmd_last_4 <= s_cmd_last_3;	
--
--																	LED1 <= not(LED1);
--																	--LED2 <= not(LED2);																	
											  -- write data to AFE
			                          when X"41"  => if busy_flag='0' then 
																		lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- read ejector module data
			                          when X"42"  => if busy_flag='0' then 
																		lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write configuration word
			                          when X"43"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write illumination intensity setup
			                          when X"44"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- read 256 words from Front-End memory
			                          when X"45"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write 256 words on Front-End memory
			                          when X"46"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- testejet
			                          when X"48"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- send command to ejector module
			                          when X"49"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write delay setup
			                          when X"4A"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- read dot memory
			                          when X"4B"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write trigger level
			                          when X"4C"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write pixini, pixend
			                          when X"4D"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write ejector table
			                          when X"4E"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write number of defects per ellipsis
			                          when X"4F"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write ellipsis dwell time
			                          when X"50"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write ellipsis
			                          when X"51"  => if busy_flag='0' then lumstp<="000000000010";
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write illumination configuration
			                          when X"52"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- read FIFO memory
			                          when X"53"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- read ejector counters
			                          when X"54"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- read configuration word
			                          when X"56"  => data_rd<=(others=>'0');
																	data_rd(0)<='1';
																	data_rd(1)<='0';
																	data_rd(2)<='0';
																	data_rd(3)<=floorx;
																	data_rd(4)<='0';
																	data_rd(5)<=extra(0);
																	data_rd(6)<=extra(1);
																	data_rd(9)<='0';
																	data_rd(10)<='0';
																	data_rd(11)<='0';
																	data_rd(12)<=extra(6);
																	data_rd(13)<=extra(7);
																	data_rd(14)<=s_CLR_MEAN_COMMAND_A; -- allow gain correction calculation
																	data_rd(15)<=s_CLR_MEAN_COMMAND_B;
														
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	

											  -- write X axis gain						
			                          when X"57"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- write Y axis gain
			                          when X"58"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  -- read gain values
			                          when X"59"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
											  ----------------------------------
											  -- multiplier input multiplexer -- 
											  ----------------------------------
											  -- write 256 bckgnd gain values
			                          when X"5A"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
	
																		LED1 <= not(LED1);
																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
																	
											  -- write luminary last command
			                          when X"60"  => if busy_flag='0' then lumstp<="000000000010"; 
--																	else
--																		s_cmd_last <= cmd_reg(7 downto 0);
--																		s_cmd_last_1 <= s_cmd_last;
--																		s_cmd_last_2 <= s_cmd_last_1;
--																		s_cmd_last_3 <= s_cmd_last_2;
--																		s_cmd_last_4 <= s_cmd_last_3;
--	
--																		LED1 <= not(LED1);
--																		--LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
																	
											  -- Read 16 command flags that indicates if the FPGA is with default configuration
			                          when X"61"  => 		data_rd(14 downto 0) <= s_already_conf_flag;
																		data_rd(15) <= s_already_conf_flag(0) and s_already_conf_flag(1) and s_already_conf_flag(2) 
																		and s_already_conf_flag(3) and s_already_conf_flag(4) and s_already_conf_flag(5) and s_already_conf_flag(6) 
																		and s_already_conf_flag(7) and s_already_conf_flag(8) and s_already_conf_flag(9) and s_already_conf_flag(10) 
																		and s_already_conf_flag(11) and s_already_conf_flag(12) and s_already_conf_flag(13) and s_already_conf_flag(14);
											  
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
--	
																		LED1 <= not(LED1);
--																		-- LED2 <= not(LED2);	

											  -- Erase all command flags
			                          when X"62"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
--	
																		LED1 <= not(LED1);
--																		-- LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
												-- Returns flags from ellipsis
			                          when X"63"  => 		data_rd <= s_ellip_confirm_B & '0' & s_ellip_confirm_A & '0';
											  
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
--	
																		LED1 <= not(LED1);
--																		-- LED2 <= not(LED2);	

											  -- Set image grab trigger wait
			                          when X"F0"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
--	
--																		--LED1 <= not(LED1);
--																		-- LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
																	
											  -- Read 256 words from RAM image data - Lower part
			                          when X"F1"  => if busy_flag='0' then lumstp<="000000000010"; 
																	else
																		s_cmd_last <= cmd_reg(7 downto 0);
																		s_cmd_last_1 <= s_cmd_last;
																		s_cmd_last_2 <= s_cmd_last_1;
																		s_cmd_last_3 <= s_cmd_last_2;
																		s_cmd_last_4 <= s_cmd_last_3;
--	
--																		--LED1 <= not(LED1);
--																		-- LED2 <= not(LED2);	
																	end if; -- stay here if busy=0
																	
											  when others => lumstp<="000000000000";
																	s_cmd_others <= cmd_reg(7 downto 0);
																	s_cmd_others_1 <= s_cmd_others;
																	s_cmd_others_2 <= s_cmd_others_1;

																	--LED1 <= not(LED1);
																	-- LED2 <= not(LED2);	
											end case;
          ------------------------------------------------------------------------------------------------
		    when "000000000100" => lumstp<="000000001000"; 
			                        case cmd_reg(7 downto 0) is
			                          when X"03"  => lumstp<="100000000000"; -- s_cmd_last <= X"0003";-- exit 1
--			                          when X"04"  => s_cmd_last <= X"0000"; lumstp<="100000000000"; -- exit 1
			                          when X"41"  => afeaddr<=data_wr(14 downto 12);
						                                afen <=data_wr(15);
						                                afedata<=data_wr(8 downto 0);
			                          when X"42"  => if data_wr(15)='0' then
											  
																		case data_wr(14 downto 12) is
																			when "000" => data_rd <= "0000" & ejdt0(conv_integer(data_wr(14 downto 12)))(11 downto 0);
																			when "001" => data_rd <= "0000" & ejdt0(conv_integer(data_wr(14 downto 12)))(11 downto 0);
																			when "011" => data_rd <= s_overusage_a(28 downto 25) & s_overusage_a_coffee(11 downto 0);
																			when others => data_rd <= ejdt0(conv_integer(data_wr(14 downto 12)))(15 downto 0);
																		end case;
																		
						                                else
																		
																		case data_wr(14 downto 12) is
																			when "000" => data_rd <= "0000" & ejdt0(conv_integer(data_wr(14 downto 12)))(23 downto 12);
																			when "001" => data_rd <= "0000" & ejdt0(conv_integer(data_wr(14 downto 12)))(23 downto 12);
																			when "011" => data_rd <= '0' & s_overusage_a(31 downto 29) & s_overusage_b_coffee(11 downto 0);
																			when others => data_rd <= ejdt0(conv_integer(data_wr(14 downto 12)))(15 downto 0);
																		end case;

						                                end if;
						                                busy_clr<='1';
			                          when X"43"  => busy_clr<='1';
		                                            floorx<=data_wr(3);
		                                            extra(0)<=data_wr(5);
		                                            extra(1)<=data_wr(6);
																  s_has_overusage_clr <= data_wr(10);
		                                            extra(6)<=data_wr(12);
		                                            extra(7)<=data_wr(13);
																  s_CLR_MEAN_COMMAND_A <= data_wr(14);
																  s_CLR_MEAN_COMMAND_B <= data_wr(15);
																  
																  s_already_conf_flag(1) <= '1';
																  
																  lumstp<="000000000000";
			                          when X"44"  => busy_clr<='1';
																  lumstp<="000000000010"; -- return to wait busy=1
											                 case lct is
																   when 0 => led_duration_bckgnd<=data_wr(7 downto 0); --if data_wr(7 downto 0)>X"B0" then led_duration_bckgnd<=X"B0"; else led_duration_bckgnd<=data_wr(7 downto 0); end if;
																   when 1 => led_duration_A<=data_wr(7 downto 0);
																   when 2 => led_duration_B<=data_wr(7 downto 0);
																   when 3 => led_duration_C<=data_wr(7 downto 0);
																   when 4 => led_duration_D<=data_wr(7 downto 0);
--																	           s_cmd_last <= X"0044";
																				  lumstp<="000000000000";
																				  
																				  s_already_conf_flag(2) <= '1';
																				  
																   when others => lumstp<="000000000000"; --s_cmd_last <= X"0044";
																  end case;
																  lct:=lct+1;
			                          when X"45"  => ndumpf<=(others=>'0'); 
						                                extpart<=data_wr(15) & data_wr(5);
							                             exttype<='0'; -- read
																  
																  if (data_wr(5) = '1') then
																		if (data_wr(2 downto 0) = "101") then
																			ext3bf<="110";
																		else
																			if (data_wr(2 downto 0) = "110") then
																				ext3bf<="101";
																			else
																				ext3bf<=data_wr(2 downto 0);
																			end if;
																		end if;
																  else
																   ext3bf<=data_wr(2 downto 0);
																  end if;
																  
			                          when X"46"  => ndumpf<=(others=>'0'); 
											                 exttype<='1'; -- write 
																  extpart<= data_wr(15) & data_wr(5); 
																  
																  if data_wr(5) = '1' then
																		if data_wr(2 downto 0) = "011" then
																			ext3bf <= "111";
																		else
																			if data_wr(2 downto 0) = "111" then
																				ext3bf <= "011";
																			else
																				ext3bf<=data_wr(2 downto 0);
																			end if;
																		end if;
																  else
																		ext3bf<=data_wr(2 downto 0);
																  end if;
																	
																  busy_clr<='1';
			                          when X"48"  => busy_clr<='1';
 							                             s_tejet_dwell <= data_wr(13 downto 6) & "00";
							                             s_tejetbuff(CONV_INTEGER(data_wr(4 downto 0))) <= data_wr(5);
							                             s_tejet_chute <= data_wr(15);
--						                                s_cmd_last <= X"0048";
																  lumstp<="000000000000";
			                          when X"49"  => busy_clr<='1';
											                 rasc1com<=data_wr(14 downto 12); rsc1chute<=data_wr(15);
			                          when X"4A"  => busy_clr<='1';
																  if data_wr(15)='0' then
																	s_sinc_confirm_A <= '1';
																  
																	if data_wr(14)='0' then
																		sincperiod <= data_wr(8 downto 0);
																	else
																		sincperiod_el_7 <= data_wr(8 downto 0);
																	end if;
																	
																  else
																	s_sinc_confirm_B <= '1';
																	
																	if data_wr(14)='0' then
																		sincperiodb <= data_wr(8 downto 0);
																	else
																		sincperiodb_el_7 <= data_wr(8 downto 0);
																	end if;
																	
																	
																  end if;
--						                                s_cmd_last <= X"004A";

																  lumstp<="000000000000";
			                          when X"4B"  => ndumpf<=(others=>'0'); 
						                                extpart<=data_wr(15) & data_wr(5);
							                             exttype<='0'; -- read
							                             ext3bf<=data_wr(2 downto 0);
--											                 exteventd<='0'; -- try to get rid of dot-misreading
			                          when X"4C"  => busy_clr<='1';
																	if data_wr(8)='0' then
																		if data_wr(15)='0' then
																			dottrigga<=data_wr(7 downto 0);
																			s_trip_confirm_A <= '1';
																		else
																			dottriggb<=data_wr(7 downto 0);
																			s_trip_confirm_B <= '1';
																		end if;
																	else	 
																		if data_wr(15)='0' then
																			dottrigga2<=data_wr(7 downto 0);
																		else
																			dottriggb2<=data_wr(7 downto 0);
																		end if;
																	end if;	 
--						                                s_cmd_last <= X"004C";
																  
																  lumstp<="000000000000";
			                          when X"4D"  => busy_clr<='1';
																	if data_wr(15)='0' then
																		if data_wr(8)='0' then
																			pixstarta<=data_wr(7 downto 0);
																			s_boundaries_start_confirmation_A <= '1';
																		else
																			pixenda<=data_wr(7 downto 0);
																			s_boundaries_end_confirmation_A <= '1';
																		end if;
																	else
																		if data_wr(8)='0' then
																			pixstartb<=data_wr(7 downto 0);
																			s_boundaries_start_confirmation_B <= '1';
																		else
																			pixendb<=data_wr(7 downto 0);
																			s_boundaries_end_confirmation_B <= '1';
																		end if;
																	end if;
--						                                s_cmd_last <= X"004D";
																  
																  lumstp<="000000000000";
			                          when X"4E"  => busy_clr<='1';
																	ndumpf<=(others=>'0'); 
																	extpart<='0' & data_wr(15);
																	
			                          when X"4F"  => busy_clr<='1';
											                 ext3bf<=data_wr(10 downto 8);
																  
			                          when X"50"  => extpart<= '0'& data_wr(15); 
																  busy_clr<='1';
			                          when X"51"  => ndumpf<=(others=>'0'); 
																  extpart<= '0'& data_wr(15); 
																  ext3bf<=data_wr(10 downto 8);
																  busy_clr<='1';
			                          when X"52"  => busy_clr<='1';
																  ilum<=data_wr(11 downto 0);
																  s_already_conf_flag(11) <= '1';
--						                                s_cmd_last <= X"0052";
																  lumstp<="000000000000";
			                          when X"53"  => ndumpf<=(others=>'0'); 
						                                extpartf<=data_wr(15) & data_wr(1 downto 0);
							                             exttype<='0'; -- read
							                             ext3bf<="000";
																  
			                          when X"54"  => ndumpdsm<=(others=>'0'); ndumpdsm(5)<=data_wr(15);
			                          when X"56"  => lumstp<="100000000000"; --s_cmd_last <= X"0056"; -- exit 1
			                          when X"57"  => busy_clr<='1';
																	if data_wr(15)='0'  then
																		ggain_imageA(8 downto 0)<=data_wr(8 downto 0);
																		s_image_gain_confirmation_A <= '1';
																	else
																		ggain_imageB(8 downto 0)<=data_wr(8 downto 0);
																		s_image_gain_confirmation_B <= '1';
																	end if;
--						                                s_cmd_last <= X"0057";
																  
																  lumstp<="000000000000";
			                          when X"58"  => busy_clr<='1';
																	if data_wr(15)='0'  then
																		ggain_bckA(8 downto 0)<=data_wr(8 downto 0);
																		s_static_bgnd_confirmation_A <= '1';
																	else
																		ggain_bckB(8 downto 0)<=data_wr(8 downto 0);
																		s_static_bgnd_confirmation_B <= '1';
																	end if;
--						                                s_cmd_last <= X"0058";
																  
																  lumstp<="000000000000";
			                          when X"59"  => ndumpf<=(others=>'0'); 
						                                s_ref_or_trans <= data_wr(0); -- Choses between reflectance or transluscence
						                                extpartag<=data_wr(15); -- Chooses chute
						                                s_extcam<=data_wr(1);	-- Chooses cam
			                          when X"5A"  => ndumpf <= (others=>'0'); 
																  s_bckgnd_mem_sel <= data_wr(15) & data_wr(5); --Chute & camera
																  busy_clr<='1';
												-- write luminary last command
			                          when X"60"  => busy_clr<='1';
																  s_lumcmd_last <= data_wr(7 downto 0);
																  s_lumcmd_last_1 <= s_lumcmd_last;
																  s_lumcmd_last_2 <= s_lumcmd_last_1;
																  s_lumcmd_last_3 <= s_lumcmd_last_2;
																  s_lumcmd_last_4 <= s_lumcmd_last_3;
																  lumstp<="000000000000";
												-- Read 16 command flags that indicates if the FPGA is with default configuration				  
											  when X"61"  => lumstp<="100000000000"; --s_cmd_last <= X"0056"; -- exit 1
											  
											   -- Erase all command flags
											  when X"62"  => if data_wr(0) = '1' then
																		s_already_conf_flag(2 downto 1) <= (others => '0');
																		s_already_conf_flag(9) <= '0';
																		s_already_conf_flag(11) <= '0';
																		
																		s_AFE_confirm_A <= (others => '0');
																		s_AFE_confirm_B <= (others => '0');
																		s_FE_confirm_A <= (others => '0');
																		s_FE_confirm_B <= (others => '0');
																		s_def_confirm_A(6 downto 0) <= (others=>'0');
																		s_def_confirm_B(6 downto 0) <= (others=>'0');
																		s_ellip_confirm_A(6 downto 0) <= (others=>'0');
																		s_ellip_confirm_B(6 downto 0) <= (others=>'0');
																		s_bgnd_confirm_A(1 downto 0) <= (others=>'0');
																		s_bgnd_confirm_B(1 downto 0) <= (others=>'0');
																		s_sinc_confirm_A <= '0';
																		s_sinc_confirm_B <= '0';
																		s_trip_confirm_A <= '0';
																		s_trip_confirm_B <= '0';
																		s_boundaries_start_confirmation_A <= '0';
																		s_boundaries_start_confirmation_B <= '0';
																		s_boundaries_end_confirmation_A <= '0';
																		s_boundaries_end_confirmation_B <= '0';
																		s_tab_confirm_A <= '0';
																		s_tab_confirm_B <= '0';
																		s_image_gain_confirmation_A <= '0';
																		s_image_gain_confirmation_B <= '0';
																		s_static_bgnd_confirmation_A <= '0';
																		s_static_bgnd_confirmation_B <= '0';

																  end if;
																  
																  lumstp<="100000000000";
												 -- Returns flags from ellipsis				  
												when X"63"  => lumstp<="100000000000"; --s_cmd_last <= X"0056"; -- exit 1
											 
												-- Set image grab trigger wait				  
			                          when X"F0"  => s_writing_sram_int <= '1'; 
																  s_grab_a_or_b <= not(conf(2));
																  s_debug_or_normal <= not(conf(3));
																  lumstp<="000000000000";
											   -- Read 256 words from RAM image data - Lower part
			                          when X"F1"  => 	s_grabpix <= (others=>'0');
																	s_grabline <= '0' & data_wr(5 downto 0);
																	s_grab_sector <= '0' & data_wr(15 downto 14);
											 
											  when others => lumstp<="000000000000";
											end case;
          ------------------------------------------------------------------------------------------------
		    when "000000001000" => lumstp<="000000010000";
			                        case cmd_reg(7 downto 0) is
			                          when X"41"  => sendafe<='1';
			                          when X"42"  => busy_clr<='0';
											                 if busy_flag='0' then lumstp<="000000001000"; end if; -- stay here if busy=0
			                          when X"45"  => extaddr<= ext3bf & ndumpf; 
		                                            extevent<='1';
			                          when X"46"  => busy_clr<='0'; extaddrw<= ext3bf & ndumpf; 
			                          when X"49"  => busy_clr<='0'; if busy_flag='0' then lumstp<="000000001000"; end if; -- stay here if busy=0
			                          when X"4B"  => extaddrd<= ext3bf & ndumpf; 	 
		                                            exteventd<='1';
			                          when X"4E"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000001000"; end if; -- stay here if busy=0
			                          when X"4F"  => busy_clr<='0'; -- if busy_flag='0' then lumstp<="000000001000"; end if; -- stay here if busy=0
			                          when X"50"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000001000"; end if; -- stay here if busy=0
			                          when X"51"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000001000"; end if; -- stay here if busy=0
			                          when X"53"  => extaddrf<= ext3bf & ndumpf; 
															     exteventf<='1';
			                          when X"54"  => data_rd<=s_EJ_CNT_o; busy_clr<='1';
			                          when X"59"  => --extaddrag<=ndumpf; 
																  exteventag<='1';				
											  when X"5A"  => busy_clr<='0'; s_bckgnd_gain_wr_addr <= ndumpf; 																  
											  
												-- Read 256 words from RAM image data - Lower part			
			                          when X"F1"  => 	s_sram_int_rd_addr<= s_grab_sector & s_grabline & s_grabpix; 
																								-- sector  		& line  		&  pixel
																	s_reading_sram_int <= '1';																	
											  
											  when others => lumstp<="000000000000";
											end case;
          ------------------------------------------------------------------------------------------------
		    when "000000010000" => lumstp<="000000100000";
			                        case cmd_reg(7 downto 0) is
			                          when X"41"  => if afesent='0' then lumstp<="000000010000"; end if; -- stay here till AFE is written
			                          when X"42"  => if data_wr(15)='0' then
											  
																		case data_wr(14 downto 12) is
																			when "000" => data_rd <= (others => '0');
																			when "001" => data_rd <= (others => '0');
																			when "011" => data_rd <= s_overusage_b(15 downto 0);
																			when others => data_rd <= ejdt0(conv_integer(data_wr(14 downto 12)))(31 downto 16);
																		end case;
																		
						                                else
																		
																		case data_wr(14 downto 12) is
																			when "000" => data_rd <= (others => '0');
																			when "001" => data_rd <= (others => '0');
																			when "011" => data_rd <= s_overusage_b(31 downto 16);
																			when others => data_rd <= ejdt0(conv_integer(data_wr(14 downto 12)))(31 downto 16);
																		end case;

						                                end if;
																  
						                                busy_clr<='1';
			                          when X"45"  => if extevent_req='0' then data_rd<=extdataread; busy_clr<='1'; else lumstp<="000000010000"; end if; 
											  when X"46"  => if busy_flag='0' then lumstp<="000000010000"; end if; -- stay here if busy=0
			                          when X"49"  => busy_clr<='1';
											                 rascl<=data_wr;
			                          when X"4B"  => if extevent_reqd='0' then data_rd<=extdatareadot; busy_clr<='1'; else lumstp<="000000010000"; end if; 
--											                 exteventd<='0';	-- try to get rid of dot misreading
			                          when X"4E"  => busy_clr<='1';
																	if extpart(0)='0' then
																		tabejeta(CONV_INTEGER(ndumpf))<=data_wr(4 downto 0);
																	else
																		tabejetb(CONV_INTEGER(ndumpf))<=data_wr(4 downto 0);
																	end if;  
																	
			                          when X"4F"  => busy_clr<='1';
																	if data_wr(15)='0' then
																		seteja(CONV_INTEGER(ext3bf))<=data_wr(7 downto 0);
																		case ext3bf is
																			when "001" =>
																								s_def_confirm_A(0) <= '1';
																			when "010" =>
																								s_def_confirm_A(1) <= '1';
																			when "011" =>
																								s_def_confirm_A(2) <= '1';
																			when "100" =>
																								s_def_confirm_A(3) <= '1';
																			when "101" =>
																								s_def_confirm_A(4) <= '1';
																			when "110" =>
																								s_def_confirm_A(5) <= '1';
																			when "111" =>
																								s_def_confirm_A(6) <= '1';
																			when others =>
																		end case;
																		
																	else
																		setejb(CONV_INTEGER(ext3bf))<=data_wr(7 downto 0);
																		case ext3bf is
																			when "001" =>
																								s_def_confirm_B(0) <= '1';
																			when "010" =>
																								s_def_confirm_B(1) <= '1';
																			when "011" =>
																								s_def_confirm_B(2) <= '1';
																			when "100" =>
																								s_def_confirm_B(3) <= '1';
																			when "101" =>
																								s_def_confirm_B(4) <= '1';
																			when "110" =>
																								s_def_confirm_B(5) <= '1';
																			when "111" =>
																								s_def_confirm_B(6) <= '1';
																			when others =>
																		end case;
																		
																	end if;
														
																	lumstp<="000000000000"; --s_cmd_last <= X"004F";
			                          when X"50"  => busy_clr<='1';
																  lumstp<="000000001000"; -- return to wait busy=1
											                 case lct is
																   when 0 => if extpart(0)='0' then adwell1<=data_wr(7 downto 0); else bdwell1<=data_wr(7 downto 0); end if;
																   when 1 => if extpart(0)='0' then adwell1<=data_wr(7 downto 0); else bdwell1<=data_wr(7 downto 0); end if;
																   when 2 => if extpart(0)='0' then adwell2<=data_wr(7 downto 0); else bdwell2<=data_wr(7 downto 0); end if;
																   when 3 => if extpart(0)='0' then adwell3<=data_wr(7 downto 0); else bdwell3<=data_wr(7 downto 0); end if;
																   when 4 => if extpart(0)='0' then adwell4<=data_wr(7 downto 0); else bdwell4<=data_wr(7 downto 0); end if;
																   when 5 => if extpart(0)='0' then adwell5<=data_wr(7 downto 0); else bdwell5<=data_wr(7 downto 0); end if;
																   when 6 => if extpart(0)='0' then adwell6<=data_wr(7 downto 0); else bdwell6<=data_wr(7 downto 0); end if;
																   when 7 => if extpart(0)='0' then adwell7<=data_wr(7 downto 0); else bdwell7<=data_wr(7 downto 0); end if;
--																	           s_cmd_last <= X"0050";
																				  lumstp<="000000000000";
																				  s_already_conf_flag(9) <= '1';
																				  
																   when others => lumstp<="000000000000"; --s_cmd_last <= X"0050";
																  end case;
																  lct:=lct+1;
			                          when X"51"  => extaddre<=ext3bf & ndumpf;
																  extdata<=data_wr;
																  if extpart(0)='0' then extellipeva<='1'; else extellipevb<='1'; end if;
			                          when X"53"  => if extevent_reqf='0' then data_rd<=extdatareadf; busy_clr<='1'; else lumstp<="000000010000"; end if; 
			                          when X"54"  => busy_clr<='0'; if busy_flag='0' then lumstp<="000000010000"; end if; -- stay here if busy=0
			                          when X"59"  => if exteventag_req='0' then data_rd<=extdatareadag; busy_clr<='1'; else lumstp<="000000010000"; end if; 
											  when X"5A"  => if busy_flag='0' then lumstp<="000000010000"; end if; -- stay here if busy=0
											  
												-- Read 256 words from RAM image data - Lower part		
			                          when X"F1"  => 	if s_reading_sram = '0' then 
																		data_rd <= s_sram_output_data; 
																		busy_clr<='1'; 
																	else 
																		lumstp<="000000010000"; 
																	end if; --data_rd<=grabbed;											  
											  
											  when others => lumstp<="000000000000";
											end case;
          ------------------------------------------------------------------------------------------------
		    when "000000100000" => lumstp<="000001000000";
			                        case cmd_reg(7 downto 0) is
			                          when X"41"  => sendafe<='0'; busy_clr<='1'; lumstp<="000000000000"; --s_cmd_last <= X"0041";
																	if (afen = '1') then
																		if (afeaddr = "011") then
																			s_AFE_confirm_B(1) <= '1';
																		else
																			if (afeaddr = "010") then
																				s_AFE_confirm_B(0) <= '1';
																			end if;
																		end if;
																	else
																		if (afeaddr = "011") then
																			s_AFE_confirm_A(1) <= '1';
																		else
																			if (afeaddr = "010") then
																				s_AFE_confirm_A(0) <= '1';
																			end if;
																		end if;
																	end if;

			                          when X"42"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000100000"; end if; -- stay here if busy=0
			                          when X"45"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000100000"; end if; -- stay here if busy=0
			                          when X"46"  => extevent<='1'; extdata<=data_wr;
											  
			                          when X"49"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000100000"; end if; -- stay here if busy=0
			                          when X"4B"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000100000"; end if; -- stay here if busy=0
			                          when X"4E"  => busy_clr<='0';
											                 if ndumpf=X"FF" then lumstp<="000000000000"; --s_cmd_last <= X"004E";
																  
																		if extpart(0)='0' then
																			s_tab_confirm_A <= '1';
																		else
																			s_tab_confirm_B <= '1';
																		end if;  
																  
																  else ndumpf<=ndumpf+1; lumstp<="000000001000";
																  end if;	
											  when X"51"  => if (extellia='0') and (extellib='0') then lumstp<="000001000000"; busy_clr<='1'; else lumstp<="000000100000"; end if;
			                          when X"53"  => busy_clr<='0'; if busy_flag='0' then lumstp<="000000100000"; end if; -- stay here if busy=0
			                          when X"54"  => if ndumpdsm=X"1F" then lumstp<="000000000000"; --s_cmd_last <= X"0054";
											                                   else ndumpdsm<=ndumpdsm+1; lumstp<="000000001000";
																  end if;												  
			                          when X"59"  => busy_clr<='0';if busy_flag='0' then lumstp<="000000100000"; end if; -- stay here if busy=0
											  when X"5A"  => s_extevent_bckgnd_gain <= '1'; s_bckgnd_gain_data_in <= data_wr;
												-- Read 256 words from RAM image data - Lower part											  
			                          when X"F1"  => 	busy_clr<='0';
																	if busy_flag='0' then lumstp<="000000100000"; end if;
																	
											  when others => lumstp<="000000000000";
											end case;
          ------------------------------------------------------------------------------------------------
		    when "000001000000" => lumstp<="000010000000";
			                        case cmd_reg(7 downto 0) is
			                          when X"42"  => lumstp<="100000000000"; -- exit 1 s_cmd_last <= X"0042";
--																	if (data_wr(14 downto 12) = "011") then
--																	  s_overusage_clr_a <= not(data_wr(15));
--																	  s_overusage_clr_b <= data_wr(15);
--																	else
--																	  s_overusage_clr_a <= '0';
--																	  s_overusage_clr_b <= '0';
--																	end if;

			                          when X"45"  => if ndumpf=X"FF" then lumstp<="000000000000"; busy_clr<='1'; --s_cmd_last <= X"0045";
											                                else ndumpf<=ndumpf+1; lumstp<="000000001000";
																  end if;				  
			                          when X"46"  => if extevent_req='0' then busy_clr<='1'; else lumstp<="000001000000"; end if; 
			                          when X"49"  => busy_clr<='1';
											                 rasch<=data_wr;
			                          when X"4B"  => if ndumpf=X"FF" then lumstp<="000000000000"; busy_clr<='1'; --s_cmd_last <= X"004B";
											                                else ndumpf<=ndumpf+1; lumstp<="000000001000";
																  end if;				  
			                          when X"51"  => if ndumpf=X"FF" then lumstp<="000000000000"; busy_clr<='1'; --s_cmd_last <= X"0051";
											  
																	if extpart(0) = '1' then
																	
																		case ext3bf is
																			when "001" =>
																								s_ellip_confirm_A(0) <= '1';
																			when "010" =>
																								s_ellip_confirm_A(1) <= '1';
																			when "011" =>
																								s_ellip_confirm_A(2) <= '1';
																			when "100" =>
																								s_ellip_confirm_A(3) <= '1';
																			when "101" =>
																								s_ellip_confirm_A(4) <= '1';
																			when "110" =>
																								s_ellip_confirm_A(5) <= '1';
																			when "111" =>
																								s_ellip_confirm_A(6) <= '1';
																			when others =>
																		end case;
																	
																	else
																	
																		case ext3bf is
																			when "001" =>
																								s_ellip_confirm_B(0) <= '1';
																			when "010" =>
																								s_ellip_confirm_B(1) <= '1';
																			when "011" =>
																								s_ellip_confirm_B(2) <= '1';
																			when "100" =>
																								s_ellip_confirm_B(3) <= '1';
																			when "101" =>
																								s_ellip_confirm_B(4) <= '1';
																			when "110" =>
																								s_ellip_confirm_B(5) <= '1';
																			when "111" =>
																								s_ellip_confirm_B(6) <= '1';
																			when others =>
																		end case;
																	
																	end if;
											  							
											                 else ndumpf<=ndumpf+1; lumstp<="000000001000";
																  end if;				  
			                          when X"53"  => if ndumpf=X"FF" then lumstp<="000000000000"; busy_clr<='1'; --s_cmd_last <= X"0053";
											                                else ndumpf<=ndumpf+1; lumstp<="000000001000";
																  end if;				  
			                          when X"59"  => if ndumpf=X"FF" then lumstp<="000000000000"; busy_clr<='1'; --s_cmd_last <= X"0059";
											                                else ndumpf<=ndumpf+1; lumstp<="000000001000";
																  end if;				  
											  when X"5A"  => if s_extevent_bckgnd_gain_req='0' then busy_clr<='1'; else lumstp<="000001000000"; end if; 		

--												-- Read 256 words from RAM image data - Lower part		
			                          when X"F1"  => if s_grabpix=X"FF" then 
																		lumstp<="000000000000"; 
																		busy_clr<='1'; --s_cmd_last <= X"004B";
											                  else 
																		s_grabpix<=s_grabpix+1; 
																		lumstp<="000000001000";	
																	end if;
											  
											  when others => lumstp<="000000000000";
											end case;
          ------------------------------------------------------------------------------------------------
		    when "000010000000" => lumstp<="000100000000";
			                        case cmd_reg(7 downto 0) is
			                          when X"46"  => if ndumpf=X"FF" then lumstp<="000000000000"; --s_cmd_last <= X"0046";
																	case extpart is --(0) Chute (1) Camera
																		when "00" =>
																						if ext3bf = "011" then
																							s_FE_confirm_A(0) <= '1';
																						else
																							if ext3bf = "111" then
																								s_FE_confirm_A(1) <= '1';
																							end if;
																						end if;
																						
																		when "01" =>
																						if ext3bf = "011" then
																							s_FE_confirm_A(2) <= '1';
																						else
																							if ext3bf = "111" then
																								s_FE_confirm_A(3) <= '1';
																							end if;
																						end if;
																			
																		when "10" =>
																						if ext3bf = "011" then
																							s_FE_confirm_B(0) <= '1';
																						else
																							if ext3bf = "111" then
																								s_FE_confirm_B(1) <= '1';
																							end if;
																						end if;
																			
																		when "11" =>
																						if ext3bf = "011" then
																							s_FE_confirm_B(2) <= '1';
																						else
																							if ext3bf = "111" then
																								s_FE_confirm_B(3) <= '1';
																							end if;
																						end if;
																			
																		when others =>
																	end case;
																else ndumpf<=ndumpf+1; lumstp<="000000001000"; 
																end if;				  
			                          when X"49"  => busy_clr<='0';
											                 case rasc1com is
		                                              when "001" => wejt<=rasch & rascl; -- Altera ON_TIME_TOP (high word) e ON_TIME_BOT (low word)
							                                             wcom<="011";
											                                 if rsc1chute='0' then rqpaca<='1'; else rqpacb<='1';  end if;
											  
		                                              when "010" => wejt<=rasch & rascl; -- Altera DECVAL (high word) e INCVAL (low word)
							                                             wcom<="100";
											                                 if rsc1chute='0' then rqpaca<='1'; else rqpacb<='1';  end if;
											  
		                                              when "011" => wejt<="010" & "00000000000000000000000000001"; -- 34V on 
							                                             wcom<="110";
											                                 if rsc1chute='0' then rqpaca<='1'; else rqpacb<='1';  end if;
	
		                                              when "100" => wejt<="010" & "00000000000000000000000000000"; -- 34V off
							                                             wcom<="110";
											                                 if rsc1chute='0' then rqpaca<='1'; else rqpacb<='1';  end if;
	
		                                              when "101" => wejt<="001" & "00000000000000000000000000000"; -- execute
							                                             wcom<="110";
											                                 if rsc1chute='0' then rqpaca<='1'; else rqpacb<='1';  end if;
	
		                                              when "110" => wejt<=rasch & rascl; -- Altera o limite de corrente de auto-desligamento dos 34V (low word)
							                                             wcom<="101";
											                                 if rsc1chute='0' then rqpaca<='1'; else rqpacb<='1';  end if;
											  
		                                              when others => wejt<=rasch & rascl; wcom<="000";
		                                            end case;
																  
			                          when X"5A"  => if ndumpf=X"FF" then lumstp<="000000000000"; --s_cmd_last <= X"0046";
																		case s_bckgnd_mem_sel is
																			when "00" =>
																								s_bgnd_confirm_A(0) <= '1';
																			when "01" =>
																								s_bgnd_confirm_A(1) <= '1';
																			when "10" =>
																								s_bgnd_confirm_B(0) <= '1';
																			when "11" =>
																								s_bgnd_confirm_B(1) <= '1';
																			when others =>
																		end case;
											  
																	else ndumpf<=ndumpf+1; lumstp<="000000001000"; 
																  end if;		
																  
											  when others => lumstp<="000000000000";
											end case;
          ------------------------------------------------------------------------------------------------
		    when "000100000000" => lumstp<="001000000000";
			                        case cmd_reg(7 downto 0) is
			                          when X"49"  => if (ispaca='0') and (ispacb='0') then busy_clr<='1'; lumstp<="000000000000"; --s_cmd_last <= X"0049";
											                                                  else lumstp<="000100000000"; 
																  end if;
											  when others => lumstp<="000000000000";
											end case;
											
          ------------------------------------------------------------------------------------------------
		    when "100000000000" => if busy_flag='1' then lumstp<="000000000000"; busy_clr<='1'; end if;
			 
		    when others => lumstp<="000000000000";
		  end case;
 
-------------- Luminary interface ***********************************************************************************
-------------------------------------------------------------------------------------------------------------------
		 
------------------------------------------------------------------------------------------		 
-- little sequencer for automatic AFE innitialization		 
       if (lts<10000000) then
		    lts:=lts+1;
			 if (lts>9000000) then
				 case ltc is
				   when 0 => afeaddr<="000"; afen<='0'; afedata<="001101000"; ltc:=ltc+1; -- $0068
					when 1 => sendafe<='1'; ltc:=ltc+1;
					when 2 => if afesent='1' then ltc:=ltc+1; sendafe<='0'; end if;

				   when 3 => afeaddr<="010"; afen<='0'; afedata<="000011110"; ltc:=ltc+1; -- $0222
					when 4 => sendafe<='1'; ltc:=ltc+1;
					when 5 => if afesent='1' then ltc:=ltc+1; sendafe<='0'; end if;
					
				   when 6 => afeaddr<="011"; afen<='0'; afedata<="000011110"; ltc:=ltc+1; -- $0325 rear A
					when 7 => sendafe<='1'; ltc:=ltc+1;
					when 8 => if afesent='1' then ltc:=ltc+1; sendafe<='0'; end if;

				   when 9 => afeaddr<="000"; afen<='1'; afedata<="001101000"; ltc:=ltc+1; -- $0868
					when 10 => sendafe<='1'; ltc:=ltc+1;
					when 11 => if afesent='1' then ltc:=ltc+1; sendafe<='0'; end if;

				   when 12 => afeaddr<="010"; afen<='1'; afedata<="000011110"; ltc:=ltc+1; -- $0A22
					when 13 => sendafe<='1'; ltc:=ltc+1;
					when 14 => if afesent='1' then ltc:=ltc+1; sendafe<='0'; end if;
					
				   when 15 => afeaddr<="011"; afen<='1'; afedata<="000011110"; ltc:=ltc+1; -- $0B25 rear B
					when 16 => sendafe<='1'; ltc:=ltc+1;
					when 17 => if afesent='1' then ltc:=ltc+1; sendafe<='0'; end if;
					
					-------------------------------------------------
					------------------- RG Offset -------------------
					-------------------------------------------------
					
				   when 18 => afeaddr<="101"; afen<='1'; afedata<="000000000"; ltc:=ltc+1; -- Red offset to 0
					when 19 => sendafe<='1'; ltc:=ltc+1;
					when 20 => if afesent='1' then ltc:=ltc+1; sendafe<='0'; end if;
					
				   when 21 => afeaddr<="110"; afen<='1'; afedata<="000000000"; ltc:=ltc+1; -- Green offset to 0
					when 22 => sendafe<='1'; ltc:=ltc+1;
					when 23 => if afesent='1' then ltc:=ltc+1; sendafe<='0'; end if;
										
					when 24=> lts:=10000001;
					
					when others => ltc:=0;
				 end case;
			 end if;
		 end if;
	  end if;
	end process;

------------------------------------------------------------------------------------------------------
	-- Pseudo - random Ejector generation
i_PSEUDO_RANDOM_TEST : PSEUDO_RANDOM_TEST
	Port map (	ENABLE_TST_i => conf(4),	--Conf jumper that enables the test
					RST_i =>	RESET,
					CLK_i => clkz,
				
					EJET_o => s_ejet				--32bit Pseudo-random Output signal 
				);
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- Delay sorta,sortb

			  s_CH_IN00_i <= "00" & s_ejet(0) when conf(4) = '0' else sorta(00);
			  s_CH_IN01_i <= "00" & s_ejet(1) when conf(4) = '0' else sorta(01);
			  s_CH_IN02_i <= "00" & s_ejet(2) when conf(4) = '0' else sorta(02);
			  s_CH_IN03_i <= "00" & s_ejet(3) when conf(4) = '0' else sorta(03);
			  s_CH_IN04_i <= "00" & s_ejet(4) when conf(4) = '0' else sorta(04);
			  s_CH_IN05_i <= "00" & s_ejet(5) when conf(4) = '0' else sorta(05);
			  s_CH_IN06_i <= "00" & s_ejet(6) when conf(4) = '0' else sorta(06);
			  s_CH_IN07_i <= "00" & s_ejet(7) when conf(4) = '0' else sorta(07);
			  s_CH_IN08_i <= "00" & s_ejet(8) when conf(4) = '0' else sorta(08);
			  s_CH_IN09_i <= "00" & s_ejet(9) when conf(4) = '0' else sorta(09);
			  s_CH_IN10_i <= "00" & s_ejet(10) when conf(4) = '0' else sorta(10);
			  s_CH_IN11_i <= "00" & s_ejet(11) when conf(4) = '0' else sorta(11);
			  
			  s_CH_IN12_i <= "00" & s_ejet(0) when conf(4) = '0' else sortb(00);
			  s_CH_IN13_i <= "00" & s_ejet(1) when conf(4) = '0' else sortb(01);
			  s_CH_IN14_i <= "00" & s_ejet(2) when conf(4) = '0' else sortb(02);
			  s_CH_IN15_i <= "00" & s_ejet(3) when conf(4) = '0' else sortb(03);
			  s_CH_IN16_i <= "00" & s_ejet(4) when conf(4) = '0' else sortb(04);
			  s_CH_IN17_i <= "00" & s_ejet(5) when conf(4) = '0' else sortb(05);
			  s_CH_IN18_i <= "00" & s_ejet(6) when conf(4) = '0' else sortb(06);
			  s_CH_IN19_i <= "00" & s_ejet(7) when conf(4) = '0' else sortb(07);
			  s_CH_IN20_i <= "00" & s_ejet(8) when conf(4) = '0' else sortb(08);
			  s_CH_IN21_i <= "00" & s_ejet(9) when conf(4) = '0' else sortb(09);
			  s_CH_IN22_i <= "00" & s_ejet(10) when conf(4) = '0' else sortb(10);
			  s_CH_IN23_i <= "00" & s_ejet(11) when conf(4) = '0' else sortb(11);
			  
			  s_CH_IN24_i <= "000";
			  s_CH_IN25_i <= "000";
			  s_CH_IN26_i <= "000";
			  s_CH_IN27_i <= "000";
			  s_CH_IN28_i <= "000";
			  s_CH_IN29_i <= "000";
			  s_CH_IN30_i <= "000";
			  s_CH_IN31_i <= "000";
			  s_CH_IN32_i <= "000";
			  s_CH_IN33_i <= "000";
			  s_CH_IN34_i <= "000";
			  s_CH_IN35_i <= "000";
			  s_CH_IN36_i <= "000";
			  s_CH_IN37_i <= "000";
			  s_CH_IN38_i <= "000";
			  s_CH_IN39_i <= "000";
			  s_CH_IN40_i <= "000";
			  s_CH_IN41_i <= "000";
			  s_CH_IN42_i <= "000";
			  s_CH_IN43_i <= "000";
			  s_CH_IN44_i <= "000";
			  s_CH_IN45_i <= "000";
			  s_CH_IN46_i <= "000";
			  s_CH_IN47_i <= "000";
			  s_CH_IN48_i <= "000";
			  s_CH_IN49_i <= "000";
			  s_CH_IN50_i <= "000";
			  s_CH_IN51_i <= "000";
			  s_CH_IN52_i <= "000";
			  s_CH_IN53_i <= "000";
			  s_CH_IN54_i <= "000";
			  s_CH_IN55_i <= "000";
			  s_CH_IN56_i <= "000";
			  s_CH_IN57_i <= "000";
			  s_CH_IN58_i <= "000";
			  s_CH_IN59_i <= "000";
			  s_CH_IN60_i <= "000";
			  s_CH_IN61_i <= "000";
			  s_CH_IN62_i <= "000";
			  s_CH_IN63_i <= "000";
			  
			  s_adwell1 <= "0100101111" when conf(4) = '0' else adwell1 & "00"; 
			  s_bdwell1 <= "0100101111" when conf(4) = '0' else bdwell1 & "00";

i_FORMAT : WRAPPER_TOP Port map ( 
			  
			  CH_IN00_i => s_CH_IN00_i,
			  CH_IN01_i => s_CH_IN01_i, 
			  CH_IN02_i => s_CH_IN02_i,
			  CH_IN03_i => s_CH_IN03_i,
			  CH_IN04_i => s_CH_IN04_i,
			  CH_IN05_i => s_CH_IN05_i,
			  CH_IN06_i => s_CH_IN06_i,
			  CH_IN07_i => s_CH_IN07_i,
			  CH_IN08_i => s_CH_IN08_i,
			  CH_IN09_i => s_CH_IN09_i,
			  CH_IN10_i => s_CH_IN10_i,
			  CH_IN11_i => s_CH_IN11_i,
			  CH_IN12_i => s_CH_IN12_i,
			  CH_IN13_i => s_CH_IN13_i,
			  CH_IN14_i => s_CH_IN14_i,
			  CH_IN15_i => s_CH_IN15_i,
			  CH_IN16_i => s_CH_IN16_i,
			  CH_IN17_i => s_CH_IN17_i,
			  CH_IN18_i => s_CH_IN18_i,
			  CH_IN19_i => s_CH_IN19_i,
			  CH_IN20_i => s_CH_IN20_i,
			  CH_IN21_i => s_CH_IN21_i,
			  CH_IN22_i => s_CH_IN22_i,
			  CH_IN23_i => s_CH_IN23_i,
			  CH_IN24_i => s_CH_IN24_i,
			  CH_IN25_i => s_CH_IN25_i,
			  CH_IN26_i => s_CH_IN26_i,
			  CH_IN27_i => s_CH_IN27_i,
			  CH_IN28_i => s_CH_IN28_i,
			  CH_IN29_i => s_CH_IN29_i,
			  CH_IN30_i => s_CH_IN30_i,
			  CH_IN31_i => s_CH_IN31_i,
			  CH_IN32_i => s_CH_IN32_i,
			  CH_IN33_i => s_CH_IN33_i,
			  CH_IN34_i => s_CH_IN34_i,
			  CH_IN35_i => s_CH_IN35_i,
			  CH_IN36_i => s_CH_IN36_i,
			  CH_IN37_i => s_CH_IN37_i,
			  CH_IN38_i => s_CH_IN38_i,
			  CH_IN39_i => s_CH_IN39_i,
			  CH_IN40_i => s_CH_IN40_i,
			  CH_IN41_i => s_CH_IN41_i,
			  CH_IN42_i => s_CH_IN42_i,
			  CH_IN43_i => s_CH_IN43_i,
			  CH_IN44_i => s_CH_IN44_i,
			  CH_IN45_i => s_CH_IN45_i,
			  CH_IN46_i => s_CH_IN46_i,
			  CH_IN47_i => s_CH_IN47_i,
			  CH_IN48_i => s_CH_IN48_i,
			  CH_IN49_i => s_CH_IN49_i,
			  CH_IN50_i => s_CH_IN50_i,
			  CH_IN51_i => s_CH_IN51_i,
			  CH_IN52_i => s_CH_IN52_i,
			  CH_IN53_i => s_CH_IN53_i,
			  CH_IN54_i => s_CH_IN54_i,
			  CH_IN55_i => s_CH_IN55_i,
			  CH_IN56_i => s_CH_IN56_i,
			  CH_IN57_i => s_CH_IN57_i,
			  CH_IN58_i => s_CH_IN58_i,
			  CH_IN59_i => s_CH_IN59_i,
			  CH_IN60_i => s_CH_IN60_i,
			  CH_IN61_i => s_CH_IN61_i,
			  CH_IN62_i => s_CH_IN62_i,
			  CH_IN63_i => s_CH_IN63_i,
           SYNC1_i => sincperiod,
			  SYNC1_EL_7_i => sincperiod_el_7,
           SYNC2_i => sincperiodb,
			  SYNC2_EL_7_i => sincperiodb_el_7,
--			  A_TEMPO_MORTO_i => "000",
--			  B_TEMPO_MORTO_i => "000",
			  TEMPO_ESTATISTICA_i => "001", 
			  HAS_GRAIN_i => "0000000000000000000000000000000000000000" & 
								  s_has_grain_B(11 downto 0) & s_has_grain_A(11 downto 0),
			  INT_CH_REQ_i => ndumpdsm,
			  
			  RETRIGGER_ON_i => conf(1),
			  
				A_ELIPSE1_i => s_adwell1, 
				A_ELIPSE2_i => adwell2 & "00",
				A_ELIPSE3_i => adwell3 & "00",
				A_ELIPSE4_i => adwell4 & "00",
				A_ELIPSE5_i => adwell5 & "00",
				A_ELIPSE6_i => adwell6 & "00",
				A_ELIPSE7_i => adwell7 & "00",
				
				B_ELIPSE1_i => s_bdwell1, 
				B_ELIPSE2_i => bdwell2 & "00",
				B_ELIPSE3_i => bdwell3 & "00",
				B_ELIPSE4_i => bdwell4 & "00",
				B_ELIPSE5_i => bdwell5 & "00",
				B_ELIPSE6_i => bdwell6 & "00",
				B_ELIPSE7_i => bdwell7 & "00",
				
			  OVERUSAGE_CLR_A_i => s_has_overusage_clr,--s_overusage_clr_a,
			  OVERUSAGE_CLR_B_i => s_has_overusage_clr,
												
           C20US_i 	=> C20US,
           C18MHZ_i 	=> clkz,
			  C56MHz_i => clkaq,
           C3KHZ_i 	=> chopvalve,
           RST_i 		=> RESET,
			  
			  PROBE_o => open, --s_probe,
			  EJ_CNT_o => s_EJ_CNT_o, --EJections Count (O numero de ejecoes no tempo escolhido)
           MAX_ACTIVE_COUNTER_o => s_max_active_counter,
			  OVERUSAGE_o(31 downto 0) => s_overusage_a,
			  OVERUSAGE_o(63 downto 32) => s_overusage_b,
			  CH_EJ_o(31 downto 0) 	=> ejatxdata,
           CH_EJ_o(63 downto 32) 	=> ejbtxdata); 
			  
------------------------------------------------------------------------------------------------------
----------------------------------------- Ejector Interface ------------------------------------------
------------------------------------------------------------------------------------------------------

	-- Testejet signal generator
	TESTEJET_GEN : TESTEJET 
	Port map ( 	
					CLK_1_i => c1us,
					CLK_18_i => clkz,
					RESET_i => reset,
					TEJET_CHUTE_i => s_tejet_chute,
					TEJET_DWELL_i => s_tejet_dwell,
					TEJETBUFF_i => s_tejetbuff,
--					TEJET_ACTIVE_TIME_i => conf(2),
					DO_TESTEJETA_o => do_testejeta,
					DO_TESTEJETB_o => do_testejetb,
					TJET_o => tjet
				);
				
-- mux

	process (clrpaca,reset,rqpaca) -- interlock to detect end of package comm cycle
	begin
	  if reset='1' or clrpaca='1' then
	     ispaca<='0';
	  elsif rising_edge(rqpaca) then
	     ispaca<='1';
	  end if;
	end process;

	process (clrpacb,reset,rqpacb) -- interlock to detect end of package comm cycle
	begin
	  if reset='1' or clrpacb='1' then
	     ispacb<='0';
	  elsif rising_edge(rqpacb) then
	     ispacb<='1';
	  end if;
	end process;

-- signal assignment for CASE
   rteja <= CONV_INTEGER(rxsa(34 downto 32));	-- indexes for local memory of ejector status
   rtejb <= CONV_INTEGER(rxsb(34 downto 32));	
------------------------------------------------------------------------------------------------------
-- Serial communication with Ejector Module
-- 2 communication circuits in one because one FPGA takes care of 2 chutes

-- serializer	
   process (clkz,reset) -- 18.75MHz
	variable bc : integer range 0 to 63;
	variable ejs : integer range 0 to 15;
	begin
	  if reset='1' then
		 ejs:=0;
	  clrpaca<='0';
	  clrpacb<='0';
	  elsif falling_edge(clkz) then
	  clrpaca<='0';
	  clrpacb<='0';
       case ejs is
		   when 0 => ejs:=1; eja_ck<='0'; ejb_ck<='0'; eja_tx<='0'; ejb_tx<='0'; bc:=0;
		   when 1 => ejs:=2; eja_ck<='0'; ejb_ck<='0'; eja_tx<='0'; ejb_tx<='0'; -- idle
		   when 2 => ejs:=3; eja_ck<='1'; ejb_ck<='1'; eja_tx<='0'; ejb_tx<='0'; 
			          -- insert package here
						 if (do_testejeta = '1') then 
						     ejapkt<="001" & "00000000000000000000" & tjet(11 downto 0);
						 else
							if (do_testejetb = '1') then 
								ejapkt<="001" & "00000000" & tjet(11 downto 0) & "000000000000";
							else
								if ispaca='1' then
								  ejapkt<=wcom & wejt;
								  clrpaca<='1';
								else
									ejapkt<="001" & "00000000" & ejatxdata(23 downto 12) & ejatxdata(11 downto 0); -- normal: ejectors are sorting
								end if;
							end if;
						 end if;
						 
						 if do_testejetb='1' then 
						     ejbpkt<="001"&tjet;
							 elsif ispacb='1' then
							  ejbpkt<=wcom & wejt;
							  clrpacb<='1';
							 else
			              ejbpkt<="001" & ejbtxdata; -- normal: ejectors are sorting
						 end if; 
						 
						  
		   when 3 => ejs:=4; eja_ck<='1'; ejb_ck<='1'; eja_tx<='1'; ejb_tx<='1'; -- start
		               txsa <= not 
							      (ejapkt(34) xor ejapkt(33) xor ejapkt(32) xor ejapkt(31) xor ejapkt(30) xor ejapkt(29) xor ejapkt(28) xor ejapkt(27) xor ejapkt(26) xor 
							       ejapkt(25) xor ejapkt(24) xor ejapkt(23) xor ejapkt(22) xor ejapkt(21) xor ejapkt(20) xor ejapkt(19) xor ejapkt(18) xor ejapkt(17) xor 
									 ejapkt(16) xor ejapkt(15) xor ejapkt(14) xor ejapkt(13) xor ejapkt(12) xor ejapkt(11) xor ejapkt(10) xor ejapkt(9)  xor ejapkt(8) xor 
									 ejapkt(7)  xor ejapkt(6)  xor ejapkt(5)  xor ejapkt(4)  xor ejapkt(3)  xor ejapkt(2)  xor ejapkt(1)  xor ejapkt(0)) 
					             & ejapkt;

		               txsb <= not 
							      (ejbpkt(34) xor ejbpkt(33) xor ejbpkt(32) xor ejbpkt(31) xor ejbpkt(30) xor ejbpkt(29) xor ejbpkt(28) xor ejbpkt(27) xor ejbpkt(26) xor 
							       ejbpkt(25) xor ejbpkt(24) xor ejbpkt(23) xor ejbpkt(22) xor ejbpkt(21) xor ejbpkt(20) xor ejbpkt(19) xor ejbpkt(18) xor ejbpkt(17) xor 
									 ejbpkt(16) xor ejbpkt(15) xor ejbpkt(14) xor ejbpkt(13) xor ejbpkt(12) xor ejbpkt(11) xor ejbpkt(10) xor ejbpkt(9)  xor ejbpkt(8) xor 
									 ejbpkt(7)  xor ejbpkt(6)  xor ejbpkt(5)  xor ejbpkt(4)  xor ejbpkt(3)  xor ejbpkt(2)  xor ejbpkt(1)  xor ejbpkt(0)) 
					             & ejbpkt;

		   when 4 => ejs:=5; eja_ck<='0'; ejb_ck<='0'; eja_tx<='0'; ejb_tx<='0'; 
			
		   when 5 => ejs:=6; 
			          eja_ck<='0'; ejb_ck<='0';  -- tx/rx
			          eja_tx<=txsa(35); ejb_tx<=txsb(35);

		   when 6 => ejs:=7; 
			          eja_ck<='1'; ejb_ck<='1';  -- tx/rx
			          eja_tx<=txsa(35); ejb_tx<=txsb(35);
						 
              		 rxsa<=rxsa(34 downto 0) & eja_rx;
              		 rxsb<=rxsb(34 downto 0) & ejb_rx;

		   when 7 => ejs:=8; 
			          eja_ck<='1'; ejb_ck<='1';  -- tx/rx
			          eja_tx<=txsa(35); ejb_tx<=txsb(35);

                   txsa<=txsa(34 downto 0) & '0';
                   txsb<=txsb(34 downto 0) & '0';
						 
		   when 8 => ejs:=5; 
			          eja_ck<='0'; ejb_ck<='0';  -- tx/rx
			          eja_tx<=txsa(35); ejb_tx<=txsb(35);
						 bc:=bc+1;
						 if bc>=36 then ejs:=9; end if;
						 
		             rxpara <= rxsa(35) xor rxsa(34) xor rxsa(33) xor rxsa(32) xor rxsa(31) xor rxsa(30) xor rxsa(29) xor rxsa(28) xor rxsa(27) xor rxsa(26) xor 
						           rxsa(25) xor rxsa(24) xor rxsa(23) xor rxsa(22) xor rxsa(21) xor rxsa(20) xor rxsa(19) xor rxsa(18) xor rxsa(17) xor rxsa(16) xor 
									  rxsa(15) xor rxsa(14) xor rxsa(13) xor rxsa(12) xor rxsa(11) xor rxsa(10) xor rxsa(9)  xor rxsa(8)  xor rxsa(7)  xor rxsa(6) xor 
		                       rxsa(5)  xor rxsa(4)  xor rxsa(3)  xor rxsa(2)  xor rxsa(1)  xor rxsa(0); 						 

		             rxparb <= rxsb(35) xor rxsb(34) xor rxsb(33) xor rxsb(32) xor rxsb(31) xor rxsb(30) xor rxsb(29) xor rxsb(28) xor rxsb(27) xor rxsb(26) xor 
						           rxsb(25) xor rxsb(24) xor rxsb(23) xor rxsb(22) xor rxsb(21) xor rxsb(20) xor rxsb(19) xor rxsb(18) xor rxsb(17) xor rxsb(16) xor 
									  rxsb(15) xor rxsb(14) xor rxsb(13) xor rxsb(12) xor rxsb(11) xor rxsb(10) xor rxsb(9)  xor rxsb(8)  xor rxsb(7)  xor rxsb(6) xor 
		                       rxsb(5)  xor rxsb(4)  xor rxsb(3)  xor rxsb(2)  xor rxsb(1)  xor rxsb(0); 						 

		   when 9 => ejs:=10; 
			          eja_ck<='0'; ejb_ck<='0';  -- idle
			          eja_tx<='0'; ejb_tx<='0';
						 if rxpara='1' then 
						    ejdt0(rteja) <= rxsa (31 downto 0);
						 end if;
						 if rxparb='1' then 
						    ejdt1(rtejb) <= rxsb (31 downto 0);
						 end if;
						 
		   when 10=> ejs:=11; 
			          eja_ck<='1'; ejb_ck<='1';  -- idle
			          eja_tx<='0'; ejb_tx<='0';

		   when 11=> ejs:=0; 
			          eja_ck<='1'; ejb_ck<='1';  -- idle
			          eja_tx<='0'; ejb_tx<='0';
						 
						 
		   when others =>
		 end case;
	  end if;
	end process;
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- not used yet PINs	 

	 -- system
    -- microcontroler interface
--			  L_RX <= lrd or l_tx or F_Q;
			  L_IO <= "ZZ";
			  
	 -- FLASH interface (also used for FPGA configuration)
           F_Q <= 'Z';
           F_C <= 'Z';
           F_D <= 'Z';
           F_S <= 'Z';
	
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

end Behavioral;