
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_Lab5 is
end TB_Lab5;

architecture tb of TB_Lab5 is
signal clk : std_logic:='0'; 
signal reset_n : std_logic;
constant T: time := 10ns;  


begin

dut: entity work.Lab5
port map(
clk => clk,
reset_n => reset_n);

clk <= not clk after T;

p_stim : process
begin

reset_n <= '0';
wait for 50ns;
reset_n <= '1';

wait for 400*T;--para 41 lineas

assert false
report "Fin"
severity Failure;



end process p_stim;
end tb;
