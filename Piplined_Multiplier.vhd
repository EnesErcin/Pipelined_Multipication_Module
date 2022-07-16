library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Piplined_Multiplier is
port        (Multiplier: in std_logic_vector(7 downto 0):="00000000";
            Multipcant: in std_logic_vector(7 downto 0):="00000000";
            
            clk: in std_logic:= '0';
                    
            rst: in std_logic:= '0';
            start: in std_logic:= '0';
            
            Result: out std_logic_vector(15 downto 0):="0000000000000000"
            
         );
end Piplined_Multiplier;

architecture Behavioral of Piplined_Multiplier is
               
        --FSM_StepDetermination (Top)
        type Step_States is (Initiation,Analysis,Addition,Finished);
        signal current_Step_state: Step_States := Initiation; 
        
        --FSM_AdditionCycle 
        type Addition_States is (Idle,ZeroCylce,OneCycle,TwoCycle,ThreeCycle,Finished);
        signal current_ADD_state: Addition_States := Idle;
        

        
        -- Ready Signals from Step_States
        signal Ready_from_add: boolean := FALSE;
        signal Ready_from_analysis: boolean := FALSE;
        
   
        -- Component for  Analysis Step
        component Multiplier_Analysis_Module 
              Port ( 
                    OP1: in std_logic_vector(7 downto 0):="00000000";
                    
                    clk: in std_logic;
                    
                    rst: in std_logic;
                    NumberofStages: out integer :=0 ;
                    FirstDistance,SecondDistance,ThirdDistance: out integer :=0 ;
                    Ready_from_analysis: out boolean
                    
                    );
            end component;

        signal NumberofStages:  integer :=0 ;
        
        --  3 Registers for Addition
        signal Current_ResultS: unsigned (15 downto 0):="0000000000000000"; --Holds the Result
        signal ADD_1: std_logic_vector(15 downto 0):="0000000000000000";
        signal ADD_2: std_logic_vector(15 downto 0):="0000000000000000";
        
        -- Holds the second Opperand for shifting
        signal ADD1_H: std_logic_vector(7 downto 0):="00000000";
        
        -- 3 Registers for Humming Distance
         signal  FirstDistance , SecondDistance, ThirdDistance: integer := 0;
         signal  FirstDistance_h , SecondDistance_h, ThirdDistance_h: integer := 0;
         
         --For AdditionCycle
         signal  Timer_ADD: integer:= 0;
         
         
begin
    
        AnalysisComponent: Multiplier_Analysis_Module port map(
        OP1 => Multiplier,
        clk => clk,
        rst => rst,
        NumberofStages =>NumberofStages,
        FirstDistance =>FirstDistance,
        SecondDistance=>SecondDistance,
        ThirdDistance =>ThirdDistance,
        Ready_from_analysis =>Ready_from_analysis
        );

    
    process(clk)
        
        variable Current_Result: unsigned (15 downto 0):="0000000000000000";
    begin
            
            if(rising_edge(clk)) then
                
                
                case current_ADD_state is
                
                when Idle => 
                                Ready_from_add <= False;
--                                current_ADD_state <= ;
                                if(Ready_from_analysis) then
                                        case NumberofStages is
                                        when 0 => current_ADD_state <=  ZeroCylce;                                               
                                        when 1 => Current_Result := "0000000000000000";
                                                  current_ADD_state <=  OneCycle;
                                                  FirstDistance_h <= FirstDistance;
                                                  
                                                    ADD_1 <= std_logic_vector(to_unsigned(0, 8)) &  Multipcant;
                                                    ADD1_H <= Multipcant;
                                        when 2 => current_ADD_state <= TwoCycle;
                                                    FirstDistance_h <=FirstDistance;
                                                   SecondDistance_h <= SecondDistance;
                                                    
                                                     ADD_1 <= std_logic_vector(to_unsigned(0, 8)) & Multipcant;
                                                     ADD1_H <=  Multipcant;
                                        
                                        when 3 =>   current_ADD_state <= ThreeCycle;
                                        
                                                        FirstDistance_h <=FirstDistance;
                                                        SecondDistance_h <= SecondDistance;
                                                        ThirdDistance_h <=ThirdDistance;
                                                     ADD_1 <= std_logic_vector(to_unsigned(0, 8)) & Multipcant;
                                                     ADD1_H <=  Multipcant;
                                        when others => current_ADD_state <=  ZeroCylce;  --Change later;
                                        end case;
                                else      
                                end if;
                                
                when ZeroCylce => 
                                   Ready_from_add <= True;
                                   Current_Result := "0000000000000000" ;
                                   current_ADD_state <=  Idle;
                                   
                when OneCycle => 
            
                                 Timer_ADD <= Timer_ADD + 1;
                                 Ready_from_add <= False;
                                 
                                 case   Timer_ADD is
                                   -- 16 bit <=           (8-x) bit       & 8 bit         &       x bit
                                 when 0 =>      if( FirstDistance_h /= 0) then 
                                               Current_ResultS <= unsigned(std_logic_vector(to_unsigned(0, 8-FirstDistance_h)) & ADD1_H  & std_logic_vector(to_unsigned(0, FirstDistance_h)));
                                                else
                                                Current_ResultS <= unsigned(std_logic_vector(to_unsigned(0, 8)) & ADD1_H);
                                                end if;
                                 when 1 =>  Timer_ADD <= 0;
                                            current_ADD_state <= Idle;
                                            Ready_from_add <= True;        
                                 when others => Timer_ADD <= 0;
                                                Ready_from_add <= False;
                                 end case;
                               
                                
                when TwoCycle => 
                                
                                 Timer_ADD <= Timer_ADD + 1;
                                 Ready_from_add <= False;
                                 
                                 case   Timer_ADD is
                                   -- 16 bit <=           (8-x) bit       & 8 bit         &       x bit
                                 when 0 =>  if( FirstDistance_h /= 0) then
                                            ADD_1 <= std_logic_vector(to_unsigned(0, 8-FirstDistance_h)) & ADD1_H  & std_logic_vector(to_unsigned(0, FirstDistance_h));
                                            else
                                            ADD_1 <= std_logic_vector(to_unsigned(0, 8-FirstDistance_h)) & ADD1_H ;
                                            end if;
                                            
                                            ADD_2 <= std_logic_vector(to_unsigned(0, 8-SecondDistance_h)) & ADD1_H  & std_logic_vector(to_unsigned(0, SecondDistance_h));

                                 when 1 =>      
                                             Current_ResultS <=  unsigned(ADD_1) + unsigned( ADD_2);
                                             Ready_from_add <= True;
                                             
                                 when 2 =>  Timer_ADD <= 0;
                                            current_ADD_state <= Idle;
                                            Ready_from_add <= True;

                                 when others => Timer_ADD <= 0;
                                                Ready_from_add <= False;   
                                                current_ADD_state <= Idle;  
                                 end case; 
                                 
                when ThreeCycle => 
                                                                     Timer_ADD <= Timer_ADD + 1;
                                 Ready_from_add <= False;
                                 
                                 case   Timer_ADD is
                                   -- 16 bit <=           (8-x) bit       & 8 bit         &       x bit
                                 when 0 =>  if( FirstDistance_h /= 0) then
                                            ADD_1 <= std_logic_vector(to_unsigned(0, 8-FirstDistance_h)) & ADD1_H  & std_logic_vector(to_unsigned(0, FirstDistance_h));
                                            else
                                            ADD_1 <= std_logic_vector(to_unsigned(0, 8-FirstDistance_h)) & ADD1_H ;
                                            end if;
                                            
                                            ADD_2 <= std_logic_vector(to_unsigned(0, 8-SecondDistance_h)) & ADD1_H  & std_logic_vector(to_unsigned(0, SecondDistance_h));

                                 when 1 =>      
                                             Current_ResultS <=  unsigned(ADD_1) + unsigned( ADD_2);
                                             
                                 when 2 =>      
                                                
                                                ADD_1 <= std_logic_vector(TO_UNSIGNED(0,8-ThirdDistance_h)) & ADD1_H & std_logic_vector(to_unsigned(0, ThirdDistance_h));
                                                ADD_2 <= std_logic_vector(Current_ResultS);
                                                
                                  when 3=>          
                                            Current_ResultS <=  unsigned(ADD_1) + unsigned( ADD_2);
                                            Timer_ADD <= 0;
                                            Ready_from_add <= True;   
                                            current_ADD_state <= Idle;  

                                 when others => Timer_ADD <= 0;
                                                Ready_from_add <= False;   
                                                current_ADD_state <= Idle;  
                                 end case;
                when Finished => 
                when others => 
            
                end case;
                
                
            
                if (rising_edge(clk)) then
                    if( Ready_from_add) then
                       Current_ResultS <= Current_Result;
                    end if;
                end if;

            end if;
    
    end process;

      Result <= std_logic_vector(Current_ResultS); 

end Behavioral;
