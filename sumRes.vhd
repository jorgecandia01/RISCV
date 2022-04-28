library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sumRes is  
	generic(
		n: integer:= 32);
	port(
		a_ext,b_ext: in std_logic_vector(n downto 0);
		ssr: out std_logic_vector(n-1 downto 0);
		s_r: in std_logic_vector(3 downto 0);
		sig: out std_logic);
end sumRes;

architecture behavioral of sumRes is
	signal salida: std_logic_vector(n downto 0);
begin
	
	process(a_ext,b_ext,s_r)
	begin
		if (s_r="1000" or s_r="1000" or s_r="0010") then
			salida<=std_logic_vector(unsigned(a_ext)-unsigned(b_ext));
		else
			salida<=std_logic_vector(unsigned(a_ext)+unsigned(b_ext));
		end if;
	end process;
	
	ssr<=salida(n-1 downto 0);
	sig<=salida(n);

end behavioral;