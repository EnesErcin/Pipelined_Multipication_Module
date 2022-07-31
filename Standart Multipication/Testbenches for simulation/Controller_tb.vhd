
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;


entity Controller_tb is
--  Port ( );
end Controller_tb;

architecture Behavioral of Controller_tb is

                constant ClockFrequency : integer := 100e6; -- 100 MHz
            constant ClockPeriod    : time    := 1000 ms / ClockFrequency;

  component Controller is
  Port ( 
            start,reset,clk: in std_logic:='0';
            
            load_opperands,load_product:out std_logic:='0';
            reset_product,ready:out std_logic:='0';
            shift_opperand,shift_product:out std_logic:='0'
            
            
            );
  end component;
  
 component Product is
  Port ( 
            clk: in std_logic:='0';
            
            load_product:in std_logic:='0';
            reset_product:in std_logic:='0';
            shift_product:in std_logic:='0';
            
            ResultfromRC: in std_logic_vector(8 downto 0):="000000000";
            
            Product: out std_logic_vector(16 downto 0);
            ProductToRC: out std_logic_vector(7 downto 0)
  
        );
end component;
  
        signal   start,reset,clk:  std_logic:='0';

        signal   load_opperands,load_product: std_logic:='0';
        signal    reset_product,ready: std_logic:='0';
        signal    shift_opperand,shift_product: std_logic:='0';
        
        
        
        ---
        signal        ResultfromRC:  std_logic_vector(8 downto 0):="000000000";
               
        signal        Product_out:  std_logic_vector(16 downto 0);
        signal        ProductToRC:  std_logic_vector(7 downto 0);
        
        
begin
        Clk  <= not Clk after ClockPeriod / 2; 

        CNTR: Controller port map(
                     start => start,
                     reset => reset,
                     clk => clk,
                    
                    load_opperands =>load_opperands,
                    load_product => load_product,
                    
                    reset_product=> reset_product,
                    ready => ready,
                    shift_opperand =>shift_opperand,
                    shift_product =>shift_product
         
         );
         
          PRDCT:Product 
          Port map( 
                     load_product => load_product,
                     reset_product =>reset_product,
                     clk => clk,
                    ResultfromRC => ResultfromRC,
                  
          
                    
             
                    Product => Product_out,
                    ProductToRC => ProductToRC
                );
        
         
         
stim_process: process
    begin
                     start <= '0';
                     reset <= '0';
                     
        wait for 20 ns;
                      ResultfromRC <= "001010101";  
                      start <= '1';
                     reset <= '0';
                     wait for 30 ns;
                     ResultfromRC <= "000010101";  
                     wait for 20 ns;
                     ResultfromRC <= "000001010";  
                     wait for 20 ns;
                     ResultfromRC <= "000000101";  
                     wait for 20 ns;
                     ResultfromRC <= "000000010";  
                     wait for 20 ns;
                     ResultfromRC <= "000000000";  
                     wait for 20 ns;
                     ResultfromRC <= "000000000";  
                     wait for 20 ns;
                     ResultfromRC <= "000000000";  
                     wait for 20 ns;
                     ResultfromRC <= "000000000";  
                     
                     
        wait for 200 ns;
                        start <= '1';
                        
        wait for 50 ns;
                        reset <= '0';
        wait for 20 ns;
                        reset <= '1';
        wait for 20 ns;
        
                       ResultfromRC <= "001010101";  
                      start <= '1';
                     reset <= '0';
        wait for 200 ns;
        
    end process;


end Behavioral;
