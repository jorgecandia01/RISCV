library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;

entity Lab4 is
generic(
n : integer := 32);
port(
	a       : in std_logic_vector(n-1 downto 0);
	b       : in std_logic_vector(n-1 downto 0);
	shamt   : in std_logic_vector(4 downto 0);
	alu_op  : in std_logic_vector(3 downto 0);
	alu_out : out std_logic_vector(n-1 downto 0);
	z       : out std_logic;
	lt      : out std_logic;
	ge      : out std_logic);
end Lab4;

architecture structural of Lab4 is
signal a_ext : std_logic_vector(n downto 0);
signal b_ext : std_logic_vector(n downto 0);
signal sig : std_logic;
signal s : std_logic_vector(n-1 downto 0); --no se todavia por que uso esta señal
signal s_sumres : std_logic_vector(n-1 downto 0);
signal ssl : std_logic_vector(n-1 downto 0);
signal ssrl : std_logic_vector(n-1 downto 0);
signal ssra : std_logic_vector(n-1 downto 0);
signal sxor : std_logic_vector(n-1 downto 0);
signal sor : std_logic_vector(n-1 downto 0);
signal sand : std_logic_vector(n-1 downto 0);
signal z_in : std_logic ;
signal slt_in : std_logic_vector(n-1 downto 0);
signal sltu_in   :  std_logic_vector(n-1 downto 0);

begin 


i1 : entity work.sumRes
generic map( 
n => n)
port map(
	a_ext => a_ext,
	b_ext => b_ext,
	ssr	=> s_sumres,
	s_r   => alu_op,
	sig=>sig);

a_ext <= a(n-1)&a when alu_op = "0010" else '0'&a;	
b_ext <= b(n-1)&b when alu_op = "0010" else '0'&b;	
	
	
ssl <= std_logic_vector(shift_left(signed(a), to_integer(unsigned(shamt))));
ssrl <= std_logic_vector(shift_right(unsigned(a), to_integer(unsigned(shamt))));
ssra <= std_logic_vector(shift_right(signed(a), to_integer(unsigned(shamt))));

sxor <= a xor b;
sor  <= a or b ;
sand <= a and b;
slt_in <= std_logic_vector(to_unsigned(0,n-1))&sig;
sltu_in <= std_logic_vector(to_unsigned(0,n-1))&sig;
	

i8 : entity work.multiplex
generic map( 
n => n)
port map(
	alu_op =>  alu_op,
	add    => s_sumres,
	sub    => s_sumres,
	slt    => slt_in,
	sltu   => sltu_in ,
	shll   => ssl,
	shrl   => ssrl,
	shra   => ssra ,
	xoor   => sxor,
	oor    => sor,
	aand   => sand,
	alu_out => alu_out);


z<= '1' when a=b else '0';
lt<=sig;
ge <= not sig;
end structural;




	