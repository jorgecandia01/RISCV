library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mul3 is
port(
	e1	: in std_logic_vector(31 downto 0);
	e2	: in std_logic_vector(31 downto 0); 
	e3	: in std_logic_vector(31 downto 0); 
	sel	: in std_logic_vector(1 downto 0); 
	s	: out  std_logic_vector(31 downto 0));
	end Mul3;

architecture behavioural of Mul3 is
begin

with sel select
	s <= e1 when "00",
		e2 when "01",
		e3 when "10",
		(others => '0') when others;
end behavioural;
