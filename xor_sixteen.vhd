library ieee;
use ieee.std_logic_1164.all;
--library work;


entity xor_sixteen is
	port(a,b: in std_logic_vector(15 downto 0);
	     cout: out std_logic;
		  result: out std_logic_vector(15 downto 0));
end entity;


architecture xor_sixteen_arc of xor_sixteen is
begin

	result <= a xor b;
	cout <= '0';
	
end architecture;