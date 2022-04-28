library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;

entity multiplex is
generic(
n : integer := 32);
port(
	alu_op :  in std_logic_vector(3 downto 0);
	add    :  in std_logic_vector(n-1 downto 0);
	sub    :  in std_logic_vector(n-1 downto 0);
	slt    :  in std_logic_vector(n-1 downto 0);
	sltu   :  in std_logic_vector(n-1 downto 0);
	shll   :  in std_logic_vector(n-1 downto 0);
	shrl   :  in std_logic_vector(n-1 downto 0);
	shra   :  in std_logic_vector(n-1 downto 0);
	xoor   :  in std_logic_vector(n-1 downto 0);
	oor    :  in std_logic_vector(n-1 downto 0);
	aand   :  in std_logic_vector(n-1 downto 0);
	alu_out : out std_logic_vector(n-1 downto 0));

end multiplex;

architecture behavioural of multiplex is

begin

with alu_op select
	alu_out<=add when "0000",
	         sub when "1000",
				slt when "0010",
				sltu when "0011",
				shll when "0001",
				shrl when "0101",
				shra when "1101",
				xoor when "0100",
				oor when  "0110",
				aand when "0111",
				add when others;
end behavioural;
