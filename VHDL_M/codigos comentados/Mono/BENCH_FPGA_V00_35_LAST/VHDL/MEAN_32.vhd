----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:43:13 08/05/2011 
-- Design Name: 
-- Module Name:    MEAN_16K - Behavioral 
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
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEAN_16K is
		
  port (
		-- dados processados pela primeira maquina de estado, antes de ir para a fifo
		ACC_IN            : in  std_logic_vector(63 downto 0);
        -- pixel atual --> memoria transluc, reflect
		PIX_i             : in  std_logic_vector (7 downto 0);
		-- pixel na FIFO
        POX_i             : in  std_logic_vector (7 downto 0);
		-- tem nova amostra, pode começar, altera maquina de estado
        CANSUM_i          : in  std_logic;
		-- é transluctãncia
        IS_TRANSLUC_i     : in  std_logic_vector(0 downto 0);
		-- é reflectancia
        IS_REFLECT_i      : in  std_logic_vector(0 downto 0);
		-- limpa medias 
        CLR_MEAN_A_i      : in  std_logic;
        CLR_MEAN_B_i      : in  std_logic;
		-- ???
        NDUMPF_i          : in  std_logic_vector(7 downto 0);
		-- ???
        EXTEVENT_FLAGF_i  : in  std_logic;
        EXTEVENTAG_FLAG_i : in  std_logic;
		-- habilita  memoria
        READ_MEAN_i       : in  std_logic;
        RST_i             : in  std_logic;
        CLK_i             : in  std_logic;
        CLK_INV_i         : in  std_logic;
		
		-- limpa memorias ???
        CLR_MEAN_OFF_o    : out std_logic;
		-- ???
        ILLUM_A_o         : out std_logic_vector (63 downto 0);
        ILLUM_B_o         : out std_logic_vector (63 downto 0));
end MEAN_16K;

architecture Behavioral of MEAN_16K is

  component MEM_512x44
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(8 downto 0);
      dina  : in  std_logic_vector(43 downto 0);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(8 downto 0);
      doutb : out std_logic_vector(43 downto 0)
      );
  end component;

  component MEM_256x64
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(7 downto 0);
      dina  : in  std_logic_vector(63 downto 0);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(7 downto 0);
      doutb : out std_logic_vector(63 downto 0)
      );
  end component;

-- Floor CTRL
  signal s_final_side_a_addr, s_final_side_b_addr       : std_logic_vector (7 downto 0);
  signal s_acc_side_a_addr, s_acc_side_b_addr           : std_logic_vector (8 downto 0);
  signal s_acc_din, s_acc2_din, s_accb_din, s_acc2b_din : std_logic_vector(43 downto 0);
-------------

  signal s_mean_mux : std_logic;

  signal s_we_final_side_a_int, s_we_final_side_b_int           : std_logic;
  signal s_we_final_side_a, s_we_final_side_b                   : std_logic_vector (0 downto 0);
  signal st_mem16k                                              : std_logic_vector (4 downto 0);
  signal s_read_addr                                            : std_logic_vector (7 downto 0);
  signal s_floor_addr                                           : std_logic_vector (8 downto 0);
  signal s_final_side_a, s_final_side_a_out, s_final_side_a_din : std_logic_vector(63 downto 0);
  signal s_final_side_b, s_final_side_b_out, s_final_side_b_din : std_logic_vector(63 downto 0);

-- Front-end 
  signal s_acc_out_transluc, s_acc_out_reflect : std_logic_vector (63 downto 0);

-- ACC
  signal s_we_acc_mean_int                                 : std_logic;
  signal s_we_acc_mean                                     : std_logic_vector (0 downto 0);
  signal s_do_acc_reflect, s_do_acc_transluc               : std_logic;
  signal s_acc_reflect_max, s_acc_transluc_max             : std_logic;
  signal s_acc_reflect_rsum, s_acc_transluc_rsum           : std_logic_vector (13 downto 0);
  signal s_acc_reflect_wsum, s_acc_transluc_wsum           : std_logic_vector (13 downto 0);
  signal s_acc_reflect_final_int, s_acc_transluc_final_int : std_logic_vector (15 downto 0);
  signal s_acc_reflect_final, s_acc_transluc_final         : std_logic_vector (15 downto 0);
  signal s_acc_current_reflect, s_acc_current_transluc     : std_logic_vector (15 downto 0);
  signal s_acc_reflect_rmean, s_acc_transluc_rmean         : std_logic_vector (29 downto 0);
  signal s_acc_reflect_wmean, s_acc_transluc_wmean         : std_logic_vector (29 downto 0);
  signal s_acc_meanin, s_acc_meanout                       : std_logic_vector(43 downto 0);
  signal s_acc_reflect, s_acc_transluc                     : std_logic_vector(43 downto 0);

-- ACC2
  signal s_we_acc2_mean_int                                  : std_logic;
  signal s_we_acc2_mean                                      : std_logic_vector (0 downto 0);
  signal s_do_acc2_reflect, s_do_acc2_transluc               : std_logic;
  signal s_acc2_reflect_max, s_acc2_transluc_max             : std_logic;
  signal s_acc2_reflect_rsum, s_acc2_transluc_rsum           : std_logic_vector (13 downto 0);
  signal s_acc2_reflect_wsum, s_acc2_transluc_wsum           : std_logic_vector (13 downto 0);
  signal s_acc2_reflect_final_int, s_acc2_transluc_final_int : std_logic_vector (15 downto 0);
  signal s_acc2_reflect_final, s_acc2_transluc_final         : std_logic_vector (15 downto 0);
  signal s_acc2_current_reflect, s_acc2_current_transluc     : std_logic_vector (15 downto 0);
  signal s_acc2_reflect_rmean, s_acc2_transluc_rmean         : std_logic_vector (29 downto 0);
  signal s_acc2_reflect_wmean, s_acc2_transluc_wmean         : std_logic_vector (29 downto 0);
  signal s_acc2_meanin, s_acc2_meanout                       : std_logic_vector(43 downto 0);
  signal s_acc2_reflect, s_acc2_transluc                     : std_logic_vector(43 downto 0);

-- ACCB
  signal s_we_accb_mean_int                                  : std_logic;
  signal s_we_accb_mean                                      : std_logic_vector (0 downto 0);
  signal s_do_accb_reflect, s_do_accb_transluc               : std_logic;
  signal s_accb_reflect_max, s_accb_transluc_max             : std_logic;
  signal s_accb_reflect_rsum, s_accb_transluc_rsum           : std_logic_vector (13 downto 0);
  signal s_accb_reflect_wsum, s_accb_transluc_wsum           : std_logic_vector (13 downto 0);
  signal s_accb_reflect_final_int, s_accb_transluc_final_int : std_logic_vector (15 downto 0);
  signal s_accb_reflect_final, s_accb_transluc_final         : std_logic_vector (15 downto 0);
  signal s_accb_current_reflect, s_accb_current_transluc     : std_logic_vector (15 downto 0);
  signal s_accb_reflect_rmean, s_accb_transluc_rmean         : std_logic_vector (29 downto 0);
  signal s_accb_reflect_wmean, s_accb_transluc_wmean         : std_logic_vector (29 downto 0);
  signal s_accb_meanin, s_accb_meanout                       : std_logic_vector(43 downto 0);
  signal s_accb_reflect, s_accb_transluc                     : std_logic_vector(43 downto 0);

-- ACC2B
  signal s_we_acc2b_mean_int                                   : std_logic;
  signal s_we_acc2b_mean                                       : std_logic_vector (0 downto 0);
  signal s_do_acc2b_reflect, s_do_acc2b_transluc               : std_logic;
  signal s_acc2b_reflect_max, s_acc2b_transluc_max             : std_logic;
  signal s_acc2b_reflect_rsum, s_acc2b_transluc_rsum           : std_logic_vector (13 downto 0);
  signal s_acc2b_reflect_wsum, s_acc2b_transluc_wsum           : std_logic_vector (13 downto 0);
  signal s_acc2b_reflect_final_int, s_acc2b_transluc_final_int : std_logic_vector (15 downto 0);
  signal s_acc2b_reflect_final, s_acc2b_transluc_final         : std_logic_vector (15 downto 0);
  signal s_acc2b_current_reflect, s_acc2b_current_transluc     : std_logic_vector (15 downto 0);
  signal s_acc2b_reflect_rmean, s_acc2b_transluc_rmean         : std_logic_vector (29 downto 0);
  signal s_acc2b_reflect_wmean, s_acc2b_transluc_wmean         : std_logic_vector (29 downto 0);
  signal s_acc2b_meanin, s_acc2b_meanout                       : std_logic_vector(43 downto 0);
  signal s_acc2b_reflect, s_acc2b_transluc                     : std_logic_vector(43 downto 0);

begin

  i_ACC_TRANSLUC : MEM_256x64  -- Store transluscency front-end values 
    port map (
      clka  => CLK_i,
      wea   => IS_TRANSLUC_i,
      addra => PIX_i,
      dina  => ACC_IN,
      clkb  => CLK_INV_i,
      addrb => POX_i,
      doutb => s_acc_out_transluc
      );

  i_ACC_REFLECT : MEM_256x64            -- Store reflection front-end values 
    port map (
      clka  => CLK_i,
      wea   => IS_REFLECT_i,
      addra => PIX_i,
      dina  => ACC_IN,
      clkb  => CLK_INV_i,
      addrb => POX_i,
      doutb => s_acc_out_reflect
      );

  -------------------------------------------------------       
  -- ACC
  i_ACC_MEAN : MEM_512x44
    port map (
      clka  => CLK_INV_i,
      wea   => s_we_acc_mean,
      addra => s_acc_side_a_addr,
      dina  => s_acc_din,
      clkb  => CLK_INV_i,
      addrb => (s_mean_mux & POX_i),
      doutb => s_acc_meanout
      );

  s_acc_side_a_addr <= s_floor_addr when CLR_MEAN_A_i = '1' else (s_mean_mux & POX_i);

  s_acc_din     <= (others => '0') when CLR_MEAN_A_i = '1'                                  else s_acc_meanin;
  s_we_acc_mean <= "1"             when ((s_we_acc_mean_int = '1') or (CLR_MEAN_A_i = '1')) else "0";
  -------------------------------------------------------       
  -- ACC2
  i_ACC2_MEAN : MEM_512x44
    port map (
      clka  => CLK_INV_i,
      wea   => s_we_acc2_mean,
      addra => s_acc_side_a_addr,
      dina  => s_acc2_din,
      clkb  => CLK_INV_i,
      addrb => (s_mean_mux & POX_i),
      doutb => s_acc2_meanout
      );

  s_acc2_din     <= (others => '0') when CLR_MEAN_A_i = '1'                                   else s_acc2_meanin;
  s_we_acc2_mean <= "1"             when ((s_we_acc2_mean_int = '1') or (CLR_MEAN_A_i = '1')) else "0";
  -------------------------------------------------------       
  -- ACCB
  i_ACCB_MEAN : MEM_512x44
    port map (
      clka  => CLK_INV_i,
      wea   => s_we_accb_mean,
      addra => s_acc_side_b_addr,
      dina  => s_accb_din,
      clkb  => CLK_INV_i,
      addrb => (s_mean_mux & POX_i),
      doutb => s_accb_meanout
      );

  s_acc_side_b_addr <= s_floor_addr when CLR_MEAN_B_i = '1' else (s_mean_mux & POX_i);

  s_accb_din     <= (others => '0') when CLR_MEAN_B_i = '1'                                   else s_accb_meanin;
  s_we_accb_mean <= "1"             when ((s_we_accb_mean_int = '1') or (CLR_MEAN_B_i = '1')) else "0";
  -------------------------------------------------------       
  -- ACC2B
  i_ACC2B_MEAN : MEM_512x44
    port map (
      clka  => CLK_INV_i,
      wea   => s_we_acc2b_mean,
      addra => s_acc_side_b_addr,
      dina  => s_acc2b_din,
      clkb  => CLK_INV_i,
      addrb => (s_mean_mux & POX_i),
      doutb => s_acc2b_meanout
      );

  s_acc2b_din     <= (others => '0') when CLR_MEAN_B_i = '1'                                    else s_acc2b_meanin;
  s_we_acc2b_mean <= "1"             when ((s_we_acc2b_mean_int = '1') or (CLR_MEAN_B_i = '1')) else "0";
  -------------------------------------------------------       

  i_FINAL_SIDE_A : MEM_256x64
    port map (
      clka  => CLK_INV_i,
      wea   => s_we_final_side_a,
      addra => s_final_side_a_addr,
      dina  => s_final_side_a_din,
      clkb  => CLK_INV_i,
      addrb => s_read_addr,
      doutb => s_final_side_a_out
      );

  s_final_side_a_addr <= s_floor_addr(8 downto 1) when CLR_MEAN_A_i = '1' else POX_i;

  s_final_side_a_din <= ("0000000000000000" & "0000000000000000" & "0000000000000000" & "0000000000000000") when (CLR_MEAN_A_i = '1')                                                                                                 else s_final_side_a;
  s_we_final_side_a  <= "1"                                                                                 when (((s_we_final_side_a_int = '1') and (EXTEVENT_FLAGF_i = '0') and (EXTEVENTAG_FLAG_i = '0')) or (CLR_MEAN_A_i = '1')) else "0";

  i_FINAL_SIDE_B : MEM_256x64
    port map (
      clka  => CLK_INV_i,
      wea   => s_we_final_side_b,
      addra => s_final_side_b_addr,
      dina  => s_final_side_b_din,
      clkb  => CLK_INV_i,
      addrb => s_read_addr,
      doutb => s_final_side_b_out
      );

  s_final_side_b_addr <= s_floor_addr(8 downto 1) when CLR_MEAN_B_i = '1' else POX_i;

  s_final_side_b_din <= ("0000000000000000" & "0000000000000000" & "0000000000000000" & "0000000000000000") when (CLR_MEAN_B_i = '1')                                                                                                 else s_final_side_b;
  s_we_final_side_b  <= "1"                                                                                 when (((s_we_final_side_b_int = '1') and (EXTEVENT_FLAGF_i = '0') and (EXTEVENTAG_FLAG_i = '0')) or (CLR_MEAN_B_i = '1')) else "0";
  -------------------------------------------------------       

  s_read_addr <= NDUMPF_i when (((EXTEVENT_FLAGF_i = '1') and (READ_MEAN_i = '0')) or (EXTEVENTAG_FLAG_i = '1')) else POX_i;

  ILLUM_A_o <= s_final_side_a_out;
  ILLUM_B_o <= s_final_side_b_out;

  -- ACC
  s_do_acc_reflect  <= '1' when (s_acc_current_reflect > X"02B0")  else '0';
  s_do_acc_transluc <= '1' when (s_acc_current_transluc > X"02B0") else '0';

  -- ACC2
  s_do_acc2_reflect  <= '1' when (s_acc2_current_reflect > X"02B0")  else '0';
  s_do_acc2_transluc <= '1' when (s_acc2_current_transluc > X"02B0") else '0';

  -- ACCB
  s_do_accb_reflect  <= '1' when (s_accb_current_reflect > X"02B0")  else '0';
  s_do_accb_transluc <= '1' when (s_accb_current_transluc > X"02B0") else '0';

  -- ACC2B
  s_do_acc2b_reflect  <= '1' when (s_acc2b_current_reflect > X"02B0")  else '0';
  s_do_acc2b_transluc <= '1' when (s_acc2b_current_transluc > X"02B0") else '0';


  process (CLK_i, RST_i)
  begin
    if (RST_i = '1') then
      
      st_mem16k  <= (others => '0');
      s_mean_mux <= '0';

      s_we_final_side_a_int <= '0';     -- or entre todos os max
      s_we_final_side_b_int <= '0';     -- or entre todos os max

      -- ACC
      s_we_acc_mean_int   <= '0';
      -- ACC2
      s_we_acc2_mean_int  <= '0';
      -- ACCB
      s_we_accb_mean_int  <= '0';
      -- ACC2B
      s_we_acc2b_mean_int <= '0';

      -- ACC
      s_acc_reflect_max    <= '0';
      s_acc_transluc_max   <= '0';
      -- ACC2
      s_acc2_reflect_max   <= '0';
      s_acc2_transluc_max  <= '0';
      -- ACCB
      s_accb_reflect_max   <= '0';
      s_accb_transluc_max  <= '0';
      -- ACC2B
      s_acc2b_reflect_max  <= '0';
      s_acc2b_transluc_max <= '0';

      s_floor_addr <= (others => '0');
      
    elsif rising_edge (CLK_i) then
      
      if ((CLR_MEAN_A_i = '1') or (CLR_MEAN_B_i = '1')) then
        if s_floor_addr = "111111111" then
          CLR_MEAN_OFF_o <= '1';
        else
          s_floor_addr   <= s_floor_addr + 1;
          CLR_MEAN_OFF_o <= '0';
        end if;
      else
        CLR_MEAN_OFF_o <= '0';
        s_floor_addr   <= (others => '0');
      end if;

      case st_mem16k is
        -------------------------- 0 --------------------------
        when "00000" => if CANSUM_i = '1' then
                          st_mem16k <= "00001";
                        else
                          st_mem16k <= "00000";
                        end if;

       -------------------------- 1 --------------------------
        when "00001" =>
                                        -- ACC
          s_acc_reflect_rmean <= s_acc_meanout(29 downto 0);  -- Current sum of every sample acquired
          s_acc_reflect_rsum  <= s_acc_meanout(43 downto 30);  -- Current number of samples acquired

          s_acc_current_reflect  <= s_acc_out_reflect(63 downto 48);  -- Front-end memory current reflectancy value
          s_acc_current_transluc <= s_acc_out_transluc(63 downto 48);  -- Front-end memory current translucency value

          s_acc_reflect_final_int  <= s_final_side_a_out(63 downto 48);  -- Receives the last final mean in case the number of samples is not enough
          s_acc_transluc_final_int <= s_final_side_a_out(31 downto 16);

                                        -- ACC2
          s_acc2_reflect_rmean <= s_acc2_meanout(29 downto 0);  -- Current sum of every sample acquired
          s_acc2_reflect_rsum  <= s_acc2_meanout(43 downto 30);  -- Current number of samples acquired

          s_acc2_current_reflect  <= s_acc_out_reflect(47 downto 32);  -- Front-end memory current reflectancy value
          s_acc2_current_transluc <= s_acc_out_transluc(47 downto 32);  -- Front-end memory current translucency value

          s_acc2_reflect_final_int  <= s_final_side_a_out(47 downto 32);  -- Receives the last final mean in case the number of samples is not enough
          s_acc2_transluc_final_int <= s_final_side_a_out(15 downto 0);

                                        -- ACCB
          s_accb_reflect_rmean <= s_accb_meanout(29 downto 0);  -- Current sum of every sample acquired
          s_accb_reflect_rsum  <= s_accb_meanout(43 downto 30);  -- Current number of samples acquired

          s_accb_current_reflect  <= s_acc_out_reflect(31 downto 16);  -- Front-end memory current reflectancy value
          s_accb_current_transluc <= s_acc_out_transluc(31 downto 16);  -- Front-end memory current translucency value

          s_accb_reflect_final_int  <= s_final_side_b_out(63 downto 48);  -- Receives the last final mean in case the number of samples is not enough
          s_accb_transluc_final_int <= s_final_side_b_out(31 downto 16);

                                        -- ACC2B
          s_acc2b_reflect_rmean <= s_acc2b_meanout(29 downto 0);  -- Current sum of every sample acquired
          s_acc2b_reflect_rsum  <= s_acc2b_meanout(43 downto 30);  -- Current number of samples acquired

          s_acc2b_current_reflect  <= s_acc_out_reflect(15 downto 0);  -- Front-end memory current reflectancy value
          s_acc2b_current_transluc <= s_acc_out_transluc(15 downto 0);  -- Front-end memory current translucency value

          s_acc2b_reflect_final_int  <= s_final_side_b_out(47 downto 32);  -- Receives the last final mean in case the number of samples is not enough
          s_acc2b_transluc_final_int <= s_final_side_b_out(15 downto 0);


          st_mem16k <= "00010";
          -------------------------- 2 --------------------------
        when "00010" => st_mem16k  <= "00011";
         -------------------------- 3 --------------------------
        when "00011" => s_mean_mux <= '1';
                        st_mem16k <= "00100";
        -------------------------- 4 --------------------------
        when "00100" => st_mem16k <= "00101";
         -------------------------- 5 --------------------------
        when "00101" =>                 -- ACC
          s_acc_transluc_rmean <= s_acc_meanout(29 downto 0);
          s_acc_transluc_rsum  <= s_acc_meanout(43 downto 30);

                                        -- ACC2
          s_acc2_transluc_rmean <= s_acc2_meanout(29 downto 0);
          s_acc2_transluc_rsum  <= s_acc2_meanout(43 downto 30);

                                        -- ACCB
          s_accb_transluc_rmean <= s_accb_meanout(29 downto 0);
          s_accb_transluc_rsum  <= s_accb_meanout(43 downto 30);

                                        -- ACC2B
          s_acc2b_transluc_rmean <= s_acc2b_meanout(29 downto 0);
          s_acc2b_transluc_rsum  <= s_acc2b_meanout(43 downto 30);


          st_mem16k <= "00110";
          -------------------------- 6 --------------------------
        when "00110" => st_mem16k <= "00111";
                        -------------------------- 7 --------------------------
        when "00111" =>
                                        -- ACC
          if (s_do_acc_reflect = '1') then
            if (s_acc_reflect_rsum = "00011111111111") then
              s_acc_reflect_wsum  <= (others => '0');
              s_acc_reflect_wmean <= ("00000000000000" & s_acc_current_reflect);
--                                                                                              case SAMPLE_NUMBER_i is
--                                                                                                      when "00" => s_acc_reflect_final <= s_acc_reflect_rmean(29 downto 14);
--                                                                                                      when "01" => s_acc_reflect_final <= s_acc_reflect_rmean(28 downto 13);
--                                                                                                      when "10" => s_acc_reflect_final <= s_acc_reflect_rmean(27 downto 12);
--                                                                                                      when "11" => s_acc_reflect_final <= s_acc_reflect_rmean(26 downto 11);
--                                                                                                      when others => s_acc_reflect_final <= s_acc_reflect_rmean(29 downto 14);
--                                                                                              end case;
              --s_acc_reflect_final <= s_acc_reflect_rmean(29 downto 14); -- para 16k (29 downto 14)
              s_acc_reflect_final <= s_acc_reflect_rmean(26 downto 11);
              s_acc_reflect_max   <= '1';
            else
              s_acc_reflect_wsum  <= s_acc_reflect_rsum + 1;
              s_acc_reflect_wmean <= s_acc_reflect_rmean + ("00000000000000" & s_acc_current_reflect);
              s_acc_reflect_final <= s_acc_reflect_final_int;
              s_acc_reflect_max   <= '0';
            end if;
          else
            s_acc_reflect_max   <= '0';
            s_acc_reflect_final <= s_acc_reflect_final_int;
          end if;
          -------------------------------------------------------
          -- ACC2
          if (s_do_acc2_reflect = '1') then
            if (s_acc2_reflect_rsum = "00011111111111") then
              s_acc2_reflect_wsum  <= (others => '0');
              s_acc2_reflect_wmean <= ("00000000000000" & s_acc2_current_reflect);
--                                                                                              case SAMPLE_NUMBER_i is
--                                                                                                      when "00" => s_acc2_reflect_final <= s_acc2_reflect_rmean(29 downto 14);
--                                                                                                      when "01" => s_acc2_reflect_final <= s_acc2_reflect_rmean(28 downto 13);
--                                                                                                      when "10" => s_acc2_reflect_final <= s_acc2_reflect_rmean(27 downto 12);
--                                                                                                      when "11" => s_acc2_reflect_final <= s_acc2_reflect_rmean(26 downto 11);
--                                                                                                      when others => s_acc2_reflect_final <= s_acc2_reflect_rmean(29 downto 14);
--                                                                                              end case;
              --s_acc2_reflect_final <= s_acc2_reflect_rmean(29 downto 14); -- para 16k (29 downto 14)
              s_acc2_reflect_final <= s_acc2_reflect_rmean(26 downto 11);
              s_acc2_reflect_max   <= '1';
            else
              s_acc2_reflect_wsum  <= s_acc2_reflect_rsum + 1;
              s_acc2_reflect_wmean <= s_acc2_reflect_rmean + ("00000000000000" & s_acc2_current_reflect);
              s_acc2_reflect_final <= s_acc2_reflect_final_int;
              s_acc2_reflect_max   <= '0';
            end if;
          else
            s_acc2_reflect_max   <= '0';
            s_acc2_reflect_final <= s_acc2_reflect_final_int;
          end if;
          -------------------------------------------------------
          -- ACCB
          if (s_do_accb_reflect = '1') then
            if (s_accb_reflect_rsum = "00011111111111") then
              s_accb_reflect_wsum  <= (others => '0');
              s_accb_reflect_wmean <= ("00000000000000" & s_accb_current_reflect);
--                                                                                              case SAMPLE_NUMBER_i is
--                                                                                                      when "00" => s_accb_reflect_final <= s_accb_reflect_rmean(29 downto 14);
--                                                                                                      when "01" => s_accb_reflect_final <= s_accb_reflect_rmean(28 downto 13);
--                                                                                                      when "10" => s_accb_reflect_final <= s_accb_reflect_rmean(27 downto 12);
--                                                                                                      when "11" => s_accb_reflect_final <= s_accb_reflect_rmean(26 downto 11);
--                                                                                                      when others => s_accb_reflect_final <= s_accb_reflect_rmean(29 downto 14);
--                                                                                              end case;
              --s_accb_reflect_final <= s_accb_reflect_rmean(29 downto 14); -- para 16k (29 downto 14)
              s_accb_reflect_final <= s_accb_reflect_rmean(26 downto 11);
              s_accb_reflect_max   <= '1';
            else
              s_accb_reflect_wsum  <= s_accb_reflect_rsum + 1;
              s_accb_reflect_wmean <= s_accb_reflect_rmean + ("00000000000000" & s_accb_current_reflect);
              s_accb_reflect_final <= s_accb_reflect_final_int;
              s_accb_reflect_max   <= '0';
            end if;
          else
            s_accb_reflect_max   <= '0';
            s_accb_reflect_final <= s_accb_reflect_final_int;
          end if;
          -------------------------------------------------------
          -- ACC2B
          if (s_do_acc2b_reflect = '1') then
            if (s_acc2b_reflect_rsum = "00011111111111") then
              s_acc2b_reflect_wsum  <= (others => '0');
              s_acc2b_reflect_wmean <= ("00000000000000" & s_acc2b_current_reflect);
--                                                                                              case SAMPLE_NUMBER_i is
--                                                                                                      when "00" => s_acc2b_reflect_final <= s_acc2b_reflect_rmean(29 downto 14);
--                                                                                                      when "01" => s_acc2b_reflect_final <= s_acc2b_reflect_rmean(28 downto 13);
--                                                                                                      when "10" => s_acc2b_reflect_final <= s_acc2b_reflect_rmean(27 downto 12);
--                                                                                                      when "11" => s_acc2b_reflect_final <= s_acc2b_reflect_rmean(26 downto 11);
--                                                                                                      when others => s_acc2b_reflect_final <= s_acc2b_reflect_rmean(29 downto 14);
--                                                                                              end case;
              --s_acc2b_reflect_final <= s_acc2b_reflect_rmean(29 downto 14); -- para 16k (29 downto 14)
              s_acc2b_reflect_final <= s_acc2b_reflect_rmean(26 downto 11);
              s_acc2b_reflect_max   <= '1';
            else
              s_acc2b_reflect_wsum  <= s_acc2b_reflect_rsum + 1;
              s_acc2b_reflect_wmean <= s_acc2b_reflect_rmean + ("00000000000000" & s_acc2b_current_reflect);
              s_acc2b_reflect_final <= s_acc2b_reflect_final_int;
              s_acc2b_reflect_max   <= '0';
            end if;
          else
            s_acc2b_reflect_max   <= '0';
            s_acc2b_reflect_final <= s_acc2b_reflect_final_int;
          end if;

          st_mem16k <= "01000";
          -------------------------- 8 --------------------------
        when "01000" =>
                                        -- ACC
          if (s_do_acc_transluc = '1') then
            if (s_acc_transluc_rsum = "00011111111111") then
              s_acc_transluc_wsum  <= (others => '0');
              s_acc_transluc_wmean <= ("00000000000000" & s_acc_current_transluc);
--                                                                                              case SAMPLE_NUMBER_i is
--                                                                                                      when "00" => s_acc_transluc_final <= s_acc_transluc_rmean(29 downto 14);
--                                                                                                      when "01" => s_acc_transluc_final <= s_acc_transluc_rmean(28 downto 13);
--                                                                                                      when "10" => s_acc_transluc_final <= s_acc_transluc_rmean(27 downto 12);
--                                                                                                      when "11" => s_acc_transluc_final <= s_acc_transluc_rmean(26 downto 11);
--                                                                                                      when others => s_acc_transluc_final <= s_acc_transluc_rmean(29 downto 14);
--                                                                                              end case;
              --s_acc_transluc_final <= s_acc_transluc_rmean(29 downto 14); -- para 16k (29 downto 14)
              s_acc_transluc_final <= s_acc_transluc_rmean(26 downto 11);
              s_acc_transluc_max   <= '1';
            else
              s_acc_transluc_wsum  <= s_acc_transluc_rsum + 1;
              s_acc_transluc_wmean <= s_acc_transluc_rmean + ("00000000000000" & s_acc_current_transluc);
              s_acc_transluc_final <= s_acc_transluc_final_int;
              s_acc_transluc_max   <= '0';
            end if;
          else
            s_acc_transluc_max   <= '0';
            s_acc_transluc_final <= s_acc_transluc_final_int;
          end if;
          -------------------------------------------------------
          -- ACC2
          if (s_do_acc2_transluc = '1') then
            if (s_acc2_transluc_rsum = "00011111111111") then
              s_acc2_transluc_wsum  <= (others => '0');
              s_acc2_transluc_wmean <= ("00000000000000" & s_acc2_current_transluc);
--                                                                                              case SAMPLE_NUMBER_i is
--                                                                                                      when "00" => s_acc2_transluc_final <= s_acc2_transluc_rmean(29 downto 14);
--                                                                                                      when "01" => s_acc2_transluc_final <= s_acc2_transluc_rmean(28 downto 13);
--                                                                                                      when "10" => s_acc2_transluc_final <= s_acc2_transluc_rmean(27 downto 12);
--                                                                                                      when "11" => s_acc2_transluc_final <= s_acc2_transluc_rmean(26 downto 11);
--                                                                                                      when others => s_acc2_transluc_final <= s_acc2_transluc_rmean(29 downto 14);
--                                                                                              end case;
              --s_acc2_transluc_final <= s_acc2_transluc_rmean(29 downto 14); -- para 16k (29 downto 14)
              s_acc2_transluc_final <= s_acc2_transluc_rmean(26 downto 11);
              s_acc2_transluc_max   <= '1';
            else
              s_acc2_transluc_wsum  <= s_acc2_transluc_rsum + 1;
              s_acc2_transluc_wmean <= s_acc2_transluc_rmean + ("00000000000000" & s_acc2_current_transluc);
              s_acc2_transluc_final <= s_acc2_transluc_final_int;
              s_acc2_transluc_max   <= '0';
            end if;
          else
            s_acc2_transluc_max   <= '0';
            s_acc2_transluc_final <= s_acc2_transluc_final_int;
          end if;
          -------------------------------------------------------
          -- ACCB
          if (s_do_accb_transluc = '1') then
            if (s_accb_transluc_rsum = "00011111111111") then
              s_accb_transluc_wsum  <= (others => '0');
              s_accb_transluc_wmean <= ("00000000000000" & s_accb_current_transluc);
--                                                                                              case SAMPLE_NUMBER_i is
--                                                                                                      when "00" => s_accb_transluc_final <= s_accb_transluc_rmean(29 downto 14);
--                                                                                                      when "01" => s_accb_transluc_final <= s_accb_transluc_rmean(28 downto 13);
--                                                                                                      when "10" => s_accb_transluc_final <= s_accb_transluc_rmean(27 downto 12);
--                                                                                                      when "11" => s_accb_transluc_final <= s_accb_transluc_rmean(26 downto 11);
--                                                                                                      when others => s_accb_transluc_final <= s_accb_transluc_rmean(29 downto 14);
--                                                                                              end case;
              --s_accb_transluc_final <= s_accb_transluc_rmean(29 downto 14); -- para 16k (29 downto 14)
              s_accb_transluc_final <= s_accb_transluc_rmean(26 downto 11);
              s_accb_transluc_max   <= '1';
            else
              s_accb_transluc_wsum  <= s_accb_transluc_rsum + 1;
              s_accb_transluc_wmean <= s_accb_transluc_rmean + ("00000000000000" & s_accb_current_transluc);
              s_accb_transluc_final <= s_accb_transluc_final_int;
              s_accb_transluc_max   <= '0';
            end if;
          else
            s_accb_transluc_max   <= '0';
            s_accb_transluc_final <= s_accb_transluc_final_int;
          end if;
          -------------------------------------------------------
          -- ACC2B
          if (s_do_acc2b_transluc = '1') then
            if (s_acc2b_transluc_rsum = "00011111111111") then
              s_acc2b_transluc_wsum  <= (others => '0');
              s_acc2b_transluc_wmean <= ("00000000000000" & s_acc2b_current_transluc);
--                                                                                              case SAMPLE_NUMBER_i is
--                                                                                                      when "00" => s_acc2b_transluc_final <= s_acc2b_transluc_rmean(29 downto 14);
--                                                                                                      when "01" => s_acc2b_transluc_final <= s_acc2b_transluc_rmean(28 downto 13);
--                                                                                                      when "10" => s_acc2b_transluc_final <= s_acc2b_transluc_rmean(27 downto 12);
--                                                                                                      when "11" => s_acc2b_transluc_final <= s_acc2b_transluc_rmean(26 downto 11);
--                                                                                                      when others => s_acc2b_transluc_final <= s_acc2b_transluc_rmean(29 downto 14);
--                                                                                              end case;
              --s_acc2b_transluc_final <= s_acc2b_transluc_rmean(29 downto 14); -- para 16k (29 downto 14)
              s_acc2b_transluc_final <= s_acc2b_transluc_rmean(26 downto 11);
              s_acc2b_transluc_max   <= '1';
            else
              s_acc2b_transluc_wsum  <= s_acc2b_transluc_rsum + 1;
              s_acc2b_transluc_wmean <= s_acc2b_transluc_rmean + ("00000000000000" & s_acc2b_current_transluc);
              s_acc2b_transluc_final <= s_acc2b_transluc_final_int;
              s_acc2b_transluc_max   <= '0';
            end if;
          else
            s_acc2b_transluc_max   <= '0';
            s_acc2b_transluc_final <= s_acc2b_transluc_final_int;
          end if;

          st_mem16k <= "10100";
          -------------------------- 20 --------------------------
        when "10100" => st_mem16k <= "01001";
                        -------------------------- 9 --------------------------
        when "01001" =>
                                        -- ACC
          s_acc_reflect    <= s_acc_reflect_wsum & s_acc_reflect_wmean;
          s_acc_transluc   <= s_acc_transluc_wsum & s_acc_transluc_wmean;
                                        -- ACC2
          s_acc2_reflect   <= s_acc2_reflect_wsum & s_acc2_reflect_wmean;
          s_acc2_transluc  <= s_acc2_transluc_wsum & s_acc2_transluc_wmean;
                                        -- ACCB
          s_accb_reflect   <= s_accb_reflect_wsum & s_accb_reflect_wmean;
          s_accb_transluc  <= s_accb_transluc_wsum & s_accb_transluc_wmean;
                                        -- ACC2B
          s_acc2b_reflect  <= s_acc2b_reflect_wsum & s_acc2b_reflect_wmean;
          s_acc2b_transluc <= s_acc2b_transluc_wsum & s_acc2b_transluc_wmean;

          s_final_side_a <= s_acc_reflect_final & s_acc2_reflect_final & s_acc_transluc_final & s_acc2_transluc_final;
          s_final_side_b <= s_accb_reflect_final & s_acc2b_reflect_final & s_accb_transluc_final & s_acc2b_transluc_final;

          st_mem16k <= "01010";
          -------------------------- 10 --------------------------
        when "01010" => st_mem16k <= "01011";
                        -------------------------- 11 --------------------------
        when "01011" =>
                                        -- ACC
          s_acc_meanin   <= s_acc_transluc;
                                        -- ACC2
          s_acc2_meanin  <= s_acc2_transluc;
                                        -- ACCB
          s_accb_meanin  <= s_accb_transluc;
                                        -- ACC2B
          s_acc2b_meanin <= s_acc2b_transluc;

          st_mem16k <= "01100";
          -------------------------- 12 --------------------------
        when "01100" => st_mem16k <= "01101";
                        -------------------------- 13 --------------------------
        when "01101" =>
                                        -- ACC
          s_we_acc_mean_int   <= s_do_acc_transluc;
                                        -- ACC2
          s_we_acc2_mean_int  <= s_do_acc2_transluc;
                                        -- ACCB
          s_we_accb_mean_int  <= s_do_accb_transluc;
                                        -- ACC2B
          s_we_acc2b_mean_int <= s_do_acc2b_transluc;

          st_mem16k <= "10011";
          -------------------------- 19 --------------------------
        when "10011" => st_mem16k  <= "10101";
                        -------------------------- 21 --------------------------
        when "10101" => st_mem16k  <= "01110";
                        -------------------------- 14 --------------------------
        when "01110" => s_mean_mux <= '0';

--                                                                       ACC
                        s_we_acc_mean_int   <= '0';
--                                                                       ACC2
                        s_we_acc2_mean_int  <= '0';
--                                                                       ACCB
                        s_we_accb_mean_int  <= '0';
--                                                                       ACC2B
                        s_we_acc2b_mean_int <= '0';

                                        -- ACC
                        s_acc_meanin   <= s_acc_reflect;
                                        -- ACC2
                        s_acc2_meanin  <= s_acc2_reflect;
                                        -- ACCB
                        s_accb_meanin  <= s_accb_reflect;
                                        -- ACC2B
                        s_acc2b_meanin <= s_acc2b_reflect;

                        st_mem16k <= "01111";
                        -------------------------- 15 --------------------------
        when "01111" => st_mem16k <= "10000";
                        -------------------------- 16 --------------------------
        when "10000" =>
                                        -- ACC
          s_we_acc_mean_int   <= s_do_acc_reflect;
                                        -- ACC2
          s_we_acc2_mean_int  <= s_do_acc2_reflect;
                                        -- ACCB
          s_we_accb_mean_int  <= s_do_accb_reflect;
                                        -- ACC2B
          s_we_acc2b_mean_int <= s_do_acc2b_reflect;

          s_we_final_side_a_int <= ((s_acc_reflect_max) or (s_acc2_reflect_max) or (s_acc_transluc_max) or (s_acc2_transluc_max));  -- or entre todos os max
          s_we_final_side_b_int <= ((s_accb_transluc_max) or (s_acc2b_transluc_max) or (s_accb_reflect_max) or (s_acc2b_reflect_max));  -- or entre todos os max
          st_mem16k             <= "10001";
          -------------------------- 17 --------------------------
        when "10001" => st_mem16k <= "10110";
                        -------------------------- 22 --------------------------
        when "10110" => st_mem16k <= "10010";
                        -------------------------- 18 --------------------------
        when "10010" => st_mem16k <= "00000";
                        s_we_final_side_a_int <= '0';  -- or entre todos os max
                        s_we_final_side_b_int <= '0';  -- or entre todos os max
--                                                                       ACC
                        s_we_acc_mean_int     <= '0';
--                                                                       ACC2
                        s_we_acc2_mean_int    <= '0';
--                                                                       ACCB
                        s_we_accb_mean_int    <= '0';
--                                                                       ACC2B
                        s_we_acc2b_mean_int   <= '0';
                        ------------------------ others -----------------------
                        
        when others => st_mem16k <= "00000";
      end case;
    end if;
  end process;
  
end Behavioral;
