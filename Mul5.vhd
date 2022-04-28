library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mul5 is
port(
	s	: out std_logic_vector(31 downto 0);
	e1	: in std_logic_vector(31 downto 0); 
	e2	: in std_logic_vector(31 downto 0); 
	sel	: in std_logic);
end Mul5;

architecture behavioural of Mul5 is
begin

with sel select
	s <= e1 when '0',
		e2 when '1',
		(others => '0') when others;
end behavioural;




