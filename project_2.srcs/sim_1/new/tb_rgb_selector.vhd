----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2020 10:00:48
-- Design Name: 
-- Module Name: tb_rgb_selector - Behavioral
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

ENTITY tb_rgb_selector IS
END tb_rgb_selector;

architecture Behavioral of tb_rgb_selector is

component rbg_selector is
port(
    led5_r, led5_g, led5_b : out    std_logic;
    sysclk, n_Reset : in std_logic;
    input : in std_logic );
end component;

signal led5_r, led5_g, led5_b : std_logic := '0';
signal clock : std_logic := '0';
signal sysclk, n_Reset : std_logic := '0';
signal input : std_logic := '0';
constant clk_period : time := 8 ps;
begin

uut: rbg_selector
PORT MAP (led5_r => led5_r, led5_g => led5_g, led5_b => led5_b, sysclk => sysclk, n_Reset => n_Reset, input => input);

sysclk <= not sysclk after clk_period/2;

gbr_sim : process
begin
    wait for 1 ns;
    n_Reset <= '1';
    wait for 2 ns;
    n_Reset <= '0';
    wait for 1 ns;
    input <= '1';
    wait for 4 ns;
    input <= '0';
    wait for 8 ns;
    input <= '1';
    wait for 4 ns;
    input <= '0';
    wait for 8 ns;
    input <= '1';
    wait for 4 ns;
    input <= '0';
    wait for 2 ns;
    input <= '1';
    wait for 3500ns;
    input <= '0';
    wait;
end process;

end Behavioral;
