library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Piplined_Multiplier_tb is
--  Port ( );
end Piplined_Multiplier_tb;

architecture Behavioral of Piplined_Multiplier_tb is
    
     constant ClockFrequency : integer := 100e6; -- 100 MHz
    constant ClockPeriod    : time    := 1000 ms / ClockFrequency;
        
        component Piplined_Multiplier is
          Port (    Multiplier: in std_logic_vector(7 downto 0):="00000000";
                    Multipcant: in std_logic_vector(7 downto 0):="00000000";
                    
                    clk: in std_logic:= '0';
                            
                    rst: in std_logic:= '0';
                    start: in std_logic:= '0';
                    
                    Result: out std_logic_vector(15 downto 0):="0000000000000000"
                    
                 );
        end component;
        
     --Input signals
   signal Multiplier, Multipcant: std_logic_vector(7 downto 0):="00000000";
   signal clk, rst, start: std_logic:= '0';
    --Output Signals
    signal  Result: std_logic_vector(15 downto 0):="0000000000000000";
     
begin
         Clk  <= not Clk after ClockPeriod / 2;
         
        UUT: Piplined_Multiplier port map(
        Multiplier => Multiplier,
        Multipcant => Multipcant,
        clk => clk,
        rst => rst,
        start => start,
        Result => Result
        );
    
    process

    begin  
           

          start <= '1';
         Multiplier <= "00000100";
         Multipcant <= "00000010";
          wait for 100 ns;
        Multiplier <= "00001000";
         Multipcant <= "00000100";
            wait for 100 ns;
         Multiplier <= "00001000";
         Multipcant <= "00000001";
            wait for 100 ns;
         Multiplier <= "00001001";
         Multipcant <= "00001010";
         wait for 100 ns;
         Multiplier <= "00000100";
         Multipcant <= "00000010";
          wait for 100 ns;
        Multiplier <= "00001110";
        Multipcant <=   "00000100";
         wait for 100 ns;
        Multiplier <= "00000100";
         Multipcant <= "00000010";
      
    end process;
    
end Behavioral;


