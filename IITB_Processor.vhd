library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity IITB_Processor is
  port (clk,rst  : in  std_logic);
end entity;

architecture IITB_Processor_arc of IITB_Processor is

---------------------------------------components------------------------------------------------------------

------ possible fix : the previous state sets up the permissions and for stuff that needs instant returns break up  the states
component ALU is 
	port( alu_A,alu_B : in std_logic_vector(15 downto 0);
		   operation : in std_logic_vector(1 downto 0);
		   cout, zout: out std_logic;
		   alu_C : out std_logic_vector(15 downto 0));
end component ALU;

component LHI_convert is
	port (a: in std_logic_vector(8 downto 0);
	      b: out std_logic_vector(15 downto 0));
end component;

component se_seven is
	port (a: in std_logic_vector(8 downto 0);
	      b: out std_logic_vector(15 downto 0));
end component;

component se_ten is
	port (a: in std_logic_vector(5 downto 0);
	      b: out std_logic_vector(15 downto 0));
end component;

component memory is 
	port (wr_en,rd_en,clk: in std_logic; 
			Addr_in, D_in: in std_logic_vector(15 downto 0);
			D_out: out std_logic_vector(15 downto 0)); 
end component; 

component Register_File is 
	port( A1,A2,A3 : in std_logic_vector(2 downto 0);
		   D3: in std_logic_vector(15 downto 0);
		   clk,wr,reset: in std_logic ; 
		   D1, D2: out std_logic_vector(15 downto 0));
end component;

component left_shift is
	port(a: in std_logic_vector(15 downto 0);
			b: out std_logic_vector(15 downto 0));
end component;


type FSM is (Sreset, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, Spc);
signal state: FSM;
signal t1, t2, t3, t4, ir, se7_out, se10_out, lhi_out, mem_address, mem_data_in, mem_data_out, alu_x, alu_y, alu_out, RF_D3, RF_D1, RF_D2 :std_logic_vector(15 downto 0):="0000000000000000";
signal mem_rd, mem_wr, zero_out, carry_out, RF_rst, carry, zero, RF_wr :std_logic:='0';
signal alu_op :std_logic_vector(1 downto 0);
signal se7_in : std_logic_vector(8 downto 0);
signal lhi_in : std_logic_vector(8 downto 0);
signal se10_in : std_logic_vector(5 downto 0);
signal RF_A1, RF_A2, RF_A3: std_logic_vector(2 downto 0);
signal op_code : std_logic_vector(3 downto 0);
signal pc: std_logic_vector(15 downto 0):="0000000000000000";
signal left_shift_in : std_logic_vector(15 downto 0);
signal left_shift_out : std_logic_vector(15 downto 0);
begin

	SE_7 : se_seven 
		port map (se7_in,se7_out);
		
	SE_10 : se_ten
		port map (se10_in, se10_out);
		
	LHI : LHI_convert
		port map (lhi_in, lhi_out);
		
	RF : Register_File 
		port map (RF_A1, RF_A2, RF_A3, RF_D3, clk, RF_wr, RF_rst, RF_D1, RF_D2);
		
	ALUnit : ALU
		port map (alu_x, alu_y, alu_op, carry_out, zero_out, alu_out);
		
	MEM : memory 
		port map (mem_wr, mem_rd,clk, mem_address, mem_data_in, mem_data_out);
		
	LS : left_shift
		port map(left_shift_in,left_shift_out);


process(clk,state)	
     variable next_state : FSM;
	  variable t1_v, t2_v, t3_v, t4_v, ir_v, next_pc: std_logic_vector(15 downto 0);
	  variable z, car : std_logic;
	  variable op_v : std_logic_vector(3 downto 0);
	  variable mask_value : integer;
	  
begin
	   next_state := state;
		t1_v := t1; t2_v := t2; t3_v := t3; t4_v :=t4; ir_v :=ir; op_v := op_code;
		z := zero; car := carry;
		next_pc := pc;
		
		
	case state is
	
		when Sreset => --	Reset State
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '0';
			RF_rst <= '1';
			z := '0';
			car :='0';
			t1_v := "0000000000000000";
			t2_v := "0000000000000000";
			t3_v := "0000000000000000";
			ir_v := "0000000000000000";
			next_state := S0;
			


		when S0 => -- State S0
			mem_wr <= '0';
		   mem_rd <= '1';
			RF_wr <= '0';
			RF_rst <='0';
         t1_v := "0000000000000000";
         t2_v := "0000000000000000";
         t3_v := "0000000000000000";
			mem_address <= next_pc;
			ir_v := mem_data_out; -- reading the old value only logical
			op_v := ir_v(15 downto 12);
			 case (op_v) is
			 
			   when "0101" =>
				  next_state := S8;
				when "0111" =>
				  next_state := S8; 
				when "0000" =>
				  next_state := S4;
				when "0010" =>
				  next_state := S1;
				when "0001" =>
				  next_state := S1;
				when "1000" =>
				  next_state := S1;
				when "0011" =>
				  next_state := S6;
				when "1101" =>
				  next_state := S11;
				when "1001" =>
				  next_state := S18;
				when "1010" =>
				  next_state := S18;
				when "1011" =>
				  next_state := S21;
				
			   when others => null;
          end case; 			 
			 
	

		when S1 => --State S1
			mem_wr <= '0';
		   mem_rd <= '0';
			RF_wr <= '0';
		   RF_A1 <= ir_v(11 downto 9);
		   RF_A2 <= ir_v(8 downto 6);
			t1_v := RF_D1;
			t2_v := RF_D2;
			if(op_v = "0001") then
				if(ir_v(1 downto 0) = "11") then
					next_state := S23; -- corresponding to ADL
				end if;
			end if;
			next_state := S2;
			


		when S2 => --State S2
			mem_wr <= '0';
		   mem_rd <= '0';
			RF_wr <= '0';
			
		   alu_x <= t1_v;
			alu_y <= t2_v;
			
			if(op_v="1000") then
				alu_op <= "10";
			elsif(op_v="0010") then
				alu_op <= "01";
			else  
				alu_op <= "00";
			end if;
			
			t3_v := alu_out;
			
			case (op_v) is
				when "0010" =>
				next_state := S3;
			   when "0000" =>
				next_state := S5;
				when "0001" =>
				next_state := S3;
				when "0101" =>
				next_state := S9;
				when "0111" =>
				next_state := S10;
				when "1000" =>
					if(zero_out = '1') then
						next_state := S17;
					else
						next_state := Spc;
					end if;
			   when others => null;
         end case; 

	 
		when S3 => --State S3
			mem_wr <= '0';
		   mem_rd <= '0';
			RF_wr <= '1';

			if(ir_v(1 downto 0)="00") then
				RF_D3 <= t3_v;
				RF_A3 <= ir_v(5 downto 3);

				if(op_v="0000" or op_v="0001" or op_v="0010" or op_v="0101") then
					z := zero_out;
				end if;

				if(op_v="0000" or op_v="0001") then
				  	car := carry_out;
				end if;

			elsif(ir_v(1 downto 0)="10" and car='1') then
				RF_D3 <= t3_v;
				RF_A3 <= ir_v(5 downto 3);
				if(op_v="0000" or op_v="0001" or op_v="0010" or op_v="0101") then
				  	z :=zero_out;
				end if;
				if(op_v="0000" or op_v="0001") then
				  	car:=carry_out;
				end if;

          elsif(ir_v(1 downto 0)="01" and z='1') then
				RF_D3 <= t3_v;
				RF_A3 <= ir_v(5 downto 3);
				if(op_v="0000" or op_v="0001" or op_v="0010" or op_v="0101") then
				  	z := zero_out;
				end if;
				if(op_v="0000" or op_v="0001") then
				  	car:=carry_out;
				end if;
				
		   end if;
			
         next_state := Spc;
			


		when S4 => --State S4
			mem_wr <= '0';
		   mem_rd <= '0';
		   RF_wr <= '0';
		   RF_A1 <= ir_v(11 downto 9);
		   t1_v := RF_D1;
		   se10_in <= ir_v(5 downto 0);
		   t2_v := se10_out;
		   next_state := S2;
			
	
	
		when S5 => --State S5
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '1';
			
		   if(op_v="0000" or op_v="0001" or op_v="0010" or op_v="0101") then
				z :=zero_out;
		   end if;
			
		   if(op_v="0000" or op_v="0001") then
				car:=carry_out;
		   end if;
			
			RF_D3 <= t3_v;
			RF_A3 <= ir_v(8 downto 6);
			
			next_state := Spc;
				

			
		when S6 => --State S6
			mem_wr <= '0';
		   mem_rd <= '0';
			RF_wr <= '0';
			lhi_in <= ir_v(8 downto 0);
			t1_v := lhi_out;
			next_state := S7;
				


		when S7 => --State S7
			mem_wr <= '0';
		   mem_rd <= '0';
			RF_wr <= '1';
			RF_D3 <= t1_v;
			RF_A3 <= ir_v(11 downto 9);
         next_state := Spc;
					 


		when S8 => --State S8
			mem_wr <= '0';
		   mem_rd <= '0';
			RF_wr <= '0';
		   RF_A1 <= ir_v(8 downto 6);
			t1_v := RF_D1;
			se10_in <= ir_v(5 downto 0);
			t2_v := se10_out;
			next_state :=S2;
			  


       when S9 => --State S9
			mem_wr <= '0';
			mem_rd <='1';
			RF_wr <= '1';
			if(op_v="0000" or op_v="0001" or op_v="0010" or op_v="0101") then
				z :=zero_out;
			end if;
			if(op_v="0000" or op_v="0001") then
				car:=carry_out;
			end if;
			mem_address <= t3_v;
			t1_v := mem_data_out;
			RF_D3 <= t1_v;
			RF_A3 <= ir_v(11 downto 9);
         next_state :=Spc;
				


		when S10 => --State S10
			mem_wr <= '1';
		   mem_rd <= '0';
			RF_wr <= '0';
		   RF_A1 <= ir_v(11 downto 9);
			t2_v := RF_D1;
	      mem_address <= t3_v;
	      mem_data_in <= t2_v;
	      next_state := Spc;
				 


		when S11 => --State S11
			--mem_wr <= '0';
		   --mem_rd <= '0';
			RF_wr <= '0';
		   RF_A1 <= ir_v(11 downto 9);
		   t1_v := RF_D1;
			t2_v := "0000000000000000";
			se7_in <= ir_v(8 downto 0);
			t4_v := se7_out;
			mask_value := to_integer(unsigned(t2_v)); -- the bit at which we are checking presence of a 1 in t1_v
			if(t4_v(mask_value) = '1') then
				if(op_v = "1101") then
					mem_rd <= '1';
					mem_wr <= '0';
					next_state := S12;
				else
					mem_wr <= '1';
					mem_rd <= '0';
					next_state := S15;
				end if;
			else 
				if(op_v = "1101") then
					mem_rd <= '0';
					mem_wr <= '0';
					next_state := S12;
				else
					mem_wr <= '0';
					mem_rd <= '0';
					next_state := S15;
				end if;
			end if;
			
			
		when S12 => --State S12
			mem_wr <= '0';
		   --mem_rd <= '1'; commented out since the masking in S24 decides whether to read or not
			RF_wr <= '0';
			mem_address <= t1_v;
			t3_v := mem_data_out;
			next_state := S13;
			  


		when S13 => --State S13
			RF_wr <= '1';
			RF_A3<=t2_v(2 downto 0);
			RF_D3<=t3_v;
			alu_x <= t2_v;
			alu_y <= "0000000000000001";
			alu_op <= "00";
			t2_v := alu_out;
			next_state := S14;
				


		when S14 => --State S14
			alu_x <= t1_v;
			alu_y <= "0000000000000001";
			alu_op <= "00";
			t1_v := alu_out;
			
			if(to_integer(unsigned(t2_v)) < 8) then
				if(op_v="1101") then
					next_state :=S12;
				else
				   next_state :=S15;
				end if;
			else
				next_state :=Spc;
			end if;
				
	
		  
		when S15 => --State S15
			--mem_wr <= '1'; commenting out since the mask part should decide whether to write or not
			mem_rd <= '0';
			RF_wr <= '0';
			RF_A2 <= t2_v(2 downto 0);
			t3_v := RF_D2;
			mem_address <= t1_v;
			mem_data_in <= t3_v;
			next_state := S16;
				


		when S16 => --State S16
			alu_x <= t2_v;
			alu_y <= "0000000000000001";
			alu_op <="00";
			t2_v := alu_out;
			next_state := S14;
				


		when S17 => --State S17
			alu_x <= pc;
			se10_in <= ir_v(5 downto 0);
			alu_y <= se10_out;
			alu_op <= "00";
			next_pc := alu_out;
			next_state := S0;
			
	
	
		when S18 => --State S18
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '1';
			RF_D3 <= pc;
			RF_A3 <= ir_v(11 downto 9);
			if(op_v="1001") then
			  next_state := S19;
			else 
			  next_state := S20;
			end if;
				


		when S19 => --State S19
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '0';
			alu_x <= next_pc;
			se7_in <= ir_v(8 downto 0);
			alu_y <= se7_out;
			alu_op <= "00";
			next_pc := alu_out;
			next_state := S0;
				


		when S20 => --State S20
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '0';
			RF_A1 <= ir_v(8 downto 6);
			next_pc := RF_D1;
			next_state := S0;
			
		when S21 =>
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '1';
			RF_A1 <= ir_v(11 downto 9);
			t1_v := RF_D1;
			se7_in <= ir_v(8 downto 0);
			t2_v := se7_out;
			next_state := S22;
		
		when S22 =>
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '0';
			alu_x <= t1_v;
			alu_y <= t2_v;
			alu_op <= "00"; -- addition
			next_pc := alu_out;
			
		when S23 =>
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '0';
			left_shift_in <= t2_v;
			t2_v := left_shift_out; -- may have to dirctly funnel into alu_B here
			next_state := S2;

		when Spc => --Pc update state
			mem_wr <= '0';
			mem_rd <= '0';
			RF_wr <= '0';
			alu_x <= pc;
			alu_y <= "0000000000000001";
			alu_op <= "00";
			next_pc := alu_out;
			next_state := S0;
			

		
		when others => null;
  end case;		
  
 if(clk'event and clk = '0') then
          if(rst = '1') then
             state <= Sreset;
          else
             state <= next_state;
				 t1 <= t1_v; 
				 t2 <= t2_v;
				 t3 <= t3_v;
				 t4 <= t4_v;
				 zero <= z;
				 carry <= car;
				 ir <= ir_v;
				 op_code <= op_v;
				 pc <= next_pc;
          end if;
     end if;
end process;

end architecture;