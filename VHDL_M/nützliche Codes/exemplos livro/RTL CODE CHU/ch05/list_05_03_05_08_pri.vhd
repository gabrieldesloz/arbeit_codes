--=============================
-- Listing 5.3
--=============================
architecture if_arch of prio_encoder42 is
begin
   process(r)
   begin
      if (r(3)='1') then
         code <= "11";
      elsif (r(2)='1')then
         code <= "10";
      elsif (r(1)='1')then
         code <= "01";
      else
         code <= "00";
      end if;
   end process;
   active <= r(3) or r(2) or r(1) or r(0);
end if_arch;


--=============================
-- Listing 5.5
--=============================
architecture cascade_if_arch of prio_encoder42 is
begin
   process(r)
   begin
      code <="00";
      if (r(1)='1') then
         code <= "01";
      end if;
      if (r(2)='1') then
         code <= "10";
      end if;
      if (r(3)='1') then
         code <= "11";
      end if;
   end process;
   active <= r(3) or r(2) or r(1) or r(0);
end cascade_if_arch;


--=============================
-- Listing 5.8
--=============================
architecture case_arch of prio_encoder42 is
begin
   process(r)
   begin
      case r is
         when "1000"|"1001"|"1010"|"1011"|
              "1100"|"1101"|"1110"|"1111" =>
            code <= "11";
         when "0100"|"0101"|"0110"|"0111" =>
            code <= "10";
         when "0010"|"0011" =>
            code <= "01";
         when others =>
            code <= "00";
      end case;
   end process;
   active <= r(3) or r(2) or r(1) or r(0);
end case_arch;
