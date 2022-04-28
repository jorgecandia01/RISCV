library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BancoReg is
port(
	clk     : in std_logic;
	reset_n : in std_logic;
	AddrA   : in std_logic_vector(4 downto 0);
	AddrB   : in std_logic_vector(4 downto 0);
	AddrW   : in std_logic_vector(4 downto 0);
	D_in    : in std_logic_vector(31 downto 0);
	En      : in std_logic;
   RegA    : out std_logic_vector(31 downto 0);
	RegB    : out std_logic_vector(31 downto 0));
end BancoReg;

architecture behavioural of BancoReg is
	type reg is array (0 to 31) of std_logic_vector(31 downto 0);
	signal  registro : reg;
begin

regis:process(clk,reset_n)
begin
	if reset_n='0' then
			registro <= (others => (others => '0'));
	elsif clk'event and clk='1' then
		if En = '1' then --En = '1' es escritura
			registro(to_integer(unsigned(AddrW)))<=D_in;
	end if;
	end if;
end process;

RegA <= registro(to_integer(unsigned(AddrA)));
RegB <= registro(to_integer(unsigned(AddrB)));

end behavioural;
