library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_BancReg is
end TB_BancReg;

architecture tb of TB_BancReg is
signal clk : std_logic :='1'; 
signal reset_n : std_logic;
signal AddrA : std_logic_vector(4 downto 0);
signal AddrB : std_logic_vector(4 downto 0);
signal AddrW : std_logic_vector(4 downto 0);
signal D_in : std_logic_vector(31 downto 0);
signal RegA : std_logic_vector(31 downto 0);
signal RegB : std_logic_vector(31 downto 0);
signal En : std_logic;
constant T: time := 10ns;  

begin

dut: entity work.BancoReg
port map(
clk => clk,
reset_n => reset_n,
AddrA => AddrA,
AddrB => AddrB,
AddrW => AddrW,
D_in => D_in,
RegA => RegA,
RegB => RegB,
En => En
);

--clk <= not clk after 10ns;
clk <= not clk after T/2;

p_stim : process
begin

reset_n <= '0';
wait for 500ns;
reset_n <= '1';

AddrA <= "00110"; --registro 6
wait for T;

--assert AddrA = "00000"
--report "Fallo en la lectura"
--severity Failure;

wait for T;

AddrW <= "00110";
D_in <= "00000000000000000000000000001010";
En <= '1';

wait for 5*T;

En <= '0';

AddrA <= "00110";
wait for T;

--assert AddrA = "00110"
assert RegA = "00000000000000000000000000001010"
report "Fallo en la lectura"
severity Failure;

assert false
report "Fin"
severity Failure;

end process p_stim;
end tb;