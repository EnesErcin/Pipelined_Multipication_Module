library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Multipicand is
  Port  (Multipcand: in std_logic_vector(7 downto 0):="00000000";

            
            clk: in std_logic:= '0';
            load: in std_logic:= '0';
            
            Dataout: out std_logic_vector (7 downto 0):= "00000000"
  );
end Multipicand;

architecture Behavioral of Multipicand is
    
        signal Multipcand_H:  std_logic_vector(7 downto 0):="00000000";
        signal Ready_Multipcand_Load: std_logic:= '0';   
begin

    MultipicandtoAnd: process(clk)
    begin
    
    if(rising_edge(clk)) then
            
                        if(Load = '1') then
                            Multipcand_H <= Multipcand;
                        else 
                        end if; 

                Dataout <= Multipcand_H;
                
    end if;
    
    end process MultipicandtoAnd;

end Behavioral;
