----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2020 10:02:43
-- Design Name: 
-- Module Name: rgb_selector - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 1.01 - File Created
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

entity rbg_selector is
port(
led4_r, led4_g, led4_b : out    std_logic;
clock : inout std_logic;
state : inout integer;
clk, n_Reset : in std_logic);
end rbg_selector;

architecture Behavioral of rbg_selector is

signal RGB_Led_4: std_logic_vector(0 to 2);

component Button_Input
generic(
delay: integer := 2000;
repeat_limit: integer := 500
);
port(
input, n_Reset, clk: in std_logic;
output: inout std_logic;
count : inout integer := 1;
state: inout integer;
clock, interval: inout std_logic );
end component;

COMPONENT Clock_Divider
GENERIC(
freq : integer := 1000
);
PORT(
clk : IN std_logic;
reset : IN std_logic;
clock_out : OUT std_logic
);
END COMPONENT;


type channel_state_t is (Red, Green, Blue);
signal channel_state: channel_state_t;
signal input: std_logic;
signal button_state:integer :=1;
signal output:std_logic;
signal state_counter: integer := 0;
begin
    
led4_r <= RGB_Led_4(2);
led4_g <= RGB_Led_4(1);
led4_b <= RGB_Led_4(0);

cdc : Clock_Divider
port map(clk => clk, reset => n_Reset, clock_out => clock);

bps : Button_Input
port map(state => button_state, input => input, n_Reset => n_Reset,clk=>clk, output => output);


channel_selector: process (clock, n_Reset) begin
    if (n_Reset'event and n_Reset = '1') then
        state <= 1;
        channel_state <= Red;
    end if;

    if (clock'event and clock = '1') then
        if state_counter = 0 then
            channel_state <= Red;
        elsif state_counter = 1 then
            channel_state <= Green;
        elsif state_counter = 2 then
            channel_state <= Blue;
        end if;
        
       -- if(button_state = 1) then
            

        if (button_state = 2) then
                state_counter <= (state_counter mod 3) +1 ;
        elsif (button_state = 3) then
            if(output'event and output = '1') then
                state_counter <= (state_counter mod 3) +1 ;
            end if;
        end if;
    
        case channel_state is
            when Red =>
                RGB_Led_4 <= "100";
            when Green =>
                RGB_Led_4 <= "010";
            when Blue =>
                RGB_Led_4 <= "001";
            when others =>
                RGB_Led_4 <= "000";
        end case;
      end if;
end process;

end Behavioral;
