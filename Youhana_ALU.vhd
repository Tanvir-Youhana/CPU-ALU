library IEEE;
use IEEE.std_logic_1164.all;

entity Youhana_ALU is
    generic(N: integer := 32);
    port(
            Youhana_clk: in std_logic;
            Youhana_RS: in std_logic_vector(N-1 downto 0);
            Youhana_RT: in std_logic_vector(N-1 downto 0);
            Youhana_op_code: in std_logic_vector(2 downto 0);
            Youhana_RD:out std_logic_vector(N-1 downto 0);
            Youhana_flags:out std_logic_vector(2 downto 0));
end Youhana_ALU;

architecture arch4 of Youhana_ALU is 
    component Youhana_32_bit_register is 
        generic (Youhana_N_bit: integer :=32);
        port(
            Youhana_clk: in std_logic;
            Youhana_wren: in std_logic;
            Youhana_rden: in std_logic;
            Youhana_chen: in std_logic;
            Youhana_data:in std_logic_vector(N-1 downto 0);
            Youhana_q:out std_logic_vector(N-1 downto 0));
end component; 

component Youhana_op_unit is 

            generic (N: integer :=32);
            port(
            Youhana_data_in1: in std_logic_vector(N-1 downto 0);
            Youhana_data_in2: in std_logic_vector(N-1 downto 0);
            Youhana_op_code: in std_logic_vector(2 downto 0);     
				Youhana_output: out std_logic_vector (N-1 downto 0);
				Youhana_flags:out std_logic_vector(2 downto 0));
end component; 

    signal Youhana_RS_OUT, Youhana_RT_OUT, Youhana_RD_IN: std_logic_vector(N-1 downto 0);
    
begin 
    D1: Youhana_32_bit_register port map(Youhana_clk, '1','1','1', Youhana_RS, Youhana_RS_OUT);
    D2: Youhana_32_bit_register port map(Youhana_clk, '1','1','1', Youhana_RT, Youhana_RT_OUT);
    D3: Youhana_op_unit port map(Youhana_RS_OUT, Youhana_RT_OUT,Youhana_op_code, Youhana_RD_IN, Youhana_flags);
    D4: Youhana_32_bit_register port map(Youhana_clk, '1','1','1', Youhana_RD_IN, Youhana_RD);
end arch4;