----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/08/2022 06:46:06 PM
-- Design Name: 
-- Module Name: Main_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main_tb is
--  Port ( );
end Main_tb;

architecture Behavioral of Main_tb is
            
            constant ClockFrequency : integer := 100e6; -- 100 MHz
            constant ClockPeriod    : time    := 1000 ms / ClockFrequency;
            
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

        component Controller is
          Port ( 
                    start,reset,clk: in std_logic:='0';
                    
                    load_opperands,load_product:out std_logic:='0';
                    reset_product,ready:out std_logic:='0';
                    shift_opperand,shift_product:out std_logic:='0'
                    
                    
                    );
          end component;
            
            

        signal   load_opperands,load_product: std_logic:='0';
        signal    reset_product,ready: std_logic:='0';
        signal    shift_opperand,shift_product: std_logic:='0';
        
                        
                component Multiplier
                port        (Multiplier: in std_logic_vector(7 downto 0):="00000000";
                
                            Shif_Right:in std_logic:= '0';
                            
                            clk: in std_logic:= '0';
                            load: in std_logic:= '0';
                            
                            Dataout: out std_logic := '0'
                         );
                end component;
                
                component Multipicand 
                  Port  (Multipcand: in std_logic_vector(7 downto 0):="00000000";
                
                            
                            clk: in std_logic:= '0';
                            load: in std_logic:= '0';
                            
                            Dataout: out std_logic_vector (7 downto 0):= "00000000"
                  );
                end component;
                
                component AND_Module 
                port        (Multiplier_bit: in std_logic:= '0';
                             Multipcant: in std_logic_vector(7 downto 0):="00000000";
                            clk: in std_logic:= '0';
                            load: in std_logic:= '0';
                            And_Result: out std_logic_vector(7 downto 0):="00000000"
                           
                         );
                end component;
                
                
               component RippleCarryAdder
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
                
                end component;
                
               
               
               signal Sum: std_logic_vector(8 downto 0);
                
               --Inputs 
              signal Product_Out: std_logic_vector(7 downto 0); --Input
              signal   start,reset,clk:  std_logic:='0';
              signal MultiplierS,MultipcandS: std_logic_vector(7 downto 0);
              
              
              --Internal Wires
              signal Multiplier_out: std_logic;
              signal Multipcand_out: std_logic_vector(7 downto 0);
              signal AND_OUT: std_logic_vector(7 downto 0);
              
              signal  Compare,Cout: std_logic:= '-';
              
              signal        Product_outs:  std_logic_vector(16 downto 0);

begin
        Clk  <= not Clk after ClockPeriod / 2;
        
    CNTRL: Controller 
          Port map( 
                    start=> start,
                    reset=> reset,
                    clk=> clk,
                    
                    load_opperands=>load_opperands ,
                    load_product => load_product,
                    reset_product => reset_product,
                    Ready => ready,
                    shift_opperand => shift_opperand,
                    shift_product=>shift_product
                    );
                    
                    
              LIER: Multiplier
                port map       (Multiplier => MultiplierS,
                
                            Shif_Right =>  shift_opperand,
                            clk=> clk,
                            
                            load => load_opperands,
                            
                            Dataout => Multiplier_out
                         );
                
                
                CAND: Multipicand 
                  Port map  (Multipcand => MultipcandS,
                
                            
                            clk => clk,
                            load => load_opperands,
                            
                            Dataout => Multipcand_out
                            );

                
                ANDM: AND_Module 
                port  map       (Multiplier_bit =>Multiplier_out,
                                     Multipcant => Multipcand_out,
                                    clk =>clk,
                                    load => load_opperands,
                                    And_Result =>AND_OUT
                           
                                 );                
                
               RCADD: RippleCarryAdder
                    generic map(N => 8)
                    port map(
                            And_out => AND_OUT,
                            Product_Out => Product_Out,
                            Cin => '0',
                            clk =>clk,
                            Sum => Sum,
                            Cout => Cout,
                            Compare => Compare
                            
                        );
                        
              PRDCT:Product 
              Port map( 
                         load_product => load_product,
                         reset_product =>reset_product,
                         clk => clk,
                         ResultfromRC => Sum,
                         shift_product => shift_product,
              
                        
                 
                        Product => Product_outs,
                        ProductToRC => Product_Out
                    );
                    
process
begin


              


                     start <= '0';
                     reset <= '0';
                     
        wait for 20 ns;
                       
                      start <= '1';
                     reset <= '0';
                    MultiplierS <= "01000111"; 
                     MultipcandS <= "00000101";  
                     wait for 20 ns;
                      start <= '0';

                   
                     
                     
       

                     
        wait for 300 ns;
            start <= '0'; 
         wait for 20ns;     
                      start <= '1';
                     reset <= '0';
                    MultiplierS <= "01011111"; 
                     MultipcandS <= "00000101";  
                     wait for 20 ns;
                      start <= '0';

                   
                     
                     
       

                     
        wait for 300 ns;




end process;   

end Behavioral;
