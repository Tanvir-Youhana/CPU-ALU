library IEEE;
use IEEE.std_logic_1164.all;

entity Youhana_32_bit_register is 
	generic(Youhana_N_bit: integer:=32);
	port( 
	Youhana_clk, Youhana_wren, Youhana_rden, 
	Youhana_chen: in std_logic;
	Youhana_data: in std_logic_vector (Youhana_N_bit-1 downto 0);
	Youhana_q: out std_logic_vector ( Youhana_N_bit-1 downto 0)
	);
	end Youhana_32_bit_register;
	
	architecture arch1 of Youhana_32_bit_register is 
		signal Youhana_memory: std_logic_vector (Youhana_N_bit-1 downto 0);
		
	begin 
	process (Youhana_clk, Youhana_wren)
	begin 
		if (rising_edge(Youhana_clk) and Youhana_wren = '1')
			then Youhana_memory <= Youhana_data;
		end if;
		end process;
	
	process (Youhana_rden, Youhana_chen, Youhana_memory)
	begin 
		if(Youhana_rden = '1' and Youhana_chen = '1')
			then Youhana_q <= Youhana_memory;
		elsif( Youhana_chen = '0')
			then Youhana_q <= (others => 'Z');
			end if;
			end process;
	end arch1;  