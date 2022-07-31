
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity AND_Module is
port        (Multiplier_bit: in std_logic:= '0';
             Multipcant: in std_logic_vector(7 downto 0):="00000000";
            clk: in std_logic:= '0';
            load: in std_logic:= '0';
            And_Result: out std_logic_vector(7 downto 0):="00000000"
           
         );
end AND_Module;

architecture Behavioral of AND_Module is
    
begin

process(Multiplier_bit,Multipcant)
begin

        AndLoop:  for ii in 0 to 7   loop
            And_Result(ii) <= Multiplier_bit and Multipcant(ii);
         end loop AndLoop;
         
end process;

end Behavioral;
