library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity Clock_Divider is
generic(freq: integer := 666);
port ( clk,reset: in std_logic;
clock_out: out std_logic);

end Clock_Divider;
  
architecture bhv of Clock_Divider is
  
signal count: integer:=1;
signal tmp : std_logic := '0';
constant clk_out_ticks : integer := 125e6/freq;
constant clk_out_ticks_per_2 : integer := clk_out_ticks/2;
  
begin
  
process(clk,reset)
begin
    if(reset='1') then
        count<=0;
        tmp<='0';
    elsif(clk'event and clk='1') then
        if (count >= clk_out_ticks) then
            --tmp <= NOT tmp;
            count <= 0;
    
        else 
            count <=count+1;
    
        end if;
        
        if count < clk_out_ticks_per_2 then
        
            tmp<='0';
        else
            tmp<='1';        
        end if;
        
    end if;
    
end process;
  
clock_out <= tmp;
  
end bhv;