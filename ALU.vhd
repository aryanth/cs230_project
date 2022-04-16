library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;


entity ALU is 

	port( alu_A,alu_B : in std_logic_vector(15 downto 0);
		   operation : in std_logic_vector(1 downto 0);
		   cout, zout: out std_logic;
		   alu_C : out std_logic_vector(15 downto 0));
			
end entity;


architecture ALU_arc of ALU is

	signal temp1,temp2,temp3,temp4: std_logic_vector(15 downto 0); --temporary value storers
	signal carry1, carry2, carry3 : std_logic; -- storing the carry here

	component adder_sixteen is -- comp of adder
		port(a,b: in std_logic_vector(15 downto 0);
			  cin : in std_logic;
		     sum: out std_logic_vector(15 downto 0); 
		     cout: out std_logic);
	end component;

	component nand_sixteen is -- comp of nand
		port(a,b: in std_logic_vector(15 downto 0);
		     cout: out std_logic;
		     result: out std_logic_vector(15 downto 0));
	end component;
	
	component xor_sixteen is -- comp of xor
		port(a,b: in std_logic_vector(15 downto 0);
		     cout: out std_logic;
		     result: out std_logic_vector(15 downto 0));
	end component;

begin

	Adder_Inst: adder_sixteen 
		port map (a => alu_A, b => alu_B, cin => '0', sum => temp1, cout => carry1);
		
	Nand_Inst: nand_sixteen 
		port map (a => alu_A, b => alu_B, cout => carry2, result => temp2);
		
	Xor_Inst: xor_sixteen 
		port map (a => alu_A, b => alu_B, cout => carry3, result => temp3);

	process (operation, temp1, temp2, temp3, temp4, carry1, carry2)
	begin
	
		if (operation = "00") then
			temp4 <= temp1; -- ADD
			cout <= carry1;

		elsif (operation = "01") then
			temp4 <= temp2; -- NAND
			cout <= carry2;
			
		elsif (operation = "10") then
			temp4 <= temp3; -- XOR
			cout <= carry3;
			
	   end if;
		
		----------- DUNNO WHY ------------------------------------------------
		zout <= not (temp4(0) or temp4(1) or temp4(2) or temp4(3) or temp4(4) or temp4(5) or temp4(6) or temp4(7) or temp4(8) or temp4(9) or temp4(10) or temp4(11) or temp4(12) or temp4(13) or temp4(14) or temp4(15));
		alu_C <= temp4;
		
	end process;

end architecture;