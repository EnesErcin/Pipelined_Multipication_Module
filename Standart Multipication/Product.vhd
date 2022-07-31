
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Product is
  Port ( 
            clk: in std_logic:='0';
            
            load_product:in std_logic:='0';
            reset_product:in std_logic:='0';
            shift_product:in std_logic:='0';
            
            ResultfromRC: in std_logic_vector(8 downto 0):="000000000";
            
            Product: out std_logic_vector(16 downto 0);
            ProductToRC: out std_logic_vector(7 downto 0)
  
        );
end Product;


architecture Behavioral of Product is
        
        signal Product_Hold:std_logic_vector(16 downto 0) := "00000000000000000";
        
        signal Shifted_Hold:std_logic_vector(7 downto 0) := "00000000";
        
        signal ResultfromRC_H: std_logic_vector(8 downto 0):="000000000";
begin


--Shifted_Hold <= Product_Hold(7 downto 0);

process(clk,reset_product)
    variable Shifted_Hold_var : std_logic_vector(7 downto 0) := "00000000";
begin

    if (reset_product = '0') then
    
            
            if(shift_product = '1') then
                        if(rising_edge(clk)) then
                        Product_Hold <= std_logic_vector((signed(Product_Hold) srl 1));
                    end if;
                         if(falling_edge(clk)) then
                        ResultfromRC_H <=  ResultfromRC;
                    end if;
                    
            end if;
            
                
            if(load_product = '1') then 
                     if(rising_edge(clk)) then
                    -- 16 bit <=   1bit Cout  + 7 bit result & 8 bit of Zeros
                    Product_Hold <= ResultfromRC_H & Product_Hold(7 downto 0);
                    end if;    
            end if;
             
    else
        Product_Hold <=  std_logic_vector(to_unsigned(0, 17));
    end if;    
    
end process;
        
    Product <= Product_Hold ;
    ProductToRC <= Product_Hold(16 downto 9);

end Behavioral;
