library ieee;
use ieee. std_logic_1164 .all;
use ieee. numeric_std .all;

entity Ram is
port (
	clk : in std_logic ;
	d_in : in std_logic_vector (7 downto 0);
	Addr : in std_logic_vector (9 downto 0);
	we : in std_logic ; -- Write enable
	d_out : out std_logic_vector (7 downto 0));
end Ram;

architecture rtl of Ram is
type mem_t is array(0 to 1023) of std_logic_vector (7 downto 0);
signal ram_block : mem_t;
begin
process (clk)
begin
if (clk'event and clk = '1') then
	if (we = '1') then
		ram_block ( to_integer (unsigned(Addr ))) <= d_in;
   else
		d_out <= ram_block ( to_integer (unsigned(Addr )));
end if;
end if;
end process;
end rtl;