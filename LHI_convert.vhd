
library ieee;
use ieee.std_logic_1164.all;

entity LHI_convert is

	port (a: in std_logic_vector(8 downto 0);
	b: out std_logic_vector(15 downto 0));
	
end entity LHI_convert;

architecture LHI_convert_arc of LHI_convert is

begin

	b(15) <= a(8);
	b(14) <= a(7);
	b(13) <= a(6);
	b(12) <= a(5);
	b(11) <= a(4);
	b(10) <= a(3);
	b(9) <= a(2);
	b(8) <= a(1);
	b(7) <= a(0);
	b(6) <= '0';
	b(5) <= '0';
	b(4) <= '0';
	b(3) <= '0';
	b(2) <= '0';
	b(1) <= '0';
	b(0) <= '0';
	
end architecture;