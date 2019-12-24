--=============================
-- Listing 13.8 configuration
--=============================
configuration count_down_config of hundred_counter is
   for vhdl_87_arch
      for one_digit: dec_counter
         use entity work.dec_counter(down_arch);
      end for;
      for ten_digit: dec_counter
         use entity work.dec_counter(down_arch);
      end for;
   end for;
end;