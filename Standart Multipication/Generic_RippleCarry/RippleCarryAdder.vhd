library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RippleCarryAdder is
    generic(N:integer := 8);
    port(
            And_out: in std_logic_vector (N-1 downto 0);
            Product_Out: in std_logic_vector(N-1 downto 0);
            Cin: in std_logic;
            clk: in std_logic:= '0';
            Sum: out std_logic_vector (N downto 0);
            Cout: out std_logic;
            Compare: out std_logic
            
    );

end RippleCarryAdder;

architecture dataflow of RippleCarryAdder is

    component singlebitfulladder port(
        A,B,Cin: in std_logic;
        Cout,Sum: out std_logic
    );
    end component;
    
    signal C: std_logic_vector (N-1 downto 0);
    signal Sum_H: std_logic_vector (N-1 downto 0) := "00000000";
    
 
   begin 
   
   FA: for i in 0 to N-1 generate
   
        Firstbit: if i=0 generate
        
        FA_0: singlebitfulladder port map(
           And_out(i),Product_Out(i),Cin, C(i),Sum_H(i)
        );
        end generate Firstbit; 
        
        
        Laterbits: if i>0 generate
        
           FA_i : singlebitfulladder port map(
             And_out(i),Product_Out(i),C(i-1), C(i),Sum_H(i)
           );
           
       end generate Laterbits;
   
   end generate FA;

            Sum <= C(N-1) & Sum_H ;
            
  
end dataflow;

