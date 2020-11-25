
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Tb_clock_divider IS
END Tb_clock_divider;
 
ARCHITECTURE behavior OF Tb_clock_divider IS
  
COMPONENT Clock_Divider
GENERIC(
freq : integer
);
PORT(
clk : IN std_logic;
reset : IN std_logic;
clock_out : OUT std_logic
);
END COMPONENT;
 
--Inputs
signal clk : std_logic := '0';
signal reset : std_logic := '0';
 
--Outputs
signal clock_out : std_logic;
 
constant clk_period : time := 8 ns;
constant freq : integer := 10000;
 
BEGIN

uut: Clock_Divider 
GENERIC MAP(
freq => freq)
PORT MAP (
clk => clk,
reset => reset,
clock_out => clock_out
);
 
clk <= not clk after clk_period/2;

--clk_process :process
--begin
--clk <= '0';
--wait for clk_period/2;
--clk <= '1';
--wait for clk_period/2;
--end process;
 
stim_proc: process
begin
    wait for 100 ns;
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait;
end process;
 
END;
