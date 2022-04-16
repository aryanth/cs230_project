library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity memory is 
	port (wr_en,rd_en,clk: in std_logic; 
			Addr_in, D_in: in std_logic_vector(15 downto 0);
			D_out: out std_logic_vector(15 downto 0)); 
end entity; 


architecture memory_arc of memory is 

	type registerFile is array(65535 downto 0) of std_logic_vector(15 downto 0);
	
	signal mem_reg: registerFile:=(0 => x"50D0", 1 => x"52D1", 2 => x"1050" , 16 => x"0005" ,17  => x"000A" , others => x"0000");
	
	begin 
	
	  process(wr_en,rd_en,Addr_in,D_in,mem_reg,clk)
	   begin

		if (rd_en = '1') then
			 D_out <= mem_reg(to_integer(unsigned(Addr_in)));
		elsif (rd_en = '0') then
		  	 D_out <= "1111111111111111";
		end if;

		if (wr_en = '1') then
		  if(falling_edge(clk)) then
			mem_reg(to_integer(unsigned(Addr_in))) <= D_in;
		  end if;
		end if;
		
	end process;	
end architecture;