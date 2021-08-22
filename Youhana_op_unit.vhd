library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.Numeric_std.all;
entity Youhana_op_unit is
	generic (N: integer := 32);
	port (
	Youhana_data_in1: in std_logic_vector (N-1 downto 0); 
	Youhana_data_in2: in std_logic_vector (N-1 downto 0); 
	Youhana_op_code: in std_logic_vector ( 2 downto 0); 
	Youhana_output : out std_logic_vector (N-1 downto 0);
	Youhana_flags: out std_logic_vector (2 downto 0) 	
	);
	end Youhana_op_unit;

architecture arch3 of Youhana_op_unit is 
	signal Youhana_result : std_logic_vector (N-1 downto 0) := x"00000000";
	signal Youhana_overflow : std_logic_vector ( 5 downto 0);
	begin
	P1: process(Youhana_data_in1, Youhana_data_in2, Youhana_op_code, Youhana_result)
		begin 
		-- oepration code for each instruction 
			 case Youhana_op_code is 
			 when "000" => Youhana_result <= std_logic_vector(signed(Youhana_data_in1) + signed(Youhana_data_in2)); --add
			 when "001" => Youhana_result <= std_logic_vector(unsigned(Youhana_data_in1) + unsigned(Youhana_data_in2)); --addu
			 when "010" => Youhana_result <= std_logic_vector(signed(Youhana_data_in1) - signed(Youhana_data_in2)); --sub
			 when "011" => Youhana_result <= std_logic_vector(unsigned(Youhana_data_in1) - unsigned(Youhana_data_in2)); --subu
			 when "100" => Youhana_result <= Youhana_data_in1 and Youhana_data_in2; --and
			 when "101" => Youhana_result <= Youhana_data_in1 nor Youhana_data_in2; --nor
			 when "110" => Youhana_result <= Youhana_data_in1 or Youhana_data_in2; --or
			 when others => Youhana_result <= x"00000000";
			 end case;
	--Overflow flag input 
	Youhana_overflow <= Youhana_data_in1(N-1) & Youhana_op_code & Youhana_data_in2(N-1) & Youhana_result(N-1);
	-- output from result vectore
	Youhana_output <= Youhana_result(N-1 downto 0);
	end process P1;
	
	P2: process(Youhana_op_code, Youhana_result, Youhana_overflow)
		variable Youhana_Z: std_logic; -- for zero flag updating
		begin
		
		Youhana_flags <= "000";
		if (Youhana_op_code = "000" or Youhana_op_code = "010") then 
		case Youhana_overflow is 
		--using table 3.2 from the textbook we can get the overflow cases
		when "000001" => Youhana_flags(2) <= '1'; 
		when "100010" => Youhana_flags(2) <= '1';
		when "001011" => Youhana_flags(2) <= '1'; 
		when "101000" => Youhana_flags(2) <= '1'; 
		when others => Youhana_flags(2) <= '0'; 
	end case;
else Youhana_flags(2) <= '0';
end if;
-- Negative flag for add and sub operations
if(Youhana_op_code = "000" or Youhana_op_code = "001" or
	Youhana_op_code= "010" or Youhana_op_code = "011") then 
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
	end arch3;
		
		