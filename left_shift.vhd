library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity left_shift is
	port(a: in std_logic_vector(15 downto 0);
			b: out std_logic_vector(15 downto 0));
end entity;

architecture left_shift_arc of left_shift is 
begin

	b(0) <= '0';
	b(1) <= a(0);
	b(2) <= a(1);
	b(3) <= a(2);
	b(4) <= a(3);
	b(5) <= a(4);
	b(6) <= a(5);
	b(7) <= a(6);
	b(8) <= a(7);
	b(9) <= a(8);
	b(10) <= a(9);
	b(11) <= a(10);
	b(12) <= a(11);
	b(13) <= a(12);
	b(14) <= a(13);
	b(15) <= a(14);
	
end architecture;