----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2020 10:04:04
-- Design Name: 
-- Module Name: Button_Input - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity Button_Input is
generic(
delay: integer := 10;
repeat_limit: integer := 10);
port(
input, n_Reset, clk: in std_logic;
output: inout std_logic;
count : inout integer := 1;
state: inout integer;
clock, interval: inout std_logic );
end Button_Input;              



architecture bhv of Button_Input is

COMPONENT Clock_Divider
GENERIC(
freq : integer := 10000
);
PORT(
clk : IN std_logic;
reset : IN std_logic;
clock_out : OUT std_logic
);
END COMPONENT;


type pulser_state_t is (Idle, Armed, Repeat);
signal pulser_state: pulser_state_t;
signal long_press: std_logic := '0';
signal repeat_counter: integer := 1;
--signal interval: std_logic;
--signal clock : std_logic;
--signal count: integer:=1;

begin
cdc : Clock_Divider
port map(clk => clk, reset => n_Reset, clock_out => clock);

--second: Clock_Divider
--generic map(freq => fff)
--port map(clk => clk, reset => n_Reset, clock_out => interval);

button_pulser: process (clock, n_Reset) begin
    if (n_Reset'event and n_Reset = '0') then
        count <= 0;
        output <= '0';
        pulser_state <= Idle;
    end if;
    if (clock'event and clock = '1') then
        if input = '1' then
                count <= count + 1;
            if (count >= delay) then
                long_press <= '1';
            else
                long_press <= '0';
            end if;
         else
            count <= 0;
            long_press <= '0';
            output <= '0';
         end if;
       
        case pulser_state is
            when Idle => 
            state <= 1;
                if input = '1' then
                    output <= '1';
                    pulser_state <= Armed;
                elsif input = '0' then
                    output <= '0';

                end if;
            when Armed =>
                state <= 2;
                output <= '0';
                if (long_press = '1') then pulser_state <= Repeat;
                elsif (long_press = '0' and input = '0') then
                    pulser_state <= Idle;
                end if;
            when Repeat => 
            -- TODO: make repeat generate pulses by counting the clock cycles it should have between the pulses (the interval)
                state <= 3;
                
                if (long_press = '0' or input = '0') then 
                    pulser_state <= Idle;
                    repeat_counter <= 1;
                end if;
                
                repeat_counter <= repeat_counter + 1;
                                
                if (repeat_counter = repeat_limit) then
                    repeat_counter <= 1;
                    output <= not output;
                end if;
                
            when others =>
                pulser_state <= Idle;
            end case;
         
         end if;
      end process button_pulser;
end bhv;
