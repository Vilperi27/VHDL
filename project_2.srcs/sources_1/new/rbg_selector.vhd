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
led5_r, led5_g, led5_b : out    std_logic;
sysclk, n_Reset : in std_logic;
input : in std_logic );
end rbg_selector;

architecture Behavioral of rbg_selector is

signal RGB_Led_5: std_logic_vector(0 to 2);
signal clock : std_logic;

component Button_Input
generic(
delay: integer := 2000;
repeat_limit: integer := 500
);
port(
input, n_Reset, clk: in std_logic;
output: inout std_logic);
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
signal output:std_logic;

begin
    
led5_r <= RGB_Led_5(2);
led5_g <= RGB_Led_5(1);
led5_b <= RGB_Led_5(0);

cdc : Clock_Divider
port map(clk => sysclk, reset => n_Reset, clock_out => clock);

bps : Button_Input
port map(input => input, n_Reset => n_Reset,clk=>sysclk, output => output);


channel_selector: process (clock, n_Reset) begin
    if n_Reset = '1' then
        channel_state <= Red;

    elsif (rising_edge(clock)) then
    
    if output = '1' then
        case channel_state is
            when Red =>
                RGB_Led_5 <= "001";
                channel_state <= Green;
            when Green =>
                RGB_Led_5 <= "010";
                channel_state <= Blue;
            when Blue =>
                RGB_Led_5 <= "100";
                channel_state <= Red;
            when others =>
                RGB_Led_5 <= "000";
        end case;
        
      end if; -- output
      end if; --clk/rst
end process;

end Behavioral;
