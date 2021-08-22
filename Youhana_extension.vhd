library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_signed.all;
use IEEE.NUMERIC_STD.all;


entity Youhana_extension is 
    port (
    Youhana_IN1:    in std_logic_vector (15 downto 0); 
    Youhana_s:      in std_logic;
    Youhana_output: out std_logic_vector (31 downto 0));
end Youhana_extension;


architecture arch7 of Youhana_extension is 
signal Youhana_result: std_logic_vector (31 downto 0) := x"00000000";
signal extend:         std_logic_vector (15 downto 0) := x"0000";
begin 
    process (Youhana_IN1, Youhana_s, extend, Youhana_result)
    begin 
    case Youhana_s is               
when '0' => Youhana_result <= x"0000" & Youhana_IN1;
when '1' => extend <=  (15 downto 0 => Youhana_IN1(15));
Youhana_result <= extend & Youhana_IN1;
when others => Youhana_result <= x"00000000";
            
end case;
Youhana_output <=Youhana_result;
end process; 
end arch7;