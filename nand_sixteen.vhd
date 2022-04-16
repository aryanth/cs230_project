library ieee;
use ieee.std_logic_1164.all;
--library work; dunno how this is useful yet


entity nand_sixteen is
	port(a,b: in std_logic_vector(15 downto 0);
			cout: out std_logic;
			result: out std_logic_vector(15 downto 0));
end entity;


architecture nand_sixteen_arc of nand_sixteen is
begin

	result <= a nand b;
	cout <= '0';
	
end architecture;