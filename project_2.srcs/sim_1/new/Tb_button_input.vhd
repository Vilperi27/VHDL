
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Tb_button_input IS
END Tb_button_input;
 
ARCHITECTURE behavior OF Tb_button_input IS
  
COMPONENT Button_Input
GENERIC(
delay : integer := 10);
PORT(
input, n_Reset, clk: IN std_logic;
output: INOUT std_logic;
count: INOUT integer;
state: INOUT integer;
clock, interval: INOUT std_logic);
END COMPONENT;

--type pulser_state_t is (Idle, Armed, Repeat);
--signal pulser_state: pulser_state_t;
--signal long_press: std_logic := '0';
--signal clock : std_logic;
--signal count: integer:=1;

constant delay : integer := 40;
signal input : std_logic := '0';
signal n_Reset : std_logic := '0';
signal clk : std_logic := '0';
signal output : std_logic := '0';
constant clk_period : time := 8 ns;
signal count : integer := 1;
signal state : integer := 1;
signal clock : std_logic := '0';
signal interval: std_logic := '0';

BEGIN

uut: Button_Input
GENERIC MAP (delay => delay)
PORT MAP (input => input, n_Reset => n_Reset, clk => clk, output => output, count => count, state => state, clock => clock, interval => interval);

clk <= not clk after clk_period/2;

sim2_process : process
begin
    wait for 10 us;
    n_Reset <= '1';
    wait for 150 us;
    n_Reset <= '0';
    wait for 100 us;
    input <= '1';
    wait for 4 ms;
    input <= '0';
    wait for 10 ms;
    input <= '1';
    wait for 15 ms;
    input <= '0';
    wait;
end process;
END;