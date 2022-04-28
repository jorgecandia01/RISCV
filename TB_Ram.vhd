library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_Ram is
end TB_Ram;

architecture tb of TB_Ram is
signal	Addr :   std_logic_vector(31 downto 0);
signal	Din  :    std_logic_vector(31 downto 0);
signal	tipo_acc :   std_logic_vector(1 downto 0);
signal	l_u :    std_logic;
signal	we_ram :    std_logic;
signal	Dout :    std_logic_vector(31 downto 0);
signal	clk    :  std_logic:='0';
constant T: time := 10ns;  
begin

dut: entity work.RamGrande
port map(
	Addr => Addr,
	Din  =>  Din,
	tipo_acc => tipo_acc,
	l_u => l_u,
	we_ram => we_ram,
	Dout => Dout,
	clk    => clk);
	
clk <= not clk after T;
	
always :process 

begin

Din<="00000000000000000000000000001010";

Addr<="01100000101010000010101000001010";

tipo_acc<="10";

l_u<='0';

wait for 100 ns;

we_ram<='1';

wait for 3*T;

we_ram<='0';

---------------------------

Din<="00000000000000000000000000000000";
Addr<="00000000000000000000000000000000";

wait for 100 ns;

Addr<="01100000101010000010101000001010";


wait for 100 ns;


assert Dout="00000000000000000000000000001010"
	report "Fallo en la lectura"
		severity Failure;

assert false
	report "Fin"
		severity Failure;

end process always;
end tb;





	

	
