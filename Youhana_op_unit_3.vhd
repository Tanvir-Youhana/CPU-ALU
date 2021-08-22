library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.Numeric_std.all;
entity Youhana_op_unit_3 is
	generic (N: integer := 32);
	port (
Youhana_data_in1: in std_logic_vector (N-1 downto 0); 
	Youhana_data_in2: in std_logic_vector (N-1 downto 0); 
	Youhana_16_imm: in std_logic_vector(15 downto 0);
	Youhana_ex: in std_logic_vector (N-1 downto 0);
	Youhana_op_code: in std_logic_vector ( 3 downto 0); 
	Youhana_wren_mar: out std_logic;
	Youhana_wren_mdr: out std_logic;
	Youhana_RT_out: out std_logic_vector(N-1 downto 0); 
	Youhana_output : out std_logic_vector (N-1 downto 0);
	Youhana_flags: out std_logic_vector (2 downto 0)
	);
	end Youhana_op_unit_3;

architecture arch8 of Youhana_op_unit_3 is 
	signal Youhana_result : std_logic_vector (N-1 downto 0) := x"00000000";
	signal Youhana_overflow : std_logic_vector ( 6 downto 0);
	signal Youhana_wrenmar: std_logic;
	signal Youhana_wrenmdr : std_logic;
	begin
	P1: process(Youhana_data_in1, Youhana_data_in2, Youhana_op_code, Youhana_result,Youhana_ex,Youhana_wrenmar,Youhana_wrenmdr)
		begin 
		-- oepration code for each instruction 
			 case Youhana_op_code is 
			 when "0000" => Youhana_result <= std_logic_vector(signed(Youhana_data_in1) + signed(Youhana_data_in2)); --add-
			 when "0001" => Youhana_result <= std_logic_vector(unsigned(Youhana_data_in1) + unsigned(Youhana_data_in2)); --addu-
			 when "0010" => Youhana_result <= std_logic_vector(unsigned(Youhana_data_in1) + unsigned(Youhana_ex)); --addiu-
			 when "0011" => Youhana_result <= std_logic_vector(signed(Youhana_data_in1) + signed(Youhana_ex)); --addi-
			 when "0100" => Youhana_result <= std_logic_vector(signed(Youhana_data_in1) + signed(Youhana_data_in2)); --sub-
			 when "0101" => Youhana_result <= std_logic_vector(unsigned(Youhana_data_in1) + unsigned(Youhana_data_in2)); --subu-
			 when "0110" => Youhana_result <= Youhana_data_in1 and Youhana_data_in2; --and-
			 when "0111" => Youhana_result <= Youhana_data_in1 and Youhana_ex; --andi-
			 when "1000" => Youhana_result <= Youhana_data_in1 nor Youhana_data_in2; --nor-
			 when "1001" => Youhana_result <= Youhana_data_in1 or Youhana_data_in2; --or-
			 when "1010" => Youhana_result <= Youhana_data_in1 or Youhana_ex; --ori-
			 when "1011" => Youhana_Result <= Youhana_data_in1 + Youhana_ex;
									Youhana_wrenmar <= '1';
									Youhana_wrenmdr <= '1';
			 when "1111" => Youhana_result <= Youhana_data_in1+Youhana_ex;
									Youhana_wrenmar <= '1';
									Youhana_wrenmdr <= '1';
			 when others => Youhana_result <= x"00000000";
			 end case;
	if( Youhana_op_code= "0011" or Youhana_op_code= "0010" or Youhana_op_code= "0111" or Youhana_op_code= "1010") then 
	Youhana_RT_out <= Youhana_result(N-1 downto 0);
	else 
	Youhana_output <= Youhana_result(N-1 downto 0);
	end if;
	Youhana_wren_mar <= Youhana_wrenmar;
	Youhana_wren_mdr <= Youhana_wrenmar;
	--Overflow flag input 
	Youhana_overflow <= Youhana_data_in1(N-1) & Youhana_op_code & (Youhana_data_in2(N-1) or Youhana_ex(N-1)) & Youhana_result(N-1);
	-- output from result vector
	--Youhana_output <= Youhana_result(N-1 downto 0);
	end process P1;
	
	P2: process(Youhana_op_code, Youhana_result, Youhana_overflow)
		variable Youhana_Z: std_logic; -- for zero flag updating
		begin	
		Youhana_flags <= "000";
		if (Youhana_op_code = "0000" or Youhana_op_code = "0100" or Youhana_op_code= "0011") then 
		case Youhana_overflow is 
		--using table 3.2 from the textbook we can get the overflow cases
		when "0000001" => Youhana_flags(2) <= '1'; 
		when "1000010" => Youhana_flags(2) <= '1';
		when "0010011" => Youhana_flags(2) <= '1'; 
		when "1010000" => Youhana_flags(2) <= '1';
		when "0001101" => Youhana_flags(2) <= '1';
		when "1001110" => Youhana_flags(2) <= '1';
		when others => Youhana_flags(2) <= '0'; 
	end case;
else Youhana_flags(2) <= '0';
end if;
-- Negative flag for add and sub operations
if(Youhana_op_code = "0000" or Youhana_op_code = "0011" or
	Youhana_op_code= "0010" or Youhana_op_code = "0001"
	or Youhana_op_code= "0100" or Youhana_op_code= "0101")then 
	Youhana_flags(1) <= Youhana_result(N-1);

-- Zero flag
	Youhana_Z := '0';
	for i in 0 to (N-1) loop
		Youhana_Z := Youhana_Z or Youhana_result(i);
	end loop;
	Youhana_flags(0) <= not Youhana_Z;
	else Youhana_flags <= "000"; -- reset flags to 0
	end if;
	end process P2;
	end arch8;
		
		