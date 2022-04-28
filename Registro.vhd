 -- Registro de 4 bits con habilitaci ón de la carga

library ieee;
use ieee. std_logic_1164 .all;

entity Registro is

port (
	clk : in std_logic ; -- Entradas de control
	reset_n : in std_logic ;
	en : in std_logic ; -- Habilitaci ón carga
	e : in std_logic_vector (31 downto 0); -- datos
	s : out std_logic_vector (31 downto 0));
end Registro ;

architecture behavioral of Registro is

begin -- behavioral

process(clk , reset_n)
begin
	if reset_n = '0' then
		s <= (others => '0');
	elsif clk'event and clk = '1' then
		if en = '1' then
			s <= e;
		end if;
	end if;
end process;

end behavioral ;
