--=============================
-- Listing 5.4
--=============================
architecture if_arch of simple_alu is
   signal src0s, src1s: signed(7 downto 0);
begin
   src0s <= signed(src0);
   src1s <= signed(src1);
   process(ctrl,src0,src1,src0s,src1s)
   begin
     if (ctrl(2)='0') then
        result <= std_logic_vector(src0s + 1);
     elsif (ctrl(1 downto 0)="00")then
        result <=  std_logic_vector(src0s + src1s);
     elsif (ctrl(1 downto 0)="01")then
        result <= std_logic_vector(src0s - src1s);
     elsif (ctrl(1 downto 0)="10")then
        result <= src0 and src1 ;
     else
        result <= src0 or src1;
     end if;
   end process;
end if_arch;


--=============================
-- Listing 5.9
--=============================
architecture case_arch of simple_alu is
   signal src0s, src1s: signed(7 downto 0);
begin
   src0s <= signed(src0);
   src1s <= signed(src1);
   process(ctrl,src0,src1,src0s,src1s)
   begin
      case ctrl is
         when "000"|"001"|"010"|"011" =>
            result <=  std_logic_vector(src0s + 1);
         when "100" =>
            result <=  std_logic_vector(src0s + src1s);
         when "101" =>
            result <= std_logic_vector(src0s - src1s);
         when "110" =>
            result <= src0 and src1;
         when others =>    -- "111"
            result <= src0 or src1;
      end case;
   end process;
end case_arch ;
