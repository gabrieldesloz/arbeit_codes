--=============================
-- Listing 5.1
--=============================
architecture if_arch of mux4 is
begin
   process(a,b,c,d,s)
   begin
      if (s="00") then
         x <= a;
      elsif (s="01")then
         x <= b;
      elsif (s="10")then
         x <= c;
      else
         x <= d;
      end if;
   end process;
end if_arch;

--=============================
-- Listing 5.6
--=============================
architecture case_arch of mux4 is
begin
   process(a,b,c,d,s)
   begin
      case s is
         when "00" =>
            x <= a;
         when "01" =>
             x <= b;
         when "10" =>
             x <= c;
         when others =>
             x <= d;
      end case;
   end process;
end case_arch;
