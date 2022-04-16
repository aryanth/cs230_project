library ieee;
use ieee.std_logic_1164.all;


entity adder_sixteen is
	port(a,b: in std_logic_vector(15 downto 0);
	     cin : in std_logic;
		  sum: out std_logic_vector(15 downto 0); 
		  cout: out std_logic);
end entity;


architecture adder_sixteen_arc of adder_sixteen is

	signal carry: std_logic_vector(14 downto 0);
	
	component full_adder is
		port (a,b,cin: in std_logic;
				sum, cout: out std_logic);
	end component;
	
begin
	Add_Inst1: full_adder
		port map (a => a(0),b => b(0),cin => '0',sum => sum(0), cout => carry(0));
		
		
	Add_Inst2: full_adder
		port map (a => a(1), b => b(1), cin => carry(0), sum => sum(1), cout => carry(1));
		
		
	Add_Inst3: full_adder
		port map (a => a(2), b => b(2), cin => carry(1), sum => sum(2), cout => carry(2));
		
		
	Add_Inst4: full_adder
		port map (a => a(3), b => b(3), cin => carry(2), sum => sum(3), cout => carry(3));
		
		
	Add_Inst5: full_adder
		port map (a => a(4), b => b(4), cin => carry(3), sum => sum(4), cout => carry(4));
		
		
	Add_Inst6: full_adder
		port map (a => a(5), b => b(5), cin => carry(4), sum => sum(5), cout => carry(5));
		
		
	Add_Inst7: full_adder
		port map (a => a(6), b => b(6), cin => carry(5), sum => sum(6), cout => carry(6));
		
		
	Full_Add8: full_adder
		port map (a => a(7), b => b(7), cin => carry(6), sum => sum(7), cout => carry(7));
		
		
	Add_Inst9: full_adder
		port map (a => a(8), b => b(8), cin => carry(7), sum => sum(8), cout => carry(8));
		
		
	Add_Inst10: full_adder
		port map (a => a(9), b => a(9), cin => carry(8), sum => sum(9), cout => carry(9));
		
		
	Add_Inst11: full_adder
		port map (a => a(10), b => b(10), cin => carry(9), sum => sum(10), cout => carry(10));
		
		
	Add_Inst12: full_adder
		port map (a => a(11), b => b(11), cin => carry(10), sum => sum(11), cout => carry(11));
		
		
	Add_Inst13: full_adder
		port map (a => a(12), b => b(12), cin => carry(11), sum => sum(12), cout => carry(12));
		
		
	Add_Inst14: full_adder
		port map (a => a(13), b => b(13), cin => carry(12), sum => sum(13), cout => carry(13));
		
		
	Add_Inst15: full_adder
		port map (a => a(14), b => b(14), cin => carry(13), sum => sum(14), cout => carry(14));
		
		
	Add_Inst16: full_adder
		port map (a => a(15), b => b(15), cin => carry(14), sum => sum(15), cout => cout);
		
		
end architecture;