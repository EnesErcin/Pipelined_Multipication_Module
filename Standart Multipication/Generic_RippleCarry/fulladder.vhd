
library ieee;
use ieee.std_logic_1164.all;

entity singlebitfulladder is

    port(
            A: in std_logic ;
            B: in std_logic;
            Cin: in std_logic;
            Sum: out std_logic;
            Cout: out std_logic
    );

end singlebitfulladder;



architecture dataflow of singlebitfulladder is
    
   

    component halfadder is port(
        A,B: in std_logic;
        Cout,Sum: out std_logic
    );
    end component;
  
    signal S1,S2,C1,C2: std_logic;
    
   begin

    HA_1: halfadder port map(
        A => A,
        B => B,
      
        Cout => C1,
        Sum => S1
    );
    
  

    HA_2 : halfadder port map(        
        A => S1,
        B => Cin,
        
        Cout => C2,
        Sum => S2
    );

    Sum <= S2 ;
    Cout <= C2 or C1;
    
    
    end dataflow;
