library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

-- modulo que controla o acesso a memoria front end, conforme requisições internas e externas

entity fe_mux_control is
	
	port(		
		extevent_flag,exttype: in std_logic; -- requisições
		s_bgnd_floor, s_illum_floor, extfloor: in std_logic; -- tem informação de floor		
		extpart : in std_logic_vector(1 downto 0);
		ad1, ad2: out std_logic_vector(1 downto 0);
		ad3, ad4: out std_logic;
		dt1, dt2, dt3, dt3: out std_logic
	); 

end entity fe_mux_control;

architecture ARQ of fe_mux_control is

begin


-- front end memory mux process -----------------
   process (extevent_flag,exttype,extpart,s_bgnd_floor, s_illum_floor,extfloor)
	begin
	      -- requisição externa do uC
		  if extevent_flag='0' then -- uC --> extevent --> extevent_req (flag) -- extevent_flag
			     -- tem info de floor para o backg ou illumination (fron rear) ???
				 if (s_bgnd_floor='1') or (s_illum_floor='1') then
				     ad1<="01"; ad2<="01"; ad3<='0'; ad4<='0'; dt1<='0'; dt2<='0'; dt3<='0'; dt4<='0'; 
				  else
				     -- default
				     ad1<="00"; ad2<="00"; ad3<='0'; ad4<='0'; dt1<='0'; dt2<='0'; dt3<='0'; dt4<='0'; 
				  end if;
	     else
			     if exttype='0' then --- uC reading ???
				     ad1<="00"; ad2<="00"; dt1<='0'; dt2<='0'; dt3<='0'; dt4<='0'; 
					 -- 00:cam_A front, 01: cam_A rear, 10:cam_B front, 11:cam_B rear
					  if extpart(1)='0' then ad3<='1'; ad4<='0'; else ad3<='0'; ad4<='1'; end if;
				  else --- uC writing
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
	
end ARQ;