library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;

entity Controller is
  Port ( 
            start,reset,clk: in std_logic:='0';
            
            load_opperands,load_product:out std_logic:='0';
            reset_product,ready:out std_logic:='0';
            shift_opperand,shift_product:out std_logic:='0'
            
            
            );
end Controller;

architecture Behavioral of Controller is
        
        type stages_cntrl is (Initiate,LoadProduct,ShiftSignal,Finished);    
        signal current_stage : stages_cntrl := Initiate;
        
        signal Timer: integer := 0;
        signal ongoing: boolean := False;    
begin
    
process(clk,reset)
begin
    if(reset = '0') then
        
        
        if(rising_edge(clk)) then
        
            case current_stage is 
            
                when Initiate =>    
                                    if( start = '1') then
                                    current_stage <= LoadProduct;
                                     load_opperands <= '1';
                                    end if;
                                    ready <= '0';
                                    reset_product <= '0';
                when LoadProduct =>
                                    -- Switch to load mode

                                    --
                                    load_opperands <= '0';
                   
                                        shift_opperand <= '0'; 
                                        shift_product <= '0';
                                        
                                        load_product <= '1';
                                        current_stage <= ShiftSignal;
                            

                                   
                                    
                when ShiftSignal =>
                                    Timer <= Timer + 1;
                                    -- Switch to shift mode
                                
                                    
                                
                                    load_product <= '0';
                                    
                                    --
                                    shift_opperand <= '1'; 
                                    shift_product <= '1';
                                    
                                    if( Timer = 9) then -- 0 indexed
                                        current_stage <= Finished;
                                    else
                                        current_stage <= LoadProduct;
                                    end if;
                               
                
                when Finished =>
                                    Timer <= 0;
                                    ready <= '1';
                                    current_stage <=  Initiate;
                                    
                                    -- Off the shift mode
                                    shift_opperand <= '0'; 
                                    shift_product <= '0';
                                    
                when others =>
            
            end case;
            
        end if;
        
    else
        current_stage <= Initiate;
        reset_product <= '1';
    end if;
end process;


end Behavioral;