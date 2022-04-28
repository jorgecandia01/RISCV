library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mul1 is

	port(
	z      : in std_logic;
	lt     : in std_logic;
	ge     : in std_logic;
	ir_out : in std_logic_vector(1 downto 0);
	salida : out std_logic);
	
end Mul1;

architecture behavioural of Mul1 is
begin
with ir_out select 
	salida <= z      when "00", 
				 not(z) when "01",
				 lt     when "10",
				 ge     when "11",
				 '0'    when others;
end behavioural;
				 
				 