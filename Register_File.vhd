library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


---------  NOT CHANGED MUCH YET  ---------------------------------------------------------------

entity Register_File is 
	port( A1,A2,A3 : in std_logic_vector(2 downto 0);
		   D3: in std_logic_vector(15 downto 0);
		   clk,wr,reset: in std_logic ; 
		   D1, D2: out std_logic_vector(15 downto 0));
end entity;

architecture Register_File_arc of Register_File is 
 
type register_array is array(0 to 7) of std_logic_vector(15 downto 0);

signal registers: register_array := (others => (others => '0'));

begin 

--	D1 <= registers(to_integer(unsigned(A1)));
--	D2 <= registers(to_integer(unsigned(A2)));
	process (clk)

	begin 
		if((clk'event and clk = '0')) then
			if (reset = '1') then
				for i in 0 to 7 loop
					registers(i) <= "0000000000000000";
				end loop;
			else
             if (wr = '1') then
					registers(to_integer(unsigned(A3))) <= D3;
				 end if;
		   end if;
		end if;
		
	end process;

process (A1, A2)
begin
	D1 <= registers(to_integer(unsigned(A1)));
	D2 <= registers(to_integer(unsigned(A2)));
end process;
	
end architecture;
