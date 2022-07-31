library ieee;

use ieee.std_logic_1164.all;

entity halfadder is

    port(
            A: in std_logic;
            B: in std_logic;
            Sum: out std_logic;
            Cout: out std_logic
    );

end halfadder;

architecture dataflow of halfadder is
   
   begin
    Sum <= A xor B ;
    Cout <= A and B;
    
    end dataflow;