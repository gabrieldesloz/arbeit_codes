----------------------------------------------------------------------------------
-- Company:                     B�hler Sanmak    
-- Engineer:                    Carlos Eduardo Bertagnolli
-- 
-- Create Date:         08:49:42 02/13/2012 
-- Design Name:                 SORT_CASE
-- Module Name:         SORT_CASE - Behavioral 
-- Project Name:                CCD8
-- Target Devices:      SPARTAN 6 SLX25
-- Tool versions:       ISE 13.3
-- Description:                 Sorting case module
--                                                      Based on the input bits set an output ejection and/or a defect count 
--
-- Dependencies:                MAIN.vhd
--
-- Revision: 
-- Revision 0.36                - File Created
-- Revision 0.36.02     - Change to combinational logic
-- Additional Comments: 
--                                                      Created to lower FPGA resources utilization
--                                                      Seems to improve sorted quality and reduce 
--                                                      good grains inside the reject
----------------------------------------------------------------------------------
-- altera o contador de defeitos rcont a/b



library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- verifica��o pra ejetar ou nao, para cada elipse


entity SORT_CASE is
  port(
    SORT_CASE_i : in std_logic_vector (6 downto 0);
    ------------------------------------------------------------------------------------------------------      
    --  SORT_CASE_i = entrigar & entriga & r_cont_set & inside_ellip_r & inside_ellip & set_eq_0 & flage --
    ------------------------------------------------------------------------------------------------------
    -- entriga/entrigar: Front/Rear cam product detection.
    -- r_cont_bg_set_A: Defect counter is higher than preset defect number.
    -- inside_ellip_A/Inside_ellip_r_A: Front/Rear camera detected pixel is inside ellipsis.
    -- set_eq_0_A:  The defect number is preset to 0 for that ellipsis.
    -- flagea: Cleans defect counter. Is activated when there was no product or defect on the line.
    ------------------------------------------------------------------------------------------------------
    RCONT_i     : in std_logic_vector (7 downto 0);  --      Counter readed from defect counter memory
    INX_i       : in std_logic_vector (2 downto 0);  --      Ellipsis being analyzed at the moment
    RESET_i     : in std_logic;         --      Reset Signal

    SHOT_X_o : out std_logic_vector (2 downto 0);  --     3 Bit shooting signal (according to ellipsis)
    WCONT_o  : out std_logic_vector (7 downto 0)   --      Updated counter
    );
end SORT_CASE;

architecture Behavioral of SORT_CASE is
  signal s_SORT_CASE_3_1 : std_logic_vector (1 downto 0);

begin

  s_SORT_CASE_3_1 <= SORT_CASE_i(3) & SORT_CASE_i(1);

  process (RESET_i)
  begin
    if (RESET_i = '1') then
      WCONT_o  <= "00000000";
      SHOT_X_o <= "000";

    else
      
      if SORT_CASE_i(0) = '1' then  -- If flage is active should reset defect counter
        
        WCONT_o  <= "00000000";
        SHOT_X_o <= "000";

      else               -- If not test if there is product on both chutes

        case (SORT_CASE_i(4) & SORT_CASE_i(6 downto 5)) is
          when "000" =>  -- If there is no product on none of the cameras (FRONT, REAR) 
            -- keep the defect counter and don't shoot 
            
            WCONT_o  <= RCONT_i;
            SHOT_X_o <= "000";
            
          when "001" =>  -- If there is defect only on front camera
          
            case SORT_CASE_i(2 downto 1) is
              when "10" =>
                WCONT_o  <= RCONT_i+1;
                SHOT_X_o <= "000";
              when "11" =>
                WCONT_o  <= "00000000";
                SHOT_X_o <= INX_i;
              when others =>
                WCONT_o  <= RCONT_i;
                SHOT_X_o <= "000";

            end case;
            
          when "010" =>  -- If there is defect only on rear camera
 
            case s_SORT_CASE_3_1 is
              when "10" =>
                WCONT_o  <= RCONT_i+1;
                SHOT_X_o <= "000";
              when "11" =>
                WCONT_o  <= "00000000";
                SHOT_X_o <= INX_i;
              when others =>
                WCONT_o  <= RCONT_i;
                SHOT_X_o <= "000";

            end case;
            
            
          when "011" =>                 -- If there is product on both cameras
            -------------------------------------------------------------------------------------
 
            case SORT_CASE_i(3 downto 1) is
--                                                                                        "321" 
              when "000" =>
                WCONT_o  <= RCONT_i;
                SHOT_X_o <= "000";
--                                                                                        "321"
              when "001" =>
                WCONT_o  <= RCONT_i;
                SHOT_X_o <= "000";
--                                                                                        "321"
              when "010" =>
                WCONT_o  <= RCONT_i+1;
                SHOT_X_o <= "000";
              when "100" =>
                WCONT_o  <= RCONT_i+1;
                SHOT_X_o <= "000";              when "110" =>
                WCONT_o <= RCONT_i+2; 
               SHOT_X_o <= "000";

              when others =>
                WCONT_o  <= "00000000";
                SHOT_X_o <= INX_i;

            end case;
            
          when "100" =>  -- If there is no product but counter reached maximum
            WCONT_o  <= RCONT_i;
            SHOT_X_o <= "000";
            
          when others =>                -- when "101", "110", "111" 
                                        -- If counter reached maximum and there is product, SHOOT!
            WCONT_o  <= "00000000";
            SHOT_X_o <= INX_i;
            
            
        end case;
        
      end if;
    end if;
    
  end process;


end Behavioral;
