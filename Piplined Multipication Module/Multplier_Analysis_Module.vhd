library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Multiplier_Analysis_Module is
  Port ( 
        OP1: in std_logic_vector(7 downto 0):="00000000";
        
        clk: in std_logic:= '0';
        
        rst: in std_logic:= '0';
        NumberofStages: out integer :=0 ;
        FirstDistance,SecondDistance,ThirdDistance: out integer :=0 ;
        Ready_from_analysis: out boolean
        );
end Multiplier_Analysis_Module;

architecture Behavioral of Multiplier_Analysis_Module is
        
        signal Counter: integer := 0;
--        signal Stage_Counter: integer := 0;
        signal OP1_h: std_logic_vector(7 downto 0):="00000000";


        signal Finish_Counting : std_logic:='0';
        
begin

    OP1_h <= OP1;
    
    process(OP1,rst,clk)
    variable Stage_Counter: integer := 0;
    variable FirstDistance_out,SecondDistance_out, ThirdDistance_out: integer := 0;
    begin
        Stage_Counter:= 0;
        FirstDistance_out := 0; 
        SecondDistance_out :=0;
        ThirdDistance_out := 0;

        
        CountStages : for i in 0 to 7 loop
           
            if(OP1_h(i) = '1') then
                
                case Stage_Counter is 
                    
                    when 0 => FirstDistance_out := i;
                    when 1 => SecondDistance_out := i; 
                    when 2 => ThirdDistance_out := i;
                    when others =>
                end case;
                    Stage_Counter := Stage_Counter + 1;
            end if;
            

        
        end loop ; -- CountStages
        
        if (rising_edge(clk)) then
        NumberofStages  <= Stage_Counter;
        FirstDistance <= FirstDistance_out ;
        SecondDistance  <= SecondDistance_out ;
        ThirdDistance  <= ThirdDistance_out ;
        Ready_from_analysis <= False;
        end if;
        
        if falling_edge(clk) then 
            Ready_from_analysis <= True;
        end if;
        
     end process;
     
    
    end Behavioral;
