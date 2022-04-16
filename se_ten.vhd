library ieee;
use ieee.std_logic_1164.all;


entity se_ten is
	port(a: in std_logic_vector(5 downto 0);
		  b: out std_logic_vector(15 downto 0));
end entity;


architecture se_ten_arc of se_ten is
begin

	b(0) <= a(0);
	b(1) <= a(1);
	b(2) <= a(2);
	b(3) <= a(3);
	b(4) <= a(4);
	b(5) <= a(5);
	b(6) <= a(5);
	b(7) <= a(5);
	b(8) <= a(5);
	b(9) <= a(5);
	b(10) <= a(5);
	b(11) <= a(5);
	b(12) <= a(5);
	b(13) <= a(5);
	b(14) <= a(5);
	b(15) <= a(5);
	
	
	
end architecture;