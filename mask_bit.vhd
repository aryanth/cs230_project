library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity mask_bit is
	port(X: in std_logic_vector(15 downto 0);
			M: in std_logic_vector(15 downto 0);
			Y: out std_logic_vector(15 downto 0));
end entity;

architecture mask_bit_arc of mask_bit is
	signal mask_value : integer;
begin

	mask_value <= to_integer(unsigned(M));
	Y <= "0000000000000000";
	Y(mask_value) <= '1'; -- may not work cuz concurrent

	
	
end architecture;