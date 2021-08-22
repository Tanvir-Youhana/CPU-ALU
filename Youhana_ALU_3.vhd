library IEEE;
use IEEE.std_logic_1164.all;

entity Youhana_ALU_3 is
    generic (N: integer := 32);
    port(
            Youhana_clk:    in std_logic;
            Youhana_RS:     in  std_logic_vector(N-1 downto 0);
            Youhana_RT:     in std_logic_vector(N-1 downto 0);
            Youhana_16_IMM: in std_logic_vector(15  downto 0);
            Youhana_S_line: in std_logic;
				Youhana_RTout:  in std_logic_vector(N-1 downto 0);
            Youhana_op_code:in std_logic_vector( 3  downto 0);
            Youhana_RD:     out std_logic_vector(N-1 downto 0);
				Youhana_MDR : 	 in std_logic_vector(N-1 downto 0);
            Youhana_flags:  out std_logic_vector( 2  downto 0));
				
end Youhana_ALU_3;

architecture Youhana_structure of Youhana_ALU_3 is 

        component Youhana_32_bit_register is 
        generic (Youhana_N_bit: integer :=32);
        port(
            Youhana_clk:   in  std_logic;
            Youhana_wren:  in  std_logic;
            Youhana_rden:  in  std_logic;
            Youhana_chen:  in  std_logic;
            Youhana_data:  in  std_logic_vector(Youhana_N_bit-1 downto 0);
            Youhana_q:     out std_logic_vector(Youhana_N_bit-1 downto 0));
        end component; 
        
        component Youhana_16_bit_register is 
        generic (Youhana_N_bit: integer :=16);
              port(
                    Youhana_clk   : in  std_logic;
                    Youhana_wren  : in  std_logic;
                    Youhana_rden  : in  std_logic;
                    Youhana_chen  : in  std_logic;
                    Youhana_data  : in  std_logic_vector(Youhana_N_bit-1 downto 0);
                    Youhana_q     : out std_logic_vector(Youhana_N_bit-1 downto 0));
        end component; 
		  
        component Youhana_extension is 
               port (
               Youhana_IN1: in std_logic_vector (15 downto 0); 
               Youhana_s: in std_logic;
               Youhana_output: out std_logic_vector (31 downto 0)
                );
        end component;

        component Youhana_op_unit_3 is 
        generic (N: integer :=32);
            port(
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
        end component; 
   

    signal RS_OUT, RT_OUT, Youhana_output_extension, RD_IN, RT_register: std_logic_vector(N-1 downto 0);
    signal Youhana_16_IMM_out: std_logic_vector(15 downto 0);
	 signal Youhana_MAR_OUT, Youhana_MDR_OUT: std_logic_vector(N-1 downto 0);
	 signal wrenmar, wrenmdr: std_logic;
    
begin 
     D1:   Youhana_16_bit_register   port map(Youhana_clk, '1','1','1', Youhana_16_IMM, Youhana_16_IMM_out);
     D2:   Youhana_extension         port map(Youhana_16_IMM, Youhana_S_line, Youhana_output_extension);
	  D3:   Youhana_32_bit_register   port map(Youhana_clk, '1','1','1', Youhana_RS, RS_OUT);
     D4:   Youhana_op_unit_3         port map(RS_OUT, RT_OUT, Youhana_16_IMM_out, Youhana_output_extension, Youhana_op_code,wrenmar, wrenmdr, RT_register, RD_IN, Youhana_flags);
     D5:   Youhana_32_bit_register   port map(Youhana_clk, '1','1','1', RD_IN, Youhana_RD);
	  D6:   Youhana_32_bit_register   port map(Youhana_clk, wrenmar, wrenmar, '1', RD_IN, Youhana_MAR_OUT);
	  D7:   Youhana_32_bit_register   port map(Youhana_clk, wrenmdr, wrenmar, '1', RT_OUT, Youhana_MDR_OUT);
	  D8:   Youhana_32_bit_register   port map(Youhana_clk, '1', '1', '1', Youhana_RT, RT_OUT);
end Youhana_structure;