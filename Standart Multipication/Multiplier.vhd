library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Multiplier is
port        (Multiplier: in std_logic_vector(7 downto 0):="00000000";

            Shif_Right:in std_logic:= '0';
            
            clk: in std_logic:= '0';
            load: in std_logic:= '0';
            
            Dataout: out std_logic := '0'
         );
end Multiplier;

architecture Behavioral of Multiplier is
               
        
        signal Multiplier_H: std_logic_vector(7 downto 0):="00000000";
        signal Ready_Multiplier_Load: std_logic:= '0';
        
begin
    
    Shifted_Multiplier:process(clk)
    begin
    
     if(rising_edge(clk)) then
    
            if(load = '1') then
                Multiplier_H <= Multiplier;                 
            end if;
        
        
        
            if(Shif_Right = '1') then    
                Dataout <= Multiplier_H(0);
                Multiplier_H <=  std_logic_vector(shift_right(unsigned(Multiplier_H),1));
            end if;
        
       end if;
             
    end process Shifted_Multiplier;
end Behavioral;
        