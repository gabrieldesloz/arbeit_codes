----------------------------------------
--          Xilinx Top Sheet          --        
--                                    --
--          Alexander Riske           --  
--          am 11.03.2008             --
----------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY top_sheet_xilinx_mobile IS
PORT( 
      push_button   : IN     std_logic;
      schmitt_in    : IN     std_logic;
      a             : OUT    std_logic;
      b             : OUT    std_logic;
      c             : OUT    std_logic;
      d             : OUT    std_logic;
      e             : OUT    std_logic;
      f             : OUT    std_logic;
      g             : OUT    std_logic;
      schmitt_out   : OUT    std_logic;
      speaker       : OUT    std_logic;
      speaker_not   : OUT    std_logic;
      time_out      : OUT    std_logic
   );
END ENTITY top_sheet_xilinx_mobile;


ARCHITECTURE behave OF top_sheet_xilinx_mobile IS

   -- Declaration der internen signale 
   SIGNAL a_f_sig, b_e_sig, c_d_sig, g_sig, time_out_sig, clk, push_button_sig, speaker_sig, reset_n: std_ulogic;
   Type state is (st_0, st_1, st_2, st_3, st_4, st_5, st_6, st_7);
   Signal mode, nxt_mode : state;

   COMPONENT top_dice
   PORT (
      clk           : IN     std_ulogic;
      enable        : IN     std_ulogic;
      melody_enable : IN     std_ulogic;
      melody_select : IN     std_ulogic;
      push_button   : IN     std_ulogic;
      reset_n       : IN     std_ulogic;
      tick_enable   : IN     std_ulogic;
      a_f           : OUT    std_ulogic;
      b_e           : OUT    std_ulogic;
      c_d           : OUT    std_ulogic;
      g             : OUT    std_ulogic;
      speaker       : OUT    std_ulogic;
      time_out      : OUT    std_ulogic
   );
   END COMPONENT;




BEGIN
  
  --Def. der INPUT's
   clk <= not schmitt_in;
   push_button_sig <= not push_button;
--   reset_n <= '1';
   
   --Def. der OUTPUT's
   schmitt_out <= clk;
   a <= not a_f_sig;
   f <= not a_f_sig;
   b <= not b_e_sig;
   e <= not b_e_sig;
   c <= not c_d_sig;
   d <= not c_d_sig;
   g <= not g_sig;
   

   
   --Sleepmodus
   time_out_proc:PROCESS (clk)
   BEGIN
     --IF (reset_n ='0' OR push_button_sig = '1') THEN
       --time_out <= '0';
     IF(RISING_EDGE(clk)) THEN
       speaker_not <= not speaker_sig;
       speaker <= speaker_sig;
       mode <= nxt_mode;
       if time_out_sig = '1' then
         time_out <= '1';
       ELSIF (reset_n ='0' OR push_button_sig = '1') THEN
          time_out <= '0';
       end if;
     END IF;
   END PROCESS;
   
   div_proc: Process(mode)
   BEGIN  
     CASE mode is
     When st_0 =>
       nxt_mode <= st_1;
     when st_1 =>
       nxt_mode <= st_2;
     When st_2 =>
       nxt_mode <= st_3;
     when st_3 =>
       nxt_mode <= st_4;
     When st_4 =>
       nxt_mode <= st_5;
     when st_5 =>
       nxt_mode <= st_6;
     When st_6 =>
       nxt_mode <= st_7;
     when st_7 =>
         nxt_mode <= st_7;
     when others =>
       nxt_mode <= st_0;
     end case;
   end process;
  
   
   out_proc: Process (mode)
   BEGIN
     if mode = st_0 then
       reset_n <= '0';
     elsif mode = st_1 then
       reset_n <= '0';
     elsif mode = st_2 then
       reset_n <= '0';
     elsif mode = st_3 then
       reset_n <= '0';
     elsif mode = st_4 then
       reset_n <= '0';
     elsif mode = st_5 then
       reset_n <= '0';
     elsif mode = st_6 then
       reset_n <= '0';
     else
       reset_n <= '1';     
     end if;
   end process;
       
 
   
   -- Portmapping
   U_0 : top_dice
      PORT MAP (
         reset_n       => reset_n,
         clk           => clk,
         push_button   => push_button_sig,
         enable        => '1',
         tick_enable   => '1',
         melody_enable => '1',
         melody_select => '1',
         g             => g_sig,
         c_d           => c_d_sig,
         b_e           => b_e_sig,
         a_f           => a_f_sig,
         time_out      => time_out_sig,
         speaker       => speaker_sig
      );

END;


